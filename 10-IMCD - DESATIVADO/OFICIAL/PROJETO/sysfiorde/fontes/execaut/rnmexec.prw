#include 'protheus.ch'
#Define REC_NUMERARIO "RNU"


//-------------------------------------------------------------------
/*/{Protheus.doc} RNMEXEC
Processamento da integra��o de numer�rio.
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
    //O m�dulo deve ser o EIC para o processamento padr�o
    //---------------------------------------------------
    cModulo   := "EIC"

    //-----------------------------------------------
    //Classe respons�vel pela importa��o do arquivo
    //-----------------------------------------------
    oEICINT:= FIEICINT():New("Controle de Integra��es com Despachante", "Servi�os", "A��es", "Servi�os", "A��es", "Servi�os")
    cFilAnt := cFilProc
    oEICINT:SetServicos()
    oEICINT:cDirNumerario := oSysFiUtl:impPendPrc("rnm")

    //--------------------------------------------------------------------------------
    //Realiza a primeira valida��o do arquivo e recebimento do arquivo na tabela EWZ 
    //Este m�todo tamb�m grava o arquivo na pasta comex de arquivos recebidos
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
    //Replica��o das mensagens de erro
    //----------------------------------------
    cErrorFile += cErroExec   

return {lRet, cErroExec, cErrorFile, .F.}