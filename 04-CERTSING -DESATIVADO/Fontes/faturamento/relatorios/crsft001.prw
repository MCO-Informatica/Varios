#Include 'Protheus.ch'
#Include 'Totvs.ch'

//+-------------------------------------------------------------------+
//| Rotina | CRSFT001 | Autor | Rafael Beghini | Data | 16.01.2018 
//+-------------------------------------------------------------------+
//| Descr. | Relação dos Pedidos não faturados para geração de  
//|        | arquivo XML utilizando o método FWMsExcel
//+-------------------------------------------------------------------+
//| Uso    | CertiSign
//+-------------------------------------------------------------------+
User Function CRSFT001()
	Local nOpc   := 0
	Local aRet   := {}
	Local aParamBox := {}
	
	Private cTitulo := "Relação dos Pedidos não faturados."
	Private aSay    := {}
	Private aButton := {}
	Private cAliasA := GetNextAlias()
	
	AAdd( aSay , "Rotina customizada para geração de relatório com informações" )
	AAdd( aSay , "Pedidos não faturados. Rotina utilizando o método FWMsExcel")
	AAdd( aSay , "")
	AAdd( aSay , "")
	AAdd( aSay, "Clique para continuar...")
	
	aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( cTitulo, aSay, aButton )

	If nOpc == 1
		aAdd(aParamBox,{1 ,"Filial de"  ,Space(02),"","","SM0","",0,.F.}) // Tipo caractere
		aAdd(aParamBox,{1 ,"Filial Ate" ,Space(02),"","","SM0","",0,.F.}) // Tipo caractere
		aAdd(aParamBox,{1 ,"Emissão de" ,dDataBase,"","",""   ,"",50,.F.}) // Tipo caractere
		aAdd(aParamBox,{1 ,"Emissão Ate",dDataBase,"","",""   ,"",50,.T.}) // Tipo caractere
				
		If ParamBox(aParamBox,"Parâmetros...",@aRet)
			FWMsgRun(, {|| A010Query( aRet ) },cTitulo,'Gerando excel, aguarde...')
		EndIF
	EndIF
Return

//+-------------------------------------------------------------------+
//| Rotina | A010Query | Autor | Rafael Beghini | Data | 16.01.2018 
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
	Local cMV_par04 := ''
	
	//Atribui conforme o Parambox enviou
	cMV_par01 := aRet[1] //Filial
	cMV_par02 := aRet[2] //Filial
	cMV_par03 := DtoS(aRet[3]) //Data emissão
	cMV_par04 := DtoS(aRet[4]) //Data emissão
	
	cSQL += "SELECT DISTINCT C5_FILIAL, " + CRLF
	cSQL += "                C5_NUM, " + CRLF
	cSQL += "                C5_ATDTLV, " + CRLF
	cSQL += "                C5_NUMATEX, " + CRLF
	cSQL += "                C5_XORIGPV, " + CRLF
	cSQL += "                C5_EMISSAO, " + CRLF
	cSQL += "                C5_CLIENTE, " + CRLF
	cSQL += "                A1_NOME, " + CRLF
	cSQL += "                C5_CONDPAG, " + CRLF
	cSQL += "                C5_XNATURE, " + CRLF
	cSQL += "                C5_LIBEROK, " + CRLF
	cSQL += "                C5_TOTPED, " + CRLF
	cSQL += "                C5_XPOSTO, " + CRLF
	cSQL += "                C5_XLIBFAT, " + CRLF
	cSQL += "                (SELECT C9_DATALIB " + CRLF
	cSQL += "                 FROM " + RetSQLName('SC9') + " SC9 " + CRLF
	cSQL += "                 WHERE  C9_FILIAL = '" + xFilial('SC9') + "' " + CRLF
	cSQL += "                        AND C9_PEDIDO = SC5.C5_NUM " + CRLF
	cSQL += "                        AND ROWNUM = 1 " + CRLF
	cSQL += "                        AND SC9.D_E_L_E_T_ = ' ') DATALIB, " + CRLF
	cSQL += "                Sum(C6_VALOR)                     VALORTOT, " + CRLF
	cSQL += "                Max(C5_VEND1)                     VEND1, " + CRLF
	cSQL += "                Max(A3_NOME)                      NVEND, " + CRLF
	cSQL += "                Max(C5_XMOTBLQ)                   XMOTBLQ " + CRLF
	cSQL += "FROM " + RetSQLName('SC5') + " SC5 " + CRLF
	cSQL += "       LEFT JOIN " + RetSQLName('SA3') + " SA3 " + CRLF
	cSQL += "              ON A3_COD = C5_VEND1 " + CRLF
	cSQL += "                 AND SA3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       LEFT JOIN " + RetSQLName('SA1') + " SA1 " + CRLF
	cSQL += "              ON A1_COD = C5_CLIENTE " + CRLF
	cSQL += "                 AND A1_LOJA = C5_LOJACLI " + CRLF
	cSQL += "                 AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       LEFT JOIN " + RetSQLName('SC6') + " SC6 " + CRLF
	cSQL += "              ON C6_FILIAL = C5_FILIAL " + CRLF
	cSQL += "                 AND C6_NUM = C5_NUM " + CRLF
	cSQL += "                 AND SC6.D_E_L_E_T_ = ' ' " + CRLF
	
	cSQL += "WHERE  C5_FILIAL BETWEEN '" + cMV_par01 + "' AND '" + cMV_par02 + "' " + CRLF
	cSQL += "       AND C5_EMISSAO BETWEEN '" + cMV_par03 + "' AND '" + cMV_par04 + "' " + CRLF
	cSQL += "       AND C5_XORIGPV IN ( '1', '4', '5', '6', '8' ) " + CRLF
	cSQL += "       AND C5_LIBEROK IN ( ' ', 'S' ) " + CRLF
	cSQL += "       AND C5_NOTA = ' ' " + CRLF
	cSQL += "       AND C5_BLQ IN ( ' ', '1', '2' ) " + CRLF
	cSQL += "       AND SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "GROUP  BY C5_FILIAL, " + CRLF
	cSQL += "          C5_NUM, " + CRLF
	cSQL += "          C5_ATDTLV, " + CRLF
	cSQL += "          C5_NUMATEX, " + CRLF
	cSQL += "          C5_XORIGPV, " + CRLF
	cSQL += "          C5_EMISSAO, " + CRLF
	cSQL += "          C5_CLIENTE, " + CRLF
	cSQL += "          A1_NOME, " + CRLF
	cSQL += "          C5_CONDPAG, " + CRLF
	cSQL += "          C5_XNATURE, " + CRLF
	cSQL += "          C5_LIBEROK, " + CRLF
	cSQL += "          C5_TOTPED, " + CRLF
	cSQL += "          C5_XPOSTO, " + CRLF
	cSQL += "          C5_XLIBFAT " + CRLF
		
	cSQL := ChangeQuery(cSQL)
	
	IF Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), cAliasA, .F., .T.)
	
	//TCSetField(cAliasA, "LIQ_RATEIO", "N", 12, 2 )
	
	IF (cAliasA)->(!Eof())
		A010Excel( cAliasA )
	Else
		MsgAlert('A query não retornou registros, por favor verifique os parâmetros informados.', cTitulo)
	EndIF
