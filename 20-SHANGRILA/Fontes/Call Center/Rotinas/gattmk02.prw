
#Include "RwMake.Ch"

//========================================================================================================================================================
//Nelson Hammel - 27/07/11 - Rotina para validar quantidade vendida
//========================================================================================================================================================

User Function GATTMK02()  

Local xMensagem := ""
Local xPosQuant := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_QUANT"})
Local xPosProd 	:= aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_PRODUTO" })
Local xQtdEmb 	:= Posicione("SB5",1,xFilial("SB5")+aCols[N,xPosProd],"B5_QE1")
Local xQtdVen 	:= aCols[N,xPosQuant]

//==========================================================================================================================================================
//Valida linhas excluidas
If acols[n,Len(aCols[n])] == .T.
Return()     
EndIf
 
If xQtdEmb > 0
		If xQtdVen < xQtdEmb
			ApMsgAlert("O valor informado é MENOR que a quantidade minima ( "+Alltrim(Str(xQtdEmb))+" ) para a venda desse produto!") 
		Else
			xResto := xQtdVen % xQtdEmb
			If xResto > 0
				ApMsgAlert("O valor informado não é Multiplo da quantidade minima ( "+Alltrim(Str(xQtdEmb))+" ) para a venda desse produto!") 
			EndIf
		EndIf
EndIf
Return(xQtdVen)
