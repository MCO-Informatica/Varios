#include 'protheus.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} FIEXPACT
Classe de action utilizada para a extração de dados para o FIORDE
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class FIEXPACT
    method new() constructor
    method export()
    method sendFtp()
    method destroy()
    method selFiles()
    method selExpFile()
    method sendMail()

    data oSysFiUtl   as object //objeto utils 
    data lJob      as boolean//indica se o processamento é via job
    data lEnd      as boolean//flag de cancelamento
    data aSending  as array  //array de arquivos a serem enviados via FTP
    data cFIJOB    as string //nome do job 
    data aFiliais  as array 
endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@param   cFIJob, character, nome do JOB que está sendo executada.
@param   lJob, boolean, indica a rotina está sendo executada por job
@param   lEnd, boolean, flag de cancelamento do processo.
@return  object, self
/*/
//-------------------------------------------------------------------
method new(cFIJob, lJob, lEnd) class FIEXPACT

    default lJob := .T.
    //------------------------------------
    //Inicialização dos atributos
    //------------------------------------
    self:oSysFiUtl := SYSFIUTL():new()
    self:lJob      := lJob
    self:lEnd      := lEnd
    self:cFIJob    := cFIJob
    self:aFiliais  := self:oSysFiUtl:getFilCnpj()
return

//-------------------------------------------------------------------
/*/{Protheus.doc} export
Exportação dos arquivos que estão na pasta pending
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@param   lOkConnect, logical, conexão com sucesso.
@param   cMsgErro, character, mensagem de erro
@return  object, model 
/*/
//-------------------------------------------------------------------
method export(lOkConnect, cMsgErro) class FIEXPACT

    local aLogSet as array      //array de dataset para a gravação da tabela de logs EWZ/ZNT
    local oFiLogWrt as object   //objeto para gravação das tabelas EWZ e ZNT
    local lOkConnect as logical //retorno da conexão FTP
    local cFiLog  as character  //filial do arquivo
    local cNumPo  as character  //Numero do PO
    local cNumDesp as character //Codigo despachante
    local nPosFil  as numeric   //Posição da filial no array
    local lSeekOk as logical    //Seek ok?
    local nIndFile as numeric   //Indice de navegação entre os arquivos
    private aStrFile as array   //Array com as informações do arquivo 
    //---------------------------
    //Inicialização de variáveis
    //---------------------------
    lOkProc := .F.
    aLogSet := {}
    cNumDesp := strzero(val(superGetMv("ES_FIDESPC", .F., "")), 6)
    aFilAtu := FWArrFilAtu()
    //------------------------------------------------------
    //Verifica a existência de arquivos pendentes de envio
    //------------------------------------------------------
    if self:selFiles(aFilAtu[18]) .or. self:selExpFile() 
        if lOkConnect := self:sendFtp(self:aSending, @cMsgErro)
        
            for nIndFile := 1 to len (self:aSending)

                if self:aSending[nIndFile][4] 
                    //---------------------------------------------------------------
                    //Define o status de envio do arquivo via FTP para ser gravado
                    //na tabela EWZ (log de processamento)
                    //---------------------------------------------------------------
                    cStatus := "ENV"
                    cType   :=  upper(self:aSending[nIndFile][5])
                    if self:aSending[nIndFile][5] $ 'epo/edi'
                        aLogSet :=  {}
                        aadd(aLogSet,{"EWZ_STATUS", cStatus}  )
                        aadd(aLogSet,{"EWZ_DATAEN", date()})
                        aadd(aLogSet,{"EWZ_HORAEN", time()})

                        //----------------------------------
                        //Realiza a gravação do LOG 
                        //----------------------------------
                        lSeekOk := .F.

                        oFiLogWrt  := FILOGWRT():new(self:aSending[nIndFile][1],.T.,cType,,@lSeekOk, @cMsgErro)
                        cFilLog    := oFiLogWrt:getFiLog()
                        cNumPo     := oFiLogWrt:getNumPo()
                        if lSeekOK
                            oFiLogWrt:update(aLogSet)
                        else
                            self:oSysFiUtl:writeLog( self:cFIJob,cMsgErro)
                        endif    
                    
                        
                        oFiLogWrt:destroy()
                        freeObj(oFiLogWrt)
                        aSize(aLogSet,0)
                    else
                     
                        aStrFile := strTokArr2(self:aSending[nIndFile][1], "_",.T.)
                        nPosFil  := aScan(self:aFiliais, {|aFilAtu|alltrim(aFilAtu[2])==alltrim(aStrFile[2])})
                        cFilLog  :=  iif (nPosFil > 0, self:aFiliais[nPosFil][1], "")
                        cNumPo   :=  aStrFile[3]
                        aSize(aStrFile, 0)
                    endif
                   
                    lSeekOk := .F.   

                    aLogSet :=  {}
                    aadd(aLogSet,{"ZNT_NUMPO", cNumPo}  )
                    aadd(aLogSet,{"ZNT_ETAPA", cType}  )
                    if self:aSending[nIndFile][5] $ 'epo/edi'
                        cFileAux := lower(self:aSending[nIndFile][1])
                        aadd(aLogSet,{"ZNT_STATUS", "1"}  )
                    else
                        cFileAux  := lower(self:aSending[nIndFile][1])
                        cFileAux := strtran(cFileAux,"_error.txt","")
                        cFileAux := strtran(cFileAux,"_success.txt","")
                    endif

                    aadd(aLogSet,{"ZNT_FILE", cFileAux}  )
                    aadd(aLogSet,{"ZNT_STDATE", date()})
                    aadd(aLogSet,{"ZNT_STHOUR", time()})


                    oFiLogWrt  := FILOGWRT():new(cFileAux,.F.,cType,cFilLog,@lSeekOk, @cMsgErro)

                    if lSeekOK .or. self:aSending[nIndFile][5] $ 'epo/edi'
                        oFiLogWrt:update(aLogSet)
                    else
                        self:oSysFiUtl:writeLog( self:cFIJob,cMsgErro)
                    endif   

                    oFiLogWrt:destroy()
                    freeObj(oFiLogWrt)
                    aSize(aLogSet,0)
                    
                    __copyfile(self:aSending[nIndFile][2], self:aSending[nIndFile][3])
                    FErase(self:aSending[nIndFile][2])

                endif    
            next nIndFile
        endif
        //-------------------------
        //Limpeza de array e objeto
        //-------------------------
        aSize(self:aSending,0)
    else 
        lOkConnect:= .T.    
    endif

    aSize(aFilAtu,0)
return

//-------------------------------------------------------------------
/*/{Protheus.doc} sendFtp
Realiza a escrita do arquivo a ser exportado.
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method sendFtp(aFiles, cMsgErro) class FIEXPACT
    local cPath as character  //Caminho do arquivo a ser utilizada para o arquivo já enviado
    local oSftpUtil as object //Objeto de auxilio de envio de arquivos via SFTP

    
    //---------------------------------------
    //Inicializando variáveis
    //---------------------------------------
    oSftpUtil := SYSFIOFTP():new()

    //Verifica a URL do SFTP
    oSftpUtil:getUrl()

    //Verifica a credenciais de autenticação
    if lRet:=oSftpUtil:getAuth(@cMsgErro)

        //Realiza a transmissão do arquivo
        if  !oSftpUtil:sendFiles(self:aSending, @cMsgErro)
            self:oSysFiUtl:writeLog( self:cFIJob,cMsgErro)
        endif
    endif

    oSftpUtil:destroy()
    freeObj(oSftpUtil)
