#INCLUDE "protheus.ch"

User Function AfterLogin()

	If GetMv("MV_XDIA") < DtoS(Date())
		
		U_LJOB001() //1 job que roda 1 vez por mes
		//PutMv("MV_XDIA",DtoS(Date()))
		If SX6->(DbSeek(xFilial("SX6")+"MV_XDIA"))
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := DtoS(Date())
			SX6->(MsUnLock())
  		EndIf 

	EndIf


Return
