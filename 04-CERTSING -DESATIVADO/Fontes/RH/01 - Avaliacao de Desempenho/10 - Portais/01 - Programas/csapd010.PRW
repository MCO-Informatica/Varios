#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "AP5MAIL.CH"

#DEFINE CODUSUARIO 	"MSALPHA"
#DEFINE STR0001  	"Erro"
#DEFINE STR0002  	"Participante não encontrado"
#DEFINE STR0003 	"Não existem questões cadastradas para a avaliação atual."
#DEFINE STR0004 	"Avaliação de Desempenho"
#DEFINE STR0005  	"Respostas gravadas com sucesso!"
#DEFINE STR0006  	"Falha na gravação"
#DEFINE STR0007  	"Respostas gravadas e avaliação finalizada com sucesso!"
#DEFINE STR0008  	" - Incompleta"
#DEFINE STR0009  	"Avaliação gravada e não finalizada por existirem questões sem resposta!"
#DEFINE STR0010 	"Avaliação de Performance Web - Inclusão"
#DEFINE STR0011 	"Não existem avaliações para o participante logado"
#DEFINE STR0012 	"Inclusão - Erro"
#DEFINE STR0013  	"O avaliador deve ser diferente do avaliado."
#DEFINE STR0014  	"Inclusão"
#DEFINE STR0015 	"Inclusão efetuada com sucesso."
#DEFINE STR0016 	"O periodo deve ser preenchido antes desta consulta."
#DEFINE STR0017 	"Informe o filtro para pesquisa"
#DEFINE STR0018 	"Avaliação de Desempenho em Projeto"
#DEFINE STR0019  	"Pendências"
#DEFINE STR0020  	"Consulta"

User Function CSAPD10M()
	local cHtml := ''
	WEB EXTENDED INIT cHtml START "InSite"
		cHtml := ExecInPage( "CSAPD10M" )
	WEB EXTENDED END
Return cHtml

User Function CSAPD010()
	Local cHtml 	:= ""
	Local nX		:= 0
	Local oObj      := nil
	Local oParam	:= nil
	
	WEB EXTENDED INIT cHtml START "InSite"
		oObj := WSRHPERFORMANCEEVALUATE():New()
		WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
		oParam	:= WSCFGDICTIONARY():NEW()
		WsChgURL(@oParam,"CFGDICTIONARY.APW")
		
		//Valida a necessidade de se executar o compatibilizador				
		If ! oObj:ValNewFields()			
			HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "javascript:history.back();"}	//"Erro"
			Return ExecInPage("PWSAMSG")
		EndIf
		
		If oParam:GETPARAM( CODUSUARIO, "MV_APDRLV" )
			HttpSession->cCpoRelev := AllTrim( oParam:cGETPARAMRESULT )
		EndIf
		
		//Verifica se Busca Descricao da Rede
		If oParam:GETPARAM( CODUSUARIO, "MV_APDREDE" )
			HttpSession->lDescRede := oParam:cGETPARAMRESULT
		EndIf     
		
		//Verifica os campos que serao apresentados no cabe?lho da avalia?o
		HttpSession->cCposCabec := ""
		If oParam:GETPARAM( CODUSUARIO, "MV_CPOSCAB" )
			If !Empty(oParam:cGETPARAMRESULT)  .AND. oParam:cGETPARAMRESULT != ".F."
				HttpSession->cCposCabec := oParam:cGETPARAMRESULT
			EndIf
		EndIf             
		                         
		//Se n? existir o par?etro ou n? foi informado nenhum campo, 
		// assumir todos os campos para apresenta?o
		If Empty(HttpSession->cCposCabec)
			HttpSession->cCposCabec := "123456789A"
		EndIf
		
		/********************************************************************
		NIVEIS DOS AVALIADORES
		 - SEXTO PARAMETRO DO METODO BRWMYEVALUATED
		 METODO USADO PARA VERIFICAR AVALIACOES DE SUBORDINADOS, PARCEIROS
		 E SUPERIORES DO PARTICIPANTE LOGADO
		----------------------------------------------------------------------
		 1 = AVALIADOR ESTA NO MESMO NIVEL DO AVALIADO
		 2 = AVALIADOR ESTA EM NIVEL ACIMA DO AVALIADO
		 3 = AVALIADOR ESTA EM NIVEL ABAIXO DO AVALIADO
		**********************************************************************/
		
		HttpSession->aSuperior := {}
		HttpSession->BRWMYEVALUATES := {}
		HttpSession->BRWMYEVALUATED := {}
		HttpSession->aPares := {}
		HttpSession->GETPEVALUATE := NIL
		HttpSession->GETPEVALUATE := {}
		//HttpSession->cTipoAv:= "1"
		
		//SE STATUS = 1 - ALTERACAO
		//SE STATUS = 2 - CONSULTA FINALIZADOS
		
		//Alterado 11/07/2017 Bruno Nunes
		HttpSession->cStatus := "2"	
		HttpGet->cStatus 		:= "2"
		HttpPost->cStatus 	:= "2"
		
		HttpSession->cTpAval := "1"
		HttpGet->cTpAval 		:= "1"
		HttpPost->cTpAval 	:= "1"
		
		If !Empty( HttpSession->cParticipantID )
			//CONSULTA SE EXISTEM AVALIACOES DE SUBORDINADOS PARA O PARTICIPANTE LOGADO
			oObj:cStatusEvaluate := HttpSession->cStatus
			oObj:cNetLevel := "2"
			
			If oObj:BRWMYEVALUATED( CODUSUARIO, HttpSession->cParticipantID, HttpSession->cTpAval )
				HttpSession->BRWMYEVALUATED := {oObj:oWSBRWMYEVALUATEDRESULT:oWSEVALUATELIST}
		
				//Separa itens por rede
				cRede := "X"
				HttpSession->aNewSubor := {}
				Asort( HttpSession->BRWMYEVALUATED[1],,,{ |x,y| x:cNet+x:cDescription+x:cEvaluatedName < y:cNet+y:cDescription+y:cEvaluatedName } )
		
				For nX := 1 To Len(HttpSession->BRWMYEVALUATED[1])
					If cRede != HttpSession->BRWMYEVALUATED[1][nX]:cNetDescription
						If cRede == "X" .Or. HttpSession->lDescRede == ".T."
							Aadd(HttpSession->aNewSubor, {})
						EndIf
		
						cRede := HttpSession->BRWMYEVALUATED[1][nX]:cNetDescription
					EndIf
		
					Aadd( HttpSession->aNewSubor[Len(HttpSession->aNewSubor)], HttpSession->BRWMYEVALUATED[1][nX] )
				Next nX
		
			Else
				HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "W_PWSA001.APW" }	//"Erro"
				Return ExecInPage("PWSAMSG" )
			EndIf
		
			//CONSULTA SE EXISTEM AUTO-AVALIACOES DO PARTICIPANTE LOGADO
			oObj:cStatusEvaluate := HttpSession->cStatus
		
			If oObj:BRWMYEVALUATES( CODUSUARIO, HttpSession->cParticipantID, HttpSession->cTpAval )
				HttpSession->BRWMYEVALUATES := {oObj:oWSBRWMYEVALUATESRESULT:oWSEVALUATELIST}
		
		 		//Separa itens por rede
				cRede := "X"
				HttpSession->aNewAuto := {}
		
				Asort( HttpSession->BRWMYEVALUATES[1],,,{ |x,y| x:cNet+x:cDescription+x:cEvaluatedName < y:cNet+y:cDescription+y:cEvaluatedName } )
				For nX := 1 To Len(HttpSession->BRWMYEVALUATES[1])
					If cRede != HttpSession->BRWMYEVALUATES[1][nX]:cNetDescription
						If cRede == "X" .Or. HttpSession->lDescRede == ".T."
							Aadd(HttpSession->aNewAuto, {})
						EndIf
						cRede := HttpSession->BRWMYEVALUATES[1][nX]:cNetDescription
					EndIf
		
					Aadd( HttpSession->aNewAuto[Len(HttpSession->aNewAuto)], HttpSession->BRWMYEVALUATES[1][nX] )
				Next nX
			Else
				HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "javascript:history.back();"}//"W_PWSA001.APW" }			//"Erro"
				Return ExecInPage("PWSAMSG")
			EndIf
		
			//CONSULTA SE EXISTEM AVALIACOES DO SUPERIOR PARA O PARTICIPANTE LOGADO
			oObj:cStatusEvaluate := HttpSession->cStatus
			oObj:cNetLevel := "3"
			If oObj:BRWMYEVALUATED( CODUSUARIO, HttpSession->cParticipantID, HttpSession->cTpAval )
				HttpSession->aSuperior := {oObj:oWSBRWMYEVALUATEDRESULT:oWSEVALUATELIST}
		
				//Separa itens por rede
				cRede := "X"
				HttpSession->aNewSuper := {}
				Asort( HttpSession->aSuperior[1],,,{ |x,y| x:cNet+x:cDescription+x:cEvaluatedName < y:cNet+y:cDescription+y:cEvaluatedName } )
				For nX := 1 To Len(HttpSession->aSuperior[1])
					If cRede != HttpSession->aSuperior[1][nX]:cNetDescription
						If cRede == "X" .Or. HttpSession->lDescRede == ".T."
							Aadd(HttpSession->aNewSuper, {})
						EndIf
		
						cRede := HttpSession->aSuperior[1][nX]:cNetDescription
					EndIf
					Aadd( HttpSession->aNewSuper[Len(HttpSession->aNewSuper)], HttpSession->aSuperior[1][nX] )
				Next nX
			Else
				HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "javascript:history.back();"}//"W_PWSA001.APW" }	//"Erro"
				Return ExecInPage("PWSAMSG" )
			EndIf
		
			//CONSULTA SE EXISTEM AVALIACOES DE PARES PARA O PARTICIPANTE LOGADO
			oObj:cStatusEvaluate := HttpSession->cStatus
			oObj:cNetLevel := "1"
		
			If oObj:BRWMYEVALUATED( CODUSUARIO, HttpSession->cParticipantID, HttpSession->cTpAval )
				HttpSession->aPares := {oObj:oWSBRWMYEVALUATEDRESULT:oWSEVALUATELIST}
		
				//Separa itens por rede
				cRede := "X"
				HttpSession->aNewPares := {}
				Asort( HttpSession->aPares[1],,,{ |x,y| x:cNet+x:cDescription+x:cEvaluatedName < y:cNet+y:cDescription+y:cEvaluatedName } )
				For nX := 1 To Len(HttpSession->aPares[1])
					If cRede != HttpSession->aPares[1][nX]:cNetDescription
						If cRede == "X" .Or. HttpSession->lDescRede == ".T."
							Aadd(HttpSession->aNewPares, {})
						EndIf
		
						cRede := HttpSession->aPares[1][nX]:cNetDescription
					EndIf
		
					Aadd( HttpSession->aNewPares[Len(HttpSession->aNewPares)], HttpSession->aPares[1][nX] )
				Next nX
		
			Else
				HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "javascript:history.back();"}//"W_PWSA001.APW" }	//"Erro"
				Return ExecInPage("PWSAMSG" )
			EndIf
		Else
			HttpSession->_HTMLERRO := { STR0001, STR0002, "javascript:history.back();"}//"W_PWSA001.APW" }	//"Erro"##"Participante n? encontrado"
			Return ExecInPage("PWSAMSG" )
		EndIf

		If Len(HttpSession->aNewAuto) == 0 .AND.;
		   Len(HttpSession->aNewSuper) == 0 .AND.;
		   Len(HttpSession->aNewSubor) == 0 .AND.;
		   Len(HttpSession->aNewPares) == 0
			HttpSession->_HTMLERRO := {IIf(HttpSession->cTpAval == "3", STR0018, STR0004) + " - " + IIf(HttpSession->cStatus == "1", STR0019, STR0020), STR0011, "javascript:history.back();" }//"W_PWSA001.APW" }
			Return ExecInPage("PWSAMSG" )
		EndIf

		//Verifica existencia de Avaliação de Consenso 		
		ChkAvaCon()		
		
		cHtml += ExecInPage( "CSAPD010" )
	WEB EXTENDED END
