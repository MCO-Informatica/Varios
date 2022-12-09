#Include 'Protheus.ch'
#Include 'TbiConn.ch'
#Include 'ParmType.ch'


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFATJ02 |Autor: |David Alves dos Santos |Data: |13/04/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Job para gerar arquivo txt e enviar via FTP para MicroPower.  |
//|-------------+--------------------------------------------------------------|
//|Nomenclatura |CS   = Certisign.                                             |
//|do codigo    |FAT  = Modulo faturamento SIGAFAT.                            |
//|fonte.       |J    = JOB.                                                   |
//|             |02   = Numero sequencial.                                     |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFATJ02()
	
	Local cBarra   := Iif( IsSrvUnix(), '/', '\' )
	Local nRet     := 0
	Local cNomeArq := 'Ciclo_x_Acumulado.txt' //-> Nome fixo definido pela MicroPower.
	
	Private aLog     := {}
	Private cDtHr    := ""
	Private cDirProc := ''
	
	//-> Define o diret�rio onde ser� criado o arquivo.
	cDirProc := cBarra + 'performa' + cBarra + 'sav' + cBarra
	nRet := MakeDir( cDirProc )
	
	If nRet != 0
		ConOut( "N�o foi poss�vel criar o diret�rio. Erro: " + cValToChar( FError() ) )
    EndIf
	
	//-> Informa o servidor que nao ira consumir licensas.
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02" MODULO 'FAT' TABLES 'ZZD', 'ZZH', 'ZZA', 'SF2', 'SD2', 'SA3', 'SF4'
		
		//-> Processamento.
		CSFTJ2Proc(cNomeArq)
		
		//-> Envio do Arquivo.
		CSFTJ2Send(cNomeArq)
		
		//-> Envio de e-mail.
		CSFTJ2Mail()
		
	//-> Restaura ambiente.	
	RESET ENVIRONMENT
	
Return


//+-------------+-----------+-------+-----------------------+------+-----------+
//|Programa:    |CSFTJ2Proc |Autor: |David Alves dos Santos |Data: |13/04/2018 |
//|-------------+-----------+-------+-----------------------+------+-----------|
//|Descricao:   |Processamento do JOB de acumulados.                           |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function CSFTJ2Proc(cNomeArq)
	
	Local cTmp      := GetNextAlias()
	Local cQuery    := ''
	Local cLinha    := ''
	Local cHeader   := 'CICLO;CPF;INDICADOR;VALOR'
	Local nHdl      := 0
	Local cFATJ02A  := AllTrim(SuperGetMV("MV_FATJ02A", .F., "1.Volume de Faturamento"))
	Local nAcuLic   := 0
	Local cFATJ02B  := AllTrim(SuperGetMV("MV_FATJ02B", .F., "VC0070"))
	
	//-> Variaveis de log.
	aLog  := {}
	cDtHr := "'[ CSFATJ02 - ' + DToc(Date()) + ' - ' + Time() + ' ] '"
	
	AAdd(aLog, &(cDtHr) + "Iniciando a gera��o do arquivo: " + cNomeArq + " com base na tabela de acumulados (ZZA).")
	
	//-> Verifica se o arquivo j� existe.
	If File( cDirProc + cNomeArq )
		AAdd(aLog, &(cDtHr) + "O arquivo de integra��o j� existe e ser� atualizado.")
	Endif
	
	//-> Cria��o do arquivo e grava��o do cabe�alho.
	nHdl := FCreate( cDirProc + cNomeArq )
	FWrite( nHdl, cHeader + CRLF )
	
	//-> Query para montar arquivo de integra��o.
	cQuery := " SELECT zza.ZZA_VEND, " 
	cQuery += "        zzd.ZZD_DSCICL, "
	cQuery += "        sa3.A3_CGC, " 
	cQuery += "        SUM(zza.ZZA_TOTAL) AS ACUMULADO "  
	cQuery += " FROM   ZZA010 zza " 
	cQuery += "        INNER JOIN ZZD010 zzd  " 
	cQuery += "                ON zza.ZZA_CDCICL = zzd.ZZD_CDCICL " 
	cQuery += "        INNER JOIN SA3010 sa3 "
	cQuery += "                ON sa3.A3_COD = zza.ZZA_VEND "
	cQuery += " WHERE  zzd.ZZD_STATUS = '1'  "
	cQuery += "        AND zza.D_E_L_E_T_ = ' ' "
	cQuery += "        AND zzd.D_E_L_E_T_ = ' ' "
	cQuery += "        AND sa3.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP  BY zza.ZZA_VEND,  "
	cQuery += "           zzd.ZZD_DSCICL, "
	cQuery += "           sa3.A3_CGC "
	cQuery += " ORDER  BY zza.ZZA_VEND " 
	
	//-> Verifica se a tabela esta aberta.
	If Select(cTmp) > 0
		(cTmp)->(DbCloseArea())				
	EndIf
		
	//-> Cria��o da tabela temporaria.
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. ) 

	AAdd(aLog, &(cDtHr) + "Tabela tempor�ria criada com sucesso.")
	AAdd(aLog, &(cDtHr) + "Iniciando grava��o de conte�do dentro do arquivo: " + cNomeArq)
	While (cTmp)->(!Eof())
		
		If (cTmp)->ZZA_VEND == "VC0047"
			nAcuLic := (cTmp)->ACUMULADO
			cLinha := ''
			(cTmp)->( dbSkip() )
		EndIf
		
		//-> Monta linha com as informa��es.
		cLinha := AllTrim(Left((cTmp)->ZZD_DSCICL,20))
		cLinha += ";" + StrZero(Val((cTmp)->A3_CGC),11)
		cLinha += ";" + cFATJ02A
		
		If (cTmp)->ZZA_VEND == cFATJ02B
			cLinha += ";" + StrTran(AllTrim(cValToChar((cTmp)->ACUMULADO + nAcuLic)),".",",")
		Else
			cLinha += ";" + StrTran(AllTrim(cValToChar((cTmp)->ACUMULADO)),".",",")
		EndIf
		
		//-> Grava informa��es no arquivo .txt
		FWrite( nHdl, cLinha + CRLF )
		 
		cLinha := ''
		(cTmp)->( dbSkip() )
	EndDo
	
	//-> Finaliza cria��o do arquivo.
	FClose( nHdl )
	Sleep( 500 )
	AAdd(aLog, &(cDtHr) + "Arquivo " + cNomeArq + " criado com sucesso.")
	AAdd(aLog, "----------------------------------------------------------------------------------------------------")
	
