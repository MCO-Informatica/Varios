#include "rwmake.ch"

//ok fonte


User Function RESTA03()

Processa({|| AJUSTA()},"@AJUSTANDO SBJ")
Return

Static Function AJUSTA()

dbSelectArea("SB8")
dbSetOrder(1)
dbGoTop()

While Eof() == .f. 

    IncProc("Processando Saldos Por Lote "+StrZero(Recno(),10))
    
    dbSelectArea("SBJ")
    RecLock("SBJ",.T.)
        SBJ->BJ_COD     :=  SB8->B8_PRODUTO
        SBJ->BJ_LOCAL   :=  SB8->B8_LOCAL
        SBJ->BJ_DATA    :=  CTOD("02/06/2022")
        SBJ->BJ_QINI    :=  SB8->B8_SALDO
        SBJ->BJ_LOTECTL :=  SB8->B8_LOTECTL
        SBJ->BJ_DTVALID :=  SB8->B8_DTVALID
    msUnLock()

    dbSelectArea("SB8")
    dbSkip()

EndDo

Return
