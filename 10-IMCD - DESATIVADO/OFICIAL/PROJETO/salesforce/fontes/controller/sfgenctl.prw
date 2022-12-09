#include 'protheus.ch'
#include 'tryexception.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} SFGENCTL
Função responsável pela leitura do INI do Sales Force e execução
dos jobs.
@author  marcio.katsumata
@since   06/08/2019
@version 1.0
@param   cIntervalo, character,intervalo de execução hh:mm
@param   cTimeIni,   character,hh:mm:ss inicial
@param   cTimeEnd,   character, hh:mm:ss final
/*/
//-------------------------------------------------------------------
user function SFGENCTL(cIntervalo, cTimeIni, cTimeEnd)

    local oException   as object     //Objeto que armazena os erros caso ocorra.
    local oSfUtils     as object     //Objeto com funções de uso comum entre as rotinas.
	local cSFJob       as character  //Nome do job que está sendo executado
    local nIndIni1     as numeric
    local nIndIni2     as numeric
    local cArq         as character
    
    private cProgram as character
    private cxParam  as character

    default cIntervalo := "00:01"
    default cTimeIni   := "00:00:00"
    default cTimeEnd   := "23:59:00"

    cMsg :=  ("["+FwTimeStamp(3)+"] Inicio da rotina de sequenciamento de jobs Sales Force" )
    FWLogMsg("INFO", "", "BusinessObject", "SFGENCTL" , "", "", cMsg, 0, 0)		
	//---------------------------------------------------------------
	//Incializando variáveis
	//---------------------------------------------------------------              
    oException:= nil              
    oSfUtils  := SFUTILS():New()             
	cSFJob    := "SFGENCTL"
    cxParam   := ""

	//Verifica se o controller está sendo executado por um JOB.
    cArq   := cSFJob+".tmp"
    
    //Verifica se o intervalo venceu para poder executar o job.
    If  !( oSfUtils:getSchedule(cArq, cIntervalo, cTimeIni, cTimeEnd) )
        Return .T.  //Cancela a execucao antes de preparar o ambiente.
    else
        //Tenta reservar o semáforo
        if !oSfUtils:useSemaforo(cSFJob)	
            cMsg :=   ("["+FwTimeStamp(3)+"] "+cSFJob+"- esta em uso.")
            FWLogMsg("INFO", "", "BusinessObject", cSFJob , "", "", cMsg, 0, 0)	            
            return .T.
        endif 
    endif

    //Realiza a leitura do INI do Sales Force
    aIni := oSfUtils:getIni()
    
    
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
            cMsg := ("["+FwTimeStamp(3)+"] Executando: "+aIni[nIndIni1][1])
            FWLogMsg("INFO", "", "BusinessObject", "SFGENCTL" , "", "", cMsg, 0, 0)		            

            //Execução do programa
            &(cProgram+"("+cxParam+")")
            cxParam := ""
        next nIndIni1
    
    catchException using oException

        oSfUtils:writeLog( cSFJob ,iif (oException <> nil, oException:ErrorStack, "Exceção " +cSFJob ))

    endException	

    if ValType(oException) == "O"
        freeObj(oException)
    endif

    oSfUtils:setSchedule(cArq)

    //Libera o semáforo
    oSfUtils:liberaSemaforo(cSFJob)

    //Limpeza do objeto SfUtils
    freeObj(oSfUtils) 

    //Limpeza do array
    aSize(aIni, 0)

    cMsg :=  ("["+FwTimeStamp(3)+"] Fim da rotina de sequenciamento de jobs Sales Force" )
    FWLogMsg("INFO", "", "BusinessObject", "SFGENCTL" , "", "", cMsg, 0, 0)
return