#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} SFEXPACT
Classe de action utilizada para a extração de dados para o Sales Force
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFEXPACT

    method new() constructor
    method export()
    method sendFtp()
    method destroy()
    method selFiles()
    method sendMail()

    data oSfUtil   as object //objeto utils 
    data lJob      as boolean//indica se o processamento é via job
    data lEnd      as boolean//flag de cancelamento
    data cSFJob    as string //job que está sendo processado
    data aSending  as array  //array de arquivos a serem enviados via SFTP
endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   cSFJob, character, nome do JOB que está sendo executada.
@param   lJob, boolean, indica a rotina está sendo executada por job
@param   lEnd, boolean, flag de cancelamento do processo.
@return  object, self
/*/
//-------------------------------------------------------------------
method new(cSFJob,lJob, lEnd) class SFEXPACT

    default lJob := .T.
    //------------------------------------
    //Inicialização dos atributos
    //------------------------------------
    self:oSfUtil := SFUTILS():new()
    self:lJob      := lJob
    self:lEnd      := lEnd
    self:cSFJob    := cSFJob

return

//-------------------------------------------------------------------
/*/{Protheus.doc} export
Exportação dos arquivos que estão na pasta pending
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   lOkProc , boolean, processamento realizado com sucesso?
@param   cMsgErro, character, mensagem de erro
@return  object, model 
/*/
//-------------------------------------------------------------------
method export(lOkProc,cMsgErro) class SFEXPACT

    local oSfMod as object     //Objeto Model
    local aLogSet as array     //array de dataset para a gravação da tabela de logs ZNP
    local oSfLog as object     //objeto para gravação das tabelas ZNO e ZNP (logs)
    local lArq   as logical
    Local nInd := 0
    local nInd2 := 0 

    //---------------------------
    //Inicialização de variáveis
    //---------------------------
    lOkProc := .F.
    lArq    := .F.
    aLogSet := {}

    //------------------------------------------------------
    //Verifica a existência de arquivos pendentes de envio
    //------------------------------------------------------
    if self:selFiles() 

        for nInd := 1 to len (self:aSending)
            if !empty(self:aSending[nInd][2])
                aEval(self:aSending[nInd][2], {|aSend|__copyfile(aSend[2], aSend[3],,,.F.)})
                lArq := .T.
                lOkProc := self:sendFtp(self:aSending[nInd][1], cMsgErro,self:lJob )

                //---------------------------------------------------------------
                //Define o status de envio do arquivo via SFTP para ser gravado
                //na tabela ZNO (log de processamento)
                //---------------------------------------------------------------
                cStatus := iif (lOkProc, "2", "E")
                aLogSet := {{"ZNO_STATUS", cStatus},;
                            {"ZNO_STDATE", date()},;
                            {"ZNO_STHOUR", time()}}
                

                for nInd2 := 1 to len(self:aSending[nInd][2])
                    //----------------------------------
                    //Realiza a gravação do LOG ZNO/ZNP
                    //----------------------------------
                    oSfLog  := SFLOGWRT():new(, self:aSending[nInd][2][nInd2][1], ,@lOkProc, .F.)
                    if lOkProc
                        oSfLog:updateHead(aLogSet)
                        oSfLog:save() 
                        oSfLog:destroy()
                    endif
                    freeObj(oSfLog)

                next nInd2

                //----------------------------------------------------------------
                //Caso o processamento ocorra com sucesso realiza a movimentação 
                //dos arquivos exportados, movendo ele para a pasta de enviados
                //Apaga da pasta sending e pending
                //-----------------------------------------------------------------
                if lOkProc
                    aEval(self:aSending[nInd][2], {|aSend|__copyfile(aSend[3], aSend[4])})
                    aEval(self:aSending[nInd][2], {|aSend|FErase(aSend[3])})
                    aEval(self:aSending[nInd][2], {|aSend|FErase(aSend[2])})
                else
                    //------------------------------------------------------
                    //Caso o processamento não ocorra com sucesso
                    //apaga somente o arquivo da pasta sending
                    //------------------------------------------------------
                    aEval(self:aSending[nInd][2], {|aSend|FErase(aSend[3])})
                endif
            endif    
        next nInd
        
        //-------------------------
        //Limpeza de array e objeto
        //-------------------------
        aSize(aLogSet,0)
        aSize(self:aSending,0)
        
    endif

    lOkProc := (lOkProc .and. lArq) .or. (!lOkProc .and. !lArq)    

return 

//-------------------------------------------------------------------
/*/{Protheus.doc} sendFtp
Realiza a escrita do arquivo a ser exportado.
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method sendFtp(cEntity, cMsgErro, lJob) class SFEXPACT
    local cPath as character  //Caminho do arquivo a ser utilizada para o arquivo já enviado
    local oSftpUtil as object //Objeto de auxilio de envio de arquivos via SFTP
    default lJob := .T.
    
    //---------------------------------------
    //Inicializando variáveis
    //---------------------------------------
    oSftpUtil := SFFTPUTIL():new()
    //Resgatando a pasta de envio de arquivos.
    cPath := self:oSfUtil:getSendPth () 

    //Verifica a URL do SFTP
    oSftpUtil:getUrl()
    //Verifica a credenciais de autenticação
    oSftpUtil:getAuth()
    //Realiza a transmissão do arquivo
	lRet := oSftpUtil:sendFile(cEntity,cPath,@cMsgErro)
	

