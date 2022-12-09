// Ponto de Entrada para consulta de produto
User Function TMKVCA()
	Local aArea:= GetArea()
	Local nPProd  := 0
	Local nPLocal := 0
	Local cProduto:= ""

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "TMKVCA" , __cUserID )

	nPProd  := aScan(aHeader,{ |x| Alltrim(x[2])=="UB_PRODUTO"})

	If nPProd > 0
		cProduto := aCols[n][nPProd]
	endif


	U_CFAT010(cProduto)

	RestArea(aArea)
Return( .T. )