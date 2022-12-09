#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FILEIO.CH'
#INCLUDE 'Ap5Mail.ch'
#INCLUDE 'TbiConn.ch'

#DEFINE lMOSTRA_MSG_CONSOLE 	   .F.
#DEFINE cNOME_FONTE 			   'CSFUNCOES.PRW'
#DEFINE cPARAM_CRYPT 			   'PARAM_CRYPT'
#DEFINE cPARAM_CRYPT_DATA 		   'PARAM_CRYPT_DATA'
#DEFINE cPARAM_CAMINHO 			   'PARAM_CAMINHO'
#DEFINE cPARAM_MODO_DEBUG 		   'PARAM_MODO_DEBUG'
#DEFINE cPARAM_SHOW_PENDENTES_V2   'PENDENTES_V2'
#DEFINE cPARAM_VIEW_REL_BH_EXTRATO 'VIEW_REL_BH_EXTRATO'
#DEFINE cPARAM_VIEW_REL_BH_CUSTO   'VIEW_REL_BH_CUSTO'
#DEFINE cPARAM_GERA_LOG_ERRO 	   'GERA_LOG_ERRO'
#DEFINE cPARAM_GERA_LOG_ALERTA 	   'GERA_LOG_ALERTA'
#DEFINE cPARAM_GERA_LOG_INFO 	   'GERA_LOG_INFO'
#DEFINE cPARAM_AREA_RH 	 		   'AREA_RH'
#DEFINE cCRYPT_MASTER 			   'v8yu8ephEspuqe5h'

/*
{Protheus.doc} Json
Converte o arquivo para JSON
@Param String com Nome da Tabela
@Param Array com o nome dos campos
@Param Array com os itens do Array
@Return String
@author David Moraes
@since 22/08/2012
@version 2.01
*/
User function JSON(cJSON, aData, aProp, cObjeto, aTipo)
	Local nLinha  := 1
	Local nArray  := 1
	Local aLinha  := {}
	Local cAux    := ''
	Local cNucleo := ''

	Default aProp   := {}
	Default cJSON   := ''
	Default cObjeto := ''
	Default aTipo   := {0,{}}

	if len(aTipo) == 0
		aTipo := {0,{}}
	endif

	nArray :=  aTipo[1]
	For nLinha := 1 To Len(aData)
		//Registros posicionado
		aLinha := aData[nLinha]
		//O registro eh do tipo array
		if nArray > 0
			cNucleo += ConvText(aLinha)
		else
			if ValType(aLinha) == 'A'
				U_JSON(@cNucleo, aLinha, aProp, '', aTipo[2])
			else
				cNucleo += '"'+aProp[nLinha]+'" : ' + ConvText(aLinha)
			endif
		endif

		if nLinha < Len(aData)
			cNucleo += ','
		EndIf
	Next nLinha

	if nArray > 0
		cAux := '"'+aProp[nArray]+'" : ['+cNucleo+']'
	else
		cAux := '{'+cNucleo+'}'
	endif

	if !Empty(cObjeto)
		cJSON += '{"'+cObjeto+'" : ['+cAux+']}'
	else
		cJSON += cAux
	endif

	cJSON := replace(cJSON, "{{", "{")
	cJSON := replace(cJSON, "}}", "}")

	//u_EnviaLog( 'JSON', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return(cJSON)

