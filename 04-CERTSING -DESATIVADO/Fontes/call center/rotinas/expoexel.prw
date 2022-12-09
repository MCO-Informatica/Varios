#Include 'Protheus.ch'

#DEFINE STREXP001 	"Vertical (Descrição Amigável CNAE)"


//+----------------------------------------------------------------+
//| Rotina | EXPOEXEL | Autor | Rafael Beghini | Data | 29.08.2016 
//+----------------------------------------------------------------+
//| Descr. | Relatório de Oportunidades de Vendas
//|        | utilizando a função FWMsExcel
//+----------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+----------------------------------------------------------------+
User Function EXPOEXEL()
	
	Local nOpc      := 0
	Local aRet      := {}
	Local aParamBox := {}
	Local aCombo    := {}
	
	Private cCadastro := "Oportunidades de Venda - Certisign"
	Private cShowQry  := ''
	Private cAliasA   := GetNextAlias()
	Private aSay      := {}
	Private aButton   := {}
	Private oExcel    := Nil
	Private lShowQry  := .F.
	
	AAdd( aSay, "Esta rotina irá imprimir o relatorio de Oportunidades de vendas",     )
	AAdd( aSay, "conforme parâmetros informados pelo usuário."                         )
	aAdd( aSay, ""                                                                     )
	aAdd( aSay, "Ao final do processamento, é gerado uma planilha com as informações." )
	
	aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() } } )
	aAdd( aButton, { 2, .T., {|| FechaBatch()            } } )
	
	SetKey( VK_F12 , {|| lShowQry := MsgYesNo('Exportar a consulta SQL?',cCadastro ) } )
	
	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1
		AAdd(aCombo,"Modelo 1")
		AAdd(aCombo,"Modelo 2")
		
		aAdd(aParamBox,{ 1 ,"Período de"   ,Ctod(Space(8)), "" ,"" ,""    ,"" ,20 ,.F. }) // 01
		aAdd(aParamBox,{ 1 ,"Período Ate"  ,dDatabase     , "" ,"" ,""    ,"" ,20 ,.T. }) // 02
		aAdd(aParamBox,{ 1 ,"Vendedor de"  ,Space(06)     , "" ,"" ,"SA3" ,"" ,0  ,.F. }) // 03
		aAdd(aParamBox,{ 1 ,"Vendedor Ate" ,'ZZZZZZ'      , "" ,"" ,"SA3" ,"" ,0  ,.T. }) // 04
		
		aAdd(aParamBox,{ 2 ,"Tipo Relatório" ,1 ,aCombo ,50 ,"" ,.F.})
		
		If ParamBox(aParamBox,"",@aRet)
			aRet[5] := Iif( ValType( aRet[ 5 ] ) == 'N', aRet[ 5 ], AScan( aCombo, {|e| e==aRet[ 5 ] } ) )
			FWMsgRun(, {|| A010Query( aRet ) },cCadastro,'Gerando relatório, aguarde...')
			If lShowQry
				A010ShowQry( cShowQry )
			EndIF
		EndIF
	EndIF
	
Return


