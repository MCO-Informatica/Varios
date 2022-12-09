#include 'protheus.ch'
#include 'parmtype.ch'

user function zVldSZ4()

	Local aCOLS		:= {}
	Local nI 		:= 0
	Local cItemConta
	Local cMensagem := ""
	
	cItemConta :=  AScan(aHeader,{|x| Trim(x[2])=="Z4_ITEMCTA"})
		
	
	For nI := 1 To Len( aCOLS )

		If aCOLS[nI,Len(aHeader)+1]
			Loop
		Endif

		AAdd( aCols, cItemConta )
		
		cMensagem += "aCOLS[nI] = " + cValToChar( aCols[nI] ) + CRLF

		//nTotal += Round( aCOLS[ nI, nTDespes ] , 2 )

	Next nI
	
	msginfo ( cMensagem )
	
return