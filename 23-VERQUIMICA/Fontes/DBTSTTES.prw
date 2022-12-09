#include 'protheus.ch'
#include 'parmtype.ch'

user function DBTSTTES()
	/****utilizando no aCols ******/
	If ExistTrigger('D1_TES') 
	// verifica se existe trigger para este campo      
	RunTrigger(2,nLin,nil,,'D1_TES')
	
	Endif	
return