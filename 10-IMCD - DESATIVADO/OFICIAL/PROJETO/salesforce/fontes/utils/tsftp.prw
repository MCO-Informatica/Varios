#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"

#DEFINE AUTH "Authenticated."								// String que indica que ocorreu a autenticacao com sucesso.
#DEFINE INILOG "confirm         off"						// String que indica o inicio do log
#DEFINE ERRDWL1 "Error changing directory to"				// String que indica erro 1 ao realizar download/upload de arquivos
#DEFINE ERRDWL2 "System Error.  Code: 2"					// String que indica erro 2 ao realizar download/upload de arquivos
#DEFINE ERRDWL3 "Error code: 2"								// String que indica erro 3 ao realizar download/upload de arquivos
#DEFINE ERRLST1 "Error listing directory"					// String que indica erro 1 ao realizar listagem de uma pasta

//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TSFTP
Classe responsavel por realizar a comunicacao atraves de SFTP utilizando o aplicativo WinSCP em linha de comando
@author marcio.katsumata
@since 22/07/2019
@version 1.0
@attrib cServer Endereco do servidor e porta se for necessario. Ex: 172.16.36.155:2222
@attrib cUsuario Usuario de acesso ao servidor SFTP informado
@attrib cSenha Senha de acesso ao servidor SFTP informado
@attrib cHostKey Chave de acesso solicitada pelo protocolo SSH
@attrib cWinSCP Diretorio fisico onde o WinSCP estah localizado
@attrib cDirWinSCP Diretorio onde o WinSCP estah localizado
@attrib cDWSCPSrv	Diretorio no servidor Protheus onde o WinSCP estah localizado
@attrib cArqBat Arquivo bat especifico a ser criado e utilizado para a instancia da classe
@attrib cArqLog Arquivo de log a ser gerado pela execucao do arquivo .bat
@attrib lUsaProxy Indica se deve utilizar proxy para conectar ou nao
@attrib cTipoProxy Tipo do proxy
@attrib cProxy Endereco do proxy
@attrib cPortProxy Porta para comunicao com o Proxy
@attrib cUsrProxy Usuario para acessar ao proxy
@attrib cPswProxy	Senha para acessar ao proxy
/*/
//--------------------------------------------------------------------------------------------------------------

CLASS TSFTP

	// Atributos
	DATA cServer		// Endereco do servidor e porta se for necessario. Ex: 172.16.36.155:2222
	DATA cUsuario		// Usuario de acesso ao servidor SFTP informado
	DATA cSenha		// Senha de acesso ao servidor SFTP informado
	DATA cHostKey		// Chave de acesso solicitada pelo protocolo SSH
	DATA cWinSCP		// Diretorio onde o WinSCP + arquivo executavel estah localizado
	DATA cDirWinSCP	// Diretorio fisico onde o WinSCP estah localizado
	DATA cDWSCPSrv	// Diretorio no servidor Protheus onde o WinSCP estah localizado
	DATA cArqBat		// Arquivo bat especifico a ser criado e utilizado para a instancia da classe
	DATA cArqLog		// Arquivo de log a ser gerado pela execucao do arquivo .bat
	DATA lUsaProxy	// Indica se deve utilizar proxy para conectar ou nao 
	DATA cTipoProxy	// Tipo do proxy
	DATA cProxy		// Endereco do proxy
	DATA cPortProxy	// Porta para comunicao com o Proxy
	DATA cUsrProxy	// Usuario para acessar ao proxy
	DATA cPswProxy	// Senha para acessar ao proxy	
	
	// Métodos
	METHOD New() CONSTRUCTOR						// Metodo construtor da classe
	METHOD TstConnect()							// Metodo que identifica se eh possivel conectar com os atributos preenchidos
	METHOD Listar(cDir)							// Metodo para listar os arquivos contidos na pasta informada
	METHOD Upload(cDirOri, cArq, cDirDest)		// Metodo para realizar o upload do arquivo para a pasta informada
	METHOD Download(cDirOri, cArq, cDirDest)	// Metodo para realizar o download do arquivo para a pasta informada
	METHOD Move(cDirOri, cArq, cDirDest)		// Metodo para mover arquivos entre as pastas no servidor SFTP
	METHOD WinSCP()								// Metodo para tornar disponivel o WinSCP no diretorio informado no parametro FS_WINSCP
	METHOD Authentic()							// Metodo que retorna se ocorreu a autenticacao
	METHOD ClearArq()								// Metodo para limpar o arquivo de log e o arquivo de comandos
	METHOD LerLog()								// Metodo para ler o arquivo de log
	METHOD MontaLista(cLog)						// Metodo que recebe o conteudo do log e monta a listagem dos arquivos obtidos com o comando ls
	METHOD DelArq(cArq, cDir)					// Metodo para apagar o arquivo localizado na pasta indicada no servidor SFTP
	//TODO:: Desenvolver a implementacao do metodo destrutor que apaga os arquivos de bat apos a sua execucao
	//METHOD Destroy()								// Metodo destrutor da classe

END CLASS

//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TSFTP
Metodo construtor da classe
@author marcio.katsumata
@since 22/07/2019
@version 1.0
@return SELF Objeto criado
/*/
//--------------------------------------------------------------------------------------------------------------

