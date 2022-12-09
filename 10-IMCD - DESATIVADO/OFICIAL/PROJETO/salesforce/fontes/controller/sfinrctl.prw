#include 'protheus.ch'
#include 'tryexception.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} SFINRCTL
Função de controller da importação do arquivo gerado no sales force
com o resutado da exportação de informações reaizada.
@author  marcio.katsumata
@since   19/07/2019
@version 1.0
@param   cEmpSF, character, código da empresa 
@param   cFilSF, character, código da filial
@param   cIntervalo, character, intervalo do processamento em hh:mm
@param   cTimeIni, character, horário inicial hh:mm:ss
@param   cTimeFim, character, horário final hh:mm:ss
@param   lEnd, boolean, flag de cancelamento de processamento
/*/
//-------------------------------------------------------------------
user function SFINRCTL(cEmpSF, cFilSF,cIntervalo, cTimeIni, cTimeEnd,lEnd) 

    local oSfInrAct   as object      //Objeto com as ações a serem executadas pelo controller.
    local lJob         as logical    //Determina se a execução é via job.
    local oException   as object     //Objeto que armazena os erros caso ocorra.
    local oSfUtils     as object     //Objeto com funções de uso comum entre as rotinas.
    local cMsgErro     as character  //Mensagem de erro
    local lOk          as logical    //Status de processamento
	local cSFJob       as character  //Nome do job que está sendo executado
    local cArq         as character
    
    default cEmpSF := ""
    default cFilSF := ""
    default cIntervalo := ""
    default cTimeIni   := ""
    default cTimeEnd   := ""
	default lEnd       := .F.  
	
	//---------------------------------------------------------------
	//Incializando variáveis
	//---------------------------------------------------------------
    oSfInrAct := nil             
    lJob      := .F.             
    oException:= nil              
    oSfUtils  := SFUTILS():New()  
    cMsgErro  := ""               
    lOk       := .T.              
	cSFJob    := "SFINRCTL"+cEmpSF



	//Verifica se o controller está sendo executado por um JOB.
    lJob   := !empty(cEmpSF)
    cArq   := cSFJob+".tmp"
    
    //Verifica se o intervalo venceu para poder executar o job.
    If  lJob .And. !( oSfUtils:getSchedule(cArq, cIntervalo, cTimeIni, cTimeEnd) )
        Return .T.  //Cancela a execucao antes de preparar o ambiente.
    else
        //Tenta reservar o semáforo
        if !oSfUtils:useSemaforo(cSFJob)	
            If !lJob
                aviso (cSFJob, "O processo já está sendo executado por um JOB ou por um outro usuário", {"Cancelar"}, 2)
            else
                cMsg :=   ("["+FwTimeStamp(3)+"] "+cSFJob+"- esta em uso.")
				FWLogMsg("INFO", "", "BusinessObject", cSFJob , "", "", cMsg, 0, 0)		 
            endif
            return .T.
        endif 
    endif


    tryException    
        lOk := .F.

        if lJob 
            //Prepara o ambiente 
            RpcSetType(3)
            RPCSetEnv(cEmpSF,cFilSF)

			oSfInrAct := SFINRACT():new(lJob, lEnd)
			//-------------------------------
            //Realiza o processo de importação dos
            //arquivos retornados do Sales Force
			//-------------------------------
			oSfInrAct:import(@lOk,@cMsgErro)
			if !lOk
				oSfUtils:writeLog( cSFJob,cMsgErro,5)
            endif
        else
            processa( {|| oSfInrAct:import(@lOk,@cMsgErro)}, "Importado arquivos recebidos", "Importando...",.F.)
            if !lOk
                aviso(cSFJob, cMsgErro, {"CANCELAR"}, 3)
            endif        

        endif
        
        //-------------------------------------------------------s
        //Limpa o ambiente se estiver sendo executada por um job
        //-------------------------------------------------------
        if lJob
            oSfUtils:setSchedule(cArq)
            RpcClearEnv()
        endif

    catchException using oException
        if lJob
            oSfUtils:writeLog( cSFJob ,iif (oException <> nil, oException:ErrorStack, "Exceção " +cSFJob ))
            RpcClearEnv()
        else
            aviso(cSFJob, iif (oException <> nil, oException:ErrorStack, "Exceção " +cSFJob), {"CANCELAR"}, 3)
        endif
    endException	

    if ValType(oException) == "O"
        freeObj(oException)
    endif       

    //Limpa o objeto da Action
    if !empty(oSfInrAct)	
        oSfInrAct:destroy()
        freeObj(oSfInrAct)
    endif

    //Libera o semáforo
    oSfUtils:liberaSemaforo(cSFJob)
    
    //Limpeza do objeto SfUtils
    freeObj(oSfUtils) 

RETURN
