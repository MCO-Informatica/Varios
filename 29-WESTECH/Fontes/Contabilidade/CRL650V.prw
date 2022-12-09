#INCLUDE "PROTHEUS.CH"

User Function CRL650V()                                                                                                                                                                                             
	local nValor 

nValor:=0

IF (SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN" ) .and. (!SUBS(SD1->D1_CF,2,3)$'925/924/921/920/916/915/913/912/906/903/902/949') .and. SD1->D1_RATEIO == "2" .and. !SA2->A2_COD $"000005/000593"  .AND. SD1->D1_II ==0
		nValor:= SD1->(D1_TOTAL+D1_ICMSRET+D1_VALIPI-D1_VALIRR-D1_VALISS-D1_VALINS-D1_VALPIS-D1_VALCOF-D1_VALCSL)//SF1->((F1_VALBRUT-F1_IRRF-F1_ISS-F1_INSS-F1_VALPIS-F1_VALCOFI-F1_VALCSLL))		                        
EndIf      

Return(nValor)
