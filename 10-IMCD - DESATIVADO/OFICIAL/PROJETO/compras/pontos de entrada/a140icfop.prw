User Function A140ICFOP()

	Local oXml := PARAMIXB[1]
	Local cTipoNF := "N"
	Local cMVBenCfop	:=  AllTrim(GetNewPar("MV_XMLCFBN",""))
	Local cMVDevCfop	:=  AllTrim(GetNewPar("MV_XMLCFDV",""))

	// compilar no rpo schedule para funcionar

	aItens := IIF(ValType(oXML:_InfNfe:_Det) == "O",{oXML:_InfNfe:_Det},oXML:_InfNfe:_Det)

	//if AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "4"
	For nX := 1 To Len(aItens)
		If aItens[nX]:_PROD:_CFOP:TEXT $ AllTrim(cMVBenCfop)
			cTipoNF := "B"
		elseIF  aItens[nX]:_PROD:_CFOP:TEXT $ AllTrim(cMVDevCfop)
			cTipoNF := "D"  
		else
			cTipoNF := "N"  
		endif

	Next nX
	//Endif


Return cTipoNF