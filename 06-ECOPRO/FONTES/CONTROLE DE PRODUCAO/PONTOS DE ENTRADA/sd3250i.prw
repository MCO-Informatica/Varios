#Include 'Protheus.ch'

User Function sd3250i()
	Local aArea := GetArea()

	if FunName() == "MATA250" .and. sc2->c2_sequen == '001' .and. sb1->b1_tipo = 'PA' 
		u_ecoa001(1)
	endif
	
	RestArea(aArea)

Return  Nil
