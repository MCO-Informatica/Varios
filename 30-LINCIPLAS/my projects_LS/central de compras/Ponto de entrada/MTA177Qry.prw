/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³P.Entrada ³MTA177Qry ³Autor  ³Vitor Raspa                ³Data  ³ 23.Jun.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Ponto de Entrada para alterar a Query referente ao calculo de  ³±±
±±³          ³ necessidades - Central de Compras                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Array, sendo (elementos):                                      ³±±
±±³          ³ [01]-Sub-query ou funcao SQL para obter a qtd. da Necessidade  ³±±
±±³          ³ [02]-Join's a serem acrescidos                                 ³±±
±±³          ³ [03]-Condicoes a serem acrescidas na clausula "WHERE"          ³±±
±±³          ³ [04]-Campos a serem acrescidos na clausula "GROUP BY"          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA177Qry()
Local aParam     := PARAMIXB
Local aRet       := {'','','',''}

Local lConsPrev  := If( SuperGetMV( 'MV_QTDPREV', .F., 'N' ) == 'S', .T., .F. )

/*

//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ESTRUTURA DO ARRAY "PARAMIXB"                                     ³
//³-----------------------------                                     ³
//³PARAMIXB[1,1]...PARAMIXB[1,18]: Perguntas SX1 (Grupo MTA177)      ³
//³PARAMIXB[1,19]: Filiais selecionadas;                             ³
//³PARAMIXB[1,20]: (1)Analise por Filial | (2)Analise Centralizada   ³
//³PARAMIXB[1,21]: Codigo da Filial Centralizadora                   ³
//³PARAMIXB[1,22]: Exibicao da tela de processamento (.T./.F.)       ³
//³PARAMIXB[1,23]: Exibir somente produtos c/ necessidade (.T./.F.)  ³
//³PARAMIXB[1,24]: Filtro por categoria (.T./.F.)                    ³
//³PARAMIXB[1,25]: Categorias selecionadas                           ³
//³PARAMIXB[1,26]: Grupos selecionados                               ³
//³PARAMIXB[1,27]: Tipos selecionados                                ³
//³PARAMIXB[1,28]: Regra de Filtragem                                ³
//³PARAMIXB[1,29]: Ordem selecionada                                 ³
//³PARAMIXB[1,30]: Log de processamento (.T./.F.)                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//

*/

If len(aparam[1,26]) > 8
	MsgAlert('ATENÇÃO!!!' + _cEnter + _cEnter + 'Você selecionou mais de um grupo de produtos. ' + _cEnter + 'A rotina será cancelada!','Central de Compras')
	__Quit()
EndIf
                   
_cFiliais := '('
For _nI := 1 to len(aParam177[19])
	_cFiliais += "'" + aParam177[19,_nI] + "'" + iif(_nI == len(aParam177[19]),')',',')
Next
_cGrupo  := substr(aParam177[26],2,6)
_cFiltro := aParam177[28]
_cFilOri := aParam177[21]

U_Trans177(_cGrupo, _cProduto, _cFiliais, _cFilOri, _cFiltro, _cPa6DtRom, _cFornece)

_cQuery3 := "UPDATE " + RetSqlName('AIE')
_cQuery3 += _cEnter + "SET AIE_PEDIDO = 'ELIMIN', AIE010.D_E_L_E_T_ = '*', AIE010.R_E_C_D_E_L_ = AIE010. R_E_C_N_O_"
_cQuery3 += _cEnter + "FROM " + RetSqlName('SB1') + " SB1 (NOLOCK)"
_cQuery3 += _cEnter + "WHERE AIE010.D_E_L_E_T_ 	= ''"
_cQuery3 += _cEnter + "AND AIE_CODPRO 			= B1_COD"
_cQuery3 += _cEnter + "AND AIE_FILIAL 			= '" + xFilial('AIE') + "'"
_cQuery3 += _cEnter + "AND AIE_FILNEC 			IN " + _cFiliais
_cQuery3 += _cEnter + "AND AIE_FILCEN 			= '" + cFilAnt + "'"
_cQuery3 += _cEnter + "AND AIE_PEDIDO 			= ''"
_cQuery3 += _cEnter + "AND SB1.D_E_L_E_T_ 		= ''"
_cQuery3 += _cEnter + "AND B1_FILIAL 			= ''"
_cQuery3 += _cEnter + "AND B1_COD 				= AIE_CODPRO"          
_cQuery3 += _cEnter + "AND B1_GRUPO 			IN " + aparam[1,26]

