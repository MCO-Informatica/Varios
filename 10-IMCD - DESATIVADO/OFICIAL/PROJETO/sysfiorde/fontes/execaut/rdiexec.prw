#include 'protheus.ch'
#Define REC_DESPESAS  "RDE"


//-------------------------------------------------------------------
/*/{Protheus.doc} RDIEXEC
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
user function RDIEXEC(cFilePrc ,cFilProc,cErroExec, cErrorFile, cCompPth)
   local oEICINT       as object
   local cWork         as character
   local cFilBkp       as character
   local oSysFiUtl     as object
   local lRet          as logical
   local nIndDi        as numeric 
   local nIndReg       as numeric
   private aDIEXCFI    as array
   private cParcDIEx   as character
   private lPrimDIEx   as logical

   //--------------------------------
   //Classe utils do projeto fiorde
   //--------------------------------
   oSysFiUtl := SYSFIUTL():new()

   //-------------------------------
   //Realiza o tramamento de filial
   //-------------------------------
   cFilBkp     := cFilAnt
   lPrimDIEx   := .T.

   //---------------------------
   //Inicializador de variáveis
   //---------------------------
   cParcDIEx   := "A"
   lRet := .T.

   //---------------------------------------------------
   //O módulo deve ser o EIC para o processamento padrão
   //---------------------------------------------------
   cModulo   := "EIC"  

   //-----------------------------------------------
   //Classe responsável pela importação do arquivo
   //-----------------------------------------------
   oEICINT:= FIEICINT():New("Controle de Integrações com Despachante", "Serviços", "Ações", "Serviços", "Ações", "Serviços")
   cFilAnt     := cFilProc
   oEICINT:SetServicos()
   oEICINT:cDirDespesas := oSysFiUtl:impPendPrc("rdi")

   //--------------------------------------------------------------------------------
   //Realiza a primeira validação do arquivo e recebimento do arquivo na tabela EWZ 
   //Este método também grava o arquivo na pasta comex de arquivos recebidos
   //--------------------------------------------------------------------------------
   if (lRet:= oEICINT:ReceberArq("EWZ",REC_DESPESAS, cFilePrc, @cErroExec))

      //-----------------------------------
      //Realiza o processamento do arquivo 
      //-----------------------------------
      lRet:= oEICINT:ProcessarArq("EWZ", REC_DESPESAS, @cErroExec)

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