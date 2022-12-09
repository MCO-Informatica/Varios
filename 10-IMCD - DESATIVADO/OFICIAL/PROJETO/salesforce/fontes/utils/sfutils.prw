#include 'protheus.ch'
#include "TbiConn.ch" 

//-------------------------------------------------------------------
/*/{Protheus.doc} SFUTILS
Classe com métodos variados de uso comum no projeto.
@author  marcio.katsumata
@since  07/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFUTILS 

	method new() constructor
	method getRootPath     ()
	method getAuthPath     ()
	method getLogPath      ()
	method getSchPath      ()
	method getExpPath      ()
	method getExpPend      () 
	method getExpSent      () 
	method getImpRead      ()
	method getImpPend      () 
	method getImpPath      () 
	method getSftpPth      ()
	method getViewPth      ()
	method expPendPrc      ()
	method expSntPrc       ()
	method getSendPth      ()
	method expSentPrc      ()
	method impReadPrc      ()
	method impPendPrc      ()
	method getSfInPath     ()
	method getSfInPend     ()
	method getSfInRead     ()

	method encryptTxt      ()
	method decryptTxt      ()
	method writeLog        ()
	method timeStamp       ()
	method liberaSemaforo  ()
	method useSemaforo     ()
	method getSchedule     ()
	method setSchedule     ()
	method normaliza       () 
	method cleanDir        () 
	method getIni          ()

	data cPath          as string        
	data cAuthPath      as string      
	data cLogPath       as string
	data cSchedulePath  as string
	data cExpPath       as string
	data cInfoThread    as string   
	data cSftpPath      as string
	data cViewPath      as string    
	data cImpPath       as string  
	data cImpPend       as string   
	data cImpRead       as string 
	data cExpPend       as string
	data cExpSend       as string  
	data cExpSent       as string 
	data cSfInPath      as string  
	data cSfInPend      as string  
	data cSfInRead      as string

endclass


/*/{Protheus.doc} new
Metodo construtor
@author marcio.katsumata
@since07/07/2019
@version   1.0
/*/
method new() class SFUTILS
	self:cPath         := "\sffiles"
	self:cAuthPath     := self:cPath + "\ftpauth"
	self:cLogPath      := self:cPath + "\logs"
	self:cSchedulePath := self:cPath +"\schedule"
	self:cImpPath      := self:cPath +"\imp"
	self:cImpPend      := self:cImpPath+"\pending"
	self:cImpRead      := self:cImpPath+"\readed"
	self:cExpPath      := self:cPath +"\exp"
	self:cExpPend      := self:cExpPath+"\pending"
	self:cExpSend      := self:cExpPath+"\sending"
	self:cExpSent      := self:cExpPath+"\sent"
	self:cSftpPath     := self:cPath+"\sftpapp"
	self:cViewPath     := self:cPath+"\views"
	self:cSfInPath     := self:cPath+"\sfin"  
	self:cSfInPend     := self:cSfInPath+"\pending"  
	self:cSfInRead     := self:cSfInPath+"\readed"  
return

/*/{Protheus.doc} encryptTxt
//Criptografia RC4 das chaves de autenticação.
@author marcio.katsumata
@since07/07/2019
@version 1.0
@param cText, characters, texto a ser criptografado.
@return characters, return_description
/*/
method encryptTxt(cText) class SFUTILS
	  local cRet as character
	  cRet = rc4crypt( cText ,"rhcrmexport", .T.)
return cRet

/*/{Protheus.doc} decryptTxt
//Descriptografia RC4 das chaves de autenticação.
@author marcio.katsumata
@since07/07/2019
@version undefined
@param cEncrypted, characters, texto a ser descriptografado.
@return return, return_description
/*/
method decryptTxt(cEncrypted) class SFUTILS
	  local cOriginal as character
	  cOriginal = rc4crypt(cEncrypted, "rhcrmexport", .F., .T.)
return cOriginal


/*/{Protheus.doc} getRootPath
//Resgata o rootpath da pasta para gravação de arquivos 
referente à integração EccoSys.
@author marcio.katsumata
@since07/07/2019
@version 1.0
@return characters, rootpath
/*/
method getRootPath () class SFUTILS
	//Verifica a existência do diretório 
	if !existDir (self:cPath)
		makeDir(self:cPath)
	endif
return self:cPath

/*/{Protheus.doc} getAuthPath
//Resgata o caminho do arquivo de autenticação
@author marcio.katsumata
@since07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getAuthPath () class SFUTILS
	self:getRootPath () 
	//Verifica a existência do diretório 
	if !existDir (self:cAuthPath)
		makeDir(self:cAuthPath)
	endif
