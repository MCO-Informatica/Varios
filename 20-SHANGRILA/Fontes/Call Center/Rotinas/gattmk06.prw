#Include "RwMake.Ch"

//========================================================================================================================================================
//Nelson Hammel - 05/09/11 - Rotina para preencher automaticamene o pedido de vendas do cliente conforme linha acima
//========================================================================================================================================================

User Function GATTMK06()  

Local xPosPVend := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_PEDVEND"})
Local xPedVend:=""
                    
If acols[n,Len(aCols[n])] == .F.
              
If N>1              
	xPedVend:=Acols[n-1,17]
	Acols[n,17]:=xPedVend
	GDFIELDPUT("UB_PEDVEND",xPedVend,n)
Endif

EndIf
Return(xPedVend)
