#Include "TOPCONN.Ch"
//
// Programa		SD3250I
// Autor		Carlos N. Puerta
// Data			15/10/2017
// Descri??o	Atualiza??es das tabelas de apontamento de produ??o.
// Localiza??o	Executado na fun??o A250Atu(), rotina respons?vel pela atualiza??o das tabelas de apontamentos
// 				de produ??o simples.
// Descri??o	Ap?s atualiza??o dos arquivos na rotina de produ??es.
// 				Executa ap?s atualizar SD3, SB2, SB3 e SC2.
//
User Function SD3250I()
Local _aArea      := GetArea()
Local _cNumOP     := M->D3_OP
Local _cProduto   := M->D3_COD
Local _cXLt01     := M->D3_RAST01
Local _cXLt02     := M->D3_RAST02
Local _cXLt03     := M->D3_RAST03
Local _cXLt04     := M->D3_RAST04
//Local _cXLt05     := M->D3_RAST05
Local _cXTurno    := M->D3_XTURNO
Local _cXOperador := M->D3_XOPERAD
Local _nQuant     := M->D3_QUANT
//
//********************************************************
//
If !Empty(_cXLt01)
	dbSelectArea("SZC")
	dbSetOrder(3)             // ZC_FILIAL+ZC_PRODUTO+ZC_LOTENFE
	dbSeek(xFilial("SZC")+_cProduto+_cXLt01)
	Do While !Eof() .And. AllTrim(_cProduto) == AllTrim(SZC->ZC_PRODUTO) .And. AllTrim(_cXLt01) == AllTrim(SZC->ZC_LOTENFE)
	    If SZC->ZC_STATUS == "01"
	        RecLock("SZC",.F.)
	        SZC->ZC_STATUS   := "02"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo

	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	If dbSeek(xFilial("SZC")+_cNumOP+_cXLt01)
		If Empty(SZC->ZC_NUMPV) .And. AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador)
			RecLock("SZC",.F.)
			SZC->ZC_OP      := _cNumOP
			SZC->ZC_PRODOP  := _cProduto
			SZC->ZC_LOTEOP  := _cXLt01
			SZC->ZC_TURNO   := _cXTurno
			SZC->ZC_OPERADO := _cXOperador
			SZC->ZC_QTDOP   += _nQuant
			SZC->ZC_NUMPV   := Space(06)
			SZC->ZC_ITEMPV  := Space(02)
			SZC->ZC_QTDPV   := 0
			SZC->ZC_STATUS  := "05"
			MsUnlock()
		Else
			RecLock("SZC",.T.)
			SZC->ZC_OP      := _cNumOP
			SZC->ZC_PRODOP  := _cProduto
			SZC->ZC_LOTEOP  := _cXLt01
			SZC->ZC_TURNO   := _cXTurno
			SZC->ZC_OPERADO := _cXOperador
			SZC->ZC_QTDOP   := _nQuant
			SZC->ZC_NUMPV   := Space(06)
			SZC->ZC_ITEMPV  := Space(02)
			SZC->ZC_QTDPV   := 0
			SZC->ZC_STATUS  := "05"
			MsUnlock()
		EndIf
	Else
		RecLock("SZC",.T.)
		SZC->ZC_OP      := _cNumOP
		SZC->ZC_PRODOP  := _cProduto
		SZC->ZC_LOTEOP  := _cXLt01
		SZC->ZC_TURNO   := _cXTurno
		SZC->ZC_OPERADO := _cXOperador
		SZC->ZC_QTDOP   := _nQuant
		SZC->ZC_NUMPV   := Space(06)
		SZC->ZC_ITEMPV  := Space(02)
		SZC->ZC_QTDPV   := 0
		SZC->ZC_STATUS  := "05"
		MsUnlock()
	EndIf
EndIf

