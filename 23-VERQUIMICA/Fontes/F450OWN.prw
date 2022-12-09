#Include 'Protheus.ch'

User Function F450OWN1() 

Local cString := "" 

cString := "E2_FILIAL = '" + xFilial("SE2") + "' AND " 
cString += "E2_VENCREA >= '" + DTOS(dVenIni450) + "' AND " 
cString += "E2_VENCREA <= '" + DTOS(dVenFim450) + "' AND " 
cString += "E2_MOEDA = " + Alltrim(Str(nMoeda,2)) + " AND " 
cString += "E2_SALDO > 0 AND "
cString += "E2_FORNECE='" + cFor450 + "' AND "
cString += "D_E_L_E_T_ <> '*' "
If !Empty(cLjFor)
	cString += "And E2_LOJA='" + cLjFor + "'"
Endif

Return( cString )


/***************************************************************************************/

User Function F450OWN()

Local cString := ""

cString := "E1_FILIAL = '" + xFilial("SE1") + "' AND " 
cString += "E1_VENCREA >= '" + DTOS(dVenIni450) + "' AND " 
cString += "E1_VENCREA <= '" + DTOS(dVenFim450) + "' AND "
If mv_par03 == 2
	cString += "E1_SITUACA IN('0','F','G') AND "
Endif 
cString += "E1_MOEDA = " + Alltrim(Str(nMoeda,2)) + " AND "
cString += "E1_SALDO > 0 AND "
cString += "E1_CLIENTE ='" + cCli450 + "' AND "
cString += "D_E_L_E_T_ <> '*' "
If !Empty(cLjCli)
	cString += " AND E1_LOJA = '" + cLjCli + "'"
Endif

Return( cString )
