#Include "Protheus.CH"
#Include "RwMake.CH"
#Include "TopConn.CH"

User Function TMK260() 
    
	Local _cObs	:= ""
	
	_cObs := "===========================================" +CRLF
	_cObs += "[" + SubStr(DtoS(dDataBase),7,2) + "/" + SubStr(DtoS(dDataBase),5,2) + "/" + SubStr(DtoS(dDataBase),1,4) + " - " + time() + "]"+CRLF
	_cObs += "[ Usuario - " + UsrFullName(__cUserID) + " ]" +CRLF
	_cObs += AllTrim(SUS->US_XOBSDIA)+CRLF
	_cObs += "===========================================" +CRLF
	
	If INCLUI
		If RecLock("SUS",.F.)
			SUS->US_XHISTOR	:= _cObs
			SUS->US_XOBSDIA	:= ""
			SUS->(MsUnLock())
		EndIf
	EndIf

Return .T.