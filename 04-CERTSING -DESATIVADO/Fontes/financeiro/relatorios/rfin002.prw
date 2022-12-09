#Include "Protheus.ch"
#Include "Rwmake.ch"
Static nREGISTROS := 0
//+----------------------------------------------------------------------+
//| Rotina | RFIN002    | Autor | Rafael Beghini     | Data | 21/12/2015 |
//+--------+------------+-------+--------------------+------+------------+
//| Descr. | Relatório de Faturamento                                    |
//+--------+-------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital                             |
//+--------+-------------------------------------------------------------+
User Function RFIN002()
	Private cCadastro := "Relatório de Faturamento - CertiSign"
	Private cPerg     := "RFIN002"
	Private nOpc      := 0
	Private aSay      := {}
	Private aButton   := {}

	AjustaSX1()
	
	Pergunte( cPerg, .F. )
	
	aAdd( aSay, "Esta rotina irá imprimir o relatorio de faturamento conforme parâmetros")
	aAdd( aSay, "informados pelo usuário." )
	aAdd( aSay, "")
	aAdd( aSay, "Ao final do processamento, é gerado uma planilha com as informações.")
	
	Aadd( aButton, { 5,.T.,{|| Pergunte(cPerg, .T. ) } } )
	aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpc == 1
		Conout( "[ RFIN002 - " + Dtoc( Date() ) + " - " + Time() + " ] INICIO" )
		A010Proc()
		Conout( "[ RFIN002 - " + Dtoc( Date() ) + " - " + Time() + " ] FINAL" )
	Endif

Return

//+-------------------------------------------------------------------+
//| Rotina | A010Proc | Autor | Rafael Beghini | Data | 21.09.2018 
//+-------------------------------------------------------------------+
//| Descr. | Apresenta a tela de processamento
//+-------------------------------------------------------------------+
Static Function A010Proc()
    Local oDlg   := Nil
    Local oSay   := Nil
    Local oMeter := Nil
    Local nMeter := 0

	Private cTRB := ''

    Define Dialog oDlg Title cCadastro From 0,0 To 70,380 Pixel
        @05,05  Say oSay Prompt "Aguarde, montando a query conforme parâmetros informados." Of oDlg Pixel Colors CLR_RED,CLR_WHITE Size 185,20
        @15,05  Meter oMeter Var nMeter Pixel Size 160,10 Of oDlg
        @13,170 BITMAP Resource "PCOIMG32.PNG" SIZE 015,015 OF oDlg NOBORDER PIXEL
    Activate Dialog oDlg Centered On Init ( IIF( MontaQry(), RunReport(oDlg, oSay, oMeter), NIL ), oDlg:End() )
    
Return