Return

//+-------------------------------------------------------------------+
//| Rotina | A010Excel | Autor | Rafael Beghini | Data | 16.01.2018 
//+-------------------------------------------------------------------+
//| Descr. | Gera o arquivo XML conforme query realizada. 
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A010Excel( cAliasA )
	Local cWorkSheet := 'Pedidos'
	Local cTable     := 'Relatório de pedidos não faturados
	Local oExcel     := Nil
	Local cPath      := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile  := cPath + 'Pedidos_nao_faturados' + ".XML"
	Local cORIGPV	 := ''
	Local aCombo	 := StrToKarr( U_CSC5XBOX('Z4'), ';' )
	Local nPos		 := 0
	
	oExcel := FWMSEXCEL():New() //Método para geração em XML
	
	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >     , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Filial"        , 1     , 1    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Pedido"        , 1     , 1    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Atend. TLV."   , 1     , 1    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Aten Externo"  , 1     , 1    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Origem P.V."   , 1     , 1    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Dt. Emissão"   , 1     , 4    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Dt. Liberação" , 1     , 4    , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Cod.Cliente"   , 1     , 1	 , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Razão Social"  , 1     , 1	 , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Cond. Pagto"   , 1     , 1	 , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Natureza"      , 1     , 1	 , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Liber. Total"  , 1     , 1	 , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Total Pedido"  , 1     , 3	 , .T. )
	oExcel:AddColumn( cWorkSheet, cTable, "Posto"         , 1     , 1	 , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Vendedor"      , 1     , 1	 , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Nome Vendedor" , 1     , 1	 , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Mot.Bloqueio"  , 1     , 1	 , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Lib. Pagamento", 1     , 1	 , .F. )
	
	//nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada
	
	While (cAliasA)->(!Eof())
	
		IF (cAliasA)->C5_XORIGPV == '8' .And. (cAliasA)->C5_XLIBFAT == 'N'
            (cAliasA)->( dbSkip() )
            Loop
        EndIF
		
		nPos := AScan( aCombo, {|x| Left(x,1) ==(cAliasA)->C5_XORIGPV  } )
		cORIGPV  := IIF( nPos > 0,aCombo[nPos], '')
						
		oExcel:AddRow( cWorkSheet, cTable, { (cAliasA)->C5_FILIAL, (cAliasA)->C5_NUM, (cAliasA)->C5_ATDTLV,;
											 (cAliasA)->C5_NUMATEX, cORIGPV, sToD((cAliasA)->C5_EMISSAO),;
											 sToD((cAliasA)->DATALIB), (cAliasA)->C5_CLIENTE, (cAliasA)->A1_NOME,;
                                             (cAliasA)->C5_CONDPAG, (cAliasA)->C5_XNATURE, (cAliasA)->C5_LIBEROK,;
                                             (cAliasA)->VALORTOT, (cAliasA)->C5_XPOSTO,;
                                             (cAliasA)->VEND1, (cAliasA)->NVEND, (cAliasA)->XMOTBLQ, (cAliasA)->C5_XLIBFAT })
		
	(cAliasA)->( dbSkip() )
	End
		
	oExcel:Activate()              //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório
	
	ShellExecute( "Open", cNameFile , '', '', 1 ) //Abre o arquivo na tela após salvar	
Return