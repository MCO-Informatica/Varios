#Include 'Totvs.ch'
//+-------------------------------------------------------------------+
//| Rotina | CSGCT020 | Autor | Rafael Beghini | Data | 04.09.2015 
//+-------------------------------------------------------------------+
//| Descr. | Relatório consolidado Gestão de Contratos
//|        | utilizando a função FWMsExcel
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSGCT020()
	Local nOpc   := 0
	Local aRet   := {}
	Local aTpCtr := {"1.Compras","2.Vendas","3.Ambos"}
	Local aCrono := {"1.Sim","2.Não"}
	Local aMoeda := {"1.Real","2.Dolar","3.Euro","4.Peso Arg.","5.Peso Chileno"}
	Local aSitua := A020F3()
	Local cWhen1 := "IIf( ValType( Mv_par15 ) == 'C', Subs(Mv_par15,1,1), LTrim( Str( Mv_par15, 1, 0 ) ) ) == '1'"
	Local cWhen2 := "IIf( ValType( Mv_par15 ) == 'C', Subs(Mv_par15,1,1), LTrim( Str( Mv_par15, 1, 0 ) ) ) == '2'"
	Local aParamBox := {}
	
	Private cTitulo  := "Gestão de Contratos"
	Private cShowQry := ''
	Private cAliasA  := GetNextAlias()
	Private aSay     := {}
	Private aButton  := {}
	Private aUsrCNN  := {}
	Private oExcel   := Nil
	Private lShowQry := .F.
	
	AAdd( aSay, "Esta rotina irá gerar o Relatório Consolidado de Gestão de Contratos," )
	AAdd( aSay, "exibindo seus respectivos Fornecedores/Clientes, Cauções, Planilhas,"  )
	AAdd( aSay, "Medições e Cronogramas conforme parâmetros informados."                )
	AAdd( aSay, " "                                                                     )
	AAdd( aSay, "Clique para continuar..."                                              )
	
	aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() } } )
	aAdd( aButton, { 2, .T., {|| FechaBatch()            } } )
	
	SetKey( VK_F12 , {|| lShowQry := MsgYesNo('Exportar a consulta SQL?',cTitulo ) } )
	
	FormBatch( cTitulo, aSay, aButton )

	If nOpc == 1
		aAdd(aParamBox,{ 1, "Filial de"              , Space(02)        , "", "", "SM0", "", 0 , .F. }) // 01
		aAdd(aParamBox,{ 1, "Filial Ate"             , 'ZZ'             , "", "", "SM0", "", 0 , .T. }) // 02
		aAdd(aParamBox,{ 1, "Data de Assinatura de"  , Ctod(Space(8))   , "", "", ""   , "", 20, .F. }) // 03
		aAdd(aParamBox,{ 1, "Data de Assinatura Ate" , dDataBase        , "", "", ""   , "", 20, .T. }) // 04
		aAdd(aParamBox,{ 1, "Contrato de"            , Space(15)        , "", "", "CN9", "", 0 , .F. }) // 05
		aAdd(aParamBox,{ 1, "Contrato Ate"           , 'ZZZZZZZZZZZZZZZ', "", "", "CN9", "", 0 , .T. }) // 06
		aAdd(aParamBox,{ 1, "Revisão de"             , Space(03)        , "", "", ""   , "", 0 , .F. }) // 07
		aAdd(aParamBox,{ 1, "Revisão Ate"            , 'ZZZ'            , "", "", ""   , "", 0 , .F. }) // 08
		aAdd(aParamBox,{ 1, "Dt. Inicio Contrato de" , Ctod(Space(8))   , "", "", ""   , "", 20, .F. }) // 09
		aAdd(aParamBox,{ 1, "Dt. Inicio Contrato Ate", dDataBase        , "", "", ""   , "", 20, .T. }) // 10
		aAdd(aParamBox,{ 1, "Dt. Fim Contrato de"    , Ctod(Space(8))   , "", "", ""   , "", 20, .F. }) // 11
		aAdd(aParamBox,{ 1, "Dt. Fim Contrato Ate"   , Ctod(Space(8))   , "", "", ""   , "", 20, .F. }) // 12
		aAdd(aParamBox,{ 2, "Situação"		         , 5		        , aSitua, 60, "", .F.})         // 13
		aAdd(aParamBox,{ 1, "Situação"               , ''         	    , "", "", ""   , "", 0 , .F. }) // 14
		aAdd(aParamBox,{ 2, "Por contrato de"        , 3                , aTpCtr, 60, "", .F.})         // 15
		aAdd(aParamBox,{ 1, "Fornecedor de"          , Space(06)        , "", "", "SA2", cWhen1, 0 , .F. }) // 16
		aAdd(aParamBox,{ 1, "Fornecedor Ate"         , 'ZZZZZZ'         , "", "", "SA2", cWhen1, 0 , .F. }) // 17
		aAdd(aParamBox,{ 1, "Cliente de"             , Space(06)        , "", "", "SA1", cWhen2, 0 , .F. }) // 18
		aAdd(aParamBox,{ 1, "Cliente Ate"            , 'ZZZZZZ'         , "", "", "SA1", cWhen2, 0 , .F. }) // 19
		aAdd(aParamBox,{ 1, "Tipo Contrato de"       , Space(03)        , "", "", "CN1", "", 0 , .F. }) // 20 
		aAdd(aParamBox,{ 1, "Tipo Contrato Ate"      , 'ZZZ'            , "", "", "CN1", "", 0 , .T. }) // 21
		aAdd(aParamBox,{ 2, "Moeda"                  , 1                , aMoeda, 60, "", .F.})         // 22
		aAdd(aParamBox,{ 2, "Exibir Cronograma"      , 2                , aCrono, 60, "", .F.})         // 23
		
		If ParamBox(aParamBox,"Contratos",@aRet)
			FWMsgRun(, {|| A020Query( aRet ) },'Gestão de contratos','Gerando excel, aguarde...')
			If lShowQry
				A020ShowQry( cShowQry )
			EndIF
		EndIF
	EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A020Query | Autor | Rafael Beghini | Data | 04.09.2015 
