#include "protheus.ch"
#include "topconn.ch"

User Function F450SE5()


cQuery := " UPDATE "+ RetSQLName("SE5")+ " "
cQuery := cQuery + "  SET E5_DATA = E5_DTDISPO "
cQuery := cQuery + "  WHERE E5_DATA = '' "
	
TCSQLExec(cQuery)


Return()