//+--------+----------+-------+--------------------+------+-------------+
//| Rotina | MontaQry | Autor | Rafael Beghini     | Data | 21/12/2015  |
//+--------+----------+-------+--------------------+------+-------------+
//| Descr. | Executa query para processamento                           |
//+--------+------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital                            |
//+--------+------------------------------------------------------------+
Static Function MontaQry()
	
	Local cSQL		:= ''
	Local cCount	:= ''
	Local lRet		:= .T.
	
	cSQL += "SELECT DISTINCT " + CRLF
	cSQL += "		SF2.R_E_C_N_O_ AS F2RECNO, " + CRLF
	cSQL += "       SE1.E1_VENCREA, " + CRLF
	cSQL += "       SE1.E1_SALDO " + CRLF
	cSQL += "FROM   " + RetSqlName("SF2") + " SF2 " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SD2") + " SD2 " + CRLF
	cSQL += "               ON SD2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND D2_FILIAL = F2_FILIAL " + CRLF
	cSQL += "                  AND D2_DOC = F2_DOC " + CRLF
	cSQL += "                  AND D2_SERIE = F2_SERIE " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SE1") + " SE1 " + CRLF
	cSQL += "               ON SE1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND E1_FILIAL = '" + xFilial("SE1") + "' " + CRLF
	/*IF xFilial('SF2') == '01' //--Filtrar notas do RJ
		cSQL += "                  AND E1_PREFIXO = 'RJ' || SUBSTR(F2_SERIE, 1, 1)" + CRLF
	Else
		cSQL += "                  AND E1_PREFIXO = 'SP' || SUBSTR(F2_SERIE, 1, 1)" + CRLF
	EndIF
	*/
	cSQL += "                  AND E1_NUM = F2_DOC " + CRLF
	cSQL += "                  AND E1_PEDIDO = D2_PEDIDO " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SC6") + " SC6 " + CRLF
	cSQL += "               ON SC6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "                  AND C6_NUM = D2_PEDIDO " + CRLF
	cSQL += "                  AND C6_ITEM = D2_ITEMPV " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SC5") + " SC5 " + CRLF
	cSQL += "               ON SC5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND C5_FILIAL = C6_FILIAL " + CRLF
	cSQL += "                  AND C5_NUM = C6_NUM " + CRLF
	cSQL += "                  AND C5_CHVBPAG = ' ' " + CRLF
	cSQL += "WHERE  SF2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND F2_EMISSAO >= '" + dTos(Mv_par01) + "'" + CRLF
	cSQL += "       AND F2_EMISSAO <= '" + dTos(Mv_par02) + "'" + CRLF
	cSQL += "       AND F2_VEND1 <> 'VA0001'" + CRLF
	cSQL += "       AND F2_CLIENTE >= '" + Mv_par06 + "'" + CRLF
	cSQL += "       AND F2_CLIENTE <= '" + Mv_par07 + "'" + CRLF

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )

	cCount := ' SELECT COUNT(*) COUNT FROM ( ' + cSQL + ' ) QUERY '
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCount),cTRB,.F.,.T.)
	nREGISTROS := (cTRB)->COUNT
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	cTRB := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
	
	TcSetField( cTRB, "E1_SALDO"	, "N", 15, 2 )
	TcSetField( cTRB, "E1_VENCREA"	, "D", 8 )

	IF (cTRB)->( EOF() )
        lRet := .F.    
        (cTRB)->( dbCloseArea() )
	    FErase( cTRB + GetDBExtension() )
        MsgInfo('Não há dados para extração conforme parâmetros informados.',cCadastro)
    EndIF
Return( lRet )

