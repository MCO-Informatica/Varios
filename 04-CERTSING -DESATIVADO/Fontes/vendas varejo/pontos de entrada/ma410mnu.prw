#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MA410MNU

Pronto de entrada executado ao acessar a tela de manutenção de cadastros de pedidos de vendas.
Desta forma o ponto de entrada é usado para inserir novas opções para a tela de pedido de vendas

@author Totvs SM - David
@since 10/03/2014
@version P11
/*/
User Function MA410MNU()
	Local nI		:= 0
	Local aRotAux	:= {}

	For nI := 1 To Len(aRotina)
		Do Case
			Case ValType(aRotina[nI][2]) == "C" .AND. AllTrim(Upper(aRotina[nI][2])) == "A410ALTERA"
			Aadd( aRotAux, {aRotina[nI][1], "U_XA410ALT", aRotina[nI][3], aRotina[nI][4], aRotina[nI][5], aRotina[nI][6]} )

			Case ValType(aRotina[nI][2]) == "C" .AND. AllTrim(Upper(aRotina[nI][2])) == "A410DEVOL"
			Aadd( aRotAux, {aRotina[nI][1], "U_XA410DEV", aRotina[nI][3], aRotina[nI][4], aRotina[nI][5], aRotina[nI][6]} )

			Case ValType(aRotina[nI][2]) == "C" .AND. AllTrim(Upper(aRotina[nI][2])) == "MA410PVNFS"
			Loop

			Case ValType(aRotina[nI][2]) == "C" .AND. AllTrim(Upper(aRotina[nI][2])) == "A410PCOPIA"
			Loop

			Case ValType(aRotina[nI][2]) == "A" .AND. AllTrim(Upper(aRotina[nI][1])) == "EXCLUIR"
			Aadd( aRotAux, {aRotina[nI][1], "U_XA410DEL", aRotina[nI][3], aRotina[nI][4], aRotina[nI][5], aRotina[nI][6]} )

			Case ValType(aRotina[nI][2]) == "A" .AND. AllTrim(Upper(aRotina[nI][1])) == "COD.BARRA"
			Loop

			OtherWise
			Aadd( aRotAux, {aRotina[nI][1], aRotina[nI][2], aRotina[nI][3], aRotina[nI][4], aRotina[nI][5], aRotina[nI][6]} )
		Endcase
	Next nI

	Aadd( aRotAux, {"Lib.Pg.Ped."	, "U_XA410HRD", 0, 2, 0, NIL} )
	Aadd( aRotAux, {"Conf.Pg."		, "U_XA410GAR", 0, 2, 0, NIL} )
	Aadd( aRotAux, {"Can.Ped.Site"	, "U_XA410CAN", 0, 2, 0, NIL} )
	Aadd( aRotAux, {"Alt.Gestao"	, "U_CSGCT010", 0, 2, 0, NIL} )

	aRotina := Aclone( aRotAux )
Return(.T.)

/*/{Protheus.doc} XA410DEV

Rotina referente a execução da devolução de itens

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
User Function XA410DEV(cAlias,nReg,nOpc)
	If !Empty(SC5->C5_CHVBPAG)
		// Prende o lock do processo deste item
		If !U_GarLock(SC5->C5_CHVBPAG)
			MsgStop("Pedido em manutenção por ou outro usuário ou processo...")
			Return(.F.)
		Endif
	Endif

	A410DEVOL(cAlias,nReg,nOpc)

	If !Empty(SC5->C5_CHVBPAG)
		// Solta o lock do processo deste item
		U_GarUnLock(SC5->C5_CHVBPAG)
	Endif
Return(.T.)

/*/{Protheus.doc} XA410ALT

Rotina referente a execução da alteração de pedido de vendas personalizada

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
User Function XA410ALT(cAlias,nReg,nOpc)
	If !Empty(SC5->C5_CHVBPAG)
		// Prende o lock do processo deste item
		If !U_GarLock(SC5->C5_CHVBPAG)
			MsgStop("Pedido em manutenção por ou outro usuário ou processo...")
			Return(.F.)
		Endif
	Endif

	A410ALTERA(cAlias,nReg,nOpc)

	If !Empty(SC5->C5_CHVBPAG)
		// Solta o lock do processo deste item
		U_GarUnLock(SC5->C5_CHVBPAG)
	Endif
Return(.T.)

/*/{Protheus.doc} XA410DEL

