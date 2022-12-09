#include "protheus.ch"
#include "rwmake.ch"

User Function PNM08001()
 
MsgInfo("Evento Provento: "+PARAMIXB[1]+CRLF+"Evento Desconto: "+PARAMIXB[2]+CRLF+"Data: "+ DTOC(PARAMIXB[5]) +CRLF+"Saldo: "+PARAMIXB[6]+CRLF+"Tp.Fech: "+PARAMIXB[7],"PE PNM08001")
 

If PARAMIXB[6] < 0
	PARAMIXB[6] := 0
EndIf

Return(Nil)