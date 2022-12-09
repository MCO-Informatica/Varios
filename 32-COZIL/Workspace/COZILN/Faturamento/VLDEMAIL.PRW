#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "Protheus.ch"
User Function CVLDEMAIL() 
Local _lRet := .T.
__cEmail := alltrim(lower(M->A1_EMAIL))
If ISEMAIL(__cEmail) == .F.
    _lRet := .F.
Endif    
