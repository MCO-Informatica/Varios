                      
#DEFINE CRLF CHR(13)+CHR(10)

USER FUNCTION DBVFVRE()
Local _cRet := .F.                        
Local _cMsg := ""

If (M->UA_VQ_FVER!="N")
	_cRet := .T.                                                                                                  	
Else
	_cMsg += "Informe o valor do frete real "    + CRLF    + CRLF    
	_cMsg += "O Valor do frete real é o valor definido entre o vendedor e a transportadora" + CRLF    
	MsgInfo(_cMsg)     
	_cRet := .F.                  
EndIf                                 



RETURN _cRet