#include "PROTHEUS.CH"

User Function MT103IPC()

Local n1         := paramixb[1]
Local _nPosCONT	 := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_XCONTRA"})
Local _nPosAplic := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_NATURE"})

aCols[n1,_nPosCONT]  := SC7->C7_XCONTRA
aCols[n1,_nPosAplic] := SC7->C7_NATURE

Return(.F.)