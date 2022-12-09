#include 'Ap5Mail.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FGEN010   �Autor  �Alexandre Martins   � Data �  03/28/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para envio de e-mail.                               ���
�������������������������������������������������������������������������͹��
���Par�metros� ExpC1: e-mail do destinat�rio                              ���
���          � ExpC2: assunto do e-mail                                   ���
���          � ExpC3: texto do e-mail                                     ���
���          � ExpC4: anexos do e-mail                                    ���
���          � ExpL1: exibe mensagem de envio                             ���
�������������������������������������������������������������������������͹��
��� Retorno  � ExpL2: .T. - envio realizado                               ���
���          �        .F. - n�o enviado                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo OmniLink                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FGEN010(c_MailDestino,c_Assunto,c_Texto,c_Anexos,l_Mensagem)

	Local 	l_Ret				:= .T.
	Local 	c_Cadastro		:= "Envio de e-mail"
	Private	c_MailServer	:= AllTrim(GetMv("MV_RELSERV"))
	Private	c_MailConta 	:= AllTrim(GetMv("MV_RELAUSR"))
	Private 	l_Auth		:= GetMv("MV_RELAUTH")
	Private  c_MailAuth		:= AllTrim(GetMv("MV_RELACNT"))

	Private	c_MailSenha		:= AllTrim(GetMv("MV_RELPSW"))
	Private  c_SenhaAuth	:= AllTrim(GetMv("MV_RELAPSW"))
	Private	c_MailDestino	:= If( ValType(c_MailDestino) != "U" , c_MailDestino,  "" )
	Private	l_Mensagem		:= If( ValType(l_Mensagem)    != "U" , l_Mensagem,  .T. )

	//�����������������Ŀ
	//�Efetua validacoes�
	//�������������������

	If Empty(c_MailDestino)
		If l_Mensagem
			Aviso(	c_Cadastro, "Conta(s) de e-mail de destino(s) n�o informada. ";
					+"Envio n�o realizado.",{"&Ok"},,"Falta informa��o" )     
					Conout('Envio nao realizado email destino nao informado 46 ')
		EndIf
		c_msgerro := "Conta(s) de e-mail de destino(s) n�o informada. Envio n�o realizado."
		l_Ret	:= .F.         
			Conout('Envio nao realizado email destino nao informado 50 ')
	EndIf

	If Empty(c_Assunto)
		If l_Mensagem
			Aviso(	c_Cadastro,"Assunto do e-mail n�o informado. ";
					+"Envio n�o realizado.",{"&Ok"},,"Falta informa��o" )     
						Conout('Envio nao realizado ASSUNTO DO EMAIL nao informado  57')
		EndIf
		c_msgerro := "Assunto do e-mail n�o informado. Envio n�o realizado."
		l_Ret	:= .F.   
		Conout('Envio nao realizado ASSUNTO DO EMAIL nao informado  60')
	EndIf

	If Empty(c_Texto)
		If l_Mensagem
			Aviso(	c_Cadastro,"Texto do e-mail n�o informado. ";
					+"Envio n�o realizado.",{"&Ok"},, "Falta informa��o" ) 
					Conout('Envio nao realizado TEXTO DO EMAIL nao informado 68 ')
		EndIf
		c_msgerro := "Texto do e-mail n�o informado. Envio n�o realizado."
		l_Ret	:= .F.    
		Conout('Envio nao realizado TEXTO DO EMAIL nao informado 72 ')
	EndIf

	If l_Ret
		If l_Mensagem
			Processa({|| l_Ret := SendMail(c_MailDestino,c_Assunto,c_Texto,c_Anexos,l_Mensagem), "Enviando e-mail"})   
			Conout('EnvIANDO EMAIL 78 ')
		Else
			l_Ret := SendMail(c_MailDestino,c_Assunto,c_Texto,c_Anexos,l_Mensagem)   
			Conout('Envio FUNCAO SEND EMAIL 81')
		EndIf
	EndIf

