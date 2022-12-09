User Function TK271FIMGR()


If SUA->UA_OPER=="3" 
	
	If DTOS(SUA->UA_EMISSAO) < DTOS(dDataBase)
		Reclock("SUA",.f.)
		SUA->UA_EMISSAO	:=	dDataBase
		SUA->UA_ENTREGA	:=  (dDataBase+7)
		MsUnLock()
	EndIf
EndIf                                

Return()