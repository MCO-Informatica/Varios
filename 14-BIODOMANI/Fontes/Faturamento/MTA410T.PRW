User Function MTA410T()

	Local _aArea    := GetArea()
	Local _lTransf  := .f.
	Local _lLiberOK := .t.
	Local _lLiber   := .t.
	Local _nForcaLib:= 0
	Local _nTotalPed:= 0
    Local _cGeraFin := ""

	//ALERT("SC5 "+SC5->C5_NUM+" - "+SC5->C5_BLQ)

	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.F.)

		While Eof() == .f. .And. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)

			//ALERT("SC6 "+SC6->C6_NUM+" - "+SC6->C6_ITEM+" - "+SC6->C6_BLOQUEI)
			//ALERT("ACN "+ACN->ACN_CODREG)

			dbSelectArea("ACN")
			dbSetOrder(3)
			dbSeek(xFilial("ACN")+SC6->C6_X_PRKIT,.F.)

			_nTotalPed ++
            _cGeraFin := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_DUPLIC")

			//----> SE FOR KIT VERIFICA O DESCONTO DE KIT
			If !Empty(SC6->C6_BLOQUEI) .and. SC6->C6_X_KIT$"S"
				//----> SE O DESCONTO ESTIVER NA REGRA DO KIT, LIBERA O PEDIDO
				If SC6->C6_DESCONT <= ACN->ACN_X_DESC
					RecLock("SC6",.f.)
					SC6->C6_BLOQUEI = ''
					_nForcaLib ++
					MsUnLock()
				EndIf
			//----> SE O TES NÃO GERA FINANCEIRO, LIBERA O PEDIDO
			ElseIf !Empty(SC6->C6_BLOQUEI) .and. _cGeraFin$"N"
				RecLock("SC6",.f.)
				SC6->C6_BLOQUEI = ''
				_nForcaLib ++
				MsUnLock()
			Elseif Empty(SC6->C6_BLOQUEI) .and. SC6->C6_X_KIT$"N"
				_nForcaLib ++
			EndIf

			//----> INICIO GRAVACAO DOS CAMPOS CUSTOMIZADOS SC6 - 02/02/2020 - RICARDO SOUZA - UPDUO
			RecLock("SC6",.f.)
			SC6->C6_LOCAL		:=	SC5->C5_X_ARMAZ
			SC6->C6_X_EMPFA		:=	SC5->C5_X_EMPFA
			MsUnLock()
			//----> FIM GRAVACAO DOS CAMPOS CUSTOMIZADOS SC6 - 02/02/2020 - RICARDO SOUZA - UPDUO
			dbSkip()
		EndDo
	EndIf

	dbSelectArea("SC9")
	dbSetOrder(1)
	If dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.F.)

		While Eof() == .f. .And. SC9->(C9_FILIAL+C9_PEDIDO) == SC5->(C5_FILIAL+C5_NUM)

			//ALERT("SC9 "+SC9->C9_PEDIDO+"- "+SC9->C9_ITEM)

			//----> INICIO GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 21/09/2017 - RICARDO SOUZA - MCINFOTEC
			RecLock("SC9",.f.)
			SC9->C9_DF		:=	SC5->C5_DF
			SC9->C9_X_EMPFA	:=	SC5->C5_X_EMPFA
			MsUnLock()
			//----> FIM GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 21/09/2017 - RICARDO SOUZA - MCINFOTEC
			dbSkip()
		EndDo
	EndIf

	If _nForcaLib == _nTotalPed .and. SC5->C5_BLQ$"1"
		dbSelectArea("SC5")
		RecLock("SC5",.f.)
		SC5->C5_BLQ := ""
		MsUnLock()
		//ALERT("VOU FORÇAR A LIBERAÇÃO")
		MaAvLibPed(SC5->C5_NUM,_lLiber,_lTransf,@_lLiberOk)
	EndIf

	RestArea(_aArea)

Return()
