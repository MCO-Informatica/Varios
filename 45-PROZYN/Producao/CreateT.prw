#include "tbiconn.ch"
User Function CreateT()
	Local aTabs := {'ZA2','ZA3'}
	Local nA as numeric
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	for nA := 1 to len(aTabs)
	DbSelectArea(aTabs[nA])
	If SELECT(aTabs[nA]) > 0
		CONOUT("Tabela "+aTabs[nA]+" criada com sucesso!")
	Else
		CONOUT("Tabela "+aTabs[nA]+" não foi criada corretamente.")
	EndIf
	Next nA
    RESET ENVIRONMENT
Return
