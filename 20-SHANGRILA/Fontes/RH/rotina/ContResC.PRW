#INCLUDE "PROTHEUS.CH"

USER FUNCTION CONTRESC()
Local CRET:= ""

SRR->(DbSetorder(10))
If SRR->(DbSeek(SRZ->RZ_FILIAL+SRZ->RZ_MAT+SRZ->RZ_PD+"R"+Str(SRZ->RZ_VAL,12,2)))
	If MESANO(SRR->RR_DATA)== MESANO(DDATABASE)
		If Alltrim(SRR->RR_TIPO3) == "R"
			cRet := SRV->RV_ZCRESCI
		Else
			cRet := SRV->RV_ZCFOLHA
		EndIf
	Else
		cRet := SRV->RV_ZCFOLHA
	Endif	
Elseif SRR->(DbSeek(SRZ->RZ_FILIAL+SRZ->RZ_MAT+SRZ->RZ_PD+"F"+Str(SRZ->RZ_VAL,12,2)))
   		If MESANO(SRR->RR_DATA)== MESANO(DDATABASE)
			If Alltrim(SRR->RR_TIPO3) == "F"
				cRet := SRV->RV_ZCFERIA
			Else
				cRet := SRV->RV_ZCFOLHA
			EndIf
		Else
			cRet := SRV->RV_ZCFOLHA
		Endif
Else
	cRet := SRV->RV_ZCFOLHA
Endif

RETURN(cRet)