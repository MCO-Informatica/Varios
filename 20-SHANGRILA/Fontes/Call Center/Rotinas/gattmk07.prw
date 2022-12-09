#Include "RwMake.Ch"

//========================================================================================================================================================
//Nelson Hammel - 05/09/11 - Gatilho para atualizar datas de entrega dos itens conforme cabeçalho
//========================================================================================================================================================

User Function GATTMK07()      

//MSExecAuto({|x,y| TMKA271(x,y)},"000018",4)


Local xPosDTENTRE := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_DTENTRE"})
Local xDtEntre:=M->UA_ENTREGA

//If !Inclui

	For c:=1 to Len(Acols)
		If acols[c,Len(aCols[c])] == .F.
			Acols[c,xPosDTENTRE]:=xDtEntre
			GDFIELDPUT("UB_DTENTRE",xDtEntre,C)
		Endif
	Next

//EndIf

Return(xDtEntre)