Rotina referente a execução da exclusão de pedidos de vendas personalizado

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
User Function XA410DEL(cAlias,nReg,nOpc)
	If !Empty(SC5->C5_CHVBPAG)
		// Prende o lock do processo deste item
		If !U_GarLock(SC5->C5_CHVBPAG)
			MsgStop("Pedido em manutenção por ou outro usuário ou processo...")
			Return(.F.)
		Endif
	Endif

	A410DELETA(cAlias,nReg,nOpc)

	If !Empty(SC5->C5_CHVBPAG)
		// Solta o lock do processo deste item
		U_GarUnLock(SC5->C5_CHVBPAG)
	Endif
Return(.T.)

/*/{Protheus.doc} XA410HRD

Rotina sera utilizado o tratametno identificação de pagamento de hardware avuslo

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
User Function X410PAG(cAlias,nReg,nOpc,cMsgIncide)
	Local cJobEmp		:= '01'
	Local cJobFil		:= '02'


	RpcSetType( 3 )
	RpcSetEnv( cJobEmp, cJobFil )

	dbSelectArea("SC5")
	SC5->( dbGoto(nReg) )
	CONOUT('[X410PAG] INICIO - PEDIDO : ' + SC5->C5_NUM + ' | ' + TIME())
	U_XA410HRD( 'SC5', SC5->( Recno() ), 2, cMsgIncide )
	CONOUT('[X410PAG] FIM    - PEDIDO : ' + SC5->C5_NUM + ' | ' + TIME())
Return

User Function XA410HRD(cAlias,nReg,nOpc,cMsgIncide)
	Local aArea 		:= GetArea() 	
	Local nRecC5		:= 0
	Local cSql			:= ""
	Local cCategoSFW	:= GetNewPar("MV_GARSFT", "2")
	Local cCategoHRD	:= GetNewPar("MV_GARHRD", "1")
	Local lSfw			:= .f.
	Local lHrd			:= .f.
	Local cMsgErr		:= ""
	Local cMsgAvi		:= ""
	Local lWaitFat		:= GetNewPar("MV_XWAITFT", .T.)
	Local cOperNPF		:= GetNewPar("MV_XOPENPF", "61,62")
	Local cOperProd		:= ""
	Local cOperSoft		:= ""
	Local aRet			:= {}
	Local cUserLib := Iif( Empty(cUserName), 'Pelo Financeiro', 'Por ' + cUserName )

	Private cMsgJOB		:= ''
	Default cMsgIncide	:= ""

	cMsgJOB := cMsgIncide

	If Empty(SC5->C5_XNPSITE)    
		MsgStop("Pedido não se Refere a Compra Via Site")
		Return(.F.)
	EndIf  

	If SC5->C5_TIPMOV =="2"  .and. Empty(SC5->C5_XCODAUT)
		MsgStop("Pedido referente a compra com Cartão nâo Autorizado. A operação não é permitida.")
		Return(.F.)
	EndIf  

	//Verifica se o Pedido contem produtos de Software
	cSql			:= "SELECT "
	cSql			+= "  C6_XOPER "
	cSql			+= "FROM "
	cSql			+= "  "+RetSqlName("SC6")+" C6 INNER JOIN "+RetSqlName("SB1")+" B1 ON "
	cSql			+= "    C6_PRODUTO = B1_COD "
	cSql			+= "WHERE "
	cSql			+= "  C6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
	cSql			+= "  C6.C6_NUM = '"+SC5->C5_NUM+"' AND "
	cSql			+= "  C6.D_E_L_E_T_ = ' ' AND "
	cSql			+= "  B1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
	cSql			+= "  B1.B1_CATEGO = '"+cCategoSFW+"' AND "
	cSql			+= "  B1.D_E_L_E_T_ = ' ' "     

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TRBSC6",.F.,.T.)

	lSfw 		:= !TRBSC6->(EoF())
	If lSfw
		cOperSoft	:= TRBSC6->C6_XOPER
	Endif

	TRBSC6->(DbCloseArea())

	//Verifica se Pedido tem Produto Hardware
	cSql			:= "SELECT "
	cSql			+= "  C6_XOPER "
	cSql			+= "FROM "
	cSql			+= "  "+RetSqlName("SC6")+" C6 INNER JOIN "+RetSqlName("SB1")+" B1 ON "
	cSql			+= "    C6_PRODUTO = B1_COD "
	cSql			+= "WHERE "
	cSql			+= "  C6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
	cSql			+= "  C6.C6_NUM = '"+SC5->C5_NUM+"' AND "
	cSql			+= "  C6.D_E_L_E_T_ = ' ' AND "
	cSql			+= "  B1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
	cSql			+= "  B1.B1_CATEGO = '"+cCategoHRD+"' AND "
	cSql			+= "  B1.D_E_L_E_T_ = ' ' "     

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TRBSC6",.F.,.T.)

	lHrd := !TRBSC6->(EoF())

	If lHrd
		cOperProd	:= TRBSC6->C6_XOPER
	Endif

	TRBSC6->(DbCloseArea())


	If cOperProd $ cOperNPF .or. cOperSoft $ cOperNPF 
		If !Empty(SC5->C5_XRECPG)
			cMsgErr += "Recibo de pagamento referente a compra ja gerado"+CRLF
		Else
			If (!Empty(SC5->C5_CHVBPAG) .or. (SC5->C5_XORIGPV >= "7" .and. !Empty(SC5->C5_XPEDORI))) .and. U_XA410GAR(cMsgJOB)
				cMsgAvi += "Solicitação de liberação enviada ao Destino"+CRLF
				aRet:= u_csfa520(SC5->C5_NUM,"L")

				If aRet[1]
					Reclock('SC5',.F.)
					SC5->C5_XRECPG	:= aRet[2]
					SC5->C5_XFLAGEN := Space(TamSX3("C5_XFLAGEN")[1]) 
					Msunlock() 
					cMsgAvi += "Notificação de liberação enviada ao Cliente"+CRLF
				Else
					cMsgAvi += "Notificação de liberação com inconsistências"+CRLF
					cMsgAvi += aRet[2]+CRLF
				EndIf
			ElseIf Empty(SC5->C5_CHVBPAG)
				//Gera Liberação de Pedido
				aRet:= u_csfa520(SC5->C5_NUM,"L")

				If aRet[1]
					Reclock('SC5',.F.)
					SC5->C5_XRECPG	:= aRet[2]
					SC5->C5_XFLAGEN := Space(TamSX3("C5_XFLAGEN")[1]) 
					Msunlock() 
					cMsgAvi += "Notificação de liberação enviado com sucesso"+CRLF
				Else
					cMsgErr += "Notificação de liberação com inconsistências"+CRLF
					cMsgErr += aRet[2]+CRLF
				EndIf
			Else
				cMsgErr	:= "Nã foi possivel Liberar o pedido"
			Endif
		EndIf

		If !Empty(cMsgErr)
			Aviso( "Atencao !", cMsgErr , { "OK" } )
			Return(.F.)
		EndIf

		Reclock('SC5',.F.)
		xObs:=SC5->C5_XOBS
		SC5->C5_XOBS	:= IiF( Empty( cMsgIncide ), "*** Liberado manualmente "+cUserLib, "*** " + cMsgIncide ) + " em "+DtoC(Date())+"-"+Time()+" ***"+chr(13)+chr(10)+xObs
		Msunlock() 

	Else

		If SC5->C5_TPCARGA <> "1" 
			If lHrd .and. !Empty(SC5->C5_XNFHRD) .and. lSfw .and. !Empty(SC5->C5_XNFSFW)	
				cMsgErr += "Todas as Notas Fiscais Referente a Venda Ja Gerada"+CRLF
			ElseIf lHrd .and. !lSfw .and. !Empty(SC5->C5_XNFHRD)
				cMsgErr += "Nota Fiscal Referente ao Hardware Ja Gerada"+CRLF
			ElseIf !lHrd .and. lSfw .and. !Empty(SC5->C5_XNFSFW)
				cMsgErr += "Nota Fiscal Referente ao Software Ja Gerada"+CRLF	 
			EndIf

			If !Empty(cMsgErr)
				Aviso( "Atencao !", cMsgErr , { "OK" } )
				Return(.F.)
			EndIf

			nRecC5 := SC5->(Recno()) 

			Reclock('SC5',.F.)
			xObs:=SC5->C5_XOBS
			SC5->C5_XOBS	:= "*** Liberado e faturado "+cUserLib+" em "+DtoC(Date())+"-"+Time()+" ***"+chr(13)+chr(10)+xObs
			Msunlock() 

			If !Empty(SC5->C5_CHVBPAG) .or. (SC5->C5_XORIGPV == "7" .and. !Empty(SC5->C5_XPEDORI) )
				U_XA410GAR(cMsgJOB)
			EndIf                                                                                   

			lFat		:= .T.  //Na liberação manual apenas fatura 
			lServ 		:= .T.                                                           
			lProd		:= .T.
			lEnt		:= .F.
			lRecPgto	:= .F.  //Na liberação manual Não gera recibo no VNDA190 
			lGerTitRecb	:= .F.  //Na liberação manual Não gera título para recibo no VNDA190 

			IF .NOT. SC5->C5_XORIGPV == 'C' //EMISSAO CARTEIRA NÃO FATURA
				Processa( {|| StartJob("U_VNDA190P",GetEnvServer(),lWaitFat,cEmpAnt,cFilAnt,nRecC5,lFat,lProd,lServ,lEnt,lRecPgto,lGerTitRecb) }, "Gerando Nota de Venda de Hardware...")
			EndIF

			//Gera um PDF de informando a liberação do pedido
			aRet := u_csfa520(SC5->C5_NUM,"L")

			If aRet[1] 
				cRecPgto	:= aRet[2]
				If !Empty(cRecPgto)
					RecLock("SC5", .F.)
					Replace SC5->C5_XRECPG With cRecPgto
					Replace SC5->C5_XFLAGEN With Space(TamSX3("C5_XFLAGEN")[1]) 
					SC5->(MsUnLock())
				Endif
			EndIf

			SC5->(DbGoTo(nRecC5))

			IF lWaitFat

				If lHrd .and. !Empty(SC5->C5_XNFHRD) .and. lSfw .and. !Empty(SC5->C5_XNFSFW)	
					cMsgAvi += "Todas as Notas Fiscais Referente a Venda Geradas com Sucesso"+CRLF
				ElseIf lHrd .and. lSfw .and. (Empty(SC5->C5_XNFHRD) .or. Empty(SC5->C5_XNFSFW))
					cMsgErr += "Inconsistência ao Gerar PDF das Notas de Hardware ou Software"+CRLF	
				ElseIf lHrd .and. !lSfw .and. !Empty(SC5->C5_XNFHRD)
					cMsgAvi += "Nota Fiscal Referente ao Hardware Gerada com Sucesso"+CRLF
				ElseIf lHrd .and. !lSfw .and. Empty(SC5->C5_XNFHRD)
					cMsgErr += "Inconsistência ao Gerar PDF da Nota de Hardware"+CRLF
				ElseIf !lHrd .and. lSfw .and. !Empty(SC5->C5_XNFSFW)
					cMsgAvi += "Nota Fiscal Referente ao Software Gerada com Sucesso"+CRLF	 
				ElseIf !lHrd .and. lSfw .and. Empty(SC5->C5_XNFSFW)
					cMsgErr += "Inconsistência ao Gerar PDF da Nota de Software"+CRLF
				EndIf 

				If !Empty(cMsgErr)
					Aviso( "Atencao !", cMsgErr , { "OK" } )
					Return(.F.)
				EndIf
			Endif	
		ElseIf SC5->C5_TPCARGA == "1"
			cMsgAvi += "Compra referente a Delivery notas fiscais devem ser geradas junto com a Carga."+CRLF

			nRecC5 := SC5->(Recno())
			lFat		:= .T.  //Na liberação manual apenas fatura 
			lServ 		:= .F.                                                           
			lProd		:= .T.
			lEnt		:= .F.
			lRecPgto	:= .F.  //Na liberação manual Não gera recibo no VNDA190 
			lGerTitRecb	:= .F.  //Na liberação manual Não gera título para recibo no VNDA190 

			IF .NOT. SC5->C5_XORIGPV == 'C' //EMISSAO CARTEIRA NÃO FATURA
				Processa( {|| StartJob("U_VNDA190P",GetEnvServer(),lWaitFat,cEmpAnt,cFilAnt,nRecC5,lFat,lProd,lServ,lEnt,lRecPgto,lGerTitRecb) }, "Gerando Nota de Venda de Hardware...")
			EndIF

			//Gera um PDF de informando a liberação do pedido
			aRet := u_csfa520(SC5->C5_NUM,"L")

			If aRet[1] 
				cRecPgto	:= aRet[2]
				If !Empty(cRecPgto)
					RecLock("SC5", .F.)
					Replace SC5->C5_XRECPG With cRecPgto
					Replace SC5->C5_XFLAGEN With Space(TamSX3("C5_XFLAGEN")[1]) 
					SC5->(MsUnLock())
				Endif
			EndIf
		EndIf

	EndIf

	If !Empty(cMsgAvi)
		Aviso( "Aviso", cMsgAvi , { "OK" } )
	EndIf

	RestArea(aArea)
Return(.T.)

/*/{Protheus.doc} XA410GAR

