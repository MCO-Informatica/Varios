#Include 'Protheus.ch'

User Function F450OWN1()
Local cString := ""

//#IFDEF TOP // Ambiente em TOPCONNECT

cString := "E2_FILIAL = '" + cFilial + "' .AND. " 
cString += "E2_VENCREA >= '" + DTOS(dVenIni450) + "' .AND. " 
cString += "E2_VENCREA <= '" + DTOS(dVenFim450) + "' .AND. " 

cString += "E2_MOEDA = " + Alltrim(Str(nMoeda,2)) + " .AND. "    
cString += "E2_SALDO > 0 "

//#ENDIF

ALERT("F450OWN1 - PAGAR")
ALERT(CSTRING)

Return( cString )