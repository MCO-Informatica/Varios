#include 'protheus.ch'
#include 'tryexception.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} SFGENCTL
Fun��o de controller da execu��o de extra��o de dados para o sales
force. 
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   cEmpSF, character, c�digo da empresa 
@param   cFilSF, character, c�digo da filial
@param   cIntervalo, character, intervalo do processamento em hh:mm
@param   cTimeIni, character, hor�rio inicial hh:mm:ss
@param   cTimeFim, character, hor�rio final hh:mm:ss
@param   cSFJob  , character, nome do job 
@param   cViewName, character, nome da view a ser extraida
@param   dDataIni, date, data inicial a ser considerada para a extra��o
@param   dDataFim, date, data final a ser considerada para a extra��o
@param   cMsExp, character, utiliza o campo MSEXP para extra��o dos registros
@param   lEnd, boolean, flag de cancelamento de processamento
/*/
//-------------------------------------------------------------------
user function SFEXTCTL (cEmpSF, cFilSF,cIntervalo, cTimeIni, cTimeEnd,;
                        cSFJob, cViewName, dDataIni, dDataFim,cMsExp, lEnd) 

    local oGenAction    := nil              //Objeto com as a��es a serem executadas pelo controller.
    local lJob          := .F.              //Determina se a execu��o � via job.
    local oException    := nil              //Objeto que armazena os erros caso ocorra.
    local oSfUtils      := SFUTILS():New()  //Objeto com fun��es de uso comum entre as rotinas.
    local cMsgErro      := ""               //Mensagem de erro
    local lOk           := .T.              //Processamento OK?
	local lUseMsExp     := .F.              //Usa a flag MSEXP para extra��o dos registros
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

	//Verifica se o controller est� sendo executado por um JOB.
    lJob   := !empty(cEmpSF)
    cArq   := cSFJob+".tmp"
    
    //Verifica se o intervalo venceu para poder executar o job.
    If  lJob .And. !( oSfUtils:getSchedule(cArq, cIntervalo, cTimeIni, cTimeEnd) )
        Return .T.  //Cancela a execucao antes de preparar o ambiente.
    else
        //Tenta reservar o sem�foro
        if !oSfUtils:useSemaforo(cSFJob)	
            If !lJob
                aviso (cSFJob, "O processo j� est� sendo executado por um JOB ou por um outro usu�rio", {"Cancelar"}, 2)
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
		//Realiza a extra��o de dados em arquivo
		//------------------------------------------
		if lJob 
			//chama o m�todo da action
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
			oSfUtils:writeLog( cSFJob ,iif (oException <> nil, oException:ErrorStack, "Exce��o " +cSFJob ))
			RpcClearEnv()
		else
			aviso(cSFJob, iif (oException <> nil, oException:ErrorStack, "Exce��o " +cSFJob), {"CANCELAR"}, 3)
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

	//Libera o sem�foro
	oSfUtils:liberaSemaforo(cSFJob)
	
	freeObj(oSfUtils)       
return