return self:cAuthPath		 


/*/{Protheus.doc} getLogPath
//Resgata o caminho do arquivo de logs
@author marcio.katsumata
@since07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getLogPath () class SFUTILS
	self:getRootPath () 
	//Verifica a existência do diretório 
	if !existDir (self:cLogPath)
		makeDir(self:cLogPath)
	endif
return self:cLogPath


/*/{Protheus.doc} getExpPath
//Resgata o caminho raiz dos arquivos extraidos
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getExpPath () class SFUTILS
	self:getRootPath () 
	//Verifica a existência do diretório 
	if !existDir (self:cExpPath)
		makeDir(self:cExpPath)
	endif
return self:cExpPath

/*/{Protheus.doc} getExpPend
//Resgata o caminho dos arquivos pendentes de exportação
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getExpPend () class SFUTILS
	
	self:getRootPath () 
	self:getExpPath()
	//Verifica a existência do diretório 
	if !existDir (self:cExpPend)
		makeDir(self:cExpPend)
	endif

return self:cExpPend

/*/{Protheus.doc} expPendPrc
//Resgata o caminho dos arquivos pendentes de exportação
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@param  cProcess, character, processo
@return characters, caminho 
/*/
method expPendPrc (cProcess) class SFUTILS
	local cPathExp := self:cExpPend+"\"+Capital(cProcess)

	self:getRootPath () 
	self:getExpPath()
	self:getExpPend()
	//Verifica a existência do diretório 
	if !existDir (cPathExp)
		makeDir(cPathExp)
	endif

return cPathExp


/*/{Protheus.doc} expPendPrc
//Resgata o caminho dos arquivo enviados por processo
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@param  cProcess, character, processo
@return characters, caminho 
/*/
method expSentPrc (cProcess) class SFUTILS
local cPathExp := self:cExpSent+"\"+Capital(cProcess)

self:getRootPath () 
self:getExpPath()
self:getExpSent()
//Verifica a existência do diretório 
if !existDir (cPathExp)
	makeDir(cPathExp)
endif

return cPathExp

method impReadPrc(cProcess,cStatus) class SFUTILS
	local cPathImp := self:cImpRead+"\"+Capital(cProcess)
	default cStatus := ""

	self:getRootPath () 
	self:getImpPath()
	self:getImpRead()

	//Verifica a existência do diretório 
	if !existDir (cPathImp)
		makeDir(cPathImp)
	endif

	if !empty(cStatus)
		cPathImp += "\"+capital(cStatus)
		if !existDir (cPathImp)
			makeDir(cPathImp)
		endif
	endif
return cPathImp

method impPendPrc(cProcess, cStatus) class SFUTILS
	local cPathImp := self:cImpPend+"\"+Capital(cProcess)
	
	default cStatus := ""

	self:getRootPath () 
	self:getImpPath()
	self:getImpPend()

	//Verifica a existência do diretório 
	if !existDir (cPathImp)
		makeDir(cPathImp)
	endif

	if !empty(cStatus)
		cPathImp += "\"+capital(cStatus)
		if !existDir (cPathImp)
			makeDir(cPathImp)
		endif
	endif

return cPathImp

/*/{Protheus.doc} getSendPth
//Resgata o caminho dos arquivos a serem enviados
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getSendPth() class SFUTILS

	self:getRootPath () 
	self:getExpPath()
	//Verifica a existência do diretório 
	if !existDir (self:cExpSend)
		makeDir(self:cExpSend)
	endif
