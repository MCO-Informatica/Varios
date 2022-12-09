#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE CRLF CHR(13)+CHR(10)

user function DBFCIHELPER()
Local _cFormat := "????????-????-????-????-????????????"
Local _cMsg := ""

If !IsInCallStack("U_CENTNFEXM")
	If (!Match(M->D1_FCICOD,_cFormat))
		_cMsg += "Código FCI informado difere do padrão definido pela legislação " + CRLF + CRLF
		_cMsg += "Valor Informado: " + M->D1_FCICOD + " " + CRLF + CRLF 
		_cMsg += "Padrão: " + _cFormat + " (8-4-4-4-12)" + CRLF + CRLF
		_cMsg +=" Exemplo: ABC123SQ-12DS-N64S-N3DS-ABC123456QED " + CRLF + CRLF 
	EndIf
	
	If !Empty(_cMsg)
		Alert(_cMsg, "FCI fora do padrão")
		return .F.
	EndIf
EndIf

return .T.