//+-------------------------------------------------------------------+
//| Rotina | A010Query | Autor | Rafael Beghini | Data | 29.08.2016
//+-------------------------------------------------------------------+
//| Descr. | Cria a query conforme parâmetros no Parambox
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A010Query( aRet )
	
	Local cSQL      := ''
	Local cMV_par01 := cMV_par02 := cMV_par03 := cMV_par04 := ''
		
	//Atribui conforme o Parambox enviou
	cMV_par01 := dToS(aRet[1]) ; cMV_par02 := dToS(aRet[2]) ; cMV_par03 := aRet[3]  ; cMV_par04 := aRet[4]
	
	cSQL += "SELECT AD1_VEND, " + CRLF
	cSQL += "       TRIM(A3_NOME) A3_NOME, " + CRLF
	cSQL += "       AD1_NROPOR, " + CRLF
	cSQL += "       AD1_CODCLI||AD1_LOJCLI AS CLIENTE, " + CRLF
	cSQL += "       AD1_PROSPE||AD1_LOJPRO AS PROSPECT, " + CRLF
	cSQL += "       TRIM(AD1_DESCRI) AD1_DESCRI, " + CRLF
	cSQL += "       AD1_DTINI, " + CRLF
	cSQL += "       AD1_DTPFIM, " + CRLF
	cSQL += "       AD1_FEELIN, " + CRLF
	
	If aRet[5] == 1 //-> Modelo 1
		cSQL += "       ZE_MES, " + CRLF
		cSQL += "       ZE_ANO, " + CRLF
		cSQL += "       ZE_VALOR, " + CRLF
	ElseIf aRet[5] == 2 //-> Modelo 2
		cSQL += "       AD1_CODMEM, " + CRLF
	EndIf
	
	cSQL += "       AD1_STAGE, " + CRLF
	cSQL += "       TRIM(AC2_PPLINE) AC2_PPLINE, " + CRLF
	cSQL += "       AD1_VERBA, " + CRLF
	cSQL += "       AD1_FCS, " + CRLF
	cSQL += "       TRIM(X51.X5_DESCRI) DESC_FCS, " + CRLF
	cSQL += "       AD1_FCI, " + CRLF
	cSQL += "       TRIM(X52.X5_DESCRI) DESC_FCI, " + CRLF
	cSQL += "       AD1_CODPRO, " + CRLF
	cSQL += "       TRIM(X53.X5_DESCRI) DESC_PRO, " + CRLF
	cSQL += "       AD1_CAMPAN, " + CRLF
	cSQL += "       TRIM(UH_DESC) DESC_CAMPAN, " + CRLF
	cSQL += "       TRIM(Z2_CANAL) CANAL " + CRLF	
	cSQL += "FROM   " + RetSqlName("AD1") + " AD1 " + CRLF
	
	If aRet[5] == 1 //-> Modelo 1
		cSQL += "       LEFT OUTER JOIN " + RetSqlName("SZE") + " SZE " + CRLF
		cSQL += "                    ON SZE.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "                       AND SZE.ZE_FILIAL = '  ' " + CRLF
		cSQL += "                       AND SZE.ZE_NROPOR = AD1.AD1_NROPOR " + CRLF
	EndIf
	
	cSQL += "       LEFT OUTER JOIN " + RetSqlName("SA3") + " SA3 " + CRLF
	cSQL += "                    ON SA3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                       AND A3_FILIAL = '  ' " + CRLF
	cSQL += "                       AND A3_COD = AD1_VEND " + CRLF
	cSQL += "       LEFT OUTER JOIN " + RetSqlName("AC2") + " AC2 " + CRLF
	cSQL += "                    ON AC2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                       AND AC2_PROVEN = AD1_PROVEN " + CRLF
	cSQL += "                       AND AC2_STAGE = AD1_STAGE " + CRLF
	cSQL += "       LEFT OUTER JOIN " + RetSqlName("SX5") + " X51 " + CRLF
	cSQL += "                    ON X51.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                       AND X51.X5_FILIAL = AD1_FILIAL " + CRLF
	cSQL += "                       AND X51.X5_TABELA = 'ZQ' " + CRLF
	cSQL += "                       AND X51.X5_CHAVE = AD1_FCS " + CRLF
	cSQL += "       LEFT OUTER JOIN " + RetSqlName("SX5") + " X52 " + CRLF
	cSQL += "                    ON X52.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                       AND X52.X5_FILIAL = AD1_FILIAL " + CRLF
	cSQL += "                       AND X52.X5_TABELA = 'ZQ' " + CRLF
	cSQL += "                       AND X52.X5_CHAVE = AD1_FCI " + CRLF
	cSQL += "       LEFT OUTER JOIN " + RetSqlName("SX5") + " X53 " + CRLF
	cSQL += "                    ON X53.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                       AND X53.X5_FILIAL = AD1_FILIAL " + CRLF
	cSQL += "                       AND X53.X5_TABELA = 'Z3' " + CRLF
	cSQL += "                       AND X53.X5_CHAVE = AD1_CODPRO " + CRLF
	cSQL += "       LEFT OUTER JOIN " + RetSqlName("SUH") + " SUH " + CRLF
	cSQL += "                    ON SUH.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                       AND UH_MIDIA = AD1_CAMPAN " + CRLF
	cSQL += "       LEFT OUTER JOIN " + RetSqlName("SZ2") + " SZ2 " + CRLF
	cSQL += "                    ON SZ2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                       AND SZ2.Z2_CODIGO = SA3.A3_XCANAL " + CRLF	
	cSQL += "WHERE  AD1.D_E_L_E_T_ = ' '" + CRLF
	cSQL += "       AND AD1_FILIAL = '" + xFilial('AD1') + "' " + CRLF
	cSQL += "       AND AD1_DTINI >= '" + cMV_par01      + "' " + CRLF
	cSQL += "       AND AD1_DTINI <= '" + cMV_par02      + "' " + CRLF
	cSQL += "       AND AD1_VEND  >= '" + cMV_par03      + "' " + CRLF
	cSQL += "       AND AD1_VEND  <= '" + cMV_par04      + "' " + CRLF
	cSQL += "ORDER  BY AD1_NROPOR"
	
	If aRet[5] == 1 //-> Modelo 1
		cSQL += ", ZE_ANO, ZE_MES" + CRLF
	EndIf
	
	cShowQry += cSQL
	
	cSQL := ChangeQuery(cSQL)
	
	IF Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIF
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), cAliasA, .F., .T.)
		
	IF .NOT. Eof( cAliasA )
		A010Excel( cAliasA, aRet[5] )
	Else
		MsgAlert('A query não retornou registros, por favor verifique os parâmetros informados.', cCadastro)
	EndIF
	
