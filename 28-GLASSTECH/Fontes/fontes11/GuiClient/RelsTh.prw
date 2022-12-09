#Include 'Protheus.ch'

#DEFINE GENERIC_REPORT_URL "http://localhost:8084/Filter/GenericReport/"

// Relatório de apontamento de primitivo
User Function Rel001()
	U_ThRpt(GENERIC_REPORT_URL + "1")
Return

// Commissão por representantes analítico
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

// Comissão por representantes resumido
User Function Rel003()
	U_ThRpt(GENERIC_REPORT_URL + "3")
Return

// Comissão por representantes analítico com quebra de página
// Falta implementar
User Function Rel004()
	U_ThRpt(GENERIC_REPORT_URL + "4")
Return

// Controle de log
// Falta implementar
User Function Rel005()
	U_ThRpt(GENERIC_REPORT_URL + "5")
Return