/*
{Protheus.doc} MontarSQL
Cria uma tabela temporaria de uma instrucao em SQL
@Param cAlias - Alias para tabela temporaria
@Param @nRec - Numero de registros da tabela temporaria
@Param cQuery - Instrucao SQL
@Param lExeChange - .T. Passa pelo change query .F. Não passa pelo change query
@Return boolean - .T. Gerou tabela temporaria, .F. Nao gerou tabela temporaria
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function MontarSQ(cAlias, nRec, cQuery, lExeChange, lTotaliza)
	Local lRetorno    := .F.
	Local cAliasTotal := getNextAlias()
	Local cQueryConta := ''

	Default nRec       := 0
	Default lExeChange := .T.
	Default lTotaliza  := .T.

	//Monta tabela temporaria conforme query pre formatada
	if lExeChange
		cQuery := ChangeQuery(cQuery)
		if TCGetDB() == 'MSSQL'
			cQuery := replace(cQuery, 'SUBSTR(', 'SUBSTRING(')
		endif
	EndIf

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAlias, .F., .T.)

	//Verifica se ha dados na tabela temporaria

	if select( cAlias ) > 0
		( cAlias )->(dbGoTop())
		if ( cAlias )->(!EoF())
			if lTotaliza
				if TCGetDB() == 'MSSQL'
					//No MSQSQL não aceita order by dentro de um subselect com Count(*)
					Count To nRec
					( cAlias )->(dbGoTop())
					if nRec > 0
						lRetorno := .T.
					endif
				else
					cQueryConta :=' SELECT COUNT(*) COUNT FROM ( ' + cQuery + ' ) QUERY '
					if lExeChange
						cQueryConta := ChangeQuery(cQueryConta)
					EndIf
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQueryConta), cAliasTotal, .F., .T.)
					nRec := (cAliasTotal)->COUNT
					(cAliasTotal)->(DbCloseArea())
					lRetorno := .T.
					( cAlias )->(dbGoTop())
				endif
			else
				lRetorno := .T.
			endIf
		else
			( cAlias )->(dbCloseArea())
		endif
	endif

	//u_EnviaLog( 'MontarSQ', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return(lRetorno)

/*
{Protheus.doc} GerarArq
Cria arquivo texto
@Param cTexto - Texto para gerar aquivo texto.
@Param cCaminho - Caminho mais nome do arquivo texto
@Param lCriaDir - .T. Cria diretorio caso nao exista, .F. Não cria diretorio
@Param lApaga - .T. Apaga registro caso exista, .F. Não apaga registro e escreve na ultima linha
@Param nDeslocamento - Desloca do final para o começo os numero de bytes passados por esse parametro
@Return boolean - .T. Gerou arquivo texto, .F. Nao gerou arquivo texto
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function GerarArq(cTexto, cCaminho, lCriaDir, lApaga, nDeslocamento)
	Local lRetorno 		  := .F.				//Retorno da funcao
	Local nHandle  		  := 0                 //Handle de onde com o arquivo texto
	local cErro1   := ""
	local cErro2   := ""

	Default nDeslocamento := 0
	Default lCriaDir 	  := .F.
	Default lApaga   	  := .F.

	if lCriaDir
		U_CriarDir(cCaminho)
	EndIf

	if lApaga
		FERASE(cCaminho)
	EndIf

	//Verifica se o arquivo texto existe
	if !File( cCaminho )
		//Cria o arquivo texto
		nHandle := MsFCreate( cCaminho )
		if nHandle == -1
			//Caso de erro ao criar arquivo texto
			U_ConsoleL('Erro ao criar arquivo', {"handle", nHandle}	, "", cErro1, cErro2, cNOME_FONTE, procName())
			fCLose(nHandle)
			Return(lRetorno)
		EndIf
	Else
		//Posiciona na ultima linha do arquivo texto
		nHandle := fOpen( cCaminho, FO_WRITE )
		nTot := fSeek(nHandle, nDeslocamento, FS_END)
	EndIf

	//Inclui log  e fecha o arquivo texto
	fWrite( nHandle, cTexto+Chr(13)+Chr(10) )
	fClose( nHandle )
	lRetorno := .T.

	//u_EnviaLog( 'GerarArq', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return(lRetorno)

/*
{Protheus.doc} CriarDir
Cria diretorios e subdiretorios conforme parametro
@Param cCaminho - Caminho mais nome do arquivo
@Return boolean - .T. Criou diretorio, .F. Nao criou diretorio
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function CriarDir(cCaminho)
	Local nPos   := 0
	Local cAux	 := SubString(cCaminho, 1,3)
	Local cTexto := Right(cCaminho, Len(cCaminho)-3)

	While At( '\' , cTexto) > 0
		nPos :=	At( '\' , cTexto)
		cAux += SubString(cTexto, 1, nPos)
		cTexto := Right(cTexto, Len(cTexto)-nPos)
		if !ExistDir(cAux)
			MakeDir(cAux)
		End If
	End

	//u_EnviaLog( 'CriarDir', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return()

/*
{Protheus.doc} ListaDir
Retorna um lista com a arvore de diretorios e arquivos.
@Param aDirectory - Array para retorno da arvore de diretorios e aquivos
@Param cDir - Diretorio raiz
@Return boolean - .T. Arvore de diretorios lidos, .F. Arvore de diretorios nao lidos
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function ListaDir(aDirectory, cDir)
	Local aAuxDir	:= {} 	//Array auxiliar para carregar os diretorios
	Local nI 		:= 1 	//Contador utilzado no laço de repeticao
	Local nX        := 1	//Contador utilzado no laço de repeticao
	Local nTotDir   := 0 	//Total de diretorios encontrados
	Local cTipoArq  := ''
	Local nSufixo   := ''
	Local lRetorno  := .F.

	//Retorna todos os diretorios passados no caminho
	aAuxDir := Directory(cDir+'\*.*', 'D')
	//oProcess:SetRegua1( Len(aAuxDir) )
	For nI := 1 To Len(aAuxDir)
		//oProcess:IncRegua1( 'Dir(' + AllTrim(Str(nI))+'/'+AllTrim(Str(Len(aAuxDir)))+')' )
		if At(".",aAuxDir[nI,1]) == 0
			aADD(aDirectory, Replace(cDir + '\' + aAuxDir[nI,1] + '\', '\\','\'))
		EndIf
	Next nI

	//Retorna o total de diretorios encontrados
	nTotDir := Len(aDirectory)

	//Retorna todos os subdiretorios
	nI := 1
	While nI <= nTotDir
		aSubDir := Directory(aDirectory[nI] + '\*.*', 'D')
		nSubDAdd := 0
		//oProcess:SetRegua1( Len(aSubDir) )
		//oProcess:IncRegua1( AllTrim(aDirectory[nI] ) )
		For nX := 1 To Len(aSubDir)
			//oProcess:SetRegua2( Len(aSubDir[nX]) )
			cTipoArq := aSubDir[nX,5]
			nSufixo  := At('.',aSubDir[nX,1])
			if (cTipoArq $ 'D/AD') .And. (nSufixo == 0)
				cPath := aDirectory[nI] + AllTrim(aSubDir[nX,1]) + '\'
				cPath := Replace(cPath, '\\','\')
				//oProcess:IncRegua2( AllTrim(aDirectory[nI] + AllTrim(aSubDir[nX,1]) + '\') )
				if aScan(aDirectory, cPath) <= 0
					aADD(aDirectory, cPath)
					nTotDir++
					lRetorno  := .T.
				EndIf
			EndIf
		Next nX
		nI++
	EndDo

	//Indico o mesmo diretorico como local de pesquisa.
	aADD(aDirectory, cDir + '\')

	//u_EnviaLog( 'ListaDir', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return(.T.)

/*
@author Bruno Vilas Boas Nunes
@since 25/08/2011
@version P10
@Param  1 - _oGetArq:  Objeto de tela.
2 - _cDir: Caminho escolhido.
@Return Nenhum
@obs
Rotina com objetivo de escolher o diretorio correpondente ao campo.
Alteracoes Realizadas desde a Estruturacao Inicial
Programador     Data       Motivo
*/
User Function EscDiret( _oGetArq, _cDir )
	Local _cStartDir := IIf( Empty( _cDir ), 'SERVIDOR', IIf( ! ':' $ _cDir, 'SERVIDOR' + _cDir , _cDir ) )

	_cDir := AllTrim( cGetFile( '', 'Selecione Diretório', 0, _cStartDir, .F.,  GETF_ONLYSERVER +GETF_LOCALHARD+ GETF_RETDIRECTORY ) )
	//GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY
	//_oGetArq:Refresh()

	//u_EnviaLog( 'EscDiret', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return( Nil )

