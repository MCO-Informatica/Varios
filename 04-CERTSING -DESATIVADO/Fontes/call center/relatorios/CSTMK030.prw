#Include 'Protheus.ch'
#Include 'Topconn.ch'
#Include 'Totvs.ch'

//+-------------------------------------------------------------------+
//| Rotina | CSTMK030 | Autor | Rafael Beghini | Data | 15.07.2015 
//+-------------------------------------------------------------------+
//| Descr. | Relatório de Indicador de Agendas utilizando
//|        | o método FWMsExcel
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSTMK030()
	Local nOpc      := 0
	
	Private cTitulo := "Indicador de Agendas"
	Private cPerg  := 'CSTMK030'
	Private aSay    := {}
	Private aButton := {}
	Private cAliasA := GetNextAlias()
	
	CriaSx1( cPerg )
	
	aAdd( aSay , "Esta rotina irá imprimir o relatório de Indicador de Agendas, conforme parâmetros" )
	aAdd( aSay , "informados pelo usuário.")
	aAdd( aSay , "")
	aAdd( aSay, "Clique em OK para continuar...")
	
	aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( cTitulo, aSay, aButton )

	If nOpc == 1 .And. Pergunte( cPerg, .T. )
		FWMsgRun(, {|| A030Query() }, cTitulo, 'Gerando o relatório, aguarde...')
	EndIF
	
Return

