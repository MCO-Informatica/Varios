#Include 'Protheus.ch'

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSTKR020 |Autor: |David Alves dos Santos |Data: |13/04/2017   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Geração de relatorio.                                         |
//|-------------+--------------------------------------------------------------|
//|Nomenclatura |CS  = Certisign.                                              |
//|do codigo    |TK  = Modulo Call Center SIGATMK.                             |
//|fonte.       |R   = Relatorio.                                              |
//|             |999 = Numero sequencial.                                      |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSTKR020()
	
	Local cPerg := "TKR020A"
	
	If !Pergunte(cPerg,.T.)
		Return
	Else
		Processa({|| RunReport()} ,"Gerando relatório, aguarde...")
	EndIf
	
Return


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |RunReport |Autor: |David Alves dos Santos |Data: |13/04/2017   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Executa o processamento do relatorio.                          |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local oFWMsExcel
	Local oExcel
	Local aArea      := GetArea()
	Local cQuery     := ""
	Local cArquivo   := GetTempPath()+"RelExcel_" + dToS(Date())+"-"+ StrTran(time(),":","") + ".xml"
	Local cTmpQry    := GetNextAlias()
	
	ProcRegua(0)
	
	//-- Query para extração dos dados.
	cQuery := " WITH contato AS "
	cQuery += " ( "
	cQuery += " SELECT ac8.AC8_CODCON, "
	cQuery += "        ac8.AC8_CODENT, "
	cQuery += "        su5.U5_CODCONT, "
	cQuery += "        su5.U5_CPF, "
	cQuery += "        su5.U5_CONTAT, "
	cQuery += "        sz3.Z3_DESENT, "
	cQuery += "        sz3.Z3_CODENT "
	cQuery += " FROM   " + RetSqlName("SU5") + " su5 "
	cQuery += "        LEFT JOIN " + RetSqlName("AC8") + " ac8 "
	cQuery += "               ON su5.U5_CODCONT = ac8.AC8_CODCON "
	cQuery += "        LEFT JOIN " + RetSqlName("SZ3") + " sz3 "
	cQuery += "               ON ac8.AC8_CODENT = sz3.Z3_CODENT "
	cQuery += " WHERE  ac8.AC8_ENTIDA = 'SZ3' "
	cQuery += "        AND su5.D_E_L_E_T_ = ' ' "
	cQuery += "        AND ac8.D_E_L_E_T_ = ' ' "
	cQuery += "        AND sz3.D_E_L_E_T_ = ' ' "
	cQuery += " ) "
	cQuery += " SELECT ade.ADE_CODIGO protocolo, "
	cQuery += "        ade.ADE_ASSUNT assunto, "
	cQuery += "        ctt.U5_CPF     cpf, "
	cQuery += "        ctt.U5_CONTAT  nome_contato, "
	cQuery += "        ctt.Z3_DESENT  ar, "
	cQuery += "        ade.ADE_GRUPO  equipe, "
	cQuery += "        ade.ADE_DATA   data "
	cQuery += " FROM   " + RetSqlName("ADE") + " ade  "
	cQuery += "        LEFT JOIN contato ctt "
	cQuery += "               ON ade.ADE_CODCON = ctt.U5_CODCONT AND ade.ADE_CHAVE = ctt.Z3_CODENT "
	cQuery += " WHERE  ade.ade_data BETWEEN '" + dToS(mv_par01) + "' AND '" + dToS(mv_par02) + "'  "
	
	If !Empty(mv_par03)
		cQuery += "		AND ade.ADE_GRUPO = '" + AllTrim(mv_par03) + "' "
	EndIf
	
	cQuery += "        AND ade.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY ade.ADE_CODIGO "
	
	//-- Executa query.
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmpQry,.F.,.T.)
	(cTmpQry)->(dbGoTop())
	
	//-- Criando o objeto que irá gerar o conteúdo do Excel
	oFWMsExcel := FWMSExcel():New()
	
	//-- Pasta.
	oFWMsExcel:AddworkSheet("RELATORIO")
	//-- Criando a Tabela
	oFWMsExcel:SetTitleSizeFont(15)
	oFWMsExcel:AddTable("RELATORIO","Relatório - Chamados x Contatos")
	
	//-- Colunas.
	oFWMsExcel:AddColumn("RELATORIO" ,"Relatório - Chamados x Contatos" ,"Protocolo"    ,1)
	oFWMsExcel:AddColumn("RELATORIO" ,"Relatório - Chamados x Contatos" ,"Assunto"      ,1)
	oFWMsExcel:AddColumn("RELATORIO" ,"Relatório - Chamados x Contatos" ,"CPF"          ,1)
	oFWMsExcel:AddColumn("RELATORIO" ,"Relatório - Chamados x Contatos" ,"Nome Contato" ,1)
	oFWMsExcel:AddColumn("RELATORIO" ,"Relatório - Chamados x Contatos" ,"AR"           ,1)
	oFWMsExcel:AddColumn("RELATORIO" ,"Relatório - Chamados x Contatos" ,"Equipe"       ,1)
	oFWMsExcel:AddColumn("RELATORIO" ,"Relatório - Chamados x Contatos" ,"Data"         ,1)
		
	//-- Criando as Linhas... Enquanto nao for fim da query
	While !(cTmpQry)->(EoF())
		
		//-- Inicia processamento.
		IncProc()
		
		//-- Adiciona uma nova linha no excel.
		oFWMsExcel:AddRow("RELATORIO","Relatório - Chamados x Contatos" ,;
								 { 	(cTmpQry)->(PROTOCOLO)		,;
							  		(cTmpQry)->(ASSUNTO)			,;
							  		(cTmpQry)->(CPF)				,;
							  		(cTmpQry)->(NOME_CONTATO)	,;
							  		(cTmpQry)->(AR)				,;
							  		(cTmpQry)->(EQUIPE)			,;
							  		(cTmpQry)->(DATA)				})
		//-- Proximo registro.
		(cTmpQry)->(DbSkip())
		
	EndDo

	//-- Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//-- Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()			//-- Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo)		//-- Abre uma planilha
	oExcel:SetVisible(.T.)				//-- Visualiza a planilha
	oExcel:Destroy()						//-- Encerra o processo do gerenciador de tarefas
	
	//-- Fecha tabela temporaria e restaura.
	(cTmpQry)->(DbCloseArea())
	RestArea(aArea)

Return