User Function MMENS038
                                                                                                            
Local aDados	  	:= ParamIXB[1]
Local cMensagem 	:= ParamIXB[2]   
Local cContrato 	:= aDados[1] 
Local cRevisa	 	:= aDados[2]
Local cCodFor		//C�digo do fornecedor
Local nLojaFor 		//Loja do fornecedor
Local cNomeFor 		//Descri��o Fornecedor

cMensagem:= OemToAnsi("Aviso Vencimento do Contrato:")  
 
dbSelectArea("CNC")
CNC->(dbSetOrder(3))    //CNC_FILIAL+CNC_NUMERO+CNC_REVISA+CNC_CODIGO+CNC_LOJA
If CNC->(dbSeek(xFilial("CNC")+cContrato+cRevisa))  
	cCodFor 		:= CNC->CNC_CODIGO
	nLojaFor		:= CNC->CNC_LOJA
    cNomeFor		:= GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+cCodFor+nLojaFor,1,"Fornecedor Nao Encontrado") + Chr(13) + Chr(10)
   	//cMensagem 	 	+= "Saldo: "+TRANSFORM(cValToChar(CN9->CN9_SALDO), "@E 9,999,999,999,999.99") + Chr(13) + Chr(10)
   	cMensagem   += + Chr(13) + Chr(10)
   	cMensagem   += "Contrato.: " + cContrato + Chr(13) + Chr(10) 
   	cMensagem   += "Revis�o.: " + cRevisa + Chr(13) + Chr(10)
   	cMensagem	+= "Saldo.: " + cValToChar(TRANSFORM(CN9->CN9_SALDO, "@E 9,999,999,999.99")) + Chr(13) + Chr(10)    
	cMensagem	+= "Fornecedor.: " + cCodFor +" " + cValToChar(nLojaFor) + " " + "- " + cNomeFor 
	cMensagem	+= OemToAnsi("Data In�cio.:") + cValToChar(CN9->CN9_DTINIC) + Chr(13) + Chr(10)
	cMensagem	+= OemToAnsi("Data T�rmino.:") + cValToChar(CN9->CN9_DTFIM) + Chr(13) + Chr(10)
Endif                                                             
Return(cMensagem)  