//+-------------------------------------------------------------------+
//| Descr. | Cria a query conforme parâmetros no Parambox
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A020Query( aRet )
	Local cQuery    := ''
	Private cMV_par01 := cMV_par02 := cMV_par03 := cMV_par04 := cMV_par05 := cMV_par06 := cMV_par07 := cMV_par08 := cMV_par09 := cMV_par10 := ''
	Private cMV_par11 := cMV_par12 := cMV_par13 := cMV_par14 := cMV_par15 := cMV_par16 := cMV_par17 := cMV_par18 := cMV_par19 := cMV_par20 := ''
	Private cMV_par21 := cMV_par22 := cMV_par23 := ''
	
	//Atribui conforme o Parambox enviou
	cMV_par01 := aRet[1]  ; cMV_par02 := aRet[2]  ; cMV_par03 := aRet[3]  ; cMV_par04 := aRet[4]  ; cMV_par05 := aRet[5]  ; cMV_par06 := aRet[6]
	cMV_par07 := aRet[7]  ; cMV_par08 := aRet[8]  ; cMV_par09 := aRet[9]  ; cMV_par10 := aRet[10] ; cMV_par11 := aRet[11] ; cMV_par12 := aRet[12]
	cMV_par13 := aRet[13] ; cMV_par14 := aRet[14] ; cMV_par15 := aRet[15] ; cMV_par16 := aRet[16] ; cMV_par17 := aRet[17] ; cMV_par18 := aRet[18]
	cMV_par19 := aRet[19] ; cMV_par20 := aRet[20] ; cMV_par21 := aRet[21] ; cMV_par22 := aRet[22] ; cMV_par23 := aRet[23]
	
	cMV_par13 := Iif( ValType( aRet[13] ) == 'C', aRet[13], Strzero( aRet[13], 2 ) )
	cMV_par15 := Iif( ValType( aRet[15] ) == 'C', Subs(aRet[15],1,1), LTrim( Str( aRet[15], 1, 0 ) ) )
	cMV_par22 := Iif( ValType( aRet[22] ) == 'C', Subs(aRet[22],1,1), LTrim( Str( aRet[22], 1, 0 ) ) )
	cMV_par23 := Iif( ValType( aRet[23] ) == 'C', Subs(aRet[23],1,1), LTrim( Str( aRet[23], 1, 0 ) ) )
	
	//cQuery += " select distinct tst.* from ( "
	cQuery += " SELECT " + CRLF 
	//Dados do Contrato  
	cQuery += " CN9_DTASSI, CN9_FILIAL, CN9_NUMERO, CN9_DESCRI, CN9_CTRPAI,CN9_CLIENT, CN9_LOJACL, CN9_DTREV, CN9_REVISA, CN9_SITUAC, CN9_DTINIC, CN9_DTFIM," + CRLF 
	cQuery += " TO_DATE(CN9_DTFIM, 'yyyymmdd') - TRUNC(SYSDATE) AS DIAS_VCTO, CN1_ESPCTR, CN1_DESCRI," + CRLF 
	cQuery += " CN9_VLATU,  CN9_MEDACU, CN9_SALDO, CN9_TPRENO, CN9_RECORR, CN9_OKAY, cn9_dtaniv, CN9_FLGREJ,CN9_CODOBJ," + CRLF
	cQuery += " CN9_XASSIN, CN9_XAREA, CN9_GESTC, CN9_X_NOMC, CN9_AVIPRE, CN9_ASSINA,CN9_DTENCE, " + CRLF

	//Caução  
	cQuery += " CN8_DTINVI, CN8_DTENT, CN8_DTFIVI, CN8_CODIGO, CN8_NUMDOC, CN8_VLEFET, CN9_MOEDA, CN9_INDICE " + CRLF
	 
	cQuery += " FROM " + RetSqlName("CN9") + " CN9 "   + CRLF
	
	cQuery += " INNER JOIN " + RetSqlName("CN1") + " CN1 ON CN1_FILIAL = CN9_FILIAL AND CN1_CODIGO = CN9_TPCTO AND CN1.D_E_L_E_T_= ' ' " + CRLF  
	cQuery += " AND CN1_CODIGO >= '" + cMV_par20 + "' AND CN1_CODIGO <= '" + cMV_par21 + "'" + CRLF  
		IF cMV_par15 $ '12'
			cQuery += "  AND CN1_ESPCTR = '" + cMV_par15 + "' " + CRLF
		EndIF  
	//cQuery += " LEFT JOIN  " + RetSqlName("CNC") + " CNC ON CNC_FILIAL = CN9_FILIAL AND CNC_NUMERO = CN9_NUMERO AND CNC_REVISA = CN9_REVISA AND CN1.D_E_L_E_T_= ' ' " + CRLF 
	cQuery += " LEFT JOIN " + RetSqlName("CN8") + " CN8 ON CN8_FILIAL = CN9_FILIAL AND CN8_CONTRA = CN9_NUMERO AND CN8_REVISA = CN9_REVISA AND CN8.D_E_L_E_T_ = ' ' " + CRLF
	
	/*cQuery += " INNER JOIN " + RetSqlName("CNN") + " CNN ON CNN_FILIAL = CN9_FILIAL AND CNN_CONTRA = CN9_NUMERO AND CNN_USRCOD <> ' ' " + CRLF
	cQuery += " AND CNN_TRACOD = '001' AND CNN.D_E_L_E_T_= ' '" + CRLF
	cQuery += " WHERE  CN9.D_E_L_E_T_ = ' ' " + CRLF
	
	cQuery += " AND CN9_FILIAL >= '" + cMV_par01 +       "' AND CN9_FILIAL <= '" + cMV_par02 +       "' " + CRLF
	cQuery += " AND CN9_DTASSI >= '" + DtoS(cMV_par03) + "' AND CN9_DTASSI <= '" + DtoS(cMV_par04) + "' " + CRLF
	cQuery += " AND CN9_NUMERO >= '" + cMV_par05 +       "' AND CN9_NUMERO <= '" + cMV_par06 +       "' " + CRLF
	cQuery += " AND CN9_REVISA >= '" + cMV_par07 +       "' AND CN9_REVISA <= '" + cMV_par08 +       "' " + CRLF
	cQuery += " AND CN9_DTINIC >= '" + DtoS(cMV_par09) + "' AND CN9_DTINIC <= '" + DtoS(cMV_par10) + "' " + CRLF
	IF .NOT. (  Empty(cMV_par11) .And. Empty(cMv_par12) )
		cQuery += " AND CN9_DTFIM  >= '" + DtoS(cMV_par11) + "' AND CN9_DTFIM  <= '" + DtoS(cMV_par12) + "' " + CRLF
	EndIF
	IF cMV_par13 <> 'To'
		cQuery += " AND CN9_SITUAC >= '" + cMV_par13 +       "' AND CN9_SITUAC <= '" + cMV_par13 +       "' " + CRLF
	EndIF
	IF cMV_par15 == '2'
		cQuery += " AND CN9_CLIENT >= '" + cMV_par18 + "' AND CN9_CLIENT <= '" + cMV_par19 + "' " + CRLF
	EndIF
	cQuery += " AND CN9_MOEDA  = '" + cMV_par22 + "' " + CRLF	
	
	//Union All para mostrar contrato FILHO
	/*cQuery += " UNION ALL (" + CRLF
	cQuery += " SELECT " + CRLF 
	//Dados do Contrato  
	//cQuery += " utl_raw.cast_to_varchar2(cast(dbms_lob.substr(CN9_MOTCAN,150,1) as varchar2(4000))) CN9_MOTCAN, "
	cQuery += " CN9_DTASSI, CN9_FILIAL, CN9_NUMERO, CN9_DESCRI ,CN9_CTRPAI, CN9_CLIENT, CN9_LOJACL, CN9_REVISA, CN9_SITUAC, CN9_DTINIC, CN9_DTFIM," + CRLF 
	cQuery += " TO_DATE(CN9_DTFIM, 'yyyymmdd') - TRUNC(SYSDATE) AS DIAS_VCTO, CN1_ESPCTR, CN1_DESCRI," + CRLF 
	cQuery += " CN9_VLATU,  CN9_MEDACU, CN9_SALDO, CN9_TPRENO, CN9_RECORR, CN9_OKAY, cn9_dtaniv,CN9_FLGREJ,CN9_CODOBJ," + CRLF 
	cQuery += "CASE " + CRLF
	cQuery += "WHEN CN1_ESPCTR = '1' THEN (SELECT TRIM(A2_NOME) AS A2_NOME FROM " + RetSqlName("SA2") + " SA2 " + CRLF
	cQuery += "						 WHERE  SA2.D_E_L_E_T_ = ' ' AND A2_FILIAL = ' ' " + CRLF
	cQuery += "								AND A2_COD || A2_LOJA IN (SELECT CNC_CODIGO || CNC_LOJA " + CRLF
	cQuery += "									 FROM " + RetSqlName("CNC") + " CNC WHERE CNC.D_E_L_E_T_ = ' ' AND CNC_FILIAL = CN9_FILIAL AND CNC_NUMERO = CN9_NUMERO AND CNC_REVISA = CN9_REVISA)) " + CRLF
	cQuery += "ELSE (SELECT TRIM(A1_NOME) AS A1_NOME FROM " + RetSqlName("SA1") + " SA1 " + CRLF
	cQuery += "   WHERE  SA1.D_E_L_E_T_ = ' ' AND A1_FILIAL = ' ' " + CRLF
	cQuery += "   AND A1_COD || A1_LOJA IN (SELECT CNC_CLIENT || CNC_LOJACL FROM " + RetSqlName("CNC") + " CNC " + CRLF
	cQuery += "							 WHERE  CNC.D_E_L_E_T_ = ' ' AND CNC_FILIAL = CN9_FILIAL AND CNC_NUMERO = CN9_NUMERO AND CNC_REVISA = CN9_REVISA)) " + CRLF
	cQuery += "END CLIFOR, " + CRLF
	//Caução  
	cQuery += " CN8_DTINVI, CN8_DTENT, CN8_DTFIVI, CN8_CODIGO, CN8_NUMDOC, CN8_VLEFET, CN9_MOEDA, CN9_INDICE " + CRLF
	 
	cQuery += " FROM " + RetSqlName("CN9") + " CN9 "   + CRLF
	
	cQuery += " INNER JOIN " + RetSqlName("CN1") + " CN1 ON CN1_FILIAL = CN9_FILIAL AND CN1_CODIGO = CN9_TPCTO AND CN1.D_E_L_E_T_= ' ' " + CRLF  
	cQuery += " AND CN1_CODIGO >= '" + cMV_par20 + "' AND CN1_CODIGO <= '" + cMV_par21 + "'" + CRLF  
		IF cMV_par15 $ '12'
			cQuery += "  AND CN1_ESPCTR = '" + cMV_par15 + "' " + CRLF
		EndIF  
	//cQuery += " LEFT JOIN  " + RetSqlName("CNC") + " CNC ON CNC_FILIAL = CN9_FILIAL AND CNC_NUMERO = CN9_NUMERO AND CNC_REVISA = CN9_REVISA AND CN1.D_E_L_E_T_= ' ' " + CRLF 
	cQuery += " LEFT JOIN " + RetSqlName("CN8") + " CN8 ON CN8_FILIAL = CN9_FILIAL AND CN8_CONTRA = CN9_NUMERO AND CN8.D_E_L_E_T_ = ' ' " + CRLF
	*/
	cQuery += " WHERE  CN9.D_E_L_E_T_ = ' ' " + CRLF
	
	cQuery += " AND CN9_FILIAL >= '" + cMV_par01 +       "' AND CN9_FILIAL <= '" + cMV_par02 +       "' " + CRLF
	cQuery += " AND CN9_DTASSI >= '" + DtoS(cMV_par03) + "' AND CN9_DTASSI <= '" + DtoS(cMV_par04) + "' " + CRLF
	cQuery += " AND CN9_NUMERO >= '" + cMV_par05 +       "' AND CN9_NUMERO <= '" + cMV_par06 +       "' " + CRLF
	cQuery += " AND CN9_REVISA >= '" + cMV_par07 +       "' AND CN9_REVISA <= '" + cMV_par08 +       "' " + CRLF
	cQuery += " AND CN9_DTINIC >= '" + DtoS(cMV_par09) + "' AND CN9_DTINIC <= '" + DtoS(cMV_par10) + "' " + CRLF
	IF .NOT. (  Empty(cMV_par11) .And. Empty(cMv_par12) )
		cQuery += " AND CN9_DTFIM  >= '" + DtoS(cMV_par11) + "' AND CN9_DTFIM  <= '" + DtoS(cMV_par12) + "' " + CRLF
	EndIF
	IF cMV_par13 <> 'To'
		cQuery += " AND CN9_SITUAC = '" + cMV_par13 + "' " + CRLF
	EndIF
	IF cMV_par15 == '2'
		cQuery += " AND CN9_CLIENT >= '" + cMV_par18 + "' AND CN9_CLIENT <= '" + cMV_par19 + "' " + CRLF
	EndIF
	cQuery += " AND CN9_MOEDA  = '" + cMV_par22 + "' " + CRLF	
	
	//cQuery += " )" + CRLF
	//cQuery += " )  tst "*/
	cQuery += " Order By CN9_FILIAL, CN9_NUMERO, CN9_REVISA ASC" + CRLF
	
	cShowQry += '< Dados do Contrato >' + CRLF
	cShowQry += cQuery + CRLF + CRLF
	
	// MEMOWRITE("C:\Protheus\TST_CONTRAT.sql",cQuery)
	cQuery := ChangeQuery(cQuery)
	
	IF Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasA, .F., .T.)
		
	IF .NOT. Eof( cAliasA )
		A020Excel( cAliasA )
	Else
		MsgAlert('A query não retornou registros, por favor verifique os parâmetros informados.', cTitulo)
	EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A020Excel | Autor | Rafael Beghini | Data | 10.07.2015 
