User Function XVLDMTADS()
Local lRet := .T.   
             
If MV_PAR04 == 1
	Alert("Devido a problema com marca��o, a op��o TRAZER PEDIDOS MARCADOS DEVE ESTAR COMO N�O! Altere e prossiga")
	lRet := .F.
EndIf

Return lRet