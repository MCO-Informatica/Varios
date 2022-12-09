#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"    
#DEFINE DIRXML  "XMLNFE\"
#DEFINE DIRALER "NEW\"
#DEFINE DIRLIDO "OLD\"
#DEFINE DIRERRO "ERR\" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACOMR03  ºAutor  ³Felipi Marques       º Data ³  04/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina que realiza a chamada do WS responsável por realizar º±±
±±º          ³o Download da NFe junto a SEFAZ                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³	                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/               

User Function ACOMR03( cTpAmb, cUfAutor, cCNPJ, nNumImp, cChave, cVersao )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oWS
Local oRetorno
Local cBeginReq  	
Local cEndReq		
Local cRequest   := ''  
Local cRotina    := "MANIFESTACAO"                            
Local cMotivo
Local cStat         
Local cNumNF
Local cSerie
Local cCNPJ
Local dDtEmissao
Local aArea	    := GetArea()
Local cError    := ""
Local lStatus   := .F. 
Local oAuxXml
Local oXML
Local cXml
Local lError := .F. 
Local lExisteNfe := .F. // MH 04/01/2019
Local nLimSef := SuperGetMv("ES_LIMSEF",,90) // Limite de dias que o Sefaz disponibiliza notas - MH 07/01/2019 
Local cTipoNf := "" // Capturar Notas de Complemento para tratar o Status - MH 08/01/2019

Private lJob		:= IsBlind()   
Private cIdEnt
Private aErros	:= {} // MH 04/01/2019



DbSelectArea("Z05")
Z05->(DbSetOrder(2))   
IF Z05->(dbSeek(xFilial("Z05")+cCNPJ)) 
	cIdEnt := Z05-> Z05_CODIGO
Else
	Conout( "| ACOMR03 | Não encontrado o cadastro da entidade" )   // MH 04/01/2019
EndIf 

