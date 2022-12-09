#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE CRLF CHR(13)+CHR(10)

user function DBFCIHELPER()
Local _cFormat := "????????-????-????-????-????????????"
Local _cMsg := ""

If !IsInCallStack("U_CENTNFEXM")
	If (!Match(M->D1_FCICOD,_cFormat))
		_cMsg += "C�digo FCI informado difere do padr�o definido pela legisla��o " + CRLF + CRLF
		_cMsg += "Valor Informado: " + M->D1_FCICOD + " " + CRLF + CRLF 
		_cMsg += "Padr�o: " + _cFormat + " (8-4-4-4-12)" + CRLF + CRLF
		_cMsg +=" Exemplo: ABC123SQ-12DS-N64S-N3DS-ABC123456QED " + CRLF + CRLF 
	EndIf
	
	If !Empty(_cMsg)
		Alert(_cMsg, "FCI fora do padr�o")
		return .F.
	EndIf
EndIf

return .T.