Funcao executada pelo ponto de entrada onde serah utilizado o tratametno identificação de pagamento de vendas Varejo e liberação do Pedido para Validação

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/

//XA410GAR(cAlias,nReg,nOpc,cMsgIncide)
User Function XA410GAR(cMsgJOB)
	Local aArea := GetArea() 	
	Local nRecC5:= 0
	Local cUserLib := Iif( Empty(cUserName), 'Pelo Financeiro', 'Por ' + cUserName )
	Local cMV_A410GAR := 'MV_A410GAR'
	
	Default cMsgJOB	:= ""
	

	If .NOT. GetMv( cMV_A410GAR, .T. )
		CriarSX6( cMV_A410GAR, 'C', 'USUARIO AUTORIZADO PARA LIBERAR PEDIDO MANUAL MA410MNU.PRW', '000000' )
	Endif

	cMV_A410GAR := GetMv( cMV_A410GAR, .F. )

	If SC5->C5_TIPMOV =="2"  .and. Empty(SC5->C5_XCODAUT)
		MsgStop("Pedido referente a compra com Cartão nâo Autorizado. A operação não é permitida.")
		Return(.F.)
	EndIf  

	If (SC5->C5_XORIGPV < "7" .AND. Empty(SC5->C5_CHVBPAG)) .or. (SC5->C5_XORIGPV >= "7" .and. Empty(SC5->C5_XPEDORI))
		IF .NOT. __cUserID $ cMV_A410GAR .AND. !IsBlind()
			HS_MsgInf("Pedido Não necessita ser Liberado para pagamento na origem" + CRLF +;
			"Solicite acesso para o parâmetros 'MV_A410GAR'","Atenção","[XA410GAR] Confirmação de pagamento")
			Return(.F.)
		EndIF
	EndIf  

	nRecC5 := SC5->(Recno()) 

	If IsBlind()
		CONOUT('ENTREI NO ISBLIND DO MA410MNU '+SC5->C5_CHVBPAG+' '+SC5->C5_XNPSITE)
		U_VNDA481( {SC5->(Recno())}, nil, NIL )
		CONOUT('SAI DO ISBLIND DO MA410MNU '+SC5->C5_CHVBPAG+' '+SC5->C5_XNPSITE)
	Else
		CONOUT('ENTREI SEM O ISBLIND DO MA410MNU '+SC5->C5_CHVBPAG+' '+SC5->C5_XNPSITE)
		MsgRun("Enviando Informações ao HUB ...","Aguarde ...",{||U_VNDA481({SC5->(Recno())},nil,NIL ) } )
		CONOUT('SAI SEM O ISBLIND DO MA410MNU '+SC5->C5_CHVBPAG+' '+SC5->C5_XNPSITE)
	Endif

	SC5->(DbGoTo(nRecC5))

	IF Empty( cMsgJOB )
		Reclock('SC5',.F.)
		xObs:=SC5->C5_XOBS
		SC5->C5_XOBS	:= "***Liberação manual de pagamento realizado "+cUserLib+" em "+DtoC(Date())+"-"+Time()+" ***"+chr(13)+chr(10)+xObs
		Msunlock() 
	EndIF

	RestArea(aArea)
