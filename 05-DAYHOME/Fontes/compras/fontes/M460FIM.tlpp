#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 

//////////////////////////////////////////////////////////////////////////////
//Analista: Guelder                                                         //
//Rotina gera titulo no contas a pagar após a confirmação da Nota de        //
//saida (ICMS DEST e ICMS ST)                                               //
//////////////////////////////////////////////////////////////////////////////

User Function M460FIM()

Local aArea	   := GetArea()
Local cAreaSC6 := SC6->(GetArea())
Local cEstado  := GetMv("MV_XESTST",, "SP")		//parametro para avaliar para quais estados
Local cEstCli  := Posicione("SA1",1,xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA, "A1_EST")

Local xDOC   := SF2->F2_DOC 	// FRETE - Fontanelli 
Local xSERIE := SF2->F2_SERIE 	// FRETE - Fontanelli 

SD2->(DbSetOrder(3))
SD2->(DbSeek(xFilial('SD2') + xDOC + xSERIE))

While !(SD2->(EOF())) .And. xDOC = SD2->D2_DOC .And. xSERIE = SD2->D2_SERIE

    SZ4->(DbSetOrder(4))

    If SZ4->(DbSeek(xFilial('SZ4') + SD2->D2_PEDIDO + SD2->D2_ITEMPV))
        
        SZ4->(reclock('SZ4',.F.))
        
        SZ4->Z4_NOTA    := SF2->F2_DOC
        SZ4->Z4_SERIE   := SF2->F2_SERIE
        SZ4->Z4_CLIENTE := SF2->F2_CLIENTE
        SZ4->Z4_LOJA    := SF2->F2_LOJA
        SZ4->Z4_DTNOTA  := SF2->F2_EMISSAO
        
        SZ4->(MsUnlock())
    
    Endif

    SD2->(DbSkip())

Enddo

