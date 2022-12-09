User Function XVLDMTADS()
Local lRet := .T.   
             
If MV_PAR04 == 1
	Alert("Devido a problema com marcação, a opção TRAZER PEDIDOS MARCADOS DEVE ESTAR COMO NÃO! Altere e prossiga")
	lRet := .F.
EndIf

Return lRet