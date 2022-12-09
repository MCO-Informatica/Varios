//--------------------------------------------------------------------------
// Rotina | CSFA770    | Autor | Robson Gon�alves        | Data | 29.11.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para extrair dados do t�tulo a pagar e forma de pagamento
//        | do pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA770()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private cCadastro := 'T�tulo a pagar X forma de pagto.'
	
	AAdd( aSay, 'Esta rotina tem por objetivo em extrair os t�tulos a pagar e a forma de pagamento' )
	AAdd( aSay, 'indicada nacapa de despesa do pedido de compras.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
   
	If nOpcao==1
		A770Param()
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A770Param | Autor | Robson Gon�alves         | Data | 29.11.2016
//--------------------------------------------------------------------------
// Descr. | Rotina de par�metros para processamento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A770Param()
	Local aParamBox := {}
	Local aPergRet := {}
	Local aImpostos := {"N�o","Sim"}
	
	AAdd(aParamBox,{1,"Vencto. Real de" ,Ctod(Space(8)),"","","","",50,.T.})//1
	AAdd(aParamBox,{1,"Vencto. Real at�",Ctod(Space(8)),"","","","",50,.T.})//2
	AAdd(aParamBox,{2,"Imprimir impostos" ,1,aImpostos,50,"",.F.})//3
	AAdd(aParamBox,{1,"Centro de custo de" ,Space(9),"","","CTT","",50,.F.})//4
	AAdd(aParamBox,{1,"Centro de custo at�",Space(9),"","","CTT","",50,.T.})//5
	AAdd(aParamBox,{1,"Natureza de" ,Space(10),"","","SED","",50,.F.})//6
	AAdd(aParamBox,{1,"Natureza at�",Space(10),"","","SED","",50,.T.})//7

	If ParamBox(aParamBox,'Par�metros',aPergRet,,,,,,,,.T.,.T.)
		MsAguarde( {|| A770Proc( aPergRet ) }, cCadastro, 'In�cio do processo, aguarde...', .F. )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A770Proc | Autor | Robson Gon�alves          | Data | 29.11.2016
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A770Proc( aRet )
	Local aPoint := {"/","-","|","-","\","|"}
	
	Local cDir := ''
	Local cDirTmp := ''
	Local cFile := ''
	Local cSQL := ''
	Local cTable := 'Follow-up T�tulos a Pagar'
	Local cTRB := GetNextAlias()
	Local cWorkSheet := 'T�tulos'
	
	Local lImpostos := Iif( ValType( aRet[ 3 ] ) == 'N', aRet[ 3 ], AScan( {"N�o","Sim"}, {|e| e==aRet[ 3 ] } ) )==2
	Local lSC7 := .F.
	
	Local nPoint := 0
	Local nSaldo := 0
	
	Local oExcelApp
	Local oFwMsEx
	
   MsProcTxt( 'Buscando os dados para in�cio do processamento...'  )
   ProcessMessage()

	cSQL := "SELECT distinct "
	cSQL += " 		E2_FORNECE,"
	cSQL += "       A2_NOME,"
	cSQL += "       A2_CGC,"
	cSQL += "       E2_PREFIXO,"
	cSQL += "       E2_NUM,"
	cSQL += "       E2_PARCELA,"
	cSQL += "       E2_TIPO,"
	cSQL += "       E2_NATUREZ,"
	cSQL += "       ED_DESCRIC,"
	cSQL += "       E2_CCD,"
	cSQL += "       CTT_DESC01,"
	cSQL += "       E2_EMISSAO,"
	cSQL += "       E2_VENCTO,"
	cSQL += "       E2_VENCREA,"
	cSQL += "       E2_VALOR,"
If lImpostos
	cSQL += "       E2_PIS,"
	cSQL += "       E2_CSLL,"
	cSQL += "       E2_COFINS,"
	cSQL += "       E2_IRRF,"
	cSQL += "       E2_ISS,"
	cSQL += "       E2_INSS,"
Endif
	cSQL += "       E2_SALDO,"
	cSQL += "       E2_NUMBOR,"
	cSQL += "       A2_BANCO,"
	cSQL += "       A2_AGENCIA,"
	cSQL += "       A2_DVAGEN,"
	cSQL += "       A2_NUMCON,"
	cSQL += "       A2_DGCTAC,"
	cSQL += "       C7_FORMPG, "
	cSQL += "       SE2.R_E_C_N_O_ AS E2_RECNO "
	cSQL += "FROM   "+RetSqlName("SE2")+" SE2 "
	cSQL += "       INNER JOIN "+RetSqlName("SA2")+" SA2 "
	cSQL += "               ON A2_COD = E2_FORNECE "
	cSQL += "              AND A2_LOJA = E2_LOJA "
	cSQL += "              AND SA2.D_E_L_E_T_ = ' ' "
	cSQL += "INNER JOIN "+RetSqlName("CTT")+" CTT "
	cSQL += "        ON CTT_FILIAL = "+ValToSql(xFilial("CTT"))+" "
	cSQL += "           AND CTT_CUSTO = E2_CCD "
	cSQL += "           AND CTT.D_E_L_E_T_ = ' ' "
	cSQL += "INNER JOIN "+RetSqlName("SED")+" SED "
	cSQL += "        ON ED_FILIAL = "+ValToSql(xFilial("SED"))+" "
	cSQL += "           AND ED_CODIGO = E2_NATUREZ "
	cSQL += "           AND SED.D_E_L_E_T_ = ' ' "
	cSQL += " LEFT  JOIN "+RetSqlName("SD1")+" D1    ON D1_FORNECE = E2_FORNECE AND D1_LOJA = E2_LOJA  AND D1_DOC = E2_NUM AND D1.D_E_L_E_T_ = ' ' " 
	cSQL += " LEFT  JOIN "+RetSqlName("Sc7")+" Sc7    ON C7_FILIAL = D1_FILIAL AND C7_NUM = D1_PEDIDO AND SC7.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  E2_FILIAL = "+ValToSql(xFilial("SE2"))+" "
	cSQL += "       AND E2_VENCREA >= "+ValToSql(aRet[1])+" "
	cSQL += "       AND E2_VENCREA <= "+ValToSql(aRet[2])+" "
	cSQL += "       AND E2_CCD >= "+ValToSql(aRet[4])+" "
	cSQL += "       AND E2_CCD <= "+ValToSql(aRet[5])+" "
	cSQL += "       AND E2_NATUREZ >= "+ValToSql(aRet[6])+" "
	cSQL += "       AND E2_NATUREZ <= "+ValToSql(aRet[7])+" "
	cSQL += "       AND SE2.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY E2_VENCREA, "
	cSQL += "          A2_NOME "
	
	 MEMOWRITE("C:\Protheus\TESTE.sql",cSQL)
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.T.,.T.)
	
	If (cTRB)->( .NOT. BOF() ) .AND. (cTRB)->( .NOT. EOF() )
		cFile := CriaTrab(NIL,.F.)+'.xml'
		
		oFwMsEx := FWMsExcel():New()
	   oFwMsEx:AddWorkSheet( cWorkSheet )
	   oFwMsEx:AddTable( cWorkSheet, cTable )	
	   
		// M�todo: AddColumn
		// Sintaxe: FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)-> NIL
		// Descri��o: Adiciona uma coluna a tabela de uma Worksheet.
		// Par�metros:
		
		// cWorkSheet -> Nome da planilha
		// cTable -----> T�tulo da tabela
		// cColumn ----> Titulo da tabela que ser� adicionada
		
		// nAlign -----> Alinhamento da coluna ( 1-Left,2-Center,3-Right )
		// nFormat ----> Codigo de formata��o ( 1-General,2-Number,3-Monet�rio,4-DateTime )
		
		// lTotal -----> Indica se a coluna deve ser totalizada
		
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Status"                ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "C�digo"                ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Raz�o Social"          ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "CNPJ/CPF"              ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Prefixo"               ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "T�tulo"                ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Parcela"               ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Tipo"                  ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Natureza"              ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Descr.Natureza"        ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "C.Custo Debito"        ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Descr.C.Custo Deb."    ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Emiss�o"               ,2,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Vencimento"            ,2,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Vencimento Real"       ,2,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Valor bruto"           ,3,2)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Valor l�quido"         ,3,2)
		If lImpostos
			oFwMsEx:AddColumn( cWorkSheet, cTable , "PIS"                   ,3,2)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "CSLL"                  ,3,2)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "COFINS"                ,3,2)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "IRRF"                  ,3,2)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "ISS"                   ,3,2)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "INSS"                  ,3,2)
		Endif
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Saldo"                 ,3,2)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Border�"               ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Banco"                 ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Ag�ncia"               ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "C/C"                   ,1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Forma Pg. Capa Desp."  ,1,1)
		
		SE1->( dbSetOrder( 1 ) )
		SF1->( dbSetOrder( 2 ) )
		SD1->( dbSetOrder( 1 ) )
		SC7->( dbSetOrder( 1 ) )
		
		While (cTRB)->( .NOT. EOF() )
			nPoint++
			If nPoint == 7
				nPoint := 1
			Endif
			
			SE2->( dbSeek( xFilial( 'SE2' ) + (cTRB)->E2_PREFIXO + (cTRB)->E2_NUM + (cTRB)->E2_PARCELA + (cTRB)->E2_TIPO + (cTRB)->E2_FORNECE ) )
			nSaldo := SE2->( SaldoTit(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,"P",E2_FORNECE,1) )
			
	//		SF1->( dbSeek( xFilial( 'SF1' ) + (cTRB)->E2_FORNECE + SE2->E2_LOJA + (cTRB)->E2_NUM ) )
	//		SD1->( dbSeek( xFilial( 'SD1' ) + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )
	//		lSC7 := SC7->( dbSeek( xFilial( 'SC7' ) + SD1->D1_PEDIDO ) )
			
		   MsProcTxt( 'Aguarde, lendo registros [ ' + aPoint[ nPoint ] + ' ]'  )
		   ProcessMessage()

			If lImpostos
				oFwMsEx:AddRow( cWorkSheet, cTable, {;  
				Iif(nSaldo==0,'Baixado',Iif(nSaldo==(cTRB)->E2_VALOR,'Em aberto','Parcialmente baixado')),;
				(cTRB)->E2_FORNECE,;
				(cTRB)->A2_NOME,;
				TransForm((cTRB)->A2_CGC,Iif(Len(RTrim((cTRB)->A2_CGC))==14,'@R 99.999.999/9999-99','@R 999.999.999-99')),;
				(cTRB)->E2_PREFIXO,;
				(cTRB)->E2_NUM,;
				(cTRB)->E2_PARCELA,;
				(cTRB)->E2_TIPO,;
				(cTRB)->E2_NATUREZ,;
				(cTRB)->ED_DESCRIC,;
				(cTRB)->E2_CCD,;
				(cTRB)->CTT_DESC01,;
				Stod((cTRB)->E2_EMISSAO),;
				Stod((cTRB)->E2_VENCTO),;
				Stod((cTRB)->E2_VENCREA),;
				(cTRB)->E2_VALOR,;
				nSaldo,;
				(cTRB)->E2_PIS,;
				(cTRB)->E2_CSLL,;
				(cTRB)->E2_COFINS,;
				(cTRB)->E2_IRRF,;
				(cTRB)->E2_ISS,;
				(cTRB)->E2_INSS,;
				(cTRB)->E2_SALDO,;
				(cTRB)->E2_NUMBOR,;
				(cTRB)->A2_BANCO,;
				(cTRB)->A2_AGENCIA+'-'+(cTRB)->A2_DVAGEN,;
				(cTRB)->A2_NUMCON+'-'+(cTRB)->A2_DGCTAC,;
				(cTRB)->C7_FORMPG} )
				
			Else
				oFwMsEx:AddRow( cWorkSheet, cTable, {;  
				Iif(nSaldo==0,'Baixado',Iif(nSaldo==(cTRB)->E2_VALOR,'Em aberto','Parcialmente baixado')),;
				(cTRB)->E2_FORNECE,;
				(cTRB)->A2_NOME,;
				TransForm((cTRB)->A2_CGC,Iif(Len(RTrim((cTRB)->A2_CGC))==14,'@R 99.999.999/9999-99','@R 999.999.999-99')),;
				(cTRB)->E2_PREFIXO,;
				(cTRB)->E2_NUM,;
				(cTRB)->E2_PARCELA,;
				(cTRB)->E2_TIPO,;
				(cTRB)->E2_NATUREZ,;
				(cTRB)->ED_DESCRIC,;
				(cTRB)->E2_CCD,;
				(cTRB)->CTT_DESC01,;
				Stod((cTRB)->E2_EMISSAO),;
				Stod((cTRB)->E2_VENCTO),;
				Stod((cTRB)->E2_VENCREA),;
				(cTRB)->E2_VALOR,;
				nSaldo,;
				(cTRB)->E2_SALDO,;
				(cTRB)->E2_NUMBOR,;
				(cTRB)->A2_BANCO,;
				(cTRB)->A2_AGENCIA+'-'+(cTRB)->A2_DVAGEN,;
				(cTRB)->A2_NUMCON+'-'+(cTRB)->A2_DGCTAC,;
				(cTRB)->C7_FORMPG} )
			Endif
			(cTRB)->( dbSkip() )
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
			MsgInfo( "N�o foi poss�vel copiar o arquivo para o diret�rio tempor�rio do usu�rio." )
		Endif
	Else
		MsgAlert('N�o h� dados com os par�metros informados.',cCadastro)
	Endif
Return