If !Empty(_cXLt02)
	dbSelectArea("SZC")
	dbSetOrder(3)             // ZC_FILIAL+ZC_PRODUTO+ZC_LOTENFE
	dbSeek(xFilial("SZC")+_cProduto+_cXLt02)
	Do While !Eof() .And. AllTrim(_cProduto) == AllTrim(SZC->ZC_PRODUTO) .And. AllTrim(_cXLt02) == AllTrim(SZC->ZC_LOTENFE)
	    If SZC->ZC_STATUS == "01"
	        RecLock("SZC",.F.)
	        SZC->ZC_STATUS   := "02"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo

	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	If dbSeek(xFilial("SZC")+_cNumOP+_cXLt02)
		If Empty(SZC->ZC_NUMPV) .And. AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador)
			RecLock("SZC",.F.)
			SZC->ZC_OP      := _cNumOP
			SZC->ZC_PRODOP  := _cProduto
			SZC->ZC_LOTEOP  := _cXLt02
			SZC->ZC_TURNO   := _cXTurno
			SZC->ZC_OPERADO := _cXOperador
			SZC->ZC_QTDOP   += _nQuant
			SZC->ZC_NUMPV   := Space(06)
			SZC->ZC_ITEMPV  := Space(02)
			SZC->ZC_STATUS  := "05"
			MsUnlock()
		Else
			RecLock("SZC",.T.)
			SZC->ZC_OP      := _cNumOP
			SZC->ZC_PRODOP  := _cProduto
			SZC->ZC_LOTEOP  := _cXLt02
			SZC->ZC_TURNO   := _cXTurno
			SZC->ZC_OPERADO := _cXOperador
			SZC->ZC_QTDOP   := _nQuant
			SZC->ZC_NUMPV   := Space(06)
			SZC->ZC_ITEMPV  := Space(02)
			SZC->ZC_STATUS  := "05"
			MsUnlock()
		EndIf
	Else
		RecLock("SZC",.T.)
		SZC->ZC_OP      := _cNumOP
		SZC->ZC_PRODOP  := _cProduto
		SZC->ZC_LOTEOP  := _cXLt02
		SZC->ZC_TURNO   := _cXTurno
		SZC->ZC_OPERADO := _cXOperador
		SZC->ZC_QTDOP   := _nQuant
		SZC->ZC_NUMPV   := Space(06)
		SZC->ZC_ITEMPV  := Space(02)
		SZC->ZC_STATUS  := "05"
		MsUnlock()
	EndIf
EndIf

If !Empty(_cXLt03)
	dbSelectArea("SZC")
	dbSetOrder(3)             // ZC_FILIAL+ZC_PRODUTO+ZC_LOTENFE
	dbSeek(xFilial("SZC")+_cProduto+_cXLt03)
	Do While !Eof() .And. AllTrim(_cProduto) == AllTrim(SZC->ZC_PRODUTO) .And. AllTrim(_cXLt03) == AllTrim(SZC->ZC_LOTENFE)
	    If SZC->ZC_STATUS == "01"
	        RecLock("SZC",.F.)
	        SZC->ZC_STATUS   := "02"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo

	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	If dbSeek(xFilial("SZC")+_cNumOP+_cXLt03)
		If Empty(SZC->ZC_NUMPV) .And. AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador)
			RecLock("SZC",.F.)
			SZC->ZC_OP      := _cNumOP
			SZC->ZC_PRODOP  := _cProduto
			SZC->ZC_LOTEOP  := _cXLt03
			SZC->ZC_TURNO   := _cXTurno
			SZC->ZC_OPERADO := _cXOperador
			SZC->ZC_QTDOP   += _nQuant
			SZC->ZC_NUMPV   := Space(06)
			SZC->ZC_ITEMPV  := Space(02)
			SZC->ZC_STATUS  := "05"
			MsUnlock()
		Else
			RecLock("SZC",.T.)
			SZC->ZC_OP      := _cNumOP
			SZC->ZC_PRODOP  := _cProduto
			SZC->ZC_LOTEOP  := _cXLt03
			SZC->ZC_TURNO   := _cXTurno
			SZC->ZC_OPERADO := _cXOperador
			SZC->ZC_QTDOP   := _nQuant
			SZC->ZC_NUMPV   := Space(06)
			SZC->ZC_ITEMPV  := Space(02)
			SZC->ZC_STATUS  := "05"
			MsUnlock()
		EndIf
	Else
		RecLock("SZC",.T.)
		SZC->ZC_OP      := _cNumOP
		SZC->ZC_PRODOP  := _cProduto
		SZC->ZC_LOTEOP  := _cXLt03
		SZC->ZC_TURNO   := _cXTurno
		SZC->ZC_OPERADO := _cXOperador
		SZC->ZC_QTDOP   := _nQuant
		SZC->ZC_NUMPV   := Space(06)
		SZC->ZC_ITEMPV  := Space(02)
		SZC->ZC_STATUS  := "05"
		MsUnlock()
	EndIf
EndIf

