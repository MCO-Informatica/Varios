#Include "rwmake.ch"
#Include "topconn.ch"
#Include "Protheus.ch"
#include "fileio.ch"
#INCLUDE "TBICONN.CH"


//---------------------------------------------------------------
/*/{Protheus.doc} CSFAJOB
Funcao para realizar o processamento das transmissoes automaticas.
						  
@'param'	cQuery		Query a ser realizado o processamento

@return	lProcessa		Retorna se foi processado com sucesso ou nao.						

@author	Douglas Parreja
@since		26/06/2015
@version	11.8
/*/
//---------------------------------------------------------------
User Function CSFATJOB( cQuery )

	Local lProcessa	:= .T.
	Local cQueryRet	:= ""
	Local cIdEnt		:= "000002" 
	Local cCodMun 	:= SM0->M0_CODMUN
	Local cAviso		:= ""
	Local cURL		:= Padr( GetNewPar("MV_SPEDURL","http://localhost:8080/nfse"),250 )
	Local cDocIni	:= ""
	Local cDocFim	:= ""
	Local nCount 	:= 0
	Local nTam		:= 0	
	Local aRet		:= {}
	Local aProcessa	:= {}
	
	Default cQuery 	:= ""
	
	
	If !( Empty(cQuery) ) 
		
		cQueryRet 	:= ExecuteQuery( cQuery )
		cRDMakeNFSe	:= getRDMakeNFSe(alltrim(cCodMun),"1",cIdEnt)
		lMontaXml		:= .T. //lMontaXML		:= lMontaXML(cIdEnt,cCodMun,"1")
					
		If !( Empty(cQueryRet) )
			
			u_autoMsg("Iniciando processo dos documentos", 1 , 1)
			
			While !(cQueryRet)->(eof())
			
				nCount++
				
				//---------------------------------------------------
				// Realiza a montagem do array para ser enviado para 
				// processamento.   (funcao padrao AutoNFSeBusiness)
				//---------------------------------------------------
				aRet := montaRemessaNFSE( cQueryRet,cRdMakeNFSe,,,cIdEnt,lMontaXML,,@cAviso)
				
				If Len(aRet) > 0 
					u_autoMsg("Adicionando no Range de Transmissao - ["+Alltrim(Str(nCount))+"] Nota Fiscal : " + aRet[1] + aRet[2], 1, 1 )
					
					aAdd( aProcessa, aRet )

				Else
					lProcessa := .F.
				EndIf
				//---------------------------------------------------
				// Caso ocorreu algum erro sera exibido no Conout
				//---------------------------------------------------
				If !(Empty(cAviso) )
					u_autoMsg( cAviso , 1 , 1 )
				EndIf
				
				(cQueryRet)->(dbSkip())			
			End
			
			(cQueryRet)->(dbCloseArea())
			
			If Len(aProcessa) > 0
				
				//--------------------------------------------------------------------------------------
				//Verifica qual eh o tamanho do aProcessa para exibir no conout a NF inicio e NF final
				// aProcessa[x][1] = Serie	+ aProcessa[x][2] = Numero da NF
				//--------------------------------------------------------------------------------------				
				nTam		:= Len(aProcessa)
				cDocIni 	:= aProcessa[1][1] + aProcessa [1][2] 
				cDocFim	:= IIf(nTam > 0, aProcessa[nTam][1] + aProcessa[nTam][2], cDocIni ) 
				
				
				u_autoMsg("Iniciando processo de Transmissao - Range de Notas : " + cDocIni + " A " + cDocFim , 1 , 1  )
				
				//---------------------------------------------------
				// Realiza a transmissao da NFSe 
				// (funcao padrao AutoNFSeBusiness)
				//---------------------------------------------------
				lOk := envRemessaNFSe(cIdEnt,cUrl,aProcessa,.F.,"1",,,,cCodMun)
				
				If lOk
					u_autoMsg("Concluido com sucesso o processo de Transmissao - Range de Notas : " + cDocIni + " A " + cDocFim , 1 , 1  )
				Else
					u_autoMsg("Falha no processo de Transmissao - Range de Notas : " + cDocIni + " A " + cDocFim , 1 , 1  )
				EndIf
				
			EndIf
		EndIf
	Else
		lProcessa := .F.
	EndIf
	

Return lProcessa

//-------------------------------------------------------------------
/*/{Protheus.doc} executeQuery
Funcao executa a query.

@param	cQuery		Query que sera executada

@return 	cAlias		Alias da query executada

@author  Douglas Parreja
@since   26/06/2015
@version 11.8
/*/
//-------------------------------------------------------------------
static function ExecuteQuery( cQuery )

	Local cAlias	:= getNextAlias()
	Default cQuery	:= ""
	
	If !( Empty(cQuery) )
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
			
		If ( (cAlias)->(eof()) )
		
			(cAlias)->(dbCloseArea())
			
			cAlias := ""
			u_autoMsg( "Query nao retornou registros", 1 , 1 )
		Else
			u_autoMsg( "Executando query" , 1, 1 )
		Endif
	Else
		
		cAlias := ""
		u_autoMsg( "Query nao retornou registros", 1 , 1 )
	
	Endif

Return cAlias

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
User Function autoMsg1( cMessage, nExec, nProcesso )   

	Local cExec		:= ""
	Local cProcesso	:= "" 
	
	Default cMessage := ""	// Mensagem enviada a ser exibida no Conout
	Default nExec	:= 0		// De qual processo esta sendo executado (nome do Job, Rotina, etc)
	Default nProcesso	:= 0		// A qual processo refere-se (1-Transmissao,2-Monitoramento)

	//---------------------------------------------------------------------------------
	// Realizado essa funcao para caso estiver outra userfunction, podera ser chamada 
	// essa funcao somente precisara acrescentar o nProcesso e Descricao.
	//---------------------------------------------------------------------------------
		
	If ( getSrvProfString( "AUTOMSG_DEBUG" , "0" ) == "1" )
	
		If nExec == 1						//JOB CSJB03
			cExec  := " AUTONFSE JOB(CSJB03) "
		EndIf
		
		If nProcesso == 1 					// Transmissao
			cProcesso := "TRANSMISSAO "
		ElseIf nProcesso == 2 				// Monitoramento
			cProcesso := "MONITORAMENTO "
		EndIf 
	
		CONOUT( "["+ cExec + " - " + cProcesso +" - " + Dtoc( date() ) + " - " + time() + " ] " + AllTrim(cMessage) )
		//	[ AUTONFSE JOB(CSJB03) - TRANSMISSAO - 26/06/2015 - 17:47:00 ] - Iniciando o JOB 
	Endif 

Return


