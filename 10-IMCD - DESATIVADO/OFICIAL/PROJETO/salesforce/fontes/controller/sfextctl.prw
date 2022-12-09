#include 'protheus.ch'
#include 'tryexception.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} SFGENCTL
Função de controller da execução de extração de dados para o sales
force. 
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   cEmpSF, character, código da empresa 
@param   cFilSF, character, código da filial
@param   cIntervalo, character, intervalo do processamento em hh:mm
@param   cTimeIni, character, horário inicial hh:mm:ss
@param   cTimeFim, character, horário final hh:mm:ss
@param   cSFJob  , character, nome do job 
@param   cViewName, character, nome da view a ser extraida
@param   dDataIni, date, data inicial a ser considerada para a extração
@param   dDataFim, date, data final a ser considerada para a extração
@param   cMsExp, character, utiliza o campo MSEXP para extração dos registros
@param   lEnd, boolean, flag de cancelamento de processamento
/*/
//-------------------------------------------------------------------
user function SFEXTCTL (cEmpSF, cFilSF,cIntervalo, cTimeIni, cTimeEnd,;
                        cSFJob, cViewName, dDataIni, dDataFim,cMsExp, lEnd) 

    local oGenAction    := nil              //Objeto com as ações a serem executadas pelo controller.
    local lJob          := .F.              //Determina se a execução é via job.
    local oException    := nil              //Objeto que armazena os erros caso ocorra.
    local oSfUtils      := SFUTILS():New()  //Objeto com funções de uso comum entre as rotinas.
    local cMsgErro      := ""               //Mensagem de erro
    local lOk           := .T.              //Processamento OK?
	local lUseMsExp     := .F.              //Usa a flag MSEXP para extração dos registros
    local cArq         as character
    
    default cEmpSF := ""
    default cFilSF := ""
    default cIntervalo := ""
    default cTimeIni   := ""
    default cTimeEnd   := ""
    default dDataIni   := stod("")
    default dDataFim   := stod("")
    default lEnd       := .F.
	default cMsExp     := 'T'

	lUseMsExp := cMsExp == 'T'

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
                cMsg :=  ("["+FwTimeStamp(3)+"] "+cSFJob+"- esta em uso.")
				FWLogMsg("INFO", "", "BusinessObject", cSFJob , "", "", cMsg, 0, 0)						
            endif
            return .T.
        endif 
    EndIf  
    
    tryException 
        //Prepara o ambiente se for job
        if lJob
            RpcSetType(3)
            RPCSetEnv(cEmpSF,cFilSF)
		endif
			
		dDataIni   := superGetMv("ES_SFDTINI",.F., stod(""))
		dDataFim   := superGetMv("ES_SFDTFIM",.F., stod(""))
		//----------------------------	
		//Instancia a classe de action
		//----------------------------
		oGenAction := SFEXTACT():new(cViewName,cSFJob, lJob, @lEnd)

		//------------------------------------------
		//Realiza a extração de dados em arquivo
		//------------------------------------------
		if lJob 
			//chama o método da action
				oGenAction:extract( dDataIni, dDataFim,@lOk,lUseMsExp,@cMsgErro)
			if !lOk
				//Grava arquivo de log de erros em arquivo
				oSfUtils:writeLog(cSFJob,cMsgErro)
			endif
		else	
			processa( {|| oGenAction:extract( dDataIni, dDataFim,@cMsgErro, @lOk)}, "Extraindo dados "+cSFJob, "Processando...",.F.)
			if !lOk
				aviso(cSFJob, cMsgErro, {"CANCELAR"}, 3)
			endif
		endif

		//-------------------------------------------------------
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
	if !empty(oGenAction)	
		oGenAction:destroy()
		freeObj(oGenAction)
	endif

	//Libera o semáforo
	oSfUtils:liberaSemaforo(cSFJob)
	
	freeObj(oSfUtils)       
return