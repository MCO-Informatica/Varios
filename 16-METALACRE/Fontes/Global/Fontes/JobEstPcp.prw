#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include 'Ap5Mail.ch'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � JobEstPcp � Autor � Luiz Alberto       � Data �  Out/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Processamento em Job de Saldo Atual e Refaz Acumulados   ��
�������������������������������������������������������������������������͹��
���Uso       � Metalacre                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function JobEstPcp()
RPCSetType(3)
RPCSETENV("01", "01", "lalberto", "051102", "SIGAEST", "WF",{})
Sleep( 5000 )     // aguarda 5 segundo para que as jobs IPC subam.
SetHideInd(.T.) // evita problemas com indices temporarios
//ConOut("Executada Mata 300 - Saldo Atual!")
//Mata300()// Saldo Atual 
//ConOut("Executada Mata330 - Custo M�dio !")
//Mata330() // Custo M�dio
ConOut("Executada Mata215 - Refaz Acumulados! - " + Time()) 
cTxt := 'Inicio Processamento Refaz Acumulados: ' + DtoC(Date()) + ' as ' + Time()
Mata215(.T.) // Refaz Acumulados // Demora muito // Ligar Microsiga               
cTxt += Chr(13)+'Termino Processamento Refaz Acumulados: ' + DtoC(Date()) + ' as ' + Time()
ConOut("Finalizada Mata215 - Refaz Acumulados! - " + Time())
//ConOut("Executada Mata216 - Poder de 3�!")
//Mata216() // Poder de 3�
//ConOut("Executada Mata280 - Virada de Saldos !")
//MATA280() // Virada de Saldos                             

EnvMail(cTxt)

RpcClearEnv()
Return .t.



				
Static Function EnvMail(cCorpo)
Local cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))
Local cFrom		:= RTrim(SuperGetMV("MV_RELFROM"))
Local cPara		:= 'mariana@metalacre.com.br' 
Local cAssunto	:= "Processamentos Automaticos"
Local cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
Local cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))
Local aAnexos		:= {}
Local cEmailTo := cPara						// E-mail de destino
Local cEmailBcc:= ""							// E-mail de copia
Local lResult  := .F.							// Se a conexao com o SMPT esta ok
Local cError   := ""							// String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso 
Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso
	
	_cAnexo	:= ''


	//�����������������������������������������������������������������������������Ŀ
	//�Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense�
	//�que somente ela recebeu aquele email, tornando o email mais personalizado.   �
	//�������������������������������������������������������������������������������
	
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult
	
	// Se a conexao com o SMPT esta ok
	If lResult
	
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaTK)	
		Else
			lRet := .T.	
	    Endif    
		
		If lRet
			SEND MAIL FROM cFrom ;
			TO      	cEmailTo;
			SUBJECT 	cAssunto;
			BODY    	cCorpo;
			RESULT lResult
	
			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
					Help(" ",1,'Erro no Envio do Email',,cError+ " " + cEmailTo,4,5)	//Aten��o
			Else
				FErase(_cAnexo)
			Endif
	
		Else
			GET MAIL ERROR cError
			Help(" ",1,'Autentica��o',,cError,4,5)  //"Autenticacao"
			MsgStop('Erro de Autentica��o','Verifique a conta e a senha para envio') 		 //"Erro de autentica��o","Verifique a conta e a senha para envio"
		Endif
			
		DISCONNECT SMTP SERVER
		
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
	Endif
Return .t.

