#INCLUDE 'PROTHEUS.CH'

User Function TK271ROTM()
Local nPMnuCpy := aScan(aRotina, {|x| x[2] == "TK271Copia"})
Local aRot := {} 

For nX := 1 To Len(aRotina)
	If nPMnuCPy <> nX
		Aadd(aRot, aRotina[nX])
	EndIf
Next nX

//aAdd( aRot, { 'Copiar Atendimento' ,'U_VQCPYTMK', 0 , 6 })
aAdd( aRot, { 'Orcamento Personalizado' ,'U_DBRCOTV', 0 , 7 })

aRotina := aRot
aRot := {}
Return aRot