METHOD New() CLASS TSFTP
Local cPathPD	:= GetSrvProfString("ROOTPATH","")
::cServer		:= ""
::cUsuario		:= ""
::cSenha		:= ""
::cHostKey		:= ""
::cWinSCP		:= SELF:WinSCP(1)
::cDirWinSCP	:= Substr(::cWinSCP,1,RAt("\", ::cWinSCP))								// Somente o diretorio sem o nome do arquivo
::cDWSCPSrv	    := strtran(	::cDirWinSCP,cPathPD,"")																// Diretorio no Protheus_Data sem o nome do arquivo
::cArqBat		:= "WinSCP" + DToS(Date()) + StrTran(Time(), ":", "") + ".bat"
::cArqLog		:= "WinSCP" + DToS(Date()) + StrTran(Time(), ":", "") + ".log"
::lUsaProxy	:= .F. 
::cTipoProxy	:= ""
::cProxy		:= ""
::cPortProxy	:= ""
::cUsrProxy	:= ""
::cPswProxy	:= ""

Return SELF

//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TstConnect
Metodo que identifica se eh possivel conectar com os atributos preenchidos
@author marcio.katsumata
@since 22/07/2019
@version 1.0
@return lRet .T.=Eh possivel conectar, .F.=Nao eh possivel conectar
/*/
//-------------------------------------------------------------------------------------------------------------------------

METHOD TstConnect() CLASS TSFTP

Local lRet 	:= .F.		// Retorno do metodo indicado se eh possivel conectar no servidor com os atributos informados
Local cAcao	:= ""		// Comandos a serem executados atraves do arquivo batch
Local cProxy	:= ""		// String com as intrucoes do proxy para acesso do servidor

// Limpar o arquivo de comandos e de log antes de executar o novo
SELF:ClearArq()

If ::lUsaProxy

	cProxy :=	' -rawsettings "' + ;
				' ProxyMethod=' + ::cTipoProxy + ;
				' ProxyHost=' + ::cProxy + ;
				Iif(!Empty(::cPortProxy), ' ProxyPort=' + ::cPortProxy, "") + ;
				Iif(!Empty(::cUsrProxy), ' ProxyUsername=' + ::cUsrProxy, "") + ;
				Iif(!Empty(::cPswProxy), ' cPswProxy=' + ::cPswProxy, "") + ;
				' " '

Endif

// Montar o comando para realizar a operacao 
cAcao	:=	'"' + ::cWinSCP + '"' + ;															// Chamada do programa que estah no arquivo executaval
			' /command "open ' + ::cUsuario + ':' + ::cSenha + '@' + ::cServer + ;		// Executar o comando de conexao com servidor SFTP
			' -hostkey=""' + ::cHostKey + '"" ' + ;											// Informar o HostKey para tornar automatica a conexao			
			Iif(!Empty(cProxy), cProxy, "") + ' " ' + ;										// Informacoes para conexao atraves de proxy
			' "option batch abort" ' + ;														// Deixar para executar no modo batch
			' "option confirm off" ' + ;														// Desabilitar a confirmacao das operacoes
			' "exit" ' + ;																		// Desconectar do servidor SFTP
			'>' + ::cDirWinSCP + ::cArqLog														// Gerar o log da execucao do comando

//conout(::cDirWinSCP + ::cArqBat)
//conout(cAcao)
			
// Gerar o arquivo bat 
//memowrite("WinSCP\" + ::cArqBat, cAcao) 
memowrite(::cDWSCPSrv + ::cArqBat, cAcao)

// Executar o bat para tentar realizar a conexao e gravar o resultado da tentativa
WaitRunSrv( 'cmd "/c ' + ::cDirWinSCP + ::cArqBat + '"' , .T. , ::cDirWinSCP )

// Verificar se ocorreu a autenticacao com sucesso
lRet := SELF:Authentic()

Return lRet

//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Listar
Metodo para listar os arquivos contidos na pasta informada
@author marcio.katsumata
@since 22/07/2019
@version 1.0
@param cDir
@return aRet Array com a lista dos arquivos do diretorio informado
/*/
//-------------------------------------------------------------------------------------------------------------------------

METHOD Listar(cDir) CLASS TSFTP

Local aRet 	:= {}		// Retorno com a lista dos arquivos encontrados no diretorio informado
Local cAcao	:= ""		// Comandos a serem executados atraves do arquivo batch
Local cLog		:= ""		// String contendo o conteudo do arquivo de log
Local cProxy	:= ""		// String contendo as informacoes para utilizar o proxy

DEFAULT cDir := ""

// Limpar o arquivo de comandos e de log antes de executar o novo
SELF:ClearArq()

If ::lUsaProxy

	cProxy :=	' -rawsettings "' + ;
				' ProxyMethod=' + ::cTipoProxy + ;
				' ProxyHost=' + ::cProxy + ;
				Iif(!Empty(::cPortProxy), ' ProxyPort=' + ::cPortProxy, "") + ;
				Iif(!Empty(::cUsrProxy), ' ProxyUsername=' + ::cUsrProxy, "") + ;
				Iif(!Empty(::cPswProxy), ' cPswProxy=' + ::cPswProxy, "") + ;
				' " '

Endif

// Montar o comando para realizar a operacao 
cAcao	:=	'"' + ::cWinSCP + '"' + ;															// Chamada do programa que estah no arquivo executaval
			' /command "open ' + ::cUsuario + ':' + ::cSenha + '@' + ::cServer + ;		// Executar o comando de conexao com servidor SFTP
			' -hostkey=""' + ::cHostKey + '"" ' + ;											// Informar o HostKey para tornar automatica a conexao
			Iif(!Empty(cProxy), cProxy, "") + ' " ' +;										// Informacoes para conexao atraves de proxy
			' "option batch abort" ' + ;														// Deixar para executar no modo batch
			' "option confirm off" ' + ;														// Desabilitar a confirmacao das operacoes
			' "ls ' + cDir + ' " ' + ;															// Comando para executar a listagem dos arquivos no dir. informado
			' "exit" ' + ;																		// Desconectar do servidor SFTP
			'>' + ::cDirWinSCP + ::cArqLog														// Gerar o log da execucao do comando
			
// Gerar o arquivo bat 
memowrite(::cDWSCPSrv + ::cArqBat, cAcao)

// Executar o bat para tentar realizar a conexao e gravar o resultado da tentativa
WaitRunSrv( 'cmd "/c ' + ::cDirWinSCP + ::cArqBat + '"' , .T. , ::cDirWinSCP )

//Testar se autenticou
If !SELF:Authentic()
	Return aRet	// Nem autenticou, entao nao devolve nada
Endif

// Leitura do arquivo de log
cLog := SELF:LerLog()

// Validar que o comando de listagem ocorreu com sucesso.
If (ERRLST1 $ cLog)
	Return aRet
Endif

// Montar a lista dos arquivos em array
aRet := SELF:MontaLista(cLog)

Return aRet

//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Updload
Metodo para realizar o upload do arquivo para a pasta informada
@author marcio.katsumata
@since 22/07/2019
@version 1.0
@param cDirOri Diretorio de origem
@param cArq Arquivo a ser enviado para o servidor SFTP
@param cDirDest Diretorio de destino
@return lRet .T.=Foi possivel realizar o upload, .F.=Nao foi possivel realizar o upload
/*/
//-------------------------------------------------------------------------------------------------------------------------

METHOD Upload(cDirOri, cArq, cDirDest, lUpper) CLASS TSFTP

Local lRet := .F.											// Retorna se foi possivel realizar o upload do arquivo
Local cAcao	:= ""										// Comandos a serem executados atraves do arquivo batch
Local cLog		:= ""										// String contendo o conteudo do arquivo de log
Local cPathPD	:= GetSrvProfString("ROOTPATH","")		// Caminho do Protheus_Data
Local cProxy	:= ""										// String contendo as informacoes para utilizar o proxy

DEFAULT cDirOri	:= ""
DEFAULT cArq		:= ""
DEFAULT cDirDest	:= ""
DEFAULT lUpper	:= .T.

// Limpar o arquivo de comandos e de log antes de executar o novo
SELF:ClearArq()

If ::lUsaProxy

	cProxy :=	' -rawsettings "' + ;
				' ProxyMethod=' + ::cTipoProxy + ;
				' ProxyHost=' + ::cProxy + ;
				Iif(!Empty(::cPortProxy), ' ProxyPort=' + ::cPortProxy, "") + ;
				Iif(!Empty(::cUsrProxy), ' ProxyUsername=' + ::cUsrProxy, "") + ;
				Iif(!Empty(::cPswProxy), ' cPswProxy=' + ::cPswProxy, "") + ;
				' " '

Endif

// Montar o comando para realizar a operacao 
cAcao	:=	'"' + ::cWinSCP + '"' + ;															// Chamada do programa que estah no arquivo executaval
			' /command "open ' + ::cUsuario + ':' + ::cSenha + '@' + ::cServer + ;		// Executar o comando de conexao com servidor SFTP
			' -hostkey=""' + ::cHostKey + '"" ' + ;											// Informar o HostKey para tornar automatica a conexao
			Iif(!Empty(cProxy), cProxy, "") + ' " ' +  ;										// Informacoes para conexao atraves de proxy			
			' "option batch abort" ' + ;														// Deixar para executar no modo batch
			' "option confirm off" ' + ;														// Desabilitar a confirmacao das operacoes
			' "cd ' + cDirDest + ' "' + ;														// Mudar para o diretorio de destino
			' "put -nopermissions -nopreservetime ' + cPathPD + cDirOri + cArq + " " +;									// Comando para executar o upload dos arquivos
			If(lUpper, Upper(cArq), '') + '" ' +;
			' "exit" ' + ;																		// Desconectar do servidor SFTP
			'>' + ::cDirWinSCP + ::cArqLog														// Gerar o log da execucao do comando
			
// Gerar o arquivo bat 
//memowrite("WinSCP\" + ::cArqBat, cAcao)
memowrite(::cDWSCPSrv + ::cArqBat, cAcao)

// Executar o bat para tentar realizar a conexao e gravar o resultado da tentativa
WaitRunSrv( 'cmd "/c ' + ::cDirWinSCP + ::cArqBat + '"' , .T. , ::cDirWinSCP )

//Testar se autenticou
If !SELF:Authentic()
	Return lRet	// Nem autenticou entao nem fez o upload
Endif

// Leitura do arquivo de log
cLog := SELF:LerLog()

// Validar que o arquivo subiu para o servidor
If !(ERRDWL1 $ cLog) .AND. !(ERRDWL2 $ cLog)
	lRet := .T.
Endif

Return lRet

//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Download
Metodo para realizar o download do arquivo para a pasta informada
@author marcio.katsumata
@since 22/07/2019
@version 1.0
@param cDirOri Diretorio de origem
@param cArq Arquivo a ser enviado para o servidor SFTP
@param cDirDest Diretorio de destino
@return lRet .T.=Foi possivel realizar o download, .F.=Nao foi possivel realizar o download
/*/
//-------------------------------------------------------------------------------------------------------------------------

METHOD Download(cDirOri, cArq, cDirDest) CLASS TSFTP

Local lRet := .F.											// Retorna se foi possivel realizar o download do arquivo
Local cAcao	:= ""										// Comandos a serem executados atraves do arquivo batch
Local cLog		:= ""										// String contendo o conteudo do arquivo de log
Local cPathPD	:= GetSrvProfString("ROOTPATH","")		// Caminho do Protheus_Data
Local cProxy	:= ""										// String contendo as informacoes para utilizar o proxy

DEFAULT cDirOri	:= ""
DEFAULT cArq		:= ""
DEFAULT cDirDest	:= ""

// Limpar o arquivo de comandos e de log antes de executar o novo
SELF:ClearArq()

If ::lUsaProxy

	cProxy :=	' -rawsettings "' + ;
				' ProxyMethod=' + ::cTipoProxy + ;
				' ProxyHost=' + ::cProxy + ;
				Iif(!Empty(::cPortProxy), ' ProxyPort=' + ::cPortProxy, "") + ;
				Iif(!Empty(::cUsrProxy), ' ProxyUsername=' + ::cUsrProxy, "") + ;
				Iif(!Empty(::cPswProxy), ' cPswProxy=' + ::cPswProxy, "") + ;
				' " '

Endif

// Montar o comando para realizar a operacao 
cAcao	:=	'"' + ::cWinSCP + '"' + ;															// Chamada do programa que estah no arquivo executaval
			' /command "open ' + ::cUsuario + ':' + ::cSenha + '@' + ::cServer + ;		// Executar o comando de conexao com servidor SFTP
			' -hostkey=""' + ::cHostKey + '"" ' + ;											// Informar o HostKey para tornar automatica a conexao
			Iif(!Empty(cProxy), cProxy, "") + ' " ' +  ;										// Informacoes para conexao atraves de proxy			
			' "option batch abort" ' + ;														// Deixar para executar no modo batch
			' "option confirm off" ' + ;														// Desabilitar a confirmacao das operacoes
			' "cd ' + cDirOri + ' "' + ;														// Mudar para o diretorio de origem
			' "lcd ' + cPathPD + cDirDest + ' "' + ;											// Mudar para o diretorio local de destino
			' "get -delete ' + cArq + '" ' + ;															// Comando para executar o download do arquivo
			' "exit" ' + ;																		// Desconectar do servidor SFTP
			'>' + ::cDirWinSCP + ::cArqLog														// Gerar o log da execucao do comando
			
// Gerar o arquivo bat 
//memowrite("WinSCP\" + ::cArqBat, cAcao)
memowrite(::cDWSCPSrv + ::cArqBat, cAcao)

// Executar o bat para tentar realizar a conexao e gravar o resultado da tentativa
WaitRunSrv( 'cmd "/c ' + ::cDirWinSCP + ::cArqBat + '"' , .T. , ::cDirWinSCP )

//Testar se autenticou
If !SELF:Authentic()
	Return lRet	// Nem autenticou, entao nem fez o download
Endif

// Leitura do arquivo de log
cLog := SELF:LerLog()

// Validar que o arquivo foi para o servidor protheus
If !(ERRDWL1 $ cLog) .AND. !(ERRDWL2 $ cLog) .AND. !(ERRDWL3 $ cLog)
	lRet := .T.
Endif

Return lRet

//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Move
Metodo para mover arquivos entre as pastas no servidor SFTP
@author marcio.katsumata
@since 07/11/2014
@version 1.0
@param cDirOri Diretorio de origem
@param cArq Arquivo a ser movido no servidor SFTP
@param cDirDest Diretorio de destino
@return lRet .T.=Foi possivel realizar o download, .F.=Nao foi possivel realizar o download
/*/
//-------------------------------------------------------------------------------------------------------------------------

METHOD Move(cDirOri, cArq, cDirDest) CLASS TSFTP

Local lRet := .F.											// Retorna se foi possivel realizar o download do arquivo
Local cAcao	:= ""										// Comandos a serem executados atraves do arquivo batch
Local cLog		:= ""										// String contendo o conteudo do arquivo de log
Local cPathPD	:= GetSrvProfString("ROOTPATH","")		// Caminho do Protheus_Data
Local cProxy	:= ""										// String contendo as informacoes para utilizar o proxy

DEFAULT cDirOri	:= ""
DEFAULT cArq		:= ""
DEFAULT cDirDest	:= ""

// Limpar o arquivo de comandos e de log antes de executar o novo
SELF:ClearArq()

If ::lUsaProxy

	cProxy :=	' -rawsettings "' + ;
				' ProxyMethod=' + ::cTipoProxy + ;
				' ProxyHost=' + ::cProxy + ;
				Iif(!Empty(::cPortProxy), ' ProxyPort=' + ::cPortProxy, "") + ;
				Iif(!Empty(::cUsrProxy), ' ProxyUsername=' + ::cUsrProxy, "") + ;
				Iif(!Empty(::cPswProxy), ' cPswProxy=' + ::cPswProxy, "") + ;
				' " '

Endif

// Montar o comando para realizar a operacao 
cAcao	:=	'"' + ::cWinSCP + '"' + ;															// Chamada do programa que estah no arquivo executaval
			' /command "open ' + ::cUsuario + ':' + ::cSenha + '@' + ::cServer + ;		// Executar o comando de conexao com servidor SFTP
			' -hostkey=""' + ::cHostKey + '"" ' + ;											// Informar o HostKey para tornar automatica a conexao
			Iif(!Empty(cProxy), cProxy, "") + ' " ' +  ;										// Informacoes para conexao atraves de proxy			
			' "option batch abort" ' + ;														// Deixar para executar no modo batch
			' "option confirm off" ' + ;														// Desabilitar a confirmacao das operacoes
			' "mv ' + cDirOri + cArq + ' ' + cDirDest + cArq + ' "' + ;						// Move arquivo origem para destino
			' "exit" ' + ;																		// Desconectar do servidor SFTP
			'>' + ::cDirWinSCP + ::cArqLog														// Gerar o log da execucao do comando
			
// Gerar o arquivo bat 
memowrite(::cDWSCPSrv + ::cArqBat, cAcao)

// Executar o bat para tentar realizar a conexao e gravar o resultado da tentativa
WaitRunSrv( 'cmd "/c ' + ::cDirWinSCP + ::cArqBat + '"' , .T. , ::cDirWinSCP )

//Testar se autenticou
If !SELF:Authentic()
	Return lRet	// Nem autenticou, entao nem fez o download
Endif

// Leitura do arquivo de log
cLog := SELF:LerLog()

// Validar que o arquivo foi para o servidor protheus
If !(ERRDWL1 $ cLog) .AND. !(ERRDWL2 $ cLog) .AND. !(ERRDWL3 $ cLog)
	lRet := .T.
Endif

Return lRet

//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} WinSCP
Metodo que torna disponivel o WinSCP no diretorio informado no parametro FS_WINSCP e retorna o diretorio + arquivo do WinSCP
@author marcio.katsumata
@since 22/07/2019
@version 1.0
@return cRet diretorio + arquivo do WinSCP executavel pela linha de comando
/*/
//-------------------------------------------------------------------------------------------------------------------------

METHOD WinSCP() CLASS TSFTP
local oSfUtils  := SFUTILS():new()
Local cRet		:= ""				          // Retorno do metodo com o diretorio + arquivo do WinSCP para ser executado pelo linha de comando
Local cDir		:= oSfUtils:getSftpPth()+"\"  // Diretorio dentro do Protheus_Data onde o executavel via linha de comando se encontra
Local cWinSCP	:= "WinSCP.com"	// Arquivo executavel a ser utilizado via linha de comando

cRet := GetSrvProfString("ROOTPATH","") + cDir + cWinSCP

freeObj(oSfUtils)
Return cRet

//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Authentic
Metodo que retorna se ocorreu a autenticacao
@author marcio.katsumata
@since 22/07/2019
@version 1.0
@return lRet .T.=Indica que foi possivel realizar a autenticacao, .F.=Falha na autenticacao
/*/
//-------------------------------------------------------------------------------------------------------------------------

METHOD Authentic() CLASS TSFTP

Local lRet			:= .F.		// Retorno do metodo
Local cLog			:= ""		// String contendo o conteudo do arquivo de log

// Leitura do arquivo de log
cLog := SELF:LerLog()
		
// Foi encontrado o string que indica que ocorreu a autenticacao com sucesso
If (AUTH $ cLog)
	lRet := .T.
Endif
		
If lRet
	//conout("Autenticado")
Else
	//conout("Não autenticado")
Endif

Return lRet

//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} ClearArq
Metodo para limpar o arquivo de log e o arquivo de comandos
@author marcio.katsumata
@since 03/11/2014
@version 1.0
/*/
//-------------------------------------------------------------------------------------------------------------------------

METHOD ClearArq() CLASS TSFTP

// Apagar arquivo de log
If File(::cDWSCPSrv + ::cArqLog)
	FErase(::cDWSCPSrv + ::cArqLog)
Endif

// Apagar arquivo de comando bat
If File(::cDWSCPSrv + ::cArqBat)
	FErase(::cDWSCPSrv + ::cArqBat)
Endif

Return Nil

//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} LerLog
Metodo para ler o arquivo de log
@author marcio.katsumata
@since 03/11/2014
@version 1.0
/*/
//-------------------------------------------------------------------------------------------------------------------------

METHOD LerLog() CLASS TSFTP

Local cRet			:= ""		// String com o conteudo do log
Local nHdl			:= 0		// Handler para acesso ao arquivo de log
Local cLog			:= ""		// String contendo o conteudo do arquivo de log
Local nQtd			:= 0		// Qtd de bytes no arquivo de log
Local nQtdLido	:= 0		// Qtd de bytes lidos no arquivo de log
Local cArqLog		:= ""		// Path + nome do arquivo de logs

//conout(::cDWSCPSrv + ::cArqLog)
//conout(File(::cDWSCPSrv + ::cArqLog))

//If (nHdl := FOPEN(::cDirWinSCP + ::cArqLog)) > 0 
If (nHdl := FOPEN(::cDWSCPSrv + ::cArqLog)) > 0

	//conout(cValToChar(nHdl))

	// Posiciona no fim do arquivo, retornando o tamanho do mesmo 
	nQtd := FSEEK(nHdl, 0, FS_END) 
	
	// Posiciona no início do arquivo 
	FSEEK(nHdl, 0)
	
	// Ler o arquivo de log
	cLog := Space(nQtd)
	nQtdLido := FREAD(nHdl, @cLog, nQtd)
	
	// Consistir a leitura do arquivo e armazenar os dados na variavel de retorno
	If (nQtdLido == nQtd .AND. !Empty(cLog))
		cRet := cLog		
	Endif
	
	// Fecha arquivo 
	FCLOSE(nHdl)
	
Else

	//conout("Erro: " + cValToChar(FError()))
	
Endif

Return cRet

//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MontaLista
Metodo que recebe o conteudo do log e monta a listagem dos arquivos obtidos com o comando ls
@author marcio.katsumata
@since 03/11/2014
@version 1.0
@param cLog Conteudo do log obtido atraves da linha de comando
/*/
//-------------------------------------------------------------------------------------------------------------------------

METHOD MontaLista(cLog) CLASS TSFTP

Local aRet		:= {}			// Array com a listagem do conteudo da pasta informada no metodo Listar
Local nIniLS	:= 0			// Inicio do log
Local nFimLin	:= 0			// Fim da linha corrente
Local cLinha	:= ""			// Conteudo da linha corrente
Local cLinha2	:= ""			// Conteudo da linha corrente retirando-se os chr(10) (ENTER) e chr(13) (LF)
Local cItem	:= ""			// Item contido na pasta corrente  
Local cTipo	:= ""			// Tipo do item - "Dir"=Pasta, "Arq"=Arquivo


DEFAULT cLog := ""

// Consistencia dos dados do log
If Empty(cLog)
	Return aRet
Endif

// Encontrar onde comeca a listagem
nIniLS := At(INILOG, cLog) + 28
// Encontrar o fim da linha corrente
nFimLin := At(chr(10), Substr(cLog, nIniLS))
// Obter o conteudo da primeira linha a ser considerada
cLinha := ALLTRIM(Substr(cLog, nIniLS, nFimLin))

// Ler todas as linhas
While !Empty(cLinha)

	//conout(StrTran(cLinha, chr(10), ""))

	// Retirar os ENTER da linha
	cLinha2 := StrTran(StrTran(cLinha, chr(10), ""), chr(13), "") 

	// Adicionar o item no array de retorno
	cItem := Substr(cLinha2, 65)
	cTipo := Iif(UPPER(Substr(cLinha2, 1, 1)) == "D", "Dir", "Arq")
	aAdd(aRet, {cItem, cTipo})
	nIniLS := nIniLS + LEN(cLinha)
	// Encontrar o fim da linha corrente
	nFimLin := At(chr(10), Substr(cLog, nIniLS))
	// Obter o conteudo da primeira linha a ser considerada
	cLinha := ALLTRIM(Substr(cLog, nIniLS, nFimLin))

EndDo

Return aRet

//-------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} DelArq
Metodo para apagar o arquivo localizado na pasta indicada no servidor SFTP
@author marcio.katsumata
@since 22/07/2019
@version 1.0
@param cDir Diretorio onde o arquivo estah para ser deletado
@param cArq Arquivo a ser deletado do servidor SFTP que estah no diretorio indicado em cDir
@return lRet .T.=Foi possivel realizar o delete, .F.=Nao foi possivel realizar o delete
/*/
//-------------------------------------------------------------------------------------------------------------------------

METHOD DelArq(cArq, cDir) CLASS TSFTP

Local lRet := .F.											// Retorna se foi possivel realizar o delete do arquivo
Local aRet 	:= {}										// Retorno com a lista dos arquivos encontrados no diretorio informado
Local cAcao	:= ""										// Comandos a serem executados atraves do arquivo batch
Local cLog		:= ""										// String contendo o conteudo do arquivo de log
Local cProxy	:= ""										// String contendo as informacoes para utilizar o proxy

DEFAULT cDir	:= ""
DEFAULT cArq	:= ""

// Limpar o arquivo de comandos e de log antes de executar o novo
SELF:ClearArq()

If ::lUsaProxy

	cProxy :=	' -rawsettings "' + ;
				' ProxyMethod=' + ::cTipoProxy + ;
				' ProxyHost=' + ::cProxy + ;
				Iif(!Empty(::cPortProxy), ' ProxyPort=' + ::cPortProxy, "") + ;
				Iif(!Empty(::cUsrProxy), ' ProxyUsername=' + ::cUsrProxy, "") + ;
				Iif(!Empty(::cPswProxy), ' cPswProxy=' + ::cPswProxy, "") + ;
				' " '

Endif

// Montar o comando para realizar a operacao 
cAcao	:=	'"' + ::cWinSCP + '"' + ;															// Chamada do programa que estah no arquivo executaval
			' /command "open ' + ::cUsuario + ':' + ::cSenha + '@' + ::cServer + ;		// Executar o comando de conexao com servidor SFTP
			' -hostkey=""' + ::cHostKey + '"" ' + ;											// Informar o HostKey para tornar automatica a conexao
			Iif(!Empty(cProxy), cProxy, "") + ' " ' + ;										// Informacoes para conexao atraves de proxy			
			' "option batch abort" ' + ;														// Deixar para executar no modo batch
			' "option confirm off" ' + ;														// Desabilitar a confirmacao das operacoes
			' "cd ' + cDir + ' "' + ;															// Mudar para o diretorio informado
			' "rm ' + cArq + '" ' + ;															// Comando para executar o delete do arquivo
			' "exit" ' + ;																		// Desconectar do servidor SFTP
			'>' + ::cDirWinSCP + ::cArqLog														// Gerar o log da execucao do comando
			
// Gerar o arquivo bat 
//memowrite("WinSCP\" + ::cArqBat, cAcao)
memowrite(::cDWSCPSrv + ::cArqBat, cAcao)

// Executar o bat para tentar realizar a conexao e gravar o resultado da tentativa
WaitRunSrv( 'cmd "/c ' + ::cDirWinSCP + ::cArqBat + '"' , .T. , ::cDirWinSCP )

//Testar se autenticou
If !SELF:Authentic()
	Return aRet	// Nem autenticou, entao nem deletou nada
Endif

// Leitura do arquivo de log
cLog := SELF:LerLog()

// Validar que o arquivo foi para o servidor protheus
If !(ERRDWL1 $ cLog) .AND. !(ERRDWL2 $ cLog) .AND. !(ERRDWL3 $ cLog)
	lRet := .T.
Endif

Return lRet

//###########################################################################################################################################

User Function testFTP()

Local oTSFTP		:= Nil
Local lConectou	:= .F.
Local aList		:= {}
Local nCnt			:= 0



// Instanciar o objeto
oTSFTP := TSFTP():New()



// Preencher os atributos do objeto
oTSFTP:cServer	    := "sftp-nldca.imcd.biz"
oTSFTP:cUsuario	    := "BrasilSF"
oTSFTP:cSenha		:= strtran("Y/Bh45y\","/", "%%2F")
oTSFTP:cHostKey	    := "ssh-rsa 4096 7a:ae:f7:ec:9e:93:fc:2e:ef:80:76:45:c9:a8:d4:00"
/*
oTSFTP:lUsaProxy	:= .T. 
oTSFTP:cTipoProxy	:= "3"		// HTTP
oTSFTP:cProxy		:= "proxy.sp01.local"
oTSFTP:cPortProxy	:= "8080"
oTSFTP:cUsrProxy	:= "sp01\rafael.previdi"
oTSFTP:cPswProxy	:= "RaFa7134"
*/

// Executar o metodo de teste de conexao
lConectou := oTSFTP:TstConnect()

Alert(Iif(lConectou, "Conectou", "Não conectou"))

If !lConectou
	Aviso("Log", oTSFTP:LerLog(), {"Ok"})
Else	
	aList := oTSFTP:Listar("/home/BrasilSF/InFromLERP/")
	Alert("Listar os arquivos da pasta raíz:")
	
	// Listar os arquivos
	For nCnt := 1 To LEN(aList)
	
		Alert(aList[nCnt][1] + " - " + aList[nCnt][2])
	
	Next nCnt
Endif	

//Upload(cDirOri, cArq, cDirDest)

lUpload := oTSFTP:Upload("\WinSCP\", "enviar.tXT", "/upload/")
//conout(Iif(lUpload, "Subiu arquivo", "Não Subiu arquivo"))

aList := oTSFTP:Listar("/blabla/")
//conout("Listar os arquivos da pasta Upload:")

// Listar os arquivos
For nCnt := 1 To LEN(aList)

	//conout(aList[nCnt][1] + "		" + aList[nCnt][2])

Next nCnt
/*
//Download(cDirOri, cArq, cDirDest)
//lDownload := oTSFTP:Download("/upload/", "enviar.txt", "\destino")
lDownload := oTSFTP:Download("/blabla/", "enviar.txt", "\destino")
//conout(Iif(lDownload, "Baixou arquivo", "Não Baixou arquivo"))

lMove := oTSFTP:Move("/blabla/", "enviar.txt", "/")
//conout(Iif(lDownload, "Moveu arquivo", "Não Moveu arquivo"))

lMove := oTSFTP:Move("/blabla/", "to*.*", "/")
//conout(Iif(lDownload, "Moveu arquivos", "Não Moveu arquivos"))

//DelArq(cArq, cDir)
lDelete := oTSFTP:DelArq("enviar.txt", "/blabla/")
//conout(Iif(lDelete, "Deletou arquivo", "Não Deletou arquivo"))

aList := oTSFTP:Listar("/upload/")
//conout("Listar os arquivos da pasta Upload:")

// Listar os arquivos
For nCnt := 1 To LEN(aList)

	//conout(aList[nCnt][1] + "		" + aList[nCnt][2])

Next nCnt*/

oTSFTP:ClearArq()

//conout(" ")
//conout("Terminou TstTSFTP")

Return Nil

User Function TstSFPT2()

StartJob("U_TstTSFPT", "ERP_TOP_PORT", .T.)

Return Nil