User Function MMENS039
                                                                                                            
Local aDados	  	:= ParamIXB[1]
Local cMensagem 	:= ParamIXB[2]   
Local cContrato 	:= aDados[1] 
Local cRevisa	 	:= aDados[2]
Local cCodFor		//Código do fornecedor
Local nLojaFor 		//Loja do fornecedor
Local cNomeFor 		//Descrição Fornecedor

cMensagem:= OemToAnsi("AVISO TÉRMINO CONTRATO:")  

dbSelectArea("CNC")
CNC->(dbSetOrder(3))    //CNC_FILIAL+CNC_NUMERO+CNC_REVISA+CNC_CODIGO+CNC_LOJA
If CNC->(dbSeek(xFilial("CNC")+cContrato+cRevisa))  
	cCodFor 		:= CNC->CNC_CODIGO
	nLojaFor		:= CNC->CNC_LOJA
    cNomeFor		:= GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+cCodFor+nLojaFor,1,"Fornecedor Nao Encontrado") + Chr(13) + Chr(10)
   	cMensagem   += + Chr(13) + Chr(10)
   	cMensagem   += "Contrato.: " + cContrato + Chr(13) + Chr(10) 
   	cMensagem   += "Revisão.: " + cRevisa + Chr(13) + Chr(10)
   	cMensagem	+= "Saldo.: " + cValToChar(TRANSFORM(CN9->CN9_SALDO, "@E 9,999,999,999.99")) + Chr(13) + Chr(10)    
	cMensagem	+= "Fornecedor.: " + cCodFor +" " + cValToChar(nLojaFor) + " " + "- " + cNomeFor 
	cMensagem	+= OemToAnsi("Data Início.:") + cValToChar(CN9->CN9_DTINIC) + Chr(13) + Chr(10)
	cMensagem	+= OemToAnsi("Data Término.:") + cValToChar(CN9->CN9_DTFIM) + Chr(13) + Chr(10)
Endif                                                             
Return(cMensagem)     