return self:cExpSend

/*/{Protheus.doc} expSntPrc
//Resgata o caminho dos arquivos exportados
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@param  cProcess, character, processo
@return characters, caminho 
/*/
method expSntPrc (cProcess) class SFUTILS
	local cPathExp := self:cExpPend+"\"+Capital(cProcess)

	self:getRootPath () 
	self:getExpPath()
	self:getExpSent()
	//Verifica a existência do diretório 
	if !existDir (cPathExp)
		makeDir(cPathExp)
	endif

return cPathExp

/*/{Protheus.doc} getExpSent
//Resgata o caminho dos arquivos pendentes de exportação
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getExpSent () class SFUTILS
	
	self:getRootPath () 
	self:getExpPath()
	//Verifica a existência do diretório 
	if !existDir (self:cExpSent)
		makeDir(self:cExpSent)
	endif

return self:cExpSent

/*/{Protheus.doc} getImpPath
//Resgata o caminho raiz dos arquivos de importação 
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getImpPath () class SFUTILS
	
	self:getRootPath () 
	//Verifica a existência do diretório 
	if !existDir (self:cImpPath)
		makeDir(self:cImpPath)
	endif

return self:cImpPath

/*/{Protheus.doc} getImpRead
//Resgata o caminho dos arquivos de importação lidos
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getImpRead () class SFUTILS
	
	self:getRootPath () 
	self:getImpPath()
	//Verifica a existência do diretório 
	if !existDir (self:cImpRead)
		makeDir(self:cImpRead)
	endif

return self:cImpRead

/*/{Protheus.doc} getImpRead
//Resgata o caminho dos arquivos de importação pendentes
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getImpPend () class SFUTILS
	
	self:getRootPath () 
	self:getImpPath()
	//Verifica a existência do diretório 
	if !existDir (self:cImpPend)
		makeDir(self:cImpPend)
	endif

return self:cImpPend

/*/{Protheus.doc} getSfInPath
//Resgata o caminho raiz dos arquivos de registros
gerados a partir do Sales Force 
@author  marcio.katsumata
@since   23/07/2019
@version 1.0
@return characters, caminho 
/*/
method getSfInPath () class SFUTILS
	
	self:getRootPath () 

	//Verifica a existência do diretório 
	if !existDir (self:cSfInPath)
		makeDir(self:cSfInPath)
	endif

return self:cSfInPath


/*/{Protheus.doc} getSfInPend
//Resgata o caminho dos arquivos de registros
gerados a partir do Sales Force pendentes de importação
@author  marcio.katsumata
@since   23/07/2019
@version 1.0
@return characters, caminho 
/*/
method getSfInPend () class SFUTILS
	
	self:getRootPath() 
	self:getSfInPath()

	//Verifica a existência do diretório 
	if !existDir (self:cSfInPend)
		makeDir(self:cSfInPend)
	endif

return self:cSfInPend


/*/{Protheus.doc} getSfInRead
//Resgata o caminho dos arquivos de registros
gerados a partir do Sales Force importados
@author  marcio.katsumata
@since   23/07/2019
@version 1.0
@return characters, caminho 
/*/
method getSfInRead () class SFUTILS
	
	self:getRootPath() 
	self:getSfInPath()

	//Verifica a existência do diretório 
	if !existDir (self:cSfInRead)
		makeDir(self:cSfInRead)
	endif

return self:cSfInRead

/*/{Protheus.doc} getSemaforoPath
//Resgata o caminho do arquivo de semaforos
@author marcio.katsumata
@since07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getSchPath () class SFUTILS
	self:getRootPath () 
	//Verifica a existência do diretório 
	if !existDir (self:cSchedulePath)
		makeDir(self:cSchedulePath)
	endif
return self:cSchedulePath

/*/{Protheus.doc} getSftpPth
//Resgata o caminho do arquivo do app SFTP
@author marcio.katsumata
@since 07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getSftpPth () class SFUTILS
	self:getRootPath () 
	//Verifica a existência do diretório 
	if !existDir (self:cSftpPath)
		makeDir(self:cSftpPath)
	endif