If !empty(_cFiltro)
	_cQuery3 += _cEnter + "AND (" + _cFiltro + ")"
EndIf
_cQuery1 += _cEnter + "AND B1_GRUPO = " + _cGrupo
nValSql := TcSqlExec(_cQuery3)

_lCompras := (_cTipoCalc == 'RC')

If  aparam[1,26] == "('0003')"    // livros
	
	// Note que o estoque máximo deve ser maior igual a 2
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
//	aret[1] := _cEnter + "SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI)"

	aret[1] := _cEnter + "SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END) + (CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END)+ (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)"
	
	aret[3] := _cEnter + "SBZ.BZ_EMAX > 0 AND "
	aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473
	If !empty(MV_PAR23)
		aret[3] += _cEnter + "SBZ.BZ_PERFIL IN " + FormatIn(alltrim(mv_par23),',') + " AND "
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN AND"   // 69582
	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END) + (CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END)+ (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END) <= SBZ.BZ_EMIN AND " 
	aret[3] += _cEnter + " D1_FILIAL = '" + xFilial('SD1') + "'"
	
	If empty(mv_par14) .or. empty(mv_par15)
		
		If _lCompras
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK)"
			aret[2] += _cEnter + " ON 	A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " 		A.B1_GRUPO = '0003' "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " 		(SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " 		 FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " 		 	INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " 		 	ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " 		 	AND SF4.D_E_L_E_T_ = ''"
			aret[2] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " 		 	D1_FILIAL = '" + cFilAnt + "' AND "
			aret[2] += _cEnter + " 		 	SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " 		 	F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " 		 	(D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " 	ON SD1.D1_COD = SBZ.BZ_COD "
			
			aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
			aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//			aret[3] += _cEnter + " (SB2.B2_QATU + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN AND"
			aret[3] += _cEnter + " (SB2.B2_QATU + (CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END)+ (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN AND"
			If !empty(MV_PAR23)
				aret[3] += _cEnter + "SBZ.BZ_PERFIL IN " + FormatIn(alltrim(mv_par23),',') + " AND "
			EndIf
			aret[3] += _cEnter + " D1_FILIAL = '" + xFilial('SD1') + "' AND "

			aret[3] += _cEnter + " SB2.B2_FILIAL IN (SELECT A1_LOJA "			// NAO PEGA LOJA BLOQUEADAS (OU INATIVAS)
			aret[3] += _cEnter + " FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)" 
			aret[3] += _cEnter + " WHERE A1_COD < '000009' "
			aret[3] += _cEnter + " AND A1_MSBLQL = '2' "
			aret[3] += _cEnter + " AND SA1.D_E_L_E_T_ = '') AND"

			aret[3] += _cEnter + " SB2.B2_COD NOT IN "
			aret[3] += _cEnter + " (SELECT PA7_CODPRO "
			aret[3] += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK) "
			aret[3] += _cEnter + " 		INNER JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK) "
			aret[3] += _cEnter + " 		ON PA6_NUMROM = PA7_NUMROM AND "
			aret[3] += _cEnter + " 		PA6.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " 		SBZ.BZ_FILIAL = PA6_FILDES "
			aret[3] += _cEnter + " WHERE PA7.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " PA6_DTROM = '" + dtos(dDataBase) + "')"
			
		Else
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0003' "
			
			aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
			aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473
			If !empty(MV_PAR23)
				aret[3] += _cEnter + "SBZ.BZ_PERFIL IN " + FormatIn(alltrim(mv_par23),',') + " AND "
			EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//			aret[3] += _cEnter + " (SB2.B2_QATU + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN AND"
			aret[3] += _cEnter + " (SB2.B2_QATU + (CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END)+ (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN AND"
			
			aret[3] += _cEnter + " SB2.B2_FILIAL IN (SELECT A1_LOJA "			// NAO PEGA LOJA BLOQUEADAS (OU INATIVAS)
			aret[3] += _cEnter + " FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)" 
			aret[3] += _cEnter + " WHERE A1_COD < '000009' "
			aret[3] += _cEnter + " AND A1_MSBLQL = '2' "
			aret[3] += _cEnter + " AND SA1.D_E_L_E_T_ = '') AND"

			aret[3] += _cEnter + " SB2.B2_COD NOT IN "
			aret[3] += _cEnter + " (SELECT PA7_CODPRO "
			aret[3] += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK) "
			aret[3] += _cEnter + " INNER JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK) "
			aret[3] += _cEnter + " ON PA6_NUMROM = PA7_NUMROM AND "
			aret[3] += _cEnter + " PA6.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " SBZ.BZ_FILIAL = PA6_FILDES "
			aret[3] += _cEnter + " WHERE PA7.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " PA6_DTROM = '" + dtos(dDataBase) + "')"

		EndIf
		
	Else
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0003' AND "
			aret[2] += _cEnter + " A.B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "' "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_FILIAL = ''" + cFilAnt + "'' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD  "

			aret[2] += _cEnter + " SB2.B2_FILIAL IN (SELECT A1_LOJA "			// NAO PEGA LOJA BLOQUEADAS (OU INATIVAS)
			aret[2] += _cEnter + " FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)" 
			aret[2] += _cEnter + " WHERE A1_COD < '000009' "
			aret[2] += _cEnter + " AND A1_MSBLQL = '2' "
			aret[2] += _cEnter + " AND SA1.D_E_L_E_T_ = '') AND "

			aret[2] += _cEnter + " AND SB2.B2_COD NOT IN "
			aret[2] += _cEnter + " (SELECT PA7_CODPRO "
			aret[2] += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK) "
			aret[2] += _cEnter + " ON PA6_NUMROM = PA7_NUMROM AND "
			aret[2] += _cEnter + " PA6.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " SBZ.BZ_FILIAL = PA6_FILDES "
			aret[2] += _cEnter + " WHERE PA7.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " PA6_DTROM = '" + dtos(dDataBase) + "')"
			
		Else            // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0003' AND "
			aret[2] += _cEnter + " A.B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "'  "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			
			aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
			aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473
			If !empty(MV_PAR23)
				aret[3] += _cEnter + "SBZ.BZ_PERFIL IN " + FormatIn(alltrim(mv_par23),',') + " AND "
			EndIf			
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//			aret[3] += _cEnter + " (SB2.B2_QATU + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN AND"
			aret[3] += _cEnter + " (SB2.B2_QATU + (CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END)+ (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN AND"

			aret[3] += _cEnter + " SB2.B2_FILIAL IN (SELECT A1_LOJA "			// NAO PEGA LOJA BLOQUEADAS (OU INATIVAS)
			aret[3] += _cEnter + " FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)" 
			aret[3] += _cEnter + " WHERE A1_COD < '000009' "
			aret[3] += _cEnter + " AND A1_MSBLQL = '2' "
			aret[3] += _cEnter + " AND SA1.D_E_L_E_T_ = '') AND"

			aret[3] += _cEnter + " SB2.B2_COD NOT IN "
			aret[3] += _cEnter + " (SELECT PA7_CODPRO "
			aret[3] += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK) "
			aret[3] += _cEnter + " INNER JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK) "
			aret[3] += _cEnter + " ON PA6_NUMROM = PA7_NUMROM AND "
			aret[3] += _cEnter + " PA6.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " SBZ.BZ_FILIAL = PA6_FILDES "
			aret[3] += _cEnter + " WHERE PA7.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " PA6_DTROM = '" + dtos(dDataBase) + "')"
			
		EndIf
		
	EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[4] := "SB2.B2_QATU, SB2.B2_SALPEDI"
	aret[4] := "SB2.B2_QATU, (CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END), (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)"
	
