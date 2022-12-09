#Include 'Protheus.ch'
#Include 'Totvs.ch'
#include 'Topconn.ch'
#Include 'Rwmake.ch'

//+-------------------------------------------------------------------+
//| Rotina | CSSC5002 | Autor | Rafael Beghini | Data | 28.04.2016 
//+-------------------------------------------------------------------+
//| Descr. | Relatório de Pedidos Liberados e Nao Recebidos
//|        | 
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSSC5002()
	Local nOpc   := 0
	Local aRet   := {}
	Local aParamBox := {}
	
	Private cTitulo := "Pedidos Liberados e Não Recebidos"
	Private aSay    := {}
	Private aButton := {}
	Private cAliasA := GetNextAlias()
	
	AAdd( aSay , "Listagem dos pedidos já liberados mas que não foram informados no CNAB" )
	AAdd( aSay , "")
	AAdd( aSay, "Clique para continuar...")
	
	AAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	AAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( cTitulo, aSay, aButton )

	If nOpc == 1
		aAdd(aParamBox,{1,"Liberação de " ,Ctod(Space(8))  ,"","","","",50,.F.}) // Tipo data
		aAdd(aParamBox,{1,"Liberação ate" ,Ctod(Space(8))  ,"","","","",50,.T.}) // Tipo data
		aAdd(aParamBox,{1,"Vencimento ate",Ctod(Space(8))  ,"","","","",50,.F.}) // Tipo data
		aAdd(aParamBox,{1,"Vencimento ate",cToD('01/12/49'),"","","","",50,.F.}) // Tipo data
		aAdd(aParamBox,{1,"Pedido GAR"    ,Space(8)        ,"","","","",50,.F.}) // Tipo data
				
		If ParamBox(aParamBox,"",@aRet)
			Conout( "CSSC5003 - Begin Emp(01/02) - ["+ Dtoc(Date()) +" - "+ TIME() +"]" )
			FWMsgRun(, {|| A010Query( aRet ) },cTitulo,'Gerando excel, aguarde...')
			Conout( "CSSC5003 - End Emp(01/02) - ["+ Dtoc(Date()) +" - "+ TIME() +"]" )
		EndIF
	EndIF
Return