Return cHtml


User Function CSAPD011()

Local cHtml := ""
Local oObj
Local cPEvaluateID 	:= If(!Empty(HttpGet->cPEvaluateID), HttpGet->cPEvaluateID, If(!Empty(HttpSession->cPEvaluateID),HttpSession->cPEvaluateID,""))
Local cProject 		:= If(!Empty(HttpGet->cProject), HttpGet->cProject, If(!Empty(HttpSession->cProject),HttpSession->cProject,"      "))

WEB EXTENDED INIT cHtml START "InSite"

	oObj := WSRHPERFORMANCEEVALUATE():New()
	WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")

	If !Empty( HttpSession->cParticipantID ) .And. !Empty( cPEvaluateID )

		HttpSession->cDateFrom 	:= If(!Empty(HttpGet->cDateFrom), HttpGet->cDateFrom, HttpSession->cDateFrom)
		If oObj:GETPEVALUATE( CODUSUARIO, HttpSession->cParticipantID, cPEvaluateID,,,,,,, CToD(HttpSession->cDateFrom), cProject )
			HttpSession->GETPEVALUATE := oObj:oWSGETPEVALUATERESULT:oWSEVALUATELIST
			If len(HttpSession->GETPEVALUATE[1]:oWsListOfCompetence:oWsCompetences) == 0
				HttpSession->_HTMLERRO := { STR0001, STR0003, "W_CSAPD010.APW" }			//"Erro"##N? existem quest?s cadastradas para a avalia?o atual."
				Return ExecInPage("PWSAMSG" )
			EndIf
		Else
			HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "W_CSAPD010.APW" }			//"Erro"
			Return ExecInPage("PWSAMSG" )
		EndIf
	EndIf

	HttpSession->cTipo := "2" //Auto-Avalia?o
	
	cHtml += ExecInPage( "CSAPD011" )

	WEB EXTENDED END

Return cHtml

//imprimir avaliação
//TODO - refazer
User Function CSAPD11I()

Local cHtml := ""
Local oParam   := WSCFGDICTIONARY():NEW()

Private cParam := ""

WEB EXTENDED INIT cHtml START "InSite"

WsChgURL(@oParam,"CFGDICTIONARY.APW")
If oParam:GETPARAM( CODUSUARIO, "MV_APDINCB" )
	cParam := AllTrim( oParam:cGETPARAMRESULT )
EndIf

//--Se o parametro nao estiver preenchido exibe, como padrao, somente o codigo
If Empty( cParam )
	cParam := "1"
EndIf

cHtml += ExecInPage( "CSAPD11I" )

WEB EXTENDED END

Return cHtml

/*******************************************************************/
/* Autor...: 	Tatiane Vieira Matias			Data: 28/02/2005      */
/* Objetivo: Avaliacao de Desempenho - Questoes	- Avaliado         */
/*******************************************************************/

User Function CSAPD11A()
	Local cHtml := ""

	WEB EXTENDED INIT cHtml START "InSite"

	cHtml += ExecInPage( "CSAPD11A" )

	WEB EXTENDED END
Return cHtml

/******************************************************************/
/* Autor...: Aline Correa do Vale              Data: Maio de 2004 */
/* Objetivo: Responder Avaliador com Seus Avaliados / Sua Equipe  */
/******************************************************************/

User Function CSAPD012()
	Local cHtml := ""
	Local oObj
	Local cPEvaluateID := If(!Empty(HttpGet->cPEvaluateID), HttpGet->cPEvaluateID, If(!Empty(HttpSession->cPEvaluateID)  ,HttpSession->cPEvaluateID  ,""))
	Local cEvaluatedID := If(!Empty(HttpGet->cEvaluatedID), HttpGet->cEvaluatedID, If(!Empty(HttpSession->cEvaluatedID)  ,HttpSession->cEvaluatedID  ,""))
	Local cTipoAv      := If(!Empty(HttpGet->cTipoAv)     , HttpGet->cTipoAv     , If(!Empty(HttpSession->cTipoAv)       ,HttpSession->cTipoAv       ,""))
	Local cProject     := If(!Empty(HttpGet->cProject)    , HttpGet->cProject    , If(!Empty(HttpSession->cProject)      ,HttpSession->cProject      ,""))
	Local cEvaluatorID := If(!Empty(HttpGet->cEvaluatorID), HttpGet->cEvaluatorID, If(!Empty(HttpSession->cParticipantId),HttpSession->cParticipantId,""))
	
	WEB EXTENDED INIT cHtml START "InSite"
	oObj := WSRHPERFORMANCEEVALUATE():New()
	WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
	
	If !Empty( cEvaluatedID ) .And. !Empty( cPEvaluateID ) .And. !Empty( cTipoAv )
		HttpSession->cDateFrom 	:= If(!Empty(HttpGet->cDateFrom), HttpGet->cDateFrom, HttpSession->cDateFrom)
	
		If oObj:GETPEVALUATE(CODUSUARIO, cEvaluatedID, cPEvaluateID, cEvaluatorID, cTipoAv,,,,, CToD(HttpSession->cDateFrom), cProject )
			HttpSession->GETPEVALUATE := oObj:oWSGETPEVALUATERESULT:oWSEVALUATELIST
			If len(HttpSession->GETPEVALUATE[1]:oWsListOfCompetence:oWsCompetences) == 0
				HttpSession->_HTMLERRO := { STR0001, STR0003, "W_CSAPD010.APW" }			//"Erro"##N? existem quest?s cadastradas para a avalia?o atual."
				Return ExecInPage("PWSAMSG" )
			EndIf
		Else
			HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "W_CSAPD010.APW" }			//"Erro"
			Return ExecInPage("PWSAMSG" )
		EndIf
	EndIf
	
	HttpSession->cTipo := "1" //Avaliador
	cHtml += ExecInPage( "CSAPD012" )
	
	WEB EXTENDED END
Return cHtml

/*******************************************************************/
/* Autor...: 	Tatiane Vieira Matias			Data: 29/02/2005      */
/* Objetivo: Avaliacao de Desempenho - Questoes - Avaliador        */
/*******************************************************************/

User Function CSAPD12A()
	Local cHtml 	:= ""
	Local oParam   	:= WSCFGDICTIONARY():NEW()
	Private cParam  := ""
	
	WEB EXTENDED INIT cHtml START "InSite"
	WsChgURL(@oParam,"CFGDICTIONARY.APW")
	If oParam:GETPARAM( CODUSUARIO, "MV_APDINCB" )
		cParam := AllTrim( oParam:cGETPARAMRESULT )
	EndIf
	
	//--Se o parametro nao estiver preenchido exibe, como padrao, somente o codigo
	If Empty( cParam )
		cParam := "1"
	EndIf
	
	cHtml += ExecInPage( "CSAPD12A" )
	
	WEB EXTENDED END	
Return cHtml


