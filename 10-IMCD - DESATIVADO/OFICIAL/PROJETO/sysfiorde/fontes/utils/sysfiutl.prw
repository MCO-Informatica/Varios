#include 'protheus.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} SYSFIUTL
Classe SYSFIUTL, classe utils do projeto SYSFIORDE
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SYSFIUTL 

    method new() constructor
    method getRootPath()
    method getComex()
    method getAuthPath()
    method getIntDesp()
    method getEnviado()
    method getGerado()
    method getRejeitado()
    method getRecebido()
    method getIntegrado()
    method getSftpPth() 
    method getLogPath() 
    method timeStamp()
    method cleanDir()
	method encryptTxt()
    method decryptTxt()
    method getSchedule()
    method setSchedule()
	method getSchPath()
	method getImpRead()
	method getImpPend() 
	method getImpPath() 
	method impReadPrc()
	method impPendPrc()
    method writeLog()
    method liberaSemaforo()
	method useSemaforo()
	method getFilCnpj()
	method checkEDI()
	method getExpPend() 
	method getExpSent() 
	method getExpPath()
	method expSentPrc()
	method expPendPrc()
	method getIni()
	
    data cRootPath    as string
    data cAuthPath    as string
    data cRootComex   as string
    data cPthIntDesp  as string
    data cPthEnviado  as string
    data cPthGerado   as string
    data cPthReject   as string
    data cPthInteg    as string
    data cPthReceb    as string
    data cLogPath      as string
    data cSchedulePath as string
	data cInfoThread    as string  
	data cImpPath     as string
	data cImpPend     as string
	data cImpRead     as string
	data cExpPend     as string
	data cExpPath     as string
	data cExpSent     as string

endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
método construtor.
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@return  self, objeto SYSFIUTL
/*/
//-------------------------------------------------------------------
method new () class SYSFIUTL
    self:cRootComex  := "\comex\"
    self:cRootPath   := "\fiorde\"
    self:cAuthPath   := self:cRootPath+"auth\"
    self:cPthIntDesp := self:cRootComex+"intdespachante\" 
    self:cPthEnviado := self:cPthIntDesp+"enviados\"
    self:cPthGerado  := self:cPthIntDesp+"gerados\"
    self:cPthReject  := self:cPthIntDesp+"rejeitados\"
    self:cPthInteg   := self:cPthIntDesp+"integrados\"
    self:cPthReceb   := self:cPthIntDesp+"recebidos\"
    self:cLogPath      := self:cRootPath + "\logs"
	self:cSchedulePath := self:cRootPath +"\schedule"
	self:cImpPath      := self:cRootPath +"\imp"
	self:cImpPend      := self:cImpPath+"\pending"
	self:cImpRead      := self:cImpPath+"\readed"
	self:cExpPath      := self:cRootPath +"\exp"
	self:cExpPend      := self:cExpPath+"\pending"
	self:cExpSent      := self:cExpPath+"\sent"
return

/*/{Protheus.doc} getRootPath
//Resgata o rootpath da pasta para gravação de arquivos sysfiorde
@author marcio.katsumata
@since 02/09/2019
@version 1.0
@return characters, rootpath
/*/
method getRootPath () class SYSFIUTL
    //Verifica a existência do diretório 
    if !existDir (self:cRootPath)
        makeDir(self:cRootPath)
    endif
return self:cRootPath

/*/{Protheus.doc} getAuthPath
//Resgata o caminho do arquivo de autenticação
@author marcio.katsumata
@since 02/09/2019
@version 1.0
@return characters, caminho 
/*/
method getAuthPath () class SYSFIUTL
	self:getRootPath () 
	//Verifica a existência do diretório 
	if !existDir (self:cAuthPath)
		makeDir(self:cAuthPath)
	endif
return self:cAuthPath		

//-------------------------------------------------------------------
/*/{Protheus.doc} getComex
método responsável pelo retorno do rootpath do comex
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@return  character, rootpath do comex 
/*/
//-------------------------------------------------------------------
method getComex() class SYSFIUTL
return self:cRootComex 

//-------------------------------------------------------------------
/*/{Protheus.doc} getIntDesp
método responsável por retornar o caminho completo até a pasta
de integração com o despachante.
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@return  character, pasta de integração com o despachante.
/*/
//-------------------------------------------------------------------
method getIntDesp() class SYSFIUTL
return self:cPthIntDesp

//-------------------------------------------------------------------
/*/{Protheus.doc} getEnviado
Método responsável por retornar o caminho completo até a pasta de 
arquivos enviados para o despachante.
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@return  character, pasta de enviados da integração com o despachante. 
/*/
//-------------------------------------------------------------------
method getEnviado() class SYSFIUTL
return self:cPthEnviado

//-------------------------------------------------------------------
/*/{Protheus.doc} getGerado
Método responsável por retornar o caminho completo até a pasta de 
arquivos gerados para o despachante.
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@return  character, pasta de gerados da integração com o despachante. 
/*/
//-------------------------------------------------------------------
method getGerado() class SYSFIUTL
return self:cPthGerado

//-------------------------------------------------------------------
/*/{Protheus.doc} getRejeitado
Método responsável por retornar o caminho completo até a pasta de 
arquivos rejeitados pelo despachante.
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@return  character, pasta de rejeitados da integração com o despachante. 
/*/
//-------------------------------------------------------------------
method getRejeitado() class SYSFIUTL
return self:cPthReject 


//-------------------------------------------------------------------
/*/{Protheus.doc} getRecebido
Método responsável por retornar o caminho completo até a pasta de 
arquivos recebidos pelo despachante.
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@return  character, pasta de rejeitados da integração com o despachante. 
/*/
//-------------------------------------------------------------------
method getRecebido() class SYSFIUTL
return self:cPthReceb 


//-------------------------------------------------------------------
/*/{Protheus.doc} getIntegrado
Método responsável por retornar o caminho completo até a pasta de 
arquivos integrados do despachante.
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@return  character, pasta de integrados da integração com o despachante. 
/*/
//-------------------------------------------------------------------
method getIntegrado() class SYSFIUTL
return self:cPthInteg 

/*/{Protheus.doc} getSftpPth
//Resgata o caminho do arquivo do app SFTP
@author marcio.katsumata
@since 02/09/2019
@version 1.0
@return characters, caminho 
/*/
method getSftpPth () class SYSFIUTL
	self:getRootPath () 
	//Verifica a existência do diretório 
	if !existDir (self:cSftpPath)
		makeDir(self:cSftpPath)
	endif
return self:cSftpPath

/*/{Protheus.doc} getLogPath
//Resgata o caminho do arquivo de logs
@author marcio.katsumata
@since 02/09/2019
@version 1.0
@return characters, caminho 
/*/
method getLogPath () class SYSFIUTL
	self:getRootPath () 
	//Verifica a existência do diretório 
	if !existDir (self:cLogPath)
		makeDir(self:cLogPath)
	endif
return self:cLogPath

/*/{Protheus.doc} getSchPath
//Resgata o caminho do arquivo de schedule
@author marcio.katsumata
@since 03/09/2019
@version 1.0
@return characters, caminho 
/*/
method getSchPath () class SYSFIUTL
	self:getRootPath () 
	//Verifica a existência do diretório 
	if !existDir (self:cSchedulePath)
		makeDir(self:cSchedulePath)
	endif
return self:cSchedulePath

/*/{Protheus.doc} getImpPath
//Resgata o caminho raiz dos arquivos de importação 
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getImpPath () class SYSFIUTL
	
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
method getImpRead () class SYSFIUTL
	
	self:getRootPath () 
	self:getImpPath()
	//Verifica a existência do diretório 
	if !existDir (self:cImpRead)
		makeDir(self:cImpRead)
	endif

return self:cImpRead

