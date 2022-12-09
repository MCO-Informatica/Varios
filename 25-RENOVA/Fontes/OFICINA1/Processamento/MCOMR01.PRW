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
±±ºUso       ³  U_MCOMR01()                                               ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
                                      
User Function MCOMR01(aParam)
Local nAux		:= 0
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
	SM0->(DbEval({|| Aadd(alEmp, {SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->M0_CGC}) }))
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
Local nSemaForo       
Local aRet			:= {}

If lJob

		cTpAmb		:= SuperGetMV("ES_XMLAMB"	,.F.,'1',				)	
		cUfAutor	:= SuperGetMV("ES_XMLUF" 	,.F.,'31'				)
		cCNPJ		:= SM0->M0_CGC
		
		DbSelectArea("Z05")
		DbSetOrder(2)   
		If Z05->(dbSeek(xFilial("Z05")+Alltrim(cCNPJ) )) 
			Conout("Inicio da rotina ACOMR01 - Baixando as chaves da NFe. - Empresa: " + cEmpAnt + " - Filial:" + cFilAnt  + " - "+ DtoC(Date())+" "+Time()+" CNPJ: "+cCNPJ)
			aRet := U_ACOMR01(cTpAmb, cUfAutor, cCNPJ, 1) 
			
			If .NOT. aRet[1]
				ConOut("Erro no retorno ACOMR01 -> "+aRet[2])
			Endif	
			Conout("Fim da rotina ACOMR01 - Baixando as chaves da NFe. - Empresa: " + cEmpAnt + " - Filial:" + cFilAnt  + " - "+ DtoC(Date())+" "+Time()+" CNPJ: "+cCNPJ)
		Endif
Else
 
	cTpAmb		:= SuperGetMV("ES_XMLAMB"	,.F.,'1',				)	
	cUfAutor	:= SuperGetMV("ES_XMLUF" 	,.F.,'31'				)
	cCNPJ		:= SM0->M0_CGC
	
	        
	If ( nSemaforo := MsFCreate(GetNewPar("ES_SEMACHV","JOB"+cEmpAnt+".lck") ) ) < 0	
		MsgAlert(OemToAnsi("A Rotina de Importação de chaves NFe esta sendo utilizada por")+ENTER+;
		OemToAnsi("outro usuário. Por questoes de integridade de dados, nao")+ENTER+;
		OemToAnsi("é permitida a utilização desta rotina por mais de um usuário")+ENTER+;
		OemToAnsi("simultaneamente. Tente novamente mais tarde."),"Atenção")
	Else
		DbSelectArea("Z05")
		DbSetOrder(2)   
		If Z05->(dbSeek(xFilial("Z05")+Alltrim(cCNPJ) )) 

			Conout("Inicio da rotina ACOMR01 - Baixando as chaves da NFe. " + DtoC(Date())+" "+Time() )
		   
		   	LJMsgRun("Importando chaves NFE junto a Sefaz","Aguarde... ",{|| aRet	:= U_ACOMR01(cTpAmb, cUfAutor, cCNPJ, 1) })

			If .NOT. aRet[1] 
				ConOut("Erro no retorno ACOMR01 -> "+aRet[2])
				Aviso("Aviso", aRet[2] , {"&Ok"}, 2, "Processo abortado!" )  
				Fclose(nSemaForo)
				Ferase("JOB"+cEmpAnt+".lck")
				Return .F.
			EndIf

			Conout("Fim da rotina ACOMR01 - Baixando as chaves da NFe. - Empresa: " + cEmpAnt + " - Filial:" + cFilAnt  + " - "+ DtoC(Date())+" "+Time()+" CNPJ: "+cCNPJ)
			
		Endif
		Fclose(nSemaForo)
		Ferase("JOB"+cEmpAnt+".lck")	
	EndIf
		
EndIf
												
Return