Return


//+-------------+-----------+-------+-----------------------+------+-----------+
//|Programa:    |CSFTJ2Send |Autor: |David Alves dos Santos |Data: |02/05/2018 |
//|-------------+-----------+-------+-----------------------+------+-----------|
//|Descricao:   |Envia o arquivo gerado via FTP.                               |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function CSFTJ2Send(cNomeArq)
	
	Local cMV_FTP1PFM := GetMV("MV_FTP1PFM", .F.)	//-> Servidor
	Local nMV_FTP2PFM := GetMV("MV_FTP2PFM", .F.)	//-> Porta
	Local cMV_FTP3PFM := GetMV("MV_FTP3PFM", .F.)	//-> Login
	Local cMV_FTP4PFM := GetMV("MV_FTP4PFM", .F.)	//-> Senha
	Local cMV_FTP5PFM := GetMV("MV_FTP5PFM", .F.)	//-> IP ou Hostname
	Local cPsw        := ""
	
	AAdd(aLog, &(cDtHr) + "Iniciando processo de envio do arquivo " + cNomeArq + " via FTP.")
	
	//-> Verifica se o arquivo existe.
	If File( cDirProc + cNomeArq )
		
		AAdd(aLog, &(cDtHr) + "Arquivo encontrado.")
		cPsw := Decode64(cMV_FTP4PFM)
		
		//-> Realiza a conex�o no servidor FTP da MicroPower.
		If FTPConnect( cMV_FTP1PFM , nMV_FTP2PFM, cMV_FTP3PFM, cPsw, ( cMV_FTP5PFM == 'S' ) )		
			
			AAdd(aLog, &(cDtHr) + "Conex�o FTP realizada com sucesso.")

			//-> Reseta a variavel para n�o deixar a senhar armazenada.
			cPsw := ""

			//-> Realiza o upload do arquivo para o FTP da MicroPower.
			If FTPUpLoad( cDirProc + cNomeArq, cNomeArq )
				AAdd(aLog, &(cDtHr) + "Arquivo " + cNomeArq + " enviado com sucesso para o servidor FTP.")
			Else
				AAdd(aLog, &(cDtHr) + "Falha ao realizar o upload do arquivo " + cNomeArq)
			Endif

			//-> Encerra a conex�o.
			FTPDisConnect()
		Else
			AAdd(aLog, &(cDtHr) + "N�o foi possivel realizar a conex�o com o servidor FTP.")
		Endif

	Endif
	
	AAdd(aLog, &(cDtHr) + "Processo de envio de arquivo via FTP finalizado.")
	
Return


//+-------------+-----------+-------+-----------------------+------+-----------+
//|Programa:    |CSFTJ2Mail |Autor: |David Alves dos Santos |Data: |02/05/2018 |
//|-------------+-----------+-------+-----------------------+------+-----------|
//|Descricao:   |Envia e-mail com o log de processamento.                      |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function CSFTJ2Mail()
	
	Local nX       := 0
	Local cBody    := ""
	Local cHtml    := ""
	Local cPara    := GetMV("MV_FTP6PFM", .F.)
	Local cAssunto := "LOG - Integra��o SAV Protheus x Performa"
	
	//-- Montagem do corpo do e-mail.
	cBody := "<br><p>"
	cBody += "	Segue informa��es detalhadas sobre a integra��o: Protheus x Performa<br><br>"
	cBody += "	Este e-mail tem como objetivo, apresentar o log de processamento a fim de apontar possiveis falhas na integra��o do Protheus com o sistema Performa da MicroPower.<br><br><br>"
	cBody += "	<strong>Log de integra��o via FTP:</strong><br><br>"
			
	For nX := 1 To Len(aLog)
		Conout(aLog[nX])
		cBody += aLog[nX] + "<br>"
	Next nX
	cBody += "<br><br></p>"
	
	Conout('[CSFATJ02_' + DtoS(Date()) + '_' + Time() + '] - ' + "Processo de upload realizado com sucesso.")
				
	//-- Retorna o HTML completo concatenando o corpo do e-mail.
	cHtml := u_CSModHtm(cBody)
			
	If !Empty(cPara)
		//-- Realiza o envio do e-mail.
		FSSendMail( cPara, cAssunto, cHtml )
	EndIf

Return