/******************************************************************/
/* Autor...: Juliana Barros Mariano              Data: 21/02/2005 */
/* Objetivo: Impressao de avaliacao da equipe					  */
/******************************************************************/

User Function CSAPD12I()
	Local cHtml := ""
	
	WEB EXTENDED INIT cHtml START "InSite"
	
	cHtml += ExecInPage( "CSAPD12I" )
	
	WEB EXTENDED END
Return cHtml

//-----------------------------------------------------------------------------
//<summary>
//	Grava as respostas da Avaliacao
//</summary>
//<remarks></remarks>
//<history>	 
// 	<change date="01/05/2004" developer="Aline Correa do Vale">Criacao</change>
// 	<change date="24/11/2005" developer="Juliana Barros Mariano">Alteracao</change>
// 	<change date="08/07/2008" developer="Rogerio Ribeiro da Cruz">Isolamento da rotina de gravacao para a function 'PWSA013Grava()'</change>
//</history>
//-----------------------------------------------------------------------------
/*
Web Function PWSA013()
	Local cHtml := If(HttpSession->cTipo=="1","W_CSAPD012.APW",if(HttpSession->cTipo=="2","W_CSAPD011.APW","W_CSAPD015.APW"))
	cHtml+= "?cPEvaluateID=" + HttpSession->GetPEvaluate[1]:cEvaluateID
	cHtml+= "&cEvaluatedID=" + HttpSession->GetPEvaluate[1]:cEvaluatedID
	cHtml+= "&cTipoAv=" + HttpPost->cTipoAV
	cHtml+= "&cDateFrom=" + DTOC(HttpSession->GetPEvaluate[1]:dInitialDate)
	cHtml+= "&cProject=" + HttpSession->GetPEvaluate[1]:cProject
	cHtml+= "&cEvaluatorID=" + HttpSession->GetPEvaluate[1]:cEvaluatorID
	
	WEB EXTENDED INIT cHtml START "InSite"
		If PWSA013Grava(HttpSession->GetPEvaluate[1])
			HttpSession->_HTMLERRO := {Iif(HttpSession->cTpAval == "3" ,STR0018,STR0004), STR0005, cHtml }	//"Avalia?o de Desempenho em Projeto"###"Avalia?o de Desempenho"##"Respostas gravadas com SUCESSO!"
			Return ExecInPage("PWSAMSG")
		Else
			HttpSession->_HTMLERRO := { STR0001, STR0006, cHtml }	//"Erro"##"Falha na grava?o"
			Return ExecInPage("PWSAMSG")
		EndIf
	
	WEB EXTENDED END
RETURN	
*/

/*
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??rograma  ?WSA010   ?utor  ?quipe RH            ?Data ?8/07/2008   ??
???????????????????????????????????????
??esc.     ?Gravacao das respostas da Avaliacao                         ??
??         ?                                                            ??
???????????????????????????????????????
??arametros?                                                            ??
???????????????????????????????????????
??so       ?ortal Protheus                                              ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
*/
//-----------------------------------------------------------------------------
//<summary>
//	Rotina de grava?o dos dados da respostas da avaliacao
//</summary>
//<remarks></remarks>
//<history>	 
// 	<change date="08/07/2008" developer="Rogerio Ribeiro da Cruz">Criacao</change>
//</history>
//-----------------------------------------------------------------------------
/*
STATIC FUNCTION PWSA013Grava(oEvaluate)
	Local ni := 0
	Local nc := 1
	Local nz := 0
	Local nT := 0
	Local nCont := 0     
	Local nRelevPadrao	:=0  
	Local nRelevSelec	:=0
	Local cAlternEsc	:= "" 
    Local cDisserTxt   	:= ""
	Local cJustif		:= "" 	
	Local oObj:= WSRHPERFORMANCEEVALUATE():New()
	WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
		
	oObj:oWSEVALUATE 					:= RHPERFORMANCEEVALUATE_EVALUATES():New()
	oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:= RHPERFORMANCEEVALUATE_ARRAYOFCOMPETENCES():New()
	
	oObj:oWSEVALUATE:cEvaluateId  		:= oEvaluate:cEvaluateID
	oObj:oWSEVALUATE:cEvaluatedId 		:= oEvaluate:cEvaluatedID
	oObj:oWSEVALUATE:cEvaluatorId 		:= oEvaluate:cEvaluatorID
	oObj:oWSEVALUATE:cProject     		:= oEvaluate:cProject
	oObj:oWSEVALUATE:cNet         		:= oEvaluate:cNet
	oObj:oWSEVALUATE:cLevel       		:= oEvaluate:cLevel
	oObj:oWSEVALUATE:cVision      		:= oEvaluate:cVision
	oObj:oWSEVALUATE:cEvaluateType		:= oEvaluate:cEvaluateType
	oObj:oWSEVALUATE:dInitialDate 		:= oEvaluate:dInitialDate
	oObj:oWSEVALUATE:dFinalDate			:= oEvaluate:dFinalDate
	oObj:oWSEVALUATE:dAnswerFinalDate	:= oEvaluate:dAnswerFinalDate
	oObj:oWSEVALUATE:cSelfEvaluate		:= oEvaluate:cSelfEvaluate
	oObj:oWSEVALUATE:cModel       		:= oEvaluate:cModel
	oObj:oWSEVALUATE:cCompetence  		:= oEvaluate:cCompetence
	
	For nT := 1 to Len(oEvaluate:oWsListOfCompetence:oWsCompetences)
		nz := 1
		aAdd(oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES, RHPERFORMANCEEVALUATE_COMPETENCES():New() )
		oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION := RHPERFORMANCEEVALUATE_ARRAYOFQUESTIONS():New()
		oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:cCompetenceItem := oEvaluate:oWsListOfCompetence:oWsCompetences[nT]:cCompetenceItem
	
		for nz := 1 to Len(oEvaluate:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions)
			If (oEvaluate:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cObjectType == "3" .And.;
				!Empty(Alltrim(&("HttpPost->TX"+StrZero(nT,2)+StrZero(nz,3))))) .Or.;
				(oEvaluate:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cObjectType != "3";
				.And. &("HttpPost->RSP"+StrZero(nT,2)+StrZero(nz,3)) != "---")
	
				aAdd( oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION:oWSQUESTIONS, RHPERFORMANCEEVALUATE_QUESTIONS():New() )
				nCont := len(oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION:oWSQUESTIONS)
				oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION:oWSQUESTIONS[nCont]:cQuestionID := oEvaluate:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nz]:cQuestionID
				oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION:oWSQUESTIONS[nCont]:cObjectType := oEvaluate:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cObjectType
				oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION:oWSQUESTIONS[nCont]:cScale      := oEvaluate:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cScale
				nRelevPadrao := oEvaluate:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cScaleItem
	
				//Item de Relevancia 
				nRelevSelec	:= &("HttpPost->REL"+StrZero(nT,2)+StrZero(nz,3))   
				IF (nRelevSelec == NIL) .or. Empty(nRelevSelec)
					nRelevSelec:= nRelevPadrao
				Endif

				oObj:oWSEVALUATE:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nCont]:cScaleItemDescription := ""
				oObj:oWSEVALUATE:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nCont]:cScaleItem := nRelevSelec
				oEvaluate:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cScaleItem := nRelevSelec
	
				If oEvaluate:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cObjectType == "3" //dissertativa   
					//Texto Resposta dissertativa
					cDisserTxt	:= Alltrim(&("HttpPost->TX"+StrZero(nT,2)+StrZero(nz,3)))
					IF (cDisserTxt == NIL) .or. Empty(cDisserTxt)
						cDisserTxt:= oEvaluate:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cAnswerDescription 
				   	Endif
					oObj:oWSEVALUATE:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nCont]:cAnswerDescription := cDisserTxt
					oEvaluate:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cAnswerDescription :=           cDisserTxt
				Else
					//Alternativa Escolhida
					cAlternEsc	:= &("HttpPost->RSP"+StrZero(nT,2)+StrZero(nz,3))   
					IF (cAlternEsc == NIL) .or. Empty(cAlternEsc)
						cAlternEsc:= oEvaluate:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nz]:cAlternativeChoice 
				   	Endif
					oObj:oWSEVALUATE:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nCont]:cAlternativeChoice := cAlternEsc
					oEvaluate:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cAlternativeChoice := cAlternEsc
								
					//Justificativa 
					cJustif	:= &("HttpPost->JUS"+StrZero(nT,2)+StrZero(nz,3))   
					IF (cJustif == NIL) .or. Empty(cJustif)
						cJustif:= oEvaluate:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nz]:cJustification 
				   	 Else
            			cJustif := strtran(cJustif, CHR(9), "") 
            		Endif
				   	If !Empty(cJustif)
						oObj:oWSEVALUATE:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nCont]:cJustification := Alltrim(cJustif)
						oEvaluate:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cJustification := AllTrim(cJustif)
					EndIf					
				EndIf													
			EndIf
		Next nz		
	Next nT
	
	HttpSession->cPEvaluateID 	:= HttpPost->cPEvaluateID
	HttpSession->cEvaluatedID 	:= HttpPost->cEvaluatedID
	HttpSession->cEvaluatorID	:= HttpPost->cEvaluatorID
	HttpSession->cTipoAV 		:= HttpPost->cTipoAV
	HttpSession->cProject 		:= HttpPost->cProject
	
	lReturn := oObj:PUTPEVALUATE( CODUSUARIO, oObj:oWsEvaluate )
RETURN lReturn
*/