//+-------------------------------------------------------------------+
//| Rotina | A030Query | Autor | Rafael Beghini | Data | 15.07.2015 
//+-------------------------------------------------------------------+
//| Descr. | Cria a query conforme parâmetros no Parambox
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A030Query()
	Local cQuery      := ''
	Local cMV_par01   := ''
	Local cMV_par02   := ''
	Local cMV_par03   := ''
	Local cMV_par04   := ''
	Local cRet        := ''
	Local dMV_DTAGEND := 'MV_DTAGEND'
	Local i           := 0
	Local nReg        := 1
	Local lEntidade   := .F.
	
	dMV_DTAGEND := GetMv( dMV_DTAGEND ) //'A PARTIR DE QUE DATA A QUERY DEVE BUSCAR REGISTRO DA LISTA DE CONTATO (SU4/SU6). BRANCO CONSIDERA-SE TODOS
	
	MakeSqlExpr( cPerg )
	
	//Atribui conforme o Pergunte
	cMV_par01 := MV_PAR01
	cMV_par02 := MV_PAR02
	cMV_par03 := Substr( MV_PAR03, 2, Len(MV_PAR03) - 2 ) 
	cMV_par04 := rTrim(MV_PAR04)
	
	If .NOT. Empty(cMV_par04) .AND. cMV_par04 != 'Todos'
		For i := nReg To Len(cMV_par04) / 3
			If Len(cRet) == 0
				cRet += Substring(cMV_par04,nReg,3)
			Else
				cRet += "','"+Substring(cMV_par04,nReg,3)
			EndIf
			nReg := nReg + 3
		Next
		cMV_par04 := cRet
		lEntidade := .T.
	EndIf
	
	cQuery := "SELECT operador," + CRLF 
	IF lEntidade
		cQuery += "       entidade," + CRLF 
	EndIF
	cQuery += "       Sum(atender_novas)       AS Atender_Novas," + CRLF 
	cQuery += "       Sum(atender_reagenda)    AS Atender_Reagenda," + CRLF 
	cQuery += "       Sum(atendidas_encerrada) AS Atendidas_Encerrada," + CRLF 
	cQuery += "       Sum(atendidas_reagenda)  AS Atendidas_Reagenda," + CRLF 
	cQuery += "       Sum(futuras_novas)       AS Futuras_Novas," + CRLF 
	cQuery += "       Sum(futuras_reagenda)    AS Futuras_Reagenda" + CRLF 
	cQuery += "FROM   ("
	//Atender_Novas
	cQuery += "       SELECT a.u4_operad  AS Operador," + CRLF 
	IF lEntidade
		cQuery += "               b1.u6_entida AS Entidade," + CRLF 
	EndIF
	cQuery += "               Count(*)     AS Atender_Novas," + CRLF 
	cQuery += "               0            AS Atender_Reagenda," + CRLF 
	cQuery += "               0            AS Atendidas_Encerrada," + CRLF 
	cQuery += "               0            AS Atendidas_Reagenda," + CRLF 
	cQuery += "               0            AS Futuras_Novas," + CRLF 
	cQuery += "               0            AS Futuras_Reagenda" + CRLF 
	cQuery += "        FROM   " + RetSqlName('SU4') + " a " + CRLF 
	cQuery += "               INNER JOIN " + RetSqlName('SU6') + " b1 " + CRLF 
	cQuery += "                       ON b1.u6_filial = a.u4_filial " + CRLF
	cQuery += "                          AND b1.u6_lista = a.u4_lista " + CRLF
	cQuery += "                          AND b1.u6_filial = '" + xFilial("SU6") + "' " + CRLF 
	IF lEntidade
		cQuery += "                          AND b1.u6_entida IN ('" + cMV_par04 + "') " + CRLF
	EndIF
	cQuery += "        WHERE  a.d_e_l_e_t_ = ' ' " + CRLF
	cQuery += "               AND a.u4_filial = '" + xFilial("SU4") + "' " + CRLF 
	cQuery += "               AND a.u4_data >= " + ValToSql( cMV_par01 ) + " " + CRLF
	cQuery += "               AND a.u4_data <= " + ValToSql( cMV_par02 ) + " " + CRLF
	cQuery += "               AND " + cMV_par03 + " " + CRLF	
	cQuery += "               AND a.u4_status = '1' " + CRLF
	cQuery += "               AND a.u4_codlig = ' ' " + CRLF
	If .NOT. Empty( dMV_DTAGEND )
		cQuery += "          AND a.u4_data > " + ValToSql( dMV_DTAGEND ) + " " + CRLF
	Endif
	cQuery += "        GROUP  BY a.u4_operad " + CRLF
	IF lEntidade
		cQuery += "                  ,b1.u6_entida " + CRLF
	EndIF
	cQuery += "        UNION ALL " + CRLF
	//Atender_Reagenda
	cQuery += "        SELECT b.u4_operad  AS Operador," + CRLF 
	IF lEntidade
		cQuery += "               b2.u6_entida AS Entidade," + CRLF 
	EndIF
	cQuery += "               0            AS Atender_Novas," + CRLF 
	cQuery += "               Count(*)     AS Atender_Reagenda," + CRLF 
	cQuery += "               0            AS Atendidas_Encerrada, " + CRLF
	cQuery += "               0            AS Atendidas_Reagenda, " + CRLF
	cQuery += "               0            AS Futuras_Novas, " + CRLF
	cQuery += "               0            AS Futuras_Reagenda " + CRLF
	cQuery += "        FROM   " + RetSqlName('SU4') + " b " + CRLF
	cQuery += "               INNER JOIN " + RetSqlName('SU6') + " b2 " + CRLF 
	cQuery += "                       ON b2.u6_filial = b.u4_filial " + CRLF
	cQuery += "                          AND b2.u6_lista = b.u4_lista " + CRLF
	cQuery += "                          AND b2.u6_filial = '" + xFilial("SU6") + "' " + CRLF 
	IF lEntidade
		cQuery += "                          AND b2.u6_entida IN ('" + cMV_par04 + "') " + CRLF
	EndIF
	cQuery += "        WHERE  b.d_e_l_e_t_ = ' ' " + CRLF
	cQuery += "               AND b.u4_filial = '" + xFilial("SU4") + "' " +CRLF 
	cQuery += "               AND b.u4_data >= " + ValToSql( cMV_par01 ) + " " + CRLF
	cQuery += "               AND b.u4_data <= " + ValToSql( cMV_par02 ) + " " + CRLF
	cQuery += "               AND " + cMV_par03 + " " + CRLF
	cQuery += "               AND b.u4_status = '1' " + CRLF
	cQuery += "               AND b.u4_codlig <> ' ' " + CRLF
	If .NOT. Empty( dMV_DTAGEND )
		cQuery += "          AND b.u4_data > " + ValToSql( dMV_DTAGEND ) + " " + CRLF
	Endif
	cQuery += "        GROUP  BY b.u4_operad " + CRLF
	IF lEntidade
		cQuery += "                  ,b2.u6_entida " + CRLF
	EndIF
	cQuery += "        UNION ALL " + CRLF
	//Atendidas_Encerrada
	cQuery += "        SELECT c.u4_operad  AS Operador," + CRLF 
	IF lEntidade
		cQuery += "               b3.u6_entida AS Entidade, " + CRLF
	EndIF
	cQuery += "               0            AS Atender_Novas, " + CRLF
	cQuery += "               0            AS Atender_Reagenda, " + CRLF
	cQuery += "               Count(*)     AS Atendidas_Encerrada, " + CRLF
	cQuery += "               0            AS Atendidas_Reagenda, " + CRLF
	cQuery += "               0            AS Futuras_Novas, " + CRLF
	cQuery += "               0            AS Futuras_Reagenda " + CRLF
	cQuery += "        FROM   " + RetSqlName('SU4') + " c " + CRLF
	cQuery += "               INNER JOIN " + RetSqlName('SU6') + " b3 " + CRLF
	cQuery += "                       ON b3.u6_filial = c.u4_filial " + CRLF
	cQuery += "                          AND b3.u6_lista = c.u4_lista " + CRLF
	cQuery += "                          AND b3.u6_filial = '" + xFilial("SU6") + "' " + CRLF 
	IF lEntidade
		cQuery += "                          AND b3.u6_entida IN ('" + cMV_par04 + "') " + CRLF
	EndIF
	cQuery += "        WHERE  c.d_e_l_e_t_ = ' ' " + CRLF
	cQuery += "               AND c.u4_filial = '" + xFilial("SU4") + "' " + CRLF
	cQuery += "               AND c.u4_data >= " + ValToSql( cMV_par01 ) + " " + CRLF
	cQuery += "               AND c.u4_data <= " + ValToSql( cMV_par02 ) + " " + CRLF
	cQuery += "               AND " + cMV_par03 + " " + CRLF	
	cQuery += "               AND c.u4_status = '2' " + CRLF
	cQuery += "               AND c.u4_codlig = ' ' " + CRLF
	If .NOT. Empty( dMV_DTAGEND )
		cQuery += "          AND c.u4_data > " + ValToSql( dMV_DTAGEND ) + " " + CRLF
	Endif 
	cQuery += "        GROUP  BY c.u4_operad " + CRLF
	IF lEntidade
		cQuery += "                  ,b3.u6_entida " + CRLF
	EndIF
	cQuery += "        UNION ALL " + CRLF
	//Atendidas_Reagenda
	cQuery += "        SELECT d.u4_operad  AS Operador," + CRLF 
	IF lEntidade
		cQuery += "               b4.u6_entida AS Entidade, " + CRLF
	EndIF
	cQuery += "               0            AS Atender_Novas, " + CRLF 
	cQuery += "               0            AS Atender_Reagenda, " + CRLF
	cQuery += "               0            AS Atendidas_Encerrada, " + CRLF
	cQuery += "               Count(*)     AS Atendidas_Reagenda, " + CRLF
	cQuery += "               0            AS Futuras_Novas, " + CRLF
	cQuery += "               0            AS Futuras_Reagenda " + CRLF
	cQuery += "        FROM   " + RetSqlName('SU4') + " d " + CRLF
	cQuery += "               INNER JOIN " + RetSqlName('SU6') + " b4 " + CRLF
	cQuery += "                       ON b4.u6_filial = d.u4_filial " + CRLF
	cQuery += "                          AND b4.u6_lista = d.u4_lista " + CRLF
	cQuery += "                          AND b4.u6_filial = '" + xFilial("SU6") + "' " + CRLF 
	IF lEntidade
		cQuery += "                          AND b4.u6_entida IN ('" + cMV_par04 + "') " + CRLF
	EndIF
	cQuery += "        WHERE  d.d_e_l_e_t_ = ' ' " + CRLF
	cQuery += "               AND d.u4_filial = '" + xFilial("SU4") + "' " + CRLF
	cQuery += "               AND d.u4_data >= " + ValToSql( cMV_par01 ) + " " + CRLF
	cQuery += "               AND d.u4_data <= " + ValToSql( cMV_par02 ) + " " + CRLF
	cQuery += "               AND " + cMV_par03 + " " + CRLF	
	cQuery += "               AND d.u4_status = '2' " + CRLF
	cQuery += "               AND d.u4_codlig <> ' ' " + CRLF
	If .NOT. Empty( dMV_DTAGEND )
		cQuery += "          AND d.u4_data > " + ValToSql( dMV_DTAGEND ) + " " + CRLF
	Endif
	cQuery += "        GROUP  BY d.u4_operad " + CRLF
	IF lEntidade
		cQuery += "                  ,b4.u6_entida " + CRLF
	EndIF
	cQuery += "        UNION ALL " + CRLF
	//Futuras_Novas
	cQuery += "        SELECT e.u4_operad  AS Operador," + CRLF 
	IF lEntidade
		cQuery += "               b5.u6_entida AS Entidade, " + CRLF
	EndIF
	cQuery += "               0            AS Atender_Novas, " + CRLF
	cQuery += "               0            AS Atender_Reagenda, " + CRLF
	cQuery += "               0            AS Atendidas_Encerrada, " + CRLF
	cQuery += "               0            AS Atendidas_Reagenda, " + CRLF
	cQuery += "               Count(*)     AS Futuras_Novas, " + CRLF
	cQuery += "               0            AS Futuras_Reagenda " + CRLF
	cQuery += "        FROM   " + RetSqlName('SU4') + " e " + CRLF
	cQuery += "               INNER JOIN " + RetSqlName('SU6') + " b5 " + CRLF
	cQuery += "                       ON b5.u6_filial = e.u4_filial " + CRLF
	cQuery += "                          AND b5.u6_lista = e.u4_lista " + CRLF
	cQuery += "                          AND b5.u6_filial = '" + xFilial("SU6") + "' " + CRLF 
	IF lEntidade
		cQuery += "                          AND b5.u6_entida IN ('" + cMV_par04 + "') " + CRLF
	EndIF
	cQuery += "        WHERE  e.d_e_l_e_t_ = ' ' " + CRLF
	cQuery += "               AND e.u4_filial = '" + xFilial("SU4") + "' " + CRLF 
	cQuery += "               AND e.u4_data > " + ValToSql( cMV_par02 ) + " " + CRLF
	cQuery += "               AND " + cMV_par03 + " " + CRLF	
	cQuery += "               AND e.u4_status = '1' " + CRLF
	cQuery += "               AND e.u4_codlig = ' ' " + CRLF
	If .NOT. Empty( dMV_DTAGEND )
		cQuery += "          AND e.u4_data > " + ValToSql( dMV_DTAGEND ) + " " + CRLF
	Endif 
	cQuery += "        GROUP  BY e.u4_operad " + CRLF
	IF lEntidade
		cQuery += "                  ,b5.u6_entida " + CRLF
	EndIF
	cQuery += "        UNION ALL " + CRLF
	//Futuras_Reagenda
	cQuery += "        SELECT f.u4_operad  AS Operador," + CRLF 
	IF lEntidade
		cQuery += "               b6.u6_entida AS Entidade, " + CRLF
	EndIF
	cQuery += "               0            AS Atender_Novas, " + CRLF
	cQuery += "               0            AS Atender_Reagenda, " + CRLF
	cQuery += "               0            AS Atendidas_Encerrada, " + CRLF
	cQuery += "               0            AS Atendidas_Reagenda, " + CRLF
	cQuery += "               0            AS Futuras_Novas, " + CRLF
	cQuery += "               Count(*)     AS Futuras_Reagenda " + CRLF
	cQuery += "        FROM   " + RetSqlName('SU4') + " f " + CRLF
	cQuery += "               INNER JOIN " + RetSqlName('SU6') + " b6 " + CRLF
	cQuery += "                       ON b6.u6_filial = f.u4_filial " + CRLF
	cQuery += "                          AND b6.u6_lista = f.u4_lista " + CRLF
	cQuery += "                          AND b6.u6_filial = '" + xFilial("SU6") + "' " + CRLF 
	IF lEntidade
		cQuery += "                          AND b6.u6_entida IN ('" + cMV_par04 + "') " + CRLF
	EndIF
	cQuery += "        WHERE  f.d_e_l_e_t_ = ' ' " + CRLF
	cQuery += "               AND f.u4_filial = '" + xFilial("SU4") + "' " + CRLF
	cQuery += "               AND f.u4_data > " + ValToSql( cMV_par02 ) + " " + CRLF
	cQuery += "               AND " + cMV_par03 + " " + CRLF	
	cQuery += "               AND f.u4_status = '1' " + CRLF
	cQuery += "               AND f.u4_codlig <> ' ' " + CRLF
	If .NOT. Empty( dMV_DTAGEND )
		cQuery += "          AND f.u4_data > " + ValToSql( dMV_DTAGEND ) + " " + CRLF
	Endif
	cQuery += "        GROUP  BY f.u4_operad " + CRLF
	IF lEntidade
		cQuery += "                  ,b6.u6_entida " + CRLF
	EndIF
	cQuery += "                  ) " + CRLF
	cQuery += "GROUP  BY operador " + CRLF
	IF lEntidade
		cQuery += "          ,entidade " + CRLF
	EndIF
	cQuery += "ORDER  BY operador " + CRLF
	IF lEntidade
		cQuery += "          ,entidade 	" + CRLF
	EndIF
	cQuery += " "
	
	cQuery := ChangeQuery(cQuery)
	
	IF Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasA, .F., .T.)
	
	IF .NOT. Eof( cAliasA )
		A030Excel( cAliasA, lEntidade )
	Else
		MsgAlert('A query não retornou registros, por favor verifique os parâmetros informados.', cTitulo)
	EndIF	
