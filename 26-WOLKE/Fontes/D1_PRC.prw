#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

User Function D1PRC() 
Local aAreaAtu 	:= GetArea()
Local nValor := 0
Local nPosCol

nPosCol := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))== "DA1_CODPRO"})
nValor := aCols[N][nPosCol]
            
RestArea(aAreaAtu)
return(nValor)                     
