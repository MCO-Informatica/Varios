#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} SYSFIOFTP
Classe relacionada à preparação do ambiente para a chamada do
objeto de envio via SFTP.
@author  junior.carvalho/marcio.katsumata
@since   02/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SYSFIOFTP 
    method new() constructor
    method getUrl()
	method getAuth()
	method sendFiles()
	method getFiles()
	method destroy()
	
	data url as character         //Url do FTP
	data port as numeric          //Porta do FTP
	data user as character        //Usuário do FTP
	data password as character    //Senha do FTP
	data oSysFiUtl as object      //Utils
endclass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor 
@author  junior.carvalho/marcio.katsumata
@since   02/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method new() class SYSFIOFTP

return

//-------------------------------------------------------------------
/*/{Protheus.doc} getUrl
Verifica a URL e porta do SFTP Sales Force
@author  junior.carvalho/marcio.katsumata
@since   02/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method getUrl () class SYSFIOFTP

    //Inicialização de atributos
	self:url      := AllTrim(superGetMv("ES_XFIURL"  ,.F.,"ftp.fiorde.com.br"))      
	self:port     := superGetMv("ES_XFIPRT",.F.,21)        
	self:user     := ""
	self:password := ""
	self:oSysFiUtl := SYSFIUTL():new()
return 

//-------------------------------------------------------------------
/*/{Protheus.doc} getAuth
Verifica credenciais de autenticação no SFTP do Sales Force.
@author  junior.carvalho/marcio.katsumata
@since   02/09/2019
@version 1.0
@return  boolean, retorno da existência de credenciais.
/*/
//-------------------------------------------------------------------
method getAuth(cMsgErro) class SYSFIOFTP
	local cAuxUser  as character  //Nome do usuário criptografado
	local cAuxPass  as character  //Senha do usuário criptografado
	local oSYSFIUTL as object     //Objeto SYSFIUTL
	local cArqAuth  as character  //Arquivo que contem o nome e senha do usuário criptografado
	local aAuth     as array      //Array com o nome e senha do usuário
	local cLine     as character  //Linha de leitura do arquivo.
	local lRet      as logical    //retorno

    //Nome do arquivo que contem o nome e senha do usuário criptografado
	cArqAuth := "authentication.aut"

	lRet := .F.

    //Regasta o caminho do arquivo de autenticação
	cArqAuth := self:oSysFiUtl:getAuthPath()+cArqAuth


    //Realiza a leitura do arquivo de autenticação e descriptografa.
	if file(cArqAuth)
		cLine := memoread(cArqAuth)
		if !empty(cLine)
			aAuth := strTokArr(cLine,";")
			if len(aAuth) == 2
				self:user     := alltrim(self:oSysFiUtl:decryptTxt(aAuth[1]))
				self:password := alltrim(self:oSysFiUtl:decryptTxt(aAuth[2]))
			endif
		endif
	endif

	if !empty(self:url) .and. !empty(self:port) .and. !empty(self:user) .and. !empty(self:password)
		if !(lRet := FTPCONNECT(self:url ,self:port ,self:user , self:password ))
			cMsgErro+= 'Não foi possível a conexão com o servidor FTP informado. Verifique.'
		Endif
	else
		cMsgErro += 'A URL, a porta, o usuário ou a senha não estão devidamente configurados. Verifique.'
	endif


return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} sendFiles
Envio FTP de arquivos 
@author  junior.carvalho/marcio.katsumata
@since   02/09/2019
@version 1.0
@param   aFiles   , array, arquivos a processar o envio
						   Estrutura do array
							1. Nome do arquivo
							2. Caminho completo do arquivo
							3. Caminho completo do destino do arquivo após a transferência
							4. Sucesso na transmissão (boolean)
@param   cMsgErro  , character, mensagem de erro
@return  boolean, sucesso no envio
/*/
method sendFiles(aFiles,cMsgErro) class SYSFIOFTP

	local cTarget  as character //Local do FTP onde serão gravados os arquivos
	local lRet     as logical   //Retorno do envio
	local cArqOri  as character //caminho completo do arquivo origem
	local cArqDest as character //caminho completo do arquivo destino
	local cFile    as character //nome do arquivo
	local nX       as numeric    //indice
	local nCount   as numeric     //contador
	local cType    as character  //tipo de arquivo D= DI (Embarque) , P=PO(Purchase Order)


	//--------------------------------------------------------------------------------------
	//Inicialização das variáveis
	//--------------------------------------------------------------------------------------
	cTargetOut:= superGetMv("ES_FIOUTFTP",.F.,"/inbound")
	cTargetIn := superGetMv("ES_FIINFTP",.F.,"/outbound")
	nCount := Len( aFiles )
	lRet := .T.

	For nX := 1 to nCount
		lSent  := .T.
		cFile := aFiles[nX,1]

		//---------------------------------
		//Define o arquivo origem e destino
		//---------------------------------
		cArqOri  := aFiles[nX,2]
		cType    := aFiles[nX,5]
		if cType $ 'epo/edi'
			cArqDest := cTargetOut+"/"+cType+"/pending/"+cFile
		else
			cArqDest := cTargetIn+"/"+cType+"/"+aFiles[nX,6]+"/"+cFile
		endif
		FTPSETPASV(.F.)

		//-----------------------------
		//Realiza o UPLOAD do arquivo
		//-----------------------------
		IF !FTPUPLOAD( cArqOri,cArqDest)

			IF !FTPUPLOAD( cArqOri,cArqDest) //forço a entrada, tentando duas vezes
				lRet:=.F.
				lSent := .F.
				cMsgErro+='[SYSFIOFTP] [sendFiles] Não foi possível a carga do arquivo no FTP. Verifique as permissões e tente novamente.'
			Endif
		Endif

		If lSent
			aFiles[nX,4] := .T.
		EndIf
			
	Next nX
					

