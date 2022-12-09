#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} SFFTPUTIL
Classe relacionada � prepara��o do ambiente para a chamada do
objeto de envio via SFTP.
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFFTPUTIL 
    method new() constructor
    method getUrl()
	method getAuth()
	method sendFile()
	method getFile()

	data url as character         //Url do FTP
	data port as numeric          //Porta do FTP
	data user as character        //Usu�rio do FTP
	data password as character    //Senha do FTP
	data hostKey  as character    //Hostkey do FTP
endclass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
M�todo construtor 
@author  marcio.katsumata
@since   26/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method new() class SFFTPUTIL

return

//-------------------------------------------------------------------
/*/{Protheus.doc} getUrl
Verifica a URL e porta do SFTP Sales Force
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method getUrl () class SFFTPUTIL

    //Inicializa��o de atributos
	self:url      := AllTrim(superGetMv("ES_XURLFTP"  ,.F.,""))      
	self:port     := superGetMv("ES_XPTAFTP",.F.,21)        
	self:user     := ""
	self:password := ""
	self:hostKey  := ""
return 

//-------------------------------------------------------------------
/*/{Protheus.doc} getAuth
Verifica credenciais de autentica��o no SFTP do Sales Force.
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
@return  boolean, retorno da exist�ncia de credenciais.
/*/
//-------------------------------------------------------------------
method getAuth() class SFFTPUTIL
	local cAuxUser  as character  //Nome do usu�rio criptografado
	local cAuxPass  as character  //Senha do usu�rio criptografado
	local oSFUTILS as object     //Objeto SFUTILS
	local cArqAuth  as character  //Arquivo que contem o nome e senha do usu�rio criptografado
	local aAuth     as array      //Array com o nome e senha do usu�rio
	local cLine     as character  //Linha de leitura do arquivo.


    //Nome do arquivo que contem o nome e senha do usu�rio criptografado
	cArqAuth := "authentication.aut"

    //Regasta o caminho do arquivo de autentica��o
	oSFUTILS := SFUTILS():new()
	cArqAuth := oSFUTILS:getAuthPath()+"\\"+cArqAuth


    //Realiza a leitura do arquivo de autentica��o e descriptografa.
	if file(cArqAuth)
		cLine := memoread(cArqAuth)
		if !empty(cLine)
			aAuth := strTokArr(cLine,";")
			if len(aAuth) == 3
				self:user     := alltrim(oSFUTILS:decryptTxt(aAuth[1]))
				self:password := alltrim(oSFUTILS:decryptTxt(aAuth[2]))
				self:hostKey  := alltrim(oSFUTILS:decryptTxt(aAuth[3]))
			endif
		endif
	endif

    freeObj(oSFUTILS)

return !empty(self:user) .and. !empty(self:password) .and. !empty(self:hostKey)


//-------------------------------------------------------------------
/*/{Protheus.doc} sendFile
Envio FTP de arquivos 
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
@param   cEntity   , character, entidade(processo da exporta��o Orders/Products/Accounts)
@param   cServStart, character, diret�rio  (Protheus)
@param   cMsgErro  , character, mensagem de erro
@return  boolean, sucesso no envio
/*/
method sendFile(cEntity,cServStart,cMsgErro) class SFFTPUTIL

	Local cSource as character //Local do server Protheus que est�o os arquivos a serem exportados
	Local cTarget as character //Local do SFTP onde ser�o gravados os arquivos
	Local cMode   as character //Modo da requisi��o SFTP 
    Local oSFTP   as object    //Objeto SFTP
	local lRet    as logical   //Retorno do envio
	local cPorta  as character //Porta do SFTP

	//--------------------------------------------------------------------------------------
	//Inicializa��o das vari�veis
	//--------------------------------------------------------------------------------------
	cSource:=cServStart+"\"  //Apenas arquivos CSV ser�o exportados.
	cTarget:= superGetMv("ES_XPTHFTP",.F.,"/home/BrasilSF/InFromLERP/")+cEntity+"/Input"
	cMode:="P" //Modo PUT
	oSFTP:=TSFTP():New()
	lRet := .T.
	cPorta := cValToChar(self:port )

	//-------------------------------------------------------------------------------------------
	//Execu��o do envio dos arquivos da pasta especificada.
	//-------------------------------------------------------------------------------------------
	if !empty(self:user) .and. !empty(self:password) .and. !empty(self:url) .and. !empty(cPorta)
		oSFTP:cServer	    := self:url
		oSFTP:cUsuario	    := self:user
		oSFTP:cSenha		:= strtran(self:password,"/", "%%2F")
		oSFTP:cHostKey	    := self:hostKey

		//Realiza teste de conex�o ao SFTP
		if (lRet := oSFTP:TstConnect())
			//---------------------------------------------------------------
			//Realiza o upload dos arquivos 
			//---------------------------------------------------------------			
			if !(lRet := oSFTP:Upload(cSource, "*.csv", cTarget))
				cMsgErro += "[FTP] Erro ao transmitir arquivos."+CRLF+oSFTP:LerLog()+CRLF
			endif
		else
			cMsgErro += "[FTP] Erro na tentativa de conex�o: "+CRLF+oSFTP:LerLog()+CRLF
		endif
    else
        lRet := .F.
        cMsgErro += "[FTP] Par�metros de usu�rio/senha/url/porta nao preenchidos"+CRLF
    endif
	
	//Limpeza do objeto SFTP
	oSFTP:ClearArq()
	freeObj(oSFTP)


return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} getFile
Receber arquivos  via SFTP Sales Force
@author  marcio.katsumata
@since   19/07/2019
@version 1.0
@param   aEntities , array    , entidades
@param   cMsgErro  , character, mensagem de erro
@return  boolean, sucesso no envio
/*/
method getFile(aEntities,cMsgErro,lNewSFReg) class SFFTPUTIL

	Local cSource as character //Local do server Protheus que est�o os arquivos a serem exportados
	Local cTarget as character //Local do SFTP onde ser�o gravados os arquivos
	Local cMode   as character //Modo da requisi��o SFTP 
	Local oSFTP   as object    //Objeto SFTP
	local lRet    as logical   //Retorno do envio
	local cPorta  as character //Porta do SFTP
	local cSrcAux as character //Path source auxiliar
	local cTarget as character //Path target auxiliar
	local oSfUtils as object   //Objeto da classe utils
	Local nInd := 0
	Local nInd2 := 0

	default lNewSFReg := .F.
	//--------------------------------------------------------------------------------------
	//Inicializa��o das vari�veis
	//--------------------------------------------------------------------------------------
	
	cSource:= iif(lNewSFReg,superGetMv("ES_XSFINFT",.F.,"/home/BrasilSF/OutFromSalesForce/"), superGetMv("ES_XPTHFTP",.F.,"/home/BrasilSF/InFromLERP/"))
	cSrcImpAut := superGetMv("ES_XSFIMFT",.F.,"/home/BrasilSF/outbox/")
	cSrcAux := ""
	cTarget := ""
	oSFTP:= TSFTP():New()
	lRet := .T.
	cPorta := cValToChar(self:port )
	aStatus := {"Success", "Error"}
	oSfUtils := SFUTILS():new()
	cImpAuto := lower(superGetMv("ES_XSFIMAT",.F.,"quote/"))
	//-------------------------------------------------------------------------------------------
	//Execu��o do envio dos arquivos da pasta especificada.
	//-------------------------------------------------------------------------------------------
	if !empty(self:user) .and. !empty(self:password) .and. !empty(self:url) .and. !empty(cPorta)
		oSFTP:cServer	    := self:url
		oSFTP:cUsuario	    := self:user
		oSFTP:cSenha		:= strtran(self:password,"/", "%%2F")
		oSFTP:cHostKey	    := self:hostKey 
		//Realiza teste de conex�o ao SFTP
		if (lRet := oSFTP:TstConnect())
			if lNewSFReg
				cTarget := oSfUtils:getSfInPend()
				//---------------------------------------------------------------
				//Realiza o downlod dos arquivos de cada entidade e ap�s o download realiza 
				//a remo��o do arquivo SFTP.
				//---------------------------------------------------------------
				for nInd := 1 to len(aEntities)
					if !(lRet := oSFTP:Download(cSource, aEntities[nInd]+"_*.*", cTarget))
						cMsgErro += "[FTP] Erro ao realizar o download de  arquivos: "+CRLF+oSFTP:LerLog()+CRLF
					endif
				next nInd
			else
				for nInd := 1 to len(aEntities) 
					if lower(alltrim(aEntities[nInd])) $ lower(alltrim(cImpAuto))						
						cSrcAux := cSrcImpAut + aEntities[nInd] +"/"
						cTarget := oSfUtils:impPendPrc(aEntities[nInd])+"\"
						//---------------------------------------------------------------
						//Realiza o downlod dos arquivos e ap�s o download realiza 
						//a remo��o do arquivo SFTP.
						//---------------------------------------------------------------
						if !(lRet := oSFTP:Download(cSrcAux, "*.*", cTarget))
							cMsgErro += "[FTP] Erro ao realizar o download de  arquivos: "+CRLF+oSFTP:LerLog()+CRLF
						endif
					else
						for nInd2 := 1 to len(aStatus)

							cSrcAux := cSource + aEntities[nInd] +"/"+aStatus[nInd2]+"/"
							cTarget := oSfUtils:impPendPrc(aEntities[nInd], aStatus[nInd2])+"\"
							//---------------------------------------------------------------
							//Realiza o downlod dos arquivos e ap�s o download realiza 
							//a remo��o do arquivo SFTP.
							//---------------------------------------------------------------
							if !(lRet := oSFTP:Download(cSrcAux, "*.*", cTarget))
								cMsgErro += "[FTP] Erro ao realizar o download de  arquivos: "+CRLF+oSFTP:LerLog()+CRLF
							endif
						next nInd2
					endif


				next nInd
			endif
		else
			cMsgErro += "[FTP] Erro na tentativa de conex�o: "+CRLF+oSFTP:LerLog()+CRLF
		endif
	else
		lRet := .F.
		cMsgErro += "[FTP] Par�metros de usu�rio/senha/url/porta nao preenchidos"+CRLF
	endif
	
	//-----------------------------------------
	//Limpeza de arquivos tempor�rios do WINSCP
	//-----------------------------------------
	oSFTP:ClearArq()

	//---------------------------
	//Limpeza de objeto e array
	//---------------------------
	freeObj(oSFTP)
	aSize(aStatus,0)


Return lRet


user function SFFTPUTIL()
return