/*/{Protheus.doc} getImpPend
//Resgata o caminho dos arquivos de importação pendentes
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getImpPend () class SYSFIUTL
	
	self:getRootPath () 
	self:getImpPath()
	//Verifica a existência do diretório 
	if !existDir (self:cImpPend)
		makeDir(self:cImpPend)
	endif

return self:cImpPend

//-------------------------------------------------------------------
/*/{Protheus.doc} impReadPrc
Resgata o caminho dos arquivos de importação lidos por processo
@author  marcio.katsumata
@since   04/09/2019
@version 1.0
@param   cProcess, character, processo
@param   cStatus, character, status (success, error)
/*/
//-------------------------------------------------------------------
method impReadPrc(cProcess,cStatus) class SYSFIUTL
	local cPathImp := self:cImpRead+"\"+cProcess+"\"

	default cStatus := ""

	self:getRootPath () 
	self:getImpPath()
	self:getImpRead()

	//Verifica a existência do diretório 
	if !existDir (cPathImp)
		makeDir(cPathImp)
	endif
	if !empty(cStatus)
		cPathImp += (cStatus)
		if !existDir (cPathImp)
			makeDir(cPathImp)
		endif
	endif

return cPathImp

//-------------------------------------------------------------------
/*/{Protheus.doc} impPendPrc
Resgata o caminho dos arquivos de importação lidos por processo
@author  marcio.katsumata
@since   04/09/2019
@version 1.0
@param   cProcess, character, processo
@param   cStatus, character, status (success, error)
/*/
//-------------------------------------------------------------------
method impPendPrc(cProcess, cStatus) class SYSFIUTL
	local cPathImp := self:cImpPend+"\"+cProcess+"\"

	default cStatus := ""

	self:getRootPath () 
	self:getImpPath()
	self:getImpPend()

	//Verifica a existência do diretório 
	if !existDir (cPathImp)
		makeDir(cPathImp)
	endif

	if !empty(cStatus)
		cPathImp += "\"+cStatus
		if !existDir (cPathImp)
			makeDir(cPathImp)
		endif
	endif

return cPathImp

/*/{Protheus.doc} getExpPath
//Resgata o caminho raiz dos arquivos extraidos
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getExpPath () class SYSFIUTL
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
method getExpPend () class SYSFIUTL
	
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
method expPendPrc (cProcess, cStatus) class SYSFIUTL
	local cPathExp := self:cExpPend+"\"+(cProcess)

	self:getRootPath () 
	self:getExpPath()
	self:getExpPend()
	//Verifica a existência do diretório 
	if !existDir (cPathExp)
		makeDir(cPathExp)
	endif

	cPathExp += "\"+cStatus
	if !existDir (cPathExp)
		makeDir(cPathExp)
	endif

return cPathExp

/*/{Protheus.doc} getExpPend
//Resgata o caminho dos arquivos pendentes de exportação
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@return characters, caminho 
/*/
method getExpSent () class SYSFIUTL
	
	self:getRootPath () 
	self:getExpPath()
	//Verifica a existência do diretório 
	if !existDir (self:cExpSent)
		makeDir(self:cExpSent)
	endif

return self:cExpSent


/*/{Protheus.doc} expSentPrc
//Resgata o caminho dos arquivo enviados por processo
@author  marcio.katsumata
@since   07/07/2019
@version 1.0
@param  cProcess, character, processo
@return characters, caminho 
/*/
method expSentPrc (cProcess, cStatus) class SYSFIUTL
	local  cPathExp := self:cExpSent+"\"+(cProcess)

	self:getRootPath () 
	self:getExpPath()
	self:getExpSent()
	//Verifica a existência do diretório 
	if !existDir (cPathExp)
		makeDir(cPathExp)
	endif

	cPathExp += "\"+cStatus
	if !existDir (cPathExp)
		makeDir(cPathExp)
	endif

return cPathExp

/*/{Protheus.doc} timeStamp
//Retorna data ou data-hora conforme
parâmetro informado.
@author marcio.katsumata
@since 07/07/2019
@version 1.0
@param nType, numeric, 1- Data, 2- Data-Hora
@return characters, timestamp
/*/
method timeStamp(nType) class SYSFIUTL

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

//-------------------------------------------------------------------
/*/{Protheus.doc} encryptTxt
//Criptografia RC4 das chaves de autenticação.
@author marcio.katsumata
@since 07/07/2019
@version 1.0
@param cText, characters, texto a ser criptografado.
@return characters, return_description
/*/
//-------------------------------------------------------------------
method encryptTxt(cText) class SYSFIUTL
    local cRet as character
    cRet = rc4crypt( cText ,"fiordeinteg", .T.)
return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} decryptTxt
//Descriptografia RC4 das chaves de autenticação.
@author marcio.katsumata
@since 07/07/2019
@version 1.0
@param cEncrypted, characters, texto a ser descriptografado.
@return return, return_description
/*/
//-------------------------------------------------------------------
method decryptTxt(cEncrypted) class SYSFIUTL
    local cOriginal as character
    cOriginal = rc4crypt(cEncrypted, "fiordeinteg", .F., .T.)
return cOriginal

/*/{Protheus.doc} getSchedule
//Método responsável por verificar a última execução da função
e retorna se é possível prosseguir com a execução do processo.
@author marcio.katsumata
@since 07/07/2019
@version 1.0
@return boolean, prosseguir com o processamento
@param cArq, characters, função
@param cECIntervalo, characters, descricao
@param cTimeIni, characters, descricao
@param cTimeEnd, characters, descricao