return  lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Realiza a limpeza de objetos
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy() class FIEXPACT


    freeObJ(self:oSysFiUtl)

return


//-------------------------------------------------------------------
/*/{Protheus.doc} selFiles
marcio.katsumata
@author  marcio.katsumata
@since   13/07/2019
@version 1.0
@return  boolean, existe arquivo para transferência? .T. = Sim, .F. = Não
/*/
//-------------------------------------------------------------------
method selFiles(cCnpjAtu) class FIEXPACT

    local aDirPend as array      //Lista de diretórios da pasta pending
    local cPath    as character  //Caminho da pasta pending
    local nInd      as numeric   //Indice 
    local nInd2     as numeric   //Indice  
    local lOk       as logical   //Retorno de sucesso   
    local aType     as array

    //--------------------------------------------
    //Inicialização de variáveis
    //--------------------------------------------
    aDirPend := {}
    self:aSending := {}
    lOk      := .F.

    cDestiny := self:oSysFiUtl:getEnviado()
    cPath := self:oSysFiUtl:getGerado()

    aDirPend := Directory(cPath+"*"+cCnpjAtu+"*.txt", "D")


    for nInd := 1 to len(aDirPend)

        //-------------------------------------------------------------------------------
        //Inserindo a entidade no array de arquivos
        //-------------------------------------------------------------------------------
        //Estrutura do array
        //      -Nome do arquivo
        //      -Caminho origem (onde o arquivo se encontra)
        //      -Caminho destino (onde o arquivo deve ser movido após o processamento
        //      -Envio FTP Ok?
        //      -Tipo de arquivo. EDI - DI(Embarque)
        //                        EPO - PO(Purchase Order)
        //--------------------------------------------------------------------------------
        cType := lower(substr(aDirPend[nInd][1],1,3))

        aadd(self:aSending, {lower(aDirPend[nInd][1]), cPath+"\"+lower(aDirPend[nInd][1]), cDestiny+"\"+lower(aDirPend[nInd][1]),.F.,cType})    
        lOk := .T.
    next

    
return lOk

//-------------------------------------------------------------------
/*/{Protheus.doc} selExpFile
Método responsável pela exportação de arquivos success e error 
resultados da importação dos processos recebidos pela Fiorde.
@author  marcio.katsumata
@since   23/09/2019
@version 1.0
@return  logical, existe arquivo?
/*/
//-------------------------------------------------------------------
method selExpFile() class FIEXPACT
    local aDirPend as array      //Lista de diretórios da pasta pending
    local cPath    as character  //Caminho da pasta pending
    local cRootPath as character //RootPath do Protheus
    local aDirAux   as array     //Diretório auxiliar para naveção entre as pastas do diretório pending
    local nInd      as numeric   //Indice 
    local nInd2     as numeric   //Indice  
    local lOk       as logical   //Retorno de sucesso   
    local cSent     as character //Diretório da pasta de arquivos enviados.  
    Local nIndSta   as numeric

    //--------------------------------------------
    //Inicialização de variáveis
    //--------------------------------------------
    cRootPath := GetSrvProfString ("ROOTPATH","")
    aDirAux  := {}
    aDirPend := {}
    self:aSending := {}
    lOk      := .F.
    cSent    := ""
    cPath    := self:oSysFiUtl:getExpPend()
    aStatus  := {"success", "error"}
    
    aDirPend := Directory(cPath+"\*.*","D")

    for nInd := 1 to len(aDirPend)

        if aDirPend[nInd][1] <> '.' .and. aDirPend[nInd][1] <> '..'

            //-------------------------------------------------------------------
            //Verifica se existem arquivos nos subdiretórios da pasta pendentes.
            //-------------------------------------------------------------------
            cPathAux := cPath+"\"+aDirPend[nInd][1]


            //Navega entre as pastas Success e Error
            for nIndSta := 1 to len(aStatus)

                cType := lower(alltrim(aDirPend[nInd][1]))
                //Limpeza do array auxiliar
                aSize(aDirAux,0)

                //Verifica o diretório de arquivos pendentes por tipo de arquivo
                cSent := self:oSysFiUtl:expSentPrc (cType, aStatus[nIndSta])
                cPending := self:oSysFiUtl:expPendPrc (cType, aStatus[nIndSta])

                //Realiza a verificação de arquivos dentro do diretorio 
                aDirAux  := directory(cPending+"\*.*")

                //Se existir arquivos no subdiretório armazena-los no array de arquivos a enviar
                for nInd2 :=1 to len(aDirAux)
                    if aDirAux[nInd2][1] <> '.' .and. aDirAux[nInd2][1] <> '..'
                        aadd(self:aSending, {aDirAux[nInd2][1], cPending+"\"+aDirAux[nInd2][1], cSent+"\"+aDirAux[nInd2][1],.F.,cType,aStatus[nIndSta] })    
                        lOk := .T.
                    endif
                next nInd2
            next nIndSta
        endif
    next nInd

    aSize(aDirAux,0)
    aSize(aDirPend,0)
    aSize(aStatus,0)
return lOk 
//-------------------------------------------------------------------
/*/{Protheus.doc} sendMail
Envia notifição de indisponibilidade do server FTP por e-mail .
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@param   cMsgErro, character, mensagem de erro
@return  boolean, sucesso no envio do e-mail
/*/
//-------------------------------------------------------------------
method sendMail(cMsgErro) class FIEXPACT

	local lRet      as logical   //Envio OK?
    local cAssunto  as character //Assunto do e-mail
    local cMensagem as character //Mensagem do e-mail
	local cEmail    as character //E-mail destino
	local oSfMail   as object    //Classe para envio de e-mail


	cEmail := supergetMv("ES_MAILFIOR", .F., "m.katsumata@everysys.com.br")
    cAssunto := "[FTP FIORDE] Falha de conectividade no  FTP FIORDE "
	cMensagem := " <html><p>Falha no envio de FTP </p> "+;
                 " <p> Cheque a conectividade do FTP Fiorde.Data Referência:"+ dtoc(date())+"</p>"

	oSfMail := SFMAIL():new()

	if oSfMail:getAuth()
		lRet := oSfMail:sendMail(cAssunto,cMensagem,cEmail,{},@cMsgErro)
	endif

	freeObj(oSfMail)

return lRet




user function FIEXPACT()
return