//+-------------------------------------------------------------------+
//| Descr. | Gera o arquivo XML conforme query realizada. 
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A020Excel( cAliasA )
	Local cWorkSheet := 'Dados do Contrato'
	Local cTable     := 'Rel. Consolidado - Gestão de Contratos'
	Local cPath      := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile  := cPath + 'Contratos_' + dTos(Date()) + ".XML"
	Local aArea      := GetArea()
	
	Local cCN9_DTASSI := cCN9_DTINIC := cCN9_DTFIM := cCN9_DTREAJ := cCN8_DTINVI := cCN8_DTENT := cCN8_DTFIVI := cCN9_DTREV := '' 
	Local cCliFor := cCodCli := cNCliFor := cCN9Situa := cSituacao := cDescMoeda := cVcto := cPercent := cCodUser := cUserName := cFilName := ''
	Local cTpRenova := cRecorrencia := cAprovado := cCTRSUP := cTPCTR := cDataRej := cObjeto := cMotCan := ''
	Local cCNNRecno := nPos := 0
	Local aCN9_INDICE := {}
	Local aCLIFOR	:= {}
	Local cCN9_INDICE := ''
	Local nCN9_INDICE := ''
	Local cCN9_FILHOS := ''
	Local nCN9_FILHOS := ''
	Local cCN9_GESTN  := ''
	Local cCN9_ASSINA := ''
	Local cCN9_AVIPRE := ''
	Local cType := ''
	Local aDADOS      := {}
	Local aASSINA := {}
	Local cAssina := ''
	Local cArea	  := ''
	Local nL	:= 0
		                                                                                            
	oExcel := FWMSEXCEL():New() //Método para geração em XML
	
	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >     , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Data de Inclusão"      				, 1     , 4    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data Assinatura Contrato"			, 1     , 4    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Filial"		          				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nr. Contrato"          				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Categoria Contrato"    				, 1     , 1	   , .F. ) //Principal x Derivados
	oExcel:AddColumn( cWorkSheet, cTable, "Nr. Contrato Principal"				, 1     , 1	   , .F. ) //Principal x Derivados
	oExcel:AddColumn( cWorkSheet, cTable, "Desc. Contrato"        				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Cod Fornece/Cliente"   				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nome Fornece/Cliente"  				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data Revisão/Encerramento"			, 1     , 4	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Revisão"               				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Situação"              				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data de Inicio"       				, 1     , 4	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data Final"			  				, 1     , 4    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Dias Vencimento"       				, 1     , 2	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Aviso Prévio - Rescisão" 			, 1     , 2	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data do Reajuste"   	  				, 1     , 4    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Tipo do Contrato"      				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor Total Contrato"  				, 1     , 3	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Valor de Consumo"      				, 1     , 3	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Percentual Consumo"    				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Saldo do Contrato"     				, 1     , 3	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Inicio Garantia"       				, 1     , 4	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Entrega Garantia"      				, 1     , 4	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Encerramento Garantia" 				, 1     , 4	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Código Garantia"       				, 1     , 1	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Nº Documento"          				, 1     , 1	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Valor Garantia"        				, 1     , 3	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Desc. Moeda"           				, 1     , 1	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Usuário Responsável"   				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Índice"                				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Tp. Renovação"         				, 1     , 1	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Recorrência"          				, 1     , 1	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Aprovado"              				, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Motivo finaliz/cancelado "           , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Assinantes do Contrato"	            , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Área responsável"		            , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Gestor Responsável"		            , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Comprador Responsável"	            , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Objeto"					            , 1     , 1	   , .F. )
    
	CNC->( dbSetOrder(1) )
	CNN->( dbSetOrder(2) )
	SA1->( dbSetOrder(1) )
	SA2->( dbSetOrder(1) )
	RD0->( dbSetOrder(1) )
	
	While .NOT. Eof( cAliasA )
		
		/*IF (cAliasA)->CN1_ESPCTR == '1' //Tipo de Contrato 1-Compra 2-Venda
			IF CNC->( dbSeek( (cAliasA)->CN9_FILIAL + (cAliasA)->CN9_NUMERO + (cAliasA)->CN9_REVISA) )
				IF cMV_par15 == '1'
					IF .NOT. ( CNC->CNC_CODIGO >= cMV_par16 .And. CNC->CNC_CODIGO <= cMV_par17 )
						(cAliasA)->( dbSkip() )
						Loop
					EndIF
				EndIF
			cCodCli  := CNC->CNC_CODIGO
			cCliFor	:= CNC->CNC_CODIGO + CNC->CNC_LOJA
			cNCliFor := AllTrim(GetAdvFVal('SA2','A2_NOME', xFilial('SA2') + cCliFor,1,''))
			EndIF
		Else
			cCodCli  := (cAliasA)->CN9_CLIENT
			cCliFor	:= (cAliasA)->CN9_CLIENT + (cAliasA)->CN9_LOJACL
			cNCliFor := AllTrim(GetAdvFVal('SA1','A1_NOME', xFilial('SA1') + cCliFor,1,''))
		EndIF*/
		aCLIFOR  := A020CliFor( (cAliasA)->CN1_ESPCTR, (cAliasA)->CN9_FILIAL, (cAliasA)->CN9_NUMERO, (cAliasA)->CN9_REVISA )
		cCodCli  := aCLIFOR[1]
		cNCliFor := aCLIFOR[2]
		//Descrição da Filial
		cFilName := Rtrim( FWFilialName(, (cAliasA)->CN9_FILIAL, 1) )
		
		cCN9_DTASSI := IIF( Empty((cAliasA)->CN9_DTASSI), (cAliasA)->CN9_DTASSI, StoD((cAliasA)->CN9_DTASSI) )
		cCN9_ASSINA := IIF( Empty((cAliasA)->CN9_ASSINA), (cAliasA)->CN9_ASSINA, StoD((cAliasA)->CN9_ASSINA) ) 
		cCN9_DTINIC := IIF( Empty((cAliasA)->CN9_DTINIC), (cAliasA)->CN9_DTINIC, StoD((cAliasA)->CN9_DTINIC) ) 
		cCN9_DTFIM  := IIF( Empty((cAliasA)->CN9_DTFIM) , (cAliasA)->CN9_DTFIM , StoD((cAliasA)->CN9_DTFIM ) )
		cCN9_DTREV	:= IIF( Empty((cAliasA)->CN9_DTREV) , (cAliasA)->CN9_DTREV , StoD((cAliasA)->CN9_DTREV ) )
		cCN9_DTENCE := IIF( Empty((cAliasA)->CN9_DTENCE) , (cAliasA)->CN9_DTENCE , StoD((cAliasA)->CN9_DTENCE ) )
		cVcto       := IIF( (cAliasA)->Dias_vcto <= 0, 'Vencido', lTrim(Str((cAliasA)->Dias_vcto)) )
		cPercent    := lTrim( Str( Round( ( (cAliasA)->CN9_MEDACU / (cAliasA)->CN9_VLATU ) * 100, 5 ) ) ) + ' %'
		cDataRej    := StoD( IIF( Empty( (cAliasA)->CN9_DTANIV ), (cAliasA)->CN9_DTFIM, (cAliasA)->CN9_DTANIV) )
		cObjeto 	:= MSMM((cAliasA)->CN9_CODOBJ)
		cMotCan		:= AllTrim(GetAdvFVal('CN9','CN9_MOTCAN',(cAliasA)->CN9_FILIAL+(cAliasA)->CN9_NUMERO,1,''))

		if (cAliasA)->CN9_FLGREJ  = '1' 
			If cVcto = 'Vencido'
				cCN9_DTREAJ := cDataRej
			ElseIf MesDia( cDataRej ) < MesDia( MsDate() )
				cCN9_DTREAJ := StoD( lTrim(Str(Year(MsDate()) + 1)) + MesDia( cDataRej ) )

			Else
				cCN9_DTREAJ := StoD( lTrim(Str(Year(MsDate()))) + MesDia( cDataRej ) )
			EndIF
        ELSE
        		cCN9_DTREAJ :=""					
		endif
			
		cCN8_DTINVI := IIF( Empty((cAliasA)->CN8_DTINVI), (cAliasA)->CN8_DTINVI, StoD((cAliasA)->CN8_DTINVI) ) 
		cCN8_DTENT  := IIF( Empty((cAliasA)->CN8_DTENT) , (cAliasA)->CN8_DTENT , StoD((cAliasA)->CN8_DTENT ) ) 
		cCN8_DTFIVI := IIF( Empty((cAliasA)->CN8_DTFIVI), (cAliasA)->CN8_DTFIVI, StoD((cAliasA)->CN8_DTFIVI) )
		
		cCN9Situa := (cAliasA)->CN9_SITUAC
		//Situação do Contrato
		IF cCN9Situa == '01' ; cSituacao := 'Cancelado'
		ElseIF cCN9Situa == '02' ; cSituacao := 'Elaboração'
		ElseIF cCN9Situa == '03' ; cSituacao := 'Emitido'
		ElseIF cCN9Situa == '04' ; cSituacao := 'Aprovação'
		ElseIF cCN9Situa == '05' ; cSituacao := 'Vigente'
		ElseIF cCN9Situa == '06' ; cSituacao := 'Paralisado'
		ElseIF cCN9Situa == '07' ; cSituacao := 'Sol. Finalização'
		ElseIF cCN9Situa == '08' ; cSituacao := 'Finalizado'
		ElseIF cCN9Situa == '09' ; cSituacao := 'Revisão'
		ElseIF cCN9Situa == '10' ; cSituacao := 'Revisado'
		EndIF
		
		//Descrição da Moeda
		IF (cAliasA)->CN9_MOEDA == Val('1') ; cDescMoeda := 'Real'
		ElseIF (cAliasA)->CN9_MOEDA == Val('2') ; cDescMoeda := 'Dolar'
		ElseIF (cAliasA)->CN9_MOEDA == Val('3') ; cDescMoeda := 'Euro'
		ElseIF (cAliasA)->CN9_MOEDA == Val('4') ; cDescMoeda := 'Peso Arg.'
		ElseIF (cAliasA)->CN9_MOEDA == Val('5') ; cDescMoeda := 'Peso Chileno'
		EndIF
		
		//Tipo Renovação
		IF (cAliasA)->CN9_TPRENO == '1' ; cTpRenova := 'Aditivo'
		ElseIF (cAliasA)->CN9_TPRENO == '2' ; cTpRenova := 'Automático'
		ElseIF (cAliasA)->CN9_TPRENO == '3' ; cTpRenova := 'Indeterminado'
		EndIF
		
		//Recorrência
		IF (cAliasA)->CN9_RECORR == '1' ; cRecorrencia := 'Fixo'
		ElseIF (cAliasA)->CN9_RECORR == '2' ; cRecorrencia := 'Variável'		 
		ElseIF (cAliasA)->CN9_RECORR == '3' ; cRecorrencia := 'Ambos'
		EndIF
		
		//Contrato Aprovado?
		IF (cAliasA)->CN9_OKAY == '0' ; cAprovado := 'Legado'
		ElseIF (cAliasA)->CN9_OKAY == '1' ; cAprovado := 'Em aprovação'
		ElseIF (cAliasA)->CN9_OKAY == '2' ; cAprovado := 'Aprovado'
		ElseIF (cAliasA)->CN9_OKAY == '3' ; cAprovado := 'Rejeitado' 
		EndIF
		
		//Tipo do Contrato (Principal x Derivado)
		IF Empty( (cAliasA)->CN9_CTRPAI ) ; cTPCTR := 'Principal'
		Else ; cTPCTR := 'Derivado' 
		EndIF
		cCTRSUP   := (cAliasA)->CN9_CTRPAI
		cCTRNUM   := (cAliasA)->CN9_NUMERO
		
//		cVcto     := IIF( (cAliasA)->Dias_vcto <= 0, 'Vencido', lTrim(Str((cAliasA)->Dias_vcto)) )
//		cPercent  := lTrim( Str( Round( ( (cAliasA)->CN9_MEDACU / (cAliasA)->CN9_VLATU ) * 100, 5 ) ) ) + ' %'
		
		CNN->( dbSeek( (cAliasA)->CN9_FILIAL + Space(06) + (cAliasA)->CN9_NUMERO + '001'  ) )
		cCNNRecno := CNN->( Recno() )
		While .NOT. Eof() .And. CNN->CNN_FILIAL == (cAliasA)->CN9_FILIAL .And. CNN->CNN_CONTRA == (cAliasA)->CN9_NUMERO ;
						.And. Empty(CNN->CNN_GRPCOD) .And. CNN->CNN_TRACOD == '001'
			IF cCNNRecno >= CNN->( Recno() )
				cCNNRecno := CNN->( Recno() )
				cCodUser  := CNN->CNN_USRCOD
			EndIF
		CNN->( dbSkip() )
		End
		
		cUserName := Alltrim( UsrFullName( cCodUser ) )
		
		cCN9_INDICE := Posicione( "CN6", 1, (cAliasA)->CN9_FILIAL + (cAliasA)->CN9_INDICE, "CN6_DESCRI" )
		
		IF .Not. Empty( (cAliasA)->CN9_XASSIN )
			aASSINA := StrToKarr( (cAliasA)->CN9_XASSIN, '|' )
			For nL := 1 To Len( aASSINA )
				RD0->( dbSeek( xFilial('RD0') + aASSINA[nL] ) )
				cAssina += rTrim(RD0->RD0_NOME) + ' / '
			Next nL
			aASSINA := {}
		EndIF
		
		IF cCN9Situa == '08'
			cCN9_DTREV	:= cCN9_DTENCE
		ElseIF Empty( (cAliasA)->CN9_REVISA )
			cCN9_DTREV	:= cCN9_DTASSI
		EndIF

		cArea := rTrim( Posicione( 'SX5', 1, '02' + 'Z5' + (cAliasA)->CN9_XAREA , "X5_DESCRI" ) )

		cCN9_GESTN 	:= Posicione("RD0",1,xFilial("RD0")+(cAliasA)->CN9_GESTC,"RD0_NOME")
		cCN9_AVIPRE := Transform((cAliasA)->CN9_AVIPRE,"@E 999")
		
		
		aDADOS := { cCN9_DTASSI, cCN9_ASSINA,cFilName, (cAliasA)->CN9_NUMERO, cTPCTR, cCTRSUP, (cAliasA)->CN9_DESCRI, cCodCli, cNCliFor, cCN9_DTREV,;
					(cAliasA)->CN9_REVISA, cSituacao, cCN9_DTINIC, cCN9_DTFIM, cVcto, cCN9_AVIPRE, cCN9_DTREAJ, (cAliasA)->CN1_DESCRI, (cAliasA)->CN9_VLATU,; 
				  	(cAliasA)->CN9_MEDACU, cPercent, (cAliasA)->CN9_SALDO, cCN8_DTINVI, cCN8_DTENT, cCN8_DTFIVI,; 
				  	(cAliasA)->CN8_CODIGO, (cAliasA)->CN8_NUMDOC, (cAliasA)->CN8_VLEFET, cDescMoeda, cUserName,;
				  	cCN9_INDICE, cTpRenova, cRecorrencia, cAprovado,	cMotCan, cAssina, cArea , cCN9_GESTN, (cAliasA)->CN9_X_NOMC,cObjeto} 
		
		oExcel:AddRow( cWorkSheet, cTable, aDADOS )
		
		aDADOS := {}
				  
		(cAliasA)->( dbSkip() )
		
		cCliFor := cCodCli := cNCliFor := cSituacao := cDescMoeda := cVcto := cPercent := cUserName := cCNNRecno := cCodUser := ''
		cTpRenova := cRecorrencia := cAprovado := cTPCTR := cCTRSUP := cAssina := ''
	End
	
	(cAliasA)->( dbCloseArea() )
	
	A020Planilha()
	A020Medicao()
	
	IF cMV_par23 == '1' //Dados do cronograma
		A020Cronograma()
	EndIF 
	
	IF File( cNameFile )
		Ferase( cNameFile )
	EndIF		
	
	Sleep(500)
		
	oExcel:Activate()              //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório
//	CpyS2T( cNameFile, "C:\TEMP\PERFORMA\",.T. )
	IF ! ApOleClient("MsExcel") 
		MsgAlert("MsExcel não instalado. Para abrir o arquivo, localize-o na pasta %temp% .","Contratos")
	Else
		ShellExecute( "Open", cNameFile , '', '', 1 ) //Abre o arquivo na tela após salvar
	EndIF
	RestArea(aArea)
Return
//+-------------------------------------------------------------------+
//| Rotina | A020Planilha | Autor | Rafael Beghini | Data | 04.09.2015 
//+-------------------------------------------------------------------+
//| Descr. | Cria a query conforme parâmetros no Parambox
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A020Planilha()
	Local cWorkSheet := 'Dados da Planilha'
	Local cTable     := 'Rel. Consolidado - Gestão de Contratos'
	Local cAliasB    := GetNextAlias() 
	Local aArea      := GetArea()
	Local cQuery     := cPlanilha := cFilName := ''
	Local cType := ''
	Local aDADOS      := {}
	 
	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	oExcel:AddColumn( cWorkSheet, cTable, "Filial"		           	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Tipo de Contrato"       	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nr. Contrato"          	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Revisão"              	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Parcelado"			  	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Periodicidade de Pag." 	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nr. Planilha"          	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Desc. Planilha"        	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Tipo Planilha"         	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor Total da Planilha" , 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Saldo Total da Planilha" , 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Item Produto "         	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição Produto"     	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Qtde. Total Produto"   	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vlr. Unitário Produto" 	, 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vlr. Total Produto"    	, 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Qtde. Entregue Produto"	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Saldo em Qtde Produto" 	, 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Saldo em R$ Produto"   	, 1     , 3	   , .F. )
	
     cQuery := "SELECT DISTINCT " + CRLF
     cQuery += "CNA_FILIAL, CNA_CONTRA, CNA_REVISA, CNA_NUMERO, CNA_XDESCR, CNA_TIPPLA, CNA_SALDO, CNA_VLTOT," + CRLF
  		//Itens da Planilha 
     cQuery += "CNB_ITEM, CNB_PRODUT, B1_DESC, CNB_QUANT, CNB_VLUNIT, CNB_VLTOT, CNB_QTDMED, CNB_SLDMED, CN1_ESPCTR," + CRLF
     cQuery += "(CNB_VLUNIT * CNB_SLDMED) AS SALDO," + CRLF
     cQuery += "CNA_XPARC," + CRLF
	 cQuery += "CASE" + CRLF
	 cQuery += "WHEN CNA_XPARC ='S' THEN 'SIM'" + CRLF
	 cQuery += "ELSE 'NAO' END AS PARCELADO," + CRLF
	 cQuery += "CNA_X_PERI," + CRLF
	 cQuery += "CASE" + CRLF
	 cQuery += "WHEN CNA_X_PERI ='V' THEN 'A VISTA'" + CRLF
	 cQuery += "WHEN CNA_X_PERI ='A' THEN 'ANUAL'" + CRLF
	 cQuery += "WHEN CNA_X_PERI ='M' THEN 'MENSAL'" + CRLF
	 cQuery += "WHEN CNA_X_PERI ='C' THEN 'CONF. CONSUMO'" + CRLF
	 cQuery += "WHEN CNA_X_PERI ='P' THEN 'PARCELADO'" + CRLF
	 cQuery += "WHEN CNA_X_PERI ='T' THEN 'TRIMESTRAL'" + CRLF
	 cQuery += "END AS PERIODICIDADE," + CRLF
	 cQuery += "CN9_ESPCTR," + CRLF
	 cQuery += "CASE" + CRLF
	 cQuery += "WHEN CN1_ESPCTR ='1' THEN 'COMPRAS'" + CRLF
	 cQuery += "ELSE 'VENDAS' END AS TPCONTRATO" + CRLF
     cQuery += "FROM " + RetSqlName("CNA") + " CNA "   + CRLF
	
	cQuery += "INNER JOIN " + RetSqlName("CN9") + " CN9 ON CN9_FILIAL = CNA_FILIAL AND CN9_NUMERO = CNA_CONTRA " + CRLF
	cQuery += "AND CN9_REVISA = CNA_REVISA AND CN9.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "AND CN9_FILIAL >= '" + cMV_par01 +       "' AND CN9_FILIAL <= '" + cMV_par02 +       "' " + CRLF
	cQuery += "AND CN9_DTASSI >= '" + DtoS(cMV_par03) + "' AND CN9_DTASSI <= '" + DtoS(cMV_par04) + "' " + CRLF
	cQuery += "AND CN9_NUMERO >= '" + cMV_par05 +       "' AND CN9_NUMERO <= '" + cMV_par06 +       "' " + CRLF
	cQuery += "AND CN9_REVISA >= '" + cMV_par07 +       "' AND CN9_REVISA <= '" + cMV_par08 +       "' " + CRLF
	cQuery += "AND CN9_DTINIC >= '" + DtoS(cMV_par09) + "' AND CN9_DTINIC <= '" + DtoS(cMV_par10) + "' " + CRLF
	IF .NOT. (  Empty(cMV_par11) .And. Empty(cMv_par12) )
		cQuery += "AND CN9_DTFIM  >= '" + DtoS(cMV_par11) + "' AND CN9_DTFIM  <= '" + DtoS(cMV_par12) + "' " + CRLF
	EndIF
	IF cMV_par15 == '2'
		cQuery += "AND CN9_CLIENT >= '" + cMV_par18 + "' AND CN9_CLIENT <= '" + cMV_par19 + "' " + CRLF
	EndIF
	cQuery += "AND CN9_MOEDA  = '" + cMV_par22 + "' " + CRLF	
	//cQuery += "AND CN9_SITUAC = '05' " + CRLF
	
	cQuery += "INNER JOIN  " + RetSqlName("CN1") + " CN1 ON CN1_FILIAL = CN9_FILIAL AND CN1_CODIGO = CN9_TPCTO AND CN1.D_E_L_E_T_= ' ' " + CRLF  
	cQuery += "AND CN9_TPCTO >= '" + cMV_par20 + "' AND CN9_TPCTO <= '" + cMV_par21 + "'" + CRLF 
	cQuery += "AND CN1_CODIGO >= '" + cMV_par20 + "' AND CN1_CODIGO <= '" + cMV_par21 + "'" + CRLF 
	IF cMV_par15 $ '12'
		cQuery += "AND CN1_ESPCTR = '" + cMV_par15 + "' " + CRLF
	EndIF
		
	//cQuery += "INNER JOIN  " + RetSqlName("CNB") + " CNB ON CNB_FILIAL = CNA_FILIAL AND CNB_CONTRA = CNA_CONTRA " + CRLF
	//cQuery += /*"AND CNB_REVISA = CNA_REVISA AND CNB_NUMERO = CNA_NUMERO*/" AND CNB.D_E_L_E_T_ = ' ' " + CRLF
	//cQuery += "LEFT JOIN   " + RetSqlName("SB1") + " SB1 ON CNB_FILIAL = B1_FILIAL  AND CNB_PRODUT = B1_COD AND SB1.D_E_L_E_T_ = ' ' " + CRLF

	cQuery += "LEFT JOIN  " + RetSqlName("CNB") + " CNB ON CNB_FILIAL = CNA_FILIAL AND CNB_CONTRA = CNA_CONTRA " + CRLF
	cQuery += "AND CNB_REVISA = CNA_REVISA AND CNB_NUMERO = CNA_NUMERO AND CNB.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "LEFT JOIN   " + RetSqlName("SB1") + " SB1 ON CNB_FILIAL = B1_FILIAL  AND CNB_PRODUT = B1_COD AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	
	cQuery += "WHERE CNA.D_E_L_E_T_= ' '
	cQuery += "AND CNA_CONTRA >= '" + cMV_par05 + "' AND CNA_CONTRA <= '" + cMV_par06 + "' " + CRLF
	cQuery += "AND CNA_REVISA >= '" + cMV_par07 + "' AND CNA_REVISA <= '" + cMV_par08 + "' " + CRLF

	cQuery += "Order By CNA_FILIAL, CNA_CONTRA, CNA_REVISA, CNA_NUMERO, CNB_ITEM ASC"
	
	cShowQry += '< Dados da Planilha >' + CRLF
	cShowQry += cQuery + CRLF + CRLF
	
	cQuery := ChangeQuery(cQuery)
	
	IF Select( cAliasB ) > 0
		dbSelectArea( cAliasB )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasB, .F., .T.)
	
	IF .NOT. Eof( cAliasB )
		CNC->( dbSetOrder(1) )
		CNL->( dbSetOrder(1) )
		
		While .NOT. Eof( cAliasB )
			
			IF (cAliasB)->CN1_ESPCTR == '1' //Tipo de Contrato 1-Compra 2-Venda
				IF CNC->( dbSeek( (cAliasB)->CNA_FILIAL + (cAliasB)->CNA_CONTRA + (cAliasB)->CNA_REVISA) )
					IF cMV_par15 == '1'
						IF .NOT. ( CNC->CNC_CODIGO >= cMV_par16 .And. CNC->CNC_CODIGO <= cMV_par17 )
							(cAliasB)->( dbSkip() )
							Loop
						EndIF
					EndIF
				EndIF
			EndIF
		
			//Tipo da Planilha
			IF CNL->( dbSeek( (cAliasB)->CNA_FILIAL + (cAliasB)->CNA_TIPPLA ) )
				cPlanilha := (cAliasB)->CNA_TIPPLA + ' - ' + Alltrim(CNL->CNL_DESCRI)
			Else
				cPlanilha := (cAliasB)->CNA_TIPPLA
			EndIF
			

			//Descrição da Filial
			cFilName := Rtrim( FWFilialName(, (cAliasB)->CNA_FILIAL, 1) )
			
			aDADOS := { cFilName, (cAliasB)->TPCONTRATO, (cAliasB)->CNA_CONTRA, (cAliasB)->CNA_REVISA, (cAliasB)->PARCELADO, (cAliasB)->PERIODICIDADE,;
			  (cAliasB)->CNA_NUMERO, (cAliasB)->CNA_XDESCR, cPlanilha, (cAliasB)->CNA_VLTOT, (cAliasB)->CNA_SALDO, (cAliasB)->CNB_ITEM, (cAliasB)->B1_DESC,; 
			  Str((cAliasB)->CNB_QUANT), (cAliasB)->CNB_VLUNIT, (cAliasB)->CNB_VLTOT,; 
			  Str((cAliasB)->CNB_QTDMED), Str((cAliasB)->CNB_SLDMED), (cAliasB)->SALDO }
			
			  
			oExcel:AddRow( cWorkSheet, cTable, aDADOS )
		
			aDADOS := {}	    
			(cAliasB)->( dbSkip() )
			cPlanilha := ''
		End
		(cAliasB)->( dbCloseArea() )
	EndIF
	RestArea(aArea)
