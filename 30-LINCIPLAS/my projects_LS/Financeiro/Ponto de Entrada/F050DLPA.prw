#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PA na exclus?o de contas a pagar - se for PA, apaga a movimenta??o financeira da inclus?o do PA
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F050DLPA()
////////////////////////

If SE2->E2_TIPO = 'PA'
	RecLock('SE5',.f.)
	DbDelete()        
	MsUnLock()
EndIf
Return(.t.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PA na exclus?o de contas a pagar - se for PA, apaga a movimenta??o financeira da exclus?o do PA
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F050EXCPA()
////////////////////////

If SE2->E2_TIPO = 'PA'
	DbDelete()
EndIf
Return()