EndIf

If  aparam[1,26] == "('0002')"	// CONVENIENCIA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
//	aret[1] := _cEnter + "SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI)"
	aret[1] := _cEnter + "SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + (CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END)+ (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END))"

	aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
	aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + (CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END)+ (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN AND"   // 69582
	aret[3] += _cEnter + " B2_QATU > 0 AND "
	aret[3] += _cEnter + " D1_FILIAL = '" + xFilial('SD1') + "'"
	
	If empty(mv_par14) .OR. empty(mv_par15)
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0002' "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_FILIAL = '" + cFilAnt + "' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else            // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0002'  "
			
			aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
			aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
//	aret[3] += _cEnter + " (CASE WHEN (SB2.B2_SALPEDI + SB2.B2_QATU) < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN  AND"
//	aret[3] += _cEnter + " SBZ.BZ_EMAX - (CASE WHEN (SB2.B2_SALPEDI + SB2.B2_QATU) < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI) > 0 "
//  aret[3] += _cEnter + " SBZ.BZ_EMAX - (CASE WHEN (SB2.B2_SALPEDI + SB2.B2_QATU) < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI) > 0 "		
		
		aret[3] += _cEnter + " (CASE WHEN (SB2.B2_XTRANSI + SB2.B2_QATU + SB2.B2_XRESERV) < 0 THEN 0 ELSE "
		aret[3] += _cEnter + " CASE WHEN (SB2.B2_QATU) < 0 THEN 0 ELSE SB2.B2_QATU END "
		aret[3] += _cEnter + "+ (CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END)) <= SBZ.BZ_EMIN  AND"

		aret[3] += _cEnter + " SBZ.BZ_EMAX - (CASE WHEN (SB2.B2_SALPEDI + SB2.B2_QATU + SB2.B2_XRESERV) < 0 THEN 0 ELSE "
		aret[3] += _cEnter + " CASE WHEN (SB2.B2_QATU) < 0 THEN 0 ELSE SB2.B2_QATU END "
		aret[3] += _cEnter + "+ (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END) "				
		aret[3] += _cEnter + "+ (CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END))> 0 "						
	
		
			
		EndIf
		
	Else
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0002' AND "
			aret[2] += _cEnter + " A.B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "' "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_FILIAL = '" + cFilAnt + "' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else            // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0002' AND "
			aret[2] += _cEnter + " B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "'  "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " (NOLOCK) "
			
			aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 "
			aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473
			
		EndIf
		
	EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//aret[4] := "SB2.B2_QATU, SB2.B2_SALPEDI /*,B1_CONV*/ "
	aret[4] := "SB2.B2_QATU, SB2.B2_XTRANSI,SB2.B2_XRESERV "
	
EndIf

If  aparam[1,26] == "('0007')"
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
 //	aret[1] := _cEnter + " SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI)"
	aret[1] := _cEnter + " SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + "
	aret[1] += _cEnter + "	CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END) +"
	aret[1] += _cEnter + "	CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END) +"
	aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
	aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
//	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN AND"   // 69582
	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END +  "
	aret[3] += _cEnter + "	CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)+ "
	aret[3] += _cEnter + "	CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END) "
	aret[3] += _cEnter + "	<= SBZ.BZ_EMIN AND"   // 69582
		
	aret[3] += _cEnter + " D1_FILIAL = '" + xFilial('SD1') + "'"
	
	If empty(mv_par14) .OR. empty(mv_par15)
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0007' "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_FILIAL = '" + cFilAnt + "' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else            // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0007' "
			
			aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
			aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
//			aret[3] += _cEnter + " (SB2.B2_QATU + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN AND "
			aret[3] += _cEnter + " (SB2.B2_QATU + (CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END) + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END) ) <= SBZ.BZ_EMIN AND "
			aret[3] += _cEnter + " SB2.B2_COD NOT IN "
			aret[3] += _cEnter + " (SELECT D1_COD"
			aret[3] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[3] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[3] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[3] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[3] += _cEnter + " D1_FILIAL = '" + cFilAnt + "' AND "
			aret[3] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[3] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " F4_ESTOQUE = 'S')  AND "

			aret[3] += _cEnter + " SB2.B2_FILIAL IN (SELECT A1_LOJA "			// NAO PEGA LOJA BLOQUEADAS (OU INATIVAS)
			aret[3] += _cEnter + " FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)" 
			aret[3] += _cEnter + " WHERE A1_COD < '000009' "
			aret[3] += _cEnter + " AND A1_MSBLQL = '2' "
			aret[3] += _cEnter + " AND SA1.D_E_L_E_T_ = '') AND"

			aret[3] += _cEnter + " SB2.B2_COD NOT IN "
			aret[3] += _cEnter + " (SELECT PA7_CODPRO "
			aret[3] += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK) "
			aret[3] += _cEnter + " INNER JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK) "
			aret[3] += _cEnter + " ON PA6_NUMROM = PA7_NUMROM AND "
			aret[3] += _cEnter + " PA6.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " SBZ.BZ_FILIAL = PA6_FILDES "
			aret[3] += _cEnter + " WHERE PA7.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " PA6_DTROM = '" + dtos(dDataBase) + "')"
			
		EndIf
		
	Else
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0007' AND "
			aret[2] += _cEnter + " B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "' "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_FILIAL = '" + cFilAnt + "' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else            // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0007' AND "
			aret[2] += _cEnter + " B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "'  "
			
			aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
			aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//			aret[3] += _cEnter + " (SB2.B2_QATU + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN AND "
			aret[3] += _cEnter + " (SB2.B2_QATU + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN AND "

			aret[3] += _cEnter + " SB2.B2_FILIAL IN (SELECT A1_LOJA "			// NAO PEGA LOJA BLOQUEADAS (OU INATIVAS)
			aret[3] += _cEnter + " FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)" 
			aret[3] += _cEnter + " WHERE A1_COD < '000009' "
			aret[3] += _cEnter + " AND A1_MSBLQL = '2' "
			aret[3] += _cEnter + " AND SA1.D_E_L_E_T_ = '') AND"

			aret[3] += _cEnter + " SB2.B2_COD NOT IN "
			aret[3] += _cEnter + " (SELECT PA7_CODPRO "
			aret[3] += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK) "
			aret[3] += _cEnter + " INNER JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK) "
			aret[3] += _cEnter + " ON PA6_NUMROM = PA7_NUMROM AND "
			aret[3] += _cEnter + " PA6.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " SBZ.BZ_FILIAL = PA6_FILDES "
			aret[3] += _cEnter + " WHERE PA7.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " PA6_DTROM = '" + dtos(dDataBase) + "')"
			
		EndIf
		
	EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[4] := "SB2.B2_QATU, SB2.B2_SALPEDI"
	aret[4] := "SB2.B2_QATU, SB2.B2_XTRANSI,SB2.B2_XRESERV"
	
