User Function PCADLINE ()  
aDet := {}   
For nX := 1 To Len(ParamIxb)   
	If nx == 6
		Aadd(aDet,TRANSFORM(C7_TOTAL, "@E 999,999,999.99")) 
		Aadd(aDet,TRANSFORM(C7_VLDESC, "@E 999,999,999.99"))
		Aadd(aDet, ParamIxb[nX])
	Else 
		Aadd(aDet, ParamIxb[nX])
	EndIf
Next
Return(aDet)  