//-----------------------------------------------------------------------------
//<summary>
//	Grava os dados da respostas da avaliacao (Avaliado) e avan? para a proxima pagina
//</summary>
//<remarks></remarks>
//<history>	 
// 	<change date="08/07/2008" developer="Rogerio Ribeiro da Cruz">Criacao</change>
//</history>
//-----------------------------------------------------------------------------
/*
WEB FUNCTION PWSA013A()
	Local cHtml
	
	WEB EXTENDED INIT cHtml START "InSite"
		If PWSA013Grava(HttpSession->GetPEvaluate[1])
			Return W_CSAPD15A()
		Else
			HttpSession->_HTMLERRO := { STR0001, STR0006, "javascript:history.back();" }	//"Erro"##"Falha na grava?o"
			Return ExecInPage("PWSAMSG")
		EndIf
	WEB EXTENDED END
RETURN
*/


//-----------------------------------------------------------------------------
//<summary>
//	Grava os dados da respostas da avaliacao (Avaliador) e avan? para a proxima pagina
//</summary>
//<remarks></remarks>
//<history>	 
// 	<change date="08/07/2008" developer="Rogerio Ribeiro da Cruz">Criacao</change>
//</history>
//-----------------------------------------------------------------------------
/*
WEB FUNCTION PWSA013B()
	Local cHtml
	
	WEB EXTENDED INIT cHtml START "InSite"
		If PWSA013Grava(HttpSession->GetPEvaluate[1])
			Return W_CSAPD12A()
		Else
			HttpSession->_HTMLERRO := { STR0001, STR0006, "javascript:history.back();" }	//"Erro"##"Falha na grava?o"
			Return ExecInPage("PWSAMSG")
		EndIf
	WEB EXTENDED END
RETURN
*/


//-----------------------------------------------------------------------------
//<summary>
//	Grava os dados da respostas da avaliacao (Consenso) e avan? para a proxima pagina
//</summary>
//<remarks></remarks>
//<history>	 
// 	<change date="08/07/2008" developer="Rogerio Ribeiro da Cruz">Criacao</change>
//</history>
//-----------------------------------------------------------------------------
/*
WEB FUNCTION PWSA013C()
	Local cHtml
	
	WEB EXTENDED INIT cHtml START "InSite"
		If PWSA013Grava(HttpSession->GetPEvaluate[1])
			Return W_L()
		Else
			HttpSession->_HTMLERRO := { STR0001, STR0006, "javascript:history.back();" }	//"Erro"##"Falha na grava?o"
			Return ExecInPage("PWSAMSG")
		EndIf
	WEB EXTENDED END
RETURN
*/


//-----------------------------------------------------------------------------
//<summary>
//	Grava os dados da respostas da avaliacao (Avaliado) e finaliza a avaliacao.
//</summary>
//<remarks></remarks>
//<history>	 
// 	<change date="08/07/2008" developer="Rogerio Ribeiro da Cruz">Criacao</change>
//</history>
//-----------------------------------------------------------------------------
/*
WEB FUNCTION PWSA013D()
	Local cHtml
	
	WEB EXTENDED INIT cHtml START "InSite"
		If PWSA013Grava(HttpSession->GetPEvaluate[1])
			Return W_PWSA014()
		Else
			HttpSession->_HTMLERRO := { STR0001, STR0006, "javascript:history.back();" }	//"Erro"##"Falha na grava?o"
			Return ExecInPage("PWSAMSG")
		EndIf
	WEB EXTENDED END
RETURN
*/


//****************************************************************************/
/* Autor...: Aline Correa do Vale                         Data: Maio de 2004 */
/* Alterado: Juliana Barros Mariano			   			  Data: 24.11.2005	  */
/* Objetivo: Gravar e Finalizar as respostas da Avaliacao || botao Finalizar */
//****************************************************************************/
/*
Web Function PWSA014()
	Local cMsg		:= ""
	Local cBody 	:= ""
	Local cServer	:= ""
	Local oParam	:= ""
	Local oMsg		:= ""
	Local oObj		:= ""
	Local oEmail 	:= ""
	Local nT 		:= 0
	Local nZ 		:= 0
	Local nPos		:= 0
	Local nCont 	:= 0
	Local lCompleto	:= .T.
	Local cFinishOk	:= IIF(HttpSession->cTpAval=="3", "W_PWSA090.APW", "W_CSAPD010.APW")
	Local cHtml 	:= IIF(HttpSession->cTipo=="1","W_CSAPD012.APW",if(HttpSession->cTipo=="2","W_CSAPD011.APW","W_CSAPD015.APW"))
	cHtml+= "?cPEvaluateID=" + HttpSession->GetPEvaluate[1]:cEvaluateID
	cHtml+= "&cEvaluatedID=" + HttpSession->GetPEvaluate[1]:cEvaluatedID
	cHtml+= "&cTipoAv=" + HttpPost->cTipoAV
	cHtml+= "&cDateFrom=" + DTOC(HttpSession->GetPEvaluate[1]:dInitialDate)
	cHtml+= "&cProject=" + HttpSession->GetPEvaluate[1]:cProject
	cHtml+= "&cEvaluatorID=" + HttpSession->GetPEvaluate[1]:cEvaluatorID

	WEB EXTENDED INIT cHtml START "InSite"
		oParam	:= WSCFGDICTIONARY():NEW()
		oMsg	:= WSRHPERSONALDESENVPLAN():NEW()
		oEmail	:= WSRHCURRICULUM():New()
		oObj	:= WSRHPERFORMANCEEVALUATE():New()
		WsChgURL(@oParam,"CFGDICTIONARY.APW")
		WsChgURL(@oMsg,"RHPERSONALDESENVPLAN.APW")
		WsChgURL(@oEmail,"RHCURRICULUM.APW")
		WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
		
		oObj:oWSEVALUATE := RHPERFORMANCEEVALUATE_EVALUATES():New()
		oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE := RHPERFORMANCEEVALUATE_ARRAYOFCOMPETENCES():New()
		
		oObj:oWSEVALUATE:cEvaluateId  := HttpSession->GetPEvaluate[1]:cEvaluateID
		oObj:oWSEVALUATE:cEvaluatedId := HttpSession->GetPEvaluate[1]:cEvaluatedID
		oObj:oWSEVALUATE:cEvaluatorId := HttpSession->GetPEvaluate[1]:cEvaluatorID
		oObj:oWSEVALUATE:cProject     := HttpSession->GetPEvaluate[1]:cProject
		oObj:oWSEVALUATE:cNet         := HttpSession->GetPEvaluate[1]:cNet
		oObj:oWSEVALUATE:cLevel       := HttpSession->GetPEvaluate[1]:cLevel
		oObj:oWSEVALUATE:cVision      := HttpSession->GetPEvaluate[1]:cVision
		oObj:oWSEVALUATE:cEvaluateType:= HttpSession->GetPEvaluate[1]:cEvaluateType
		oObj:oWSEVALUATE:dInitialDate := HttpSession->GetPEvaluate[1]:dInitialDate
		oObj:oWSEVALUATE:dFinalDate   := HttpSession->GetPEvaluate[1]:dFinalDate
		oObj:oWSEVALUATE:dAnswerFinalDate:= HttpSession->GetPEvaluate[1]:dAnswerFinalDate
		oObj:oWSEVALUATE:cSelfEvaluate:= HttpSession->GetPEvaluate[1]:cSelfEvaluate //HttpSession->cTipo
		oObj:oWSEVALUATE:cModel       := HttpSession->GetPEvaluate[1]:cModel
		oObj:oWSEVALUATE:cCompetence  := HttpSession->GetPEvaluate[1]:cCompetence
		
		
		For nT := 1 to Len(HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWsCompetences)
			aAdd( oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES, RHPERFORMANCEEVALUATE_COMPETENCES():New() )
			oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION := RHPERFORMANCEEVALUATE_ARRAYOFQUESTIONS():New()
			oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:cCompetenceItem := HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWsCompetences[nT]:cCompetenceItem
		
			for nz := 1 to Len(HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions)
				If (HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cObjectType == "3" .And.;
					 !Empty(HttpSession->GetPEvaluate[1]:oWsListOfCompetence:OWSCOMPETENCES[nT]:oWsListOfQuestion:OWSQUESTIONS[nz]:cAnswerDescription)) .Or.;
					(HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cObjectType != "3" .And.;
					 HttpSession->GetPEvaluate[1]:oWsListOfCompetence:OWSCOMPETENCES[nT]:oWsListOfQuestion:OWSQUESTIONS[nz]:cAlternativeChoice != "---" .and.;
					 !Empty(HttpSession->GetPEvaluate[1]:oWsListOfCompetence:OWSCOMPETENCES[nT]:oWsListOfQuestion:OWSQUESTIONS[nz]:cAlternativeChoice))
		
					aAdd( oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION:oWSQUESTIONS, RHPERFORMANCEEVALUATE_QUESTIONS():New() )
					nCont := len(oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION:oWSQUESTIONS)
					oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION:oWSQUESTIONS[nCont]:cQuestionID 	:= HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nz]:cQuestionID
					oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION:oWSQUESTIONS[nCont]:cObjectType 	:= HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cObjectType
					oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION:oWSQUESTIONS[nCont]:cScale      	:= HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cScale
					oObj:oWSEVALUATE:oWSLISTOFCOMPETENCE:oWSCOMPETENCES[nT]:oWSLISTOFQUESTION:oWSQUESTIONS[nCont]:cEdit		:= HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cEdit
		
					//Item de Relevancia
					oObj:oWSEVALUATE:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nCont]:cScaleItemDescription := ""
					oObj:oWSEVALUATE:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nCont]:cScaleItem := &("HttpPost->REL"+StrZero(nT,2)+StrZero(nz,3))
					HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cScaleItem := &("HttpPost->REL"+StrZero(nT,2)+StrZero(nz,3))
		
					If HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cObjectType == "3" //dissertativa
						oObj:oWSEVALUATE:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nCont]:cAnswerDescription := HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cAnswerDescription
					Else
						oObj:oWSEVALUATE:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nCont]:cAlternativeChoice := HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cAlternativeChoice
						If ! Empty(HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cJustification)
							oObj:oWSEVALUATE:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nCont]:cJustification     := Alltrim(HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWSCOMPETENCES[nT]:oWsListOfQuestion:oWSQUESTIONS[nz]:cJustification)
						EndIf
					EndIf
				Else
					If (HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nz]:cEdit == "1" .and.;
						 HttpSession->cTipo == "2") .or.;
						(HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nz]:cEdit == "2" .and.;
						 HttpSession->cTipo == "1") .or.;
						(HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWsCompetences[nT]:oWsListOfQuestion:oWsQuestions[nz]:cEdit == "3")
							lCompleto := .F.
					EndIf
				EndIf
			next nz
		
		Next nT
		
		HttpSession->cPEvaluateID 	:= HttpPost->cPEvaluateID
		HttpSession->cEvaluatedID 	:= HttpPost->cEvaluatedID
		HttpSession->cEvaluatorID	:= HttpPost->cEvaluatorID
		HttpSession->cTipoAV 		:= HttpPost->cTipoAV
		HttpSession->cProject 		:= HttpPost->cProject
		
		If oObj:PUTPEVALUATE( CODUSUARIO, oObj:oWsEvaluate, lCompleto, HttpSession->cTpAval)
			If lCompleto 
				//-- Funcionalidade de envio de email foi transferido para o metodo PUTPEVALUATE na rotina WSAPD010.
				HttpSession->_HTMLERRO := {Iif(HttpSession->cTpAval == "3" ,STR0018,STR0004) , STR0007, cFinishOk}	//"Avalia?o de Desempenho"##"Respostas gravadas e avalia?o finalizada com SUCESSO!"
			Else
				HttpSession->_HTMLERRO := {Iif(HttpSession->cTpAval == "3" ,STR0018+STR0008, STR0004+STR0008), STR0009, cHtml }	//"Avalia?o de Desempenho - Incompleta"##"Avalia?o gravada e n? finalizada por existirem quest?s sem resposta!"
			EndIf
		Else
			HttpSession->_HTMLERRO := { STR0001, "", cHtml }	//"Erro"
		EndIf
		
		cHtml := ExecInPage( "PWSAMSG" )
	WEB EXTENDED END
	
Return cHtml
*/