RestArea(cAreaSC6)

	// ---------------------------------------------------
	// INTREGRACAOO MADEIRAMADEIRA
	// ---------------------------------------------------  
	
	If ExistBlock("M050105") 
		U_M050105(SF2->F2_DOC,SF2->F2_SERIE)
	Endif 
	
	//----------------------------------------------------
	
	If !(cEstCli $ cEstado)
		U_FIN050INC()
	EndIf

	if SF2->F2_TIPO == 'N'
		
		If SE1->(FieldPos("E1_XDEMONS")) > 0
			//Gravacao de Campo Especifico nas Operacoes de Demonstracao
			Demonstr(SF2->F2_SERIE, SF2->F2_DOC, SF2->F2_CLIENTE, SF2->F2_LOJA)
		EndIf

		//27/09/2016, para notas fiscais de venda, caso o cliente possua descontos financeiro sera atualizado o
		//seu titulo de acordo com a configuraçaõ do campo A1_X_TPVC <> 'N' (CTP)
		dbSelectArea('SA1')
		SA1->(dbSetorder(1))
		if SA1->(dbSeek(xFilial('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA))
		
			if A1_X_TVPC <> 'N'
			
				U_DHFIN001(SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA, SF2->F2_DUPL, SF2->F2_PREFIXO, SA1->A1_CGC, SA1->A1_X_TVPC, SA1->A1_X_PVPC,SF2->F2_VALBRUT)
				
			EndIf
			
		EndIf
		
	EndIf

	//U_DHFrete(xDOC,xSERIE) // FRETE - Fontanelli

//Inicia-se Customização para gravação de Volume correto de acordo com Pedido.
//Lucas Baia - Consultor Protheus pela UPDUO.
//Customizado
cQuery := " SELECT ISNULL(SUM(C5_VOLUME1),0) QTD FROM "+RetSqlName("SC5")+" SC5 "
cQuery += " WHERE C5_FILIAL = '"+xFilial("SC5")+"' "
cQuery += " AND C5_NUM IN ( SELECT DISTINCT C6_NUM FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'" 
cQuery += " AND C6_NOTA = '"+SF2->F2_DOC+"'"
cQuery += " AND C6_SERIE = '"+SF2->F2_SERIE+"'"
cQuery += " AND C6_CLI = '"+SF2->F2_CLIENTE+"'"
cQuery += " AND C6_LOJA = '"+SF2->F2_LOJA+"'"
cQuery += " AND SC6.D_E_L_E_T_ = '' ) "
cQuery += " AND SC5.D_E_L_E_T_ = '' "

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW Alias "QRYSC5" 
			
dbSelectArea("QrySC5")
dbGoTop()
_nVolume1 := QrySC5->QTD
QrySC5->(dbCloseArea())

RecLock("SF2", .F.)
SF2->F2_VOLUME1	:= _nVolume1
SF2->(MsUnlock())

//Fim Customização para gravação de Volume correto de acordo com Pedido.
//Lucas Baia - Consultor Protheus pela UPDUO.
//Customizado

RestArea(aArea)
	
Return
//-------------------------------------------------------------------
/*{Protheus.doc} Demonstr
Grava no Titulo a Receber se e uma operacao de Demonstracao

@author Guilherme Santos
@since 07/11/2016
@version P12
*/
//-------------------------------------------------------------------
Static Function Demonstr(cSerie, cNFiscal, cCliente, cLojaCli)
	Local aArea		:= GetArea()
	Local aAreaSF2	:= SF2->(GetArea())
	Local aAreaSD2	:= SD2->(GetArea())
	Local aAreaSC5	:= SC5->(GetArea())
	Local aAreaSE1	:= SE1->(GetArea())

	Local cCondDem	:= SuperGetMV("ES_CONDDEM", NIL, "D00")
	Local cQuery		:= ""
	Local cTabQry		:= GetNextAlias()
	
	cQuery += "SELECT		SD2.D2_PEDIDO" + CRLF
	cQuery += "FROM		" + RetSqlName("SD2") + " SD2" + CRLF
	cQuery += "WHERE		SD2.D2_FILIAL = '" + xFilial("SD2") + "'" + CRLF
	cQuery += "AND		SD2.D2_SERIE = '" + cSerie + "'" + CRLF
	cQuery += "AND		SD2.D2_DOC = '" + cNFiscal + "'" + CRLF
	cQuery += "AND		SD2.D2_CLIENTE = '" + cCliente + "'" + CRLF
	cQuery += "AND		SD2.D2_LOJA = '" + cLojaCli + "'" + CRLF
	cQuery += "AND		SD2.D_E_L_E_T_ = ''" + CRLF
	cQuery += "GROUP BY 	SD2.D2_PEDIDO" + CRLF
	
	cQuery := ChangeQuery(cQuery)
		
	DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cTabQry, .T., .T.)
		
	While !(cTabQry)->(Eof())
		DbSelectArea("SC5")
		DbSetOrder(1)		//C5_FILIAL, C5_NUM
		
		If SC5->(DbSeek(xFilial("SC5") + (cTabQry)->D2_PEDIDO))
			If SC5->C5_CONDPAG $ cCondDem
				DbSelectArea("SE1")
				DbSetOrder(1)		//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
				
				If SE1->(DbSeek(xFilial("SE1") + cSerie + cNFiscal))
					While !SE1->(Eof()) .AND. xFilial("SE1") + cSerie + cNFiscal == SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM
						If AllTrim(SE1->E1_TIPO) == "NF"
							RecLock("SE1", .F.)
								SE1->E1_XDEMONS := "S"
							MsUnlock()
						EndIf
					
						SE1->(DbSkip())
					End
				EndIf
			EndIf
		EndIf	

		(cTabQry)->(DbSkip())
	End
	
	If Select(cTabQry) > 0
		(cTabQry)->(DbCloseArea())
	EndIf
	
	RestArea(aAreaSE1)
	RestArea(aAreaSC5)
	RestArea(aAreaSD2)
	RestArea(aAreaSF2)
	RestArea(aArea)
Return NIL

USER FUNCTION FIN050INC()

	LOCAL aArray := {}
	LOCAL nCont:= 0
	LOCAL nIcmsRet:=0
	LOCAL nDifal:=0

	dbSelectArea("SF3")
	dbSetOrder(5)
	If dbSeek(SF2->F2_FILIAL+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
		While Eof() == .f. .and. SF3->F3_FILIAL+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA == SF2->F2_FILIAL+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA

			nIcmsRet += SF3->F3_ICMSRET
			nDifal += SF3->F3_DIFAL

			dbSkip()
		EndDo
	EndIF


	PRIVATE lMsErroAuto := .F.
	IF nDifal<>0 .AND. nIcmsRet<>0
		For nCont:= 1 To 2
			aArray := { { "E2_PREFIXO"  , IIF(nCont=1,"ICD","ST ")   				, NIL },;
				{ "E2_NUM"      , SF2->F2_DOC       						, NIL },;
				{ "E2_TIPO"     , IIF(nCont=1,"ICD","ST ")   				, NIL },;
				{ "E2_NATUREZ"  , IIF(nCont=1,"ICD       ","ST        ")    , NIL },;
				{ "E2_FORNECE"  , "GNR   "            						, NIL },;
				{ "E2_EMISSAO"  , dDatabase									, NIL },;
				{ "E2_VENCTO"   , dDatabase									, NIL },;
				{ "E2_VENCREA"  , dDatabase									, NIL },;
				{ "E2_VALOR"    , IIF(nCont=1,nDifal,nIcmsRet), NIL } }
		 
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
			If lMsErroAuto
				MostraErro()
			Else
				Alert("GERAR GNRE!")
			Endif
  
		Next nCont
		Return
	Else
		IF nDifal<>0
			aArray := { { "E2_PREFIXO"  , "ICD"   			, NIL },;
				{ "E2_NUM"      , SF2->F2_DOC       , NIL },;
				{ "E2_TIPO"     , "ICD"   			, NIL },;
				{ "E2_NATUREZ"  , "ICD       "    	, NIL },;
				{ "E2_FORNECE"  , "GNR   "          , NIL },;
				{ "E2_EMISSAO"  , dDatabase			, NIL },;
				{ "E2_VENCTO"   , dDatabase			, NIL },;
				{ "E2_VENCREA"  , dDatabase			, NIL },;
				{ "E2_VALOR"    , nDifal		, NIL } }
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
			If lMsErroAuto
				MostraErro()
			Else
				Alert("GERAR GNRE!")
			Endif
		EndIf

		IF nIcmsRet<>0
			aArray := { { "E2_PREFIXO"  , "ST "             , NIL },;
				{ "E2_NUM"      , SF2->F2_DOC       , NIL },;
				{ "E2_TIPO"     , "ST "             , NIL },;
				{ "E2_NATUREZ"  , "ST        "      , NIL },;
				{ "E2_FORNECE"  , "GNR   "          , NIL },;
				{ "E2_EMISSAO"  , dDatabase			, NIL },;
				{ "E2_VENCTO"   , dDatabase			, NIL },;
				{ "E2_VENCREA"  , dDatabase			, NIL },;
				{ "E2_VALOR"    , nIcmsRet   , NIL } }
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
			If lMsErroAuto
				MostraErro()
			Else
				Alert("GERAR GNRE!")
			Endif
		EndIf
	Endif
Return


//////////////////////////////////
//      FRETE - Fontanelli      //
//////////////////////////////////
User Function DHFrete(xDOC,xSERIE) 

	Local oDlg
	Local nOpca    := 0

    local cPedido     := space(06)
    local cTpFrete    := space(01)
    local nFrete      := 0
    local nRealFrete  := 0
    local cMotivo     := space(06)
	
    DbSelectArea("SC6")
    DbSetOrder(4)
    If DbSeek(xFilial("SC6")+xDOC+xSERIE)
	   DbSelectArea("SC5")
	   DbSetOrder(1)
	   if DbSeek(xFilial("SC5")+SC6->(C6_NUM))
            cPedido     := SC5->C5_NUM
            cTpFrete    := SC5->C5_TPFRETE
            nFrete      := SC5->C5_FRETE
            nRealFrete  := 0
        endif
    endif

    If nFrete > 0 .OR. cTpFrete == "C"

		While nOpca == 0

			DEFINE MSDIALOG oDlg FROM 0,0 TO 245,465 PIXEL TITLE "Informar Frete/Motivo"

			@ 010,010 Say "Pedido: " of oDlg Pixel
			@ 009-1,060 MsGet cPedido Picture "@!" when .F. Size 20,10 of oDlg Pixel

			@ 025,010 Say "Tipo Frete: " of oDlg Pixel
			@ 024-1,060 MsGet cTpFrete Picture "@!" When .F. Size 10,10 of oDlg Pixel

			@ 040,010 Say "Frete Protheus: " of oDlg Pixel
			@ 039-1,060 MsGet nFrete Picture "@E 999,999.99" when .F. Size 60,10 of oDlg Pixel

			@ 055,010 Say "Motivo (Tabela ZE): " of oDlg Pixel
			@ 054,060 MsGet cMotivo Picture "@!" F3 "ZE" VALID u_ValMotivo(cMotivo) Size 20,10 of oDlg Pixel

			@ 070,010 Say "Frete Real: " of oDlg Pixel
			@ 069-1,060 MsGet nRealFrete Picture "@E 999,999.99" Size 60,10 of oDlg Pixel

			@ 100,200 BUTTON "Confirma" SIZE 28,13 PIXEL OF oDlg ACTION (nOpca := 1, oDlg:End())

			ACTIVATE MSDIALOG oDlg CENTERED

			If nOpca == 1
				DbSelectArea("SC5")
				DbSetOrder(1)
				If SC5->(dbSeek( xFilial("SC5") + cPedido))
					RecLock("SC5",.F.)
					SC5->C5_XFRTREA := nRealFrete
					SC5->C5_XFRTMOT := cMotivo
					MsUnLock()
				EndIf
			EndIf

		EndDo
		    
    endif
    
Return


//////////////////////////////////
//  VALIDA Motivo - Fontanelli  //
//////////////////////////////////

User Function ValMotivo(cMotivo)

Local nRet:= .T.

	    DbSelectArea("SX5")
        DbSetOrder(1)
	    SX5->(dbGoTop())
	    If ! DbSeek( xFilial("SX5") + "ZE" + cMotivo )
		    Alert("Motivo informado não existe na tabela ZE !" )
		    nRet:= .F.
		endif

Return(nRet)
