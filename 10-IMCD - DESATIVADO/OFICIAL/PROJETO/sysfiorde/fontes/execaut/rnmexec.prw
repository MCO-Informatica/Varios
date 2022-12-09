#include 'protheus.ch'
#Define REC_NUMERARIO "RNU"


//-------------------------------------------------------------------
/*/{Protheus.doc} RNMEXEC
Processamento da integração de numerário.
@author  marcio.katsumata
@since   17/09/2019
@version 1.0
@param   cFilePrc, character, nome do arquivo
@param   cFilProc, character, filial em que deve ser processado
@param   cMsgError, character, mensagem de erro
@param   cErrorFile, character, mensagem de erro para arquivo de retorno proc. sysfiorde
@param   cComPth   , character, caminho completo do arquivo processado
@return  logical, retorno do processamento.
/*/
//-------------------------------------------------------------------
user function RNMEXEC(cFilePrc ,cFilProc,cErroExec, cErrorFile, cCompPth)
    local oEICINT   as object
    local cWork     as character
    local cFilBkp   as character
    local oSysFiUtl as object
    local cMsgEI100 as character
    //--------------------------------
    //Classe utils do projeto fiorde
    //--------------------------------
    oSysFiUtl := SYSFIUTL():new()

    //-------------------------------
    //Realiza o tramamento de filial
    //-------------------------------
    cFilBkp := cFilAnt
    cMsgEI100 := ""
    //---------------------------------------------------
    //O módulo deve ser o EIC para o processamento padrão
    //---------------------------------------------------
    cModulo   := "EIC"

    //-----------------------------------------------
    //Classe responsável pela importação do arquivo
    //-----------------------------------------------
    oEICINT:= FIEICINT():New("Controle de Integrações com Despachante", "Serviços", "Ações", "Serviços", "Ações", "Serviços")
    cFilAnt := cFilProc
    oEICINT:SetServicos()
    oEICINT:cDirNumerario := oSysFiUtl:impPendPrc("rnm")

    //--------------------------------------------------------------------------------
    //Realiza a primeira validação do arquivo e recebimento do arquivo na tabela EWZ 
    //Este método também grava o arquivo na pasta comex de arquivos recebidos
    //--------------------------------------------------------------------------------
    if (lRet:= oEICINT:ReceberArq("EWZ",REC_NUMERARIO, cFilePrc, @cErroExec))

        //-----------------------------------
        //Realiza o processamento do arquivo 
        //-----------------------------------
        lRet:= oEICINT:ProcessarArq("EWZ", REC_NUMERARIO, @cErroExec)

    endif

    //-------------------
    //Limpeza dos objetos
    //-------------------
    freeObj(oEICINT)
    freeObj(oSysFiUtl)
    
    //-------------------
    //Restaura filial
    //-------------------
    cFilAnt    := cFilBkp

    //-----------------------------------------
    //Replicação das mensagens de erro
    //----------------------------------------
    cErrorFile += cErroExec   

return {lRet, cErroExec, cErrorFile, .F.}