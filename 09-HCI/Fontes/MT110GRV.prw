#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

User Function MT110GRV()
	Local aRet := {}
	Local nPos := 0 
	Local cXML := ""
	Local cProcessId := "MATA110"
	Local cComments := "Solicitacao Gerada atraves do Protheus"
	
	If INCLUI
		//INICIALIZA SOLICITACOES COMO BLOQUEADAS
		Reclock ("SC1" ,.F.)
		replace C1_APROV with "B"
		MsUnlock()
		
		//Gera XML
		cXML :=U_MATA110XML()
		
	   //aRet := BIStartTask("MATA110", SC1->C1_NUM + SC1->C1_ITEM, cProcessId,cComments,cXML) 
	   //nPos := aScan(aRet,{|x| x [1] == "ERROR"})  
	                     
	   nPos := FWECMStartProcess(cProcessId,0,cComments,cXML)
		
		If nPos > 0
			MsgStop("Erro ao iniciar processo no Fluig ")
		Else
			//Insere um registro na tabela de equivalência Protheus X Fluig - WFE
		   //	BIPrtEcm("MATA110", SC1->C1_NUM + SC1->C1_ITEM, aRet[4[2]])
		   	MsgInfo("Solicitacao " +SC1->C1_NUM + SC1->C1_ITEM + " criada no fluig.")
		EndIf
	EndIf
Return