/******************************************************************/
/* Autor...: Aline Correa do Vale              Data: Maio de 2004 */
/* Alterado...: Juliana Barros Mariano         Data: Nov  de 2005 */
/* Objetivo: Consenso visualizando respostas Avaliado e Avaliador */
// ****************************************************************/
User Function CSAPD015()
	Local cHtml := ""
	Local oObj
	Local cPEvaluateID := If(!Empty(HttpGet->cPEvaluateID), HttpGet->cPEvaluateID, If(!Empty(HttpSession->cPEvaluateID),HttpSession->cPEvaluateID,""))
	Local cEvaluatedID := If(!Empty(HttpGet->cEvaluatedID), HttpGet->cEvaluatedID, If(!Empty(HttpSession->cEvaluatedID),HttpSession->cEvaluatedID,""))
	Local cEvaluatorID := If(!Empty(HttpGet->cEvaluatorID), HttpGet->cEvaluatorID, If(!Empty(HttpSession->cEvaluatorID),HttpSession->cEvaluatorID,""))
	Local cTipoAv 	   := If(!Empty(HttpGet->cTipoAv)     , HttpGet->cTipoAv     , If(!Empty(HttpSession->cTipoAv)     ,HttpSession->cTipoAv,""))
	Local cProject     := If(!Empty(HttpGet->cProject)    , HttpGet->cProject    , If(!Empty(HttpSession->cProject)    ,HttpSession->cProject,""))	
	
	WEB EXTENDED INIT cHtml START "InSite"
	oObj := WSRHPERFORMANCEEVALUATE():New()
	WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
	
	If !Empty( cEvaluatedID ) .And. !Empty( cPEvaluateID )
		HttpSession->cDateFrom 	:= If(!Empty(HttpGet->cDateFrom), HttpGet->cDateFrom, HttpSession->cDateFrom)


		VARINFO('UserCode', CODUSUARIO)
		VARINFO('HttpSession->cParticipantID', HttpSession->cParticipantID)
		VARINFO('cPEvaluateID', cPEvaluateID)
		VARINFO('cEvaluatedID', cEvaluatedID)
		VARINFO('CToD(HttpSession->cDateFrom)', CToD(HttpSession->cDateFrom))
		VARINFO('cProject', cProject)

		//Alterado 11/07/2017 Bruno Nunes
		//If oObj:GETPEVALUATE( CODUSUARIO, cEvaluatedID               , cPEvaluateID, IIF(Empty(cEvaluatorID),HttpSession->cParticipantID,cEvaluatorID), cTipoAv,,,,, CToD(HttpSession->cDateFrom), cProject )
		If oObj:GETPEVALUATE( CODUSUARIO, cEvaluatedID, cPEvaluateID,,,,,,, CToD(HttpSession->cDateFrom), cProject )
			HttpSession->GETPEVALUATE := oObj:oWSGETPEVALUATERESULT:oWSEVALUATELIST

			If len(HttpSession->GETPEVALUATE[1]:oWsListOfCompetence:oWsCompetences) == 0
				HttpSession->_HTMLERRO := { STR0001, STR0003, "W_CSAPD010.APW" }			//"Erro"##N? existem quest?s cadastradas para a avalia?o atual."
				Return ExecInPage("PWSAMSG" )
			EndIf
		Else
			HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "W_CSAPD010.APW" }			//"Erro"
			Return ExecInPage("PWSAMSG" )
		EndIf
	EndIf

	retMedia()	      
	loadMentor()
	loadCC()	
	loadLegend()
	HttpSession->cTipo := "3" //Consenso
	cHtml += ExecInPage( "CSAPD015" )
	
	WEB EXTENDED END	
Return cHtml

/*******************************************************************/
/* Autor...: 	Tatiane Vieira Matias			Data: 29/02/2005      */
/* Objetivo: Avaliacao de Desempenho - Questoes - Consenso         */
/*******************************************************************/

User Function CSAPD15A()
	Local cHtml 	:= ""
	Local oParam   	:= WSCFGDICTIONARY():NEW()
	Private cParam  := ""
	
	WEB EXTENDED INIT cHtml START "InSite"
	WsChgURL(@oParam,"CFGDICTIONARY.APW")
	If oParam:GETPARAM( CODUSUARIO, "MV_APDINCB" )
		cParam := AllTrim( oParam:cGETPARAMRESULT )
	EndIf
	
	//--Se o parametro nao estiver preenchido exibe, como padrao, somente o codigo
	If Empty( cParam )
		cParam := "1"
	EndIf
	
	cHtml += ExecInPage( "CSAPD15A" )
	
	WEB EXTENDED END
Return cHtml

/******************************************************************/
/* Autor...: Juliana Barros Mariano				Data: 21/02/2005  */
/* Objetivo: Consenso Impressao									  */
// ****************************************************************/
User Function CSAPD15I()
	Local cHtml := ""
	
	WEB EXTENDED INIT cHtml START "InSite"
	
	cHtml += ExecInPage( "CSAPD15I" )
	
	WEB EXTENDED END	
Return cHtml


/******************************************************************/
/* Autor...: Juliana Barros Mariano              Data: Outubro de 2004 */
/* Objetivo: Consulta avaliacoes do participante logado				*/
// ****************************************************************/
User Function CSAPD016()
	Local cHtml := ""
	Local oAval := {}
	
	WEB EXTENDED INIT cHtml START "InSite"
	
	oAval := WSRHPERFORMANCEEVALUATE():NEW()
	WsChgURL(@oAval,"RHPERFORMANCEEVALUATE.APW")
	
	If oAval:BRWEVALUATE( CODUSUARIO, HttpSession->cParticipantID )
		HttpSession->aAval := oAval:oWSBRWEVALUATERESULT:oWSEVALUATEDEVALUATE
	
		If len(HttpSession->aAval) > 0
			cHtml := ExecInPage("CSAPD016")
		Else
			HttpSession->_HTMLERRO := { STR0010, STR0011, "javascript:history.back();"}//"W_PWSA001.APW" }		//"Avalia?o de Performance Web - Inclus?"##"N? existem avalia?es para o participante logado"
			cHtml := ExecInPage("PWSAMSG" )
		EndIf
	Else
		HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "javascript:history.back();"}//"W_PWSA001.APW" }			//"Erro"
		cHtml := ExecInPage("PWSAMSG" )
	EndIf
	
	WEB EXTENDED END
Return cHtml


