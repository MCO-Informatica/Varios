User Function PCADHEAD()
aDet := {}   
For nX := 1 To Len(ParamIxb)   
	If nx == 6                           
		Aadd(aDet, RetTitle('C7_TOTAL'))
		Aadd(aDet, RetTitle('C7_VLDESC'))  
		Aadd(aDet, ParamIxb[nX])
	Else 
		Aadd(aDet, ParamIxb[nX])
	EndIf
Next
Return(aDet)