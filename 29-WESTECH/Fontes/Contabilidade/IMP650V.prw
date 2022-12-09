#INCLUDE "PROTHEUS.CH"

User Function IMP650V()                                                                                                                                                                                             
	local nValor 

nValor:=0

IF (SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN/ES" ) .and. SD1->D1_TES $'300/301/302/305/309/310/311/312/313'
		nValor:= SD1->(D1_TOTAL+D1_DESPESA+D1_VALCMAJ+D1_VALPMAJ)//-D1_VALIMP5-D1_VALIMP6)//SF1->((F1_VALBRUT-F1_IRRF-F1_ISS-F1_INSS-F1_VALPIS-F1_VALCOFI-F1_VALCSLL))		                        
EndIf      


IF (!SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN/ES" ) .and. SD1->D1_TES $'300/301/302/305/309/310/311/312/313' 
		nValor:= SD1->(D1_TOTAL+D1_DESPESA+D1_VALIPI+D1_VALICM+D1_VALIMP5+D1_VALIMP6)//SF1->((F1_VALBRUT-F1_IRRF-F1_ISS-F1_INSS-F1_VALPIS-F1_VALCOFI-F1_VALCSLL))		                        
EndIf

IF (SD1->D1_TES $'304/306/307/308/314')
		nValor:= SD1->(D1_TOTAL+D1_DESPESA+D1_VALIPI+D1_VALICM+D1_VALIMP5+D1_VALIMP6)//SF1->((F1_VALBRUT-F1_IRRF-F1_ISS-F1_INSS-F1_VALPIS-F1_VALCOFI-F1_VALCSLL))		                        
EndIf                              

Return(nValor)