Return

//+-------------------------------------------------------------------+
//| Rotina | A030Excel | Autor | Rafael Beghini | Data | 15.07.2015 
//+-------------------------------------------------------------------+
//| Descr. | Gera o arquivo XML conforme query realizada. 
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A030Excel( cAliasA, lEntidade )
	Local cWorkSheet := cTitulo
	Local cTable     := 'Indicador de Agendas'
	Local cOperador  := ''
	Local oExcel     := Nil
	Local cPath      := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile  := cPath + 'IndicadorAgenda_' + dTos( dDataBase ) + ".XML"
	
	oExcel := FWMSEXCEL():New() //Método para geração em XML
	
	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >    , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Cód. Operador"        , 1      , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nome Operador"        , 1      , 1	      , .F. )
	IF lEntidade
		oExcel:AddColumn( cWorkSheet, cTable, "Entidade"        , 1      , 1	      , .F. )
	EndIF
	oExcel:AddColumn( cWorkSheet, cTable, "Atender Novas"        , 2      , 1	      , .T. )
	oExcel:AddColumn( cWorkSheet, cTable, "Atender Reagendadas"  , 2      , 1      , .T. )
	oExcel:AddColumn( cWorkSheet, cTable, "Atendidas Encerradas" , 2      , 1      , .T. )
	oExcel:AddColumn( cWorkSheet, cTable, "Atendidas Reagendadas", 2      , 1	      , .T. )
	oExcel:AddColumn( cWorkSheet, cTable, "Futuras Novas"        , 2      , 1      , .T. )
	oExcel:AddColumn( cWorkSheet, cTable, "Futuras Reagendadas"  , 2      , 1	      , .T. )
	
	//nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada
	
	While .NOT. Eof( cAliasA )
		cOperador := rTrim( Posicione('SU7', 1, xFilial('SU7') + (cAliasA)->OPERADOR, 'U7_NOME') )
		
		IF lEntidade
			oExcel:AddRow( cWorkSheet, cTable, { (cAliasA)->OPERADOR, cOperador, (cAliasA)->ENTIDADE, (cAliasA)->Atender_Novas,; 
										     (cAliasA)->Atender_Reagenda, (cAliasA)->Atendidas_Encerrada, (cAliasA)->Atendidas_Reagenda,; 
										     (cAliasA)->Futuras_Novas, (cAliasA)->Futuras_Reagenda} )
		Else
			oExcel:AddRow( cWorkSheet, cTable, { (cAliasA)->OPERADOR, cOperador, (cAliasA)->Atender_Novas, (cAliasA)->Atender_Reagenda,;
											 (cAliasA)->Atendidas_Encerrada, (cAliasA)->Atendidas_Reagenda, (cAliasA)->Futuras_Novas,;
											 (cAliasA)->Futuras_Reagenda} )
		EndIF
		
	(cAliasA)->( dbSkip() )
	End
		
	oExcel:Activate()              //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório
	
	ShellExecute( "Open", cNameFile , '', '', 1 ) //Abre o arquivo na tela após salvar	
