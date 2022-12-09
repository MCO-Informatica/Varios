#Include "Totvs.ch"
User Function VLDMAIL() 
Local __cEmail := ""
Local _lRet := .T.
__cEmail := alltrim(M->A1_EMAIL)
If .not. ISEMAIL(__cEmail)
    M->A1_EMAIL := (NIL)
    _lRet := .F.
Endif    
