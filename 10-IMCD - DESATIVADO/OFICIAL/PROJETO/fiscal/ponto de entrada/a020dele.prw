//ponto de entrada para excluir item contabil na exclusao do fornecedor

User Function A020DELE() 

LOCAL URET := .T. 

IF cEmpAnt <> '02'
	URET := .T.  

	dbselectarea("CTD")
	dbsetorder(1)
	dbgotop()
	dbseek("  " + ("F" + SA2->A2_COD + SA2->A2_LOJA) )

	IF !Empty(CTD->CTD_ITEM)
		RecLock("CTD", .F.)
		dbDelete()
		MsUnLock()
	Endif   

	dbclosearea("CTD")
ENDIF

return(URET)