/*
{Protheus.doc} LerArqTxt
Funcao para leitura de arquivo texto
@Param cCaminho - Caminho + nome do arquivo texto
@Param aLinha - Array para retorno das linhas do arquivo texto
@Param lVisual - Se esta utilizando interface visual
@Return boolean - .T. Lido o arquivi texto, .F. Não lido arquivo texto
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function LerArqTx(cCaminho, aLinha, lVisual)
	Local lRetorno  := .F.				//Retorno da funcao
	Local nHandle   := 0                 //Handle de onde com o arquivo texto
	Local nLinha    := 0
	Local cLinha    := ''

	default lVisual := .T.

	//Verifica se o arquivo texto existe
	if File( cCaminho )
		// Abre o arquivo
		nHandle := FT_FUse(cCaminho)

		// Se houver erro de abertura abandona processamento
		if nHandle = -1
			if lVisual
				return (Alert('Erro ao abrir o arquivo - '+cCaminho))
			else
				return u_ConsoleL('Erro ao abrir o arquivo - '+cCaminho)
			endif
		endif

		nTotLinha := FT_FLastRec()

		ProcRegua(nTotLinha)

		//Posiciona na primeria linha
		FT_FGoTop()

		While !FT_FEOF()
			cLinha  := FT_FReadLn() // Retorna a linha corrente
			nLinha++

			if lVisual
				IncProc("Lendo arquivo texto: " + StrZero(nLinha,6)+"/"+StrZero(nTotLinha,6))
			endif

			aAdd(aLinha,	cLinha)
			// Pula para próxima linha
			FT_FSKIP()
			lRetorno  := .T.
		End

		// Fecha o Arquivo
		FT_FUSE()
	Else
		if lVisual
			Alert('Arquivo não encontrato.')
		endif
	End If

	//u_EnviaLog( 'LerArqTx', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return(lRetorno)

/*
{Protheus.doc} ConsoleL
Funcao para retornar em string qualquer tipo de variavel
@Param cMsg - Titulo da mensagem
@Param oVar - Conteudo das variaveis
@Param tipoLog - Tipo do log - Info / Alerta / Erro
@Param cArquivo - Complemento do arquivo
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function ConsoleL(cMsg, oVar, cArquivo, cErro1, cErro2, cFonteOri, cFuncao)
	Local cHTML 	:= ""
	Local cCaminho 	:= ""
	local nHandle 	:= 0
	local oJItem 	:= jsonObject():new()
	local oJLog 	:= jsonObject():new()
	local cBody 	:= ""

	Default cMsg 		:= ''
	Default oVar 		:= Nil
	Default cArquivo 	:= 'log'
	Default cErro1 		:= ""
	Default cErro2 		:= ""
	Default cFonteOri   := ""
	default cFuncao     := ""

	cBody := alltrim( varInfo( "Detalhe:" , oVar, 1 , .T. , .F. ) )

	oJItem['data']     := dtoc(msDate())
	oJItem['hora'] 	   := time()
	oJItem['fonte']    := cFonteOri
	oJItem['funcao']   := cFuncao
	oJItem['detalhe']  := cBody
	oJItem['erro1']    := cErro1
	oJItem['erro2']    := cErro2

	if empty(cArquivo)
		cArquivo := 'log'
	endif
	cCaminho := '\ponto_eletronico\log\'+cArquivo+"_"+cFuncao+"_"+dtos( msDate() )+'.json'

	if !File( cCaminho )
		//Cria o arquivo texto
		nHandle := MsFCreate( cCaminho )
		oJLog := { oJItem }

	else
		//cFile   := memoRead( cCaminho )
		fErase( cCaminho )
		nHandle := MsFCreate( cCaminho )

		//FWJsonDeserialize(cFile, @oAux)
		oJLog := { oJItem }
	endif

	cHTML := FWJsonSerialize(oJLog,.T.,.T.)

	if nHandle != -1
		FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
		FWrite(nHandle, cHTML)     // Insere texto no arquivo
		fclose(nHandle)                   // Fecha arquivo
	Endif

Return(Nil)

/*
{Protheus.doc} ConvText
Funcao para retornar em string qualquer tipo de variavel
@Param oVariavel - Variavel de qualquer tipo
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function ConvText(oVariavel)
	Local cRetorno 	:= ''
	Local cAux 		:= ''

	if ValType(oVariavel) == "C"
		cRetorno 	:= '"'+alltrim(spednoacento(oVariavel))+'"'
	Elseif ValType(oVariavel) == "N"
		cRetorno 	:= cValToChar(oVariavel)
	Elseif ValType(oVariavel) == "D"
		cAux 		:= 	DTOS(oVariavel)
		cRetorno 	:= '"'+substr(cAux, 7, 2)+'/'+substr(cAux, 5, 2)+'/'+substr(cAux, 1, 4)+'"'
	Elseif ValType(oVariavel) == "L"
		cRetorno 	:= IF(oVariavel, '"true"' , '"false"')
	Elseif ValType(oVariavel) == "U"
		cRetorno 	:= '""'
	EndIf

	//u_EnviaLog( 'ConvText', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return(cRetorno)

/*
{Protheus.doc} ParamPtE
Funcao para montar variaveis para criptografia
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function ParamPtE()
	Local lRetorno 	:= .F.
	Local cDtString := dtos(MsDate())
	local cFile     := memoRead( '\ponto_eletronico\pontoEletronico2.dll' )
	local oJson 	:= nil
	local aInfo	  := {}
	local aErro	  := {}
	local aAlerta := {}

	if GetGlbValue(cPARAM_CRYPT_DATA) != cDtString
		ClearGlbValue(cPARAM_CRYPT)
		ClearGlbValue(cPARAM_CAMINHO)
		ClearGlbValue(cPARAM_CRYPT_DATA)
		ClearGlbValue(cPARAM_MODO_DEBUG)
		ClearGlbValue(cPARAM_VIEW_REL_BH_EXTRATO)
		ClearGlbValue(cPARAM_VIEW_REL_BH_CUSTO)
		aAdd(aAlerta, {'Cryptografia resetada devido a datas divergentes.', {cDtString, GetGlbValue(cPARAM_CRYPT_DATA)}} )
	endif

	if Empty(GetGlbValue(cPARAM_CRYPT)) .Or. Empty(GetGlbValue(cPARAM_CAMINHO))
		//cCaminho := '\ponto_eletronico\pontoEletronico.dll'
		if FWJsonDeserialize(cFile, @oJson)
			PutGlbValue( cPARAM_CRYPT  			 	 , left(FWAES_encrypt( Embaralha( oJson['criptografia']+cDtString, 0 ),  cCRYPT_MASTER ), 16) )
			PutGlbValue( cPARAM_CAMINHO			 	 , oJson['urldefault'] )
			PutGlbValue( cPARAM_CRYPT_DATA		 	 , cDtString )
			PutGlbValue( cPARAM_MODO_DEBUG		 	 , oJson['mododebug'])
			PutGlbValue( cPARAM_SHOW_PENDENTES_V2	 , oJson['aprovacaov2'])
			PutGlbValue( cPARAM_GERA_LOG_ERRO	 	 , oJson['geralogerro'])
			PutGlbValue( cPARAM_GERA_LOG_ALERTA		 , oJson['geralogalerta'])
			PutGlbValue( cPARAM_GERA_LOG_INFO	 	 , oJson['geraloginfo'])
			PutGlbValue( cPARAM_AREA_RH	 		 	 , oJson['arearh'])
			PutGlbValue( cPARAM_VIEW_REL_BH_EXTRATO	 , oJson['acessorelatorio_bh_extrato'])
			PutGlbValue( cPARAM_VIEW_REL_BH_CUSTO	 , oJson['acessorelatorio_bh_custo'])

			aAdd( aInfo, {'Gerado novo código de Cryptografia.', {cDtString, oJson} } )
		else
			aAdd( aErro, 'Arquivo de configuração de cryptografica não esta na pasta: ponto_eletronico\pontoEletronico.dll' )
		endif
	endif

	//if !//u_EnviaLog('User Function ParamPtE()', aErro, aAlerta, aInfo)
		lRetorno := .T.
	//endif

	//u_EnviaLog( 'ParamPtE', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return(lRetorno)

/*
{Protheus.doc} CrypCsPE
Funcao de criptografia do portal do ponto
@Param lCrypt - .T., criptografa string,  .F. descriptografa string
@Param cConteudo - String para criptografar ou descriptografar
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function CrypCsPE(lCrypt, cConteudo)
	Local cCrypt 	:= ''
	Local cRetorno 	:= ''
	local aErro	  := {}

	default lCrypt 	:= .T.

	if empty(cConteudo)
		aAdd(aErro, {'Conteúdo da cryptografica está vazio.', cConteudo})
	else
		if u_ParamPtE()
			cCrypt := GetGlbValue(cPARAM_CRYPT)
			if !empty(cCrypt)
				/*
				if lCrypt
				cRetorno := Encode64( FWAES_encrypt( cConteudo,  cCrypt )  )
				else
				cRetorno := FWAES_decrypt( Decode64( cConteudo ) ,  cCrypt )
				endif
				*/
				cRetorno := cConteudo
			else
				aAdd(aErro, {'Chave da cryptografia esta vazia', cCrypt})
			endif
		endif
	endif

	//if //u_EnviaLog('User Function CrypCsPE(lCrypt, cConteudo)', aErro, aAlerta, aInfo)
		//cRetorno := ''
	//endif

	//u_EnviaLog( 'CrypCsPE', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return(cRetorno)

