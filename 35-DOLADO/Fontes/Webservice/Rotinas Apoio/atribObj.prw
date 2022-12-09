#include 'protheus.ch'
/*Atribuição de uma classe com o Json*/

User Function atribObj(oJson,oObj)
	Local nI := 0
	Local nX := 0
	Local aJson := {}
	Local cTag := ""
	Local cDest := ""
	Local oObjA

	aJson := oJson:GetNames()
	for nI := 1 to len( aJson )
		cTag := aJson[nI]
		if valtype(oJson[cTag]) == "A"
			cDest := 'oObj:'+ctag
			for nX := 1 to len( oJson[cTag] )
				oObjA := &(cTag+'():new()')
				u_atribObj(oJson[cTag][nX],@oObjA)
				aadd(&cDest, oObjA )
			Next
		else
			cDest := 'oObj:'+ctag
			&cDest := oJson[cTag]
		endif
	next

return