return self:cSftpPath

/*/{Protheus.doc} getViewPth
//Resgata o caminho do arquivo do app SFTP
@author marcio.katsumata
@since 12/07/2019
@version 1.0
@return characters, caminho 
/*/
method getViewPth() class SFUTILS
	self:getRootPath() 
	//Verifica a existência do diretório 
	if !existDir (self:cViewPath)
		makeDir(self:cViewPath)
	endif
return self:cViewPath

/*/{Protheus.doc} writeLog
//grava arquivo de log referente à integração EccoSys
@author marcio.katsumata
@since07/07/2019
@version 1.0
@return nil, nil 
/*/
method writeLog (cFun,cText) class SFUTILS
	local cArquivo := self:getLogPath()+"\log_"+dtos(date())+".log"
	local cTimeStamp := "["+self:timeStamp(2)+"]["+cFun+"]"
	local cConteudo  := ""

	//Realiza limpeza no diretório , verificando o limite de arquivos no diretório.
	self:cleanDir(self:getLogPath())

	//Realiza a leitura do arquivo
	if file (cArquivo)
		cConteudo := memoread(cArquivo) 
	endif

	//Realiza a gravação do arquivo concatenando o conteúdo lido.
	memowrite (cArquivo, cConteudo+cTimeStamp+cText+CRLF)

return 