Return


//+-------------------------------------------------------------------+
//| Rotina | A010Excel | Autor | Rafael Beghini | Data | 29.08.2016 
//+-------------------------------------------------------------------+
//| Descr. | Gera o arquivo XML conforme query realizada. 
//+-------------------------------------------------------------------+
//| Uso    | Genérico
//+-------------------------------------------------------------------+
Static Function A010Excel( cAliasA, cModelo )
	
	Local cWorkSheet := 'Oportunidades'
	Local cTable     := cCadastro
	Local cPath      := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile  := cPath + 'Oportunidades_' + dTos(Date()) + ".XML"
	Local aArea      := GetArea()
	Local aDADOS     := {}
	Local nPos       := 0
	Local cPicture   := "@E 999,999,999.99"
	Local aFEELING   := StrToKarr( Posicione( 'SX3', 2, 'AD1_FEELIN', 'X3CBox()' ), ';' )
	Local cGrpVen    := ""
	Local cCNAE      := ""
	Local cCnaeDesc  := ""
	Local cCnaeNAmig := ""
	Local cXCAMIG    := ""
	Local nUNeg1     := 0
	Local nUNeg2     := 0
	Local nUNeg3     := 0
	Local nUNeg4     := 0
	Local nUNeg5     := 0
	Local nUNeg6     := 0
	Local c01EXPEX   := GetMv("MV_01EXPEX",,"000049|000056|000044|000045|000041|000048|000042|000043")
	Local c02EXPEX   := GetMv("MV_02EXPEX",,"000050|000035")
	Local c03EXPEX   := GetMv("MV_03EXPEX",,"000051|000036")
	Local c04EXPEX   := GetMv("MV_04EXPEX",,"000052|000053|000037|000038")
	Local c05EXPEX   := GetMv("MV_05EXPEX",,"000054|000039")
	Local c06EXPEX   := GetMv("MV_06EXPEX",,"000055|000040")

	oExcel := FWMSEXCEL():New() //Método para geração em XML
	
	oExcel:AddworkSheet(cWorkSheet)		//-- Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable(cWorkSheet,cTable)	//-- Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	
	BuildModel(oExcel, cModelo, cWorkSheet, cTable)
	
	//nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada
	
	//-- Tabela CNAE
	//DbSelectArea("CC3")
	//CC3->(DbSetOrder(1))
	
	//-- Tabela generica.
	//DbSelectArea("SX5")
	//SX5->(DbSetOrder(1))
	
	//(cAliasA)->( dbGoTop() )
		
	//Para mostrar os itens preenchidos olhar a tabela RDY
	While !(cAliasA)->(EOF())
		
		nPos     := AScan( aFEELING, {|X| Left(X,1) == (cAliasA)->AD1_FEELIN  } )
		cFEELING := IIF( nPos > 0, rTrim( SubStr( aFEELING[nPos],3,Len(aFEELING[nPos]) ) ), '')
		
		cCNAE := ""		
		SA1->(DbSetOrder())
		If SA1->(MsSeek(xFilial("SA1")+(cAliasA)->CLIENTE))
			cGrpVen := Posicione("ACY", 1, xFilial("ACY") + SA1->A1_GRPVEN, "ACY_DESCRI")
			cCNAE   := AllTrim(SA1->A1_CNAE)
		EndIf

		//-- Inclusão da descrição amigavel CNAE.
		cCnaeDesc  := ""
		cCnaeNAmig := ""
		If !Empty(cCNAE)
			cCnaeDesc  := AllTrim(Posicione("CC3",1,xFilial( "CC3" ) + cCNAE,"CC3->CC3_DESC"))
			cXCAMIG    := AllTrim(Posicione("CC3",1,xFilial( "CC3" ) + cCNAE,"CC3->CC3_XCAMIG"))
			cCnaeNAmig := AllTrim(Posicione("SX5",1,xFilial( "SX5" ) + 'ZX' + cXCAMIG ,"SX5->X5_DESCRI"))
		EndIf
		
		IF Empty( (cAliasA)->PROSPECT )
			cNOME := rTrim( Posicione("SA1",1,xFilial('SA1') + (cAliasA)->CLIENTE ,"A1_NOME") )
		Else
			cNOME := rTrim( Posicione("SUS",1,xFilial('SUS') + (cAliasA)->PROSPECT,"US_NOME") )
		EndIF
		
		If cModelo == 1 //-> Modelo 1

			//-- Dados impressos no relatório.
			aDADOS := {	(cAliasA)->AD1_VEND,;																	//-- ID Vendedor
						(cAliasA)->A3_NOME,;																	//-- Nome do Vendedor
						(cAliasA)->AD1_NROPOR,;																	//-- Núm. Oportunidade
						cNOME,;																					//-- Nome do Cliente
						(cAliasA)->AD1_DESCRI,;																	//-- Descrição Oportunidade
						sToD( (cAliasA)->AD1_DTINI ),;															//-- DT.Início
						IIF(Empty((cAliasA)->AD1_DTPFIM),(cAliasA)->AD1_DTPFIM,sToD((cAliasA)->AD1_DTPFIM)),;	//-- DT. Prev. Fechamento
						cFEELING,;																				//-- Feeling
						(cAliasA)->ZE_MES,;																		//-- Mês do Forecast
						(cAliasA)->ZE_ANO,;																		//-- Ano do Forecast
						(cAliasA)->AD1_STAGE,;																	//-- Cód. Estágio
						(cAliasA)->AC2_PPLINE,;																	//-- Desc. Estágio
						(cAliasA)->ZE_VALOR,;																	//-- Exp. Receita (Forecast)
						(cAliasA)->AD1_VERBA,;																	//-- Valor da Oportunidade
						(cAliasA)->DESC_FCS,;																	//-- Fator de Sucesso
						(cAliasA)->DESC_FCI,;																	//-- Fator de Perda
						(cAliasA)->DESC_PRO,;																	//-- Produto Principal
						cGrpVen,;																				//-- Grupo de Venda
						(cAliasA)->DESC_CAMPAN,;																//-- Nome da Campanha
						cCNAE,;																					//-- CNAE
						cCnaeDesc,;																				//-- Denominação
						cCnaeNAmig,;																			//-- Vertical (Descrição Amigável CNAE)
						(cAliasA)->CANAL }																		//-- Canal																
	
		ElseIf cModelo == 2 //-> Modelo 2

			nUneg1 := 0
			nUneg2 := 0
			nUneg3 := 0
			nUneg4 := 0
			nUneg5 := 0
			nUneg6 := 0

			dbSelectArea("ADJ")
			ADJ->(dbSetOrder(1))

			//-> Percorre os produtos da oportunidade para somar o valor total de cada produto.
			If ADJ->(dbSeek( xFilial("ADJ") + (cAliasA)->AD1_NROPOR ))
			
				While ADJ->(!Eof()) .And. ADJ->ADJ_NROPOR == (cAliasA)->AD1_NROPOR
					
					dbSelectArea("ACV")
					ACV->(dbSetOrder(5))
					
					If ACV->(dbSeek( xFilial("ACV") + ADJ->ADJ_PROD ))
						If ACV->ACV_CATEGO $ c01EXPEX		//-> CERT ICP.
							nUneg1 += ADJ->ADJ_VALOR
						ElseIf ACV->ACV_CATEGO $ c02EXPEX	//-> PDI.
							nUneg2 += ADJ->ADJ_VALOR
						ElseIf ACV->ACV_CATEGO $ c03EXPEX	//-> PDA.
							nUneg3 += ADJ->ADJ_VALOR
						ElseIf ACV->ACV_CATEGO $ c04EXPEX	//-> CERT BIO.
							nUneg4 += ADJ->ADJ_VALOR
						ElseIf ACV->ACV_CATEGO $ c05EXPEX	//-> SELO CRONOLOGICO.
							nUneg5 += ADJ->ADJ_VALOR
						ElseIf ACV->ACV_CATEGO $ c06EXPEX	//-> SSL TERCEIROS.
							nUneg6 += ADJ->ADJ_VALOR
						EndIf	
					EndIf

					ADJ->(dbSkip())

				EndDo

			EndIf
			
			//-- Dados impressos no relatório.
			aDADOS := {	(cAliasA)->AD1_VEND,;																							//-> 01
						(cAliasA)->A3_NOME,;																							//-> 02
						cNOME,;																											//-> 03
						(cAliasA)->AD1_DESCRI,;																							//-> 04
						(cAliasA)->AD1_NROPOR,;																							//-> 05
						cFEELING,;																										//-> 06
						(cAliasA)->AD1_STAGE,;																							//-> 07
						(cAliasA)->AC2_PPLINE,;																							//-> 08
						IIF( Empty((cAliasA)->AD1_DTPFIM),(cAliasA)->AD1_DTPFIM,sToD( (cAliasA)->AD1_DTPFIM ) ),;						//-> 09
						(cAliasA)->AD1_VERBA,;																							//-> 10
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '01' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 11
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '02' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 12
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '03' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 13
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '04' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 14
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '05' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 15
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '06' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 16
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '07' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 17
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '08' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 18
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '09' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 19
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '10' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 20
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '11' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 21
						Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '12' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;	//-> 22
						0,;																												//-> 23
						0,;																												//-> 24
						0,;																												//-> 25
						0,;																												//-> 26
						0,;																												//-> 27
						SubStr(DtoS(Date()),1,4),;																						//-> 28
						MSMM( (cAliasA)->AD1_CODMEM ),;																					//-> 29
						(cAliasA)->DESC_PRO,;																							//-> 30
						(cAliasA)->DESC_FCS,;																							//-> 31
						(cAliasA)->DESC_FCI,;																							//-> 32
						(cAliasA)->DESC_CAMPAN,;																						//-> 33
						cCNAE,;																											//-> 34
						cCnaeDesc,;																										//-> 35
						cCnaeNAmig,;																									//-> 36
						(cAliasA)->CANAL,;																								//-> 37
						sToD( (cAliasA)->AD1_DTINI ),;																					//-> 38
						nUNeg1,;																										//-> 39
						nUNeg2,;																										//-> 40
						nUNeg3,;																										//-> 41
						nUNeg4,;																										//-> 42
						nUNeg5,;																										//-> 43
						nUNeg6,;																										//-> 44
						(cAliasA)->AD1_VERBA}																							//-> 45
			
			aDados[29] := StrTran(aDados[29],">","")
			aDados[29] := StrTran(aDados[29],"<","")
			aDados[29] := StrTran(aDados[29],"[","")
			aDados[29] := StrTran(aDados[29],"]","")			
			
			//-> Totaliza o valor dos meses de forecast.
			aDados[23] := aDados[11] + aDados[12] + aDados[13] + aDados[14] + aDados[15] + aDados[16] + aDados[17] + aDados[18] + aDados[19] + aDados[20] + aDados[21] + aDados[22]
			
			//-> Total por Trimestre.
			aDados[24] := aDados[11] + aDados[12] + aDados[13]
			aDados[25] := aDados[14] + aDados[15] + aDados[16]
			aDados[26] := aDados[17] + aDados[18] + aDados[19]
			aDados[27] := aDados[20] + aDados[21] + aDados[22]
	
		EndIf
					  
		oExcel:AddRow( cWorkSheet, cTable, aDADOS )
		(cAliasA)->( dbSkip() )
	End
	
	(cAliasA)->( dbCloseArea() )
	
	IF File( cNameFile )
		Ferase( cNameFile )
	EndIF		
	
	Sleep(500)
		
	oExcel:Activate()              //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório
	
	IF ! ApOleClient("MsExcel") 
		MsgAlert("MsExcel não instalado. Para abrir o arquivo, localize-o na pasta %temp% .",cCadastro)
	Else
		ShellExecute( "Open", cNameFile , '', '', 1 ) //Abre o arquivo na tela após salvar
	EndIF
	RestArea(aArea)
	