/*/
method getSchedule(cArq,cECIntervalo,cTimeIni, cTimeEnd)  class SYSFIUTL

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
method setSchedule(cArq) class SYSFIUTL
	cArq := self:getSchPath()+'\'+cArq
	MemoWrite(cArq,DtoS(Date())+','+Time())

return

/*/{Protheus.doc} writeLog
//grava arquivo de log referente à integração EccoSys
@author marcio.katsumata
@since 02/09/2019
@version 1.0
@return nil, nil 
/*/
method writeLog (cFun,cText) class SYSFIUTL
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
@since   02/09/2019
@version 1.0
@param   cPath, character, diretório da limpeza.
@return  nil, nil
/*/
//-------------------------------------------------------------------
method cleanDir(cPath, nQtdLimite) class SYSFIUTL
local aFiles     as array      //vetor com os arquivos que estão no diretório informado
local nTotalArq  as numeric    //Quantidade de arquivos no diretório informado       
local nInd as numeric

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

/*/{Protheus.doc} useSemaforo
//Utiliza o semáforo de uma rotina.
@author marcio.katsumata
@since 03/09/2019
@version undefined
@return boolean, uso do semáforo autorizado
@param cSemaforo, characters, descricao
/*/
method useSemaforo(cSemaforo) class SYSFIUTL
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
@since 03/09/2019
@version 1.0
@return nil, nil
@param cSemaforo, characters, descricao
/*/
method liberaSemaforo(cSemaforo) class SYSFIUTL
	local lRet as logical

	//--------------------------
	//Inicialização de variáveis
	//---------------------------
	lRet := .F.
	
	ptInternal(1,self:cInfoThread)
	
return 

//-------------------------------------------------------------------
/*/{Protheus.doc} getFilCnpj
Método que retorna um array com os códigos das filiais e cnpjs das
filiais da empresa logada.
@author  marcio.katsumata
@since   05/09/2019
@version 1.0
@return  array, filiais e cnpjs
/*/
//-------------------------------------------------------------------
method getFilCnpj() class SYSFIUTL
	local aFiliais as array
	local aSM0     as array
	local nFil as numeric
	aFiliais := {}
	aSM0     := {}

	aFiliais := FWLoadSM0 ()    

	for nFil := 1 to len(aFiliais)

		if aFiliais[nFil][1] == cEmpAnt
			aadd(aSM0, {aFiliais[nFil][2],aFiliais[nFil][18]})

		endif

	next nFil

	aSize(aFiliais,0)

return aSM0

//-------------------------------------------------------------------
/*/{Protheus.doc} checkEDI
Verifica se existe embarque processado pelo SYSFIORDE
@author  marcio.katsumata
@since   06/09/2019
@version 1.0
@param   cNumProc, character, processamento
@return  boolean, existe?
/*/
//-------------------------------------------------------------------
method checkEDI(cNumProc) class SYSFIUTL

	local cAliasZNT as character

	cAliasZNT := getNextAlias()

    beginSql alias cAliasZNT
        SELECT * FROM %table:ZNT% ZNT
            WHERE ZNT.ZNT_ETAPA = 'EDI' AND
                  ZNT.ZNT_STATUS = '2'  AND
                  ZNT.ZNT_NUMPO  = %exp:cNumProc% AND
                  ZNT.%notDel%
    endSql

    lEDI := (cAliasZNT)->(!eof())
	(cAliasZNT)->(dbCloseArea())

return lEDI
//-------------------------------------------------------------------
/*/{Protheus.doc} getIni
Resgata o ini para realizar o sequeciamento de execução dos jobs fiorde.
@author  marcio.katsumata
@since   23/09/2019
@version 1.0
@return  array, vetor com as rotinas que devem ser executadas e seus
                parâmetros
/*/
//-------------------------------------------------------------------
method getIni() class SYSFIUTL
	local cArqIni as character
	local nHandle as numeric
	local aIniRet as array
	local nInd    as numeric
	local cLinhas as character


	cArqIni := self:getRootPath () +"\"+"sysfiorde.ini"
	aIniRet  := {}
	nInd    := 1
	nHandle := Ft_FUse(cArqIni)

	if nHandle >= 0
		while ! FT_FEof()

			cLinha := Ft_FReadLn()

			if "[" $ cLinha .and. substr(cLinha,1,1) <> ";"
				
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

user function SYSFIUTL()
return