#include 'protheus.ch'
#include 'tryexception.ch'
#Include 'TBICONN.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} SFIMPCTL
Fun��o de controller da importa��o do arquivo gerado no sales force
com o resutado da exporta��o de informa��es reaizada.
@author  marcio.katsumata
@since   19/07/2019
@version 1.0
@param   cEmpSF, character, c�digo da empresa 
@param   cFilSF, character, c�digo da filial
@param   cIntervalo, character, intervalo do processamento em hh:mm
@param   cTimeIni, character, hor�rio inicial hh:mm:ss
@param   cTimeFim, character, hor�rio final hh:mm:ss
@param   lEnd, boolean, flag de cancelamento de processamento
/*/
//-------------------------------------------------------------------
user function SFIMPCTL(cEmpSF, cFilSF,cIntervalo, cTimeIni, cTimeEnd,lEnd) 

    local oSfImpAct   as object      //Objeto com as a��es a serem executadas pelo controller.
    local lJob         as logical    //Determina se a execu��o � via job.
    local oException   as object     //Objeto que armazena os erros caso ocorra.
    local oSfUtils     as object     //Objeto com fun��es de uso comum entre as rotinas.
    local cMsgErro     as character  //Mensagem de erro
    local lOk          as logical    //Status de processamento
	local cSFJob       as character  //Nome do job que est� sendo executado
    local cArq         as character
    
    default cEmpSF := ""
    default cFilSF := ""
    default cIntervalo := ""
    default cTimeIni   := ""
    default cTimeEnd   := ""
	default lEnd       := .F.  
	
	//---------------------------------------------------------------
	//Incializando vari�veis
	//---------------------------------------------------------------
    oSfImpAct := nil             
    lJob      := .F.             
    oException:= nil              
    oSfUtils  := SFUTILS():New()  
    cMsgErro  := ""               
    lOk       := .T.              
	cSFJob    := "SFIMPCTL"+cEmpSF



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

			oSfImpAct := SFIMPACT():new(lJob, lEnd)
			//-------------------------------
            //Realiza o processo de importa��o dos
            //arquivos retornados do Sales Force
			//-------------------------------
			oSfImpAct:import(@lOk,@cMsgErro)
			if !lOk
				oSfUtils:writeLog( cSFJob,cMsgErro,5)
            endif
        else
            processa( {|| oSfImpAct:import(@lOk,@cMsgErro)}, "Importado arquivos recebidos", "Importando...",.F.)
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
    if !empty(oSfImpAct)	
        oSfImpAct:destroy()
        freeObj(oSfImpAct)
    endif

    //Libera o sem�foro
    oSfUtils:liberaSemaforo(cSFJob)
    
    //Limpeza do objeto SfUtils
    freeObj(oSfUtils) 

return    
