#include "rwmake.ch"

User Function RESTA02()

    Processa({|| AJUSTA()},"@AJUSTANDO SB9")
Return

Static Function AJUSTA()

Local _cLote    := ""
Local _cProduto := ""
Local _nQtde    := 0

dbSelectArea("SBJ")
dbSetOrder(2)
//BJ_FILIAL, BJ_COD, BJ_LOCAL, BJ_LOTECTL, BJ_DATA

While Eof() == .f. 

    IncProc("Processando Saldos Por Lote "+StrZero(Recno(),10))
    _cProduto   := SBJ->BJ_COD
    _cLote      := SBJ->BJ_LOTECTL
    _cLocal     := SBJ->BJ_LOCAL
    _dData      := "20210115"

    //If !SBJ->BJ_LOCAL$"01A1"
    //    dbSelectArea("SBJ")
    //    dbSkip()
    //    Loop
    //EndIf

    If !DTOS(SBJ->BJ_DATA) $ _dData
        dbSelectArea("SBJ")
        dbSkip()
        Loop
    EndIf


    While Eof() == .f. .And. SBJ->(BJ_FILIAL+BJ_COD+BJ_LOCAL) == xFilial("SBJ")+_cProduto+_clocal

        If DTOS(SBJ->BJ_DATA) == _dData
            _nQtde += SBJ->BJ_QINI 
        EndIf

        dbSelectArea("SBJ")
        dbSkip()
    
    EndDo

    dbSelectArea("SB9")
    dbSetOrder(1)
    If dbSeek(xFilial("SB9")+_cProduto+_cLocal+_dData,.f.)
        RecLock("SB9",.F.)
        SB9->B9_QINI    := _nQtde
        msUnLock()
    EndIf
    _nQtde := 0

    dbSelectArea("SBJ")

EndDo

Return
