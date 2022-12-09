#Include "topconn.CH"
#Include "rwmake.CH"
#Include "protheus.CH"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_ACTOCON()
/////////////////////////

DbSelectArea('Z16')
If DbSeek(xFilial('Z16') + '0002',.f.) .and. ExistBlock(Z16->Z16_FUNCAO)
	U_LsPreview(2)
Else
	MsgBox('Definição de impressão gráfica não existe.','ATENÇÃO!!!','ERRO')
EndIf

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_ACTO()
////////////////////////
_xPar := PARAMIXB
VP_ACERTO()
_nTCopias := 1
Do While Pergunte(cPerg,.t.)
	
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
	
	_cQuery := "SELECT F3_CFO, F3_VALCONT, F3_BASEICM, F3_VALICM, F3_ISENICM, F3_OUTRICM, F3_OBSERV,"
	_cQuery += _cEnter + " CASE WHEN SE21.E2_PARCELA = '002' THEN '' ELSE SE21.E2_PARCELA END PARC1,"
	_cQuery += _cEnter + " CASE WHEN SE21.E2_PARCELA = '002' THEN '' ELSE SE21.E2_VENCTO END VENC1,"
	_cQuery += _cEnter + " CASE WHEN SE21.E2_PARCELA = '002' THEN 0 ELSE SE21.E2_VALOR END VALOR1,"
	_cQuery += _cEnter + " CASE WHEN SE22.E2_PARCELA = '002' THEN SE22.E2_PARCELA ELSE '' END PARC2,"
	_cQuery += _cEnter + " CASE WHEN SE22.E2_PARCELA = '002' THEN SE22.E2_VENCTO ELSE '' END VENC2,"
	_cQuery += _cEnter + " CASE WHEN SE22.E2_PARCELA = '002' THEN SE22.E2_VALOR ELSE 0 END VALOR2,"
	_cQuery += _cEnter + " Z15_NFDATA, Z15_NOTA, Z15_SERIE, Z15_VALOR, Z15_FILORI, Z15_LOJA, Z15_CLDATA,"
	_cQuery += _cEnter + " FORN.M0_NOMECOM FORNECEDOR, FORN.M0_FILIAL FORN, FORN.M0_CGC CGCFORN, FORN.M0_ENDCOB ENDFOR, FORN.M0_BAIRCOB BAIRROFOR, "
	_cQuery += _cEnter + " FORN.M0_CIDCOB MUNFOR, FORN.M0_ESTCOB UFFOR, FORN.M0_CEPCOB CEPFOR,"
	_cQuery += _cEnter + " CLI.M0_NOMECOM CLIENTE, CLI.M0_FILIAL CLI, CLI.M0_CGC CGCCLI"
 
	_cQuery += _cEnter + " FROM " + RetSqlName('Z15') + " Z15(NOLOCK)"

	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE2') + " SE21 (NOLOCK)"
	_cQuery += _cEnter + " ON SE21.E2_MSFIL = Z15_LOJA"
	_cQuery += _cEnter + " AND SE21.E2_NUM = Z15_NOTA"
	_cQuery += _cEnter + " AND SE21.E2_LOJA = Z15_FILORI"
	_cQuery += _cEnter + " AND SE21.E2_FORNECE < '000010'"
	_cQuery += _cEnter + " AND SE21.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND SE21.E2_PARCELA <> '002'"

	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE2') + " SE22 (NOLOCK)"
	_cQuery += _cEnter + " ON SE22.E2_MSFIL = Z15_LOJA"
	_cQuery += _cEnter + " AND SE22.E2_NUM = Z15_NOTA"
	_cQuery += _cEnter + " AND SE22.E2_LOJA = Z15_FILORI"
	_cQuery += _cEnter + " AND SE22.E2_FORNECE < '000010'"
	_cQuery += _cEnter + " AND SE22.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND SE22.E2_PARCELA = '002'"

	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF3') + " SF3 (NOLOCK)"
	_cQuery += _cEnter + " ON F3_FILIAL = Z15_LOJA"
	_cQuery += _cEnter + " AND F3_NFISCAL = Z15_NOTA"
	_cQuery += _cEnter + " AND F3_SERIE = Z15_SERIE"
	_cQuery += _cEnter + " AND F3_LOJA = Z15_FILORI"
	_cQuery += _cEnter + " AND F3_CLIEFOR < '000010'"
	_cQuery += _cEnter + " AND F3_CFO < '5'"

	_cQuery += _cEnter + " INNER JOIN SIGAMAT FORN"
	_cQuery += _cEnter + " ON FORN.M0_CODIGO = '01'"
	_cQuery += _cEnter + " AND FORN.M0_CODFIL = Z15_FILORI"

	_cQuery += _cEnter + " INNER JOIN SIGAMAT CLI"
	_cQuery += _cEnter + " ON CLI.M0_CODIGO = '01'"
	_cQuery += _cEnter + " AND CLI.M0_CODFIL = Z15_LOJA"

	_cQuery += _cEnter + " WHERE Z15_NOTA <> ''"
	_cQuery += _cEnter + " AND (SE22.E2_VENCTO = '" + dtos(mv_par01) + "' OR SE21.E2_VENCTO = '" + dtos(mv_par01) + "')"
	_cQuery += _cEnter + " AND Z15_NOTA BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
	If !empty(mv_par04)
		_cQuery += _cEnter + " AND Z15_FILORI = '" + mv_par04 + "'"
	EndIf
	If !empty(mv_par05)
		_cQuery += _cEnter + " AND Z15_LOJA = '" + mv_par05 + "'"
	EndIf

	_cQuery += _cEnter + " ORDER BY Z15_FILORI, Z15_LOJA, Z15_NOTA"
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'Z15', .F., .T.)
	
	_cAlias := alias()
	
	If !eof()
		U_LSImpEtq(_xPar)
	Else
		MsgBox('Nenhum registro selecionado. Verifique parâmetros','ATENÇÃO!!!','INFO')
	EndIf
	
	DbSelectArea('Z15')
	DbCloseArea()
EndDo

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VP_ACERTO()
//////////////////////////
_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Vencimento                 ?","","", "mv_ch1", "D",  8 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "02", "Nota fiscal de             ?","","", "mv_ch2", "C",  9 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "03", "Nota fiscal até            ?","","", "mv_ch3", "C",  9 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "04", "Filial de Origem           ?","","", "mv_ch4", "C",  2 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0",""})
aAdd( aPerg , { cPerg, "05", "Filial de Destino          ?","","", "mv_ch5", "C",  2 , 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0",""})

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