Return(l_Ret)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SendMail  �Autor  �Alexandre Martins   � Data �  03/28/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de envio de e-mail.                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo Scelisul.                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SendMail(c_MailDestino,c_Assunt,c_Text,c_Anexo,l_Mensagem)

	Local l_Conexao		:= .F.
	Local l_Envio			:= .F.
	Local l_Desconexao	:= .F.
	Local l_Ret				:= .T.
	Local c_Assunto		:= If( ValType(c_Assunt) != "U" , c_Assunt , "" )
	Local c_Texto			:= If( ValType(c_Text)   != "U" , c_Text   , "" )
	Local c_Anexos			:= If( ValType(c_Anexo)  != "U" , c_Anexo  , "" )
	Local c_Erro_Conexao	:= ""
	Local c_Erro_Envio		:= ""
	Local c_Erro_Desconexao	:= ""
	Local c_Cadastro			:= "Envio de e-mail"

	If l_Mensagem
		IncProc("Conectando-se ao servidor de e-mail...")       
		Conout('Conectando-se ao servidor de e-mail... 115')
	EndIf

	//������������������������������������������������������Ŀ
	//� Executa conexao ao servidor mencionado no parametro. �
	//��������������������������������������������������������
		Conout('Executa conexao ao servidor mencionado no parametro 120')
	Connect Smtp Server c_MailServer ACCOUNT c_MailConta PASSWORD c_MailSenha RESULT l_Conexao
 //	Conout('ERRO NA CONEXAO '+c_MailServer +c_MailConta+c_MailSenha+l_Conexao+'LINHA 123')
	If !l_Conexao
		GET MAIL ERROR c_Erro_Conexao
		If l_Mensagem
	 		Aviso(	c_Cadastro, "Nao foi poss�vel estabelecer conex�o com o servidor - ";
	 				+c_Erro_Conexao,{"&Ok"},,"Sem Conex�o" )    
	 				Conout('NAO FOI POSSIVEL CONEXAO COM SERVIDOR 128'+c_Erro_Conexao)
		EndIf
		c_msgerro := "Nao foi poss�vel estabelecer conex�o com o servidor - "+c_Erro_Conexao
		l_Ret := .F.   
			Conout('NAO FOI POSSIVEL CONEXAO COM SERVIDOR 131 '+c_Erro_Conexao)
	EndIf

	//�����������������������������������Ŀ
	//�Verifica se deve fazer autenticacao�
	//�������������������������������������
	If l_Auth
		If !MailAuth(c_MailAuth, c_SenhaAuth)
			GET MAIL ERROR c_Erro_Conexao
			If l_Mensagem
		 		Aviso(	c_Cadastro, "Nao foi poss�vel autenticar a conex�o com o servidor - ";
		 				+c_Erro_Conexao,{"&Ok"},,"Sem Conex�o" )       
		 					Conout('NAO FOI POSSIVEL CONEXAO COM SERVIDOR 2 MAIL AUTH  144'+c_Erro_Conexao)
			EndIf
			c_msgerro := "Nao foi poss�vel autenticar a conex�o com o servidor - "+c_Erro_Conexao
			l_Ret := .F.                                                                            
				Conout('NAO FOI POSSIVEL CONEXAO COM SERVIDOR 2 MAIL AUTH 148'+c_Erro_Conexao)
		EndIf
	EndIf

	If l_Mensagem
		IncProc("Enviando e-mail...")  
			Conout('ENVIANDO EMAIL 153')
	EndIf                     
	
   cEmailNR := SuperGetMv("MV_EMAILNR",.F.,"naoresponder@workflow.com.br")   

	//����������������������������Ŀ
	//� Executa envio da mensagem. �
	//������������������������������
	If !Empty(c_Anexos)
		Send Mail From c_MAILCONTA to c_MailDestino SubJect c_Assunto BODY c_Texto FORMAT TEXT ATTACHMENT c_Anexos RESULT l_Envio
		//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 09/11/2012]          
		//conforme definido pelo Fabio
		//Send Mail From cEmailNR to c_MailDestino SubJect c_Assunto BODY c_Texto FORMAT TEXT ATTACHMENT c_Anexos RESULT l_Envio
	Else                                                                                                 
	   Send Mail From c_MAILCONTA to c_MailDestino SubJect c_Assunto BODY c_Texto FORMAT TEXT RESULT l_Envio
	   //substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 09/11/2012]
	   //conforme definido pelo Fabio
	   //Send Mail From cEmailNR to c_MailDestino SubJect c_Assunto BODY c_Texto FORMAT TEXT RESULT l_Envio
	EndIf

	If !l_Envio
		Get Mail Error c_Erro_Envio
		If l_Mensagem
			Aviso(	c_Cadastro,"N�o foi poss�vel enviar a mensagem - ";
					+c_Erro_Envio,{"&Ok"},,	"Falha de envio" )       
						Conout('NAO FOI POSSIVEL ENVIAR MSG 178 '+c_Erro_Envio)
		EndIf
		c_msgerro := "N�o foi poss�vel enviar a mensagem - "+c_Erro_Envio
		l_Ret := .F.    
			Conout('NAO FOI POSSIVEL ENVIAR MSG  182'+c_Erro_Envio)
	EndIf

	If l_Mensagem
	   IncProc("Desconectando-se do servidor de e-mail...")     
	   	Conout('DESCONECTANDO  SERVIDOR DE EMAIL  188')
	EndIf

	//��������������������������������������Ŀ
	//� Executa disconexao ao servidor SMTP. �
	//����������������������������������������
	DisConnect Smtp Server Result l_Desconexao

	If !l_Desconexao
		Get Mail Error c_Erro_Desconexao
		If l_Mensagem
			Aviso(	c_Cadastro,"N�o foi poss�vel desconectar-se do servidor - ";
					+c_Erro_Desconexao,{"&Ok"},,"Descone��o" )    
						Conout('NAO FOI POSSIVEL DESCONETAR COM SERVIDOR  201'+c_Erro_Desconexao)
		EndIf
		c_msgerro := "N�o foi poss�vel desconectar-se do servidor - "+c_Erro_Desconexao
		l_Ret := .F.      
			Conout('NAO FOI POSSIVEL CONEXAO COM SERVIDOR 205 '+c_Erro_Desconexao)
	EndIf

Return(l_Ret)