EndIf

If  aparam[1,26] == "('0004')"
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[1] := _cEnter + "SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI)"
	aret[1] := _cEnter + "SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END))"
	
	aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
	aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD','RD','GV','MG') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473/66489
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN "   // 69582
	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN "   // 69582

	aret[3] += _cEnter + " D1_FILIAL = '" + xFilial('SD1') + "'"
	
	If empty(mv_par14) .OR. empty(mv_par15)  // FORNECEDORES DE - ATE
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0004' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > (case when A.B1_PERIODI = 7 then '" + dtos(dDataBase+2) + "' Else '" + dtos(dDataBase+3) + "' end ) "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else            // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0004' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > (case when A.B1_PERIODI = 7 then '" + dtos(dDataBase+2) + "' Else '" + dtos(dDataBase+3) + "' end ) "
			
			aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
			aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD','RD','GV','MG') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473/66489
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//			aret[3] += _cEnter + " (SB2.B2_QATU + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN AND "
			aret[3] += _cEnter + " (SB2.B2_QATU + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN AND "

			aret[3] += _cEnter + " SB2.B2_FILIAL IN (SELECT A1_LOJA "			// NAO PEGA LOJA BLOQUEADAS (OU INATIVAS)
			aret[3] += _cEnter + " FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)" 
			aret[3] += _cEnter + " WHERE A1_COD < '000009' "
			aret[3] += _cEnter + " AND A1_MSBLQL = '2' "
			aret[3] += _cEnter + " AND SA1.D_E_L_E_T_ = '') AND"

			aret[3] += _cEnter + " SB2.B2_COD NOT IN "
			aret[3] += _cEnter + " (SELECT PA7_CODPRO "
			aret[3] += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK) "
			aret[3] += _cEnter + " INNER JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK) "
			aret[3] += _cEnter + " ON PA6_NUMROM = PA7_NUMROM AND "
			aret[3] += _cEnter + " PA6.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " SBZ.BZ_FILIAL = PA6_FILDES "
			aret[3] += _cEnter + " WHERE PA7.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " PA6_DTROM = '" + dtos(dDataBase) + "')"
			
		EndIf
		
	Else
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0004' AND "
			aret[2] += _cEnter + " B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > (case when A.B1_PERIODI = 7 then '" + dtos(dDataBase+1) + "' Else '" + dtos(dDataBase+3) + "' end ) "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " D1_FILIAL = '" + cFilAnt + "' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else            // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0004' AND "
			aret[2] += _cEnter + " B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > (case when A.B1_PERIODI = 7 then '" + dtos(dDataBase+1) + "' Else '" + dtos(dDataBase+3) + "' end ) "
			
			aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
			aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD','RD','GV','MG') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473/66489
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//			aret[3] += _cEnter + " (SB2.B2_QATU + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN AND "
			aret[3] += _cEnter + " (SB2.B2_QATU + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN AND "
			
			aret[3] += _cEnter + " SB2.B2_FILIAL IN (SELECT A1_LOJA "			// NAO PEGA LOJA BLOQUEADAS (OU INATIVAS)
			aret[3] += _cEnter + " FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)" 
			aret[3] += _cEnter + " WHERE A1_COD < '000009' "
			aret[3] += _cEnter + " AND A1_MSBLQL = '2' "
			aret[3] += _cEnter + " AND SA1.D_E_L_E_T_ = '') AND"

			aret[3] += _cEnter + " SB2.B2_COD NOT IN "
			aret[3] += _cEnter + " (SELECT PA7_CODPRO "
			aret[3] += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK) "
			aret[3] += _cEnter + " INNER JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK) "
			aret[3] += _cEnter + " ON PA6_NUMROM = PA7_NUMROM "
			aret[3] += _cEnter + " AND PA6.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " SBZ.BZ_FILIAL = PA6_FILDES "
			aret[3] += _cEnter + " WHERE PA7.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " PA6_DTROM = '" + dtos(dDataBase) + "')"
			
		EndIf
		
	EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[4] := "SB2.B2_QATU, SB2.B2_SALPEDI "
	aret[4] := "SB2.B2_QATU, SB2.B2_XTRANSI,SB2.B2_XRESERV  "
	