/*
{Protheus.doc} ModoDebug
Funcao que prepara os dados para enviar para rotina de gerar log o
erro, alerta ou informação sobre a rotina que esta em processamento
@Param lDebug - .T., esta debugando com ambiente pelo IDE,  .F. Nao inicia ambiente
@Param lLogin - .T., inicia ambiente, .F. Finaliza ambiente
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function ModoDebu(lDebug, lLogin)
	default lDebug := .F.
	default lLogin := .F.

	if lDebug
		if lLogin
			rpcSetType(3)
			PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'
		else
			RESET ENVIRONMENT
		endif
	Endif

	//u_EnviaLog( 'ModoDebu', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
return()

/*
{Protheus.doc} //u_EnviaLog
Funcao que prepara os dados para enviar para rotina de gerar log o
erro, alerta ou informação sobre a rotina que esta em processamento
@Param cTitulo - Titulo do log
@Param aErro - Array com dados que deverão ser considerados como erro
@Param aAlerta - Array com dados que deverão ser considerados com aviso
@Param aInfo - Array com dados que deveraõ ser considerados como informação
@Param cIdLog - complemento do nome do arquivo do log
@Return Booleana - .T. Array de erros não esta vazio, .F. Array de erros esta vazio
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function EnviaLog(cTitulo, aErro, aAlerta, aInfo, cIdLog, cErro1, cErro2, cFonteOri, cFuncao)
	Local lRetorno := .F.

	Default cTitulo 	:= ""
	Default aErro 		:= {}
	Default aAlerta 	:= {}
	Default aInfo		:= {}
	Default cIdLog  	:= ""
	Default cErro1		:= ""
	Default cErro2		:= ""
	Default cFonteOri  	:= ""
	default cFuncao 	:= ""

	lRetorno := Len(aErro) > 0
	if  lRetorno .and. GetGlbValue(cPARAM_GERA_LOG_ERRO) == "1"
		U_ConsoleL('<strong>Rotina: </strong>'+cTitulo, aErro	, "ERRO_"+cIdLog, cErro1	, cErro2, cFonteOri, cFuncao )
	endif
	if Len(aAlerta) > 0 .and. GetGlbValue(cPARAM_GERA_LOG_ALERTA) == "1"
		U_ConsoleL('<strong>Rotina: </strong>'+cTitulo, aAlerta	, "ALERTA_"+cIdLog, cErro1	, cErro2, cFonteOri, cFuncao )
	endif
	if Len(aInfo) > 0 .and. GetGlbValue(cPARAM_GERA_LOG_INFO) == "1"
		U_ConsoleL('<strong>Rotina: </strong>'+cTitulo, aInfo	, "INFO_"+cIdLog, cErro1	, cErro2, cFonteOri, cFuncao )
	endif
Return(lRetorno)


/*
{Protheus.doc} Versao
Monta um arquivo texto com a data e hora de compilação do arquivos, usado para auditoria
@author Bruno Nunes
@since 07/01/2019
@version 2.01
*/
User function Versao()
	local aFontes 	 := {}
	local aArquivos  := {}
	local i 		 := 0
	local aData 	 := {}
	local cLinha	 := ""
	local aLinha     := {}
	local cQuebra 	 := ' +--------------------------------------------------------------+----------------------+----------------------+----------------------+----------------------+------------------------------------------+'
	local lEncontrou := .F.

	//+-------------------------------------------------------------------------------------+
	//|GetAPOInfo                                                                           |
	//+----------+--------------------------------------------------------------------------+
	//| aData[1] | Nome do fonte                                                            |
	//| aData[2] | Linguagem do fonte. Exemplo: AdvPL, 4GL, ...                             |
	//| aData[3] | Modo de Compilação                                                       |
	//| aData[4] | Data da última modificação do arquiv                                     |
	//| aData[5] | Hora, minutos e segundos da última modificação realizada no arquivo      |
	//+----------+--------------------------------------------------------------------------+
	//|                                                                                     |
	//+---------------------+---------------------------------------------------------------+
	//| 0 - BUILD_FULL 	   | Usuário tem permissão para compilar qualquer tipo de fonte    |
	//| 2 - BUILD_PARTNER   | Permissão de compilação da Fábrica de Software TOTVS          |
	//| 3 - BUILD_PATCH 	   | Aplicação de Patch                                            |
	//| 1 - BUILD_USER 	   | Usuário só pode compilar User Functions                       |
	//+---------------------+---------------------------------------------------------------+

	u_ModoDebug(.T., .T.)

	aAdd( aFontes, { 'CsFuncoes.prw'				, '23/10/2017', '17:18' } )
	aAdd( aFontes, { 'CsRh010.prw' 					, '23/10/2017', '16:41' } )
	aAdd( aFontes, { 'CsRh030.prw' 					, '30/06/2017', '14:19' } )
	aAdd( aFontes, { 'CsRh040.prw' 					, '30/06/2017', '14:19' } )
	aAdd( aFontes, { 'CsRh050.prw' 					, '30/06/2017', '14:19' } )
	aAdd( aFontes, { 'CsRh070.prw' 					, '28/08/2017', '15:12' } )
	aAdd( aFontes, { 'CsRhAjax.prw' 				, '15/08/2017', '16:46' } )
	aAdd( aFontes, { 'fCrgPB7.prw' 					, '30/06/2017', '14:19' } )
	aAdd( aFontes, { 'fRestPB7.prw'					, '30/06/2017', '14:19' } )
	aAdd( aFontes, { 'fRestPon.prw' 				, '04/08/2017', '11:50' } )
	aAdd( aFontes, { 'fRstPCB7.prw' 				, '30/06/2017', '14:19' } )
	aAdd( aFontes, { 'GP180TRA.prw' 				, '30/06/2017', '14:19' } )
	aAdd( aFontes, { 'PNA130GRV.prw' 				, '30/06/2017', '14:19' } )
	aAdd( aFontes, { 'PNM090END.prw' 				, '30/06/2017', '14:19' } )
	aAdd( aFontes, { 'PONAPO2.prw' 					, '28/08/2017', '15:06' } )
	aAdd( aFontes, { 'PONCALM.prw' 					, '30/06/2017', '14:19' } )
	aAdd( aFontes, { 'CsWsPortalPonto.prw'			, '25/08/2017', '17:23' } )
	aAdd( aFontes, { 'Client_CsWsPortalPonto.prw'	, '24/07/2017', '15:51' } )

	aAdd( aArquivos, { '\web\pp\ponto_eletronico\administrador.htm' 			, '12/08/2016', '13:52' } )
	aAdd( aArquivos, { '\web\pp\ponto_eletronico\aprovador.htm' 				, '15/08/2017', '18:15' } )
	aAdd( aArquivos, { '\web\pp\ponto_eletronico\default.htm' 					, '30/06/2017', '15:19' } )
	aAdd( aArquivos, { '\web\pp\ponto_eletronico\indicador.htm' 				, '01/09/2016', '16:09' } )
	aAdd( aArquivos, { '\web\pp\ponto_eletronico\lista_periodo.htm' 			, '15/08/2017', '17:00' } )
	aAdd( aArquivos, { '\web\pp\ponto_eletronico\log.htm' 						, '12/08/2016', '13:52' } )
	aAdd( aArquivos, { '\web\pp\ponto_eletronico\marcacao.htm' 					, '07/08/2017', '19:21' } )
	aAdd( aArquivos, { '\web\pp\ponto_eletronico\scripts\ponto_eletronico.js'	, '15/08/2017', '18:20' } )

	//Monta fontes compilados
	aAdd(aLinha, cQuebra)
	cLinha	:= ' | '+PadR( 'Fonte' , 60, ' ')
	cLinha	+= ' | '+PadR( 'Data do Fonte' , 20, ' ')
	cLinha	+= ' | '+PadR( 'Hora do Fonte' , 20, ' ')
	cLinha	+= ' | '+PadR( 'Data da Compilação' , 20, ' ')
	cLinha	+= ' | '+PadR( 'Hora da Compilação' , 20, ' ')
	cLinha	+= ' | '+PadR( 'Status', 40, ' ')
	cLinha	+= ' | '
	aAdd(aLinha, cLinha)
	aAdd(aLinha, cQuebra)
	//aData := GetFuncArray('GetAPOInfo', @aType, @aFile, @aLine, @aDate, @aTime)
	for i := 1 to len(aFontes)
		aData := GetAPOInfo(aFontes[i,1])
		if len(aData) > 0
			lEncontrou := .T.
		else
			lEncontrou := .F.
		endif
		cLinha := MontaLinha(aFontes[i], aData[4], aData[5], lEncontrou)
		aAdd(aLinha, cLinha)
	next i
	for i := 1 to len(aArquivos)
		aData := DIRECTORY(aArquivos[i,1])
		if len(aData) > 0
			cLinha  := MontaLinha(aArquivos[i], aData[1][3], aData[1][4], .T.)
		else
			cLinha  := MontaLinha(aArquivos[i], ctod('//'), '', lEncontrou)
		endif

		aAdd(aLinha, cLinha )
	next i
	aAdd(aLinha, cQuebra)

	cLinha := ''
	for i:= 1 to len(aLinha)
		cLinha += aLinha[i]+CRLF
	next
	u_GerarArq(cLinha, 'c:\temp\versao_portal_ponto.txt', .T., .T.)

	ModoDebug(.T., .F.)

	//u_EnviaLog( 'Versao', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return