//+--------+-----------+-------+--------------------+------+-------------+
//| Rotina | RunReport | Autor | Rafael Beghini     | Data | 21/12/2015  |
//+--------+-----------+-------+--------------------+------+-------------+
//| Descr. | Rotina processar o relatório.                               |
//+--------+-------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital                             |
//+--------+-------------------------------------------------------------+
Static Function RunReport(oDlg, oSay, oMeter)
	Local cPAGTO    := ''
	Local cTPCLIEN  := ''
	Local cTIPOCLI  := ''
	Local cCODIGO   := ''
	Local cLOJA     := ''
	Local cNOME     := '' 
	Local cCNPJ     := ''  
	Local cMAIL     := ''
	Local cUrl      := '' 
	Local cTipo     := ''	
	Local cMsgNota  := ''
	Local cChaveNFE	:= ''
	Local cVencRea	:= ''
	Local nHdl      := 0
	Local lRet      := .F.
	Local cPath     := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cDir      := Curdir()
	Local cNameFile := 'RelFaturamento_' + dTos(Mv_par01) + '_a_' + dTos(Mv_par02) + '.CSV'
	Local cDado     := ''
	Local cCabec    := "DT_FATURAMENTO" + ';' + "COD_CLIENTE" + ';' + "NOME" + ';' + "CNPJ/CPF" + ';' + "EMAIL" + ';' +; 
	                   "DESCRICAO" + ';' + "QTDVEN"+ ';' + "VALOR" + ';' + "NUM_PEDIDO" + ';' + "NATUREZA" + ';' + "NOTAFISCAL" + ';' +;
					   "FORMA_PAGTO" + ';' + "COND_PAGTO" + ';' + "MSG_NOTA" + ';' + "VENCIMENTO" + ';' +; 
					   "NOTA_DE_SERVICO" + ';' + "SEFAZ" + ';' 
	Local nSeconds    := 0
    Local nCount      := 0
    Local nLastUpdate := 0

	oMeter:SetTotal(nREGISTROS)
    nSeconds := Seconds()

    oSay:SetText("Aguarde, montando o relatório. Total de registro(s): " + AllTrim( Str(nREGISTROS) ) )
		
	IF File( cDir + cNameFile )
		Ferase( cDir + cNameFile)
	EndIF
	
	IF File( cPath + cNameFile )
		Ferase( cPath + cNameFile)
	EndIF
	
	nHdl := FCreate( cNameFile )
	FWrite( nHdl, cCabec + CRLF )
	
	SA1->( dbSetOrder(1) )
	SA2->( dbSetOrder(1) )
	SF2->( DbSetOrder(1) )
	
	(cTRB)->( dbGotop() )
	While .NOT. (cTRB)->( EOF() )
		nCount++
		IF (Seconds() - nLastUpdate) > 1 // Se passou 1 segundo desde a última atualização da tela
			oMeter:Set(nCount)
			oDlg:CommitControls() // Para atualizar a tela e o usuário receber o feedback

			nLastUpdate := Seconds()
		EndIf

		SF2->( DbGoto( (cTRB)->F2RECNO ) )
						
		SC6->( DbSetOrder(4) )	//C6_FILIAL+C6_NOTA+C6_SERIE
		SC6->( MsSeek( xFilial("SC6") + SF2->(F2_DOC + F2_SERIE) ) )
					
		SC5->( DbSetOrder(1) )	//C5_FILIAL+C5_NUM
		SC5->( MsSeek( xFilial("SC5") + SC6->C6_NUM ) )

		cCODIGO 	:= ''
		cLOJA   	:= ''
		cTIPOCLI	:= ''
		cNOME		:= ''
		cTPCLIEN 	:= ''
		cCNPJ    	:= ''
		cMAIL    	:= ''
		cTipo		:= ''
		cPAGTO		:= ''
		cMsgNota	:= ''
		cUrl 		:= ''
		cChaveNFE	:= ''
		cVencRea	:= ''

		cUrl 		:= "https://nfe.prefeitura.sp.gov.br/contribuinte/notaprint.aspx?inscricao=36414891&nf="+Alltrim(SF2->F2_NFELETR)+"&verificacao="+Alltrim(SF2->F2_CODNFE)
		cChaveNFE	:= Alltrim( SF2->F2_CHVNFE )

		IF cValToChar(MV_PAR03) == '1' //-- Filtra somente vencidos
			IF .NOT. ( 	( (cTRB)->E1_VENCREA >= Mv_par04 .And. (cTRB)->E1_VENCREA <= Mv_par05 ) .OR.; 
						( Mv_par04 >= (cTRB)->E1_VENCREA .And. Mv_par05 <= (cTRB)->E1_VENCREA ) ) //.And. (cTRB)->E1_SALDO > 0
				(cTRB)->(dbSkip())
				Loop
			EndIF
		EndIF
		
		cCODIGO := SF2->F2_CLIENTE
		cLOJA   := SF2->F2_LOJA
		
		cTIPOCLI   := Alltrim( SC5->C5_TIPO )
		If !( cTIPOCLI $ 'B/D' )
			//Cliente
			SA1->(MsSeek(xFilial('SA1')+cCODIGO+cLOJA))
			
			cNOME    := Alltrim( STRTRAN(SA1->A1_NOME, ';', '') )  	
			cTPCLIEN := SA1->A1_PESSOA 
			cCNPJ    := SA1->A1_CGC  
			cMAIL    := rTrim( SA1->A1_EMAIL )  
		Else
			//Fornecedor
			SA2->(MsSeek(xFilial('SA2')+cCODIGO+cLOJA))
			
			cNOME    := Alltrim( STRTRAN(SA2->A2_NOME, ';', '') ) 
			cTPCLIEN := SA2->A2_TIPO
			cCNPJ    := SA2->A2_CGC  
			cMAIL    := rTrim( SA2->A2_EMAIL ) 
		EndIf
		
		cTipo    := IIF( cTPCLIEN == "J", Transform( cCNPJ, '@R 99.999.999/9999-99'), Transform( cCNPJ, '@R 999.999.999-99') )
		cTPCLIEN := IIF( cTPCLIEN == "J", "PESSOA JURIDICA","PESSOA FISICA")
		
		IF SC5->C5_TIPMOV == " "    ; cPAGTO := " "
		ElseIF SC5->C5_TIPMOV $ "1" ; cPAGTO := "BOLETO"
		ElseIF SC5->C5_TIPMOV $ "2" ; cPAGTO := "CARTAO CREDITO"
		ElseIF SC5->C5_TIPMOV $ "3" ; cPAGTO := "CARTAO DEBITO"
		ElseIF SC5->C5_TIPMOV $ "4" ; cPAGTO := "DA BB"
		ElseIF SC5->C5_TIPMOV $ "5" ; cPAGTO := "DDA" 
		ElseIF SC5->C5_TIPMOV $ "6" ; cPAGTO := "VOUCHER"
		ElseIF SC5->C5_TIPMOV $ "7" ; cPAGTO := "DA ITAU"
		ElseIF SC5->C5_TIPMOV $ "8" ; cPAGTO := "CREDITO EM CONTA"                                  
		EndIF
		
		cMsgNota := Alltrim( STRTRAN( SC5->C5_MENNOTA, ';', '' ) ) 
					
		cDado :=	dToc( SF2->F2_EMISSAO ) + ';' + cCODIGO + ';' + cNOME + ';' + cTipo + ';' + cMAIL + ';' +; 
					Alltrim(SC6->C6_DESCRI) + ';' + Strzero( SC6->C6_QTDVEN, 3 ) + ';' + lTrim(Transform( SC6->C6_VALOR, '@E 999,999,999.99')) + ';' +;
					SC5->C5_NUM + ';' + SC5->C5_XNATURE + ';' + SC6->C6_NOTA + ';' + cPAGTO + ';' + SC5->C5_CONDPAG + ';' + cMsgNota + ';' +;
					dToc( (cTRB)->E1_VENCREA ) + ';' +; 
					cUrl + ';' + lTrim( CHR(160) + cValToChar( cChaveNFE ) ) + ';'
					
		FWrite( nHdl, cDado + CRLF )
		
		(cTRB)->(dbSkip())			
	EndDo
	
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	oMeter:Set(nCount) // Efetua uma atualização final para garantir que o usuário veja o resultado do processamento
	oDlg:CommitControls() // Para atualizar a tela e o usuário receber o feedback

	Sleep(500)
	
	FClose( nHdl )
			
	lRet := __CopyFile( cNameFile, cPath + cNameFile )
	
	IF lRet
		Sleep(500)
		
		Ferase( cDir + cNameFile)
		
		IF ! ApOleClient("MsExcel") 
			MsgAlert("MsExcel não instalado. Para abrir o arquivo, localize-o na pasta %temp% ;","Relatório Faturamento")
			Return
		Else
			ShellExecute( "Open", cPath + cNameFile , '', '', 1 )
		EndIF
	Else
		MsgAlert('Não foi possível copiar o arquivo para a pasta %temp%, verifique.','Relatório Faturamento')
	EndIF
