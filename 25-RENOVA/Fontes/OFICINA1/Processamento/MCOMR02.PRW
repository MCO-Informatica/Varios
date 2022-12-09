#include "topconn.ch"
#include "protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#Define ENTER Chr(13)+Chr(10) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MCOMR01   ºAutor  ³Felipi Marques      º Data ³  03/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Job que realiza a importação das chaves das notas emi       º±±
±±º          ³tidas contra o CNPJ passado como parametro atraves do WS    º±±
±±º			 ³NfeDistribuiçãoDFe SEFAZ AN-Ambiente Nacional				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  U_MCOMR02()                                               ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
                                      
User Function MCOMR02(aParam)

Local alEmp 	:= {}
Local lEmp		:= Type('cFilAnt') == "C"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Determina a execucao via job                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lJob		:= IsBlind()   

Default aParam	:= {}  

If lJob
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .T., .F. )
	SM0->(DbGotop())
	SM0->(DbEval({|| Aadd(alEmp, {SM0->M0_CODIGO,SM0->M0_CODFIL}) }))
	SM0->(DbCloseArea())
	nLenEmp := Len(alEmp)
	
	
	//Executa a rotina de envio de e-mail de acompanhamento para cada empresa e filial 
	For nAux := 1 To nLenEmp
		
		//Abre empresa
		If !lEmp
			RpcSetType(2)
			RpcSetEnv(alEmp[nAux,1],alEmp[nAux,2])
		EndIF
	    
	    //Inicia processamento
		Processamento(aParam)
		
		//Fecha empresa
		If !lEmp
			RpcClearEnv()
		EndIF
		
	Next
Else
	Processa({|| Processamento(aParam)},"Processando registros", "")
EndIf

Return .T.

 
Static function Processamento(aParam)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cTpAmb		:= ""
Local cUfAutor		:= ""
Local cCNPJ			:= ""
Local OkCancel      := .T.
Local cRotina		:= "CIENCIA"
Local cQuery		:= ""       
Local cAlias		:= ""  
Local cEvento       := "210210–Ciencia da Operacao"
Local cJust         := ""
Local nSemaForo     
Local cStat			:= ""

If lJob
		
		cTpAmb		:= SuperGetMV("ES_XMLAMB"	,.F.,'1',				)	
		cUfAutor	:= SuperGetMV("ES_XMLUF" 	,.F.,'31'				)
		cCNPJ		:= SM0->M0_CGC
	
		Conout("Inicio da rotina MCOMR02 - Gerando Ciencia da operação. - Empresa: " + cEmpAnt + " - Filial:" + cFilAnt  + " - "+ Time())
			cQuery := " SELECT * FROM "+RetSqlName("Z01")
			cQuery += " WHERE Z01_FILIAL = '"+cFilAnt+"' AND Z01_STADOW = '1' AND Z01_STAXML <> '9' AND D_E_L_E_T_ = ' ' AND Z01_SCHEMA = 'resNFe_v1.00.xsd' "
			cQuery += " ORDER BY Z01_FILIAL,Z01_DTEMIS,Z01_NSU "
	        
			//Retorna um alias para ser utilizado no record set 
			cAlias		:= GetNextAlias()  
			//Abre uma workarea com o resultado da query
			TCQUERY cQuery NEW ALIAS (cAlias)
			//Move o cursor da área de trabalho ativa para o primeiro registro lógico do arquivo de dados   
			(cAlias)->(DbGoTop())
				
			If (cAlias)->(!Eof())
		
	
				// Rotina para geração da ciencia 
				While (cAlias)->(!Eof())
						If (cAlias)->Z01_STAXML <> "4"
							// Realiza a ciencia da operação
							cStat := U_ACOMR05(cTpAmb, cUfAutor, cCNPJ, 1, (cAlias)->Z01_CHVNFE,cEvento,cJust)
						Endif
						
						// Se  nota Cancelada ou denegada ou erro no WS, não continuar processamento - MH 07/02/2019
						If .NOT. cStat $ "653/654/XX/"
							//Chama apenas rotina para realizar o download do XML da Nota 
							U_ACOMR03( cTpAmb, cUfAutor, cCNPJ, 1, (cAlias)->Z01_CHVNFE, "1.00" )
						Endif					
					
					(cAlias)->(DbSkip()) 
				End
	   		EndIf		          
		    
		    //Libera a área de trabalho corrente para us
		    (cAlias)->( dbCloseArea() )
		
			Conout("Fim da rotina MCOMR02 - Gerando Ciencia da operação. - Empresa: " + cEmpAnt + " - Filial:" + cFilAnt  + " - "+ Time())
