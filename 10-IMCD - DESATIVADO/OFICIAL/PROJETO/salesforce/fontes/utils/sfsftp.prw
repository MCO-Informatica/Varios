#include "protheus.ch"
#include "shell.ch"

static aMsgs

//------------------------------------------------------------------------------------------------
/*/
CLASS:
Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
Data:29/04/2015
Descricao:Transferencia de dados segura usando o protocolo SFTP a partir do pscp.exe
Sintaxe:SFSFTP():New()->Objeto do Tipo SFSFTP

//------------------------------------------------------------------------------------------------
Documentacao de uso de pscp.exe:
http://tartarus.org/~simon/putty-snapshots/htmldoc/Chapter5.html#pscp-starting

//------------------------------------------------------------------------------------------------
Downloads do pscp.exe:
http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html

//------------------------------------------------------------------------------------------------
Obs.: pscp.exe devera ser adicionado como Resource no Projeto do IDE (TDS)
TODO: (1) Implementar o envio via socket utilizando o Harbour como conector sftp (https://github.com/NaldoDj/PuTTY)

//------------------------------------------------------------------------------------------------
PuTTY Secure Copy client

Release 0.64

Usage:

pscp [options] [user@]host:source target
pscp [options] source [source...] [user@]host:target
pscp [options] -ls [user@]host:filespec

Options:

-V        print version information and exit
-pgpfp    print PGP key fingerprints and exit
-p        preserve file attributes
-q        quiet, don't show statistics
-r        copy directories recursively
-v        show verbose messages
-load sessname  Load settings from saved session
-P port   connect to specified port
-l user   connect with specified username
-pw passw login with specified password
-1 -2     force use of particular SSH protocol version
-4 -6     force use of IPv4 or IPv6
-C        enable compression
-i key    private key file for user authentication
-noagent  disable use of Pageant
-agent    enable use of Pageant
-hostkey aa:bb:cc:...
manually specify a host key (may be repeated)
-batch    disable all interactive prompts
-unsafe   allow server-side wildcards (DANGEROUS)
-sftp     force use of SFTP protocol
-scp      force use of SCP protocol
/*/

//------------------------------------------------------------------------------------------------
CLASS SFSFTP
    DATA aSFTPLog

    DATA cClassName
    DATA nError
    DATA oParameters
    METHOD New() CONSTRUCTOR
    METHOD FreeObj() /*DESTRUCTOR*/
    METHOD ClassName()
    METHOD Get(cParameter)
    METHOD Set(cParameter,uValue)
    METHOD Execute(cSource,cTarget,cURL,cUSR,cPWD,cMode,cPort,nSWMode)
END CLASS
User Function SFTP()
    Return(SFSFTP():New())
METHOD New() CLASS SFSFTP
    self:ClassName()
    self:nError:=0
    self:aSFTPLog:=Array(0)
    IF FindFunction("U_THash")
        self:oParameters:=tHash():New()
    EndIF
    LoadMsgs()
    Return(self)
METHOD FreeObj() CLASS SFSFTP
    IF (Valtype(self:oParameters)=="O")
        self:oParameters:=self:oParameters:FreeObj()
    EndIF
    aSize(self:aSFTPLog,0)
    self:=FreeObj(self)
    Return(self)
METHOD ClassName() CLASS SFSFTP
    self:cClassName:="SFSFTP"
    Return(self:cClassName)
METHOD Get(cParameter) CLASS SFSFTP
    Local uValue
    IF (Valtype(self:oParameters)=="O")
        uValue:=self:oParameters:Get(cParameter)
    EndIF
    Return(uValue)
METHOD Set(cParameter,uValue) CLASS SFSFTP
    IF (Valtype(self:oParameters)=="O")
        uValue:=self:oParameters:Set(cParameter,uValue)
    EndIF
    Return(self)