EndIf

If  aparam[1,26] == "('0006')"
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[1] := _cEnter + " SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI)"
	aret[1] := _cEnter + " SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END))"
	
	aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
	aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD','RD','GV','MG') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473/66489
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN "   // 69582 
	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN "   // 69582
	
	If empty(mv_par14) .OR. empty(mv_par15)
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0006' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > '" + dtos(dDataBase+3) + "' "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_FILIAL = '" + cFilAnt + "' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else             // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0006' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > '" + dtos(dDataBase+3) + "'  "
			
			aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//			aret[3] += _cEnter + " (SB2.B2_QATU + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN AND "
			aret[3] += _cEnter + " (SB2.B2_QATU + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN AND "
			
			aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD','RD','GV','MG') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473/66489

			aret[3] += _cEnter + " SB2.B2_FILIAL IN (SELECT A1_LOJA "			// NAO PEGA LOJA BLOQUEADAS (OU INATIVAS)
			aret[3] += _cEnter + " FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)" 
			aret[3] += _cEnter + " WHERE A1_COD < '000009' "
			aret[3] += _cEnter + " AND A1_MSBLQL = '2' "
			aret[3] += _cEnter + " AND SA1.D_E_L_E_T_ = '') AND"

			aret[3] += _cEnter + " SB2.B2_COD NOT IN "
			aret[3] += _cEnter + " (SELECT PA7_CODPRO "
			aret[3] += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK) "
			aret[3] += _cEnter + " INNER JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK) "
			aret[3] += _cEnter + " ON PA6_NUMROM = PA7_NUMROM AND "
			aret[3] += _cEnter + " PA6.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " SBZ.BZ_FILIAL = PA6_FILDES "
			aret[3] += _cEnter + " WHERE PA7.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " PA6_DTROM = '" + dtos(dDataBase) + "')"
			
		EndIf
		
	Else
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0006' AND "
			aret[2] += _cEnter + " B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > '" + dtos(dDataBase+1) + "' "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else            // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0006' AND "
			aret[2] += _cEnter + " B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > '" + dtos(dDataBase+3) + "'  "
			
			aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
			aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD','RD','GV','MG') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473/66489  
			
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
//			aret[3] += _cEnter + " (SB2.B2_QATU + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN AND "
			aret[3] += _cEnter + " (SB2.B2_QATU + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN AND "
			
			aret[3] += _cEnter + " SB2.B2_COD NOT IN "
			aret[3] += _cEnter + " (SELECT D1_COD"
			aret[3] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[3] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[3] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[3] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[3] += _cEnter + " D1_FILIAL = '" + cFilAnt + "' AND "
			aret[3] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[3] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " F4_ESTOQUE = 'S')  AND "

			aret[3] += _cEnter + " SB2.B2_FILIAL IN (SELECT A1_LOJA "			// NAO PEGA LOJA BLOQUEADAS (OU INATIVAS)
			aret[3] += _cEnter + " FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)" 
			aret[3] += _cEnter + " WHERE A1_COD < '000009' "
			aret[3] += _cEnter + " AND A1_MSBLQL = '2' "
			aret[3] += _cEnter + " AND SA1.D_E_L_E_T_ = '') AND"

			aret[3] += _cEnter + " SB2.B2_COD NOT IN "
			aret[3] += _cEnter + " (SELECT PA7_CODPRO "
			aret[3] += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK) "
			aret[3] += _cEnter + " INNER JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK) "
			aret[3] += _cEnter + " ON PA6_NUMROM = PA7_NUMROM AND "
			aret[3] += _cEnter + " PA6.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " SBZ.BZ_FILIAL = PA6_FILDES "
			aret[3] += _cEnter + " WHERE PA7.D_E_L_E_T_ = '' AND "
			aret[3] += _cEnter + " PA6_DTROM = '" + dtos(dDataBase) + "')"
			
		EndIf
		
	EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[4] := "SB2.B2_QATU, SB2.B2_SALPEDI "
	aret[4] := "SB2.B2_QATU, SB2.B2_XTRANSI,SB2.B2_XRESERV "
	
	