Return
//+-------------------------------------------------------------------+
//| Rotina | A020Medicao | Autor | Rafael Beghini | Data | 04.09.2015 
//+-------------------------------------------------------------------+
//| Descr. | Cria a query conforme parâmetros no Parambox
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A020Medicao()
	Local cWorkSheet := 'Dados da Medicao'
	Local cTable     := 'Rel. Consolidado - Gestão de Contratos'
	Local cAliasC    := GetNextAlias() 
	Local aArea      := GetArea()
	Local cQuery     := cCodCC := cDescCC := cCCAprov := cDescAprov := cTpRenova :=  cFilName := cRecorrencia := cAprovado := cCND_DTINIC := cCND_DTVENC := cCND_DTFIM := ''
	Local cType := ''
	Local aDADOS      := {}
	
	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	oExcel:AddColumn( cWorkSheet, cTable, "Filial"		           , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nr. Contrato"          , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nr. Planilha"          , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Competência"           , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nr. Medição"           , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Item"                  , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Produto"               , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Qtde Medida"           , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vlr. Unit. Medição"    , 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vlr. Desconto - CAB"   , 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vlr. Desconto - ITENS" , 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Tp. Variação"          , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Motivo"                , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vlr. Variação"         , 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vlr. Total Medição"    , 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "C. Custo Despesa"      , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"             , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "C. Custo Aprovador"    , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"             , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido Compra/Venda"   , 1     , 1	   , .F. )	
	oExcel:AddColumn( cWorkSheet, cTable, "Data de Inclusão"      , 1     , 4	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data de Vencimento"    , 1     , 4	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data de Encerramento"  , 1     , 4	   , .F. )
	
   cQuery := "SELECT DISTINCT " + CRLF
   cQuery += "CND_FILIAL, CND_CONTRA, CND_REVISA, CND_NUMERO, CND_NUMMED, CND_COMPET, CND_DTINIC, CND_DTVENC, CND_DTFIM," + CRLF
  	//Itens da Medição 
   cQuery += "CNE_ITEM, CNE_PRODUT, TRIM(B1_DESC) B1_DESC, CNE_QUANT, CNE_VLUNIT, CNE_VLTOT, C7_CC, CND_PEDIDO, CN1_ESPCTR," + CRLF
   //Itens de Desconto, Multa e/ou Bonificação.
   cQuery += "NVL(CNQ_VALOR,0)CNQ_VALOR, CNR_TIPO, Trim(CNR_DESCRI)CNR_DESCRI, NVL(CNR_VALOR,0)CNR_VALOR,"
   cQuery += "CASE" + CRLF
	cQuery += "  WHEN NVL(CNQ_VALOR,0) > 0" + CRLF
	cQuery += "    THEN CNE_VLTOT - CNQ_VALOR" + CRLF
	cQuery += "  WHEN NVL(CNR_VALOR,0) > 0 AND CNR_TIPO = '1'" + CRLF
	cQuery += "    THEN CNE_VLTOT - CNR_VALOR" + CRLF
	cQuery += "  WHEN NVL(CNR_VALOR,0) > 0 AND CNR_TIPO = '2'" + CRLF
	cQuery += "    THEN CNE_VLTOT + CNR_VALOR" + CRLF
	cQuery += "  ELSE" + CRLF
	cQuery += "    CNE_VLTOT" + CRLF
	cQuery += "END VLTOT," + CRLF
	cQuery += "CNE_VLDESC," + CRLF
	cQuery += "CND_DESCME" + CRLF
   
   cQuery += "FROM " + RetSqlName("CND") + " CND "   + CRLF
	
	cQuery += "LEFT JOIN " + RetSqlName("CNE") + " CNE ON CNE_FILIAL = CND_FILIAL AND CNE_CONTRA = CND_CONTRA AND CNE_NUMMED = CND_NUMMED " + CRLF 
	cQuery += "AND CNE_NUMERO = CND_NUMERO AND CNE_REVISA = CND_REVISA AND CNE_QUANT > 0 AND CNE.D_E_L_E_T_ = ' ' " + CRLF
	
	cQuery += "LEFT JOIN " + RetSqlName("SC7") + " SC7 ON C7_FILIAL = CND_FILIAL AND C7_NUM = CND_PEDIDO AND C7_CONTRA = CND_CONTRA AND SC7.D_E_L_E_T_= ' '" + CRLF
	
	cQuery += "LEFT JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = CNE_FILIAL AND B1_COD = CNE_PRODUT AND SB1.D_E_L_E_T_= ' ' " + CRLF
	
	cQuery += "INNER JOIN " + RetSqlName("CN9") + " CN9 ON CN9_FILIAL = CND_FILIAL AND CN9_NUMERO = CND_CONTRA " + CRLF
	cQuery += "AND CN9_REVISA = CND_REVISA AND CN9.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "AND CN9_FILIAL >= '" + cMV_par01 +       "' AND CN9_FILIAL <= '" + cMV_par02 +       "' " + CRLF
	cQuery += "AND CN9_DTASSI >= '" + DtoS(cMV_par03) + "' AND CN9_DTASSI <= '" + DtoS(cMV_par04) + "' " + CRLF
	cQuery += "AND CN9_NUMERO >= '" + cMV_par05 +       "' AND CN9_NUMERO <= '" + cMV_par06 +       "' " + CRLF
	cQuery += "AND CN9_REVISA >= '" + cMV_par07 +       "' AND CN9_REVISA <= '" + cMV_par08 +       "' " + CRLF
	cQuery += "AND CN9_DTINIC >= '" + DtoS(cMV_par09) + "' AND CN9_DTINIC <= '" + DtoS(cMV_par10) + "' " + CRLF
	IF .NOT. (  Empty(cMV_par11) .And. Empty(cMv_par12) )
		cQuery += "AND CN9_DTFIM  >= '" + DtoS(cMV_par11) + "' AND CN9_DTFIM  <= '" + DtoS(cMV_par12) + "' " + CRLF
	EndIF
	IF cMV_par13 <> 'To'
		cQuery += " AND CN9_SITUAC >= '" + cMV_par13 +       "' AND CN9_SITUAC <= '" + cMV_par13 +       "' " + CRLF
	EndIF
	IF cMV_par15 == '2'
		cQuery += "AND CN9_CLIENT >= '" + cMV_par18 + "' AND CN9_CLIENT <= '" + cMV_par19 + "' " + CRLF
	EndIF
	cQuery += "AND CN9_MOEDA  = '" + cMV_par22 + "' " + CRLF	
	
	cQuery += "INNER JOIN " + RetSqlName("CN1") + " CN1 ON CN1_FILIAL = CN9_FILIAL AND CN1_CODIGO = CN9_TPCTO AND CN1.D_E_L_E_T_= ' ' " + CRLF  
	cQuery += "AND CN1_CODIGO >= '" + cMV_par20 + "' AND CN1_CODIGO <= '" + cMV_par21 + "'" + CRLF  
	IF cMV_par15 $ '12'
		cQuery += "AND CN1_ESPCTR = '" + cMV_par15 + "' " + CRLF
	EndIF  
	
	cQuery += "LEFT JOIN " + RetSqlName("CNQ") + " CNQ ON CNQ_FILIAL = CND_FILIAL AND CNQ_CONTRA = CND_CONTRA AND CNQ_NUMMED = CND_NUMMED AND CNQ.D_E_L_E_T_= ' '" + CRLF 
	cQuery += "LEFT JOIN " + RetSqlName("CNR") + " CNR ON CNR_FILIAL = CND_FILIAL AND CNR_CONTRA = CND_CONTRA AND CNR_NUMMED = CND_NUMMED AND CNR.D_E_L_E_T_= ' '" + CRLF
	
	cQuery += "WHERE CND.D_E_L_E_T_= ' '" + CRLF
	cQuery += "AND CND_CONTRA >= '" + cMV_par05 + "' AND CND_CONTRA <= '" + cMV_par06 + "' " + CRLF
	cQuery += "AND CND_REVISA >= '" + cMV_par07 + "' AND CND_REVISA <= '" + cMV_par08 + "' " + CRLF

	cQuery += "Order By CND_CONTRA, CND_REVISA, CND_NUMMED, CND_NUMERO, CND_COMPET, CNE_ITEM ASC"
	
	cShowQry += '< Dados da Medição >' + CRLF
	cShowQry += cQuery + CRLF + CRLF
	
	cQuery := ChangeQuery(cQuery)
	
	IF Select( cAliasC ) > 0
		dbSelectArea( cAliasC )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasC, .F., .T.)
	
	IF .NOT. Eof( cAliasC )
		CNC->( dbSetOrder(1) )
		SC7->( dbSetOrder(1) )
		
		While .NOT. Eof( cAliasC )
			
			IF (cAliasC)->CN1_ESPCTR == '1' //Tipo de Contrato 1-Compra 2-Venda
				IF CNC->( dbSeek( (cAliasC)->CND_FILIAL + (cAliasC)->CND_CONTRA + (cAliasC)->CND_REVISA) )
					IF cMV_par15 == '1'
						IF .NOT. ( CNC->CNC_CODIGO >= cMV_par16 .And. CNC->CNC_CODIGO <= cMV_par17 )
							(cAliasC)->( dbSkip() )
							Loop
						EndIF
					EndIF
				EndIF
			EndIF
			
			IF SC7->( dbSeek( (cAliasC)->CND_FILIAL + (cAliasC)->CND_PEDIDO ) ) .And. .NOT. Empty( (cAliasC)->CND_PEDIDO )
				cCodCC   := SC7->C7_CC
				cCCAprov := SC7->C7_CCAPROV
				SC7->( dbGotop() )
				IF CTT->( dbSeek( xFilial('CTT') + cCodCC ) )
					cDescCC := rTrim(CTT->CTT_DESC01)
				EndIF
				SC7->( dbGotop() )
				IF CTT->( dbSeek( xFilial('CTT') + cCCAprov ) )
					cDescAprov := rTrim(CTT->CTT_DESC01)
				EndIF
			EndIF
			
			//Descrição da Filial
			cFilName := Rtrim( FWFilialName(, (cAliasC)->CND_FILIAL, 1) )		 
			 
			cCND_DTINIC := IIF( Empty((cAliasC)->CND_DTINIC), (cAliasC)->CND_DTINIC, StoD((cAliasC)->CND_DTINIC) ) 
			cCND_DTVENC := IIF( Empty((cAliasC)->CND_DTVENC), (cAliasC)->CND_DTVENC, StoD((cAliasC)->CND_DTVENC) ) 
			cCND_DTFIM  := IIF( Empty((cAliasC)->CND_DTFIM), (cAliasC)->CND_DTFIM, StoD((cAliasC)->CND_DTFIM) ) 
			
			IF (cAliasC)->CNR_TIPO == '1'
				cType := 'DECRESCIMO'
			ElseIF (cAliasC)->CNR_TIPO == '2'
				cType := 'ACRESCIMO'
			Else
				cType := ''
			EndIF
			
			oExcel:AddRow( cWorkSheet, cTable,;
				{ cFilName, (cAliasC)->CND_CONTRA, (cAliasC)->CND_NUMERO, (cAliasC)->CND_COMPET, (cAliasC)->CND_NUMMED, (cAliasC)->CNE_ITEM, (cAliasC)->B1_DESC,;
							  Str((cAliasC)->CNE_QUANT), (cAliasC)->CNE_VLUNIT, (cAliasC)->CND_DESCME,(cAliasC)->CNE_VLDESC, cType, (cAliasC)->CNR_DESCRI, (cAliasC)->CNR_VALOR,;
							  (cAliasC)->VLTOT, cCodCC, cDescCC, cCCAprov, cDescAprov, (cAliasC)->CND_PEDIDO, cCND_DTINIC,;
							  cCND_DTVENC, cCND_DTFIM } )
			    
		(cAliasC)->( dbSkip() )
			cCodCC := cDescCC := cCCAprov := cDescAprov := cType := ''
		End
		(cAliasC)->( dbCloseArea() )
	EndIF
	RestArea(aArea)
