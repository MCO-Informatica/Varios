#include 'protheus.ch'
/*Atribuição do objeto do Json com a classe*/

User Function atribJson(oObj,cNomTag)

	Local oJson
	Local oJsoD
	Local oObD
	Local aObD := {}

	Local cOri := ''
	Local cDes := ''
	Local aJsoD := {}
	Local cOrD := ''
	Local cDeD := ''
	Local nP := 0
	Local nO := 0

	oJson := JsonObject():new()
	oJsoD := JsonObject():new()
	cOri := 'oObj:'+lower(cNomTag)
	cDes := 'oJson["'+lower(cNomTag)+'"]'

	if ValType(&cOri) == "A"
		For nP := 1 to len(&cOri)
			Aadd(aJsoD,JsonObject():new())
			oObD := &(cOri+"["+str(nP)+"][1]")
			aObD := ClassDataArr(oObD)
			For nO := 1 to len(aObD)
				cOrD := 'oObD:'+lower(aObD[nO,1])
				cDeD := 'aJsoD['+str(nP)+',"'+lower(aObD[nO,1])+'"]'
				&cDeD := &cOrD
			next nO
		Next nP
		if !empty(cDeD)
			&cDes := aJsoD
		else
			&cDes := &cOri
		endif
	else
		&cDes := &cOri
	endif

Return &cDes