EndIf
                                 
If  aparam[1,26] $ "('0001')/('0016')/('0017')/('0018')/('0019')/('0029')/('0030')/('0031')"
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[1] := _cEnter + " SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI)"
	aret[1] := _cEnter + " SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END))"
	
	aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
	aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
//	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN"   // 69582
	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN"   // 69582
	
	
	If empty(mv_par14) .OR. empty(mv_par15)
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO IN ('0001','0016','0017','0018','0019','0029','0030','0031') "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_FILIAL = '" + cFilAnt + "' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else            // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO IN ('0001','0016','0017','0018','0019','0029','0030','0031') "
			
		EndIf
		
	Else
		
		If _lCompras	// COMPRAS
			
			aret[2] := "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO IN ('0001','0016','0017','0018','0019','0029','0030','0031') AND "
			aret[2] += _cEnter + " B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > '" + dtos(dDataBase+3) + "' "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_FILIAL = '" + cFilAnt + "' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else            // REPOSICAO
			
			aret[2] := "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO IN ('0001','0016','0017','0018','0019','0029','0030','0031') AND "
			aret[2] += _cEnter + " B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > '" + dtos(dDataBase+3) + "' "
			
		EndIf
		
	EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[4] := "SB2.B2_QATU, SB2.B2_SALPEDI "
	aret[4] := "SB2.B2_QATU, SB2.B2_XTRANSI,SB2.B2_XRESERV "
	
