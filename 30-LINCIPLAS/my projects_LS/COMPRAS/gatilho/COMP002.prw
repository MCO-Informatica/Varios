#Include "PROTHEUS.CH"

User Function COMP002()  

Local aArea	:= GetArea()

Local _nPDesc  	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_PDESC" })
Local _nQtde  	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_QUANT" })
Local _nPreco	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_PRECO" })
Local _nTotal	:= aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_TOTAL" })
Local _nVDesc	:= 0

DbSelectArea("SA2")
SA2->( Dbseek(xFilial("SA2")+SB1->B1_PROC+SB1->B1_LOJPROC) )
_nPeDesc := SA2->A2_PDESC

//_nPeDesc := (((SB1->B1_PRV2 - SB1->B1_UPRC) / SB1->B1_PRV2)*100)

_nVDesc := ((SB1->B1_PRV2*_nPeDesc)/100)

aCols[n,_nPreco] := SB1->B1_PRV2 - _nVDesc
aCols[n,_nTotal] := aCols[n,_nPreco]*aCols[n,_nQtde]
aCols[n,_nPDesc] := _nPeDesc
aCols[n,_nTotal] := aCols[n,_nPreco]*aCols[n,_nQtde] 					

RestArea(aArea)

Return(aCols[n,_nPreco])