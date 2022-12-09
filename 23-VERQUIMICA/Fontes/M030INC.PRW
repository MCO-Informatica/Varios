User Function M030INC()
Local _cVends := ""
If !(PARAMIXB == 3)	
	_cVends := U_vAtuCliZ12(SA1->A1_COD,SA1->A1_LOJA, SA1->A1_REGIAO, SA1->A1_GRPVEN) 
	DbSelectArea("SA1");DbSetOrder(1)
	If SA1->(DbSeek(xFilial("SA1")+SA1->(A1_COD+A1_LOJA)))
		RecLock("SA1",.F.)
			SA1->A1_VQ_VEND := _cVends
		MsUnlock()
	End
EndIf	      
Return