/*
{Protheus.doc} MontaLinha
Rotina auxiliar da funcao versao
@author Bruno Nunes
@since 07/01/2019
@version 2.01
*/
Static Function MontaLinha(aArquivos, dCompilada, cTempo, lEncontrou)
	local cRetorno 	:= ''
	local cAux 		:= ''

	cRetorno := ' | '+PadR( aArquivos[1], 60, ' ')
	cRetorno += ' | '+PadR( aArquivos[2], 20, ' ')
	cRetorno += ' | '+PadR( aArquivos[3], 20, ' ')
	if lEncontrou
		cRetorno += ' | '+PadR( dtoc(dCompilada), 20, ' ')
		cRetorno += ' | '+PadR( left(cTempo,5), 20, ' ')
		cAux := ''
		if ctod(aArquivos[2]) != dCompilada
			cAux +=  PadR( 'Datas divergentes' , 20, ' ')
		endif
		if aArquivos[3] != left(cTempo,5)
			if !empty(cAux)
				cAux += ' - '
			endif
			cAux +=  PadR( 'Horas divergentes', 20, ' ')
		endif
		if empty(cAux)
			cAux := 'Ok'
		endif
	else
		cRetorno += ' | '+PadR( 'Não encontrado', 20, ' ')
		cRetorno += ' | '+PadR( 'Não encontrado', 20, ' ')
	endif
	cRetorno += ' | '+PadR( cAux, 40, ' ')+' | '

	//u_EnviaLog( 'MontaLinha', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return cRetorno

