#Include "PROTHEUS.CH"

User Function RCFG001()

_lRet := .F.


dbSelectArea("MHH")
dbSetOrder(1)
If dbSeek(SB4->B4_FILIAL+SB4->B4_COD,.F.)
    If MHH->MHH_FLAG$"1"
        _lRet := .T.
    else
        _lRet := .F.
    EndIf

else
    _lRet := .F.
Endif

//ALERT(SB4->B4_COD+SB4->B4_DESC)

Return(_lRet)