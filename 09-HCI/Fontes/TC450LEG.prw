#INCLUDE "PROTHEUS.CH"
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?TC450LEG  ?Autor  ?Alexandre Circenis  ? Data ?  02/26/15   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? PE para alterar as cores da legenda na rotina de Ordem de  ???
???          ? Servi?o                                                    ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
user function TC450LEG()
Local aCores :={}  
Local nX
Local aCorAux := ParamIXB
Aadd(aCores, { 'BR_AZUL', "Pre Ordem de Servi?o" })	
for nX := 1 to Len(aCorAux)
	Aadd(aCores , aCorAux[nX]) 
next
Return aCores
