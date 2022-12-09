#INCLUDE 'Totvs.ch'
#INCLUDE 'TbiConn.ch'
#INCLUDE 'tryexception.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} ERPQuery

Essa rotina executa a exportação em Excel do relatorio.

@author Fabio Favaretto
@since 10/05/2021
@version 1.0
/*/
//-------------------------------------------------------------------
User Function SQLERP()
	Local oERPQry
	Local cERPQry   := Space(1000)
	Local nRegMax   := 1000
	Local lMaster   := .T.
	Local cGruposNm := ""
	Local aGruposNm := UsrRetGrp(,RetCodUsr())
	Local AliasExcl

	Private oERPResu
	Private cERPResu  := "Exemplo de Referência em Tabelas Internas = Select * From SM4" + Alltrim(cEmpAnt) + "0"
	Private oDlg
	Private oGetDB
	Private cQry   	:= getNextAlias()

	If Len(aGruposNm) > 0
		cGruposNm := aGruposNm[1]
	EndIF

	DEFINE MSDIALOG oDlg TITLE "Extrator de Query's" FROM 000,000 TO 560,900 PIXEL

	oERPQry := tMultiget():New(002,002,{|u|if(Pcount()>0,cERPQry:=u,cERPQry)},oDlg,448,090,,,,,,.T.,,,,,,!lMaster,,,,,.T.,"Expressão SQL",1,,CLR_GREEN)

	@ 104, 005 BUTTON "Novo"		SIZE  50,16 PIXEL OF oDlg ACTION NwQry(@cERPQry)
	@ 104, 060 BUTTON "Abrir"		SIZE  50,16 PIXEL OF oDlg ACTION OpnQry(@cERPQry)
	@ 104, 120 BUTTON "Salvar"		SIZE  50,16 PIXEL OF oDlg ACTION  SvQry( cERPQry)
	@ 104, 180 BUTTON "Executar"	SIZE  50,16 PIXEL OF oDlg ACTION ExecQry(@cERPQry, @cERPResu, @lMaster, oDlg:Refresh() )
	@ 104, 240 BUTTON "Excel"		SIZE  50,16 PIXEL OF oDlg ACTION MsAguarde({|| ExecXcel(@cERPQry,cQry)},"Aguarde","Executando query e exportando a consulta para o Excel...",.F.)
	@ 104, 400 BUTTON "Sair"		SIZE  50,16 PIXEL OF oDlg ACTION oDlg:End()

	oERPResu := tMultiget():New(122,002,{|u|if(Pcount()>0,cERPResu:=u,cERPResu)},oDlg,448,27,,,,,,.T.,,,{||.F.},,,,,,,,.T.,"Log. (Empresa Conectada = " + Alltrim(cEmpAnt) + "0)",1,,CLR_RED)

	SetKey(VK_F5, {|| ExecQry(@cERPQry, @cERPResu, @lMaster, oDlg:Refresh() )})
	SetKey(VK_F8, {|| MsAguarde({||ExecXcel(@cERPQry,cQry)},"Aguarde","Executando Query e Excel da consulta...",.F.)})
	SetKey(VK_ESCAPE, {|| oDlg:End() })

	ACTIVATE MSDIALOG oDlg CENTER

Return

Static Function ExecXcel(_cQuery, _aAlias)
	Local nCnt 	  := 0
	Local aStruQry  := {}
	Local cArquivo  := "ERPQuery.XLS"
	Local oExcelApp := Nil
	Local cPath     := "C:\TEMP\"
	Local nTotal    := 0
	Local aLinExcel := {}
	Local oExcel
	
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
	cAba    := "ERPQuery"
	cTabela := "ERPQuery"

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

Static Function ExecQry(cERPQry, cERPResu, lMaster)
	Local nCnt    	:= 0
	Local cFileOpen := ""
	Local cTitulo1  := "Selecione a Query"
	Local cExtens   := "Arquivo TXT | *.txt"
	Local cLocPatc  := 'SERVIDOR\query_ERP'
	Local cBuffer	:= ""
	Local aLinha    := {}
	Local nI        := 0
	Local cAfetadas := ""
	Local lAfetadas := .T.

	aLinha := StrToKarr(cERPQry,CHR(13)+CHR(10))

	If !Empty(cERPQry)

		If Select(cQry) > 0
			(cQry)->(DbCloseArea())
		EndIf

		//If ("DELETE " $ Upper(cERPQry) .OR. "UPDATE " $ Upper(cERPQry) .OR. "INSERT INTO " $ Upper(cERPQry))
		//	Alert("Regras de DELETE/UPDATE/INSERT não esta Liberado.")
		//	Return
		//Endif

		TryException
		//cERPQry := ChangeQuery(cERPQry)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cERPQry),cQry,.T.,.T.)

		//(cQry)->(DbEval({|| nCnt++}))
		(cQry)->(DbGoTop())

		MsAguarde({||GeraArq(cQry)},"Aguarde","Executando Query...",.F.)

		If Select(cQry) > 0
			(cQry)->(DbCloseArea())
		EndIf
		CatchException using oException
		Alert("Houve um erro na execução da Query, por favor verifique!")
		EndException
	Else
		MsgInfo("Comando Query não informado")
	EndIf

Return cQry

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

Static Function SvQry(cERPQry)
	Local cFile
	Local nHdl

	cFile := cGetFile('Advanced Protheus Query Analyzer |*.APQ |SQL Query Analyzer |*.SQL |All Files|*.*','Save File',,,.F.,GETF_ONLYSERVER)
	If Empty(cFile)
		Return
	EndIf
	If At(".",cFile) == 0
		cFile += ".APQ"
	EndIf

	If File(cFile)
		If ApMsgYesNo("Sobrescrever o arquivo existente?","Atenção")
			FErase(cFile)
		Else
			Return
		EndIf
	EndIf

	nHdl := FCreate(cFile,0)
	If nHdl < 0
		ApMsgAlert("Falha na gravação do arquivo "+cFile )
		Return
	EndIf
	FWrite(nHdl,cERPQry)
	FClose(nHdl)
Return

Static Function OpnQry(cERPQry)
	Local cFile
	Local cBuffer
	Local nLength
	Local nHdl

	cFile := cGetFile('Advanced Protheus Query Analyzer |*.APQ |SQL Query Analyzer |*.SQL |All Files|*.*','Open File',,,.T.,GETF_ONLYSERVER)
	If Empty(cFile)
		Return
	EndIf

	If At(".",cFile) == 0
		cFile += ".APQ"
	EndIf

	nHdl := FOpen(cFile,0)
	If nHdl < 0
		ApMsgAlert("Falha na leitura do arquivo "+cFile )
		Return
	EndIf

	nLength := FSeek(nHdl,0,2)
	cBuffer := Space(nLength)
	FSeek(nHdl,0)
	FRead(nHdl,@cBuffer,nLength)
	FClose(nHdl)
	cERPQry := cBuffer
Return

Static Function NwQry(cERPQry)
	If !Empty(cERPQry) .And. ApMsgYesNo("Salvar script corrente?","Atenção")
		ApQrySvQry()
	EndIf
	cERPQry := ""
Return