Return
//+-------------------------------------------------------------------+
//| Rotina | A020Cronograma | Autor | Rafael Beghini | Data | 04.09.2015 
//+-------------------------------------------------------------------+
//| Descr. | Cria a query conforme parâmetros no Parambox
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A020Cronograma()
	Local cWorkSheet  := 'Dados do Cronograma'
	Local cTable      := 'Rel. Consolidado - Gestão de Contratos'
	Local cAliasD     := GetNextAlias() 
	Local aArea       := GetArea()
	Local cQuery      := cFilName := cCNF_DTVENC := cCNF_PRUMED := cCNF_DTREAL := ''
	Local cType := ''
	Local aDADOS      := {}
	
	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	oExcel:AddColumn( cWorkSheet, cTable, "Filial"		       , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nr. Contrato"          , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nr. Planilha"          , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Competência"           , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nr. Cronograma"        , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nr. Parcela"           , 1     , 1	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vlr. Prev. Parc"       , 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vlr. Realizado"        , 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Saldo Parc."           , 1     , 3	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Dt. Vencto. Med"       , 1     , 4	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Dt. Prev. Med."        , 1     , 4	   , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Dt. Realizado"         , 1     , 4	   , .F. )
	
     cQuery := "SELECT DISTINCT " + CRLF
     cQuery += "CNF_FILIAL, CNF_CONTRA, CNF_REVISA, CNF_NUMERO, CNF_PARCEL, CNF_VLPREV, CNF_VLREAL, CNF_SALDO, CNF_DTVENC, CNF_PRUMED, CNF_DTREAL," + CRLF 
     cQuery += "CNF_COMPET, CN1_ESPCTR, CNA_NUMERO" + CRLF
  	
     cQuery += "FROM " + RetSqlName("CNF") + " CNF "   + CRLF
	
	cQuery += "INNER JOIN " + RetSqlName("CN9") + " CN9 ON CN9_FILIAL = CNF_FILIAL AND CN9_NUMERO = CNF_CONTRA " + CRLF
	cQuery += "AND CN9_REVISA = CNF_REVISA AND CN9.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "AND CN9_FILIAL >= '" + cMV_par01 +       "' AND CN9_FILIAL <= '" + cMV_par02 +       "' " + CRLF
	cQuery += "AND CN9_DTASSI >= '" + DtoS(cMV_par03) + "' AND CN9_DTASSI <= '" + DtoS(cMV_par04) + "' " + CRLF
	cQuery += "AND CN9_NUMERO >= '" + cMV_par05 +       "' AND CN9_NUMERO <= '" + cMV_par06 +       "' " + CRLF
	cQuery += "AND CN9_REVISA >= '" + cMV_par07 +       "' AND CN9_REVISA <= '" + cMV_par08 +       "' " + CRLF
	cQuery += "AND CN9_DTINIC >= '" + DtoS(cMV_par09) + "' AND CN9_DTINIC <= '" + DtoS(cMV_par10) + "' " + CRLF
	IF .NOT. (  Empty(cMV_par11) .And. Empty(cMv_par12) )
		cQuery += "AND CN9_DTFIM  >= '" + DtoS(cMV_par11) + "' AND CN9_DTFIM  <= '" + DtoS(cMV_par12) + "' " + CRLF
	EndIF
	IF cMV_par15 == '2'
		cQuery += "AND CN9_CLIENT >= '" + cMV_par18 + "' AND CN9_CLIENT <= '" + cMV_par19 + "' " + CRLF
	EndIF
	cQuery += "AND CN9_MOEDA  = '" + cMV_par22 + "' " + CRLF	
	cQuery += "AND CN9_SITUAC = '05' " + CRLF
	
	cQuery += "INNER JOIN  " + RetSqlName("CN1") + " CN1 ON CN1_FILIAL = CN9_FILIAL AND CN1_CODIGO = CN9_TPCTO AND CN1.D_E_L_E_T_= ' ' " + CRLF  
	cQuery += "AND CN1_CODIGO >= '" + cMV_par20 + "' AND CN1_CODIGO <= '" + cMV_par21 + "'" + CRLF  
		IF cMV_par15 $ '12'
			cQuery += "  AND CN1_ESPCTR = '" + cMV_par15 + "' " + CRLF
		EndIF  
		
	cQuery += "INNER JOIN  " + RetSqlName("CNA") + " CNA ON CNA_FILIAL = CNF_FILIAL AND CNA_CONTRA = CNF_CONTRA AND CNA_REVISA = CNF_REVISA" + CRLF 
	cQuery += "AND CNA_CRONOG = CNF_NUMERO AND CNA.D_E_L_E_T_= ' ' " + CRLF
	 
	cQuery += "WHERE CNF.D_E_L_E_T_= ' '" + CRLF
	cQuery += "AND CNF_CONTRA >= '" + cMV_par05 + "' AND CNF_CONTRA <= '" + cMV_par06 + "' " + CRLF
	cQuery += "AND CNF_REVISA >= '" + cMV_par07 + "' AND CNF_REVISA <= '" + cMV_par08 + "' " + CRLF

	cQuery += "Order By CNF_FILIAL, CNF_CONTRA, CNF_REVISA, CNF_NUMERO, CNF_PARCEL ASC"
	
	cShowQry += '< Dados do Cronograma >' + CRLF
	cShowQry += cQuery + CRLF + CRLF
	
	cQuery := ChangeQuery(cQuery)
	
	IF Select( cAliasD ) > 0
		dbSelectArea( cAliasD )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasD, .F., .T.)
	
	IF .NOT. Eof( cAliasD )
		While .NOT. Eof( cAliasD )
			
			IF (cAliasD)->CN1_ESPCTR == '1' //Tipo de Contrato 1-Compra 2-Venda
				IF CNC->( dbSeek( (cAliasD)->CNF_FILIAL + (cAliasD)->CNF_CONTRA + (cAliasD)->CNF_REVISA) )
					IF cMV_par15 == '1'
						IF .NOT. ( CNC->CNC_CODIGO >= cMV_par16 .And. CNC->CNC_CODIGO <= cMV_par17 )
							(cAliasD)->( dbSkip() )
							Loop
						EndIF
					EndIF
				EndIF
			EndIF
			
			cCNF_DTVENC := IIF( Empty((cAliasD)->CNF_DTVENC), (cAliasD)->CNF_DTVENC, StoD((cAliasD)->CNF_DTVENC) ) 
			cCNF_PRUMED := IIF( Empty((cAliasD)->CNF_PRUMED), (cAliasD)->CNF_PRUMED, StoD((cAliasD)->CNF_PRUMED) ) 
			cCNF_DTREAL := IIF( Empty((cAliasD)->CNF_DTREAL) , (cAliasD)->CNF_DTREAL , StoD((cAliasD)->CNF_DTREAL ) )
			
			//Descrição da Filial
			cFilName := Rtrim( FWFilialName(, (cAliasD)->CNF_FILIAL, 1) )
			 
			oExcel:AddRow( cWorkSheet, cTable,;
				{ cFilName, (cAliasD)->CNF_CONTRA, (cAliasD)->CNA_NUMERO, (cAliasD)->CNF_COMPET, (cAliasD)->CNF_NUMERO, (cAliasD)->CNF_PARCEL,; 
				  (cAliasD)->CNF_VLPREV, (cAliasD)->CNF_VLREAL, (cAliasD)->CNF_SALDO, cCNF_DTVENC, cCNF_PRUMED, cCNF_DTREAL  } )
			    
		(cAliasD)->( dbSkip() )
		End
		(cAliasD)->( dbCloseArea() )
	EndIF
	RestArea(aArea)