/******************************************************************
* Autor...: Juliana Barros Mariano
* Data: 	Outubro de 2004
* Objetivo: Inclusao de novo avaliador e projeto para participante logado
*******************************************************************/
/*
Web Function PWSA017()
	Local cHtml := ""
	Local oObj
	Local nCont
	
	WEB EXTENDED INIT cHtml START "InSite"
			HttpSession->aNewAval (linhas)
	
			1 - Codigo da Avaliacao
			2 - Nome da avaliacao
			3 - Codigo do Avaliador
			4 - Nome do Avaliador
			5 - Codigo do Projeto
			6 - Nome do Projeto
			7 - Codigo do Cliente
			8 - Nome do Cliente
			9 - Dt Inicial do Periodo
			10- Dt Final do Periodo
			11- Codigo do Tipo de Avaliacao
			12- Codigo da Rede
			13- Nivel da Rede
	
		If HttpGet->cPopUp != "2" .And. HttpGet->cPopUp != "3"
	
			//SESSION COM OS DADOS DA AVALIACAO SELECIONADA
			Declare HttpSession->aNewAval[14]
	
			//Se existir apenas uma avaliacao, ja preencher o campo com esta avaliacao
			oObj := WSRHPERFORMANCEEVALUATE():NEW()
			WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
	
			If oObj:BrwGenEvaluate( CODUSUARIO, "3", "" ) //Tipo 3=Projetos
				HttpPost->aAvaliacoes := oObj:oWSBRWGENEVALUATERESULT:oWSEVALUATEGEN
				For nCont:= 1 to len(HttpPost->aAvaliacoes)                
					If HttpPost->aAvaliacoes[nCont]:cStatus == "1"
						HttpSession->aNewAval[1] := HttpPost->aAvaliacoes[nCont]:cEvaluateID		    //Cod.Avaliacao
						HttpSession->aNewAval[2] := HttpPost->aAvaliacoes[nCont]:cEvaluateDescription 	//Desc. Avaliacao
						HttpSession->aNewAval[11]:= HttpPost->aAvaliacoes[nCont]:cTypeEvaluate			//Tipo Avaliacao
						HttpSession->aNewAval[12]:= HttpPost->aAvaliacoes[nCont]:cNet  			 		//Rede
						HttpSession->aNewAval[13]:= HttpPost->aAvaliacoes[nCont]:cLevel 				//Nivel
				   		Exit
					EndIf
				Next nCont	  		
			EndIf
	
		ElseIf HttpGet->cPopUp == "2"
	
			//Inclusao de Periodo
			HttpSession->aNewAval[9] 	:= HttpGet->cPeriodoDe
			HttpSession->aNewAval[10] 	:= HttpGet->cPeriodoAte
		EndIf
	
		cHtml := ExecInPage("PWSA017")
	
	WEB EXTENDED END
Return cHtml
*/

/******************************************************************
* Autor...: Juliana Barros Mariano
* Data: 	Outubro de 2004
* Objetivo: Consulta de Projetos
* Obs:		Tela de PopUp
*******************************************************************/
/*
Web Function PWSA017A()
	Local cHtml := ""
	
	WEB EXTENDED INIT cHtml START "InSite"
	
		//SE DADOS ESTIVEREM VINDO DA TELA DE POP UP ENCAMINHA PARA A TELA DE BAIXO
		//VEM DA TELA DE CONSULTA DE AVALIADOR
		//SE VEM DA TELA DE VISUALIZACAO DOS DADOS PARA ABRIR POPUP
		//CONSULTA DE AVALIADOR
		If HttpGet->cPopProd == "1"
			//SIGNIFICA QUE OS DADOS ESTAO VINDO DA TELA DE COMPETENCIAS COMPORTAMENTAIS
			HttpPost->cTela := "CC"
	
			cHtml := W_PWSA028()
		Else
	  		HttpSession->aNewAval[3] := HttpGet->cCodAvaliador
			HttpSession->aNewAval[4] := HttpGet->cNomeAvaliador
	
			cHtml := ExecInPage("PWSA017")
		EndIf
	
	WEB EXTENDED END
Return cHtml
*/

/******************************************************************
* Autor...: Juliana Barros Mariano
* Data: 	Outubro de 2004
* Objetivo: Consulta todos os projetos em tela de popup
*******************************************************************/
/*
Web Function PWSAPopProj()
	Local cHtml := ""
	Local oAval := {}
	
	WEB EXTENDED INIT cHtml START "InSite"
	
	//SE FOR CONSULTA NA POPUP
	If HttpGet->cPopUp == "1"
		HttpSession->aNewAval[5] := HttpGet->cCodProjeto
		HttpSession->aNewAval[6] := HttpGet->cDescProjeto
		cHtml := ExecInPage("PWSA017" )
	Else
		HttpPost->aProjetos := {}
	
		//CONSULTA NA POPUP DE PROJETOS
		If HttpGet->cPopProd != "5" .and. HttpSession->cPopProd != "5"
	
	 		If Empty(HttpPost->cNome)
	 			HttpSession->cPopProd  := "5"
				HttpSession->_HTMLERRO := { STR0001, STR0017, "W_PWSAPopProj.APW" } //"Erro" "Informe o filtro para pesquisa"
				cHtml := ExecInPage("PWSAMSG" )
	 		Else
	 			HttpSession->cPopProd  := ""
	
				oAval := WSRHPERFORMANCEEVALUATE():NEW()
				WsChgURL(@oAval,"RHPERFORMANCEEVALUATE.APW")
	
	
				If oAval:BrwProjects( CODUSUARIO, HttpPost->cNome, HttpSession->aNewAval[7], HttpSession->aNewAval[14])
				//If oAval:BrwCFP( 		CODUSUARIO, HttpPost->cNome, HttpSession->aNewAval[7] )
	
					//PARA NAO MOSTRAR MENSAGEM DE DIGITAR NOME PARA CONSULTA
					HttpPost->cScript := "<script language=javascript>Tablemsg.style.display = 'none';</script>"
	
					HttpPost->aProjetos := oAval:oWSBRWPROJECTSRESULT:oWSPROJECTS
					//HttpPost->aProjetos := oAval:oWSBRWCFPRESULT:oWSPROJECTS
	
					cHtml := ExecInPage("PWSAPopProj")
				Else
					HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "javascript:history.back();"}//"W_PWSA001.APW" }			//"Erro"
					cHtml := ExecInPage("PWSAMSG" )
				EndIf
			EndIf
		Else
			HttpSession->cPopProd  := ""
			cHtml := ExecInPage("PWSAPopProj")
		EndIf
	EndIf
	
	WEB EXTENDED END
Return cHtml
*/

/******************************************************************
* Autor...: Emerson Grassi Rocha
* Data: 	Mar/2006
* Objetivo: Consulta de Avaliados em tela de popup
*******************************************************************/
/*
Web Function PWSAdoPop()
	Local cHtml := ""
	Local oObj := {}
	
	WEB EXTENDED INIT cHtml START "InSite"
	
	//SE FOR CONSULTA NA POPUP
	If HttpGet->cPopUp == "1"
		HttpSession->aNewAval[3] := HttpGet->cAdoCod
		HttpSession->aNewAval[4] := HttpGet->cAdoNome
		cHtml := ExecInPage("PWSA017" )
	Else
		HttpPost->aAvaliados := {}
	
		//CONSULTA NA POPUP DE AVALIADOS
		If HttpGet->cPopProd != "3" .and. HttpSession->cPopProd != "3"
	
	 		If Empty(HttpPost->cNome)
	 			HttpSession->cPopProd  := "3"
				HttpSession->_HTMLERRO := { STR0001, STR0017, "W_PWSAdoPop.APW" } //"Erro" "Informe o filtro para pesquisa"
				cHtml := ExecInPage("PWSAMSG" )
	 		Else
	 			HttpSession->cPopProd  := ""
	
				oObj := WSRHPERFORMANCEEVALUATE():NEW()
				WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
	
				If oObj:brwEvaluator( CODUSUARIO, HttpPost->cNome )
					//PARA NAO MOSTRAR MENSAGEM DE DIGITAR NOME PARA CONSULTA
					HttpPost->cScript := "<script language=javascript>Tablemsg.style.display = 'none';</script>"
	
					httpPost->aAvaliados 	:= 	oObj:oWSBRWEVALUATORRESULT:OWSEVALUATORS
					cHtml := ExecInPage("PWSAdoPop")
				Else
					HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "javascript:history.back();"}//"W_PWSA001.APW" }			//"Erro"
					cHtml := ExecInPage("PWSAMSG" )
				EndIf
			EndIf
		Else
			HttpSession->cPopProd  := ""
			cHtml := ExecInPage("PWSAdoPop")
		EndIf
	EndIf
	
	WEB EXTENDED END
Return cHtml
*/

