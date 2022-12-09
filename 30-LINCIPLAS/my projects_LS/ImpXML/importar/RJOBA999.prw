#INCLUDE "Protheus.ch"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TbiConn.ch"
                                             				
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RJOBA999 �Autor  �Bruno Daniel Borges � Data �  17/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �JOB que baixa os emails que podem conter XMLs de NFs eletro-���
���          �nica para serem importados posteriormente para o Protheus   ���
�������������������������������������������������������������������������͹��
���Uso       � Clientes Totvs em Geral                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RJOBA999( _lProcSch )   

Local cConta     	:= "" 
Local cServer		:= "" 
Local cPass			:= "" 
Local cDirXMLNFE    := ""
Local nPorta		:= 0 
Local nTimeOut      := 0 
Local nEmails       := 0
Local i,j           := 0  
Local nXML          := 0
Local oMessage 		:= Nil
Local oMailServer	:= Nil
Local aAttInfo		:= {}
Local lUsaTSS		:= .F.   

//Inicializa os parametros 
cConta 		:= Alltrim( SuperGetMV( "MV_XUSRMAI", .F., "" ) )
cServer 	:= Alltrim( SuperGetMV( "MV_XSRVMAI", .F., "" ) )
cPass		:= Alltrim( SuperGetMV( "MV_XSENMAI", .F., "" ) ) 
cDirXMLNFE	:= Alltrim( SuperGetMV( "MV_XPSTXML", .F., "\XMLS_NFE\" ) ) 
nPorta      := SuperGetMV( "MV_XPORPOP", .F., 110 )  
lUsaTSS		:= SuperGetMV( "MV_XSRCSEG", .F., .F.) 
nTimeOut    := SuperGetMV( "MV_XTIMEOU", .F., 1500 ) 
cMailResp 	:= Alltrim( SuperGetMV( "MV_XMAILRE", .F., " " ) )    

if valtype ( nPorta ) == "C"  

	nPorta := val ( nPorta ) 

Endif  

cDirXMLNFE += if ( Right(alltrim(cDirXMLNFE),1) <> '\', '\', '' ) + 'temp\'       
 
//Abre a conexao com o servidor
oMailServer := TMailManager():New()    

// Servidor Requer conex�o segura?
If lUsaTSS
	oMailServer:SetUseSSL(.T.)
EndIf

oMailServer:Init(cServer,"",cConta,cPass,nPorta)
                      
//Estabelece conexao POP
If oMailServer:PopConnect() == 0  

	//Cria o diretorio caso nao exista
	MakeDir(cDirXMLNFE)
               
	//Define o Timeout
	oMailServer:SetPOPTimeout(nTimeOut)
 
 	//Processa a qtd. de mensagens do servidor
	oMailServer:GetNumMsgs(@nEmails)
	
 	If( nEmails > 0 )
 	
 		oMessage := TMailMessage():New()
 	
 		//Verifica todas mensagens no servidor 
 		For i := 1 To nEmails  
 		
 			oMessage:Clear()
 			If oMessage:Receive(oMailServer,i) == 0   
 			
 				//Verifica todos anexos da mensagem e os salva
   				For j := 1 to oMessage:getAttachCount()
 					aAttInfo:= oMessage:getAttachInfo(j)   
 					
 					#IFDEFTOP 
 					 
	 					//Verificar se arquivo ja foi baixado 
	 					_cAlias := GetNextAlias() 
	 					_cSeqXML:= "%'%" + Alltrim(aAttInfo[j]) + "%'%"
	        
	        			BEGINSQL ALIAS _cAlias  
	        			%noParser%
	                  	
		                 	SELECT
		                   			COUNT(1) QTDXML
		                	FROM
		                     		%table:UZQ% UZQ
		                 	WHERE
		                    		UZQ.%notDel%     
		                    		AND UZQ_LOCARQ LIKE %exp:_cSeqXML%  
	             		ENDSQL
	    
	    			   
	             		//cLastQuery    := aLastQuery[2] 
	             		(_cAlias)->( DbGotop() ) 
	             		
	             		_lEncXML := (_cAlias)->(QTDXML) > 0
	             	
        				(_cAlias)->( dbCloseArea() )
        				
        			#ELSE
	           
	       				DbSelectArea("UZQ")
     	   				DbSetOrder(4)
       	   				_lEncXML :=  DbSeek( xFilial("UZQ") + Padr(Upper(aArqs[nArqs, 1]), TamSX3("UZQ_LOCARQ")[01]  ) ) 
       		
	    			#ENDIF  
						
					// Se for anexo XML e n�o importado
					If (".XML" $ Upper(aAttInfo[j])).AND. !_lEncXML 
					
	 					nXML := FCreate(cDirXMLNFE+aAttInfo[j])
	 					FWrite(nXML,oMessage:getAttach(j) )
	 					FClose(nXML)    
	 					
	 				ElseIf _lEncXML    
	 				
	 					//��������������������������������������������������������������������������Ŀ
						//� Envia email de aviso sobre o erro                                        �
			   			//����������������������������������������������������������������������������
						cAssunto	:= "Advert�ncia - Rotina de Importa��o de Nota Fiscal formato XML" 
						
						cMensagem	:= "O arquivo XML: " + Alltrim(aAttInfo[j]) + " em anexo, "  + CRLF 
						cMensagem	+= " j� encontra-se importado e ser� apagado. " + CRLF 
						cMensagem	+= "Caso necessite de uma nova importa��o, " + CRLF  
			   			cMensagem	+= "apague a Nf/e gerada e sua refer�ncia na Importa��o do xml "  + CRLF   
			   			cMensagem	+= "e importe o mesmo novamente ! "  + CRLF  
			   			
						u__XmlEnvM(  cAssunto, cMensagem, {}, _lProcSch  )
				
						//��������������������������������������������������������������������������Ŀ
						//� Envia mensagem de erro para o console do server Protheus                 �
						//����������������������������������������������������������������������������
						ConOut( "" )	
						ConOut( cAssunto )
						ConOut( cMensagem )
						ConOut( "" )	
	 					
	 				EndIf
	 				
 				Next 
 				
 			EndIf  
 			
 			// Apagado e-mail, notar para contas do Google, colocar regra no pr�prio e-mail devido a falha ao apagar
 			oMailServer:DeleteMsg(i)
 			
		Next 
		
 	EndIf   
 	           
	//Fecha conexao com servidor
	oMailServer:PopDisconnect()

EndIf  

Return(Nil)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RJOB999B �Autor  �Bruno Daniel Borges � Data �  17/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao que retorna os arquivos disponiveis para importacao  ���
���          �contendo NFs (XMLs)                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RJOB999B()
Local aRetorno := {}
Local aFiles   := {}
Local cDirXML  := Alltrim( SuperGetMV( "MV_XDIRXML", .F., "\XMLS_NFE\" ) ) 
Local i

aFiles := Directory(cDirXML+"*.XML")
For i := 1 To Len(aFiles)
	AAdd(aRetorno,	cDirXML+aFiles[i,1])
Next i

Return(aRetorno)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RJOB999C �Autor  �Bruno Daniel Borges � Data �  17/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao que muda a extensao dos arquivos para JA IMPORTADOS  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RJOB999C(aArquivos)
Local i

For i := 1 To Len(aArquivos)
	If File(aArquivos[i])
		FRename(aArquivos[i],SubStr(Upper(aArquivos[i]),1,At(".XML",Upper(cArqImp))-1) +".IMP")
	EndIf
Next i

Return(Nil)