User Function MTA410T()

	Local _aArea    := GetArea()
	Local _aAreaSC5 := SC5->(GetArea())
	Local _aAreaSC6 := SC6->(GetArea())

	If  Empty(SC5->C5_BLQ) .AND. SC5->C5_XFRTDIG$"1" .AND. SC5->C5_TPFRETE$"C"
		dbSelectArea("SC5")
		RecLock("SC5",.f.)
		SC5->C5_BLQ := "1"
		MsUnLock()

	Elseif Empty(SC5->C5_BLQ) .AND. "CARTAO"$AllTrim(M->C5_ZDESC)
		dbSelectArea("SC5")
		RecLock("SC5",.f.)
		SC5->C5_BLQ := "1"
		MsUnLock()
	EndIf


	TotPed(SC5->C5_NUM)

	RestArea(_aArea)
	RestArea(_aAreaSC5)
	RestArea(_aAreaSC6)
	
Return .T.


Static Function TotPed(cNumPed)
	Local _aArea := GetArea()
    Local nTotBru   := 0
    Local nTotPli   := 0

	If !SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cNumPed))
		RestArea(_aArea)
		Return .F.
	Endif

	If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
		While SC6->(!Eof()) .And. xFilial("SC6")==SC6->C6_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
		    nTotBru += Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PESBRU")*SC6->C6_QTDVEN  //B1_PESBRU - PESO BRUTO
		    nTotPli += Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PESO")*SC6->C6_QTDVEN   //B1_PESO   - Peso Liquido

			SC6->(DbSkip())
		EndDo
	Endif

	RecLock("SC5",.F.)
	SC5->C5_PESOL         := nTotBru 
    SC5->C5_PBRUTO        := nTotPli 
	SC5->(MsUnlock())
		
	RestArea(_aArea)

Return()