METHOD Execute(cSource,cTarget,cURL,cUSR,cPWD,cMode,cPort,nSWMode) CLASS SFSFTP

    Local aFiles

    Local cAppSFTP:="pscp.exe"
    Local cBatSFTP:="pscp.bat"
    Local cFile
    Local cDirTmp
    Local cDirSFTP
    Local cDirAux
    Local cSrvPath
    Local cTmpFile
    Local cRootPath
    Local cLogAppSFTP
    Local cfLogAppSFTP
    Local ctLogAppSFTP
    Local cFullAppSFTP
    Local cFullBatSFTP
    Local cCommandLine
    Local cWaitRunPath
    Local lCopyFile

    Local nError:=0

    Local nFile
    Local nFiles
    local oSfUtils := SFUTILS():new()

    BEGIN SEQUENCE
        IF (Valtype(self:oParameters)=="O")
            DEFAULT cSource:=self:Get("cSource")
            DEFAULT cTarget:=self:Get("cTarget")
            DEFAULT cURL:=self:Get("cURL")
            DEFAULT cUSR:=self:Get("cUSR")
            DEFAULT cPWD:=self:Get("cPWD")
            DEFAULT cMode:=self:Get("cMode")
            DEFAULT lSrv:=self:Get("lSrv")
            DEFAULT cPort:=self:Get("cPort")
            DEFAULT lForceClient:=self:Get("lForceClient")
            DEFAULT nSWMode:=self:Get("nSWMode")
        EndIF

        DEFAULT cSource:=""
        DEFAULT cTarget:=""
        DEFAULT cURL:=""
        DEFAULT cUSR:=""
        DEFAULT cPWD:=""
        DEFAULT cPort:="22"

        //-------------------------------------------------------------------------------
        //cMode=>P:Put;G:Get
        DEFAULT cMode:="P"

        DEFAULT nSWMode:=SW_MAXIMIZE


        
        //-------------------------------------------------------------------------------
        //Obtem o RootPath do Protheus
        cRootPath:=AllTrim(GetSrvProfString("ROOTPATH",""))
        IF .NOT.(Right(cRootPath,1)=="\")
            cRootPath+="\"
        EndIF
    
        //-------------------------------------------------------------------------------
        //Define o Caminho para o aplicativo de Transferencia SFTP
        cDirSFTP:= oSfUtils:getSftpPth()+"\"
        //-------------------------------------------------------------------------------
        //Verifica a existencia do diretorio para Extracao do aplicativo de Transferencia SFTP
        IF .NOT.(ExistDir(cDirSFTP))
            IF .NOT.(MakeDir(cDirSFTP)==0)
                nError:=-1
                cMsg := ("["+ProcName()+"]["+LoadMsgs(nError)+"]["+cDirSFTP+"]")
                FWLogMsg("INFO", "", "BusinessObject", "SFSFTP" , "", "", cMsg, 0, 0)
                BREAK
            EndIF
        EndIF

        //-------------------------------------------------------------------------------
        //Obtem o Caminho completo do aplicativo de Transferencia SFTP
        cFullAppSFTP:=(cDirSFTP+cAppSFTP)
        //-------------------------------------------------------------------------------
        //Verifica a existencia aplicativo de Transferencia SFTP
        /*IF .NOT.(File(cFullAux))
            //-------------------------------------------------------------------------------
            //Extrai, do Repositorio de Objetos, o aplicativo de Transferencia SFTP
            //Obs: Pressupoe, para a extracao, que ele foi adicionado como Resource no processo de compilacao
            IF .NOT.(Resource2File(cAppSFTP,cFullAux))
                nError:=-2
                ConOut("["+ProcName()+"]["+LoadMsgs(nError)+"]["+cFullAppSFTP+"]")
                BREAK
            EndIF
        EndIF*/

        //-------------------------------------------------------------------------------
        //Elabora o Comando para execucao do Aplicativo de Transferencia SFTP
        //-------------------------------------------------------------------------------
        //Exemplo Client:
        //P:pscp.exe -sftp -C -l cUSR -pw cPWD -P cPort C:\tmp\files\*.txt cURL:cTarget
        //G:pscp.exe -sftp -C -l cUSR -pw cPWD -P cPort cURL:cTarget/*.txt C:\tmp\files\
        //-------------------------------------------------------------------------------
        //Exemplo Server:
        //P:pscp.exe -sftp -C -l cUSR -pw cPWD -P cPort \tmp\files\*.txt cURL:cTarget
        //G:pscp.exe -sftp -C -l cUSR -pw cPWD -P cPort cURL:cTarget/*.txt \tmp\files\
        //-------------------------------------------------------------------------------
        cCommandLine:=""


        cfLogAppSFTP:=cDirSFTP
        cCommandLine+=cRootPath+cDirSFTP

        IF .NOT.(Right(cfLogAppSFTP,1)=="\")
            cfLogAppSFTP+="\"
        EndIF

        //-------------------------------------------------------------------------------
        //Define o arquivo que conter� o log de execucao do Aplicativo de Transferencia SFTP
        ctLogAppSFTP:=CriaTrab(NIL,.F.)+".log"
        cfLogAppSFTP+=ctLogAppSFTP
        //-------------------------------------------------------------------------------
        //Adiciona o Aplicativo de Transferencia SFTP
        cCommandLine+=cAppSFTP
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //show verbose messages
        cCommandLine+="-v"
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //force use of SFTP protocol
        cCommandLine+="-sftp"
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //enable compression
        cCommandLine+="-C"
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //connect with specified username
        cCommandLine+="-l"
        cCommandLine+=" "
        cCommandLine+=cUSR
        //-------------------------------------------------------------------------------
        //login with specified password
        cCommandLine+=" "
        cCommandLine+="-pw"
        cCommandLine+=" "
        cCommandLine+=cPWD
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //connect to specified port
        cCommandLine+="-P"
        cCommandLine+=" "
        cCommandLine+=cPort
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //Verifica cMode
        IF (cMode=="P")
            //-------------------------------------------------------------------------------
            //Ajusta cTarget
            cTarget:=StrTran(cTarget,"\","/")
            IF (Right(cTarget,1)=="/")
                cTarget:=SubStr(cTarget,1,(Len(cTarget)-1))
            EndIF
            //-------------------------------------------------------------------------------
            //Verifica se a Transferencia vai ser feita a partir Servidor

            cCommandLine+=cRootPath
            IF (Left(cSource,1)=="\")
                cCommandLine+=SubStr(cSource,2)
            Else
                cCommandLine+=cSource
            EndIF

            cCommandLine+=" "
            cCommandLine+=cURL
            cCommandLine+=":"
            cCommandLine+=cTarget
        Else //cMode=="G"
            cCommandLine+=cURL
            cCommandLine+=":"
            cCommandLine+=cSource
            cCommandLine+=" "

            cCommandLine+=cRootPath
            IF (Left(cTarget,1)=="\")
                cCommandLine+=SubStr(cTarget,2)
            Else
                cCommandLine+=cTarget
            EndIF

        EndIF
        //-------------------------------------------------------------------------------
        //Adiciona a Saida do Log
        cCommandLine+=" >> "
        cCommandLine+=cRootPath+cfLogAppSFTP
        cCommandLine+=" "

        //-------------------------------------------------------------------------------
        //Define o Batch File
        cFullBatSFTP:=StrTran(cfLogAppSFTP,ctLogAppSFTP,cBatSFTP)
        cFullBatSFTP := strtran(cFullBatSFTP, cRootPath, "")
        //-------------------------------------------------------------------------------
        //Redefine cCommandLine incluindo mode con
        cCommandLine:="mode con:lines=45 cols=165"+CRLF+cCommandLine
        //-------------------------------------------------------------------------------
        //Grava o Comando no Batch File
        MemoWrite(cFullBatSFTP,cCommandLine)

        //-------------------------------------------------------------------------------
        //Redefine cCommandLine
        cCommandLine:=cRootPath+cFullBatSFTP


        //-------------------------------------------------------------------------------
        //Executa o Comando de Transferencia no Server
        //Onde:
        //cCommandLineLine:Instrucao a ser executada
        //lWaitRun:Se deve aguardar o termino da Execucao
        //Path:Onde, no server, a funcao devera ser executada
        //Retorna:.T. Se conseguiu executar o Comando, caso contrario, .F.
        //Read more:http://www.blacktdn.com.br/2011/04/protheus-executando-aplicacoes-externas.html#ixzz3YemwKcI7
        //WaitRunSrv(cCommandLineLine,lWaitRun,cPath):lSuccess
        cWaitRunPath:=cRootPath
        cWaitRunPath+=IF(Left(cDirSFTP,1)=="\",SubStr(cDirSFTP,2),cDirSFTP)
        IF .NOT.(WaitRunSrv(cCommandLine,.T.,cWaitRunPath))
            nError:=-3
            cMsg := ("["+ProcName()+"]["+LoadMsgs(nError)+"]["+cCommandLine+"][Path]["+cRootPath+"]")
            FWLogMsg("INFO", "", "BusinessObject", "SFSFTP" , "", "", cMsg, 0, 0)            
            BREAK
        EndIF
        nError:=0


    END SEQUENCE

    //-------------------------------------------------------------------------------
    //Obtem o Log de Execucao
    IF .NOT.(Empty(cfLogAppSFTP))
        IF File(cfLogAppSFTP)
            cLogAppSFTP:=MemoRead(cfLogAppSFTP)
            cMsg := ("["+ProcName()+"][LOG]",cfLogAppSFTP)
            FWLogMsg("INFO", "", "BusinessObject", "SFSFTP" , "", "", cMsg, 0, 0)              
            fErase(cfLogAppSFTP)
        EndIF
    EndIF

    self:nError:=nError

    freeObj(oSfUtils)
Return(self:nError)


Static Function LoadMsgs(nError)
    Local cMsg
    Local nMsg
    DEFAULT aMsgs:=Array(0)
    IF Empty(aMsgs)
        aAdd(aMsgs,{0,"OK"})
        aAdd(aMsgs,{-1,"Impossivel Criar Diretorio"})
        aAdd(aMsgs,{-2,"Recurso de Transferencia SFTP nao Encontrado"})
        aAdd(aMsgs,{-3,"Problema na Execucao do Comando"})
        aAdd(aMsgs,{-4,""})
        aAdd(aMsgs,{-5,""})
        aAdd(aMsgs,{-6,""})
        aAdd(aMsgs,{-7,""})
        aAdd(aMsgs,{-8,""})
        aAdd(aMsgs,{-9,""})
    EndIF
    IF (ValType(nError)=="N")
        nMsg:=aScan(aMsgs,{|e|e[1]==nError})
        IF (nMsg>0)
            cMsg:=aMsgs[nMsg][2]
        EndIF
    EndIF
    DEFAULT cMsg:=""
    Return(cMsg)