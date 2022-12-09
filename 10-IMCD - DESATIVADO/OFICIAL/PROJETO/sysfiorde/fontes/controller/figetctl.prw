#include 'protheus.ch'
#include 'tryexception.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} FIGETCTL
Função de controller da importação de arquivos do Sysfiorde
@author  marcio.katsumata
@since   03/09/2019
@version 1.0
@param   cEmpFI, character, código da empresa 
@param   cFilFI, character, código da filial
@param   cIntervalo, character, intervalo do processamento em hh:mm
@param   cTimeIni, character, horário inicial hh:mm:ss
@param   cTimeFim, character, horário final hh:mm:ss
@param   lEnd, boolean, flag de cancelamento de processamento
/*/
//-------------------------------------------------------------------
user function FIGETCTL (cEmpFI, cFilFI,cIntervalo, cTimeIni, cTimeEnd,lEnd) 

    local oFIGETACT   as object      //Objeto com as ações a serem executadas pelo controller.
    local lJob         as logical    //Determina se a execução é via job.
    local oException   as object     //Objeto que armazena os erros caso ocorra.
    local oSysFiUtl     as object     //Objeto com funções de uso comum entre as rotinas.
    local cMsgErro     as character  //Mensagem de erro
    local lOk          as logical    //Status de processamento
	local cFIJob       as character  //Nome do job que está sendo executado
	local nTotal       as numeric    //Numero total de tentativas de envio via SFTP
	local nTry         as numeric    //Tentiva atual de envio via SFTP
	local cArq         as character  //Nome do arquivo semáforo
	local aRetArq      as array      //Array com os arquivos baixados para exibir após o processamento
	local cInbound     as character  //Arquivos da pasta inbound
	local cOutbound    as character  //Arquivos da pasta oubound


    default cEmpFI := ""
    default cFilFI := ""
    default cIntervalo := ""
    default cTimeIni   := ""
    default cTimeEnd   := ""
	default lEnd       := .F.  
	
	//---------------------------------------------------------------
	//Incializando variáveis
	//---------------------------------------------------------------
    oFIGETACT := nil             
    lJob      := .F.             
    oException:= nil              
    oSysFiUtl  := SYSFIUTL():New()  
    cMsgErro  := ""               
    lOk       := .F.              
	cFIJob    := "FIGETCTL"+cEmpFI+cFilFI
	nTotal    := 0
	nTry      := 1
	cInbound  := ""
	cOutbound := ""

	//Verifica se o controller está sendo executado por um JOB.
    lJob   := !empty(cEmpFI)
    cArq   := cFIJob+".tmp"
    
    //Verifica se o intervalo venceu para poder executar o job.
    If  lJob .And. !( oSysFiUtl:getSchedule(cArq, cIntervalo, cTimeIni, cTimeEnd) )
        Return .T.  //Cancela a execucao antes de preparar o ambiente.
    else
        //Tenta reservar o semáforo
        if !oSysFiUtl:useSemaforo(cFIJob)	
            If !lJob
                aviso (cFIJob, "O processo já está sendo executado por um JOB ou por um outro usuário", {"Cancelar"}, 2)
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

				oFIGETACT := FIGETACT():new(cFIJob,lJob, lEnd)

				//-------------------------------
				//Realiza o envio via FTP do arquivo
				//-------------------------------
				oFIGETACT:getFiles(@lOk,@cMsgErro,aRetArq)

				if !lOk
					oSysFiUtl:writeLog( cFIJob,cMsgErro)
				endif
					
				nTry++
			enddo		
			//------------------------------------------------------------------------------
			//Caso numero de tentativas tenha excedido o limite, realiza o envio via e-mail 
			//ao responsável.
			//-------------------------------------------------------------------------------
			if !lOk
				lOk := oFIGETACT:sendMail(@cMsgErro)
				if !lOk
					oSysFiUtl:writeLog( cFIJob,cMsgErro)
				endif
			endif
			
		else	
			oFIGETACT := FIGETACT():new(cFIJob,lJob, lEnd)
			processa( {|| oFIGETACT:getFiles(@lOk,@cMsgErro,@aRetArq)}, "Recebendo o arquivo via FTP", "Recebendo...",.F.)
			if !lOk
				aviso(cFIJob, cMsgErro, {"CANCELAR"}, 3)
			else
				//-------------------------------------------
				//Montagem da mensagem dos arquivos baixados
				//--------------------------------------------
				iif(!empty(aRetArq[1]), aEval(aRetArq[1], {|cFileIn|cInbound += cFileIn+CRLF})   ,"")
				iif(!empty(aRetArq[2]), aEval(aRetArq[2], {|cFileOut|cOutbound += cFileOut+CRLF}),"")

				cMsgRetArq := "Integração FTP realizada com sucesso."+CRLF+CRLF

				iif(!empty(cInbound),cMsgRetArq += "Arquivos retornos de sucesso ou falha de PO/Booking baixados: "+CRLF+cInbound+CRLF,"")
				iif(!empty(cOutbound),cMsgRetArq += "Arquivos a importar baixados: "+CRLF+cOutbound+CRLF,"")

				eecview(cMsgRetArq)
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
			oSysFiUtl:writeLog( cFIJob ,iif (oException <> nil, oException:ErrorStack, "Exceção " +cFIJob ))
			RpcClearEnv()
		else
			aviso(cFIJob, iif (oException <> nil, oException:ErrorStack, "Exceção " +cFIJob), {"CANCELAR"}, 3)
		endif
	endException	
		
	//Limpa o objeto da Action
	if !empty(oFIGETACT)	
		oFIGETACT:destroy()
		freeObj(oFIGETACT)
	endif

	if ValType(oException) == "O"
		freeObj(oException)
	endif

	//Libera o semáforo
	oSysFiUtl:liberaSemaforo(cFIJob)
	
	//Limpeza do objeto SfUtils
	freeObj(oSysFiUtl) 

return     