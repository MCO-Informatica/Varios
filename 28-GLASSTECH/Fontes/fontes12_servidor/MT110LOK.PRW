
User Function MT110LOK
Local lRet := .T.

If Empty(cGrp)
	lRet := .F.
	Alert("Grupo de Produto não informado no cabeçalho, verifique.")
EndIf

Return lRet
