#INCLUDE "PROTHEUS.CH"

User Function C650V()

	local nValor 
	local ncnt           

nCnt:=0

IF (!SUBS(SD1->D1_CF,2,3)$'925/924/921/920/916/915/913/912/906/903/902/949/'.and. SA2->A2_TIPO<>"X" .and. SA2->A2_COD <>"000005" .AND.SA2->A2_COD<>"000593" .and. !SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN" ) .and. SD1->D1_RATEIO == "2"  .AND. SD1->D1_II ==0

		ncnt:=	SD1->(D1_TOTAL-D1_VALIRR-D1_VALISS-D1_VALINS-D1_VALPIS-D1_VALCOF-D1_VALCSL)+SD1->D1_VALIPI   //SF1->((F1_VALBRUT-F1_IRRF-F1_ISS-F1_INSS-F1_VALPIS-F1_VALCOFI-F1_VALCSLL))
		nValor:= nCnt
Endif  
		                     				
Return nvalor
	