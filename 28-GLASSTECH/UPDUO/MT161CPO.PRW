#INCLUDE "PROTHEUS.CH"
 
User Function MT161CPO()
Local cNumero    := SC8->C8_NUM
Local aArea      := GetArea()
Local aPropostas := PARAMIXB[1] // Array com os dados das propostas dos Fornecedores
Local aItens     := PARAMIXB[2] // Array com os dados da grid "Produtos"
Local aCampos    := {"C8_XPRECO"} // Array com os campos adicionados na grid "Item da Proposta"
Local aCposProd  := {"C8_XPRECO"} // Array com os campos adicionados na grid "Produtos"
Local aRetorno   := {}
Local nX         := 0
Local nY         := 0
Local nZ         := 0
Local nCount     := 0
//Local aAux       := {}
//Local nC         := 0
 
For nX := 1 To Len(aPropostas)
    For nY := 1 To Len(aPropostas[nX])
        For nZ := 1 To Len(aPropostas[nX][nY][2])
            nCount++            
            AADD(aPropostas[nX][nY][2][nZ], Transform(Posicione("SC8",1,SC8->(C8_FILIAL+C8_NUM)+aPropostas[nX][nY][1][1]+aPropostas[nX][nY][1][2]+aPropostas[nX][nY][2][nZ][2]+aPropostas[nX][nY][2][nZ][12], "C8_XPRECO"),"@E 999,999,999.9999"))
        Next nZ
    Next nY
Next nX
 
For nX := 1 To Len(aItens)
//C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD 
    AADD(aItens[nX], Transform(Posicione("SC8",1,xFilial("SC8")+cNumero+aItens[nX][10]+aItens[nX][11]+aItens[nX][12]+aItens[nX][13]+Str(nX) , "C8_XPRECO"),"@E 999,999,999.9999"))
Next nX
/* 
aAux := aClone(aItens)

For nC := 1 to Len(aItens)

aItens[nC][4]   := aAux[nC][15]
aItens[nC][5]   := aAux[nC][16]
aItens[nC][15]  := aAux[nC][4]
aItens[nC][16]  := aAux[nC][5]

Next
*/
AADD(aRetorno, aPropostas)
AADD(aRetorno, aCampos)
AADD(aRetorno, aItens)
AADD(aRetorno, aCposProd)

//aAux := {}

RestArea(aArea)
 
Return aRetorno



/*	
User Function MT161PRO()

Local aPropostas := PARAMIXB[1]
Local aRet := aPropostas //{}

// Customizacoes diversas

Return aRet
*/
