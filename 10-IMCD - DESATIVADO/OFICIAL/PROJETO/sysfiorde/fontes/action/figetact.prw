#include 'protheus.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} FIGETACT
Classe de action utilizada para a extração de dados para o FIORDE
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class FIGETACT
    method new() constructor
    method getFiles()
    method getFtp()
    method destroy()


    data oSysFiUtl   as object //objeto utils 
    data lJob      as boolean//indica se o processamento é via job
    data lEnd      as boolean//flag de cancelamento
    data cFIJob    as string // nome do job
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
method new(cFIJob,lJob, lEnd) class FIGETACT

    default lJob := .T.
    //------------------------------------
    //Inicialização dos atributos
    //------------------------------------
    self:oSysFiUtl := SYSFIUTL():new()
    self:lJob      := lJob
    self:lEnd      := lEnd
    self:cFIJob    := cFIJob
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
method getFiles(lOkConnect, cMsgErro,aRetArq) class FIGETACT

    local cPath as character  //Caminho do arquivo a ser utilizada para o arquivo já enviado
    local oSftpUtil as object //Objeto de auxilio de envio de arquivos via FTP

    
    //---------------------------------------
    //Inicializando variáveis
    //---------------------------------------
    oSftpUtil := SYSFIOFTP():new()

    //Verifica a URL do SFTP
    oSftpUtil:getUrl()

    //Verifica a credenciais de autenticação
    if lOkConnect:=oSftpUtil:getAuth(@cMsgErro)
        aRetArq := {{},{}}
        //Realiza a transmissão do arquivo
        if oSftpUtil:getFiles(@cMsgErro,@aRetArq)
            self:oSysFiUtl:writeLog( self:cFIJob,cMsgErro)
        endif
    endif

    oSftpUtil:destroy()
    freeObj(oSftpUtil)
return  


//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Realiza a limpeza de objetos
@author  marcio.katsumata
@since   03/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy() class FIGETACT
    freeObJ(self:oSysFiUtl)
return

user function FIGETACT()
return