//+-------------------------------------------------------------------+
//| Rotina | A010Query | Autor | Rafael Beghini | Data | 28.04.2016 
//+-------------------------------------------------------------------+
//| Descr. | Cria a query conforme parâmetros no Parambox
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A010Query( aRet )
	Local cSQL      := ''
	Local cMV_par01 := ''
	Local cMV_par02 := ''
	Local cMV_par03 := ''
	 
	//Atribui conforme o Parambox enviou
	cMV_par01 := aRet[1]
	cMV_par02 := aRet[2]
	cMV_par03 := aRet[5]
	
	cSQL += "SELECT c5_filial, c5_num, c5_chvbpag, c5_xnpsite, ade_filial, ade_codigo, c5_emissao, c5_cliente, c5_lojacli," + CRLF
	cSQL += "       ade_xar, Trim(ADE_EMAIL2) ADE_EMAIL2, Trim(ade_to) ade_to, adf_data, c6_item, d2_cod, d2_total, "         + CRLF
	cSQL += "       'SP'||Substr(d2_serie, 1, 1)||d2_doc AS Documento"  + CRLF
	cSQL += "FROM   (SELECT c5_filial, c5_num, c5_chvbpag, c5_xnpsite, ade_filial, ade_codigo, c5_emissao, c5_cliente, c5_lojacli," + CRLF
	cSQL += "               ade_xar, Trim(ADE_EMAIL2) ADE_EMAIL2, Trim(ade_to) ade_to, adf_data" + CRLF
	cSQL += "        FROM   "+ RetSqlName("ADF") +" ADF "            + CRLF
	cSQL += "               INNER JOIN "+ RetSqlName("ADE") +" ADE " + CRLF
	cSQL += "                       ON ADE.d_e_l_e_t_ = ' ' "        + CRLF
	cSQL += "                          AND ade_filial = adf_filial " + CRLF
	cSQL += "                          AND ade_codigo = adf_codigo " + CRLF
	cSQL += "                          AND ade_grupo = '71' "        + CRLF
	cSQL += "                          AND ade_pedgar <> ' ' "       + CRLF
	cSQL += "               INNER JOIN "+ RetSqlName("SC5") +" SC5 " + CRLF
	cSQL += "                       ON SC5.d_e_l_e_t_ = ' ' "        + CRLF
	cSQL += "                          AND c5_filial = '"+xFilial("SC5")+"'  " + CRLF
	cSQL += "                          AND ade_pedgar = c5_chvbpag " + CRLF
	cSQL += "                          AND c5_tipo = 'N' "           + CRLF
	cSQL += "                          AND c5_tipmov <> '2' "         + CRLF
	IF .NOT. Empty(cMV_par03)
	cSQL += "                          AND c5_chvbpag = '"+ cMV_par03 +"' " + CRLF
	Else
	cSQL += "                          AND c5_chvbpag <> '          '"  + CRLF
	EndIF
	cSQL += "        WHERE  ADF.d_e_l_e_t_ = ' ' "                      + CRLF
	cSQL += "               AND adf_filial = '" + xFilial("ADF") + "' " + CRLF
	cSQL += "               AND adf_data >= '" + dToS(cMV_par01) + "' " + CRLF
	cSQL += "               AND adf_data <= '" + dToS(cMV_par02) + "' " + CRLF
	cSQL += "               AND ( adf_codsu9 = '003192' "            + CRLF
	cSQL += "                      OR adf_codsu9 = '008749' "        + CRLF
	cSQL += "                      OR adf_codsu9 = '014109' "        + CRLF
	cSQL += "                      OR adf_codsu9 = '008067' ) ), "   + CRLF
	cSQL += "       "+ RetSqlName("SC6") +" SC6 "                    + CRLF
	cSQL += "       INNER JOIN "+ RetSqlName("SF4") +" SF4 "         + CRLF
	cSQL += "               ON SF4.d_e_l_e_t_ = ' ' "                + CRLF
	cSQL += "                  AND f4_filial = '" + xFilial("SF4") + "' " + CRLF
	cSQL += "                  AND f4_codigo = c6_tes "              + CRLF
	cSQL += "                  AND f4_duplic = 'S' "                 + CRLF
	cSQL += "       INNER JOIN "+ RetSqlName("SD2") +" SD2 "         + CRLF
	cSQL += "               ON SD2.d_e_l_e_t_ = ' ' "                + CRLF
	cSQL += "                  AND d2_filial = '"+ xFilial("SD2")+ "' "  + CRLF
	cSQL += "                  AND d2_pedido = c6_num "              + CRLF
	cSQL += "                  AND d2_itempv = c6_item "             + CRLF
	cSQL += "WHERE  SC6.d_e_l_e_t_ = ' ' "      + CRLF
	cSQL += "       AND c6_filial = c5_filial " + CRLF
	cSQL += "       AND c6_num = c5_num "       + CRLF
	
	//memowrite("c:\Intel\CSSC5002.txt",cSQL)	
	
	cSQL := ChangeQuery(cSQL)
	
	IF Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), cAliasA, .F., .T.)
	
	TcSetField( cAliasA,"d2_total" ,"N",15,2 )
	
	IF .NOT. (cAliasA)->( Eof() )
		A010Excel( cAliasA, aRet )
	Else
		MsgAlert('A query não retornou registros, por favor verifique os parâmetros informados.', cTitulo)
	EndIF
Return

