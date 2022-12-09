User Function VQGD1UNI()
Local _nRet := 0

If !IsInCallStack("U_CENTNFEXM")
	If INCLUI
	    _nRet := IIF(M->D1_QTSEGUM==0,0,M->D1_TOTAL/M->D1_QTSEGUM)                                                   
	Else
	    _nRet := IIF(SD1->D1_QTSEGUM==0,0,SD1->D1_TOTAL/SD1->D1_QTSEGUM)                                                   
    EndIf
EndIf

Return _nRet