If !Empty(_cXLt04)
	dbSelectArea("SZC")
	dbSetOrder(3)             // ZC_FILIAL+ZC_PRODUTO+ZC_LOTENFE
	dbSeek(xFilial("SZC")+_cProduto+_cXLt04)
	Do While !Eof() .And. AllTrim(_cProduto) == AllTrim(SZC->ZC_PRODUTO) .And. AllTrim(_cXLt04) == AllTrim(SZC->ZC_LOTENFE)
	    If SZC->ZC_STATUS == "01"
	        RecLock("SZC",.F.)
	        SZC->ZC_STATUS   := "02"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo

	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	If dbSeek(xFilial("SZC")+_cNumOP+_cXLt04)
		If Empty(SZC->ZC_NUMPV) .And. AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador)
			RecLock("SZC",.F.)
			SZC->ZC_OP      := _cNumOP
			SZC->ZC_PRODOP  := _cProduto
			SZC->ZC_LOTEOP  := _cXLt04
			SZC->ZC_TURNO   := _cXTurno
			SZC->ZC_OPERADO := _cXOperador
			SZC->ZC_QTDOP   += _nQuant
			SZC->ZC_NUMPV   := Space(06)
			SZC->ZC_ITEMPV  := Space(02)
			SZC->ZC_STATUS  := "05"
			MsUnlock()
		Else
			RecLock("SZC",.T.)
			SZC->ZC_OP      := _cNumOP
			SZC->ZC_PRODOP  := _cProduto
			SZC->ZC_LOTEOP  := _cXLt04
			SZC->ZC_TURNO   := _cXTurno
			SZC->ZC_OPERADO := _cXOperador
			SZC->ZC_QTDOP   := _nQuant
			SZC->ZC_NUMPV   := Space(06)
			SZC->ZC_ITEMPV  := Space(02)
			SZC->ZC_STATUS  := "05"
			MsUnlock()
		EndIf
	Else
		RecLock("SZC",.T.)
		SZC->ZC_OP      := _cNumOP
		SZC->ZC_PRODOP  := _cProduto
		SZC->ZC_LOTEOP  := _cXLt04
		SZC->ZC_TURNO   := _cXTurno
		SZC->ZC_OPERADO := _cXOperador
		SZC->ZC_QTDOP   := _nQuant
		SZC->ZC_NUMPV   := Space(06)
		SZC->ZC_ITEMPV  := Space(02)
		SZC->ZC_STATUS  := "05"
		MsUnlock()
	EndIf
EndIf
//
/*/
If !Empty(_cXLt05)
	dbSelectArea("SZC")
	dbSetOrder(3)             // ZC_FILIAL+ZC_PRODUTO+ZC_LOTENFE
	dbSeek(xFilial("SZC")+_cProduto+_cXLt05)
	Do While !Eof() .And. AllTrim(_cProduto) == AllTrim(SZC->ZC_PRODUTO) .And. AllTrim(_cXLt05) == AllTrim(SZC->ZC_LOTENFE)
	    If SZC->ZC_STATUS == "01"
	        RecLock("SZC",.F.)
	        SZC->ZC_STATUS   := "02"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo

	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	If dbSeek(xFilial("SZC")+_cNumOP+_cXLt05)
		If Empty(SZC->ZC_NUMPV) .And. AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador)
			RecLock("SZC",.F.)
			SZC->ZC_OP      := _cNumOP
			SZC->ZC_PRODOP  := _cProduto
			SZC->ZC_LOTEOP  := _cXLt05
			SZC->ZC_TURNO   := _cXTurno
			SZC->ZC_OPERADO := _cXOperador
			SZC->ZC_QTDOP   += _nQuant
			SZC->ZC_NUMPV   := Space(06)
			SZC->ZC_ITEMPV  := Space(02)
			SZC->ZC_STATUS  := "05"
			MsUnlock()
		Else
			RecLock("SZC",.T.)
			SZC->ZC_OP      := _cNumOP
			SZC->ZC_PRODOP  := _cProduto
			SZC->ZC_LOTEOP  := _cXLt05
			SZC->ZC_TURNO   := _cXTurno
			SZC->ZC_OPERADO := _cXOperador
			SZC->ZC_QTDOP   := _nQuant
			SZC->ZC_NUMPV   := Space(06)
			SZC->ZC_ITEMPV  := Space(02)
			SZC->ZC_STATUS  := "05"
			MsUnlock()
		EndIf
	Else
		RecLock("SZC",.T.)
		SZC->ZC_OP      := _cNumOP
		SZC->ZC_PRODOP  := _cProduto
		SZC->ZC_LOTEOP  := _cXLt05
		SZC->ZC_TURNO   := _cXTurno
		SZC->ZC_OPERADO := _cXOperador
		SZC->ZC_QTDOP   := _nQuant
		SZC->ZC_NUMPV   := Space(06)
		SZC->ZC_ITEMPV  := Space(02)
		SZC->ZC_STATUS  := "05"
		MsUnlock()
	EndIf
EndIf
/*/
//
RestArea(_aArea)
Return