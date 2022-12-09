#include 'protheus.ch'
#include 'tryexception.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} FIEXPCTL
Fun��o de controller da exporta��o do arquivo para o sales
force. 
@author  marcio.katsumata
@since   03/09/2019
@version 1.0
@param   cEmpFI, character, c�digo da empresa 
@param   cFilFI, character, c�digo da filial
@param   cIntervalo, character, intervalo do processamento em hh:mm
@param   cTimeIni, character, hor�rio inicial hh:mm:ss
@param   cTimeFim, character, hor�rio final hh:mm:ss
@param   lEnd, boolean, flag de cancelamento de processamento
/*/
//-------------------------------------------------------------------
user function FIEXPCTL (cEmpFI, cFilFI,cIntervalo, cTimeIni, cTimeEnd,lEnd) 

    local oFiExpAct   as object      //Objeto com as a��es a serem executadas pelo controller.
    local lJob         as logical    //Determina se a execu��o � via job.
    local oException   as object     //Objeto que armazena os erros caso ocorra.
    local oSysFiUtl     as object     //Objeto com fun��es de uso comum entre as rotinas.
    local cMsgErro     as character  //Mensagem de erro
    local lOk          as logical    //Status de processamento
	local cFIJob       as character  //Nome do job que est� sendo executado
	local nTotal       as numeric    //Numero total de tentativas de envio via SFTP
	local nTry         as numeric    //Tentiva atual de envio via SFTP
    local cArq         as character
	
	
    default cEmpFI := ""
    default cFilFI := ""
    default cIntervalo := ""
    default cTimeIni   := ""
    default cTimeEnd   := ""
	default lEnd       := .F.  
	
	//---------------------------------------------------------------
	//Incializando vari�veis
	//---------------------------------------------------------------
    oFiExpAct := nil             
    lJob      := .F.             
    oException:= nil              
    oSysFiUtl  := SYSFIUTL():New()  
    cMsgErro  := ""               
    lOk       := .F.              
	cFIJob    := "FIEXPCTL"+cEmpFI+cFilFI
	nTotal    := 0
	nTry      := 1

	//Verifica se o controller est� sendo executado por um JOB.
    lJob   := !empty(cEmpFI)
    cArq   := cFIJob+".tmp"
    
    //Verifica se o intervalo venceu para poder executar o job.
    If  lJob .And. !( oSysFiUtl:getSchedule(cArq, cIntervalo, cTimeIni, cTimeEnd) )
        Return .T.  //Cancela a execucao antes de preparar o ambiente.
    else
        //Tenta reservar o sem�foro
        if !oSysFiUtl:useSemaforo(cFIJob)	
            If !lJob
                aviso (cFIJob, "O processo j� est� sendo executado por um JOB ou por um outro usu�rio", {"Cancelar"}, 2)
            else
                cMsg :=  ("["+FwTimeStamp(3)+"] "+cFIJob+"- esta em uso.")
				FWLogMsg("INFO", "", "BusinessObject", cFIJob , "", "", cMsg, 0, 0)					
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
			RPCSetEnv(cEmpFI,cFilFI)
			
			//Reset do buffer
			rstmvbuff()

			nTotal := superGetMv("ES_CRMTRIES", .F., 3)
			//---------------------------------------------------------------------
			//Verifica o numero de tentativas realizadas de envio via FTP do arquivo
			//---------------------------------------------------------------------
			while nTry <= nTotal .and. !lOk

				oFiExpAct := FIEXPACT():new(cFIJob,lJob, lEnd)

				//-------------------------------
				//Realiza o envio via FTP do arquivo
				//-------------------------------
				oFiExpAct:export(@lOk,@cMsgErro)

				if !lOk
					oSysFiUtl:writeLog( cFIJob,cMsgErro)
				endif

				nTry++
			enddo		
			//------------------------------------------------------------------------------
			//Caso numero de tentativas tenha excedido o limite, realiza o envio via e-mail 
			//ao respons�vel.
			//-------------------------------------------------------------------------------
			if !lOk
				lOk := oFiExpAct:sendMail(@cMsgErro)
				if !lOk
					oSysFiUtl:writeLog( cFIJob,cMsgErro)
				endif
			endif
			
		else	
			oFiExpAct := FIEXPACT():new(cFIJob,lJob, lEnd)

			processa( {|| oFiExpAct:export(@lOk,@cMsgErro)}, "Enviando o arquivo via FTP", "Enviando...",.F.)
			if !lOk
				aviso(cFIJob, cMsgErro, {"CANCELAR"}, 3)
			else
				aviso(cFIJob, "Envio realizado com sucesso.", {"OK"},1)
    	    endif
		endif

		

		//-------------------------------------------------------s
		//Limpa o ambiente se estiver sendo executada por um job
		//-------------------------------------------------------
		if lJob
			oSysFiUtl:setSchedule(cArq)
			RpcClearEnv()
		endif

	catchException using oException
		if lJob
			oSysFiUtl:writeLog( cFIJob ,iif (oException <> nil, oException:ErrorStack, "Exce��o " +cFIJob ))
			RpcClearEnv()
		else
			aviso(cFIJob, iif (oException <> nil, oException:ErrorStack, "Exce��o " +cFIJob), {"CANCELAR"}, 3)
		endif
	endException	
		
	//Limpa o objeto da Action
	if !empty(oFiExpAct)	
		oFiExpAct:destroy()
		freeObj(oFiExpAct)
	endif

	if ValType(oException) == "O"
		freeObj(oException)
	endif

	//Libera o sem�foro
	oSysFiUtl:liberaSemaforo(cFIJob)
	
	//Limpeza do objeto Sysfiutl
	freeObj(oSysFiUtl) 

return     