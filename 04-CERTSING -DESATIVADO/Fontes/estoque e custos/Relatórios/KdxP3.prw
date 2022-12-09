//-----------------------------------------------------------------
// Rotina | KDXP3 | Autor | Robson Gonçalves          | Data | 2015 
//-----------------------------------------------------------------
// Descr. | Kardex do controle de 3º no caso os parceiros.
//-----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-----------------------------------------------------------------
#Include 'Protheus.ch'
#include 'totvs.ch'
#include 'topconn.ch'

User Function KdxP3()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private cCadastro := 'Kardex - Poder de 3º'
	Private lExpQry   := .F.
	Private lExpDados := .F.
	Private lExpTrack := .F.
	
	SetKey( VK_F11 , {|| KdxP3Aut() } )
	
	AAdd( aSay, 'Esta rotina tem por objetivo em gerar o Kardex dos movimentos de poder de terceiros.' )
	AAdd( aSay, 'Por favor, clique no botão OK para prosseguir e informar os parâmetros para o' )
	AAdd( aSay, 'processamento.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
   
	If nOpcao==1
		KdxParam()
	Endif
	
	SetKey( VK_F11 , {|| NIL })
Return

/******
 *
 * Rotina...: Rotina para solicitar os parâmetros para o usuário.
 * Autor....: Robson Gonçalves
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
Static Function KdxParam()
	//Local lRet := .F.
	Local lExiste := .F.
	
	Local cFile := ''
	
	Local nErro := 0
	
	Private aPoint := {'|','/','-','\'}
	Private aParamBox := {}
	Private aPergRet := {}
	Private aDADOS := {}
	Private aTrack := {}
	Private aVisao := {'1=Fornec + Produto e Resultados ',;
	                   '2=Fornec + Produto + Doc e Resultado ',;
	                   '3=Fornec + Produto + Doc + GAR e Resultado',;
	                   '4=Consumo médio do fornecedor',;
	                   '5=Resumo das remessas + consumo médio'}
	
	AAdd(aParamBox,{1,"Filial de"     ,Space(Len(SB6->B6_FILIAL)),"","","SM0_01","",50,.F.})
	AAdd(aParamBox,{1,"Filial até"    ,Space(Len(SB6->B6_FILIAL)),"","","SM0_01","",50,.T.})
	AAdd(aParamBox,{1,"Fornecedor de" ,Space(06),"","","SA2","",50,.F.})
	AAdd(aParamBox,{1,"Fornecedor até",Space(06),"","","SA2","",50,.T.})
	AAdd(aParamBox,{1,"Produto de"    ,Space(15),"","","SB1","",70,.F.})
	AAdd(aParamBox,{1,"Produto até" 	 ,Space(15),"","","SB1","",70,.T.})
	AAdd(aParamBox,{1,"Data de"       ,Ctod(Space(8)),"","","","",50,.F.})
	AAdd(aParamBox,{1,"Data até"      ,Ctod(Space(8)),"","","","",50,.T.})
	AAdd(aParamBox,{2,"Visão"         ,1,aVisao,120,"",.F.})
	
	If ParamBox(aParamBox,'Parâmetros',aPergRet,,,,,,,,.T.,.T.)
		If ValType( aPergRet[ 9 ] )  == 'C'
			aPergRet[ 9 ] := Val( SubStr( aPergRet[ 9 ], 1, 1 ) )
			MV_PAR09 := aPergRet[ 9 ]
		Endif
		If MV_PAR09==4
			cCadastro := 'Consumo médio do fornecedor'
		Endif
		cFile := CriaTrab(NIL,.F.)+'.xml'
		lExiste := File( cFile )	
		If lExiste
			nErro := FErase( cFile )
		Endif
		If lExiste .And. nErro == -1
			MsgAlert('Problemas ao tentar gerar o arquivo Excel. Verifique se há planilha está aberta e tente novamente.',cCadastro)
		Else
			If     MV_PAR09==1 ; cRotina := 'KdxProc1( "'+cFile+'" )'
			Elseif MV_PAR09==2 ; cRotina := 'KdxProc2( "'+cFile+'" )'
			Elseif MV_PAR09==3 ; cRotina := 'KdxProc3( "'+cFile+'" )'
			Elseif MV_PAR09==4 ; cRotina := 'KdxProc4( "'+cFile+'" )'
			Elseif MV_PAR09==5 ; cRotina := 'KdxProc5( "'+cFile+'" )'
			Endif
			MsAguarde( {|| &(cRotina) }, cCadastro, 'Início do processo, aguarde...', .F. )
		Endif
	Endif
Return

/******
 *
 * Rotina...: Rotina de processamento considerando a visão 1.
 * Autor....: Robson Gonçalves
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
Static Function KdxProc1( cFile )
	Local cDir := ''
	Local cDirTmp := ''
	Local cSQL := ''
	//Local cTRB := GetNextAlias()
	Local cWorkSheet := 'Kardex'
	Local cTable := 'Kardex - Poder de Terceiros'
	Local nPoint := 0
	Local nQtdMovta := 0
	//Local aMain := {}
	
	Local oFwMsEx	
	Local oExcelApp
	
   MsProcTxt( 'Buscando os dados para iniciar o processamento...'  )
   ProcessMessage()

	cSQL := "SELECT B6_CLIFOR, "
	cSQL += "       B6_LOJA, "
	cSQL += "       A2_NOME, "
	cSQL += "       B6_PRODUTO, "
	cSQL += "       B1_DESC, "
	cSQL += "       ( T_REM_ANT - T_RET_ANT ) AS SLD_INI, "
	cSQL += "       T_REM_PER, "
	cSQL += "       T_RET_PER, "
	cSQL += "       ( ( T_REM_ANT - T_RET_ANT ) + T_REM_PER - T_RET_PER ) AS SLD_FIM "
//	cSQL += "FROM   (SELECT DISTINCT B6_CLIFOR, "
	cSQL += "FROM   (SELECT  B6_CLIFOR, "
	cSQL += "                B6_LOJA, "
	cSQL += "                A2_NOME, "
	cSQL += "                B6_PRODUTO, "
	cSQL += "                B1_DESC,"
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" REMANT "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND REMANT.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES > '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'R' "
	cSQL += "                        AND B6_EMISSAO < "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_REM_ANT, "
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" RETANT "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND RETANT.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES < '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'D' "
	cSQL += "                        AND B6_EMISSAO < "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_RET_ANT, "
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" REMPER "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND REMPER.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES > '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'R' "
	cSQL += "                        AND B6_EMISSAO BETWEEN "+ValToSql(MV_PAR07)+" AND "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_REM_PER, "
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" RETPER "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND RETPER.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES < '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'D' "
	cSQL += "                        AND B6_EMISSAO BETWEEN "+ValToSql(MV_PAR07)+" AND "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_RET_PER "
	cSQL += "FROM   "+RetSqlName("SB6")+" MAIN "
	cSQL += "       INNER JOIN "+RetSqlName("SA2")+" SA2 "
	cSQL += "               ON A2_FILIAL = "+ValToSql(xFilial("SA2"))+" "
	cSQL += "                  AND A2_COD = MAIN.B6_CLIFOR "
	cSQL += "                  AND A2_LOJA = MAIN.B6_LOJA "
	cSQL += "                  AND SA2.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" SB1 "
	cSQL += "               ON B1_FILIAL = "+ValToSql(xFilial("SB1"))+" "
	cSQL += "                  AND B1_COD = MAIN.B6_PRODUTO "
	cSQL += "                  AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  MAIN.D_E_L_E_T_ = ' ' "
	cSQL += "       AND B6_FILIAL = "+ValToSql(xFilial("SB6"))+" "
	cSQL += "       AND B6_CLIFOR BETWEEN "+ValToSql(MV_PAR03)+" AND "+ValToSql(MV_PAR04)+" "
	cSQL += "       AND B6_PRODUTO BETWEEN "+ValToSql(MV_PAR05)+" AND "+ValToSql(MV_PAR06)+" "
	cSQL += "       AND B6_EMISSAO BETWEEN "+ValToSql(MV_PAR07)+" AND "+ValToSql(MV_PAR08)+") "
	cSQL += "ORDER  BY B6_CLIFOR, "
	cSQL += "          B6_LOJA, "
	cSQL += "          B6_PRODUTO "

	Memowrite("D:\TEMP\kdxP3_KdxProc1", cSQL )
	
	cSQL := ChangeQuery( cSQL )
	
	If lExpQry
		StaticCall( CSFA110, A110Script, cSQL )
	Endif
	
	If lExpDados .OR. lExpTrack
		MsgAlert( 'A visão selecionada não trabalha com os vetores aDADOS ou aTrack.', cCadastro )
	Endif

	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.T.,.T.)
	TCQUERY cSQL alias "Kdx1" NEW
	
	If Kdx1->( .NOT. BOF() ) .AND. Kdx1->( .NOT. EOF() )
		oFwMsEx := FWMsExcel():New()
		
		ParamExc( @oFwMsEx )
	   
	   oFwMsEx:AddWorkSheet( cWorkSheet )
	   oFwMsEx:AddTable( cWorkSheet, cTable )	
	
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Fornecedor"            , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto"               , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Descrição"             , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Saldo inicial"         , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Remessa"               , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Retorno"               , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Saldo final"           , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Quantidade movimentada", 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Saldo pelo movimento." , 3,1)
		
		While Kdx1->( .NOT. EOF() )
			nPoint++
			If nPoint == 5
				nPoint := 1
			Endif
			
		   MsProcTxt( 'Aguarde, lendo registros [ ' + aPoint[ nPoint ] + ' ]'  )
		   ProcessMessage()
			
			nQtdMovta := GetMovto( MV_PAR07, MV_PAR08, Kdx1->B6_PRODUTO, Kdx1->B6_CLIFOR )
			
			oFwMsEx:AddRow( cWorkSheet, cTable, { Kdx1->B6_CLIFOR + '-' + Kdx1->B6_LOJA + ' ' + Kdx1->A2_NOME,;
			Kdx1->B6_PRODUTO, Kdx1->B1_DESC,;
         Kdx1->SLD_INI, Kdx1->T_REM_PER, Kdx1->T_RET_PER, Kdx1->SLD_FIM, nQtdMovta, ( Kdx1->T_REM_PER - nQtdMovta ) } )
         
			Kdx1->( dbSkip() )
		End
		
		oFwMsEx:Activate()
		cDirTmp := GetTempPath()
		cDir := GetSrvProfString("Startpath","")
	
		LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cFile ), Sleep( 500 ) } )
	
		If __CopyFile( cFile, cDirTmp + cFile )
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cFile )
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			Sleep(500)
		Else
			MsgInfo( "Não foi possível copiar o arquivo para o diretório temporário do usuário." )
		Endif
	Else
		MsgAlert('Não há dados com os parâmetros informados.',cCadastro)
	Endif
	Kdx1->( dbCloseArea() )
Return

/******
 *
 * Rotina...: Rotina auxiliar da visão para buscar o movimento.
 * Autor....: Robson Gonçalves.
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
Static Function GetMovto( dDataDe, dDataAte, cProd, cFornec )
	Local cSQL := ''
	//Local cTRB := GetNextAlias()
	Local nQtdMidia := 0

	cSQL := "SELECT NVL(FORNEC, ' ')       AS FORNEC, "
	cSQL += "       NVL(LOJA, ' ')         AS LOJA, "
	cSQL += "       A2_NOME, "
	cSQL += "       CODMIDIA, "
	cSQL += "       DESCMIDIA, "
	cSQL += "       NVL(Sum(QTDMIDIA), 0)  AS QTDMIDIA "
	cSQL += "FROM   (SELECT SZ8.Z8_FORNEC  AS FORNEC, "
	cSQL += "               SZ8.Z8_LOJA    AS LOJA, "
	cSQL += "               SZ5.Z5_PRODGAR AS PRODGAR, "
	cSQL += "               SZ5.Z5_DATVER  AS DATAMOV, "
	cSQL += "               SB1.B1_COD     AS CODMIDIA, "
	cSQL += "               SB1.B1_DESC    AS DESCMIDIA, "
	cSQL += "               SG1.G1_QUANT   AS QTDMIDIA, "
	cSQL += "               SZ5.Z5_NFDEV   NF_RETORNO_TERCEIRO, "
	cSQL += "               SZ5.Z5_PEDGAR, "
	cSQL += "               SZ5.Z5_PEDSITE, "
	cSQL += "               SZ5.Z5_PEDIDO, "
	cSQL += "               SZ5.Z5_DESCAR  AS AR, "
	cSQL += "               SZ5.Z5_CODPOS  AS COD_POSTO, "
	cSQL += "               SZ5.Z5_DESPOS  AS POSTO, "
	cSQL += "               SZ5.Z5_NOMAGE  AS AGENTE, "
	cSQL += "               SZ5.Z5_GRUPO   AS GRUPO, "
	cSQL += "               SZ5.Z5_REDE    AS REDE "
	cSQL += "        FROM   "+RETSQLNAME("SZ5")+" SZ5 "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ3")+" SZ3 "
	cSQL += "                      ON SZ3.Z3_FILIAL = "+VALTOSQL(XFILIAL("SZ3"))+" "
	cSQL += "                         AND SZ3.Z3_CODGAR = SZ5.Z5_CODPOS "
	cSQL += "                         AND SZ3.Z3_CODGAR > ' ' "
	cSQL += "                         AND SZ3.Z3_TIPENT = '4' "
	cSQL += "                         AND SZ3.D_E_L_E_T_ <> '*' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ8")+" SZ8 "
	cSQL += "                      ON SZ8.Z8_FILIAL = "+VALTOSQL(XFILIAL("SZ8"))+" "
	cSQL += "                         AND SZ8.Z8_COD = SZ3.Z3_PONDIS "
	cSQL += "                         AND SZ8.D_E_L_E_T_ = ' ' "
	cSQL += "               INNER JOIN "+RETSQLNAME("PA8")+" PA8 "
	cSQL += "                       ON PA8.PA8_FILIAL = "+VALTOSQL(XFILIAL("PA8"))+" "
	cSQL += "                          AND PA8.PA8_CODBPG = SZ5.Z5_PRODGAR "
	cSQL += "                          AND PA8.D_E_L_E_T_ = ' ' "
	cSQL += "               INNER JOIN "+RETSQLNAME("SG1")+" SG1 "
	cSQL += "                       ON SG1.G1_FILIAL = '02' "
	cSQL += "                          AND SG1.G1_COD = PA8.PA8_CODMP8 "
	cSQL += "                          AND SG1.D_E_L_E_T_ = ' ' "
	cSQL += "               INNER JOIN "+RETSQLNAME("SB1")+" SB1 "
	cSQL += "                       ON SB1.B1_FILIAL = "+VALTOSQL(XFILIAL("SB1"))+" "
	cSQL += "                          AND SB1.B1_COD = G1_COMP "
	cSQL += "                          AND SB1.B1_CATEGO = '1' "
	cSQL += "                          AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "        WHERE  SZ5.Z5_FILIAL = "+VALTOSQL(XFILIAL("SZ5"))+" "
	cSQL += "               AND SZ5.Z5_DATVER >= "+VALTOSQL(dDataDe)+" "
	CSQL += "               AND SZ5.Z5_DATVER <= "+VALTOSQL(dDataAte)+" "
	cSQL += "               AND SZ5.Z5_PRODGAR > ' ' "
	cSQL += "               AND SZ5.Z5_CODPOS > ' ' "
	cSQL += "               AND SZ5.Z5_PEDGANT = ' ' "
	cSQL += "               AND SZ5.D_E_L_E_T_ = ' ' "
	cSQL += "               AND SB1.B1_COD >= "+VALTOSQL(cProd)+" "
	cSQL += "               AND SB1.B1_COD <= "+VALTOSQL(cProd)+" "
	cSQL += "               AND SZ8.Z8_FORNEC >= "+VALTOSQL(cFornec)+" "
	cSQL += "               AND SZ8.Z8_FORNEC <= "+VALTOSQL(cFornec)+" "
	cSQL += "        UNION ALL "
	cSQL += "        SELECT SZ8.Z8_FORNEC  AS FORNEC, "
	cSQL += "               SZ8.Z8_LOJA    AS LOJA, "
	cSQL += "               SZ5.Z5_PRODGAR AS PRODGAR, "
	cSQL += "               SZ5.Z5_EMISSAO AS DATAMOV, "
	cSQL += "               SB1.B1_COD     AS CODMIDIA, "
	cSQL += "               SB1.B1_DESC    AS DESCMIDIA, "
	cSQL += "               SC6.C6_QTDVEN  AS QTDMIDIA, "
	cSQL += "               SZ5.Z5_NFDEV   NF_RETORNO_TERCEIRO, "
	cSQL += "               SZ5.Z5_PEDGAR, "
	cSQL += "               SZ5.Z5_PEDSITE, "
	cSQL += "               SZ5.Z5_PEDIDO, "
	cSQL += "               SZ5.Z5_DESCAR  AS AR, "
	cSQL += "               SZ5.Z5_CODPOS  AS COD_POSTO, "
	cSQL += "               SZ5.Z5_DESPOS  AS POSTO, "
	cSQL += "               SZ5.Z5_NOMAGE  AS AGENTE, "
	cSQL += "               SZ5.Z5_GRUPO   AS GRUPO, "
	cSQL += "               SZ5.Z5_REDE    AS REDE "
	cSQL += "        FROM   "+RETSQLNAME("SZ5")+" SZ5 "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ3")+" SZ3 "
	cSQL += "                      ON SZ3.Z3_FILIAL = "+VALTOSQL(XFILIAL("SZ3"))+" "
	cSQL += "                         AND SZ3.Z3_CODGAR = SZ5.Z5_CODPOS "
	cSQL += "                         AND SZ3.Z3_CODGAR > ' ' "
	cSQL += "                         AND SZ3.Z3_TIPENT = '4' "
	cSQL += "                         AND SZ3.D_E_L_E_T_ = ' ' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ8")+" SZ8 "
	cSQL += "                      ON SZ8.Z8_FILIAL = "+VALTOSQL(XFILIAL("SZ8"))+" "
	cSQL += "                         AND SZ8.Z8_COD = SZ3.Z3_PONDIS "
	cSQL += "                         AND SZ8.D_E_L_E_T_ = ' ' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SB1")+" SB1 "
	cSQL += "                      ON SB1.B1_FILIAL = "+VALTOSQL(XFILIAL("SB1"))+" "
	cSQL += "                         AND SB1.B1_COD = SZ5.Z5_PRODUTO "
	cSQL += "                         AND SB1.B1_CATEGO = '1' "
	cSQL += "                         AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SC6")+" SC6 "
	cSQL += "                      ON SC6.C6_FILIAL = "+VALTOSQL(XFILIAL("SC6"))+" "
	cSQL += "                         AND SC6.C6_NUM = SZ5.Z5_PEDIDO "
	cSQL += "                         AND SC6.C6_ITEM = SZ5.Z5_ITEMPV "
	cSQL += "                         AND SC6.D_E_L_E_T_ = ' ' "
	cSQL += "        WHERE  SZ5.Z5_FILIAL = "+VALTOSQL(XFILIAL("SZ5"))+" "
	cSQL += "               AND SZ5.Z5_DATVER >= "+VALTOSQL(dDataDe)+" "
	CSQL += "               AND SZ5.Z5_DATVER <= "+VALTOSQL(dDataAte)+" "
	cSQL += "               AND SZ5.Z5_TIPO = 'ENTHAR' "
	cSQL += "               AND SZ5.D_E_L_E_T_ = ' ' "	
	cSQL += "               AND SZ8.Z8_FORNEC >= "+VALTOSQL(cFornec)+" "
	cSQL += "               AND SZ8.Z8_FORNEC <= "+VALTOSQL(cFornec)+" "
	cSQL += "               AND SB1.B1_COD >= "+VALTOSQL(cProd)+" "
	cSQL += "               AND SB1.B1_COD <= "+VALTOSQL(cProd)+" ) RESULTADO "
	cSQL += "       INNER JOIN "+RETSQLNAME("SA2")+" SA2 "
	cSQL += "               ON A2_FILIAL = "+VALTOSQL(XFILIAL("SA2"))+" "
	cSQL += "                  AND A2_COD = FORNEC "
	cSQL += "                  AND A2_LOJA = LOJA "
	cSQL += "                  AND SA2.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  FORNEC <> ' ' "
	cSQL += "        OR LOJA <> ' ' "
	cSQL += "        OR QTDMIDIA <> 0 "
	cSQL += "GROUP  BY FORNEC, "
	cSQL += "          LOJA, "
	cSQL += "          A2_NOME, "
	cSQL += "          CODMIDIA, "
	cSQL += "          DESCMIDIA "
	cSQL += "ORDER  BY 1, "
	cSQL += "          3, "
	cSQL += "          4 "

	Memowrite("D:\TEMP\kdxP3_KdxRemessa", cSQL )

	cSQL := ChangeQuery( cSQL )
	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.T.,.T.)
	TCQUERY cSQL alias "GetM" NEW
	nQtdMidia := GetM->QTDMIDIA
	GetM->( dbCloseArea() )
Return( nQtdMidia )

/******
 *
 * Rotina...: Rotina de processamento considerando a visão 2.
 * Autor....: Robson Gonçalves
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
Static Function KdxProc2( cFile )
	Local cDir := ''
	Local cDirTmp := ''
	Local cSQL := ''
	Local cKey := ''
	//Local cTRB := GetNextAlias()
	Local cWorkSheet := 'Kardex'
	Local cTable := 'Kardex - Poder de Terceiros'
	Local nPoint := 0
	
	//Local aMain := {}
	
	Local nSaldo := 0
	Local nSldIni := 0
	Local nRemessa := 0
	Local nRetorno := 0
	Local oFwMsEx	
	Local oExcelApp

   MsProcTxt( 'Buscando os dados para iniciar o processamento...'  )
   ProcessMessage()

	cSQL := "SELECT B6_CLIFOR, "
	cSQL += "       B6_LOJA, "
	cSQL += "       A2_NOME, "
	cSQL += "       B6_PRODUTO, "
	cSQL += "       B1_DESC, "
	cSQL += "       B6_EMISSAO, "
   cSQL += "       B6_DOC, "
	cSQL += "       ( T_REM_ANT - T_RET_ANT ) AS SLD_INI, "
	cSQL += "       T_REM_PER, "
	cSQL += "       T_RET_PER, "
	cSQL += "       B6_QUANT, "
	cSQL += "       ( ( T_REM_ANT - T_RET_ANT ) + T_REM_PER - T_RET_PER ) AS SLD_FIM, "
	cSQL += "       B6_TES "
//	cSQL += "FROM   (SELECT DISTINCT B6_CLIFOR, "
	cSQL += "FROM   (SELECT B6_CLIFOR, "
	cSQL += "                B6_LOJA, "
	cSQL += "                A2_NOME, "
	cSQL += "                B6_PRODUTO, "
	cSQL += "                B1_DESC,"
   cSQL += "                B6_EMISSAO, "
   cSQL += "                B6_DOC, "
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" REMANT "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND REMANT.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES > '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'R' "
	cSQL += "                        AND B6_EMISSAO < "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_REM_ANT, "
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" RETANT "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND RETANT.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES < '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'D' "
	cSQL += "                        AND B6_EMISSAO < "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_RET_ANT, "
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" REMPER "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND REMPER.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES > '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'R' "
	cSQL += "                        AND B6_EMISSAO BETWEEN "+ValToSql(MV_PAR07)+" AND "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_REM_PER, "
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" RETPER "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND RETPER.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES < '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'D' "
	cSQL += "                        AND B6_EMISSAO BETWEEN "+ValToSql(MV_PAR07)+" AND "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_RET_PER, "
	cSQL += "                B6_QUANT, "
	cSQL += "                B6_TES "
	cSQL += "FROM   "+RetSqlName("SB6")+" MAIN "
	cSQL += "       INNER JOIN "+RetSqlName("SA2")+" SA2 "
	cSQL += "               ON A2_FILIAL = "+ValToSql(xFilial("SA2"))+" "
	cSQL += "                  AND A2_COD = MAIN.B6_CLIFOR "
	cSQL += "                  AND A2_LOJA = MAIN.B6_LOJA "
	cSQL += "                  AND SA2.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" SB1 "
	cSQL += "               ON B1_FILIAL = "+ValToSql(xFilial("SB1"))+" "
	cSQL += "                  AND B1_COD = MAIN.B6_PRODUTO "
	cSQL += "                  AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  MAIN.D_E_L_E_T_ = ' ' "
	cSQL += "       AND B6_FILIAL = "+ValToSql(xFilial("SB6"))+" "
	cSQL += "       AND B6_CLIFOR BETWEEN "+ValToSql(MV_PAR03)+" AND "+ValToSql(MV_PAR04)+" "
	cSQL += "       AND B6_PRODUTO BETWEEN "+ValToSql(MV_PAR05)+" AND "+ValToSql(MV_PAR06)+" "
	cSQL += "       AND B6_EMISSAO BETWEEN "+ValToSql(MV_PAR07)+" AND "+ValToSql(MV_PAR08)+") "
	cSQL += "ORDER  BY B6_CLIFOR, "
	cSQL += "          B6_LOJA, "
	cSQL += "          B6_PRODUTO, "
	cSQL += "          B6_EMISSAO "

	Memowrite("D:\TEMP\kdxP3_KdxProc2", cSQL )
	
	cSQL := ChangeQuery( cSQL )
	
	If lExpQry
		StaticCall( CSFA110, A110Script, cSQL )
	Endif

	If lExpDados .OR. lExpTrack
		MsgAlert( 'A visão selecionada não trabalha com os vetores aDADOS ou aTrack.', cCadastro )
	Endif

	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.T.,.T.)
	TCQUERY cSQL alias "Kdx2" NEW
	
	If Kdx2->( .NOT. BOF() ) .AND. Kdx2->( .NOT. EOF() )
		oFwMsEx := FWMsExcel():New()
	   
		ParamExc( @oFwMsEx )

	   oFwMsEx:AddWorkSheet( cWorkSheet )
	   oFwMsEx:AddTable( cWorkSheet, cTable )	
	
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Fornecedor"   , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto"      , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Descrição"    , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Sld.Inicial"  , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Emissão"      , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Documento"    , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Remessa"      , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Retorno"      , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Saldo"        , 3,1)
	
		While Kdx2->( .NOT. EOF() )
			nPoint++
			If nPoint == 5
				nPoint := 1
			Endif
			
		   MsProcTxt( 'Aguarde, lendo registros [ ' + aPoint[ nPoint ] + ' ]'  )
		   ProcessMessage()
		   
			If cKey <> Kdx2->B6_CLIFOR + Kdx2->B6_LOJA + Kdx2->B6_PRODUTO
				cKey := Kdx2->B6_CLIFOR + Kdx2->B6_LOJA + Kdx2->B6_PRODUTO
				nSldIni := Kdx2->SLD_INI
				nSaldo  := Kdx2->SLD_INI
			Endif
			
 			If Kdx2->B6_TES > '500'
 				nRemessa := Kdx2->B6_QUANT
 				nSaldo := nSaldo + Kdx2->B6_QUANT
 			Else
 				nRetorno := Kdx2->B6_QUANT
 				nSaldo := nSaldo - Kdx2->B6_QUANT
 			Endif
 			
			oFwMsEx:AddRow( cWorkSheet, cTable, { Kdx2->B6_CLIFOR + '-' + Kdx2->B6_LOJA + ' ' + Kdx2->A2_NOME,;
			                                      Kdx2->B6_PRODUTO,;
			                                      Kdx2->B1_DESC,;
			                                      nSldIni,;
			                                      Dtoc(Stod(Kdx2->B6_EMISSAO)),;
			                                      Kdx2->B6_DOC,;
			                                      nRemessa,;
			                                      nRetorno,;
   		                                      nSaldo } )
   		nSldIni := 0
   		nRemessa := 0
   		nRetorno := 0
			Kdx2->( dbSkip() )
		End
		
		oFwMsEx:Activate()
		cDirTmp := GetTempPath()
		cDir := GetSrvProfString("Startpath","")
	
		LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cFile ), Sleep( 500 ) } )
	
		If __CopyFile( cFile, cDirTmp + cFile )
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cFile )
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			Sleep(500)
		Else
			MsgInfo( "Não foi possível copiar o arquivo para o diretório temporário do usuário." )
		Endif
	Else
		MsgAlert('Não há dados com os parâmetros informados.',cCadastro)
	Endif
	Kdx2->( dbCloseArea() )
Return

/******
 *
 * Rotina...: Rotina de processamento considerando a visão 3.
 * Autor....: Robson Gonçalves
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
Static Function KdxProc3( cFile )
	Local cDir := ''
	Local cDirTmp := ''
	Local cSQL := ''
	Local cKey := ''
	//Local cTRB := GetNextAlias()
	Local cWorkSheet := 'Kardex'
	Local cTable := 'Kardex - Poder de Terceiros'
		
	Local oFwMsEx	
	Local oExcelApp

	Local nCLIFOR   := 1
	Local nNOMEFOR  := 3
	Local nPRODUTO  := 4
	Local nDESCRICAO:= 5
	Local nSALDOINI := 6
	Local nDATA     := 7
	Local nDOC      := 8
	Local nREMESSA  := 9
	Local nRETORNO  := 10
	Local nSALDO    := 11
	
	Local cFor := ''
	Local cFornecedor := ''
	Local cProd := ''
	Local nLenDados := 0
	Local nSldInicial := 0
	Local nP := 0
	Local nI := 0
	Local nE := 1
	Local lFirst := .T.
	Local nRem := 0
	Local nRet := 0
	Local nSldIni := 0
	Local nSld := 0
	Local cDOC := ''
	Local nPoint := 0
	
   MsProcTxt( 'Buscando os dados para iniciar o processamento...'  )
   ProcessMessage()

	cSQL := "SELECT B6_CLIFOR, "
	cSQL += "       B6_LOJA, "
	cSQL += "       A2_NOME, "
	cSQL += "       B6_PRODUTO, "
	cSQL += "       B1_DESC, "
	cSQL += "       B6_EMISSAO, "
   cSQL += "       B6_DOC, "
	cSQL += "       ( T_REM_ANT - T_RET_ANT ) AS SLD_INI, "
	cSQL += "       T_REM_PER, "
	cSQL += "       T_RET_PER, "
	cSQL += "       B6_QUANT, "
	cSQL += "       ( ( T_REM_ANT - T_RET_ANT ) + T_REM_PER - T_RET_PER ) AS SLD_FIM, "
	cSQL += "       B6_TES, "
	cSQL += "       B6_IDENT "
//	cSQL += "FROM   (SELECT DISTINCT B6_CLIFOR, "
	cSQL += "FROM   (SELECT B6_CLIFOR, "
	cSQL += "                B6_LOJA, "
	cSQL += "                A2_NOME, "
	cSQL += "                B6_PRODUTO, "
	cSQL += "                B1_DESC,"
   cSQL += "                B6_EMISSAO, "
   cSQL += "                B6_DOC, "
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" REMANT "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND REMANT.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES > '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'R' "
	cSQL += "                        AND B6_EMISSAO < "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_REM_ANT, "
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" RETANT "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND RETANT.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES < '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'D' "
	cSQL += "                        AND B6_EMISSAO < "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_RET_ANT, "
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" REMPER "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND REMPER.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES > '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'R' "
	cSQL += "                        AND B6_EMISSAO BETWEEN "+ValToSql(MV_PAR07)+" AND "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_REM_PER, "
	cSQL += "                (SELECT NVL(Sum(B6_QUANT), 0) "
	cSQL += "                 FROM   "+RetSqlName("SB6")+" RETPER "
	cSQL += "                 WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                        AND RETPER.D_E_L_E_T_ = ' ' "
	cSQL += "                        AND B6_TES < '500' "
	cSQL += "                        AND B6_CLIFOR = MAIN.B6_CLIFOR "
	cSQL += "                        AND B6_PODER3 = 'D' "
	cSQL += "                        AND B6_EMISSAO BETWEEN "+ValToSql(MV_PAR07)+" AND "+ValToSql(MV_PAR08)+" "
	cSQL += "                        AND B6_PRODUTO = MAIN.B6_PRODUTO) AS T_RET_PER, "
	cSQL += "                B6_QUANT, "
	cSQL += "                B6_TES, "
	cSQL += "                B6_IDENT "
	cSQL += "FROM   "+RetSqlName("SB6")+" MAIN "
	cSQL += "       INNER JOIN "+RetSqlName("SA2")+" SA2 "
	cSQL += "               ON A2_FILIAL = "+ValToSql(xFilial("SA2"))+" "
	cSQL += "                  AND A2_COD = MAIN.B6_CLIFOR "
	cSQL += "                  AND A2_LOJA = MAIN.B6_LOJA "
	cSQL += "                  AND SA2.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" SB1 "
	cSQL += "               ON B1_FILIAL = "+ValToSql(xFilial("SB1"))+" "
	cSQL += "                  AND B1_COD = MAIN.B6_PRODUTO "
	cSQL += "                  AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  MAIN.D_E_L_E_T_ = ' ' "
	cSQL += "       AND B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "       AND B6_CLIFOR BETWEEN "+ValToSql(MV_PAR03)+" AND "+ValToSql(MV_PAR04)+" "
	cSQL += "       AND B6_PRODUTO BETWEEN "+ValToSql(MV_PAR05)+" AND "+ValToSql(MV_PAR06)+" "
	cSQL += "       AND B6_EMISSAO BETWEEN "+ValToSql(MV_PAR07)+" AND "+ValToSql(MV_PAR08)+") "
	cSQL += "ORDER  BY B6_CLIFOR, "
	cSQL += "          B6_LOJA, "
	cSQL += "          B6_PRODUTO, "
	cSQL += "          B6_EMISSAO "

	Memowrite("D:\TEMP\kdxP3_KdxProc3", cSQL )
	
	cSQL := ChangeQuery( cSQL )
	
	If lExpQry
		StaticCall( CSFA110, A110Script, cSQL )
	Endif

	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.T.,.T.)
	TCQUERY cSQL alias "Kdx3" NEW
	
	If Kdx3->( .NOT. BOF() ) .AND. Kdx3->( .NOT. EOF() )
		While Kdx3->( .NOT. EOF() )
		   nPoint++
		   If nPoint == 5
		   	nPoint := 1
		   Endif
		   
		   MsProcTxt( 'Aguarde, lendo registros [ ' + aPoint[ nPoint ] + ' ]'  )
		   ProcessMessage()
		   
			If cKey <> Kdx3->B6_CLIFOR + Kdx3->B6_LOJA + Kdx3->B6_PRODUTO
				cKey := Kdx3->B6_CLIFOR + Kdx3->B6_LOJA + Kdx3->B6_PRODUTO
				nSldIni := Kdx3->SLD_INI
				nSld    := Kdx3->SLD_INI
			Endif
			
 			If Kdx3->B6_TES > '500'
 				nRem := Kdx3->B6_QUANT
 				nSld := nSld + Kdx3->B6_QUANT
 			Else
 				nRet := Kdx3->B6_QUANT
 				nSld := nSld - Kdx3->B6_QUANT
 			Endif
 			
 			nP := AScan( aDADOS, {|e| e[1]+e[2]+e[4]+e[8] == Kdx3->(B6_CLIFOR+B6_LOJA+B6_PRODUTO+B6_DOC ) } )
 			
 			If nP == 0
	 			AAdd( aDADOS, { Kdx3->B6_CLIFOR,;
	 			                Kdx3->B6_LOJA,;
	 			                Kdx3->A2_NOME,;
				                Kdx3->B6_PRODUTO,;
				                Kdx3->B1_DESC,;
				                nSldIni,;
				                Dtoc(Stod(Kdx3->B6_EMISSAO)),;
				                Kdx3->B6_DOC,;
				                nRem,;
				                nRet,;
	   		                nSld } )
			Else
				aDADOS[ nP, 6 ] := nSldIni // Somente atualizar.
				aDADOS[ nP, 9 ] := nRem    // Somente atualizar.
				aDADOS[ nP, 10 ] += nRet   // Somente incrementar.
				aDADOS[ nP, 11 ] := nSld   // Somente atualizar.
			Endif
			
   		KdxTrack( "Kdx3", @nPoint )
   		
   		nSldIni := 0
   		nRem := 0
   		nRet := 0
			Kdx3->( dbSkip() )
		End
	Else
		MsgAlert('Não há dados com os parâmetros informados.',cCadastro)		
	Endif
	Kdx3->( dbCloseArea() )
	
	If lExpDados .OR. lExpTrack
		If lExpDados
			FwMsgRun(,{|| DlgToExcel( { { "ARRAY", "ANÁLISE aDADOS", {;
			'CLIFOR','LOJA','NOME','PRODUTO','DESC','SLDINI','EMISSAO','DOC','REMESSA','RETORNO','SALDO'},;
			 aDADOS } } ) },,'Aguarde, gerando os dados...')
		Endif
		If lExpTrack
			FwMsgRun(,{|| DlgToExcel( { { "ARRAY", "ANÁLISE aTRACK", {;
			'CLIFOR','PRODUTO','DOC','PEDGAR','PEDSITE','PEDIDO','PRODGAR','DATAMOV','DESCMIDIA','QTDMIDIA','AR','POSTO','AGENTE','GRUPO','REDE','COD_POSTO','QUERY'},;
			 aTrack } } ) },,'Aguarde, gerando os dados...')
		Endif
		If .NOT. MsgYesNo('Continuar com o processamento?')
			Return
		Endif
	Endif
	
	If Len( aDADOS ) > 0
		oFwMsEx := FWMsExcel():New()
	   
		ParamExc( @oFwMsEx )

	   oFwMsEx:AddWorkSheet( cWorkSheet )
	   oFwMsEx:AddTable( cWorkSheet, cTable )	
	
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Fornecedor"   , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto"      , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Descrição"    , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Sld.Inicial"  , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Emissão"      , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Documento"    , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Remessa"      , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Retorno"      , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Saldo"        , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Pedido GAR"   , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Núm.Ped.Site" , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Pedido "      , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "ProdutoGAR"   , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Data Movto."  , 2,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Quantidade"   , 3,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Agente"       , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Rede"         , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Código Posto" , 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , Iif(lExpQry,"Query",""), 1,1)
		
		nLenDados := Len( aDADOS )
			
		While nE <= nLenDados
		   MsProcTxt( 'Aguarde, lendo registros [ ' + aPoint[ nPoint ] + ' ]'  )
		   ProcessMessage()
			
			cFor := aDADOS[nE,nCLIFOR]
			cFornecedor := aDADOS[nE,nCLIFOR]+' - '+RTrim( aDADOS[nE,nNOMEFOR] )
			
			While nE <= nLenDados .AND. aDADOS[nE,nCLIFOR] == cFor
				
				cProd := aDADOS[nE,nPRODUTO]
				
				While nE <= nLenDados .AND. aDADOS[nE,nCLIFOR] == cFor .AND. aDADOS[nE,nPRODUTO] == cProd
					
					nSldInicial := aDADOS[nE,nSALDOINI]
					cDOC := aDADOS[ nE, nDOC ]
					
					While nE <= nLenDados .AND. aDADOS[nE,nCLIFOR] == cFor .AND. aDADOS[nE,nPRODUTO] == cProd .AND. aDADOS[ nE, nDOC ] == cDOC
						nP := AScan( aTrack, {|a| a[ 1 ] + a[ 2 ] + a[ 3 ] == cFor + cProd + aDADOS[ nE, nDOC ] } )
						If nP > 0
							For nI := nP To Len( aTrack )
								If aTrack[ nI, 1 ] + aTrack[ nI, 2 ] + aTrack[ nI, 3 ] == cFor + cProd + aDADOS[ nE, nDOC ]
									If lFirst
										lFirst := .F.
										nRem := aDADOS[nE,nREMESSA]
										nRet := aDADOS[nE,nRETORNO]
										nSld := aDADOS[nE,nSALDO]
									Endif
									
									nPoint++
									
									If nPoint==5
										nPoint := 1
									Endif
									
		   						MsProcTxt( 'Aguarde, lendo registros [ ' + aPoint[ nPoint ] + ' ]'  )
		   						ProcessMessage()
									
									oFwMsEx:AddRow( cWorkSheet, cTable, { cFornecedor,;
									                                      aDADOS[nE,nPRODUTO],;
									                                      aDADOS[nE,nDESCRICAO],;
									                                      nSldInicial,;
									                                      aDADOS[nE,nDATA],;
									                                      aDADOS[nE,nDOC],;
									                                      nRem,;
									                                      nRet,;
									                                      nSld,;
									                                      aTrack[nI,4],;
									                                      aTrack[nI,5],;
									                                      aTrack[nI,6],;
									                                      aTrack[nI,7],;
									                                      aTrack[nI,8],;
									                                      aTrack[nI,10],;
									                                      aTrack[nI,13],;
									                                      aTrack[nI,12],; 
									                                      aTrack[nI,16],;
									                                      aTrack[nI,17]} )
									nRem := 0
									nRet := 0
									nSld := 0
									nSldInicial := 0
								Else
									Exit
								Endif
							Next nI
							lFirst := .T.
						Endif
						nSldInicial := 0
						nE++
					End
				End
			End
		End
	
		oFwMsEx:Activate()
		cDirTmp := GetTempPath()
		cDir := GetSrvProfString("Startpath","")
		
		LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cFile ), Sleep( 500 ) } )
		
		If __CopyFile( cFile, cDirTmp + cFile )
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cFile )
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			Sleep(500)
		Else
			MsgInfo( "Não foi possível copiar o arquivo para o diretório temporário do usuário." )
		Endif	
	Endif
Return

/******
 *
 * Rotina...: Rotina de processamento auxiliar considerando a visão 3.
 * Autor....: Robson Gonçalves
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
Static Function KdxTrack( cTRB, nPoint )
	Local cSQL := ''
	
	cSQL := " SELECT "
	cSQL += " SZ8.Z8_FORNEC  AS FORNEC , SZ8.Z8_LOJA   AS LOJA,  "
	cSQL += " SZ5.Z5_PRODGAR AS PRODGAR, SZ5.Z5_DATVER AS DATAMOV, "
	cSQL += " SB1.B1_COD AS CODMIDIA, SB1.B1_DESC AS DESCMIDIA, SG1.G1_QUANT AS QTDMIDIA, "
	cSQL += " SZ5.Z5_NFDEV NF_RETORNO_TERCEIRO, SZ5.Z5_PEDGAR, SZ5.Z5_PEDSITE, SZ5.Z5_PEDIDO, "
	cSQL += " SZ5.Z5_DESCAR AS AR, SZ5.Z5_CODPOS AS COD_POSTO, SZ5.Z5_DESPOS AS POSTO, SZ5.Z5_NOMAGE AS AGENTE, SZ5.Z5_GRUPO AS GRUPO, SZ5.Z5_REDE AS REDE "
	cSQL += " FROM 	"+RetSqlName( "SZ5" )+" SZ5 "
	cSQL += "		LEFT JOIN "+RetSqlName( "SZ3" )+" SZ3 ON "
	cSQL += "				SZ3.Z3_FILIAL =  "      +ValToSql( xFilial( "SZ3" ) )      +" AND "
	cSQL += "				SZ3.Z3_CODGAR = SZ5.Z5_CODPOS AND "
	cSQL += "				SZ3.Z3_CODGAR > ' ' AND "
	cSQL += "				SZ3.Z3_TIPENT = '4' AND "
	cSQL += "				SZ3.D_E_L_E_T_<>'*' "
	cSQL += "		LEFT JOIN "+RetSqlName( "SZ8" )+" SZ8 ON "
	cSQL += "				SZ8.Z8_FILIAL =  "      +ValToSql( xFilial( "SZ8" ) )      +" AND "
	cSQL += "			   	SZ8.Z8_COD = SZ3.Z3_PONDIS AND "
	cSQL += "				SZ8.D_E_L_E_T_ <> '*' "
	cSQL += "		INNER JOIN "+RetSqlName( "PA8" )+" PA8 ON "
	cSQL += "			    PA8.PA8_FILIAL = "      +ValToSql( xFilial( "PA8" ) )      +" AND "
	cSQL += "			    PA8.PA8_CODBPG = SZ5.Z5_PRODGAR AND "
	cSQL += "			    PA8.D_E_L_E_T_ <> '*' "
	cSQL += "	  	INNER JOIN "+RetSqlName( "SG1" )+" SG1 ON "
	cSQL += "			    SG1.G1_FILIAL = '02' AND "
	cSQL += "			    SG1.G1_COD = PA8.PA8_CODMP8 AND "
	cSQL += "			    SG1.D_E_L_E_T_ <> '*' "
	cSQL += "		INNER JOIN "+RetSqlName( "SB1" )+" SB1  ON "
	cSQL += "			    SB1.B1_FILIAL = "      +ValToSql( xFilial( "SB1" ) )      +" AND "
	cSQL += "			    SB1.B1_COD = G1_COMP AND "
	cSQL += "			    SB1.B1_CATEGO = '1' AND "
	cSQL += "			    SB1.D_E_L_E_T_ <> '*' "
	cSQL += "WHERE "
	cSQL += " SZ5.Z5_FILIAL = " + ValToSql( xFilial( "SZ5" ) )      +" AND "
	cSQL += " SZ5.Z5_FORNECE = " + ValToSql( (cTRB)->B6_CLIFOR ) +" AND "
	cSQL += " TRIM(SB1.B1_COD) = TRIM(" +ValToSql( (cTRB)->B6_PRODUTO )+") AND "
	cSQL += " SZ5.Z5_NFDEV = " + ValToSql( (cTRB)->B6_DOC )    +" AND "
	cSQL += " SZ5.Z5_PRODGAR > ' ' AND "
	cSQL += " SZ5.Z5_CODPOS > ' ' AND "
	cSQL += " SZ5.Z5_PEDGANT = ' ' AND "
	cSQL += " SZ5.D_E_L_E_T_ <> '*' "
	cSQL += "			"      
	cSQL += "UNION ALL "
	cSQL += "			"  
	cSQL += "SELECT "
	cSQL += " SZ8.Z8_FORNEC  AS FORNEC , SZ8.Z8_LOJA   AS LOJA,  "
	cSQL += " SZ5.Z5_PRODGAR AS PRODGAR, SZ5.Z5_EMISSAO AS DATAMOV, "
	cSQL += " SB1.B1_COD AS CODMIDIA, SB1.B1_DESC AS DESCMIDIA, SC6.C6_QTDVEN AS QTDMIDIA , "
	cSQL += " SZ5.Z5_NFDEV NF_RETORNO_TERCEIRO, SZ5.Z5_PEDGAR, SZ5.Z5_PEDSITE, SZ5.Z5_PEDIDO, "
	cSQL += " SZ5.Z5_DESCAR AS AR, SZ5.Z5_CODPOS AS COD_POSTO, SZ5.Z5_DESPOS AS POSTO, SZ5.Z5_NOMAGE AS AGENTE, SZ5.Z5_GRUPO AS GRUPO, SZ5.Z5_REDE AS REDE "
	cSQL += "	      "
	cSQL += "FROM 	"+RetSqlName( "SZ5" )+" SZ5 "
	cSQL += "		LEFT JOIN "+RetSqlName( "SZ3" )+" SZ3 ON "
	cSQL += "				SZ3.Z3_FILIAL = "      +ValToSql( xFilial( "SZ3" ) )      +" AND "
	cSQL += "				SZ3.Z3_CODGAR = SZ5.Z5_CODPOS AND "
	cSQL += "				SZ3.Z3_CODGAR > ' ' AND "
	cSQL += "				SZ3.Z3_TIPENT = '4' AND "
	cSQL += "				SZ3.D_E_L_E_T_<>'*' "
	cSQL += "		LEFT JOIN "+RetSqlName( "SZ8" )+" SZ8 ON "
	cSQL += "				SZ8.Z8_FILIAL = "      +ValToSql( xFilial( "SZ8" ) )      +" AND "
	cSQL += "			   	SZ8.Z8_COD = SZ3.Z3_PONDIS AND "
	cSQL += "				SZ8.D_E_L_E_T_ <> '*' "
	cSQL += "		LEFT JOIN "+RetSqlName( "SB1" )+" SB1 ON "
	cSQL += "			    SB1.B1_FILIAL = "      +ValToSql( xFilial( "SB1" ) )      +" AND "
	cSQL += "			    SB1.B1_COD = SZ5.Z5_PRODUTO AND "
	cSQL += "			    SB1.B1_CATEGO = '1' AND "
	cSQL += "			    SB1.D_E_L_E_T_ <> '*' "
	cSQL += "		LEFT JOIN "+RetSqlName( "SC6" )+" SC6 ON "
	cSQL += "			    SC6.C6_FILIAL = "      +ValToSql( xFilial( "SC6" ) )      +" AND "
	cSQL += "			    SC6.C6_NUM = SZ5.Z5_PEDIDO AND "
	cSQL += "			    SC6.C6_ITEM = SZ5.Z5_ITEMPV AND "
	cSQL += "			    SC6.D_E_L_E_T_ <> '*' "
	cSQL += " WHERE "
	cSQL += " SZ5.Z5_FILIAL = "      +ValToSql( xFilial( "SZ5" ) )      +" AND"
	cSQL += " SZ5.Z5_FORNECE = " +ValToSql( (cTRB)->B6_CLIFOR ) +" AND "
	cSQL += " TRIM(SB1.B1_COD) = TRIM(" +ValToSql( (cTRB)->B6_PRODUTO )+") AND "
	cSQL += " SZ5.Z5_NFDEV = "   +ValToSql( (cTRB)->B6_DOC )    +"  AND "
	cSQL += " SZ5.Z5_TIPO = 'ENTHAR' AND "
	cSQL += " SZ5.D_E_L_E_T_ <> '*' "

	Memowrite("D:\TEMP\kdxP3_KdxTrack", cSQL )
	
	cSQL := ChangeQuery( cSQL )
	
	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"TRACK",.T.,.T.)
	TCQUERY cSQL alias "TRACK" NEW

	If TRACK->( .NOT. BOF() ) .AND. TRACK->( .NOT. EOF() )
		While TRACK->( .NOT. EOF() )
			nPoint++
			If nPoint == 5
				nPoint := 1
			Endif
			
		   MsProcTxt( 'Aguarde, lendo registros [ ' + aPoint[ nPoint ] + ' ]'  )
		   ProcessMessage()
			
			If AScan( aTrack, {|e| e[ 1 ] + e[ 2 ] + e[ 3 ] + e[ 4 ] == (cTRB)->( B6_CLIFOR + B6_PRODUTO + B6_DOC ) + TRACK->( Z5_PEDGAR ) } ) == 0
				AAdd( aTrack, { (cTRB)->B6_CLIFOR, ;
				                (cTRB)->B6_PRODUTO,;
				                (cTRB)->B6_DOC,;
								    TRACK->Z5_PEDGAR,;
								    TRACK->Z5_PEDSITE,;
								    TRACK->Z5_PEDIDO,;
								    TRACK->PRODGAR,;
								    Dtoc(Stod(TRACK->DATAMOV)),;
								    TRACK->DESCMIDIA,;
								    TRACK->QTDMIDIA ,;
								    TRACK->AR,;
								    TRACK->POSTO,;
								    TRACK->AGENTE,;
								    TRACK->GRUPO,;
								    TRACK->REDE,;
								    TRACK->COD_POSTO,;
								    Iif( lExpQry, cSQL, '' ) } )
			Endif
			TRACK->( dbSkip() )
		End
	Else
		AAdd( aTrack, { (cTRB)->B6_CLIFOR, ;
		                (cTRB)->B6_PRODUTO,;
		                (cTRB)->B6_DOC,'','','','','','',0,'','','','','','',Iif( lExpQry, cSQL, '' ) } )
	Endif
	TRACK->( dbCloseArea() )
Return

/******
 *
 * Rotina...: Rotina para listar os parâmetros na planilha considerando todas as visões.
 * Autor....: Robson Gonçalves
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
Static Function ParamExc( oFwMsEx, nQtdMeses )
	Local cDado := ''
	Local cWorkSheet := 'Parâmetros'
	Local cTable := 'Parâmetros da rotina'
	Local nI := 0
	
	DEFAULT nQtdMeses := 0
	
   oFwMsEx:AddWorkSheet( cWorkSheet )
   oFwMsEx:AddTable( cWorkSheet, cTable )	
	
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Perguntas" , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Respostas"  , 1,1)

	For nI := 1 To Len( aParamBox )
		If ValType( aPergRet ) == 'D'
			cDado := Dtoc( aPerRet[ nI ] )
		Elseif ValType( aPergRet[ nI ] ) == 'N'
			cDado := aVisao[ aPergRet[ nI ] ] 
		Else
			cDado := aPergRet[ nI ]
		Endif
		oFwMsEx:AddRow( cWorkSheet, cTable, { aParamBox[ nI, 2 ]+'?', cDado } )
	Next 
	If MV_PAR09==4
		oFwMsEx:AddRow( cWorkSheet, cTable, { 'Calcular consumo para?', LTrim( Str( nQtdMeses ) ) + Iif( nQtdMeses==1, ' mês', ' meses')})
	Endif
Return

/******
 *
 * Rotina...: Rotina auxiliar para exportar dados para apurar resultados.
 * Autor....: Robson Gonçalves
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
Static Function KdxP3Aut()
	Local aAnalisys := {}
	Local aRet := {}
	Local cTime := ( SubStr( StrTran( Time(), ':', '' ), 1, 4 ) + '00' )
	
	AAdd( aAnalisys, { 5, 'Exportar a string da(s) Query?', .F., 92, '', .F. } )
	AAdd( aAnalisys, { 5, 'Exportar o Array aDADOS?'      , .F., 92, '', .F. } )
	AAdd( aAnalisys, { 5, 'Exportar o Array aTrack?'      , .F., 92, '', .F. } )
	AAdd( aAnalisys, { 8, 'Você precisa se autenticar'    , Space(15) ,"" ,"" ,"" ,"" ,92 ,.T. })
	
	If ParamBox( aAnalisys, 'Parâmetros', aRet,,,,,,,, .F., .F. )
		If RTrim( aRet[ 4 ] ) == cTime
			lExpQry   := aRet[ 1 ] 
			lExpDados := aRet[ 2 ]
			lExpTrack := aRet[ 3 ] 
			MsgInfo('Você foi autenticado, isto libera seu acesso aos resultados parciais.', cCadastro )
		Else
			MsgAlert('Autenticação incorreta, tente outra vez.', cCadastro )
		Endif
	Endif
Return

/******
 *
 * Rotina...: Rotina para compor o consumo médio dos parceiros.
 * Autor....: Robson Gonçalves
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
Static Function KdxProc4( cFile )
	Local cDir
	Local cDirTmp
	Local cSQL := ''
	Local cTable := 'Consumo médio de fornecedor'
	//Local cTRB := ''
	Local cWorkSheet := 'Dados do consumo'
	
	Local nPoint := 1
	Local nQtdMeses := 0
	
	Local oExcelApp
	Local oFwMsEx

   MsProcTxt( 'Buscando os dados para iniciar o processamento...'  )
   ProcessMessage()

	// Quantos meses entre o período informado?
	nQtdMeses := DateDiffMonth( MV_PAR07, MV_PAR08 ) + 1
	
	cSQL := "SELECT NVL(FORNEC, ' ')       AS FORNEC, "
	cSQL += "       NVL(LOJA, ' ')         AS LOJA, "
	cSQL += "       A2_NOME, "
	cSQL += "       CODMIDIA, "
	cSQL += "       DESCMIDIA, "
	cSQL += "       NVL(Sum(QTDMIDIA), 0)  AS QTDMIDIA "
	cSQL += "FROM   (SELECT SZ8.Z8_FORNEC  AS FORNEC, "
	cSQL += "               SZ8.Z8_LOJA    AS LOJA, "
	cSQL += "               SZ5.Z5_PRODGAR AS PRODGAR, "
	cSQL += "               SZ5.Z5_DATVER  AS DATAMOV, "
	cSQL += "               SB1.B1_COD     AS CODMIDIA, "
	cSQL += "               SB1.B1_DESC    AS DESCMIDIA, "
	cSQL += "               SG1.G1_QUANT   AS QTDMIDIA, "
	cSQL += "               SZ5.Z5_NFDEV   NF_RETORNO_TERCEIRO, "
	cSQL += "               SZ5.Z5_PEDGAR, "
	cSQL += "               SZ5.Z5_PEDSITE, "
	cSQL += "               SZ5.Z5_PEDIDO, "
	cSQL += "               SZ5.Z5_DESCAR  AS AR, "
	cSQL += "               SZ5.Z5_CODPOS  AS COD_POSTO, "
	cSQL += "               SZ5.Z5_DESPOS  AS POSTO, "
	cSQL += "               SZ5.Z5_NOMAGE  AS AGENTE, "
	cSQL += "               SZ5.Z5_GRUPO   AS GRUPO, "
	cSQL += "               SZ5.Z5_REDE    AS REDE "
	cSQL += "        FROM   "+RETSQLNAME("SZ5")+" SZ5 "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ3")+" SZ3 "
	cSQL += "                      ON SZ3.Z3_FILIAL = "+VALTOSQL(XFILIAL("SZ3"))+" "
	cSQL += "                         AND SZ3.Z3_CODGAR = SZ5.Z5_CODPOS "
	cSQL += "                         AND SZ3.Z3_CODGAR > ' ' "
	cSQL += "                         AND SZ3.Z3_TIPENT = '4' "
	cSQL += "                         AND SZ3.D_E_L_E_T_ <> '*' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ8")+" SZ8 "
	cSQL += "                      ON SZ8.Z8_FILIAL = "+VALTOSQL(XFILIAL("SZ8"))+" "
	cSQL += "                         AND SZ8.Z8_COD = SZ3.Z3_PONDIS "
	cSQL += "                         AND SZ8.D_E_L_E_T_ = ' ' "
	cSQL += "               INNER JOIN "+RETSQLNAME("PA8")+" PA8 "
	cSQL += "                       ON PA8.PA8_FILIAL = "+VALTOSQL(XFILIAL("PA8"))+" "
	cSQL += "                          AND PA8.PA8_CODBPG = SZ5.Z5_PRODGAR "
	cSQL += "                          AND PA8.D_E_L_E_T_ = ' ' "
	cSQL += "               INNER JOIN "+RETSQLNAME("SG1")+" SG1 "
	cSQL += "                       ON SG1.G1_FILIAL = '02' "
	cSQL += "                          AND SG1.G1_COD = PA8.PA8_CODMP8 "
	cSQL += "                          AND SG1.D_E_L_E_T_ = ' ' "
	cSQL += "               INNER JOIN "+RETSQLNAME("SB1")+" SB1 "
	cSQL += "                       ON SB1.B1_FILIAL = "+VALTOSQL(XFILIAL("SB1"))+" "
	cSQL += "                          AND SB1.B1_COD = G1_COMP "
	cSQL += "                          AND SB1.B1_CATEGO = '1' "
	cSQL += "                          AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "        WHERE  SZ5.Z5_FILIAL = "+VALTOSQL(XFILIAL("SZ5"))+" "
	cSQL += "               AND SZ5.Z5_DATVER >= "+VALTOSQL(MV_PAR07)+" "
	CSQL += "               AND SZ5.Z5_DATVER <= "+VALTOSQL(MV_PAR08)+" "
	cSQL += "               AND SZ5.Z5_PRODGAR > ' ' "
	cSQL += "               AND SZ5.Z5_CODPOS > ' ' "
	cSQL += "               AND SZ5.Z5_PEDGANT = ' ' "
	cSQL += "               AND SZ5.D_E_L_E_T_ = ' ' "
	cSQL += "               AND SB1.B1_COD >= "+VALTOSQL(MV_PAR05)+" "
	cSQL += "               AND SB1.B1_COD <= "+VALTOSQL(MV_PAR06)+" "
	cSQL += "               AND SZ8.Z8_FORNEC >= "+VALTOSQL(MV_PAR03)+" "
	cSQL += "               AND SZ8.Z8_FORNEC <= "+VALTOSQL(MV_PAR04)+" "
	cSQL += "        UNION ALL "
	cSQL += "        SELECT SZ8.Z8_FORNEC  AS FORNEC, "
	cSQL += "               SZ8.Z8_LOJA    AS LOJA, "
	cSQL += "               SZ5.Z5_PRODGAR AS PRODGAR, "
	cSQL += "               SZ5.Z5_EMISSAO AS DATAMOV, "
	cSQL += "               SB1.B1_COD     AS CODMIDIA, "
	cSQL += "               SB1.B1_DESC    AS DESCMIDIA, "
	cSQL += "               SC6.C6_QTDVEN  AS QTDMIDIA, "
	cSQL += "               SZ5.Z5_NFDEV   NF_RETORNO_TERCEIRO, "
	cSQL += "               SZ5.Z5_PEDGAR, "
	cSQL += "               SZ5.Z5_PEDSITE, "
	cSQL += "               SZ5.Z5_PEDIDO, "
	cSQL += "               SZ5.Z5_DESCAR  AS AR, "
	cSQL += "               SZ5.Z5_CODPOS  AS COD_POSTO, "
	cSQL += "               SZ5.Z5_DESPOS  AS POSTO, "
	cSQL += "               SZ5.Z5_NOMAGE  AS AGENTE, "
	cSQL += "               SZ5.Z5_GRUPO   AS GRUPO, "
	cSQL += "               SZ5.Z5_REDE    AS REDE "
	cSQL += "        FROM   "+RETSQLNAME("SZ5")+" SZ5 "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ3")+" SZ3 "
	cSQL += "                      ON SZ3.Z3_FILIAL = "+VALTOSQL(XFILIAL("SZ3"))+" "
	cSQL += "                         AND SZ3.Z3_CODGAR = SZ5.Z5_CODPOS "
	cSQL += "                         AND SZ3.Z3_CODGAR > ' ' "
	cSQL += "                         AND SZ3.Z3_TIPENT = '4' "
	cSQL += "                         AND SZ3.D_E_L_E_T_ = ' ' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ8")+" SZ8 "
	cSQL += "                      ON SZ8.Z8_FILIAL = "+VALTOSQL(XFILIAL("SZ8"))+" "
	cSQL += "                         AND SZ8.Z8_COD = SZ3.Z3_PONDIS "
	cSQL += "                         AND SZ8.D_E_L_E_T_ = ' ' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SB1")+" SB1 "
	cSQL += "                      ON SB1.B1_FILIAL = "+VALTOSQL(XFILIAL("SB1"))+" "
	cSQL += "                         AND SB1.B1_COD = SZ5.Z5_PRODUTO "
	cSQL += "                         AND SB1.B1_CATEGO = '1' "
	cSQL += "                         AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SC6")+" SC6 "
	cSQL += "                      ON SC6.C6_FILIAL = "+VALTOSQL(XFILIAL("SC6"))+" "
	cSQL += "                         AND SC6.C6_NUM = SZ5.Z5_PEDIDO "
	cSQL += "                         AND SC6.C6_ITEM = SZ5.Z5_ITEMPV "
	cSQL += "                         AND SC6.D_E_L_E_T_ = ' ' "
	cSQL += "        WHERE  SZ5.Z5_FILIAL = "+VALTOSQL(XFILIAL("SZ5"))+" "
	//cSQL += "               AND SZ5.Z5_DATVER >= "+VALTOSQL(MV_PAR07)+" "
	//cSQL += "               AND SZ5.Z5_DATVER <= "+VALTOSQL(MV_PAR08)+" "
	cSQL += "               AND SZ5.Z5_EMISSAO >= "+VALTOSQL(MV_PAR07)+" "
	cSQL += "               AND SZ5.Z5_EMISSAO <= "+VALTOSQL(MV_PAR08)+" "
	cSQL += "               AND SZ5.Z5_TIPO = 'ENTHAR' "
	cSQL += "               AND SZ5.D_E_L_E_T_ = ' ' "	
	cSQL += "               AND SZ8.Z8_FORNEC >= "+VALTOSQL(MV_PAR03)+" "
	cSQL += "               AND SZ8.Z8_FORNEC <= "+VALTOSQL(MV_PAR04)+" "
	cSQL += "               AND SB1.B1_COD >= "+VALTOSQL(MV_PAR05)+" "
	cSQL += "               AND SB1.B1_COD <= "+VALTOSQL(MV_PAR06)+" ) RESULTADO "
	cSQL += "       INNER JOIN "+RETSQLNAME("SA2")+" SA2 "
	cSQL += "               ON A2_FILIAL = "+VALTOSQL(XFILIAL("SA2"))+" "
	cSQL += "                  AND A2_COD = FORNEC "
	cSQL += "                  AND A2_LOJA = LOJA "
	cSQL += "                  AND SA2.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  FORNEC <> ' ' "
	cSQL += "        OR LOJA <> ' ' "
	cSQL += "        OR QTDMIDIA <> 0 "
	cSQL += "GROUP  BY FORNEC, "
	cSQL += "          LOJA, "
	cSQL += "          A2_NOME, "
	cSQL += "          CODMIDIA, "
	cSQL += "          DESCMIDIA "
	cSQL += "ORDER  BY 1, "
	cSQL += "          3, "
	cSQL += "          4 "
	
	If lExpQry
		StaticCall( CSFA110, A110Script, cSQL )
	Endif

	If lExpDados .OR. lExpTrack
		MsgAlert( 'A visão selecionada não trabalha com os vetores aDADOS ou aTrack.', cCadastro )
	Endif

	Memowrite("D:\TEMP\kdxP3_KdxProc4", cSQL )

	cSQL := ChangeQuery( cSQL )
	//cTRB := GetNextAlias()
	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.T.,.T.)
	TCQUERY cSQL alias "Kdx4" NEW
	
	If Kdx4->( .NOT. BOF() ) .AND. Kdx4->( .NOT. EOF() )
		oFwMsEx := FWMsExcel():New()
		
		ParamExc( @oFwMsEx, nQtdMeses )
	   
	   oFwMsEx:AddWorkSheet( cWorkSheet )
	   oFwMsEx:AddTable( cWorkSheet, cTable )	
	
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Código"               , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"                 , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Razão social"         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Código produto"       , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Descrição do produto" , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Qtd. Movimentada"     , 3, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Consumo médio [Qtd.de meses (" + LTrim( Str( nQtdMeses ) ) + ")]", 3, 1 )
		
		While Kdx4->( .NOT. EOF() )
			nPoint++
			If nPoint == 5
				nPoint := 1
			Endif
			
		   MsProcTxt( 'Aguarde, calculando o consumo [ ' + aPoint[ nPoint ] + ' ] '  )
		   ProcessMessage()
			
			oFwMsEx:AddRow( cWorkSheet, cTable, { Kdx4->FORNEC, Kdx4->LOJA, Kdx4->A2_NOME,;
			Kdx4->CODMIDIA, Kdx4->DESCMIDIA, Kdx4->QTDMIDIA, Kdx4->QTDMIDIA/nQtdMeses} )
			
			Kdx4->( dbSkip() )
		End
		
		oFwMsEx:Activate()
		cDirTmp := GetTempPath()
		cDir := GetSrvProfString("Startpath","")
	
		LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cFile ), Sleep( 500 ) } )
	
		If __CopyFile( cFile, cDirTmp + cFile )
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cFile )
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			Sleep(500)
		Else
			MsgInfo( "Não foi possível copiar o arquivo para o diretório temporário do usuário." )
		Endif
	Else
		MsgAlert( 'Não localizei dados com os parâmetros informados. ', cCadastro )
	Endif
	Kdx4->( dbCloseArea() )
Return

/******
 *
 * Rotina...: Rotina para fazer o resumo de todas as remessas
 * Autor....: Robson Gonçalves
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
Static Function KdxProc5( cFile )
	Local cDir
	Local cDirTmp
	Local cSQL := ''
	Local cTable := 'Resumo das remessas + consumo médio'
	//Local cTRB := ''
	Local cWorkSheet := 'Dados do resumo e consumo médio'
	
	Local nPoint := 1
	Local nQtdMeses := 0
	//Local nRemessa := 0
	
	Local oExcelApp
	Local oFwMsEx

   MsProcTxt( 'Buscando os dados para iniciar o processamento...'  )
   ProcessMessage()

	// Quantos meses entre o período informado?
	nQtdMeses := DateDiffMonth( MV_PAR07, MV_PAR08 ) + 1
	
	cSQL := "WITH RESULT_SB6 "
	cSQL += "     AS (SELECT B6_CLIFOR, "
	cSQL += "                B6_PRODUTO, "
	cSQL += "                NVL(Sum(B6_QUANT), 0) AS SB6_REMESSA "
	cSQL += "         FROM   "+RetSqlName("SB6")+" SB6 "
	cSQL += "         WHERE  B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "                AND B6_PODER3 = 'R' "
	cSQL += "                AND B6_EMISSAO >= "+ValToSql(MV_PAR07)+" "
	cSQL += "                AND B6_EMISSAO <= "+ValToSql(MV_PAR08)+" "
	cSQL += "                AND SB6.D_E_L_E_T_ = ' ' "
	cSQL += "         GROUP  BY B6_CLIFOR, "
	cSQL += "                   B6_PRODUTO) "
	cSQL += "SELECT NVL(FORNEC, ' ')      AS FORNEC, "
	cSQL += "       NVL(LOJA, ' ')        AS LOJA, "
	cSQL += "       A2_NOME, "
	cSQL += "       CODMIDIA, "
	cSQL += "       DESCMIDIA, "
	cSQL += "       NVL(Sum(QTDMIDIA), 0)  AS QTDMIDIA, "
	cSQL += "       NVL(SB6_REMESSA, 0)    AS REMESSA "
	cSQL += "FROM   (SELECT SZ8.Z8_FORNEC  AS FORNEC, "
	cSQL += "               SZ8.Z8_LOJA    AS LOJA, "
	cSQL += "               SZ5.Z5_PRODGAR AS PRODGAR, "
	cSQL += "               SZ5.Z5_DATVER  AS DATAMOV, "
	cSQL += "               SB1.B1_COD     AS CODMIDIA, "
	cSQL += "               SB1.B1_DESC    AS DESCMIDIA, "
	cSQL += "               SG1.G1_QUANT   AS QTDMIDIA, "
	cSQL += "               SZ5.Z5_NFDEV   NF_RETORNO_TERCEIRO, "
	cSQL += "               SZ5.Z5_PEDGAR, "
	cSQL += "               SZ5.Z5_PEDSITE, "
	cSQL += "               SZ5.Z5_PEDIDO, "
	cSQL += "               SZ5.Z5_DESCAR  AS AR, "
	cSQL += "               SZ5.Z5_CODPOS  AS COD_POSTO, "
	cSQL += "               SZ5.Z5_DESPOS  AS POSTO, "
	cSQL += "               SZ5.Z5_NOMAGE  AS AGENTE, "
	cSQL += "               SZ5.Z5_GRUPO   AS GRUPO, "
	cSQL += "               SZ5.Z5_REDE    AS REDE "
	cSQL += "        FROM   "+RETSQLNAME("SZ5")+" SZ5 "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ3")+" SZ3 "
	cSQL += "                      ON SZ3.Z3_FILIAL = "+VALTOSQL(XFILIAL("SZ3"))+" "
	cSQL += "                         AND SZ3.Z3_CODGAR = SZ5.Z5_CODPOS "
	cSQL += "                         AND SZ3.Z3_CODGAR > ' ' "
	cSQL += "                         AND SZ3.Z3_TIPENT = '4' "
	cSQL += "                         AND SZ3.D_E_L_E_T_ <> '*' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ8")+" SZ8 "
	cSQL += "                      ON SZ8.Z8_FILIAL = "+VALTOSQL(XFILIAL("SZ8"))+" "
	cSQL += "                         AND SZ8.Z8_COD = SZ3.Z3_PONDIS "
	cSQL += "                         AND SZ8.D_E_L_E_T_ = ' ' "
	cSQL += "               INNER JOIN "+RETSQLNAME("PA8")+" PA8 "
	cSQL += "                       ON PA8.PA8_FILIAL = "+VALTOSQL(XFILIAL("PA8"))+" "
	cSQL += "                          AND PA8.PA8_CODBPG = SZ5.Z5_PRODGAR "
	cSQL += "                          AND PA8.D_E_L_E_T_ = ' ' "
	cSQL += "               INNER JOIN "+RETSQLNAME("SG1")+" SG1 "
	cSQL += "                       ON SG1.G1_FILIAL = '02' "
	cSQL += "                          AND SG1.G1_COD = PA8.PA8_CODMP8 "
	cSQL += "                          AND SG1.D_E_L_E_T_ = ' ' "
	cSQL += "               INNER JOIN "+RETSQLNAME("SB1")+" SB1 "
	cSQL += "                       ON SB1.B1_FILIAL = "+VALTOSQL(XFILIAL("SB1"))+" "
	cSQL += "                          AND SB1.B1_COD = G1_COMP "
	cSQL += "                          AND SB1.B1_CATEGO = '1' "
	cSQL += "                          AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "        WHERE  SZ5.Z5_FILIAL = "+VALTOSQL(XFILIAL("SZ5"))+" "
	cSQL += "               AND SZ5.Z5_DATVER >= "+VALTOSQL(MV_PAR07)+" "
	cSQL += "               AND SZ5.Z5_DATVER <= "+VALTOSQL(MV_PAR08)+" "
	cSQL += "               AND SZ5.Z5_PRODGAR > ' ' "
	cSQL += "               AND SZ5.Z5_CODPOS > ' ' "
	cSQL += "               AND SZ5.Z5_PEDGANT = ' ' "
	cSQL += "               AND SZ5.D_E_L_E_T_ = ' ' "
	cSQL += "               AND SB1.B1_COD >= "+VALTOSQL(MV_PAR05)+" "
	cSQL += "               AND SB1.B1_COD <= "+VALTOSQL(MV_PAR06)+" "
	cSQL += "               AND SZ8.Z8_FORNEC >= "+VALTOSQL(MV_PAR03)+" "
	cSQL += "               AND SZ8.Z8_FORNEC <= "+VALTOSQL(MV_PAR04)+" "
	cSQL += "        UNION ALL "
	cSQL += "        SELECT SZ8.Z8_FORNEC  AS FORNEC, "
	cSQL += "               SZ8.Z8_LOJA    AS LOJA, "
	cSQL += "               SZ5.Z5_PRODGAR AS PRODGAR, "
	cSQL += "               SZ5.Z5_EMISSAO AS DATAMOV, "
	cSQL += "               SB1.B1_COD     AS CODMIDIA, "
	cSQL += "               SB1.B1_DESC    AS DESCMIDIA, "
	cSQL += "               SC6.C6_QTDVEN  AS QTDMIDIA, "
	cSQL += "               SZ5.Z5_NFDEV   NF_RETORNO_TERCEIRO, "
	cSQL += "               SZ5.Z5_PEDGAR, "
	cSQL += "               SZ5.Z5_PEDSITE, "
	cSQL += "               SZ5.Z5_PEDIDO, "
	cSQL += "               SZ5.Z5_DESCAR  AS AR, "
	cSQL += "               SZ5.Z5_CODPOS  AS COD_POSTO, "
	cSQL += "               SZ5.Z5_DESPOS  AS POSTO, "
	cSQL += "               SZ5.Z5_NOMAGE  AS AGENTE, "
	cSQL += "               SZ5.Z5_GRUPO   AS GRUPO, "
	cSQL += "               SZ5.Z5_REDE    AS REDE "
	cSQL += "        FROM   "+RETSQLNAME("SZ5")+" SZ5 "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ3")+" SZ3 "
	cSQL += "                      ON SZ3.Z3_FILIAL = "+VALTOSQL(XFILIAL("SZ3"))+" "
	cSQL += "                         AND SZ3.Z3_CODGAR = SZ5.Z5_CODPOS "
	cSQL += "                         AND SZ3.Z3_CODGAR > ' ' "
	cSQL += "                         AND SZ3.Z3_TIPENT = '4' "
	cSQL += "                         AND SZ3.D_E_L_E_T_ = ' ' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SZ8")+" SZ8 "
	cSQL += "                      ON SZ8.Z8_FILIAL = "+VALTOSQL(XFILIAL("SZ8"))+" "
	cSQL += "                         AND SZ8.Z8_COD = SZ3.Z3_PONDIS "
	cSQL += "                         AND SZ8.D_E_L_E_T_ = ' ' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SB1")+" SB1 "
	cSQL += "                      ON SB1.B1_FILIAL = "+VALTOSQL(XFILIAL("SB1"))+" "
	cSQL += "                         AND SB1.B1_COD = SZ5.Z5_PRODUTO "
	cSQL += "                         AND SB1.B1_CATEGO = '1' "
	cSQL += "                         AND SB1.D_E_L_E_T_ = ' ' "
	cSQL += "               LEFT JOIN "+RETSQLNAME("SC6")+" SC6 "
	cSQL += "                      ON SC6.C6_FILIAL = "+VALTOSQL(XFILIAL("SC6"))+" "
	cSQL += "                         AND SC6.C6_NUM = SZ5.Z5_PEDIDO "
	cSQL += "                         AND SC6.C6_ITEM = SZ5.Z5_ITEMPV "
	cSQL += "                         AND SC6.D_E_L_E_T_ = ' ' "
	cSQL += "        WHERE  SZ5.Z5_FILIAL = "+VALTOSQL(XFILIAL("SZ5"))+" "
	cSQL += "               AND SZ5.Z5_EMISSAO >= "+VALTOSQL(MV_PAR07)+" "
	cSQL += "               AND SZ5.Z5_EMISSAO <= "+VALTOSQL(MV_PAR08)+" "
	cSQL += "               AND SZ5.Z5_TIPO = 'ENTHAR' "
	cSQL += "               AND SZ5.D_E_L_E_T_ = ' ' "
	cSQL += "               AND SZ8.Z8_FORNEC >= "+VALTOSQL(MV_PAR03)+" "
	cSQL += "               AND SZ8.Z8_FORNEC <= "+VALTOSQL(MV_PAR04)+" "
	cSQL += "               AND SB1.B1_COD >= "+VALTOSQL(MV_PAR05)+" "
	cSQL += "               AND SB1.B1_COD <= "+VALTOSQL(MV_PAR06)+") RESULT_SZ5 "
	cSQL += "       INNER JOIN "+RETSQLNAME("SA2")+" SA2 "
	cSQL += "               ON A2_FILIAL = "+VALTOSQL(XFILIAL("SA2"))+" "
	cSQL += "                  AND A2_COD = FORNEC "
	cSQL += "                  AND A2_LOJA = LOJA "
	cSQL += "                  AND SA2.D_E_L_E_T_ = ' ' "
	cSQL += "       LEFT JOIN  RESULT_SB6 "
	cSQL += "              ON B6_CLIFOR = FORNEC "
	cSQL += "                 AND B6_PRODUTO = CODMIDIA "
	cSQL += "WHERE  FORNEC <> ' ' "
	cSQL += "        OR LOJA <> ' ' "
	cSQL += "        OR QTDMIDIA <> 0 "
	cSQL += "GROUP  BY FORNEC, "
	cSQL += "          LOJA, "
	cSQL += "          A2_NOME, "
	cSQL += "          CODMIDIA, "
	cSQL += "          DESCMIDIA, "
	cSQL += "          SB6_REMESSA "
	cSQL += "ORDER  BY 1, "
	cSQL += "          3, "
	cSQL += "          4 "
	
	If lExpQry
		StaticCall( CSFA110, A110Script, cSQL )
	Endif
	
	If lExpDados .OR. lExpTrack
		MsgAlert( 'A visão selecionada não trabalha com os vetores aDADOS ou aTrack.', cCadastro )
	Endif

	Memowrite("D:\TEMP\kdxP3_KdxProc5", cSQL )
	
	//cTRB := GetNextAlias()
	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.T.,.T.)
	TCQUERY cSQL alias "Kdx5" NEW
	
	If Kdx5->( .NOT. BOF() ) .AND. Kdx5->( .NOT. EOF() )
		oFwMsEx := FWMsExcel():New()
		
		ParamExc( @oFwMsEx, nQtdMeses )
	   
	   oFwMsEx:AddWorkSheet( cWorkSheet )
	   oFwMsEx:AddTable( cWorkSheet, cTable )	
	
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Código"                                                          , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"                                                            , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Razão social"                                                    , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Código produto"                                                  , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Descrição do produto"                                            , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Total de remessa"                                                , 3, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Qtd. Movimentada"                                                , 3, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Saldo (remessa menos movto)"                                     , 3, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Consumo médio [Qtd.de meses (" + LTrim( Str( nQtdMeses ) ) + ")]", 3, 1 )
		
		While Kdx5->( .NOT. EOF() )
			nPoint++
			If nPoint == 5
				nPoint := 1
			Endif
			
		   MsProcTxt( 'Somando remessa e calculando consumo [ ' + aPoint[ nPoint ] + ' ] '  )
		   ProcessMessage()
			
			//nRemessa := KdxRemessa( Kdx5->FORNEC, Kdx5->CODMIDIA )
			
			oFwMsEx:AddRow( cWorkSheet, cTable, { Kdx5->FORNEC,;
			Kdx5->LOJA,;
			Kdx5->A2_NOME,;
			Kdx5->CODMIDIA,;
			Kdx5->DESCMIDIA,;
			Kdx5->REMESSA,;
			Kdx5->QTDMIDIA,;
			Kdx5->REMESSA - Kdx5->QTDMIDIA,;
			Kdx5->QTDMIDIA/nQtdMeses} )
			
			Kdx5->( dbSkip() )
		End
		
		oFwMsEx:Activate()
		cDirTmp := GetTempPath()
		cDir := GetSrvProfString("Startpath","")
	
		LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cFile ), Sleep( 500 ) } )
	
		If __CopyFile( cFile, cDirTmp + cFile )
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cFile )
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			Sleep(500)
		Else
			MsgInfo( "Não foi possível copiar o arquivo para o diretório temporário do usuário." )
		Endif
	Else
		MsgAlert( 'Não localizei dados com os parâmetros informados. ', cCadastro )
	Endif
	Kdx5->( dbCloseArea() )
Return

Static Function KdxRemessa( cB6_CLIFOR, cB6_PRODUTO )
	Local cSQL := ''
	//Local cTRB := 'REMESSA'
	Local nRemessa := 0	

	cSQL := "SELECT  B6_PRODUTO, "
	cSQL += "        NVL( SUM( B6_QUANT ), 0 ) AS SB6_REMESSA "
	cSQL += "FROM    "+RetSqlName("SB6")+" SB6 "
	cSQL += "WHERE   B6_FILIAL BETWEEN "+ValToSql(MV_PAR01)+" AND "+ValToSql(MV_PAR02)+" "
	cSQL += "    AND B6_CLIFOR = "+ValToSql(cB6_CLIFOR)+" "
	cSQL += "    AND B6_PRODUTO = "+ValToSql(cB6_PRODUTO)+" "
	cSQL += "    AND B6_PODER3 = 'R' "
	cSQL += "    AND B6_EMISSAO >= "+ValToSql(MV_PAR07)+" "
	cSQL += "    AND B6_EMISSAO <= "+ValToSql(MV_PAR08)+" "
	cSQL += "    AND SB6.D_E_L_E_T_ = ' ' "
	cSQL += "GROUP   BY B6_PRODUTO "

	Memowrite("D:\TEMP\kdxP3_KdxRemessa", cSQL )

	cSQL := ChangeQuery( cSQL )
	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.T.,.T.)
	TCQUERY cSQL alias "KdxR" NEW
	nRemessa := KdxR->SB6_REMESSA
	KdxR->( dbCloseArea() )
Return( nRemessa )

/******
 *
 * Rotina...: Rotina para efetuar ajustes na base considerando as devoluções indevidas.
 * Autor....: Robson Gonçalves
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
User Function AjustP3()
	Local aButton := {}
	Local aParamBox := {}
	Local aRet := {}
	Local aSay := {}
	Local cTime := ( SubStr( StrTran( Time(), ':', '' ), 1, 4 ) + '00' )
	Local lAcesso := .F.
	Local nOpcao := 0
	
	Private cCadastro := 'Ajuste - Poder de 3º'
	
	AAdd( aSay, 'Esta rotina tem por objetivo em ajustar o Kardex dos movimentos de poder de terceiros.' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Somente usuários autorizados poderão executar esta rotina.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
   
	If nOpcao==1
		AAdd( aParamBox, { 8, 'Você precisa se autenticar', Space( 15 ) ,'' ,'' ,'' ,'' ,60 ,.T. } )
		AAdd( aParamBox, { 1, 'Processar a partir da data', Ctod( Space( 8 ) ), '', '', '', '', 50, .T. } )
		AAdd( aParamBox, { 5, 'Simular o processamento?', .F., 90, '', .F. } )
		While .NOT. lAcesso
			If ParamBox( aParamBox, 'Parâmetros', aRet,,,,,,,, .F., .F. )
				If ( lAcesso := RTrim( aRet[ 1 ] ) == cTime ) 
					MsgInfo('Você foi autenticado, isto libera seu acesso para o processamento.', cCadastro )
					Exit
				Else
					MsgAlert('Autenticação incorreta, tente outra vez.', cCadastro )
					aRet[ 1 ] := Space( 15 )
				Endif
			Else
				Exit
			Endif
		End
		
		If lAcesso
			MsAguarde( {|| AjustPrc( aRet[ 2 ], aRet[ 3 ] ) }, cCadastro ,'Processando...', .F. )
		Endif
	Endif	
Return

/******
 *
 * Rotina...: Rotina auxiliar para processar as devoluções indevidas.
 * Autor....: Robson Gonçalves
 * Uso......: Certisign Certificadora Digital S.A.
 *
 */
Static Function AjustPrc( dDataIni, lSimular )
	Local aDADOS := {}
	Local aDADOS_SZ5 := {}
	Local aHeadMov := {}
	Local aHeadZ5 := {}
	Local aSA2 := {}
	Local aSB1 := {}
	Local aSB6 := {}
	Local aSD1 := {}
	Local aSZ5 := {}

	Local cDataIni := Dtos( dDataIni )
	Local cDoc := ''
	Local cFil := ''
	Local cSer := ''
	Local cTrbB6 := ''
	Local cTrbD1 := ''
	Local cTrbZ5 := ''

	Local lDelete := .T.
	Local lFazerAlgo := .T.

	Local nDelZ5 := 0
	Local nE := 0
	Local nI := 0
	Local nNoDelZ5 := 0
	Local nP1 := 0, nP2
	
	cTrbB6 := GetNextAlias()
	cTrbD1 := cTrbB6 + 'B6'
	cTrbZ5 := cTrbB6 + 'Z5'
	
   MsProcTxt( 'Buscando os dados para iniciar o processamento...'  )
   ProcessMessage()

	BEGINSQL ALIAS cTrbB6
		SELECT B6_FILIAL, 
		       B6_DOC, 
		       B6_SERIE, 
		       B6_PRODUTO,
		       SB6.R_E_C_N_O_ AS B6_RECNO
		FROM   %Table:SB6% SB6 
		WHERE  B6_FILIAL =  %xFilial:SB6%
		       AND B6_PODER3 = 'D'
		       AND B6_TIPO = 'E'
		       AND B6_TPCF = 'F'
		       AND B6_EMISSAO >= %Exp:cDataIni%
		       AND SB6.%NotDel%
		ORDER  BY B6_FILIAL,
		          B6_CLIFOR,
		          B6_DOC,
		          B6_PRODUTO
	ENDSQL
	 
	While (cTrbB6)->( .NOT. EOF() )
		
   	MsProcTxt( 'Processando documento ' + (cTrbB6)->B6_DOC )
   	ProcessMessage()
   	
   	cFil := (cTrbB6)->B6_FILIAL
		cDoc := (cTrbB6)->B6_DOC
		cSer := (cTrbB6)->B6_SERIE
		
		While (cTrbB6)->( .NOT. EOF() ) .AND. (cTrbB6)->B6_FILIAL == cFil .AND. (cTrbB6)->B6_DOC == cDoc .AND. (cTrbB6)->B6_SERIE == cSer
			AAdd( aSB6, { (cTrbB6)->B6_RECNO,;
			              (cTrbB6)->B6_FILIAL,;
			              (cTrbB6)->B6_DOC,;
			              (cTrbB6)->B6_SERIE,;
			              (cTrbB6)->B6_PRODUTO } )
			(cTrbB6)->( dbSkip() )
		End
		
		BEGINSQL ALIAS cTrbD1
			SELECT D1_FILIAL, 
			       D1_DOC, 
			       D1_SERIE, 
			       D1_IDENTB6, 
			       SD1.R_E_C_N_O_ AS D1_RECNO
			FROM   %Table:SD1% SD1
			WHERE  D1_FILIAL = %Exp:cFil%
			       AND D1_DOC = %Exp:cDoc%
			       AND D1_SERIE = %Exp:cSer%
			       AND D_E_L_E_T_ = ' '
		ENDSQL
		
		While (cTrbD1)->( .NOT. EOF() )
			AAdd( aSD1, { (cTrbD1)->D1_RECNO, (cTrbD1)->D1_FILIAL, (cTrbD1)->D1_DOC, (cTrbD1)->D1_SERIE, (cTrbD1)->D1_IDENTB6 } )
			(cTrbD1)->( dbSkip() )
		End
		(cTrbD1)->( dbCloseArea() ) 		
		
		BEGINSQL ALIAS cTrbZ5
			SELECT Z5_PRODUTO,
			       Z5_NFDEV,
			       Z5_DATVER,
			       R_E_C_N_O_ AS Z5_RECNO,
			       D_E_L_E_T_ AS Z5_DELETE 
			FROM   %Table:SZ5% SZ5
			WHERE  Z5_NFDEV = %Exp:cDoc%
		ENDSQL
		
		While (cTrbZ5)->( .NOT. EOF() )
			lDelete := (cTrbZ5)->Z5_DELETE == '*'
			AAdd( aSZ5, { LTrim( Str( (cTrbZ5)->Z5_RECNO ) ),;
			              (cTrbZ5)->Z5_PRODUTO,;
			              Iif( lDelete, 'Está deletado', 'Está ativo' ),;
			              (cTrbZ5)->Z5_NFDEV,;
			              (cTrbZ5)->Z5_DATVER } )
			If lDelete
				nDelZ5++
			Else
				nNoDelZ5++
			Endif
			(cTrbZ5)->( dbSkip() )
		End
		(cTrbZ5)->( dbCloseArea() )

		//-----------------------------------------------------------------------------------------------------------------
		// Verificar como está o registro da integração (SZ5) com o GAR.
		//-----------------------------------------------------------------------------------------------------------------
		// Se não houver registro no SZ5                              - informar no vetor e não fazer nada.
		// Se houver registro deletado e registro não deletado no SZ5 - informar no vetor e não fazer nada.
		// Se houver apenas registro deletado no SZ5                  - fazer a manutenção no B6 e D1 e registrar no vetor.
		//-----------------------------------------------------------------------------------------------------------------
		// nDelZ5 == 0 e nNoDelZ5 == 0 -> não fazer nada.
		// nDelZ5 == 0 e nNoDelZ5 > 0  -> não fazer nada.
		// nDelZ5 > 0  e nNoDelZ5 > 0  -> não fazer nada.
		//-----------------------------------------------------------------------------------------------------------------
		lFazerAlgo := nDelZ5 > 0 .AND. nNoDelZ5 == 0
		
		If lFazerAlgo
			dbSelectArea( 'SB6' )
			dbSetOrder( 1 )
			For nI := 1 To Len( aSB6 )
				SB6->( dbGoTo( aSB6[ nI, 1 ] ) )

				nP1 := AScan( aSA2, {|e| e[ 1 ] + e[ 2 ] == SB6->B6_CLIFOR + SB6->B6_LOJA } )
				If nP1 == 0
					AAdd( aSA2, { SB6->B6_CLIFOR, SB6->B6_LOJA, AllTrim( SA2->( GetAdvFVal( 'SA2', 'A2_NOME', xFilial( 'SA2' ) + SB6->B6_CLIFOR + SB6->B6_LOJA, 1 ) ) ) } )
					nP1 := Len( aSA2 )
				Endif
				
				nP2 := AScan( aSB1, {|e| e[ 1 ] == SB6->B6_PRODUTO } )
				If nP2 == 0
					AAdd( aSB1, { SB6->B6_PRODUTO, AllTrim( SB1->( GetAdvFVal( 'SB1', 'B1_DESC', xFilial( 'SB1' ) + SB6->B6_PRODUTO, 1 ) ) ) } )
					nP2 := Len( aSB1 )
				Endif
				
				SB6->( AAdd( aDADOS, { B6_FILIAL,;
				                       B6_DOC,;
				                       B6_SERIE,;
				                       B6_EMISSAO,;
				                       B6_CLIFOR,;
				                       B6_LOJA,;
				                       aSA2[ nP1, 3 ],;
				                       B6_PRODUTO,;
				                       aSB1[ nP2, 2 ],;
				                       B6_QUANT,;
				                       B6_IDENT,;
				                       aSB6[ nI, 1 ],;
				                       Iif( Type( 'aSD1[ nI, 1 ]' ) == 'U', '', aSD1[ nI, 1 ] ),;
				                       'Registro deletado no SZ5' } ) )
				
				If .NOT. lSimular
					SB6->( RecLock( 'SB6', .F. ) )
					SB6->( dbDelete() )
					SB6->( MsUnLock() )
				Endif
			Next nI
			
			If .NOT. lSimular
				dbSelectArea( 'SD1' )
				dbSetOrder( 1 )
				For nI := 1 To Len( aSD1 )
					SD1->( dbGoTo( aSD1[ nI, 1 ] ) )
					SD1->( RecLock( 'SD1', .F. ) )
					SD1->D1_IDENTB6 := ''
					SD1->( MsUnLock() )
				Next nI
			Endif			
		Else
			For nI := 1 To Len( aSB6 )
				SB6->( dbGoTo( aSB6[ nI, 1 ] ) )

				nP1 := AScan( aSA2, {|e| e[ 1 ] + e[ 2 ] == SB6->B6_CLIFOR + SB6->B6_LOJA } )
				If nP1 == 0
					AAdd( aSA2, { SB6->B6_CLIFOR, SB6->B6_LOJA, AllTrim( SA2->( GetAdvFVal( 'SA2', 'A2_NOME', xFilial( 'SA2' ) + SB6->B6_CLIFOR + SB6->B6_LOJA, 1 ) ) ) } )
					nP1 := Len( aSA2 )
				Endif
				
				nP2 := AScan( aSB1, {|e| e[ 1 ] == SB6->B6_PRODUTO } )
				If nP2 == 0
					AAdd( aSB1, { SB6->B6_PRODUTO, AllTrim( SB1->( GetAdvFVal( 'SB1', 'B1_DESC', xFilial( 'SB1' ) + SB6->B6_PRODUTO, 1 ) ) ) } )
					nP2 := Len( aSB1 )
				Endif

				SB6->( AAdd( aDADOS, { B6_FILIAL,;
				                       B6_DOC,;
				                       B6_SERIE,;
				                       B6_EMISSAO,;
				                       B6_CLIFOR,;
				                       B6_LOJA,;
				                       aSA2[ nP1, 3 ],;
				                       B6_PRODUTO,;
				                       aSB1[ nP2, 2 ],;
				                       B6_QUANT,;
				                       B6_IDENT,;
				                       aSB6[ nI, 1 ],;
				                       Iif( Type( 'aSD1[ nI, 1 ]' ) == 'U', '', aSD1[ nI, 1 ] ),;
				                       Iif(nDelZ5==0.AND.nNoDelZ5==0,'Não há registro no SZ5, logo não será feito nada.',;
				                       'Há registro deletado e registro não deletado no SZ5, logo não será feito nada.') } ) )
			Next nI
		Endif
		
		For nI := 1 To Len( aSZ5 )
			AAdd( aDADOS_SZ5, Array( Len( aSZ5[ nI ] ) ) )
			nE := Len( aDADOS_SZ5 )
			For nP1 := 1 To Len( aSZ5[ nI ] )
				aDADOS_SZ5[ nE, nP1 ] := aSZ5[ nI, nP1 ]
			Next nP1
		Next nI

		aSB6 := {}
		aSD1 := {}
		aSZ5 := {}
		nDelZ5 := 0
		nNoDelZ5 := 0
	End
	(cTrbB6)->( dbCloseArea() )
	
	If Len( aDADOS ) > 0
   	MsProcTxt( 'Gerando resultados em planilhas...' )
   	ProcessMessage()
   	
		aHeadMov := { 'FILIAL', 'DOCUMENTO', 'SERIE', 'EMISSÃO', 'FORNECEDOR', 'LOJA', 'RAZÃO SOCIAL', 'PRODUTO', 'DESCRIÇÃO',;
		              'QUANTIDADE', 'IDENT_SB6', 'SB6_RECNO', 'SD1_RECNO', 'OBSERVAÇÃO' }
		
		DlgToExcel({ { 'ARRAY', 'Movimentos', aHeadMov, aDADOS } })
		
		Sleep( 500 )
		
		aHeadZ5 := { 'SZ5_RECNO', 'SZ5_PRODUTO', 'SZ5_DELETE', 'SZ5_NFDEV', 'SZ5_DATVER'}
		
		DlgToExcel({ { 'ARRAY', 'Registros SZ5', aHeadZ5, aDADOS_SZ5 } })
	Endif
	
	MsgInfo( 'Processo finalizado', cCadastro ) 
Return
