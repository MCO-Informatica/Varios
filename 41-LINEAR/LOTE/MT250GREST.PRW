#Include "TOPCONN.Ch"
//
// Programa		MT250GREST
// Autor		Carlos N. Puerta
// Data			15/10/2017
// Localização	Executado na função A250Estorn(), responsavel pelos estornos dos apontamentos de produção.
// Descrição	O ponto de entrada 'MT250GREST' permite realizar gravações e/ou exclusões em tabelas e/ou campos especificos do usuário após realizar o Estorno.
//
// TDN			http://tdn.totvs.com/pages/releaseview.action?pageId=6087753
//
User Function MT250GREST()
Local _aArea      := GetArea()
Local _cNumOP     := SD3->D3_OP
Local _cProduto   := SD3->D3_COD
Local _cXLt01     := SD3->D3_RAST01
Local _cXLt02     := SD3->D3_RAST02
Local _cXLt03     := SD3->D3_RAST03
Local _cXLt04     := SD3->D3_RAST04
//Local _cXLt05     := SD3->D3_RAST05
Local _cXTurno    := SD3->D3_XTURNO
Local _cXOperador := SD3->D3_XOPERAD
Local _nQuant     := SD3->D3_QUANT
//
//********************************************************
//
If !Empty(_cXLt01)
	dbSelectArea("SZC")
	dbSetOrder(3)             // ZC_FILIAL+ZC_PRODUTO+ZC_LOTENFE
	dbSeek(xFilial("SZC")+_cProduto+_cXLt01)
	Do While !Eof() .And. AllTrim(_cProduto) == AllTrim(SZC->ZC_PRODUTO) .And. AllTrim(_cXLt01) == AllTrim(SZC->ZC_LOTENFE)
	    If SZC->ZC_STATUS == "02" .Or. SZC->ZC_STATUS == "91"
	        RecLock("SZC",.F.)
	        SZC->ZC_STATUS   := "01"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo

	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	dbSeek(xFilial("SZC")+_cNumOP+_cXLt01)
	Do While !Eof() .And. AllTrim(_cNumOP) == SZC->ZC_OP .And. AllTrim(_cXLt01) == SZC->ZC_LOTEOP
		If Empty(SZC->ZC_NUMPV) .And. SZC->ZC_STATUS == "05" .And. AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador)
			RecLock("SZC",.F.)
			dbDelete()
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
EndIf

If !Empty(_cXLt02)
	dbSelectArea("SZC")
	dbSetOrder(3)             // ZC_FILIAL+ZC_PRODUTO+ZC_LOTENFE
	dbSeek(xFilial("SZC")+_cProduto+_cXLt02)
	Do While !Eof() .And. AllTrim(_cProduto) == AllTrim(SZC->ZC_PRODUTO) .And. AllTrim(_cXLt02) == AllTrim(SZC->ZC_LOTENFE)
	    If SZC->ZC_STATUS == "02" .Or. SZC->ZC_STATUS == "91"
	        RecLock("SZC",.F.)
	        SZC->ZC_STATUS   := "01"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo

	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	dbSeek(xFilial("SZC")+_cNumOP+_cXLt02)
	Do While !Eof() .And. AllTrim(_cNumOP) == SZC->ZC_OP .And. AllTrim(_cXLt02) == SZC->ZC_LOTEOP
		If Empty(SZC->ZC_NUMPV) .And. SZC->ZC_STATUS == "05" .And. AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador)
			RecLock("SZC",.F.)
			dbDelete()
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
EndIf

If !Empty(_cXLt03)
	dbSelectArea("SZC")
	dbSetOrder(3)             // ZC_FILIAL+ZC_PRODUTO+ZC_LOTENFE
	dbSeek(xFilial("SZC")+_cProduto+_cXLt03)
	Do While !Eof() .And. AllTrim(_cProduto) == AllTrim(SZC->ZC_PRODUTO) .And. AllTrim(_cXLt03) == AllTrim(SZC->ZC_LOTENFE)
	    If SZC->ZC_STATUS == "02" .Or. SZC->ZC_STATUS == "91"
	        RecLock("SZC",.F.)
	        SZC->ZC_STATUS   := "01"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo

	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	dbSeek(xFilial("SZC")+_cNumOP+_cXLt03)
	Do While !Eof() .And. AllTrim(_cNumOP) == SZC->ZC_OP .And. AllTrim(_cXLt03) == SZC->ZC_LOTEOP
		If Empty(SZC->ZC_NUMPV) .And. SZC->ZC_STATUS == "05" .And. AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador)
			RecLock("SZC",.F.)
			dbDelete()
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
EndIf

If !Empty(_cXLt04)
	dbSelectArea("SZC")
	dbSetOrder(3)             // ZC_FILIAL+ZC_PRODUTO+ZC_LOTENFE
	dbSeek(xFilial("SZC")+_cProduto+_cXLt04)
	Do While !Eof() .And. AllTrim(_cProduto) == AllTrim(SZC->ZC_PRODUTO) .And. AllTrim(_cXLt04) == AllTrim(SZC->ZC_LOTENFE)
	    If SZC->ZC_STATUS == "02" .Or. SZC->ZC_STATUS == "91"
	        RecLock("SZC",.F.)
	        SZC->ZC_STATUS   := "01"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo

	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	dbSeek(xFilial("SZC")+_cNumOP+_cXLt04)
	Do While !Eof() .And. AllTrim(_cNumOP) == SZC->ZC_OP .And. AllTrim(_cXLt04) == SZC->ZC_LOTEOP
		If Empty(SZC->ZC_NUMPV) .And. SZC->ZC_STATUS == "05" .And. AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador)
			RecLock("SZC",.F.)
			dbDelete()
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
EndIf
//
/*/
If !Empty(_cXLt05)
	dbSelectArea("SZC")
	dbSetOrder(3)             // ZC_FILIAL+ZC_PRODUTO+ZC_LOTENFE
	dbSeek(xFilial("SZC")+_cProduto+_cXLt05)
	Do While !Eof() .And. AllTrim(_cProduto) == AllTrim(SZC->ZC_PRODUTO) .And. AllTrim(_cXLt05) == AllTrim(SZC->ZC_LOTENFE)
	    If SZC->ZC_STATUS == "02" .Or. SZC->ZC_STATUS == "91"
	        RecLock("SZC",.F.)
	        SZC->ZC_STATUS   := "01"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo

	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	dbSeek(xFilial("SZC")+_cNumOP+_cXLt05)
	Do While !Eof() .And. AllTrim(_cNumOP) == SZC->ZC_OP .And. AllTrim(_cXLt05) == SZC->ZC_LOTEOP
		If Empty(SZC->ZC_NUMPV) .And. SZC->ZC_STATUS == "05" .And. AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador)
			RecLock("SZC",.F.)
			dbDelete()
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
EndIf
/*/
//
RestArea(_aArea)
Return