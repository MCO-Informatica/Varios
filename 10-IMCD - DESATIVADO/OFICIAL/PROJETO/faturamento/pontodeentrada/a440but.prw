#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �A440BUT   � Autor � Eneovaldo Roveri Juni � Data �20/11/2009���
�������������������������������������������������������������������������Ĵ��
���Descricao �Adicionar bot�es para consulta                              ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function A440BUT()
	Local aBotao := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "A440BUT" , __cUserID )
aBotao :={ {'PENDENTE' ,{|| U_A440BT01()},"Licen�as BUT"} }
	//aadd(aBotoes,{'PENDENTE' ,{|| U_A440BT01()},"Licen�as"})
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