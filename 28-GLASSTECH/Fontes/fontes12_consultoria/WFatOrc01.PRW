#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function WFatOrc01
	Esta função tem como objetivo alterar o numero de parcelas no orçamento de vendas
	@type  Function
	@author Douglas Silva | WikiTec
	@since 23/09/2021
	@version 1.0
	/*/

User Function WFatOrc01()

	Local aArea		:= GetArea() as array

	Local lLibPv	:= .F. as logic
	Local lShowPV 	:= SuperGetMv("MV_FATTEPO",,.T.) as logic
	Local lGerouPV	:= .F. as logic

	Private aHeadC6	:= {} as array
	Private aHeadD4	:= {} as array

	If SuperGetMV("MV_ORCSLIB",,.F.)
		Pergunte("MTA410",.F.)
		lLibPV := MV_PAR01==1
	EndIf

	Pergunte("MTA416",.F.)

	aHeadC6 := {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC6",.T.)
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
		If (  ((X3Uso(SX3->X3_USADO) .And. ;
				!( Trim(SX3->X3_CAMPO) == "C6_NUM" ) .And.;
				Trim(SX3->X3_CAMPO) != "C6_QTDEMP"  .And.;
				Trim(SX3->X3_CAMPO) != "C6_QTDENT") .And.;
				cNivel >= SX3->X3_NIVEL) .Or.;
				Trim(SX3->X3_CAMPO)=="C6_NUMORC" .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_NUMOP"  .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_ITEMOP" .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_OP" .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_OPC" )	
			Aadd(aHeadC6,{TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				If(Trim(SX3->X3_CAMPO)=="C6_NUMORC",".F.",SX3->X3_VALID),;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	// Monta aHeader do SD4
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SD4")
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SD4" )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			Aadd(aHeadD4,{ Trim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT })
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo

	lGerouPV := FwMsgRun( , {|| MaBxOrc(SCJ->CJ_NUM,MV_PAR01==1,MV_PAR02==1,MV_PAR03==1,lShowPV,aHeadC6,aHeadD4,lLibPV) .AND. VerGerouPV(SCJ->CJ_NUM)},;
						 "Aguarde",;
						 "Efetivando pedido..." )

	If lGerouPV

		//Grava numero do pedido orçamento
		RecLock("SCJ", .F.)		
			SCJ->CJ_XPEDIDO := SC5->C5_NUM
		MsUnLock() //Confirma e finaliza a operação
		
		MsgInfo("Atenção: Pedido de venda: " + SC5->C5_NUM + " Gerado com Sucesso Orçamento: " + SCJ->CJ_NUM)
	Else
		MsgStop("Atenção: Pedido de venda não gerado para o Orçamento: " + SCJ->CJ_NUM + ". Processo cancelado pelo usuário")
	EndIf

	RestArea(aArea)

Return 

/*/{Protheus.doc} VerGerouPV
	(Verifica se gerou ou nao o pedido a partir dos itens do orcamento)
	@type Static Function
	@author user
	@since 25/10/2021
	@version version
	@param cNumOrc, character, (Numero do orcamento a ser consultado)
	@return lPVGerado, logic, (.T. - pedido gerado / .F. - pedido nao gerado)
	@example
	(examples)
	@see (links_or_references)
	/*/

Static Function VerGerouPV(cNumOrc)

Local lPVGerado		:= .T. as logic

Local aAreas		:= {SCJ->(GetArea()), SCK->(GetArea()), GetArea()} as array

SCK->(DbEval({|| lPVGerado := !Empty(SCK->CK_NUMPV)},, {|| SCK->(CK_FILIAL+CK_NUM) == xFilial("SCK")+cNumOrc},,,.T.))

AEval(aAreas, {|x| RestArea(x) })

Return lPVGerado