/*
{Protheus.doc} LerArqBy
Rotina auxiliar da ler arquivo e converter em base64
@author Bruno Nunes
@since 07/01/2019
@version 2.01
*/
User Function LerArqBy(cCaminho, cBin)
	Local lRetorno  := .F.				//Retorno da funcao
	Local nHandle   := 0                 //Handle de onde com o arquivo texto
	Local nLength := 0

	//Verifica se o arquivo texto existe
	if File( cCaminho )

		nHandle := fopen(cCaminho , FO_READWRITE  )
		if nHandle == -1
			MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
		Else
			//MsgStop('Arquivo aberto com sucesso.')
			nLength := FSEEK(nHandle, 0, FS_END)
			// Posiciona no início do arquivo
			FSEEK(nHandle, 0)

			FRead( nHandle, @cBin, nLength )

			//cBin  :=  MemoRead( cCaminho )
			cBin  :=  Encode64( cBin  )
			//conout(cBin)

			lRetorno := .T.
			fclose(nHandle) // Fecha arquivo
		Endif
	Else
		Alert('Arquivo não encontrato.')
	End If

	//u_EnviaLog( 'LerArqBy', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
Return(lRetorno)

/*
{Protheus.doc} qryToArr
Executa query
@author Bruno Nunes
@since 07/01/2019
@version 2.01
*/
user function qryToArr( cQuery )
	local aAux 		 := {}
	local aCampos	 := {}
	local aLista 	 := {}
	local cAlias     := getNextAlias()
	local i 		 := 0
	local lExeChange := .T.
	local nRec       := 0

	default cQuery   := ""

	if empty(cQuery)
		return aLista
	endif

	if U_MontarSQL( cAlias, @nRec, cQuery, lExeChange )
		aCampos := ( cAlias )->( DBStruct() )

		while ( cAlias )->( !EoF() )
			aAux := {}
			for i := 1 to len( aCampos )
				aAdd( aAux, aCampos[i][1] )
			next i
			aAdd( aLista, aAux )
			(cAlias)->(dbSkip())
		end
		(cAlias)->(dbCloseArea())
	endif

	//u_EnviaLog( 'qryToArr', aErro, aAlerta, aInfo, "", cErro1, cErro2, cNOME_FONTE, procName() )
return aLista

user function csTamArq( cFile )
	local nRet := 0
	local aFile := {}
	
	default cFile := ""
	
	if !empty( cFile )
		aFile := Directory( cFile )
		nRet  := iif( len( aFile ) > 0, aFile[1][2], 0 ) //tamanho do arquivo
	endif
return nRet