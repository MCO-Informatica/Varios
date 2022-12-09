#include 'protheus.ch'
#include 'tryexception.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} SFEXPCTL
Fun��o de controller da exporta��o do arquivo para o sales
force. 
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   cEmpSF, character, c�digo da empresa 
@param   cFilSF, character, c�digo da filial
@param   cIntervalo, character, intervalo do processamento em hh:mm
@param   cTimeIni, character, hor�rio inicial hh:mm:ss
@param   cTimeFim, character, hor�rio final hh:mm:ss
@param   lEnd, boolean, flag de cancelamento de processamento
/*/
//-------------------------------------------------------------------
user function SFEXPCTL (cEmpSF, cFilSF,cIntervalo, cTimeIni, cTimeEnd,lEnd) 

    local oSfExpAct   as object      //Objeto com as a��es a serem executadas pelo controller.
    local lJob         as logical    //Determina se a execu��o � via job.
    local oException   as object     //Objeto que armazena os erros caso ocorra.
    local oSfUtils     as object     //Objeto com fun��es de uso comum entre as rotinas.
    local cMsgErro     as character  //Mensagem de erro
    local lOk          as logical    //Status de processamento
	local cSFJob       as character  //Nome do job que est� sendo executado
	local nTotal       as numeric    //Numero total de tentativas de envio via SFTP
	local nTry         as numeric    //Tentiva atual de envio via SFTP
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
    oSfExpAct := nil             
    lJob      := .F.             
    oException:= nil              
    oSfUtils  := SFUTILS():New()  
    cMsgErro  := ""               
    lOk       := .F.              
	cSFJob    := "SFEXTCTL"+cEmpSF
	nTotal    := 0
	nTry      := 1

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
		
    	//------------------------------------------------------------
		//O envio do arquivo via FTP
		//-------------------------------------------------------------
		if lJob 
			//Prepara o ambiente 
			RpcSetType(3)
			RPCSetEnv(cEmpSF,cFilSF)

			nTotal := superGetMv("ES_CRMTRIES", .F., 10)
			//---------------------------------------------------------------------
			//Verifica o numero de tentativas realizadas de envio via FTP do arquivo
			//---------------------------------------------------------------------
			while nTry <= nTotal .and. !lOk
				oSfExpAct := SFEXPACT():new(cSFJob,lJob, lEnd)
				//-------------------------------
				//Realiza o envio via FTP do arquivo
				//-------------------------------
				oSfExpAct:export(@lOk,@cMsgErro)
				if !lOk
					oSfUtils:writeLog( cSFJob,cMsgErro,5)
				endif
				nTry++
			enddo		
			//------------------------------------------------------------------------------
			//Caso numero de tentativas tenha excedido o limite, realiza o envio via e-mail 
			//ao respons�vel.
			//-------------------------------------------------------------------------------
			if !lOk
				lOk := oSfExpAct:sendMail(@cMsgErro)
				if !lOk
					oSfUtils:writeLog( cSFJob,cMsgErro)
				endif
			endif
			
		else	
			processa( {|| oSfExpAct:sendFtp(@cMsgErro, @lOk, lJob)}, "Enviando o arquivo via FTP", "Enviando...",.F.)
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
		
	//Limpa o objeto da Action
	if !empty(oSfExpAct)	
		oSfExpAct:destroy()
		freeObj(oSfExpAct)
	endif

	if ValType(oException) == "O"
		freeObj(oException)
	endif

	//Libera o sem�foro
	oSfUtils:liberaSemaforo(cSFJob)
	
	//Limpeza do objeto SfUtils
	freeObj(oSfUtils) 

return     