return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} getFile
Receber arquivos  via FTP Sysfiorde
@author  junior.carvalho/marcio.katsumata
@since   03/09/2019
@version 1.0
@param   cMsgErro  , character, mensagem de erro
@param   aRetArq , array, arquivos baixados
@return  boolean, sucesso no envio
/*/
method getFiles(cMsgErro,aRetArq) class SYSFIOFTP

	Local cSource as character //Local do server Protheus que estão os arquivos a serem exportados
	Local aArqs   as array     //Arquivos retornados do FTP
	local lRet    as logical   //Retorno do envio
	local cTarget as character //Path target auxiliar
	local nArqsCopy as numeric //quantidade de arquivos
	local nInd    as numeric   //Indice para navegação entre os arquivos
	local nIndSrc as numeric   //Indice para navegação entre as pastas 
	local nType   as numeric   //Indice para navegação entre os tipos
	local nIndEnt as numeric   //Indice para navegação entre as entidades

	aType := {"success","error"}

	//--------------------------------------------------------------------------------------
	//Inicialização das variáveis
	//--------------------------------------------------------------------------------------
	aSource:= {superGetMv("ES_FIOUTFTP",.F.,"/inbound"),superGetMv("ES_FIINFTP",.F.,"/outbound") }
	aArqs  :={}
	aDirsEnt := {}

	//----------------------------------------
	//Navega entre as raizes in e out do FTP
	//Raiz IN = arquivos gerados no Protheus
	//Raiz OUT = arquivos gerados no Sysfiorde 
	//----------------------------------------
	for nIndSrc := 1 to len(aSource)
		//-----------------------------------
		//Define a raiz de procura in ou out
		//-----------------------------------
		If FTPDirChange(aSource[nIndSrc])

			//--------------------------------
			//Verifica as pastas das entidades
			//--------------------------------
			aDirsEnt := FTPDIRECTORY( "","D" )
			
			//-------------------------------------
			//Navega entre as pastas das entidades
			//--------------------------------------
			for nIndEnt:= 1 to len(aDirsEnt)
				//------------------------------------------
				//Se caso a raiz posicionada seja a pasta IN
				//------------------------------------------
				if nIndSrc == 1 
					//-------------------------------------
					//Navega entre as pasta success e error
					//-------------------------------------
					for nType := 1 to len(aType)
						//----------------------------------------------
						//Realiza a troca de diretório para o diretório
						//da entidade na pasta pending
						//----------------------------------------------	
						if FTPDirChange(aSource[nIndSrc]+"/"+aDirsEnt[nIndEnt][1]+"/"+aType[nType])
							//----------------------------------
							//Verifica os arquivos do diretório
							//----------------------------------
    						aArqs := FTPDIRECTORY( "*.txt" )
							nArqsCopy := Len(aArqs)

							//-------------------------------
							//Define o destino do download
							//-------------------------------
							cTarget := self:oSysFiUtl:impPendPrc(aDirsEnt[nIndEnt][1], aType[nType])

    						If Len(aArqs) <> 0
    						  	For nInd := 1 to nArqsCopy
    						  	    If !FTPDOWNLOAD(cTarget+"\"+aArqs[nInd][1], aArqs[nInd][1] )
										cMsgErro += '[SYSFIOFTP] [getFile] Problemas ao copiar arquivo '+ aArqs[nInd][1] 
										lRet := .F.
    						  	    Else
										aadd(aRetArq[1], aArqs[nInd][1])
									  	If !FTPERASE( aArqs[nInd][1] )
												cMsgErro +='[SYSFIOFTP] [getFile] Problemas ao apagar o arquivo ' + aArqs[nInd][1] 
												lRet := .F.
    						  	      	 EndIf
    						  	    EndIf
    						  	Next nInd
							EndIf
						else
							cMsgErro +='[SYSFIOFTP] [getFile] Problemas ao trocar de diretorio' + aArqs[nInd][1] 
							lRet := .F.		
						
						endif
						aSize(aArqs,0)
					next nType
				else
					//------------------------------------------
					//Se caso a raiz posicionada seja a pasta OUT
					//Realiza a troca de diretório para o diretório
					//da entidade na pasta pending
					//------------------------------------------	
					if FTPDirChange(aSource[nIndSrc]+"/"+aDirsEnt[nIndEnt][1]+"/pending")
						//----------------------------------
						//Verifica os arquivos do diretório
						//----------------------------------
						aArqs := FTPDIRECTORY( "*.*" )
						nArqsCopy := Len(aArqs)

						//-------------------------------
						//Define o destino do download
						//-------------------------------
						cTarget := self:oSysFiUtl:impPendPrc(aDirsEnt[nIndEnt][1])
						
						//----------------------------------------
						//Realiza o donwload dos arquivos da pasta
						//----------------------------------------
						If Len(aArqs) <> 0
							For nInd := 1 to nArqsCopy
								If !FTPDOWNLOAD(cTarget+aArqs[nInd][1], aArqs[nInd][1] )
									cMsgErro += '[SYSFIOFTP] [getFile] Problemas ao copiar arquivo '+ aArqs[nInd][1] 
									lRet := .F.
								Else
									aadd(aRetArq[2], aArqs[nInd][1])
									If !FTPERASE( aArqs[nInd][1] )
										cMsgErro +='[SYSFIOFTP] [getFile] Problemas ao apagar o arquivo ' + aArqs[nInd][1] 
										lRet := .F.
									EndIf
								EndIf
							Next nInd
						EndIf
					else
						cMsgErro +='[SYSFIOFTP] [getFile] Problemas ao trocar de diretorio' + aArqs[nInd][1] 
						lRet := .F.	
					endif
				endif

			next nIndEnt
		else
			cMsgErro +='[SYSFIOFTP] [getFile] Problemas ao trocar de diretorio' + aArqs[nInd][1] 
			lRet := .F.	 
		endif
	next nIndSrc


	aSize(aArqs,0)
	aSize(aSource,0)
	aSize(aDirsEnt,0)
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Método responsável por realizar a desconexão e limpeza de objetos.
@author  junior.carvalho/marcio.katsumata
@since   03/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy() class SYSFIOFTP
	FTPDisconnect()
return

user function SYSFIFTP()
return