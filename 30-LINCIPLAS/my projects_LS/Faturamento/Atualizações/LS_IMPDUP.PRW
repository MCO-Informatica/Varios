#Include "topconn.CH"
#Include "rwmake.CH"
#Include "protheus.CH"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_IMPDUP()
/////////////////////////

DbSelectArea('Z16')
If DbSeek(xFilial('Z16') + '0001',.f.)
	U_LsPreview(2)
Else
	MsgBox('Definição de impressão gráfica não existe.','ATENÇÃO!!!','ERRO')
EndIf

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_DUPLI()
////////////////////////
_xPar := PARAMIXB
VP_DUPLI()
Do While Pergunte(cPerg,.t.)
	_nTCopias := iif(mv_par05 == 0, 1, mv_par05)
	
	_cQuery := "SELECT MAX(R_E_C_N_O_) R_E_C_N_O_ FROM SIGAMAT (NOLOCK)"
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SM0', .F., .T.)
	
	If SM0->(LastRec()) <> _SM0->R_E_C_N_O_
		DbCloseArea()
		DbSelectArea('SM0')
		_nRecno := Recno()
		DbGoTop()
		TcSqlExec('DROP TABLE SIGAMAT')
		copy to SIGAMAT VIA 'TOPCONN'
		DbGoto(_nRecno)
	EndIf
	DbCloseArea()
	
	_cQuery := "SELECT E2_FORNECE, E2_LOJA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_SALDO, CONVERT(CHAR,CONVERT(DATETIME,E2_EMISSAO),103) E2_EMISSAO, CONVERT(CHAR,CONVERT(DATETIME,E2_VENCTO),103) E2_VENCTO,"
	_cQuery += _cEnter + " A2_NOME, A2_END, A2_MUN, A2_BAIRRO, A2_EST, A2_CEP, A2_CGC, A2_INSCR, A2_TIPO,"
	_cQuery += _cEnter + " EMP.M0_NOMECOM EMP_NOMECOM, EMP.M0_ENDCOB EMP_ENDCOB, EMP.M0_BAIRCOB EMP_BAIRCOB, EMP.M0_CIDCOB EMP_CIDCOB,"
	_cQuery += _cEnter + " EMP.M0_ESTCOB EMP_ESTCOB, EMP.M0_CGC EMP_CGC, EMP.M0_INSC EMP_INSC, EMP.M0_TEL EMP_TEL, EMP.M0_CEPCOB EMP_CEPCOB,"
	_cQuery += _cEnter + " CLI.M0_NOMECOM CLI_NOMECOM, CLI.M0_ENDCOB CLI_ENDCOB, CLI.M0_BAIRCOB CLI_BAIRCOB, CLI.M0_CIDCOB CLI_CIDCOB,"
	_cQuery += _cEnter + " CLI.M0_ESTCOB CLI_ESTCOB, CLI.M0_CGC CLI_CGC, CLI.M0_INSC CLI_INSC, CLI.M0_TEL CLI_TEL, CLI.M0_CEPCOB CLI_CEPCOB"
	
	_cQuery += _cEnter + " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN SIGAMAT EMP (NOLOCK)"
	_cQuery += _cEnter + " ON EMP.M0_CODFIL = E2_LOJA"
	_cQuery += _cEnter + " AND EMP.M0_CODIGO = '" + cEmpAnt + "'"
	_cQuery += _cEnter + " AND EMP.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " INNER JOIN SIGAMAT CLI (NOLOCK)"
	_cQuery += _cEnter + " ON CLI.M0_CODFIL = E2_MSFIL"
	_cQuery += _cEnter + " AND CLI.M0_CODIGO = '" + cEmpAnt + "'"
	_cQuery += _cEnter + " AND CLI.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SA2') + " SA2 (NOLOCK)"
	_cQuery += _cEnter + " ON A2_COD < '000010'"
	_cQuery += _cEnter + " AND A2_LOJA = E2_MSFIL"
	_cQuery += _cEnter + " AND SA2.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
	_cQuery += _cEnter + " AND E2_NUM BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
	_cQuery += _cEnter + " AND E2_LOJA = '" + mv_par04 + "'"
	_cQuery += _cEnter + " AND E2_VENCTO = '" + dtos(mv_par01) + "'"
	_cQuery += _cEnter + " AND SE2.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " ORDER BY E2_PREFIXO, E2_NUM"
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SE2', .F., .T.)
	
	_cAlias := alias()
	
	If !eof()
		U_LSImpEtq(_xPar)
	Else
		MsgBox('Nenhum registro selecionado. Verifique parâmetros','ATENÇÃO!!!','INFO')
	EndIf
	
	DbSelectArea('SE2')
	DbCloseArea()
EndDo

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VP_DUPLI()
//////////////////////////
_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Vencimento                 ?","","", "mv_ch1", "D",  8 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "02", "Nota fiscal de             ?","","", "mv_ch2", "C",  9 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "03", "Nota fiscal até            ?","","", "mv_ch3", "C",  9 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "04", "Filial de Origem           ?","","", "mv_ch4", "C",  2 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0",""})
aAdd( aPerg , { cPerg, "05", "Cópias                     ?","","", "mv_ch5", "N",  1 , 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

DbSelectArea("SX1")
DbSetOrder(1)

For i:=1 to Len(aPerg)
	RecLock("SX1",!DbSeek(cPerg + aPerg[i, 2]))
	For j := 1 to (FCount())
		If j <= Len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
			FieldPut(j, aPerg[i, j])
		Endif
	Next
	MsUnlock()
Next

RestArea(_aAlias)

Return
