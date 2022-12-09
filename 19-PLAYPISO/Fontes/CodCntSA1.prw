#Include "Protheus.ch"

User Function CodCntSA1()
	Local cRet := ""

	If n == 1
		cRet := "000001"
        n++
	Else
		cRet := StrZero(n,6)
        n++
	EndIf

Return cRet
