#Include 'Protheus.ch'
#Include "RwMake.ch"
#Include "TopConn.ch"
#Include 'Ap5Mail.ch'
#Include 'TbiConn.ch'

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFATJ01 |Autor: |David Alves dos Santos |Data: |11/04/2018   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Job para alimentar a tabela de acumulados (ZZA).              |
//|-------------+--------------------------------------------------------------|
//|Nomenclatura |CS   = Certisign.                                             |
//|do codigo    |FAT  = Modulo faturamento SIGAFAT.                            |
//|fonte.       |J    = JOB.                                                   |
//|             |01   = Numero sequencial.                                     |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFATJ01()
	
	Private aLog  := {}
	Private cDtHr := ""
	
	//-> Informa o servidor que nao ira consumir licensas.
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02" MODULO 'FAT' TABLES 'ZZD', 'ZZH', 'ZZA', 'SF2', 'SD2', 'SA3', 'SF4'
		
		//-> Processamento.
		CSFTJ1Proc()
		
	//-> Restaura ambiente.	
	RESET ENVIRONMENT
  	  
Return


//+-------------+-----------+-------+-----------------------+------+-----------+
//|Programa:    |CSFTJ1Proc |Autor: |David Alves dos Santos |Data: |11/04/2018 |
//|-------------+-----------+-------+-----------------------+------+-----------|
//|Descricao:   |Processamento do JOB de acumulados.                           |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function CSFTJ1Proc()

	Local cQuery   := ""
	Local cTmpZZDH := GetNextAlias()
	Local cTmp     := GetNextAlias()
	
	Local lSeekZZA := .T.
	
	//-> Variaveis de log.
	aLog  := {}
	cDtHr := "'[ ' + DToc(Date()) + ' - ' + Time() + ' ] '"
	
	AAdd(aLog, &(cDtHr) + "Iniciando processo de inclusão/atualização da tabela de acumulados (ZZA).")
	
	//-> Query para filtrar ciclos ativos.
	cQuery := " SELECT ZZD.ZZD_FILIAL, " 
	cQuery += "        ZZD.ZZD_CDCICL, "
	cQuery += "        ZZD.ZZD_STATUS, " 
	cQuery += "        ZZD.ZZD_DTINI, "  
	cQuery += "        ZZD.ZZD_DTFIM, " 
	cQuery += "        ZZH.ZZH_FILIAL, " 
	cQuery += "        ZZH.ZZH_ATIVO, " 
	cQuery += "        ZZH.ZZH_DTDE, " 
	cQuery += "        ZZH.ZZH_DTATE " 
	cQuery += " FROM   " + RetSqlName("ZZD") + " ZZD " 
	cQuery += "        INNER JOIN " + RetSqlName("ZZH") + " ZZH " 
	cQuery += "                ON ZZD.ZZD_CDCICL = ZZH.ZZH_CDCICL " 
	cQuery += " WHERE  ZZD.ZZD_FILIAL = '" + xFilial("ZZD") + "' " 
	cQuery += "        AND ZZH.ZZH_FILIAL = '" + xFilial("ZZH") + "' " 
	cQuery += "        AND ZZD.ZZD_STATUS = '1' " 
	cQuery += "        AND ZZH.ZZH_ATIVO = 'S' " 
	cQuery += "        AND ZZD.D_E_L_E_T_ = ' ' " 
	cQuery += "        AND ZZH.D_E_L_E_T_ = ' ' " 	
	
	//-> Verifica se a tabela esta aberta.
	If Select(cTmpZZDH) > 0
		(cTmpZZDH)->(DbCloseArea())				
	EndIf
		
	//-> Criação da tabela temporaria.
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmpZZDH, .F., .T. ) 
	AAdd(aLog, &(cDtHr) + "Tabela temporaria de ciclos ativos criado com sucesso.")
	
	//-> Se tiver registro na tabela temporaria.
	If (cTmpZZDH)->(!Eof())
		
		If DtoS(Date()) > (cTmpZZDH)->ZZH_DTATE
			cDataDe  := (cTmpZZDH)->ZZH_DTDE
			cDataAte := (cTmpZZDH)->ZZH_DTATE
		Else
			cDataDe  := (cTmpZZDH)->ZZH_DTDE
			cDataAte := DtoS(Date())
		EndIf
		
		//-> Monta query do periodo ativo dentro do ciclo.
		cQuery := " SELECT SF2.F2_VEND1, "
		cQuery += "        SA3.A3_NOME, "
		cQuery += "        SA3.A3_CGC as CPF, "
		cQuery += "        SUM(( SD2.D2_TOTAL + SD2.D2_VALFRE )) AS ACUMULADO "  
		cQuery += " FROM   " + RetSqlName("SD2") + " SD2 " 
		cQuery += "        INNER JOIN " + RetSqlName("SF2") + " SF2 " 
		cQuery += "                ON SD2.D2_FILIAL = SF2.F2_FILIAL " 
		cQuery += "                   AND SD2.D2_DOC = SF2.F2_DOC " 
		cQuery += "                   AND SD2.D2_SERIE = SF2.F2_SERIE " 
		cQuery += "                   AND SF2.D_E_L_E_T_ = ' ' "  
		cQuery += "                   AND SD2.D_E_L_E_T_ = ' ' "
		cQuery += "        INNER JOIN " + RetSqlName("SA3") + " SA3 " 
		cQuery += "                ON SA3.A3_FILIAL = ' ' " 
		cQuery += "                   AND SA3.A3_COD = SF2.F2_VEND1 " 
		cQuery += "                   AND SA3.D_E_L_E_T_ = ' ' "
		cQuery += "        INNER JOIN " + RetSqlName("SF4") + " SF4 " 
		cQuery += "                ON SF4.F4_FILIAL = ' ' " 
		cQuery += "                   AND SF4.F4_CODIGO = SD2.D2_TES "
		cQuery += "                   AND SF4.F4_DUPLIC = 'S' " 
		cQuery += "                   AND SF4.D_E_L_E_T_ = ' ' " 
		cQuery += " WHERE  SD2.D2_FILIAL BETWEEN '01'  AND '02' "
		cQuery += "        AND SD2.D2_EMISSAO BETWEEN '" + cDataDe + "' AND '" + cDataAte + "' "
		cQuery += "        AND (SA3.A3_XCANAL = '000001' OR SA3.A3_XCANAL = '000003' OR SA3.A3_XCANAL = '000011' ) " //cQuery += "        AND SA3.A3_XCANAL IN ('000001', '000003', '000011') "
		cQuery += " GROUP BY SF2.F2_VEND1, "
		cQuery += "          SA3.A3_NOME, "
		cQuery += "          SA3.A3_CGC "
		cQuery += " ORDER BY SF2.F2_VEND1 "

		//-> Verifica se a tabela esta aberta.
		If Select(cTmp) > 0
			(cTmp)->(DbCloseArea())				
		EndIf
		
		//-> Criação da tabela temporaria.
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )
		AAdd(aLog, &(cDtHr) + "Tabela temporaria de periodos ativos criado com sucesso.")

		dbSelectArea("ZZA")
		dbSetOrder(3) //-> FILIAL + CICLO + VENDEDOR + DATA DE
		
		AAdd(aLog, &(cDtHr) + "Iniciando processo de inclusão/atualização com base nas tabelas temporárias.")
		While (cTmp)->(!Eof())
			
			lSeekZZA :=  ZZA->( dbSeek( xFilial() + (cTmpZZDH)->ZZD_CDCICL + (cTmp)->F2_VEND1 + cDataDe ) )
			
			//-> Inclui natabela de acumulados.
			RecLock("ZZA", !lSeekZZA)
				ZZA->ZZA_FILIAL := xFilial("ZZA")
				ZZA->ZZA_CDCICL := (cTmpZZDH)->ZZD_CDCICL
				ZZA->ZZA_VEND   := (cTmp)->F2_VEND1
				ZZA->ZZA_UNEG   := "XXXXXX"
				ZZA->ZZA_TOTAL  := (cTmp)->ACUMULADO
				ZZA->ZZA_DTDE   := StoD(cDataDe)
				ZZA->ZZA_DTATE  := StoD(cDataAte)
			ZZA->(MsUnLock())
			
			If !lSeekZZA
				AAdd(aLog, &(cDtHr) + "Registro referente ao vendedor: " + (cTmp)->F2_VEND1 + " incluido com sucesso.")
			Else
				AAdd(aLog, &(cDtHr) + "Registro referente ao vendedor: " + (cTmp)->F2_VEND1 + " alterado com sucesso.")
			EndIf
			 
			(cTmp)->(dbSkip())
			
		EndDo
		AAdd(aLog, &(cDtHr) + "Processo de inclusão/atualização da tabela de acumulados (ZZA) concluido com sucesso.")
		
		//-> Se existir log, envia e-mail.
		If Len( aLog ) > 0
			LogMail()
		EndIf
		
	EndIf
	
Return


//+-------------+-----------+-------+-----------------------+------+-----------+
//|Programa:    |LogMail    |Autor: |David Alves dos Santos |Data: |12/04/2018 |
//|-------------+-----------+-------+-----------------------+------+-----------|
//|Descricao:   |Envio do logo do processamento via e-mail.                    |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function LogMail()

	Local nX       := 0
	Local cBody    := ""
	Local cHtml    := ""
	Local cPara    := SuperGetMV("MV_E05PERF",.F.," ")
	Local cAssunto := "LOG - Acumulados (ZZA)"
	
	//-> Montagem do corpo do e-mail.
	cBody := "<br><p>"
	cBody += "	Log de processamento tabela de ciclos acumulados<br><br>"
	cBody += "	<strong>Log de Envio via FTP:</strong> <br>"
			
	For nX := 1 To Len( aLog )
		Conout( aLog[nX] )
		cBody += aLog[nX] + " <br>"
	Next nX
	cBody += "<br><br></p>"
					
	//-> Retorna o HTML completo concatenando o corpo do e-mail.
	cHtml := u_CSModHtm(cBody)
			
	If !Empty(cPara)
		//-> Realiza o envio do e-mail.
		FSSendMail( cPara, cAssunto, cHtml )
	EndIf

Return