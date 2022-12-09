//ponto de entrada para excluir item contabil na exclusao do cliente


User Function M030DEL()    

IF cEmpAnt <> '02'     
	URET := .T. 

	dbselectarea("CTD")
	dbsetorder(1)
	dbgotop()
	dbseek("  " + ("C" + SA1->A1_COD + SA1->A1_LOJA) )

	IF !Empty(CTD->CTD_ITEM)
		RecLock("CTD", .F.)
		dbDelete()
		MsUnLock()
	Endif   

	dbclosearea("CTD")  
ENDIF	

return(URET)