#include 'protheus.ch'
#include 'parmtype.ch'


User Function VLDSB1()
local cProduto := IIF(FUNNAME()=='MATA010',m->b1_cod,aCols[n,2])
Local CCentroC 

IF SUBSTR(cProduto,1,4)=="W000"
    CCentroC := "100301"
ELSEIF SUBSTR(cProduto,1,4)=="F000"
    CCentroC := "100302"
end 


RETURN(CCentroC)