Return(.T.)

/*/{Protheus.doc} XA410CAN

Funcao executada pelo ponto de entrada onde serah utilizado o tratametno de cancelamento manual de pedidos no site de vendas independente de ja existir faturamento do mesmo.

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
User Function XA410CAN
	Local cXtitulo	:= "Cancelamento Pedido Site"
	Local cFunName	:= FunName()
	Local lRet		:= .F.
	Local aRet		:= {}
	Local aParamBox := {}
	Local cXNPSite	:= SC5->C5_XNPSITE
	Local cPedLog	:= IIF(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,cXNPSite)
	Local cMSG		:= ''
	Local cRET		:= ''

	SC6->(DbSetOrder(1))

	If 	SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM)) .and. MSgYesNo("Deseja informar o cancelamento do Pedido "+Alltrim(SC5->C5_XNPSITE)+"?",cXtitulo)
		aAdd(aParamBox,{11,"Informe o motivo","",".T.",".T.",.T.})
		If ParamBox(aParamBox,cXtitulo,@aRet)
			While !SC6->(EoF()) .and. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+SC5->C5_NUM

				//Marca os campos de informação de cancelamento
				RecLock("SC6", .F.)
				SC6->C6_XNFCANC := "S"
				SC6->C6_XDTCANC := DdataBase
				SC6->C6_XHRCANC := Time()
				//SC6->C6_BLQ := "R" //Retirado conforme solicição Giovanni 30.05.2016
				SC6->(MsUnLock())

				lRet := .T.

				SC6->(DbSkip())
			EndDo

			If lRet
				cMSG := "*** Pedido cancelado manualmente através da rotina [" + cFunName + "] por " + Upper(Alltrim(cUserName)) +; 
				" (Financeiro) em ["+DtoC(Date())+"-"+Time()+"] Motivo: " + rTrim(aRet[1]) + " ***"
				//Marca o pedido para ser enviado ao hub 
				RecLock("SC5", .F.)
				SC5->C5_XFLAGEN := ""
				SC5->C5_XOBS	  := cMSG + CRLF + CRLF + SC5->C5_XOBS  
				SC5->C5_NOTA    := IIF(Empty(SC5->C5_NOTA),'XXXXXX',SC5->C5_NOTA)
				IF EMPTY(SC5->C5_XRECPG)
					SC5->C5_XRECPG:='Pedido cancelado'
				ENDIF
				SC5->(MsUnLock())

				cRET := cXNPSite + ';' + cXNPSite + ';SC5;' + cXtitulo + ';' + cMSG

				U_VNDA331( {'01','02',cRET} )
				U_GTPutOUT(cXNPSite,"X",cPedLog,{cFunName,{.F.,"M00002",cMSG}},cXNPSite)
				MsgInfo("Solicitação de cancelamento realizada com Sucesso",cXtitulo)
			EndIf
		Else
			MsgInfo("Operação cancelada, necessário informar o motivo.",cXtitulo)
			Return(.F.)
		EndIF
	Else
		MsgStop("Não foram encontrados itens para Cancelar.",cXtitulo)
		Return(.F.)
	EndIf
Return(.T.)