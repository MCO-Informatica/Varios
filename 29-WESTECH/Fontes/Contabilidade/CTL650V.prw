#INCLUDE "PROTHEUS.CH"
/////////////////////////////////////////////////////////////
//Função  para tratamento de contrato no LP 650 - 119 e 120
/////////////////////////////////////////////////////////////

User Function CTL650V()                                                                                                                                                                                             
	local nValor 
	local ncnt
	local ncnt1
	
nValor:=0
	
IF (SUBSTR(SD1->D1_ITEMCTA,1,2) $ "AT/EQ/ST/GR/PR/EN" )  .and. (!SUBS(SD1->D1_CF,2,3)$'925/924/921/920/916/915/913/912/906/903/902/949').and. SD1->D1_RATEIO == "2" .and. !SA2->A2_COD $"000005/000593" .AND. SD1->D1_II ==0
		ncnt := SD1->(D1_TOTAL+D1_VALIPI+D1_VALFRE+D1_DESPESA+D1_ICMSRET)
	If SD1->D1_ICMSRET<>0	
		ncnt1:= SD1->(D1_VALIPI+D1_VALIMP5+D1_VALIMP6)					
		nValor:= (ncnt-ncnt1)
	Else
		ncnt1:= SD1->(D1_VALIPI+D1_VALICM+D1_VALIMP5+D1_VALIMP6)						
		nValor:= (ncnt-ncnt1)		
	EndIf
EndIF

Return (nValor)                      


