#Include 'Protheus.ch'

#DEFINE SERVER_PATH_URL "http://thtotvs:8084/"

User Function ConSep()
	Local oUsr
	
	oUsr := UserControl():New()
	
	cUsrInfo := "?args=" + AllTrim(Encode64("Usuario:" + AllTrim(oUsr:GetUserCode())))
	
	U_ThRpt(SERVER_PATH_URL + "Separacao" + cUsrInfo)
Return

