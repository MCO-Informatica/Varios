#INCLUDE "PROTHEUS.CH"

USER FUNCTION CONTRESD()
Local CRET:= ""
Local cCC := SubStr(SRZ->RZ_CC,1,5)
Local cCCt := SubStr(SRZ->RZ_CC,1,3)

/*If SRZ->RZ_MAT $ ("000780") .AND. SRZ->RZ_PD = "005" //"000891"
	Alert ("Entrou")
EndIf*/

SRR->(DbSetorder(10))
If SRR->(DbSeek(SRZ->RZ_FILIAL+SRZ->RZ_MAT+SRZ->RZ_PD+"R"+Str(SRZ->RZ_VAL,12,2)))
	If MESANO(SRR->RR_DATA)== MESANO(DDATABASE)
		If Alltrim(SRR->RR_TIPO3) == "R"
			SRV->(DbSetOrder(1))
			If SRV->(DbSeek(xFilial("SRV")+SRZ->RZ_PD))
				If cCC == "30001"
					cRet := SRV->RV_ZDRSCOM
				Elseif cCC == "30002"
					cRet := SRV->RV_ZDRSADM
				ElseIf cCCt == "400"
					cRet := SRV->RV_ZDRSLOG
				ElseIf cCCt == "500"
					cRet := SRV->RV_ZDRSPRO
				EndIf
			EndIf
		Else
			SRV->(DbSetOrder(1))
			If SRV->(DbSeek(xFilial("SRV")+SRZ->RZ_PD))
				If cCC == "30001"
					cRet := SRV->RV_ZDFPCOM
				Elseif cCC == "30002"
					cRet := SRV->RV_ZDFPADM
				ElseIf cCCt == "400"
					cRet := SRV->RV_ZDFPLOG
				ElseIf cCCt == "500"
					cRet := SRV->RV_ZDFPPRO
				EndIf
			EndIf
		EndIf
	Else
		SRV->(DbSetOrder(1))
			If SRV->(DbSeek(xFilial("SRV")+SRZ->RZ_PD))
				If cCC == "30001"
					cRet := SRV->RV_ZDFPCOM
				Elseif cCC == "30002"
					cRet := SRV->RV_ZDFPADM
				ElseIf cCCt == "400"
					cRet := SRV->RV_ZDFPLOG
				ElseIf cCCt == "500"
					cRet := SRV->RV_ZDFPPRO
				EndIf
			EndIf
	Endif	
Elseif SRR->(DbSeek(SRZ->RZ_FILIAL+SRZ->RZ_MAT+SRZ->RZ_PD+"F"+Str(SRZ->RZ_VAL,12,2)))
	   	If MESANO(SRR->RR_DATA)== MESANO(DDATABASE)
			If Alltrim(SRR->RR_TIPO3) == "F"
				SRV->(DbSetOrder(1))
				If SRV->(DbSeek(xFilial("SRV")+SRZ->RZ_PD))
					If cCC == "30001"
						cRet := SRV->RV_ZDFECOM 
					Elseif cCC == "30002"
						cRet := SRV->RV_ZDFEADM
					ElseIf cCCt == "400"
						cRet := SRV->RV_ZDFELOG
					ElseIf cCCt == "500"
						cRet := SRV->RV_ZDFEPRO
					EndIf
				Endif
			Endif		
		Else
			SRV->(DbSetOrder(1))
			If SRV->(DbSeek(xFilial("SRV")+SRZ->RZ_PD))
				If cCC == "30001"
					cRet := SRV->RV_ZDFPCOM
				Elseif cCC == "30002"
					cRet := SRV->RV_ZDFPADM
				ElseIf cCCt == "400"
					cRet := SRV->RV_ZDFPLOG
				ElseIf cCCt == "500"
					cRet := SRV->RV_ZDFPPRO
				EndIf
			EndIf
		EndIf
Else
	SRV->(DbSetOrder(1))
	If SRV->(DbSeek(xFilial("SRV")+SRZ->RZ_PD))
		If cCC == "30001"
			cRet := SRV->RV_ZDFPCOM
		Elseif cCC == "30002"
			cRet := SRV->RV_ZDFPADM
		ElseIf cCCt == "400"
			cRet := SRV->RV_ZDFPLOG
		ElseIf cCCt == "500"
			cRet := SRV->RV_ZDFPPRO
		EndIf
	Endif
Endif

RETURN(cRet)