Else
 
	Conout("Inicio do ciencia e download das Nfe junto a SEFAZ.")
	Conout("Gerar arquivo de semaforo ... " + Time() )
		
	cTpAmb		:= SuperGetMV("ES_XMLAMB"	,.F.,'1',				)	
	cUfAutor	:= SuperGetMV("ES_XMLUF" 	,.F.,'31'				)
	cCNPJ		:= SM0->M0_CGC 

	Conout("Inicio da rotina MCOMR02 - Gerando Ciencia da operação. - Empresa: " + cEmpAnt + " - Filial:" + cFilAnt  + " - "+ Time())
	Conout("Gerar arquivo de semaforo ... " + Time() )
	        
	If ( nSemaforo := MsFCreate(GetNewPar("ES_SEMACHV","JOB"+cEmpAnt+".lck") ) ) < 0	
		MsgAlert(OemToAnsi("A Rotina de Download do XML das NFe's esta sendo utilizada por")+ENTER+;
		OemToAnsi("outro usuario. Por questoes de integridade de dados, nao")+ENTER+;
		OemToAnsi("‚ permitida a utiliza‡„o desta rotina por mais de um usu rio")+ENTER+;
		OemToAnsi("simultaneamente. Tente novamente mais tarde."),"Atenção")
	Else 
	
		cQuery := " SELECT * FROM "+RetSqlName("Z01")
		cQuery += " WHERE Z01_FILIAL = '"+cFilAnt+"' AND Z01_STADOW = '1' AND D_E_L_E_T_ = ' ' AND Z01_SCHEMA = 'resNFe_v1.00.xsd'   "
		cQuery += " ORDER BY Z01_FILIAL,Z01_DTEMIS,Z01_NSU "

		cAlias		:= GetNextAlias()         

		//Abre uma workarea com o resultado da query
		TCQUERY cQuery NEW ALIAS (cAlias)
	   
		(cAlias)->(DbGoTop())
		
		If (cAlias)->(!Eof())
			// Rotina para geração da ciencia 
			While (cAlias)->(!Eof())
				
				cStat := ""

				If (cAlias)->Z01_STAXML <> "4"
					// Realiza a ciencia da operação   
					LJMsgRun("Realizando a Ciência da NFe "+(cAlias)->Z01_NUMNFE+" junto a Sefaz","Aguarde... ",{|| cStat := U_ACOMR05(cTpAmb, cUfAutor, cCNPJ, 1, (cAlias)->Z01_CHVNFE,cEvento,cJust) })
				Endif
				
				// Se  nota Cancelada ou denegada ou erro no WS, não continuar processamento - MH 07/02/2019
				If .NOT. cStat $ "653/654/XX/"
				
					//Chama apenas rotina para realizar o download do XML da Nota 
					LJMsgRun("Realizando Manifestação/Download do XML da NFe "+(cAlias)->Z01_NUMNFE+" junto a Sefaz","Aguarde... ",{|| U_ACOMR03( cTpAmb, cUfAutor, cCNPJ, 1, (cAlias)->Z01_CHVNFE, "1.00" ) })
				Endif	
				
				(cAlias)->(DbSkip())
			End
   		EndIf	

		Fclose(nSemaForo)
		Ferase("MCOMR01"+cEmpAnt+".lck")
		Conout("Fim da rotina MCOMR02 - Gerando Ciencia da operação. - Empresa: " + cEmpAnt + " - Filial:" + cFilAnt  + " - "+ Time())
	EndIf
	
EndIf
												
Return