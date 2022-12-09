#Include "Protheus.ch"
#Include "TopConn.ch"
#INCLUDE 'Totvs.ch'
#INCLUDE 'TbiConn.ch'
#INCLUDE 'tryexception.ch'

User Function ExecXcel(_cQuery, _aAlias, _cNome)
	Local nCnt 	  := 0
	Local aStruQry  := {}
	Local cArquivo  := "RelExcel.XLS"
	Local oExcelApp := Nil
	Local cPath     := "C:\TEMP\"
	Local nTotal    := 0
	Local aLinExcel := {}
	Local oExcel

    Default _cNome := "RelExcel"
	

    cArquivo := _cNome + ".XLS"
	
	If !Empty(_cQuery)
		TryException
		If Select(cQry) > 0
			(cQry)->(DbCloseArea())
		Endif

		DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cQry,.T.,.T.)

		(cQry)->(DbEval({|| nCnt++}))
		(cQry)->(DbGoTop())
		aStruQry  := (cQry)->(dbStruct())
		CatchException using oException
		Alert("Houve um erro na execução da Query, por favor verifique!")
		Return

		EndException

	Endif

	If nCnt <= 0
		Alert("Não ha Dados na Tabela para Gerar o EXCEL.")
		Return
	Endif

	aColunas := {}
	aLocais := {}
	oBrush1 := TBrush():New(, RGB(193,205,205))

	// Verifica se o Excel está instalado na máquina

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return

	EndIf

	oExcel  := FWMSExcel():New()
	cAba    := _cNome //"RelExcel"
	cTabela := _cNome //"RelExcel"

	// Criação de nova aba
	oExcel:AddworkSheet(cAba)

	// Criação de tabela
	oExcel:AddTable (cAba,cTabela)

	// Criação de colunas
	For nCnt := 1 To Len(aStruQry)
		oExcel:AddColumn(cAba,cTabela,aStruQry[nCnt,1],IIF(aStruQry[nCnt,2]=="N",3,1),IIF(aStruQry[nCnt,2]=="N",1,1),.F.)
	Next nCnt

	While !(cQry)->(Eof())

		// Criação de Linhas
		aLinExcel := {}
		For nCnt := 1 To Len(aStruQry)
			aAdd(aLinExcel,(cQry)->&(aStruQry[nCnt,1]))
		Next nCnt

		oExcel:AddRow(cAba,cTabela, aLinExcel)

		(cQry)->(dbSkip())

	End

	If !Empty(oExcel:aWorkSheet)

		oExcel:Activate()
		oExcel:GetXMLFile(cArquivo)

		CpyS2T("\SYSTEM\"+cArquivo, cPath)

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre a planilha
		oExcelApp:SetVisible(.T.)

	EndIf

Return

Static Function GeraArq(cQry)
	Local nRet    := 0
	Local aHeader := {}
	Local nI      := 0
	Local cArquivo 	:= CriaTrab(,.F.)
	Local cArqDBF 	:= CriaTrab(,.F.)
	Local cPath		:= AllTrim(GetTempPath())
	Local oExcelApp
	Local nHandle
	Local cCrLf 	:= Chr(13) + Chr(10)
	Local nX
	Local cDirDocs  := "C:\TEMP\"
	Local nCntAft   := 0
	Local aStruQry	:= {}
	Local aCmpQry   := {}
	Local aResQry   := {}
	Local aResult   := {}
	Local choraIni  := Time()
	Local choraFim  := Time()
	Local cRetSql   := ""
	Local nQtdSql   := 0

	If !lIsDir(cDirDocs)
		nRet := MakeDir( cDirDocs, Nil, .F. )
		if nRet != 0
			Alert( "Não foi possível criar o diretório "+cDirDocs+", crie manualmente. Erro: " + cValToChar( FError() ) )
		endif
	Endif

	DbSelectArea(cQry)

	aStruQry := (cQry)->(dbStruct())

	For nI := 1 To Len(aStruQry)

		If aStruQry[ni,2] <> "C"
			aAdd(aCmpQry,{aStruQry[ni,1], aStruQry[ni,1], "@E", aStruQry[ni,3], aStruQry[ni,4]})
		Else
			aAdd(aCmpQry,{aStruQry[ni,1], aStruQry[ni,1], "@!", aStruQry[ni,3], aStruQry[ni,4]})
		Endif

	Next nI

	(cQry)->(DbGoTop())
	While (cQry)->(!Eof())
		nQtdSql++
		aResQry := {}
		For nI := 1 To Len(aCmpQry)
			aAdd(aResQry,(cQry)->&(aCmpQry[nI,1]))
		Next nI
		aAdd(aResQry,.F.)
		aAdd(aResult,aResQry)
		(cQry)->(DbSkip())
	End

	oGetDB := MsNewGetDados():New(161,002,278,451,,,,,{''},,,,,,oDlg,aCmpQry,aResult)

	choraFim  := Time()
	cRetSql += "Exemplo de Referência em Tabelas Internas = Select * From SM4" + Alltrim(cEmpAnt) + "0" + Chr(13)+Chr(10)
	cRetSql += "Tempo Execução = " + ElapTime(choraIni,choraFim) + Chr(13)+Chr(10)
	cRetSql += "Qtd. Registros = " + Alltrim(Str(nQtdSql))+ Chr(13)+Chr(10)
	cERPResu := cRetSql
	oERPResu:Refresh()
	oDlg:Refresh()

Return