EndIf

If  aparam[1,26] $ "('0010')/('0008')"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
//	aret[1] := _cEnter + " SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI)"
	aret[1] := _cEnter + " SBZ.BZ_EMAX  - (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END,+ (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END))"
		
	aret[3] := _cEnter + " SBZ.BZ_EMAX > 0 AND "
	aret[3] += _cEnter + "SBZ.BZ_PERFIL NOT IN ('SP','MD') AND " // SOLICITACAO DE DANIELJG TICKT 45657/62473
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + SB2.B2_SALPEDI) <= SBZ.BZ_EMIN"   // 69582
	aret[3] += _cEnter + " (CASE WHEN SB2.B2_QATU < 0 THEN 0 ELSE SB2.B2_QATU END + CASE WHEN SB2.B2_XTRANSI < 0 THEN 0 ELSE SB2.B2_XTRANSI END + (CASE WHEN SB2.B2_XRESERV < 0 THEN 0 ELSE SB2.B2_XRESERV END)) <= SBZ.BZ_EMIN"   // 69582
	
	If empty(mv_par14) .OR. empty(mv_par15)
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0010' "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_FILIAL = '" + cFilAnt + "'' AND "
			aret[2] += _cEnter + " D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else            // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0010' "
			
		EndIf
		
	Else
		
		If _lCompras	// COMPRAS
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD "
			aret[2] += _cEnter + " AND A.B1_GRUPO = '0010' AND "
			aret[2] += _cEnter + " A.B1_PROC BETWEEN '" + mv_par14 + "' AND '" + mv_par15 + "' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > '" + dtos(dDataBase+3) + "' "
			aret[2] += _cEnter + " INNER JOIN "
			aret[2] += _cEnter + " (SELECT D1_COD, D1_FILIAL "
			aret[2] += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK) "
			aret[2] += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK) "
			aret[2] += _cEnter + " ON F4_CODIGO = D1_TES "
			aret[2] += _cEnter + " 		WHERE D1_DTDIGIT = '" + dtos(dDataBase) + "' AND "
			aret[2] += _cEnter + " D1_FILIAL = '" + cFilAnt + "' "
			aret[2] += _cEnter + " AND D1_PEDIDO <> '' AND "
			aret[2] += _cEnter + " SD1.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " F4_ESTOQUE = 'S' AND "
			aret[2] += _cEnter + " SF4.D_E_L_E_T_ = '' AND "
			aret[2] += _cEnter + " (D1_FORNECE > '000009' OR (D1_FORNECE = '000003' AND D1_LOJA = 'C0'))) AS SD1 "
			aret[2] += _cEnter + " ON SD1.D1_COD = SBZ.BZ_COD "
			
		Else            // REPOSICAO
			
			aret[2] := _cEnter + "INNER JOIN " + RetSqlName('SB1') + " A (NOLOCK) "
			aret[2] += _cEnter + " ON A.B1_COD = SBZ.BZ_COD AND "
			aret[2] += _cEnter + " A.B1_GRUPO = '0010' AND "
			aret[2] += _cEnter + " B1_PROC BETWEEN '"+ mv_par14 + "' AND '" + mv_par15 + "' AND "
			aret[2] += _cEnter + " A.B1_ENCALHE > '" + dtos(dDataBase+3) + "' "
			
		EndIf
		
	EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	aret[4] := "SB2.B2_QATU, SB2.B2_SALPEDI "
	aret[4] := "SB2.B2_QATU, SB2.B2_XTRANSI,SB2.B2_XRESERV "
	
EndIf
Return( aRet )
