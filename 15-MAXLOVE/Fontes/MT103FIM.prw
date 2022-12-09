// #########################################################################################
// Projeto: MAXLOVE
// Modulo : SIGAEST
// Fonte  : MT103FIM
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 20/05/17 | Sergio Compain    | Ponto de entrada nas notas de entrada para geracao dos vales de Entradas
// ---------+-------------------+-----------------------------------------------------------



#INCLUDE "PROTHEUS.CH"

User Function MT103FIM()

Local nRotina 	:= paramixb[1]  //3=Incluir 4=Classificar 5=Excluir
Local nOpca   	:= paramixb[2]  //1= Ok
Local aAreaAtu 	:= getarea()
Local aAreaSF1 	:= SF1->(getarea())
Local aAreaSD1 	:= SD1->(getarea())
Private lMsErroAuto := .f.

If nOpca = 1 .and. (nRotina = 3 .or. nRotina = 4) .and. cTipo = "N"
	GeraVale()
ElseIf nOpca = 1 .and. nRotina = 5 .and. cTipo = "N"
	DeleVale()
EndIf

If INCLUI
	dbSelectArea("SD1")
	dbSetOrder(1)
	If dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.F.)
		While Eof() == .f. .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			
			If SD1->D1_X_AMOST$"S"
				
				Begin Transaction
				ExpA1 := {}
				aadd(ExpA1,{"D3_FILIAL",xFilial("SD3"),})
				aadd(ExpA1,{"D3_TM","505",})
				aadd(ExpA1,{"D3_COD",SD1->D1_COD,})
				aadd(ExpA1,{"D3_UM",SD1->D1_UM,})
				aadd(ExpA1,{"D3_LOCAL",SD1->D1_LOCAL,})
				aadd(ExpA1,{"D3_LOTECTL",SD1->D1_LOTECTL,})
				aadd(ExpA1,{"D3_DTVALID",SD1->D1_DTVALID,})
				aadd(ExpA1,{"D3_QUANT",2,})
				aadd(ExpA1,{"D3_EMISSAO",dDataBase,})
				
				MSExecAuto({|x,y| mata240(x,y)},ExpA1,3)
				If !lMsErroAuto
					ConOut("Incluido com sucesso! ")
				Else
					ConOut("Erro na inclusao!")
				EndIf
				
				ConOut("Fim  : "+Time())
				
				End Transaction
			EndIf
			
			dbSelectArea("SD1")
			dbSkip()
		EndDo
	EndIf
EndIf

RestArea(aAreaSF1)
RestArea(aAreaSD1)
RestArea(aAreaAtu)

Return()

Static Function GeraVale()

Local nTamPrf	:= TamSx3("E2_PREFIXO")[1]
Local nTamNum	:= TamSx3("E2_NUM")[1]
Local nTamParc	:= TamSx3("E2_PARCELA")[1]
Local nTamTipo	:= TamSx3("E2_TIPO")[1]
Local nTamNat	:= TamSx3("E2_NATUREZ")[1]
Local cParc		:= ""
Local cNat 		:= "000053" //diversos
Local cPrf 		:= "VL"
Local cTpNf		:= "VL"
Local nVlrVl	:= VerVlrVl()
Local aParc		:= {}
Local aTit		:= {}

If nVlrVl <> 0
	
	aParc	:= Condicao(nVlrVl,cCondicao,,dDataBase)
	cParc	:= IIF(Len(aParc)>1,SuperGetMV("MV_1DUP   ")," ")
	
	
	For nP := 1 to len(aParc)
		
		aTit := {}
		AADD(aTit , {"E2_NUM"			,PadR(cNFiscal,nTamNum)	,NIL})
		AADD(aTit , {"E2_PREFIXO"		,PadR(cPrf,nTamPrf)		,NIL})
		AADD(aTit , {"E2_PARCELA"		,cParc					,NIL})
		AADD(aTit , {"E2_TIPO"			,PadR(cTpNf,nTamTipo)	,NIL})
		AADD(aTit , {"E2_NATUREZ"		,PadR(cNat,nTamNat)		,NIL})
		AADD(aTit , {"E2_FORNECE"		,cA100For				,NIL})
		AADD(aTit , {"E2_LOJA"			,cLoja					,NIL})
		AADD(aTit , {"E2_EMISSAO"		,Ddatabase				,NIL})
		AADD(aTit , {"E2_VENCTO"		,aParc[nP][1]			,NIL})
		AADD(aTit , {"E2_VENCREA"		,DataValida(aParc[nP][1],.T.)	,NIL})
		AADD(aTit , {"E2_EMIS1"			,Ddatabase				,NIL})
		AADD(aTit , {"E2_VALOR"			,aParc[nP][2]			,NIL})
		AADD(aTit , {"E2_ORIGEM"		,"VALENF"				,NIL})
		AADD(aTit , {"E2_HIST"			,"VALE_NF :" + Alltrim(cNFiscal) +" - "+AllTrim(cSerie), Nil})
		
		lMsErroAuto 	:= .F.
		MSExecAuto({|x, y| FINA050(x, y)}, aTit, 3)
		
		If lMsErroAuto
			MostraErro()
			Exit
		Else
			cParc := MaParcela(cParc)
		EndIf
		
	Next nP