Return

//+----------------------------------------------------------------+
//| Rotina | CriaSx1 | Autor | Rafael Beghini | Data | 15/07/2015  |
//+----------------------------------------------------------------+
//| Descr. | Cria as Perguntas usadas no parametro.                |
//|        |                                                       |
//+----------------------------------------------------------------+
Static Function CriaSx1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}
	Local _cPerg := ''
	
	/***
	Característica do vetor p/ utilização da função SX1
	---------------------------------------------------
	[n,1] --> texto da pergunta
	[n,2] --> tipo do dado
	[n,3] --> tamanho
	[n,4] --> decimal
	[n,5] --> objeto G=get ou C=choice
	[n,6] --> validacao
	[n,7] --> F3
	[n,8] --> definicao 1
	[n,9] --> definicao 2
	[n,10] -> definicao 3
	[n,11] -> definicao 4
	[n,12] -> definicao 5
	***/
	aAdd(aP,{"Data de"       ,"D", 8 ,0,"G",""                                     ,""      ,""   ,""   ,"","",""})
	aAdd(aP,{"Data ate"      ,"D", 8 ,0,"G","NaoVazio() .And. (mv_par02>=mv_par01)",""      ,""   ,""   ,"","",""})
	aAdd(aP,{"Consultores "  ,"C", 99,0,"R","NaoVazio()"                           ,"SU7TLV",""   ,""   ,"","",""})
	aAdd(aP,{"Entidade"      ,"C", 18,0,"G","U_CSTMK30Opc()"                       ,""      ,""   ,""   ,"","",""})
		
	aAdd(aHelp,{"Digite a data incial."})
	aAdd(aHelp,{"Digite a data Final."})
	aAdd(aHelp,{"Selecione os códigos dos consultores,"} )
	aAdd(aHelp,{"Selecione a entidade que deseja filtrar."})
	
	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		
		PutSx1(cPerg,;
		cSeq,;
		aP[i,1],aP[i,1],aP[i,1],;
		cMvCh,;
		aP[i,2],;
		aP[i,3],;
		aP[i,4],;
		0,;
		aP[i,5],;
		aP[i,6],;
		aP[i,7],;
		"",;
		"",;
		cMvPar,;
		aP[i,8],aP[i,8],aP[i,8],;
		"",;
		aP[i,9],aP[i,9],aP[i,9],;
		aP[i,10],aP[i,10],aP[i,10],;
		aP[i,11],aP[i,11],aP[i,11],;
		aP[i,12],aP[i,12],aP[i,12],;
		aHelp[i],;
		{},;
		{},;
		"")
	Next i
	
	SX1->( dbSetOrder( 1 ) )
	_cPerg := PadR( cPerg, 10 )
	IF SX1->( dbSeek( _cPerg + '03' ) )
		SX1->( RecLock( 'SX1', .F. ) )
		SX1->X1_CNT01 := 'U4_OPERAD'
		SX1->( MsUnLock() )
	EndIF
