
User Function MT110LOK
Local lRet := .T.

If Empty(cGrp)
	lRet := .F.
	Alert("Grupo de Produto n?o informado no cabe?alho, verifique.")
EndIf

Return lRet
