#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"   

//-------------------------------------------------------------------
/*/{Protheus.doc} autoMsg
Funcao que executa conout

@param	 cMessage		Mensagem que sera apresentada no conout
@param	

@author  Douglas Parreja
@since   26/06/2015
@version 11.8
/*/
//-------------------------------------------------------------------
User Function autoMsg( cExec, cProcesso, cMessage )   
	
	Default cExec	:= 0		// De qual processo esta sendo executado (nome do Job, Rotina, etc)
	Default cProcesso	:= 0		// A qual processo refere-se (Ex: 1-Transmissao,2-Monitoramento)
	Default cMessage := ""	// Mensagem enviada a ser exibida no Conout
	
	//---------------------------------------------------------------------------------
	// Realizado essa funcao para caso estiver outra userfunction, podera ser chamada 
	// essa funcao somente precisara acrescentar o nProcesso e Descricao.
	//---------------------------------------------------------------------------------
		
	If ( getSrvProfString( "AUTOMSG_DEBUG" , "0" ) == "1" )
	
		CONOUT( "[ "+ Iif(!Empty(cExec),cExec,"") + " - " + Iif(!Empty(cProcesso),cProcesso+" - ","")  + Dtoc( date() ) + " - " + time() + " ] " + Iif(!Empty(cMessage),AllTrim(cMessage),"") )
	Else
		CONOUT( "[ ATENCAO! - Nao consta configurado o parametro AUTOMSG_DEBUG no appserver.ini, com isso nao serao exibidos os conouts ] ")
	Endif

	//--------------------------------------------------------------------------------------------
	//	Exemplo: 
	//	** NFSE
	//	[ AUTONFSE JOB(CSJB03) - TRANSMISSAO - 26/06/2015 - 17:47:00 ] - Iniciando o JOB
	//	** TOTALIP
	//	[ TOTALIP JOB(CSTOTIP) - IMPORTACAO LISTA - 07/08/2015 - 16:14:00 ] - Iniciando o JOB
	//--------------------------------------------------------------------------------------------
	
Return