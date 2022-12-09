#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³A440BUT   ³ Autor ³ Eneovaldo Roveri Juni ³ Data ³20/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Adicionar botões para consulta                              ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function A440BUT()
	Local aBotao := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "A440BUT" , __cUserID )
aBotao :={ {'PENDENTE' ,{|| U_A440BT01()},"Licenças BUT"} }
	//aadd(aBotoes,{'PENDENTE' ,{|| U_A440BT01()},"Licenças"})
	//aadd(aBotoes,{'PRODUTO' ,{|| ConProd()},"Estoques" })
	//aadd(aBotoes,{'PRECO' ,{|| ConPrec()},"Pr. Custos"})

Return(aBotao)


Static Function ConProd()
	Local nPProd  := 0
	Local nPLocal := 0
	Local cProduto:= ""
	Local cLocal
	nPProd  := aScan(aHeader,{ |x| Alltrim(x[2])=="C6_PRODUTO"})
	nPLocal := aScan(aHeader,{ |x| Alltrim(x[2])=="C6_LOCAL"})

	If nPProd > 0
		cProduto := aCols[n][nPProd]
	endif
	If nPLocal > 0
		cLocal := aCols[n][nPLocal]
	Endif

	U_CFAT010(cProduto,cLocal)

return( .T. )   


Static Function ConPrec()
	Local nPProd  := 0
	Local cProduto:= ""
	Local aArea:= GetArea()

	nPProd  := aScan(aHeader,{ |x| Alltrim(x[2])=="C6_PRODUTO"})
	If nPProd > 0
		cProduto := aCols[n][nPProd]
	endif

	U_AFAT024(cProduto)

	RestArea(aArea)
return( .T. )