#Include "Totvs.ch"
User Function VLDA1CEP() 
Local _lRet := .T.
__cCep := alltrim(M->A1_CEP)
__cCep := StrTran(__cCep,"-","")
If len(__cCep) < 8
    M->A1_CEP := (NIL)
    _lRet := .F.
Endif    

Return _lRet

User Function VLA1CEPC() 
Local _lRet := .T.
__cCep := alltrim(M->A1_CEPC)
__cCep := StrTran(__cCep,"-","")
If len(__cCep) < 8
    M->A1_CEPC := (NIL)
    _lRet := .F.
Endif    

Return _lRet

User Function VLA1CEPE() 
Local _lRet := .T.
__cCep := alltrim(M->A1_CEPE)
__cCep := StrTran(__cCep,"-","")
If len(__cCep) < 8
    M->A1_CEPE := (NIL)
    _lRet := .F.
Endif    

Return _lRet

User Function VLDA2CEP() 
Local _lRet := .T.
__cCep := alltrim(M->A2_CEP)
__cCep := StrTran(__cCep,"-","")
If len(__cCep) < 8
    M->A2_CEP := (NIL)
    _lRet := .F.
Endif    

Return _lRet