Return

//-----------------------------------------------------------------------
// Rotina | A020ShowQry | Autor | Robson Gonçalves    | Data | 11.09.2015
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar o script de instrução SQL na tela.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A020ShowQry( cSQL )
	Local cNomeArq := ''
	Local nHandle := 0
	Local lEmpty := .F.
	AutoGrLog('ativar para apagar')
	cNomeArq := NomeAutoLog()
	lEmpty := Empty( cNomeArq )
	If !lEmpty
		nHandle := FOpen( cNomeArq, 2 )
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
	AutoGrLog( cSQL )
	MostraErro()
	If !lEmpty
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
Return

//+-------------------------------------------------------------------+
//| Rotina | A020F3 | Autor | Rafael Beghini | Data | 21.02.2018
//+-------------------------------------------------------------------+
//| Descr. | Consulta personalizada para selecionar a situação
//|        | do contrato.
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function A020F3()
	
	Local aRet	:= {}
	Local nLin	:= 0
		
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	IF dbSeek( 'CN9_SITUAC' )   
		aRet := StrToKarr( X3CBox(), ';' )
		aADD( aRet, 'Todos' )
	EndIF
	
Return( aRet )

Static Function A020CliFor( cTipo, xCN9xFil, cCTR, cREV )
	Local cCOD	:= ''
	Local cLOJ	:= ''
	Local aRET	:= Array( 02 )
	
	CNC->( MsSeek( xCN9xFil + cCTR + cREV ) )
	IF cTipo == '1' //Fornecedor
		cCOD := CNC->CNC_CODIGO
		cLOJ := CNC->CNC_LOJA
		SA2->( MsSeek( xFilial('SA2') + cCOD + cLOJ ) )
		aRET[1] := cCOD
		aRET[2] := rTrim( SA2->A2_NOME )
	Else
		cCOD := CNC->CNC_CLIENT
		cLOJ := CNC->CNC_LOJACL
		SA1->( MsSeek( xFilial('SA1') + cCOD + cLOJ ) )
		aRET[1] := cCOD
		aRET[2] := rTrim( SA1->A1_NOME )
	EndIF
Return ( aRET )