EndIf

Return()

Static Function DeleVale()

Local nTamPrf	:= TamSx3("E2_PREFIXO")[1]
Local cPrf 		:= "VL"

dbSelectArea("SE2")
dbSetOrder(6)   //E2_FILIAL, E2_FORNECE, E2_LOJA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO
If dbSeek(xFilial("SE2")+cA100For+cLoja+PadR(cPrf,nTamPrf)+cNFiscal)
	While !eof() .and. SE2->E2_FORNECE = cA100For .AND. SE2->E2_LOJA = cLoja .AND. SE2->E2_PREFIXO = PadR(cPrf,nTamPrf) .AND. SE2->E2_NUM = cNFiscal
		If Empty(SE2->E2_BAIXA)
			RecLock("SE2",.F.)
			DbDelete()
			MsUnLock("SE2")
		EndIf
		dBSelectArea("SE2")
		dBSkip()
	Enddo
EndIf

Return()


Static Function VerVlrVl()

Local cQuery := ""
Local nValor	:= 0
Local nImposto	:= 0

cQuery := " SELECT SUM((D1_QUANT * ((CASE WHEN ISNULL(AIB_PRCCOM,0) = 0 THEN D1_VUNIT ELSE ISNULL(AIB_PRCCOM,0) END) - D1_VUNIT))-D1_VALDESC) PRCVL "
cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
cQuery += " INNER JOIN "+RetSqlName("SF4")+" SF4 ON F4_CODIGO = D1_TES AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN "+RetSqlName("AIB")+" AIB ON AIB_CODFOR = D1_FORNECE AND AIB_LOJFOR = D1_LOJA AND AIB_CODPRO = D1_COD AND AIB_CODTAB = 'VL' AND AIB.D_E_L_E_T_ = '' "
cQuery += " WHERE D1_DOC = '"+cNFiscal+"' "
cQuery += " AND D1_SERIE = '"+cSerie+"' "
cQuery += " AND D1_FORNECE = '"+cA100For+"' "
cQuery += " AND D1_LOJA = '"+cLoja+"' "
cQuery += " AND D1_TIPO = 'N'
cQuery += " AND SD1.D_E_L_E_T_ = ''
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBTMP", .F., .T.)
dbSelectArea( "TRBTMP" )

While TRBTMP->(!Eof())
	
	nValor := TRBTMP->PRCVL
	
	dbSelectArea("TRBTMP")
	TRBTMP->(dbSkip())
	
End

IF Select("TRBTMP") <> 0
	DbSelectArea("TRBTMP")
	DbCloseArea()
ENDIF

If !cA100For$"000606/000645/000655/000714/001001/001012/001041"
	cQuery := " SELECT SUM(D1_ICMSRET+D1_VALIPI) IMPOSTO "
	cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += " INNER JOIN "+RetSqlName("SF4")+" SF4 ON F4_CODIGO = D1_TES AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN "+RetSqlName("AIB")+" AIB ON AIB_CODFOR = D1_FORNECE AND AIB_LOJFOR = D1_LOJA AND AIB_CODPRO = D1_COD AND AIB_CODTAB = 'VL' AND AIB.D_E_L_E_T_ = '' "
	cQuery += " WHERE D1_DOC = '"+cNFiscal+"' "
	cQuery += " AND D1_SERIE = '"+cSerie+"' "
	cQuery += " AND D1_FORNECE = '"+cA100For+"' "
	cQuery += " AND D1_LOJA = '"+cLoja+"' "
	cQuery += " AND D1_TIPO = 'N'
	cQuery += " AND SD1.D_E_L_E_T_ = ''
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBTMPX", .F., .T.)
	dbSelectArea( "TRBTMPX" )

	While TRBTMPX->(!Eof())
		
		nImposto := TRBTMPX->IMPOSTO
		
		dbSelectArea("TRBTMPX")
		TRBTMPX->(dbSkip())
		
	End

	IF Select("TRBTMPX") <> 0
		DbSelectArea("TRBTMPX")
		DbCloseArea()
	ENDIF


EndIf

Return(nValor-nImposto)