Return



Static Function BuildModel( oExcel, cModel, cWorkSheet, cTable )
	
	If cModel == 1 //-> Modelo 1
		
		//Adiciona uma coluna a tabela de uma Worksheet.
		//     AddColumn( cWorkSheet, cTable, < cColumn >              	, nAlign, nFormat, lTotal)
		oExcel:AddColumn( cWorkSheet, cTable, "ID Vendedor"            	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Nome do Vendedor"       	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Núm. Oportunidade"      	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Nome do Cliente"        	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Descrição Oportunidade" 	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "DT.Início"              	, 1 	, 4      , .F. ) 
		oExcel:AddColumn( cWorkSheet, cTable, "DT. Prev. Fechamento"   	, 1 	, 4      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Feeling"                	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Mês do Forecast"         , 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Ano do Forecast"         , 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Cód. Estágio"            , 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Desc. Estágio"           , 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Exp. Receita (Forecast)"	, 1 	, 3      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Valor da Oportunidade" 	, 1 	, 3      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Fator de Sucesso"      	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Fator de Perda"        	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Produto Principal"     	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Grupo de Venda"        	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Nome da Campanha"      	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "CNAE"                  	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Denominação"           	, 1 	, 1      , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, STREXP001               	, 1 	, 1      , .F. ) //-- "Vertical (Descrição Amigável CNAE)"
		oExcel:AddColumn( cWorkSheet, cTable, "Canal"                 	, 1 	, 1      , .F. )
	
	ElseIf cModel == 2 //-> Modelo 2
		
		//Adiciona uma coluna a tabela de uma Worksheet.
		//     AddColumn( cWorkSheet, cTable, < cColumn >              	, nAlign, nFormat, lTotal)
		oExcel:AddColumn( cWorkSheet, cTable, "ID Vendedor"            	, 1 	, 1      , .F. )	//-> 01 (cAliasA)->AD1_VEND,;
		oExcel:AddColumn( cWorkSheet, cTable, "Nome do Vendedor"       	, 1 	, 1      , .F. )	//-> 02 (cAliasA)->A3_NOME,;
		oExcel:AddColumn( cWorkSheet, cTable, "Nome do Cliente"        	, 1 	, 1      , .F. )	//-> 03 cNOME,;
		oExcel:AddColumn( cWorkSheet, cTable, "Descrição Oportunidade" 	, 1 	, 1      , .F. )	//-> 04 (cAliasA)->AD1_DESCRI,;
		oExcel:AddColumn( cWorkSheet, cTable, "Núm. Oportunidade"      	, 1 	, 1      , .F. )	//-> 05 (cAliasA)->AD1_NROPOR,;
		oExcel:AddColumn( cWorkSheet, cTable, "Feeling"                	, 1 	, 1      , .F. )	//-> 06 cFEELING,;
		oExcel:AddColumn( cWorkSheet, cTable, "Cód. Estágio"    		, 1 	, 1      , .F. )	//-> 07 (cAliasA)->AD1_STAGE,;
		oExcel:AddColumn( cWorkSheet, cTable, "Desc. Estágio"   		, 1 	, 1      , .F. )	//-> 08 (cAliasA)->AC2_PPLINE,;
		oExcel:AddColumn( cWorkSheet, cTable, "DT. Prev. Fechamento"   	, 1 	, 4      , .F. )	//-> 09 IIF( Empty((cAliasA)->AD1_DTPFIM),(cAliasA)->AD1_DTPFIM,sToD( (cAliasA)->AD1_DTPFIM ) ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Valor da Oportunidade" 	, 1 	, 3      , .F. )	//-> 10 (cAliasA)->AD1_VERBA,;
		oExcel:AddColumn( cWorkSheet, cTable, "Janeiro"         		, 1 	, 3      , .F. )	//-> 11 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '01' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Fevereiro"      	 		, 1 	, 3      , .F. )	//-> 12 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '02' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Março"           		, 1 	, 3      , .F. )	//-> 13 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '03' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Abril"          	 		, 1 	, 3      , .F. )	//-> 14 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '04' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Maio"            		, 1 	, 3      , .F. )	//-> 15 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '05' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Junho"           		, 1 	, 3      , .F. )	//-> 16 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '06' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Julho"           		, 1 	, 3      , .F. )	//-> 17 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '07' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Agosto"          		, 1 	, 3      , .F. )	//-> 18 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '08' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Setembro"        		, 1 	, 3      , .F. )	//-> 19 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '09' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Outubro"         		, 1 	, 3      , .F. )	//-> 20 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '10' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Novembro"        		, 1 	, 3      , .F. )	//-> 21 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '11' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Dezembro"        		, 1 	, 3      , .F. )	//-> 22 Posicione( "SZE" ,1 ,xFilial("SZE") + (cAliasA)->AD1_NROPOR + '12' + SubStr(DtoS(Date()),1,4) ,"ZE_VALOR" ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Total Forecast"  		, 1 	, 3      , .F. )	//-> 23 0,;
		oExcel:AddColumn( cWorkSheet, cTable, "Total Q1"  				, 1 	, 3      , .F. )	//-> 24 0,;
		oExcel:AddColumn( cWorkSheet, cTable, "Total Q2"  				, 1 	, 3      , .F. )	//-> 25 0,;
		oExcel:AddColumn( cWorkSheet, cTable, "Total Q3"  				, 1 	, 3      , .F. )	//-> 26 0,;
		oExcel:AddColumn( cWorkSheet, cTable, "Total Q4"  				, 1 	, 3      , .F. )	//-> 27 0,;
		oExcel:AddColumn( cWorkSheet, cTable, "Ano do Forecast" 		, 1 	, 1      , .F. )	//-> 28 SubStr(DtoS(Date()),1,4),;
		oExcel:AddColumn( cWorkSheet, cTable, "Nota"                 	, 1 	, 1      , .F. )	//-> 29 MSMM( (cAliasA)->AD1_CODMEM ),;
		oExcel:AddColumn( cWorkSheet, cTable, "Produto Principal"     	, 1 	, 1      , .F. )	//-> 30 (cAliasA)->DESC_PRO,;
		oExcel:AddColumn( cWorkSheet, cTable, "Fator de Sucesso"      	, 1 	, 1      , .F. )	//-> 31 (cAliasA)->DESC_FCS,;
		oExcel:AddColumn( cWorkSheet, cTable, "Fator de Perda"        	, 1 	, 1      , .F. )	//-> 32 (cAliasA)->DESC_FCI,;
		oExcel:AddColumn( cWorkSheet, cTable, "Nome da Campanha"      	, 1 	, 1      , .F. )	//-> 33 (cAliasA)->DESC_CAMPAN,;
		oExcel:AddColumn( cWorkSheet, cTable, "CNAE"                  	, 1 	, 1      , .F. )	//-> 34 cCNAE,;
		oExcel:AddColumn( cWorkSheet, cTable, "Denominação"           	, 1 	, 1      , .F. )	//-> 35 cCnaeDesc,;
		oExcel:AddColumn( cWorkSheet, cTable, STREXP001               	, 1 	, 1      , .F. )	//-> 36 cCnaeNAmig,;
		oExcel:AddColumn( cWorkSheet, cTable, "Canal"                 	, 1 	, 1      , .F. )	//-> 37 (cAliasA)->CANAL,;
		oExcel:AddColumn( cWorkSheet, cTable, "DT.Início"              	, 1 	, 4      , .F. )	//-> 38 sToD( (cAliasA)->AD1_DTINI ),;
		oExcel:AddColumn( cWorkSheet, cTable, "CERT ICP"				, 1 	, 3      , .F. )	//-> 39 nUNeg1,;
		oExcel:AddColumn( cWorkSheet, cTable, "PDI"						, 1 	, 3      , .F. )	//-> 40 nUNeg2,;
		oExcel:AddColumn( cWorkSheet, cTable, "PDA"						, 1 	, 3      , .F. )	//-> 41 nUNeg3,;
		oExcel:AddColumn( cWorkSheet, cTable, "CERT BIO"				, 1 	, 3      , .F. )	//-> 42 nUNeg4,;
		oExcel:AddColumn( cWorkSheet, cTable, "SELO CRONOLOGICO"		, 1 	, 3      , .F. )	//-> 43 nUNeg5,;
		oExcel:AddColumn( cWorkSheet, cTable, "SSL TERCEIROS"			, 1 	, 3      , .F. )	//-> 44 nUNeg6,;
		oExcel:AddColumn( cWorkSheet, cTable, "Valor da Oportunidade" 	, 1 	, 3      , .F. )	//-> 45 (cAliasA)->AD1_VERBA}

	EndIf
	
Return()


//-----------------------------------------------------------------------
// Rotina | A010ShowQry | Autor | Rafael Beghini    | Data | 29.08.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar o script de instrução SQL na tela.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A010ShowQry( cSQL )
	
	Local cNomeArq := ''
	Local nHandle  := 0
	Local lEmpty   := .F.
	
	AutoGrLog('Ativar para apagar')
	cNomeArq := NomeAutoLog()
	lEmpty   := Empty( cNomeArq )
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