#include 'protheus.ch'
#include 'tryexception.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} FIGENCTL
Função responsável pela leitura do INI  Fiorde e execução
dos jobs.
@author  marcio.katsumata
@since   23/09/2019
@version 1.0
@param   cIntervalo, character,intervalo de execução hh:mm
@param   cTimeIni,   character, hh:mm:ss inicial
@param   cTimeEnd,   character, hh:mm:ss final
/*/
//-------------------------------------------------------------------
user function FIGENCTL(cIntervalo, cTimeIni, cTimeEnd)

    local oException   as object     //Objeto que armazena os erros caso ocorra.
    local oSysFiUtl     as object    //Objeto com funções de uso comum entre as rotinas.
	local cFIJob       as character  //Nome do job que está sendo executado
    local nIndIni1     as numeric    //Indice
    local nIndIni2     as numeric    //Indice
    local cArq         as character  //Arquivo ini
    
    private cProgram as character
    private cxParam  as character

    default cIntervalo := "00:01"
    default cTimeIni   := "00:00:00"
    default cTimeEnd   := "23:59:00"

    cMsg := ("["+FwTimeStamp(3)+"] Inicio da rotina de sequenciamento de jobs Fiorde" )
	FWLogMsg("INFO", "", "BusinessObject", "FIGENCTL" , "", "", cMsg, 0, 0)			

	//---------------------------------------------------------------
	//Incializando variáveis
	//---------------------------------------------------------------              
    oException:= nil              
    oSysFiUtl  := SYSFIUTL():New()             
	cFIJob    := "FIGENCTL"
    cxParam   := ""

	//Verifica se o controller está sendo executado por um JOB.
    cArq   := cFIJob+".tmp"
    
    //Verifica se o intervalo venceu para poder executar o job.
    If  !( oSysFiUtl:getSchedule(cArq, cIntervalo, cTimeIni, cTimeEnd) )
        Return .T.  //Cancela a execucao antes de preparar o ambiente.
    else
        //Tenta reservar o semáforo
        if !oSysFiUtl:useSemaforo(cFIJob)	
            cMsg := ("["+FwTimeStamp(3)+"] "+cFIJob+"- esta em uso.")
			FWLogMsg("INFO", "", "BusinessObject", cFIJob , "", "", cMsg, 0, 0)				
            return .T.
        endif 
    endif

    //Realiza a leitura do INI do Sales Force
    aIni := oSysFiUtl:getIni()
    
    
    tryException 

        //Estrutura do array do INI
        //[1] Nome do JOB
        //[2] Nome do Programa
        //[3] Array com os parâmetros para o programa
        for nIndIni1 := 1 to len(aIni)

            cProgram := aIni[nIndIni1][2]
            nQtdPar := len(aIni[nIndIni1][3])

            for nIndIni2 := 1 to nQtdPar
                &("xParam"+cValToChar(nIndIni2)) := aIni[nIndIni1][3][nIndIni2]
                cxParam += "xParam"+cValToChar(nIndIni2)+","
            next nIndIni2

            cxParam := substr(cxParam,1,len(cxParam)-1)
            cMsg :=  ("["+FwTimeStamp(3)+"] Executando: "+aIni[nIndIni1][1])
			FWLogMsg("INFO", "", "BusinessObject", cFIJob , "", "", cMsg, 0, 0)					

            //Execução do programa
            &(cProgram+"("+cxParam+")")
            cxParam := ""
        next nIndIni1
    
    catchException using oException

        oSysFiUtl:writeLog( cFIJob ,iif (oException <> nil, oException:ErrorStack, "Exceção " +cFIJob ))

    endException	

    if ValType(oException) == "O"
        freeObj(oException)
    endif

    oSysFiUtl:setSchedule(cArq)

    //Libera o semáforo
    oSysFiUtl:liberaSemaforo(cFIJob)

    //Limpeza do objeto SfUtils
    freeObj(oSysFiUtl) 

    //Limpeza do array
    aSize(aIni, 0)

    cMsg := ("["+FwTimeStamp(3)+"] Fim da rotina de sequenciamento de jobs Fiorde" )
	FWLogMsg("INFO", "", "BusinessObject", cFIJob , "", "", cMsg, 0, 0)			
return