//-- Prepara estrutura de diretorios
If !ExistDir(DIRXML)
	MakeDir(DIRXML)
	MakeDir(DIRXML +DIRALER)
	MakeDir(DIRXML +DIRLIDO)
	MakeDir(DIRXML +DIRERRO)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo Implementação Ex: Prox, TSS, Programa Externo, etc...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nNumImp == 1

	oWs 						:= WSNFeDistribuicaoDFe():New()
	cBeginReq   				:= SuperGetMv("ES_BDOWNFE" ,.F.,'<downloadNFe versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">')
	cEndReq						:= SuperGetMv("ES_EDOWNFE" ,.F.,'</downloadNFe>')
	
	/*cRequest += '<tpAmb>1</tpAmb>'
	cRequest +=	'<xServ>DOWNLOAD NFE</xServ>'					                  
	cRequest += '<CNPJ>'+AllTrim(cCNPJ)+'</CNPJ>'
	cRequest += '<chNFe>'+cChave+'</chNFe>'
	*/
	cBeginReq := '<distDFeInt xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.01">'  
	cRequest  += '<tpAmb>1</tpAmb>'  
	cRequest  += '<cUFAutor>'+cUfAutor+'</cUFAutor>'  
	cRequest  += '<CNPJ>'+AllTrim(cCNPJ)+'</CNPJ>'  
	cRequest  += '<consChNFe>'  
	cRequest  += '<chNFe>'+cChave+'</chNFe>'  
	cRequest  += '</consChNFe>'  
	cEndReq   := '</distDFeInt>'
	oWS:oWSnfeDadosMsg := cBeginReq + RTrim(cRequest) + cEndReq

	/*Faz a configuração do certificado utilizado pelo SSL*/
	U_ACOMR09(cIdEnt, @cError, oWs)
   									                                   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia Web Service Nfe Download NF³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 	!( oWS:nfeDistDFeInteresse() )
		If !(Empty( GetWSCError(3)))
			conout( GetWSCError(3) )
			If .NOT. lJob
				Alert( GetWSCError(3) )
			Endif	
		Else
			Conout( GetWSCError(1) )
			Conout( "| ACOMR03 | Problema na Execução do Webservice ! " )
			If .NOT. lJob
				Alert( GetWSCError(1) )
			Endif	
		EndIf
	
	Else                               
		Conout( "ACOMR03 - WebService consumido com sucesso!!!" )
	    oRetorno := oWs:oWsnfeDistDFeInteresseResult
		If oRetorno:_nfeDistDFeInteresseResult:_RetDistDfeint:_CSTAT:TEXT == "138"  // Documento Localizado 
			//³ Busca CNPJ do fornecedor          ³
			cEmitCNPJ	:= ""
			
			// Cria o arquivo compactado
			nHdl := fCreate(cChave+".gz")
			fWrite(nHdl,Decode64(oRetorno:_nfeDistDFeInteresseResult:_RetDistDfeint:_LoteDistDfeInt:_DocZip:Text))
			fClose(nHdl)
			
			// Decompacta o arquivo
			GzDecomp(cChave+".gz","\XMLNFE\NEW\")

            FErase(cChave+".gz") 

			cVldCont := FsLoadTXT("\XMLNFE\NEW\" + cChave)
            
            If .NOT. ("</NFE>" $ Upper(cVldCont))
				//-- Move arquivo para pasta dos erros
				cArqTXT     := "\XMLNFE\NEW\" +cChave
				//copia o arquivo antes da transacao
				cNomNovArq  := "\XMLNFE\ERR\" +cChave
				If MsErase(cNomNovArq)
					__CopyFile(cArqTXT,cNomNovArq)
					FErase("\XMLNFE\NEW\" +cChave) 
					FErase("\XMLNFE\NEW\" +cChave)
				EndIf  
            EndIf
            

			// Nome do arquivo a importar
			cFile := "NFe" + cChave+ ".XML"
		    
		    //Pausa por 2 segundos
		    Sleep(2000)
		    
		    // Deleta Arquivo
			If File("\XMLNFE\NEW\"+cFile)
				FErase("\XMLNFE\NEW\"+cFile)                
		    EndIf
		
			// Renomeia o arquivo
			nRename := FRenameEx("\XMLNFE\NEW\"+cChave, "\XMLNFE\NEW\"+cFile)

		    // Apaga o arquivo GZIP
			If File("\XMLNFE\NEW\"+cChave+".gz")
				FErase("\XMLNFE\NEW\"+cChave+".gz")                
		    EndIf    
		    
		    // Apaga o arquivo cChave
			If File("\XMLNFE\NEW\"+cChave)
				FErase("\XMLNFE\NEW\"+cChave)                
		    EndIf               
			
			cXMLOri := FsLoadTXT(DIRXML+DIRALER + cFile)
			
			cTipoNf := ""
            
            //-- Processa somente nota fiscal 
			If ("</NFE>" $ Upper(cXMLOri))
		         
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³BUSCA DOC PELA CHAVE DA NOTA ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SDS")
				SDS->(DbSetOrder(2))
				If !SDS->(DbSeek(xFilial("SDS")+Right(AllTrim(cChave),44)))//Filial + Chave de acessondIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
					//³Chama funcao de importação de XML          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[Ù
					//MsAguarde({||  },"Aguarde","Importando dados do arquivo XML...",.F.)				
					lStatus := U_ACOMR07(cFile,lJob,@oXML,@cXML,@aErros,@cTipoNf)
				Else
					// Não gerar erro quando a NF já está no sistema
					lExisteNfe := .T.
				EndIf
		
		    Else  
		    	//Erro no XML
		    	lError := .T.
		    	
		    	// Deleta Arquivo
				If File("\XMLNFE\NEW\"+cFile)
					FErase(cFile)                
			    EndIf

		    EndIf
			
			If lStatus
                If  ValType(XmlChildEx(oXML,"_INFNFE")) == "O" 
                	oAuxXml := XmlChildEx(oXML,"_INFNFE")
                EndIf
                
                If XmlChildEx(oAuxXml:_EMIT,"_CNPJ") # NIL
					cEmitCNPJ := oAuxXml:_EMIT:_CNPJ:TEXT
				Else
					cEmitCNPJ := oAuxXml:_EMIT:_CPF:TEXT
				EndIf
			
                cNumNF   := StrZero(Val(AllTrim(oXML:_InfNfe:_Ide:_nNF:Text)),TamSx3("F1_DOC")[1])
				cSerie   := StrZero(Val(AllTrim(oXML:_InfNfe:_Ide:_Serie:Text)),TamSx3("F3_SDOC")[1])
			
                If  ValType(XmlChildEx(oXML:_InfNfe:_Ide,"_DEMI")) == "O"
					dDtEmissao := StoD(StrTran(AllTrim(oXML:_InfNfe:_Ide:_DEmi:Text),"-",""))
				ElseIf ValType(XmlChildEx(oXML:_InfNfe:_Ide,"_DHEMI")) == "O" 
					dDtEmissao := StoD(StrTran(Substr((oXML:_InfNfe:_Ide:_DhEmi:Text),1,10),"-",""))
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava na tabela Z02 o xml baixado  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
				U_ACOME02( cChave, cRotina, cXML ,cNumNF, cSerie, cEmitCNPJ, dDtEmissao ) 
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava Flag do xml baixado          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				U_ACOMR04( cChave, .F. )
				

				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Modifica o status da chave manifestada     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Z01->(DbSetOrder(1))
				If Z01->(DbSeek(xFilial("Z01")+cChave)) 
					RecLock("Z01",.F.)
				   		Z01->Z01_STAXML 	:= "9"  
			   		MsUnlock()
				EndIf

			ElseIF lExisteNfe // MH 04/01/2019
				// Já existe a Chave na tabela SDS, considerar manifestada
				//³ Modifica o status da chave manifestada     ³
				Z01->(DbSetOrder(1))
				If Z01->(DbSeek(xFilial("Z01")+cChave)) 
					RecLock("Z01",.F.)
				   		Z01->Z01_STAXML 	:= "9"  
				   		Z01->Z01_STADOW     := "2"
			   		MsUnlock()
				EndIf

			ElseIf !lError
				
				cErro   := "ERRO AO REALIZAR A IMPORTAÇÃO XML"
				cMotivo := "XML Não tratado ou com erro "+CHR(13)+CHR(10)
				
				For i := 1 to Len(aErros) 
					For x := 1 to Len(aErros[i])
				   		cMotivo += aErros[i][x]+CHR(13)+CHR(10)
					Next
				Next
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ocorrencia de não realizar a gravacao em virtude do chave ja existir e/ou erro na rotina de gravação.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				U_ACOME04( cChave, cRotina, "", "", cErro, "", cMotivo )
				
				//-- Move arquivo para pasta dos erros
				cArqTXT     := DIRXML+DIRALER+cFile
				//copia o arquivo antes da transacao
				cNomNovArq  := DIRXML+DIRERRO+cFile
				If MsErase(cNomNovArq)
					__CopyFile(cArqTXT,cNomNovArq)
					FErase(DIRXML+DIRALER+cFile) 
					FErase(DIRXML+DIRALER+cChave)
				EndIf                           
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Modifica o status da chave manifestada     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Z01->(DbSetOrder(1))
				If Z01->(DbSeek(xFilial("Z01")+cChave)) 
					RecLock("Z01",.F.)
					// Atualizar Status para Notas não tratadas pela Rotina - Complemento de Preço/Icms/IPI/Ajuste
					If cTipoNf $ "C/A"
						Z01->Z01_STAXML := '7' 
						Z01->Z01_STADOW := '2'
					Else	 
				   		Z01->Z01_STAXML 	:= "9"
				   	Endif	  
			   		MsUnlock()
				EndIf
				
			Else	
			
				// Verifica se o Sefaz está retornando um XML resumido - MH 08/02/2019
            	// Isso acontece quando uma Nfe que estava válida recebeu um evento de "Operação Não Realizada" ou "Desconhecimento" 
            	// ou ainda quando existe um documento emitido mas ele foi invalidado posteriormente (Nf transmitida para o Sefaz mas sem autorização ou negada posteriomente)
            	// nesse caso pode ocorrer "Nfe inexistente na base do Sefaz Nacional. Consulte o Sefaz de Origem da Nf"
            	If "</RESNFE" $ Upper(cVldCont)

					Z01->(DbSetOrder(1))
					If Z01->(DbSeek(xFilial("Z01")+cChave)) 
						RecLock("Z01",.F.)
						Z01->Z01_STAXML := '3' 
						Z01->Z01_STADOW := '2'
				   		MsUnlock()
					EndIf
            	
            	Else	
					cMotivo := "Não foi possivel realizar o download do xml" 
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Ocorrencia de não realizar a gravacao em virtude do chave ja existir e/ou erro na rotina de gravação.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					U_ACOME04( cChave, cRotina, "", "", cMotivo, "", "" )
				Endif
			EndIf
		// Tratar Nfe não existente no Sefaz por decurso de prazo		
		ElseIf oRetorno:_nfeDistDFeInteresseResult:_RetDistDfeint:_CSTAT:TEXT $ "137" 
			cMotivo := oRetorno:_nfeDistDFeInteresseResult:_RetDistDfeint:_XMOTIVO:TEXT // oRetorno:_RETNFE:_XMOTIVO:TEXT
			cStat   := oRetorno:_nfeDistDFeInteresseResult:_RetDistDfeint:_CSTAT:TEXT   // oRetorno:_RETNFE:_CSTAT:TEXT

			//³ Modifica o status da chave não localizada                                                                      ³

			Z01->(DbSetOrder(1))
			If Z01->(DbSeek(xFilial("Z01")+cChave)) 
				If (Date() - Z01->Z01_DTEMIS) > 70 // Maior Prazo da Sefaz 
					RecLock("Z01",.F.)
			   		Z01->Z01_STAXML 	:= "7"  
			   		Z01->Z01_STADOW 	:= "3"  
			   		MsUnlock()
			   		Conout( "ERRO ACOMR05 - "+cMotivo + " "+cStat+" NFE: "+Z01->Z01_NUMNFE+" CHAVE: "+Z01->Z01_CHVNFE+" DECURSO DE PRAZO")
		   		EndIf   
		   	Endif
	   		//³Gravação do log do motivo do erro.                                                                           ³
	   		U_ACOME04( cChave, cRotina, "", "", "Nfe indisponível por decurso de Prazo", cStat, "" )		
				
		// Tratar Nfe Cancelada ou Denegada como Status definitivos e não processar mais		
		ElseIf oRetorno:_nfeDistDFeInteresseResult:_RetDistDfeint:_CSTAT:TEXT $ "650/653/654"  // Nfe Cancelada ou Denegada		
			cMotivo := oRetorno:_nfeDistDFeInteresseResult:_RetDistDfeint:_XMOTIVO:TEXT // oRetorno:_RETNFE:_XMOTIVO:TEXT
			cStat   := oRetorno:_nfeDistDFeInteresseResult:_RetDistDfeint:_CSTAT:TEXT   // oRetorno:_RETNFE:_CSTAT:TEXT

			//³ Modifica o status da chave manifestada                                                                      ³
			Z01->(DbSetOrder(1))
			If Z01->(DbSeek(xFilial("Z01")+cChave)) 
				RecLock("Z01",.F.)
			   		Z01->Z01_STAXML 	:= "6"  
			   		Z01->Z01_STADOW 	:= "2"  
		   		MsUnlock()
			EndIf   

			//³Gravação do log do motivo do erro.                                                                           ³
			U_ACOME04( cChave, cRotina, "", "", cMotivo, cStat, "" )		
		
		Else
			cMotivo := oRetorno:_nfeDistDFeInteresseResult:_RetDistDfeint:_XMOTIVO:TEXT // oRetorno:_RETNFE:_XMOTIVO:TEXT
			cStat   := oRetorno:_nfeDistDFeInteresseResult:_RetDistDfeint:_CSTAT:TEXT   // oRetorno:_RETNFE:_CSTAT:TEXT
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Modifica o status da chave manifestada                                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Z01->(DbSetOrder(1))
			If Z01->(DbSeek(xFilial("Z01")+cChave)) 
				RecLock("Z01",.F.)
			   		Z01->Z01_STAXML 	:= "6"  
		   		MsUnlock()
			EndIf   
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gravação do log do motivo do erro.                                                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			U_ACOME04( cChave, cRotina, "", "", cMotivo, cStat, "" )		
		
		EndIf					
	  
	EndIf
	
EndIf 

RestArea(aArea)        

Return(lStatus) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FsLoadTXT ºAutor  ³Felipi Marques      º Data ³  05/18/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de leitura de arquivo texto para anexar ao XML      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FsLoadTXT(cFileXml)

Local cTexto     := ""
Local nHandle    := 0
Local nTamanho   := 0
nHandle := FOpen(cFileXml)
If nHandle > 0
	nTamanho := Fseek(nHandle,0,FS_END)
	FSeek(nHandle,0,FS_SET)
	FRead(nHandle,@cTexto,nTamanho)
	FClose(nHandle)
EndIf   

Return(cTexto) 