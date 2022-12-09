#Include 'Protheus.ch'

#DEFINE GENERIC_REPORT_URL "http://localhost:8084/Filter/GenericReport/"

// Relat�rio de apontamento de primitivo
User Function Rel001()
	U_ThRpt(GENERIC_REPORT_URL + "1")
Return

// Commiss�o por representantes anal�tico
User Function Rel002()
	Local cUsrInfo := ""
	Local oUsr
	
	oUsr := UserControl():New()
	
	dbSelectArea("ZZC")
	dbSetOrder(1)
	dbSeek(xFilial() + oUsr:GetUserCode())
	
	cUsrInfo := "?args=" + AllTrim(Encode64("F2_VEND10011:" + AllTrim(ZZC->ZZC_VEND)))
	
	U_ThRpt(GENERIC_REPORT_URL + "2" + cUsrInfo)
Return

// Comiss�o por representantes resumido
User Function Rel003()
	U_ThRpt(GENERIC_REPORT_URL + "3")
Return

// Comiss�o por representantes anal�tico com quebra de p�gina
// Falta implementar
User Function Rel004()
	U_ThRpt(GENERIC_REPORT_URL + "4")
Return

// Controle de log
// Falta implementar
User Function Rel005()
	U_ThRpt(GENERIC_REPORT_URL + "5")
Return