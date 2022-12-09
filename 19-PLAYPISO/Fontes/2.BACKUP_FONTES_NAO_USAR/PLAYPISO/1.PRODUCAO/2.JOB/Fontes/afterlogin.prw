#INCLUDE "protheus.ch"

User Function AfterLogin()

	If GetMv("MV_XDIA") < DtoS(Date())
		
		U_LJOB001() //1 job que roda 1 vez por mes
		PutMv("MV_XDIA",DtoS(Date()))

EndIf