return  lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Realiza a limpeza de objetos
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy() class SFEXPACT


    freeObJ(self:oSfUtil)

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
method selFiles() class SFEXPACT

    local aDirPend as array      //Lista de diretórios da pasta pending
    local cPath    as character  //Caminho da pasta pending
    local cRootPath as character //RootPath do Protheus
    local aDirAux   as array     //Diretório auxiliar para naveção entre as pastas do diretório pending
    local nInd      as numeric   //Indice 
    local nInd2     as numeric   //Indice  
    local lOk       as logical   //Retorno de sucesso   
    local cSent     as character //Diretório da pasta de arquivos enviados.  
    local cEmpSF    as character //Empresa a ser considerada
    local cDestFile as character //Nome do arquivo destino
    local cFromFile as character //Nome do arquivo origem

    //--------------------------------------------
    //Inicialização de variáveis
    //--------------------------------------------
    cRootPath := GetSrvProfString ("ROOTPATH","")
    aDirAux  := {}
    aDirPend := {}
    self:aSending := {}
    lOk      := .F.
    cSent    := ""
    cDestiny := self:oSfUtil:getSendPth() 
    cPath    := self:oSfUtil:getExpPend()
    aDirPend := Directory(cPath+"\*.*","D")
    cEmpSF   := "69"+PADR(cValToChar(val(cEmpAnt)),3,"0") // Código da empresa SF.

    for nInd := 1 to len(aDirPend)

        //Limpeza do array auxiliar
        aSize(aDirAux,0)

        if aDirPend[nInd][1] <> '.' .and. aDirPend[nInd][1] <> '..'

            //-------------------------------------------------------------------
            //Verifica se existem arquivos nos subdiretórios da pasta pendentes.
            //-------------------------------------------------------------------
            cPathAux := cPath+"\"+aDirPend[nInd][1]
            aDirAux  := directory(cPathAux+"\*.*")

            //-------------------------------------------------------------------------------
            //Inserindo a entidade no array de arquivos
            //-------------------------------------------------------------------------------
            //Estrutura do array
            //- Accounts (Entidade)
            //  -Arquivos da entidade
            //      -Nome do arquivo
            //      -Caminho origem (onde o arquivo se encontra)
            //      -Caminho destino (onde o arquivo deve ser movido após o processamento)
            //--------------------------------------------------------------------------------
            aadd(self:aSending,{} )
            nPos:= len(self:aSending)
            aadd(self:aSending[nPos],capital(aDirPend[nInd][1]))
            aadd(self:aSending[nPos],{})

            //Verifica o diretório de arquivos enviados por tipo de arquivo
            cSent := self:oSfUtil:expSentPrc (lower(alltrim(aDirPend[nInd][1])))

            //Se existir arquivos no subdiretório armazena-los no array de arquivos a enviar
            for nInd2 :=1 to len(aDirAux)
                if aDirAux[nInd2][1] <> '.' .and. aDirAux[nInd2][1] <> '..'
                    if cEmpSF $ aDirAux[nInd2][1] 
                        if "SALESORDERDETAIL" $ aDirAux[nInd2][1]
                            cFromFile := lower(aDirAux[nInd2][1])
                            cDestFile := strtran(lower(aDirAux[nInd2][1]), "salesorderdetail", "SalesOrderDetail")
                        elseif "SALESORDER" $ aDirAux[nInd2][1]
                            cFromFile := lower(aDirAux[nInd2][1])
                            cDestFile := strtran(lower(aDirAux[nInd2][1]), "salesorder", "SalesOrder")
                        else
                            cFromFile := lower(aDirAux[nInd2][1])
                            cDestFile := lower(aDirAux[nInd2][1])
                        endif
                                                                            
                        aadd(self:aSending[nPos][2], {aDirAux[nInd2][1], cPathAux+"\"+cFromFile, cDestiny+"\"+cDestFile, cSent+"\"+aDirAux[nInd2][1]})    
                        lOk := .T.
                    endif
                endif
            next nInd2

        endif
    next

return lOk

//-------------------------------------------------------------------
/*/{Protheus.doc} sendMail
Envia notifição de indisponibilidade do server SFTP por e-mail .
@author  marcio.katsumata
@since   07/06/2019
@version 1.0
@param   cMsgErro, character, mensagem de erro
@return  boolean, sucesso no envio do e-mail
/*/
//-------------------------------------------------------------------
method sendMail(cMsgErro) class SFEXPACT

	local lRet      as logical
	local cAssunto  as character
	local cMensagem as character
	local cEmail    as character
	local oSfMail   as object


	cEmail := supergetMv("ES_MAILCRM", .F., "m.katsumata@everysys.com.br")
    cAssunto := "[SFTP Sales Force] Falha de conectividade no  SFTP Sales Force "
	cMensagem := " <html><p>Aconteceu falhas consecutivas no envio de SFTP </p> "+;
                 " <p> Cheque a conectividade do SFTP Sales Force.Data Referência:"+ dtoc(date())+"</p>"

	oSfMail := SFMAIL():new()

	if oSfMail:getAuth()
		lRet := oSfMail:sendMail(cAssunto,cMensagem,cEmail,{},@cMsgErro)
	endif

	freeObj(oSfMail)

return lRet

user function sfexpact()
return