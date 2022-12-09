#INCLUDE "PROTHEUS.CH"

User Function MA512MNU()

IF cEmpAnt == '02'
	
	aadd(aRotina,{'Etiq de Saida',"U_ETAIFF04" , 0 , 2,0,NIL})
	aadd(aRotina,{'Etiq de Saida Esp',"U_ETAIFF04" , 0 , 2,0,NIL})
	aadd(aRotina,{'Etiq de Saida Manual',"U_ETAIFF10" , 0 , 2,0,NIL}) 
	
Endif

Return .T.