//-------------------------------------------------------------------
/*/{Protheus.doc} cleanDir
Realiza limpeza de diretorio, de acordo com a parametrização de numero
de arquivos.
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@param   cPath, character, diretório da limpeza.
@return  nil, nil
/*/
//-------------------------------------------------------------------
method cleanDir(cPath, nQtdLimite) class SFUTILS
	local aFiles     as array      //vetor com os arquivos que estão no diretório informado
	local nTotalArq  as numeric    //Quantidade de arquivos no diretório informado       
	local nInd       as numeric
	
	default nQtdLimite := superGetMv("ES_SFLGLMT", .F., 7) //Quantidade dlimite de arquivos no diretório   

	aFiles := {} 
	nTotalArq := 0

	if existDir(cPath)
	
		aFiles := Directory(cPath+"\*.*")
		nTotalArq := len(aFiles)

		if nTotalArq > 0

			aFiles := ASORT(aFiles, , , { | x,y | x[3] < y[3] } )

			if nQtdLimite <= nTotalArq
				nArqClean := nTotalArq - nQtdLimite
				for nInd := 1 to nArqClean
					fErase(cPath+"\"+aFiles[nInd][1])
				next nInd
			endif
		endif

	endif


return
/*/{Protheus.doc} timeStamp
//Retorna data ou data-hora conforme
parâmetro informado.
@author marcio.katsumata
@since07/07/2019
@version 1.0
@param nType, numeric, 1- Data, 2- Data-Hora
@return characters, timestamp
/*/
method timeStamp(nType) class SFUTILS

	local dDate as date
	local cRet  as character
	
	//--------------------------
	//Inicialização de variáveis
	//---------------------------
	dDate := date()
	cRet  := ""

	if nType == 1
		cRet := strzero(day(dDate),2)+"-"+strzero(month(dDate),2)+"-"+strzero(year(dDate),4)
	elseif nType == 2
		cRet := strzero(day(dDate),2)+"/"+strzero(month(dDate),2)+"/"+strzero(year(dDate),4)
		cRet += "-"+time()
	endif
	
return cRet 

/*/{Protheus.doc} useSemaforo
//Utiliza o semáforo de uma rotina.
@author marcio.katsumata
@since 07/07/2019
@version undefined
@return boolean, uso do semáforo autorizado
@param cSemaforo, characters, descricao
/*/
method useSemaforo(cSemaforo) class SFUTILS
	local lRet    as logical
	local aUsers  as array
	local nPosUsr as numeric 

	//--------------------------
	//Inicialização de variáveis
	//---------------------------
	lRet     := .F.
	aUsers   := GetUserInfoArray()
	nPosUsr  := aScan(aUsers, {|x| x[3] == ThreadId()})

	if nPosUsr > 0
		self:cInfoThread :=  aUsers[aScan(aUsers, {|x| x[3] == ThreadId()})][11] 
		lRet := aScan(aUsers, {|x|cSemaforo $ x[11]}) == 0
	
		if lRet
			ptInternal(1,cSemaforo+" semaforo iniciado: "+FwTimeStamp(3))
		endif
	endif
	
return lRet

/*/{Protheus.doc} liberaSemaforo
//Libera o semáforo para os próximos processamentos.
@author marcio.katsumata
@since 07/07/2019
@version 1.0
@return nil, nil
@param cSemaforo, characters, descricao
/*/
method liberaSemaforo(cSemaforo) class SFUTILS
	local lRet as logical

	//--------------------------
	//Inicialização de variáveis
	//---------------------------
	lRet := .F.
	
	ptInternal(1,self:cInfoThread)
	
return 

/*/{Protheus.doc} getSchedule
//Método responsável por verificar a última execução da função
e retorna se é possível prosseguir com a execução do processo.
@author marcio.katsumata
@since 07/07/2019
@version 1.0
@return boolean, prosseguir com o processamento
@param cArq, characters, função
@param cECJob, characters, descricao
@param cECIntervalo, characters, descricao
@param cTimeIni, characters, descricao
@param cTimeEnd, characters, descricao

/*/
method getSchedule(cArq,cECIntervalo,cTimeIni, cTimeEnd)  class SFUTILS

	Local lOk      as logical   //Retorna .T. caso seja o momento de executar a rotina conforme a ultima execucao e o parametro cECIntervalo
	Local cTempAnt as character //Obtem o a data e hora do ultimo processamento do arquivo gravado na pasta system do Protheus.
	Local dDataAtu as date      //Data atual
	Local cHoraAtu as character //Hora atual             
	Local dData    as date      //Data da ultima execucao
	Local cHora    as character //Hora da ultima execucao
	Local nRs      as numeric   //Resultado fracionado da subtracao da data e hora atual com a data e hora da ultima execucao
	Local cMinuto  as character //Resulta do nRS onde a fracao eh multiplicada 60 para converter a fracao em minutos
	Local aTemp    as array     //Obtem a data e hora da ultima execucao no vetor.

	Default cArq         := ""
	Default cECIntervalo := ""
	
	//--------------------------
	//Inicialização de variáveis
	//---------------------------
	lOk      := .T.     //Retorna .T. caso seja o momento de executar a rotina conforme a ultima execucao e o parametro cECIntervalo
	cTempAnt := ""      //Obtem o a data e hora do ultimo processamento do arquivo gravado na pasta system do Protheus.
	dDataAtu := Date()  //Data atual
	cHoraAtu := Time()  //Hora atual             
	dData    := CtoD(Space(8))   //Data da ultima execucao
	cHora    := ""      //Hora da ultima execucao
	nRs      := 0       //Resultado fracionado da subtracao da data e hora atual com a data e hora da ultima execucao
	cMinuto  := ""      //Resulta do nRS onde a fracao eh multiplicada 60 para converter a fracao em minutos
	aTemp    := {}     //Obtem a data e hora da ultima execucao no vetor.

	cArq := self:getSchPath()+'\'+cArq
	//set date format "dd/mm/yy"
	
	if cHoraAtu>=cTimeIni .and. cHoraAtu<=cTimeEnd

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Arquivo da ultima execucao do job ja existe.                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  File(cArq)      
			cTempAnt := MemoRead(cArq) //Le os Dados do Tempo do Final da ultima execucao deste job no arquivo .tmp
			If !Empty(cTempAnt)
				aTemp    := &("{'" + StrTran(cTempAnt,",","','") + "'}")
			EndIf
		EndIf     
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula os minutos passados desde a ultima execucao.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  !( Empty(cTempAnt) )
			dData := StoD(aTemp[1])
			cHora := aTemp[2]
	
			nRs := SubtHoras(dData, cHora, dDataAtu, cHoraAtu)
			cMinuto := StrTran(StrZero(int(nRs) + (((nRs - int(nRs)) * 60)/100),5,2),'.',':')
	
			If  (dData >= Date()) .And. (cECIntervalo > cMinuto)
				lOk := .F.
			EndIf
		EndIf
	else
		lOk := .F.
	endif
	
Return lOk

/*/{Protheus.doc} setSchedule
//Grava o arquivo referente ao horário de execução da função.
@author marcio.katsumata
@since 07/07/2019
@version 1.0
@return nil, nil
@param cArq, characters, nome da função do schedule.
/*/
method setSchedule(cArq) class SFUTILS
	cArq := self:getSchPath()+'\'+cArq
	MemoWrite(cArq,DtoS(Date())+','+Time())

return


//-------------------------------------------------------------------
/*/{Protheus.doc} normaliza
Realiza a normalização dos dados de acordo com a definição do layout
@author  marcio.katsumata
@since   07/07/2019
@version version
@param   xVar     , any    , dado a ser normalizado
@param   aTemplate, array  , template
@return  character, dado normalizado
/*/
//-------------------------------------------------------------------
method normaliza(xVar) CLASS SFUTILS
    local cNormaliz := ""
    //local aNumero   := ""

    //Tratativa para caracter
    if valType(xVar) == 'C'

        cNormaliz := alltrim(xVar)

    //Tratativa para numérico
    elseif valType(xVar) == 'N' 
		xVar := round (xVar,2)
        cNormaliz := strtran(alltrim(transform(xVar, '@E 9999999999.99')),",",".")

    //Tratativa para data
    elseif valType(xVar) == 'D'
        cNormaliz := dtoc(xVar)

	elseif valType(xVar) == 'L'
        cNormaliz := iif(xVar, 'TRUE', 'FALSE')
    endif

return cNormaliz


method getIni(lRetWeb) class SFUTILS
	local cArqIni as character
	local nHandle as numeric
	local aIniRet as array
	local nInd    as numeric
	//local cLinhas as character
	default lRetWeb := .F.

	cArqIni := self:getRootPath () +"\"+"salesforce.ini"
	aIniRet  := {}
	nInd    := 1
	nHandle := Ft_FUse(cArqIni)

	if nHandle >= 0
		while ! FT_FEof()

			cLinha := Ft_FReadLn()

			if "[" $ cLinha .and. substr(cLinha,1,1) <> ";" .and.;
				iif(lRetWeb, "WEBSERVICE"$ cLinha, !("WEBSERVICE"$ cLinha)) 
				
				aadd(aIniRet, {})
				nPosLen := len(aIniRet)
				aadd(aIniRet[nPosLen], strtran(strtran(cLinha, "[", ""), "]", ""))
				
				
				FT_FSkip()
				
				if !FT_FEof()
					cLinha := Ft_FReadLn()

					aadd(aIniRet[nPosLen], strtran(strtran(cLinha, "MAIN", ""), "=", ""))

					FT_FSkip()

					if !FT_FEof()
						cLinha := upper(Ft_FReadLn())
						nParms := val(alltrim(strtran(strtran(cLinha, "NPARMS", ""), "=", "")))

						aadd(aIniRet[nPosLen], array(nParms))

						FT_FSkip()

						while nInd <= nParms .and. ! FT_FEof()
							
							cLinha := upper(Ft_FReadLn())
							xValue := alltrim(strtran(strtran(cLinha,"PARM"+alltrim(cValToChar(nInd)), ""),"=",""))
							aIniRet[nPosLen][3][nInd] := xValue
							nInd++

							FT_FSkip()
						enddo

						nInd := iif(nInd>nParms, nParms, nInd--) 
						aSize(aIniRet[nPosLen][3], nInd)
						nInd := 1 
					endif
				endif	
			endif

			FT_FSkip()
		enddo

	endif
return aIniRet

user function sfutils()
return
