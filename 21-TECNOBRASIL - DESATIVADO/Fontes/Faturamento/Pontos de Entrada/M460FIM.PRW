#Include "Protheus.ch"
#Include "TopConn.ch"

User Function M460FIM()
	Local cPedido  := ''
	Local cFormPG   := ''
	Local aAreaSF2 := SF2->(GetArea())
	Local aAreaSD2 := SD2->(GetArea())
	Local aAreaSC5 := SC5->(GetArea())
	Local aAreaSE1 := SE1->(GetArea())
	Local aAreaSA1 := SA1->(GetArea())

	//Pega o pedido
	DbSelectArea("SD2")
	SD2->(DbSetorder(3))
	If SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
		cPedido := SD2->D2_PEDIDO
	Endif

	//Se tiver pedido
	If !Empty(cPedido)
		DbSelectArea("SC5")
		SC5->(DbSetorder(1))

		//Se posiciona pega o tipo de pagamento
		If SC5->(DbSeek(FWxFilial('SC5')+cPedido))
			cFormPG := SC5->C5_XFORMPG
		Endif
	Endif

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())

	//Se tiver dado, altera o tipo de pagamento
	If SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))

		RecLock("SA1",.F.)

		If cFormPG == "BOL" .AND. SA1->A1_XMCPBOL < SF2->F2_VALBRUT
			SA1->A1_XMCPBOL := SF2->F2_VALBRUT
			SA1->A1_XFORMPG := cFormPG

		ElseIf cFormPG == "DIN" .AND. SA1->A1_XMCPDIN < SF2->F2_VALBRUT
			SA1->A1_XMCPDIN := SF2->F2_VALBRUT
			SA1->A1_XFORMPG := cFormPG

		ElseIf cFormPG == "CCR" .AND. SA1->A1_XMCPCAR < SF2->F2_VALBRUT
			SA1->A1_XMCPCAR := SF2->F2_VALBRUT
			SA1->A1_XFORMPG := cFormPG

		ElseIf cFormPG == "DEP" .AND. SA1->A1_XMCPDEP < SF2->F2_VALBRUT
			SA1->A1_XMCPDEP := SF2->F2_VALBRUT
			SA1->A1_XFORMPG := cFormPG

		ElseIf cFormPG == "CHQ" .AND. SA1->A1_XMCPCH < SF2->F2_VALBRUT
			SA1->A1_XMCPCH := SF2->F2_VALBRUT
			SA1->A1_XFORMPG := cFormPG

		EndIf

		If cFormPG $ "CHQ,BOL" .AND. !Empty(SA1->A1_XCCLANT)
			If SF2->F2_VALBRUT > SA1->A1_LC 
				SA1->A1_LC := SF2->F2_VALBRUT
				
				If SA1->A1_ATR == 0
					SA1->A1_RISCO := 'A'
				EndIF

				If DateDiffDay(dDataBase,SA1->A1_ULTCOM) >= 720
					SA1->A1_RISCO := 'B'
				EndIf
				
				/*
				If DateDiffDay(dDataBase,SA1->A1_ULTCOM) >= 6
					SA1->A1_RISCO := 'E'
				EndIf
				*/

			EndIf
		EndIf
		SA1->(MsUnlock())

	EndIf


	//Filtra títulos dessa nota
	cSql := "SELECT R_E_C_N_O_ AS REC FROM "+RetSqlName("SE1")
	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND D_E_L_E_T_<>'*' "
	cSql += " AND E1_PREFIXO = '"+SF2->F2_SERIE+"' AND E1_NUM = '"+SF2->F2_DOC+"' "
	cSql += " AND E1_TIPO = 'NF' "
	TcQuery ChangeQuery(cSql) New Alias "_QRY"

	//Enquanto tiver dados na query
	While !_QRY->(eof())
		DbSelectArea("SE1")
		SE1->(DbGoTo(_QRY->REC))

		//Se tiver dado, altera o tipo de pagamento
		If !SE1->(EoF())
			RecLock("SE1",.F.)
			SE1->E1_XFORMPG := cFormPG
			SE1->(MsUnlock())
		EndIf

		_QRY->(DbSkip())
	Enddo
	_QRY->(DbCloseArea())

	RestArea(aAreaSF2)
	RestArea(aAreaSD2)
	RestArea(aAreaSC5)
	RestArea(aAreaSE1)
	RestArea(aAreaSA1)

Return