Return


//+--------+-------------+-------+--------------------+------+------------+
//| Rotina | AjustaSX1   | Autor | Rafael Beghini     | Data | 21/12/2015 |
//+--------+-------------+-------+--------------------+------+------------+
//| Descr. | Criacao do Pergunte                                          |
//+--------+--------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital                              |
//+--------+--------------------------------------------------------------+
Static Function AjustaSX1()
	Local aArea := GetArea()
	
	PutSx1( cPerg ,"01" ,"Dt. Emissao Ped De"  	,"Dt. Emissao Ped De"  	,"Dt. Emissao Ped De"   ,"mv_ch1" ,"D" ,08 ,00 ,01 ,"G" ,"" ,"   " ,"" ,"" ,"mv_par01" ," "   ," "   ," "   ,"" ,	" "  ," "   ," "   ," " ," " ," " , " " ," " ," " ," " ," "," ",{ "Data Inicial a ser considerada" })
	PutSx1( cPerg ,"02" ,"Dt. Emissao Ped Ate" 	,"Dt. Emissao Ped Ate" 	,"Dt. Emissao Ped Ate"  ,"mv_ch2" ,"D" ,08 ,00 ,01 ,"G" ,"" ,"   " ,"" ,"" ,"mv_par02" ," "   ," "   ," "   ,"" ,	" "  ," "   ," "   ," " ," " ," " , " " ," " ," " ," " ," "," ",{ "Data Final a ser considerada"   })
	PutSx1( cPerg ,"03" ,"Somente vencidos?"   	,"Somente vencidos?"   	,"Somente vencidos?"    ,"mv_ch3" ,"N" ,01 ,00 ,01 ,"C" ,"" ,""    ,"" ,"" ,"mv_par03" ,"Sim" ,"Sim" ,"Sim" ,"" ,"Nao" ,"Nao" ,"Nao" ,""  ,""  ,""  ,""   ,""  ,""  ,""  ,"" ,"" ,"","","","",{ "Criar arquivo Exce" })
		
	RestArea(aArea)	
Return