/******************************************************************
* Autor...: Emerson Grassi Rocha
* Data: 	Mar/2006
* Objetivo: Consulta todos os projetos PMS em tela de popup
*******************************************************************/
/*Web Function PWSAPmsPop()
	Local cHtml 	:= ""
	Local oObj 		:= {}
	Local dDtIni	:= IIf( Empty(HttpSession->aNewAval[9]), Ctod(""), Ctod(HttpSession->aNewAval[9]) )
	Local dDtFim	:= IIf( Empty(HttpSession->aNewAval[10]), Ctod(""), Ctod(HttpSession->aNewAval[10]) )
	
	WEB EXTENDED INIT cHtml START "InSite"
	
	//SE FOR CONSULTA NA POPUP
	If HttpGet->cPopUp == "1"
		HttpSession->aNewAval[5] := HttpGet->cCodProjeto
		HttpSession->aNewAval[6] := HttpGet->cDescProjeto
		cHtml := ExecInPage("PWSA017" )
	Else
		HttpPost->aProjetos := {}
	
		//CONSULTA NA POPUP DE PROJETOS PMS
		If HttpGet->cPopProd != "6" .and. HttpSession->cPopProd != "6"
	
	 		If Empty(HttpPost->cNome)
	 			HttpSession->cPopProd  := "6"
				HttpSession->_HTMLERRO := { STR0001, STR0017, "W_PWSAPmsPop.APW" } //"Erro" "Informe o filtro para pesquisa"
				cHtml := ExecInPage("PWSAMSG" )
	 		Else
	 			HttpSession->cPopProd  := ""
	
				oObj := WSPMSREPORT():NEW()
				WsChgURL(@oObj,"PMSREPORT.APW")
	
				//GetProjectList WSRECEIVE UserCode, ProtheusUserCode, DateInitial, DateFinal, ProjectInitial, ProjectFinal,PageLen,PageFirst,QryAdd,IndexKey WSSEND ProjectList WSSERVICE PmsReport
				If oObj:GetProjectList( CODUSUARIO, CODUSUARIO , dDtIni ,dDtFim , HttpPost->cNome  ,"zzzzz" )
	
					//PARA NAO MOSTRAR MENSAGEM DE DIGITAR NOME PARA CONSULTA
					HttpPost->cScript := "<script language=javascript>Tablemsg.style.display = 'none';</script>"
	
					HttpPost->aProjetos := oObj:oWSGetProjectListRESULT:oWSProjectListView
	
					cHtml := ExecInPage("PWSAPmsPop")
				Else
					HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "javascript:history.back();"}//"W_PWSA001.APW" }			//"Erro"
					cHtml := ExecInPage("PWSAMSG" )
				EndIf
	   	EndIf
		Else
			HttpSession->cPopProd  := ""
			cHtml := ExecInPage("PWSAPmsPop")
		EndIf
	EndIf
	
	WEB EXTENDED END
Return cHtml
*/
/******************************************************************
* Autor...: Emerson Grassi Rocha
* Data: 	Mar/2006
* Objetivo: Pagina de Inclusao de Projeto
*******************************************************************/
/*Web Function PWSAProjInc()
	Local cHtml := ""
	
	WEB EXTENDED INIT cHtml START "InSite"
	
		cHtml := ExecInPage("PWSAProjInc")
	
	WEB EXTENDED END	
Return cHtml
*/
/******************************************************************
* Autor...: Emerson Grassi Rocha
* Data: 	Mar/2006
* Objetivo: Consulta Avaliacoes em tela de popup
*******************************************************************/
/*Web Function PWSAvalPop()
	Local cHtml := ""
	Local oObj := {}
	
	WEB EXTENDED INIT cHtml START "InSite"
	
	//SE FOR CONSULTA NA POPUP
	If HttpGet->cPopUp == "1"
		HttpSession->aNewAval[1] := HttpGet->cCodAvaliacao
		HttpSession->aNewAval[2] := HttpGet->cDescAvaliacao
		cHtml := ExecInPage("PWSA017" )
	Else
		HttpPost->aAvaliacoes := {}
	
		//CONSULTA NA POPUP DE AVALIACOES
		If HttpGet->cPopProd != "1" .and. HttpSession->cPopProd != "1"
	
			HttpSession->cPopProd  := ""
			oObj := WSRHPERFORMANCEEVALUATE():NEW()
			WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
	
			If oObj:BrwGenEvaluate( CODUSUARIO, "3", HttpPost->cNome ) //Tipo 3=Projetos
	
				//PARA NAO MOSTRAR MENSAGEM DE DIGITAR NOME PARA CONSULTA
				HttpPost->cScript := "<script language=javascript>Tablemsg.style.display = 'none';</script>"
	
				HttpPost->aAvaliacoes := oObj:oWSBRWGENEVALUATERESULT:oWSEVALUATEGEN
	
				If Len(HttpPost->aAvaliacoes) > 0
					HttpSession->aNewAval[11] := HttpPost->aAvaliacoes[1]:cTypeEvaluate	//Tipo Avaliacao
					HttpSession->aNewAval[12] := HttpPost->aAvaliacoes[1]:cNet  			//Rede
					HttpSession->aNewAval[13] := HttpPost->aAvaliacoes[1]:cLevel 			//Nivel
				EndIf
	
				cHtml := ExecInPage("PWSAvalPop")
			Else
				HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "W_PWSAvalPop.APW" }			//"Erro"
				cHtml := ExecInPage("PWSAMSG" )
			EndIf
	
		Else
			HttpSession->cPopProd  := ""
			cHtml := ExecInPage("PWSAvalPop")
		EndIf
	EndIf
	
	WEB EXTENDED END
Return cHtml
*/

/******************************************************************
* Autor...: Emerson Grassi Rocha
* Data: 	Mar/2006
* Objetivo: Consulta Clientes em tela de popup
*******************************************************************/
/*Web Function PwsaCliPop()
	Local cHtml := ""
	Local oObj := {}
	
	WEB EXTENDED INIT cHtml START "InSite"
	
	//SE FOR CONSULTA NA POPUP
	If HttpGet->cPopUp == "1"
		HttpSession->aNewAval[7] := HttpGet->cCodCliente
		HttpSession->aNewAval[8] := HttpGet->cDescCliente
		HttpSession->aNewAval[14] := HttpGet->cLojaCliente
		
		cHtml := ExecInPage("PWSA017" )
	Else
		HttpPost->aCliente := {}
	
		//CONSULTA NA POPUP DE CLIENTES
		If HttpGet->cPopProd != "2" .and. HttpSession->cPopProd != "2"
	
	 		If Empty(HttpPost->cNome)
	 			HttpSession->cPopProd  := "2"
				HttpSession->_HTMLERRO := { STR0001, STR0017, "W_PwsaCliPop.APW" } //"Erro" "Informe o filtro para pesquisa"
				cHtml := ExecInPage("PWSAMSG" )
	 		Else
	 			HttpSession->cPopProd  := ""
	
				oObj := WSMTSYSTEMCUSTOMER():NEW()
				WsChgURL(@oObj,"MTSYSTEMCUSTOMER.APW")
	
	//			If oObj:BrwCustomer( CODUSUARIO, , , ,HttpPost->cNome ) //Nome Reduzido
				If oObj:BrwCustomer( CODUSUARIO, , , HttpPost->cNome ) //Nome (Razao Social)
	
					//PARA NAO MOSTRAR MENSAGEM DE DIGITAR NOME PARA CONSULTA
					HttpPost->cScript := "<script language=javascript>Tablemsg.style.display = 'none';</script>"
	
					HttpPost->aCliente := oObj:oWSBRWCUSTOMERRESULT:oWSGENERICVIEW2
	
					cHtml := ExecInPage("PWSACliPop")
				Else
					HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "javascript:history.back();"}//"W_PWSA001.APW" }			//"Erro"
					cHtml := ExecInPage("PWSAMSG" )
				EndIf
			EndIf
		Else
			HttpSession->cPopProd  := ""
			cHtml := ExecInPage("PWSACliPop")
		EndIf
	EndIf
	
	WEB EXTENDED END
	
Return cHtml
*/
/******************************************************************
* Autor...: Emerson Grassi Rocha
* Data: 	Mar/2006
* Objetivo: Consulta Periodos em tela de popup
*******************************************************************/
/*Web Function PWSAPerPop()
	Local cHtml := ""
	Local oObj := {}
	
	WEB EXTENDED INIT cHtml START "InSite"
	
	//SE FOR CONSULTA NA POPUP
	If HttpGet->cPopUp == "1"
		HttpSession->aNewAval[9] := HttpGet->cPeriodoDe
		HttpSession->aNewAval[10]:= HttpGet->cPeriodoAte
		cHtml := ExecInPage("PWSA017" )
	Else
		HttpPost->aPeriodo := {}
	
		oObj := WSRHPERFORMANCEEVALUATE():NEW()
		WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
	
		If oObj:BrwPeriod( CODUSUARIO, HttpSession->aNewAval[3], HttpSession->aNewAval[1], HttpSession->cParticipantID)
			HttpPost->aPeriodo := oObj:oWSBRWPERIODRESULT:oWSEVALUATELIST
	
			cHtml += ExecInPage("PWSAPerPop")
		Else
			HttpSession->_HTMLERRO := { STR0001, PWSGetWSError(), "javascript:history.back();"}//"W_PWSA001.APW" }			//"Erro"
			cHtml := ExecInPage("PWSAMSG" )
		EndIf
	
	EndIf
	
	WEB EXTENDED END
Return cHtml
*/
/******************************************************************
* Autor...: Emerson Grassi Rocha
* Data: 	Mar/2006
* Objetivo: Pagina de Inclusao de Periodo
*******************************************************************/
/*Web Function PWSAPerInc()
	Local cHtml := ""
	
	WEB EXTENDED INIT cHtml START "InSite"
	
		cHtml := ExecInPage("PWSAPerInc")
	
	WEB EXTENDED END
Return cHtml
*/
/******************************************************************
* Autor...: Juliana Barros Mariano
* Data: 	Outubro de 2004
* Objetivo: Inclusao de avaliacao
*******************************************************************/
/*Web Function PWSA018()
	Local cHtml 	:= ""
	Local oIncAval 	:= {}
	Local oAval     := {}
	
	WEB EXTENDED INIT cHtml START "InSite"	
		oIncAval := WSRHPERFORMANCEEVALUATE():NEW()
		WsChgURL(@oIncAval,"RHPERFORMANCEEVALUATE.APW")
		
		//O AVALIADOR NAO PODE SER O MESMO QUE O AVALIADO
		If HttpSession->aNewAval[3] == HttpSession->cParticipantID
			HttpSession->_HTMLERRO := { STR0012, STR0013, "W_PWSA017.APW" }	//"Inclus? - Erro"##"O avaliador deve ser diferente do avaliado."
			Return ExecInPage("PWSAMSG" )
		EndIf
		
		oIncAval:oWSPROJECTEVALUATE:oWSLISTOFEVALUATE := WsClassNew("RHPERFORMANCEEVALUATE_ARRAYOFEVALUATELIST")
		oIncAval:oWSPROJECTEVALUATE:oWSLISTOFEVALUATE:oWSEVALUATELIST := {}
	
		oAval := RHPERFORMANCEEVALUATE_EVALUATELIST():NEW()
	
		oAval:cEVALUATEDID 		:= HttpSession->aNewAval[3]
		oAval:cEVALUATEDNAME 	:= HttpSession->aNewAval[2]
		oAval:cEVALUATEID 		:= HttpSession->aNewAval[1]
		oAval:cEVALUATETYPE 	:= HttpSession->aNewAval[11]
		oAval:cEVALUATORNAME	:= HttpSession->cParticipantName
		oAval:cEVALUATORID 		:= HttpSession->cParticipantId
		oAval:dINITIALDATE 		:= CTOD(HttpSession->aNewAval[9])
		oAval:dFINALDATE 		:= CTOD(HttpSession->aNewAval[10])
		oAval:cLEVEL 			:= HttpSession->aNewAval[13]
		oAval:cNET 				:= HttpSession->aNewAval[12]		
		oAval:cSELFEVALUATE 	:= "1"
			
		If ExistBlock("MSGETPROJECT")
			oAval:cPROJECT 		:= HttpSession->aNewAval[7] + HttpSession->aNewAval[14] + HttpSession->aNewAval[5]  
		Else
			oAval:cPROJECT 		:= HttpSession->aNewAval[5]
		End
		
		aadd( oIncAval:oWSPROJECTEVALUATE:oWSLISTOFEVALUATE:oWSEVALUATELIST, oAval )
	
		//INCLUSAO DE AVALIACAO
		If oIncAval:PutEvaluate( CODUSUARIO, oIncAval:oWSPROJECTEVALUATE )	
			HttpSession->_HTMLERRO := { STR0014, STR0015, "javascript:history.go(-2);"}//"W_PWSA001.APW" }		//"Inclus?"##"Inclus? efetuada com sucesso."
			cHtml := ExecInPage("PWSAMSG" )
		Else
			HttpSession->_HTMLERRO := { STR0012, PWSGetWSError(), "javascript:history.back();"}//"W_PWSA001.APW" }		//"Inclus? - Erro"
			cHtml := ExecInPage("PWSAMSG" )
		EndIf
	WEB EXTENDED END	
Return cHtml
*/