//+-------------------------------------------------------------------+
//| Rotina | A010Excel | Autor | Rafael Beghini | Data | 28.04.2016
//+-------------------------------------------------------------------+
//| Descr. | Gera o arquivo CSV conforme query realizada. 
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A010Excel( cAliasA, aRet )
	Local cPath      := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cDir       := Curdir()
	Local cNameFile  := 'PedLib_nao_pg_' + dToS(ddatabase) + '.CSV'
	Local cCabec     := "Pedido Protheus" + ';' +"Pedido GAR" + ';' +"Pedido Site" + ';' + "Protocolo" + ';' + "Emissão Pedido" + ';' + "Liberação Pedido" + ';' +; 
					      "Cliente" + ';' + "Razão Social" + ';' + "Cidade" + ';' + "UF" + ';' + "e-Mail - Cliente" + ';' + "AR" + ';' +"E-mail" + ';' +; 
					      "Destinatário" + ';' + "Item" + ';' + "Produto" + ';' + "Descrição" + ';' + "Valor" + ';' + "Nº título" + ';' + "Valor" + ';' +; 
					      "Saldo" + ';' + "Vencimento NF" + ';'
	Local cCODIGO     := ''
	Local cLOJA       := ''
	Local cRazao      := ''
	Local cCidade     := ''
	Local cUF         := ''
	Local cEmail      := ''
	Local cE1_NUM     := ''
	Local nE1_VALOR   := 0
	Local nE1_SALDO   := 0
	Local cE1_VENCREA := ''
	Local cB1_DESC    := ''
	Local cDOCUMENTO  := ''
	Local cPICTURE    := '@E 99,999,999.99'
	Local nReg        := 0
	Local nHdl        := 0
	Local lRet        := .F.
	Local aDADOS := {}
	Local i := 0
	Private cA1xFil := ''
	Private cB1xFil := ''
	Private cF4xFil := ''
	Private cZQxFil := ''
	Private cE1xFil := ''
	
	OpenTable()
	
	IF File( cDir + cNameFile )
		Ferase( cDir + cNameFile)
	EndIF
	
	IF File( cPath + cNameFile )
		Ferase( cPath + cNameFile)
	EndIF
	
	nHdl := FCreate( cNameFile )
	FWrite( nHdl, cCabec + CRLF )
	
	Conout( "CSSC5003 - Proc - ["+ Dtoc(Date()) +" - "+ TIME() +"]" )			
	
	(cAliasA)->( dbGotop() )
	While (cAliasA)->(!EoF())
		cCODIGO := (cAliasA)->C5_CLIENTE
		cLOJA   := (cAliasA)->C5_LOJACLI
			
		IF SA1->( MsSeek( cA1xFil + cCODIGO + cLOJA ) )
			cRazao  := Alltrim( STRTRAN(SA1->A1_NOME, ';', ' ') )
			cCidade := SA1->A1_MUN
			cUF     := SA1->A1_EST
			cEmail  := Alltrim(SA1->A1_EMAIL)
		EndIF
		
		// Formado por Prefixo 'SP' + Serie + Numero da Nota
		cDOCUMENTO := (cAliasA)->Documento
	
		SE1->( MsSeek( cE1xFil + cCODIGO + cLOJA + cDOCUMENTO ) )
		
		IF SZQ->( MsSeek( cZQxFil + (cAliasA)->C5_XNPSITE ) )
			IF ( SE1->E1_VALOR < (cAliasA)->D2_TOTAL .OR. SE1->E1_SALDO > 0 ) .And. ( SE1->E1_VENCREA >= aRet[3] .And. SE1->E1_VENCREA <= aRet[4] )
				cE1_NUM     := SE1->E1_NUM 
				nE1_VALOR   := SE1->E1_VALOR
				nE1_SALDO   := SE1->E1_SALDO
				cE1_VENCREA := dToC(SE1->E1_VENCREA)
			Else
			   	(cAliasA)->(dbskip())
				Loop
			EndIF
		Else
			IF ( SE1->E1_VALOR < (cAliasA)->D2_TOTAL .OR. SE1->E1_SALDO > 0 ) .And. ( SE1->E1_VENCREA >= aRet[3] .And. SE1->E1_VENCREA <= aRet[4] )
				cE1_NUM     := SE1->E1_NUM 
				nE1_VALOR   := SE1->E1_VALOR
				nE1_SALDO   := SE1->E1_SALDO
				cE1_VENCREA := dToC(SE1->E1_VENCREA)
			Else
			   	(cAliasA)->(dbskip())
				Loop
			EndIF
		EndIF

		If SB1->(MsSeek(cB1xFil+(cAliasA)->D2_COD))
			cB1_DESC := rTrim(SB1->B1_DESC)
		EndIF
		
		AAdd( aDADOS, (cAliasA)->C5_NUM + ';' +  (cAliasA)->C5_CHVBPAG + ';' +  (cAliasA)->C5_XNPSITE + ';' + (cAliasA)->ADE_CODIGO + ';' +; 
				  dToc(sToD((cAliasA)->C5_EMISSAO)) + ';' + dToc(sToD((cAliasA)->ADF_DATA)) + ';' + (cAliasA)->C5_CLIENTE + ';' +  cRazao + ';' +; 
				  cCidade + ';' +  cUF + ';' +  cEmail + ';' +  (cAliasA)->ADE_XAR + ';' + (cAliasA)->ADE_EMAIL2 + ';' +  (cAliasA)->ADE_TO + ';' +; 
				  (cAliasA)->C6_ITEM + ';' +  (cAliasA)->D2_COD + ';' + cB1_DESC + ';' +  lTrim(TransForm((cAliasA)->D2_TOTAL,cPICTURE)) + ';' +; 
				  cE1_NUM + ';' +  lTrim(TransForm(nE1_VALOR,cPICTURE)) + ';' + lTrim(TransForm(nE1_SALDO,cPICTURE)) + ';' +  cE1_VENCREA + ';' )
		
		nReg := nReg + 1
		cCODIGO     := ''
		cLOJA       := ''
		cRazao      := ''
		cCidade     := ''
		cUF         := ''
		cEmail      := ''
		cE1_NUM     := ''
		nE1_VALOR   := 0
		nE1_SALDO   := 0
		cE1_VENCREA := ''
		cB1_DESC    := ''
		cDOCUMENTO  := ''
	(cAliasA)->( dbSkip() )
	End
	
	(cAliasA)->( dbCloseArea() )
	
	Sleep(500)
	
	IF nReg > 0
		For i := 1 To Len( aDADOS )
			FWrite( nHdl, aDADOS[i] + ';' + CRLF )
		Next i
		
		FClose( nHdl )
			
		//lRet := __CopyFile( cNameFile, cPath + cNameFile )
		lRet := CpyS2T( cNameFile, cPath )
		IF lRet
			Sleep(500)
			Ferase( cDir + cNameFile)
			IF ! ApOleClient("MsExcel") 
				MsgAlert("MsExcel não instalado. Para abrir o arquivo, localize-o na pasta %temp% ;",cTitulo)
				Return
			Else
				ShellExecute( "Open", cPath + cNameFile , '', '', 1 )
			EndIF
		Else
			MsgAlert('Não foi possível copiar o arquivo para a pasta %temp%, verifique.',cTitulo)
		EndIF
	Else
		MsgInfo('Após análise, não consta nenhum pedido liberado e não recebido conforme os parâmetros informados para consulta.', cTitulo)
	EndIF
	FClose( nHdl )
Return

Static Function OpenTable()
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	cA1xFil := xFilial("SA1")
	
	dbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	cB1xFil := xFilial("SB1")	
	
	dbSelectArea("SF4")
	SF4->(DbSetOrder(1)) 
	cF4xFil := xFilial("SF4")	
	
	dbSelectArea("SZQ")
	SZQ->(DbSetOrder(2)) 
	cZQxFil := xFilial("SZQ")	
	
	dbSelectArea("SE1")
	SE1->(DbSetOrder(2))
	cE1xFil := xFilial("SE1")
Return