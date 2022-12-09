#INCLUDE "PROTHEUS.CH"

Static aFuncCS := {}

/*/{Protheus.doc} CSRH070()
Rotina para realizar manuten��es nas tabelas do portal do ponto, pois a rotina n�o possui ponto de entrada ap�s processamento.
@type function

@author Bruno Nunes.
@since 28/08/2017
@version P11.5

@return
/*/
User Function CSRH070()
	PONM060()
	Processa({|| ProcPB7()},"Atualizando Tabelas do Portal do Ponto")
Return

/*/{Protheus.doc} PNM060SRA()
Ponto de entrada dentro da rotina de abono coletivo, guarda em array filial e matricula do funcion�rio processado
@type function

@author Bruno Nunes.
@since 28/08/2017
@version P11.5

@return .T. - Para n�o ignorar o processamento do funcion�rio
/*/
User Function PNM060SRA()
	aAdd( aFuncCS, { SRA->RA_FILIAL, SRA->RA_MAT } )
Return .T.

/*/{Protheus.doc} ProcPB7()
Restaura marca��o e grava abono coletivo nos funcion�rio marcadados.
@type function

@author Bruno Nunes.
@since 28/08/2017
@version P11.5
/*/
Static Function ProcPB7()
	local i 		 := 1
	local cTexto 	 := ''
	local cAlias 	 := GetNextalias() 	// alias resevardo para consulta SQL
	local nRec 		 := 0
	local cQuery 	 := ''
	local lExeChange := .T.
	local dDia 		 := ctod("//")

	ProcRegua( len( aFuncCS ) )
	for i := 1 to len( aFuncCS )
		cTexto += aFuncCS[i][1] + ' - ' + aFuncCS[i][2] + ' | '
		incProc()
		for dDia := MV_PAR09 to MV_PAR10
			cQuery :=  u_QryPB7( aFuncCS[i][1], aFuncCS[i][2], dDia )
			if U_MontarSQL(calias, @nRec, cQuery, lExeChange)
				(calias)->(dbGoTop())
				u_CSRH015( aFuncCS[i][1], aFuncCS[i][2], dtoc(dDia), (calias)->PB7_PAPONT, (calias)->PB7_ORDEM )
				(calias)->(dbCloseArea())
			endif
		next dDia
	next i
	msginfo("Processados "+cvaltochar(len(aFuncCS))+" funcion�rios. ", "Portal do Ponto.")
Return