/******************************************************************
* Autor...: Emerson Grassi Rocha
* Data: 	Mar/2006
* Objetivo: Inclusao de Projeto
*******************************************************************/
/*Web Function PWSA019()
	Local cHtml 	:= ""
	Local oObj 		:= {}
	Local oProj		:= {}
	
	WEB EXTENDED INIT cHtml START "InSite"
	
	oObj := WSRHPERFORMANCEEVALUATE():NEW()
	WsChgURL(@oObj,"RHPERFORMANCEEVALUATE.APW")
	oObj:oWSPUTPROJECT:oWSLISTOFPROJECT := WsClassNew("RHPERFORMANCEEVALUATE_ARRAYOFPROJECTS")
	oObj:oWSPUTPROJECT:oWSLISTOFPROJECT:oWsProjects := {}

	oProj := RHPERFORMANCEEVALUATE_PROJECTS():NEW()

	oProj:cProjectId			:= "xxxxx"
	oProj:cProjectDescription	:= HttpGet->cProjPmsDesc
	oProj:dDateFrom				:= Ctod(HttpGet->cPerDe)
	oProj:dDateTo				:= Ctod(HttpGet->cPerAte)
	oProj:cMemoCode				:= HttpGet->cDescObs
	oProj:cClientId				:= HttpGet->cCliente
	oProj:cPmsCode				:= HttpGet->cProjPms

	aadd( oObj:oWSPUTPROJECT:oWSLISTOFPROJECT:oWsProjects, oProj )

	//INCLUSAO DE AVALIACAO
	If oObj:PutProjects( CODUSUARIO, oObj:oWSPUTPROJECT )

		HttpSession->aNewAval[5]:= oObj:cPutProjectsResult
		HttpSession->aNewAval[6]:= HttpGet->cProjPmsDesc

		HttpSession->_HTMLERRO := { STR0014, STR0015, "W_PWSA017.APW?cPopUp=3" }		//"Inclus?"##"Inclus? efetuada com sucesso."
		cHtml := ExecInPage("PWSAMSG" )
	Else
		HttpSession->_HTMLERRO := { STR0012, PWSGetWSError(), "W_PWSAProjInc.APW" }		//"Inclus? - Erro"
		cHtml := ExecInPage("PWSAMSG" )
	EndIf
		
	WEB EXTENDED END
Return cHtml*/
            
//Verifica existencia de Avaliação de Consenso 
Static Function ChkAvaCon()
	local oAva := nil
	local nI   := 1      
	local aAux := {}
	
	oAva := wsWsCsPortalAPD():New()
	WsChgURL(@oAva,"WsCsPortalAPD.APW")

	For nI :=1 to len( HttpSession->BRWMYEVALUATES[1] )	
		if oAva:getListaAvaliacaoConsenso( HttpSession->cParticipantID, HttpSession->BRWMYEVALUATES[1][nI]:CEVALUATEID, HttpSession->BRWMYEVALUATES[1][nI]:dINITIALDATE )
          aAdd( aAux, { oAva:OWSGETLISTAAVALIACAOCONSENSORESULT:C_CLIDERHI, oAva:OWSGETLISTAAVALIACAOCONSENSORESULT:C_CDATRET } )          
		endif
	Next nI
	
	HttpSession->_aAvaCon := aAux
Return()

Static Function retMedia()
	local oAva := nil
	local cChave := ''
	
	oAva := wsWsCsPortalAPD():New()
	WsChgURL(@oAva,"WsCsPortalAPD.APW")
 
	 //Alterado 11/07/2017 Bruno Nunes
	cChave := 	HttpSession->GETPEVALUATE[1]:cEVALUATEID + HTTPSession->GETPEVALUATE[1]:cEVALUATEDID + HttpSession->GETPEVALUATE[1]:cPROJECT + dtos(CTOD(HttpSession->cDateFrom))
	if !empty(cChave)
		HttpSession->_nMedia := 0
		if oAva:getMediaAvaliacaoConsenso( cChave )
			//if oAva:getListaAvaliacaoConsenso( cChave ) antigo
 			HttpSession->_nMedia := oAva:NGETMEDIAAVALIACAOCONSENSORESULT
		endif
	endif
Return()

Static Function loadMentor()
	local oAva 	 := nil
	local cChave := ''
	    
	oAva := wsWsCsPortalAPD():New()
	WsChgURL(@oAva,"WsCsPortalAPD.APW")

	cChave := HttpSession->GETPEVALUATE[1]:cEVALUATEID+HttpSession->GETPEVALUATE[1]:cEVALUATEDID
	if !empty(cChave)
		if oAva:getCodigoMentor( cChave )
 			HttpSession->_cCodMen := oAva:CGETCODIGOMENTORRESULT
		endif

		cChave := HttpSession->_cCodMen
		if oAva:getNomeMentor( cChave )
 			HttpSession->_cNomMen := oAva:CGETNOMEMENTORRESULT
		endif
	endif
Return()

Static Function loadCC()
	local oAva 	 := nil
	local cChave := ''
	    
	oAva := wsWsCsPortalAPD():New()
	WsChgURL(@oAva,"WsCsPortalAPD.APW")

	cChave := HttpSession->GETPEVALUATE[1]:cEVALUATEDID
	if !empty(cChave)
		if oAva:getCodigoCc( cChave )
	 		HttpSession->_cCodCC := oAva:CGETCODIGOCCRESULT
		endif
	
		cChave := HttpSession->_cCodCC
		if oAva:getNomeCc( cChave )
	 		HttpSession->_cDescCC := oAva:CGETNOMECCRESULT
		endif
	endif
Return()

Static Function loadLider()
	local oAva 	 := nil
	local cChave := ''
	    
	oAva := wsWsCsPortalAPD():New()
	WsChgURL(@oAva,"WsCsPortalAPD.APW")

	cChave := HttpSession->GETPEVALUATE[1]:cEVALUATEDID
	if !empty(cChave)
		if oAva:getCodigoLider( cChave )
	 		HttpSession->_cCodLid := oAva:CGETCODIGOLIDERRESULT
		endif
	
		cChave := HttpSession->_cCodLid
		if oAva:getNomeLider( cChave )
	 		HttpSession->_cNomLid := oAva:CGETNOMELIDERRESULT
		endif
	endif
Return()

Static Function loadLegend()
	local oAva 	 := nil
	local cChave := ''
	    
	oAva := wsWsCsPortalAPD():New()
	WsChgURL(@oAva,"WsCsPortalAPD.APW")
      
	//Alexandre - verificar se a chave esta certa
	cChave := HttpSession->GETPEVALUATE[1]:cEVALUATEDID	
	if !empty(cChave)
		if oAva:getDescricaoLegenda( cChave )
	 		HttpSession->_LegendaConsenso := oAva:CGETDESCRICAOLEGENDARESULT
		endif
	endif
Return