Return

//+-------------------------------------------------------------------+
//| Rotina | CSTMK40Opc | Autor | Rafael Beghini | Data | 15.07.2015 
//+-------------------------------------------------------------------+
//| Descr. | Seleciona as opções de entidades no Pergunte
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
User Function CSTMK30Opc()
	Local aRet      := {}
	Local aParamBox := {}
	Local aMvPar    := {}
	Local i         := 0
	Local nMv       := 0
	Local cRet      := Space(90)
	Local aDados    := {'SZT','SZX','PAB','SA1','SUS','ACH','0'}
	
	aAdd(aParamBox,{5,"SSL RENOVAÇÃO"     ,('SZT' $ MV_PAR04),90,"",.F.})
	aAdd(aParamBox,{5,"ICP-BRASIL"        ,('SZX' $ MV_PAR04),90,"",.F.})
	aAdd(aParamBox,{5,"LISTA DE CONTATOS" ,('PAB' $ MV_PAR04),90,"",.F.})
	aAdd(aParamBox,{5,"CLIENTES"          ,('SA1' $ MV_PAR04),90,"",.F.})
	aAdd(aParamBox,{5,"PROSPECTS"         ,('SUS' $ MV_PAR04),90,"",.F.})
	aAdd(aParamBox,{5,"SUSPECTS"          ,('ACH' $ MV_PAR04),90,"",.F.})
	aAdd(aParamBox,{5,"SELECIONAR TODOS"  ,('0'   $ MV_PAR04),90,"",.F.})
		
	For nMv := 1 To 40
		AAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv
	
	If ParamBox(aParamBox,"Seleção de Entidades..",@aRet)
	   For i:=1 To Len(aRet)
	   	cRet += Iif(aRet[i],aDados[i],'')
	   Next
	Endif
	
	For nMv := 1 To Len( aMvPar )
	   &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
	Next nMv
	
	If Len( aRet ) > 0		
		IF aRet[7]
			MV_PAR04 := 'Todos'
		Else
			MV_PAR04 := Alltrim(cRet)		
		Endif
	Else
		MV_PAR04 := cRet
	EndIF
Return(Nil)