#include "totvs.ch"
#include "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#include "fileio.ch"

/*/{Protheus.doc} IMPORTFS
	Faz o download dos arquivos de Forecast e importa para o Protheus.
	@type  Function
	@author Gustavo Gonzalez
	@since 30/03/2021
/*/
User Function IMPORTFC()
	Local nZ,nX,nA,nB
	Local oObj
	Local aHeadApi  := {}
	Local aArquivos	:= {}
	Local aCampos	:= {}
	Local aDados	:= {}
	Local aRetDir	:= {}
	Local cConteudo	:= ""
	Local cErro		:= ""
	Local cArq    	:= ""
	Local cLinha  	:= ""
	Local nInc,nAlt	:= 0
	Local lPrim  	:= .T.
	Local lOk		:= .T.

	IF TYPE("CEMPANT") == "U"
		RpcClearEnv()
		RPCSetType(3)
		RpcSetEnv ( "01", "01")
	EndIf

	cUrl		:= SuperGetMv( "FC_URL" 	, .F. , "https://app2.mastercrm.ws" ,  )
	oRest		:= FWRest():New(cUrl)
	cUsername	:= SuperGetMv( "FC_USER" 	, .F. , "integracao@cloud.com" 		,  )
	cPassword	:= SuperGetMv( "FC_PASS" 	, .F. , "mudar@integracao" 			,  )
	cTenant		:= SuperGetMv( "FC_TENANT" 	, .F. , "prozyn" 				,  )
	cForecast	:= SuperGetMv( "FC_PLANEJ" 	, .F. , "Forecast 2021" 			,  )
	cDir		:= SuperGetMv( "FC_DIR" 	, .F. , "C:\CRM\" 					,  )
	cDirCSV		:= cDir + "\HISTORICO\CSV\"
	cDirErro	:= cDir + "\HISTORICO\ERROS\"

	//Checar se existem pastas locais
	If !ExistDir(cDir)
		Makedir(cDir)
		Makedir(cDir+"\HISTORICO\")
		Makedir(cDirCSV)
		Makedir(cDirErro)
	EndIf

	//Gera Cabeçalho da Requisição
	Aadd( aHeadApi	, 'Accept: application/json;charset=UTF-8')
	Aadd( aHeadApi	, 'Content-Type: application/json' )

	//Faz a Autenticação e recebe o cookie de autenticação
	cBodyApi	:= '{"username": "'+ cUsername + '","password": "'+ cPassword +'","tenant": "'+ cTenant +'"}'
	cPath		:= '/api/login'
	oRest:SetPath(cPath)
	oRest:SetPostParams(cBodyApi)
	//Ajuste de Timeout para evitar erro de conexão.
	oRest:nTimeout := 500

	If (oRest:Post(aHeadApi))
		AAdd(aHeadApi, "Cookie: " + oRest:oResponseH:aHeaderFields[AScan(oRest:oResponseH:aHeaderFields, {|x| Upper(AllTrim(x[1])) == "SET-COOKIE"})][2])
		cBodyApi	:= ''
	Else
		lOK	:= .F.
		ConOut(Repl("-", 80))
		ConOut(PadC("Forecast - Erro de Autenticacao", 80))
		ConOut(Repl("-", 80))
	EndIf

	//Lista os Planejamentos CRM
	If lOK
		cPath		:= '/api/v2/forecast/forecasts?q={select->[id,description,status]}'
		oRest:SetPath(cPath)
		oRest:SetPostParams(cBodyApi)
		If (oRest:Get(aHeadApi))
			cResponse	:= (oRest:GetResult())
			If FWJsonDeserialize(cResponse,@oObj)
				For nZ := 1 to Len(oObj:Items)
					If oObj:Items[nZ]:Description == cForecast
						cId := oObj:Items[nZ]:ID
					EndIF
				Next
			Else
				lOK	:= .F.
				ConOut(Repl("-", 80))
				ConOut(PadC("Forecast - Erro ao listar planejamentos 1.", 80))
				ConOut(Repl("-", 80))
			EndIf
		Else
			lOK	:= .F.
			ConOut(Repl("-", 80))
			ConOut(PadC("Forecast - Erro ao listar planejamentos 2.", 80))
			ConOut(Repl("-", 80))
		EndIf
	EndIF

	//Monta URL Download
	If lOK
		cPath		:= '/api/v2/file-manager/files/forecast/csv/' + cId + '.csv'
		oRest:SetPath(cPath)
		If (oRest:Get(aHeadApi))
			cResponse	:= (oRest:GetResult())
			If FWJsonDeserialize(cResponse,@oObj)
				For nZ := 1 to Len(oObj)
					If oObj[nZ]:Size <> 0
						Aadd( aArquivos	, oObj[nZ]:Path)
					EndIF
				Next
			Else
				lOK	:= .F.
				ConOut(Repl("-", 80))
				ConOut(PadC("Forecast - Erro ao Montar URL Download 1", 80))
				ConOut(Repl("-", 80))
			EndIf
		Else
			lOK	:= .F.
			ConOut(Repl("-", 80))
			ConOut(PadC("Forecast - Erro ao Montar URL Download 2", 80))
			ConOut(Repl("-", 80))
		EndIf
	EndIF

	//Baixa os arquivos
	If lOK
		For nX := 1 to Len(aArquivos)
			cPath		:= '/api/v2/file-manager/files/forecast/csv/' + cId + '.csv/' + aArquivos[nX]
			oRest:SetPath(cPath)

			//Solicita link da Amazon S3
			oRest:Get(aHeadApi)

			//Verifica se entrou no redirecionamento de Link
			If oRest:oResponseH:cStatusCode == '307'
				cS3Url	:= FwCutOff(oRest:oResponseH:aHeaderFields[AScan(oRest:oResponseH:aHeaderFields, {|x| Upper(AllTrim(x[1])) == "LOCATION"})][2])

				If !DWLDVbs(cS3Url,cDir,aArquivos[nX])
					lOK	:= .F.
					ConOut(Repl("-", 80))
					ConOut(Alltrim("Forecast - Erro ao baixar arquivo " + aArquivos[nX]))
					ConOut(Repl("-", 80))
				EndIf
			Else
				lOK	:= .F.
				ConOut(Repl("-", 80))
				ConOut(Alltrim("Forecast - Erro ao baixar arquivo " + aArquivos[nX]))
				ConOut(Repl("-", 80))
			EndIf

		Next nX
	EndIF

	//Processa arquivos para o Protheus.
	If lOk
		//Retorna todos os arquivos disponíveis
		aRetDir := DIRECTORY ( cDir + "*.CSV" )

		//Verifica se o array esta vazio.
		If Empty( aRetDir )
			conout( "Importa Forecast - Array Vazio!!" )
			Return NIL
		EndIf

		For nA := 1 to Len(aRetDir)
			cArq	:=	aRetDir[nA][1]
			If !File(cDir+cArq)
				MsgStop("O arquivo " + cDir + cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
				Return
			Else
				cConteudo	:= ''
				cErro		:= ''
				aCampos		:= {}
				aDados		:= {}

				FT_FUSE(cDir+cArq)
				ProcRegua(FT_FLASTREC())
				FT_FGOTOP()
				Conout("Lendo arquivo texto...")
				While !FT_FEOF()
					cLinha := FT_FREADLN()

					If lPrim
						aCampos := Separa(cLinha,";",.T.)
						lPrim := .F.
					Else
						AADD(aDados,Separa(cLinha,";",.T.))
					EndIf
					FT_FSKIP()
				EndDo
				// Fecha o Arquivo
				FT_FUSE()

				//Processa informações e grava na tabela SZ2
				DBSelectArea('SZ2')
				SZ2->(DBSetOrder(1))
				For nB := 1 to Len(aDados)
					lValida			:= .T.

					dData			:= STOD(SUBSTR(STRTRAN(aDados[nB][3],'-',''),1,8))  //forecast_created_at
					cAno			:= SUBSTR(aDados[nB][2],10,4)  						//forecast_description
					cCliente		:= SUBSTR(aDados[nB][8],1,6)   						//customer
					cLoja			:= SUBSTR(aDados[nB][8],8,2)   						//customer
					cProduto		:= PADR(SUBSTR(aDados[nB][9],1,6),15,' ') 			//product
					cMes			:= MESFORECAST(aDados[nB][11]) 						//measure_description
					nQuantidade		:= Val(aDados[nB][12])								//measure_value

					If Empty(dData) .Or. Empty(cAno) .Or. Empty(cCliente) .Or. Empty(cLoja) .Or. Empty(cProduto) .Or. Empty(cMes)
						lValida := .F.
					EndIf

					If lValida
						SZ2->(DbGoTop())
						If SZ2->(DBseek(xFilial('SZ2') + cCliente + cLoja + cProduto + cAno + "F"))
							RecLock("SZ2", .F.)
							nAlt++
						Else
							RecLock("SZ2", .T.)
							nInc++
						EndIf
						SZ2->Z2_FILIAL 			:= xFilial("SZ2")
						SZ2->Z2_PRODUTO			:= cProduto
						SZ2->Z2_CLIENTE			:= cCliente
						SZ2->Z2_LOJA			:= cLoja
						SZ2->Z2_ANO				:= Val(cAno)
						SZ2->Z2_TOPICO			:= "F"
						SZ2->&("Z2_QTM" + cMes)	:= nQuantidade
						SZ2->Z2_DATA			:= dData
						SZ2->Z2_STATUS			:= "A"

						MsUnLock() // Confirma e finaliza a operação
					EndIf
				Next nB
			EndIf

			//Grava histórico
			cSufixo	:= "_" + FWTimeStamp(1) + ".zip"
			nZip 	:= FZip(cDirCSV + cArq + cSufixo , {cDir+cArq})

			If nZip!=0
				conout("Não foi possível criar o arquivo zip")
			Else
				conout("Arquivo zip criado com sucesso")
				FErase(cDir+cArq)
			EndIf
		Next nA
	EndIf

	//Fecha Ambiente
	RPCClearEnv()
Return Nil

Static Function DWLDVBS(cS3Url,cDir,cArquivo)
	//Gera requisição em VBS e faz o download do arquivo.
	cScriptVBS	:= 'strFileURL = "' + cS3Url + '"' + Chr(10)+Chr(13)
	cScriptVBS	+= 'strHDLocation = "' + cDir + cArquivo + '"' + Chr(10)+Chr(13)
	cScriptVBS	+= '	Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")' + Chr(10)+Chr(13)
	cScriptVBS	+= 'objXMLHTTP.open "GET", strFileURL, false' + Chr(10)+Chr(13)
	cScriptVBS	+= 'objXMLHTTP.send()' + Chr(10)+Chr(13)
	cScriptVBS	+= 'If objXMLHTTP.Status = 200 Then' + Chr(10)+Chr(13)
	cScriptVBS	+= 'Set objADOStream = CreateObject("ADODB.Stream")' + Chr(10)+Chr(13)
	cScriptVBS	+= 'objADOStream.Open' + Chr(10)+Chr(13)
	cScriptVBS	+= 'objADOStream.Type = 1 ' + Chr(10)+Chr(13)
	cScriptVBS	+= 'objADOStream.Write objXMLHTTP.ResponseBody' + Chr(10)+Chr(13)
	cScriptVBS	+= 'objADOStream.Position = 0    ' + Chr(10)+Chr(13)
	cScriptVBS	+= 'Set objFSO = CreateObject("Scripting.FileSystemObject")' + Chr(10)+Chr(13)
	cScriptVBS	+= 'If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation' + Chr(10)+Chr(13)
	cScriptVBS	+= 'Set objFSO = Nothing' + Chr(10)+Chr(13)
	cScriptVBS	+= 'objADOStream.SaveToFile strHDLocation' + Chr(10)+Chr(13)
	cScriptVBS	+= 'objADOStream.Close' + Chr(10)+Chr(13)
	cScriptVBS	+= 'Set objADOStream = Nothing' + Chr(10)+Chr(13)
	cScriptVBS	+= 'End if' + Chr(10)+Chr(13)
	cScriptVBS	+= 'Set objXMLHTTP = Nothing' + Chr(10)+Chr(13)

	If MemoWrite(cDir+"DWLDVBS.vbs",cScriptVBS)
		WinExec('cscript "' + cDir + 'DWLDVBS.vbs"')
		Sleep( 50000 )
		FErase(cDir+"DWLDVBS.vbs")
		If File(cDir+cArquivo)
			lRet := .T.
		Else
			lRet := .F.
		EndIf
	EndIf
Return lRet

Static Function MESFORECAST(cMes)
	If cMes == 'JAN'
		cMes := '01'
	ElseIf cMes == 'FEV'
		cMes := '02'
	ElseIf cMes == 'MAR'
		cMes := '03'
	ElseIf cMes == 'ABR'
		cMes := '04'
	ElseIf cMes == 'MAI'
		cMes := '05'
	ElseIf cMes == 'JUN'
		cMes := '06'
	ElseIf cMes == 'JUL'
		cMes := '07'
	ElseIf cMes == 'AGO'
		cMes := '08'
	ElseIf cMes == 'SET'
		cMes := '09'
	ElseIf cMes == 'OUT'
		cMes := '10'
	ElseIf cMes == 'NOV'
		cMes := '11'
	ElseIf cMes == 'DEZ'
		cMes := '12'
	EndIf
Return (cMes)

