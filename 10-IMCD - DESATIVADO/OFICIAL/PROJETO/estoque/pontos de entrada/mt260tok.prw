#INCLUDE "PROTHEUS.CH"

User Function MT260TOK()

Local lRet:= .T.
Default cDocto := ""

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT260TOK" , __cUserID )

If isInCallStack('DLGV001') ;
	.Or. isInCallStack('WMSA330');
	.Or. isInCallStack('WMSA331');
	.Or. isInCallStack('DLGA150') ;
	.OR. isInCallStack("WMSMOVEST") 
	Return .T.
EndIf

If Empty(cDocto)
	
	MsgInfo("Favor preencher o Número de Documento","Campo Obrigatório")
	
	lRet := .F.
Endif

Return lRet
