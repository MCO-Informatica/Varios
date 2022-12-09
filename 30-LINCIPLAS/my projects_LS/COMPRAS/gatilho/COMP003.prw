#Include "PROTHEUS.CH"

User Function COMP003()  

Local aArea	:= GetArea()

Local _nPrv2	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_PRV2" })
Local _nPreco	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_PRECO" })
Local _nPDesc  	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_PDESC" })
Local _nQtde  	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_QUANT" })
Local _nTotal	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_TOTAL" })
Local _nPeDesc	:= 0
Local _nVDesc	:= 0

_nPeDesc := (((aCols[ n, _nPrv2 ] - aCols[ n, _nPreco ]) / aCols[ n, _nPrv2 ])*100)

_nVDesc := ((aCols[n,_nPrv2]*aCols[n,_nPDesc])/100)

aCols[n,_nPreco] := aCols[n,_nPrv2] - _nVDesc
aCols[n,_nTotal] := aCols[n,_nPreco]*aCols[n,_nQtde]

RestArea(aArea)
                   
Return(aCols[n,_nPreco])                     


// C7_PDESC, C7_PRV1, C7_PRV2 não existem na tabela SC7... existem na SX3... alterei o X3_CONTEXT para VIRTUAL.
// este fonte não está no projeto
// é um gatilho no campo C7_PDESC, que no SX3 o campo X4_TRIGGER está vazio

// quem é o pai dessa criança?