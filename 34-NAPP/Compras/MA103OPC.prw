#Include "TOTVS.CH"

User Function MA103OPC()
	Local aOpc:={}

	aAdd(aOpc,{'*Habilita Contabiliza��o',"processa({||U_LPCTBNFE()}, '', 'Limpa CTB NFE', .f.)", 0, 4, 0, Nil })


Return(aOpc)



User Function LPCTBNFE()
	Local cSql := ""
	Local nStatus := 0

	cSql := "UPDATE "+RetSqlName("SF1")+" SF1 SET F1_DTLANC = ' ' WHERE R_E_C_N_O_ = "+STR(SF1->(RECNO()))
	nStatus := TCSqlExec(cSql)

	/*
    If nStatus < 0
		MsgAlert("A limpeza falhou","Aten��o")
	Else
    */
		MsgAlert("Habilitado com sucesso","Aten��o")
	//EndIf
    
Return Nil
