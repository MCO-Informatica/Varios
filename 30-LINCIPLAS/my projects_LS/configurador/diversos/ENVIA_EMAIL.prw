#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'AP5MAIL.CH'
#INCLUDE 'TBICONN.CH'
#DEFINE  ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ENVIA_EMAIL º Autor | A.C Silva          º Data ³23/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Programa para verificar se e-mail eh valido 				          º±±
±±º caso e-mail nao seja valido, programa envia email 1 a 1.              º±±  
±±º                                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*******************************************************************************************************
User Function ENVIA_EMAIL(_cRotina, _cAssunto, _cPara, _cCopia, _cCopOcult, _cCorpoEmail, _cAtachado, _cRemetente)
*******************************************************************************************************
Private _lEnviou	:=	.F.

Private cNaoRecebeu	:=	''
Private cError    	:= ''
Private cTRecebe	:=	''
Private cTCopia		:=	''
Private cTCopOculta	:=	''

Private	aRecebe		:=	{}
Private	aCopia		:=	{}
Private	aCopOculta	:=	{}
Private	aTodosEmail	:=	{}
                     

Private cServer   	:= '' 		//AllTrim(GetMv("MV_RELSERV")) 
Private cAccount  	:= ''	 	//AllTrim(GetMV("MV_RELACNT")) 
Private cPassword 	:= ''		//AllTrim(GetMv("MV_RELPSW") ) 

Private cNomeRotina	:=	_cRotina
Private cRemetente	:= ''
Private cAssunto	:=	AllTrim(_cAssunto)
Private cRecebe		:=	AllTrim(_cPara)
Private cCopia		:=	AllTrim(_cCopia)
Private cCopOcult	:=	AllTrim(_cCopOcult)   
Private cCorpoEmail	:=	_cCorpoEmail
Private cAnexo		:=	_cAtachado

Private _StartPath	:=	AllTrim(GetSrvProfString("StartPath",""))
Private cArqConfig	:=	'ZXM_CFG.DBF'
Private cDominio   :=  ''
Private cEmailProb	:= 	''
Private	oServer		:= Nil
Private	nConfig		:= Nil
Private	nConectou 	:= Nil

_StartPath	+=	IIF(Right(_StartPath,1)=='\','','\')

Conout(  "Envia_Email - Iniciando WorkFlow...- Data: "+DtoC(Date())+" - Hora: "+Time() )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE EXISTE ARQUIVO DE CONFIGURACAO	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File(_StartPath+cArqConfig)
   Conout( "Envia_Email - Arquivo de configuracao nao encontradao. ZXM_CFG.DBF" )
   Return
EndIf

If Select('TMPCFG') == 0
   DbUseArea(.T.,,_StartPath+cArqConfig, 'TMPCFG',.T.,.F.)
   DbSetIndex(_StartPath+'TMPCFG.CDX')
EndIf

DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
DbSeek(cEmpAnt+cFilAnt, .F.)

cServer   	:= 	AllTrim(TMPCFG->SERVERENV)
cAccount  	:= 	AllTrim(TMPCFG->EMAIL)
cPassword 	:= 	AllTrim(TMPCFG->SENHA)
cRemetente	:= 	AllTrim(TMPCFG->NOME_EMP)
cDominio	:=	AllTrim(TMPCFG->DOMINIO)
nPortEnv	:=	Val(TMPCFG->PORTA_ENV)
nPortRec	:=	Val(TMPCFG->PORTA_REC)
cEmailProb	:=	AllTrim(TMPCFG->PROB_EMAIL)


Conout( ENTER+ENTER+'INICIO DA ROTINA: ' + cNomeRotina +' -  DATA: '+DtoC(Date())+" - Hora: "+Time() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³		RECEBE EMAIL          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
cRecebe	+=	IIF(Len(cRecebe)>1, IIF(Right(AllTrim(cRecebe),1)!=';',';',''), '')
Do While !Empty(cRecebe)   
	nPontoVirg 	:= At(";", cRecebe )-1
		
	If 	nPontoVirg <= 0
		Exit
	Endif

	Aadd(aTodosEmail, 	Left(cRecebe, nPontoVirg)+ 	IIF( '@' $ Left(cRecebe, nPontoVirg),		'', '@'+cDominio+';') )
	cTRecebe	+=	AllTrim(Left(cRecebe, nPontoVirg)+ 	IIF( '@' $ Left(cRecebe, nPontoVirg),	'',	'@'+cDominio+';') )
	cRecebe		:=	AllTrim(Right(cRecebe, ( Len(cRecebe)-nPontoVirg-1) )  )
EndDo
                          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³		COPIA  EMAIL          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
cCopia	+=	IIF(Len(cCopia)>1, IIF(Right(AllTrim(cCopia),1)!=';',';',''), '')
Do While !Empty(cCopia)   
	nPontoVirg 	:= At(";", cCopia )-1
	If nPontoVirg <= 0
		Exit
	Endif
	
	Aadd(aTodosEmail, 	Left(cCopia, nPontoVirg)+ IIF(  '@' $ Left(cCopia, nPontoVirg),	'',	'@'+cDominio+';') )
	cTCopia		+=	AllTrim(Left(cCopia, nPontoVirg)+ IIF(  '@' $ Left(cCopia, nPontoVirg),'',	'@'+cDominio+';') )
	cCopia		:=	AllTrim(Right(cCopia, ( Len(cCopia)-nPontoVirg-1) ))
EndDo
              

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³		COPIA OCULTA          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                  
cCopOcult	+=	IIF(Len(cCopOcult)>1, IIF(Right(AllTrim(cCopOcult),1)!=';',';',''), '')
Do While !Empty(cCopOcult)   
	nPontoVirg 	:= At(";", cCopOcult )-1
	If nPontoVirg <= 0
		Exit
	Endif
	
	Aadd(aTodosEmail, 	Left(cCopOcult, nPontoVirg)+ IIF(  '@' $ Left(cCopOcult, nPontoVirg),			'',	'@'+cDominio+';') )
	cTCopOculta		+=	AllTrim(Left(cCopOcult, nPontoVirg)+ IIF(  '@' $ Left(cCopOcult, nPontoVirg),	'',	'@'+cDominio+';') )
	cCopOcult		:=	AllTrim(Right(cCopia, ( Len(cCopOcult)-nPontoVirg-1) ) )
EndDo

lRet := ENVIA_TODOS()

If !lRet
	lRet := ENVIA_1_A_1()
EndIf            

               
/*
cServer   	:= GETMV("MV_RELSERV")
cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
cEnvia    	:= 'adalpiaz@laselva.com.br'
//cRecebe		:= 'fabianocpereira@gmail.com'      
*/
/*
cenvia := 'adalpiaz@laselva.com.br'
cAssunto 	:= 'Assunto - Teste'
_cHtml		:= 'TEste - teste - teste'
crecebe := 'fpereira@cope.ind.br;fabianocpereira@gmail.com;adalpiaz@laselva.com.br'

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou
		
	SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY _cHtml RESULT lEnviado
	
	If !lEnviado
		cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
		GET MAIL ERROR cHtml
		ALERT( "ERRO SMTP EM: " + cAssunto )
	Else
		DISCONNECT SMTP SERVER
		ALERT( 'ENVIUUU  '+cAssunto )
	Endif
	
Else
	
	ALERT( "ERRO SMTP EM: " + cAssunto )
	cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
	MsgAlert(cHtml)
Endif                                

alert('fim')
*/
Conout( 'FIM DA ROTINA: ' + cNomeRotina +' -  DATA: '+DtoC(Date())+" - Hora: "+Time() +ENTER+ENTER)

Return(.t.)
*********************************************************************************
Static Function ENVIA_TODOS()
*********************************************************************************
Local lRetorno	:=	.F.
Local	nErro

Conout('ENVIANDO PARA TODOS...') 	
		
******************************
	Conecta_Server()
******************************
		
If nConectou == 0

	oMessage :=	TMailMessage():New()

	//Limpa o objeto
	oMessage:Clear()
                                  
	//Popula com os dados de envio
	oMessage:cFrom		:= Lower(cRemetente)
	oMessage:cTo 		:= Lower(cTRecebe)
	oMessage:cCc 		:= Lower(cTCopia)
	oMessage:cBcc 		:= Lower(cTCopOculta)
	oMessage:cSubject 	:= cAssunto
	oMessage:cBody 		:= cCorpoEmail
	oMessage:AttachFile( cAnexo )

	//oMessage:SetConfirmRead( .T. )
   // Adiciona um anexo, nesse caso a imagem esta no root

      
   // Essa tag, é a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
   //oMessage:AddAttHTag( 'Content-ID: <ID_imagem.jpg>' )

 	nErro := oMessage:Send( oServer )
		                                                  
   If nErro != 0 
   	Conout( "Não enviou o e-mail. TODOS - ", oServer:GetErrorString( nErro ) )
	EndIf

	//Desconecta do servidor
	If oServer:SmtpDisconnect() != 0
		Conout( "Erro ao disconectar do servidor SMTP" )
	EndIf

Else
	Conout('NAO CONECTOU NO SERVIDOR DE E-MAIL....  -  ENVIA_TODOS....' + oServer:GetErrorString(nConecTou) ) 	  
	ALERT('NAO CONECTOU NO SERVIDOR DE E-MAIL....  -  ENVIA_TODOS....' + oServer:GetErrorString(nConecTou) ) 	  
Endif


If nConectou == 0 .And. nErro == 0
	Conout('ENVIADO COM SUCESSO PARA: ' + cTRecebe )
	IIF(Len(aCopia)>0, Conout('COPIA PARA: '+ cTCopia ), )  
	IIF(Len(aCopOculta)>0 , Conout('COPIA OCULATA PARA: '+ cTCopOculta ), )  
	lRetorno	:=	.T.
Endif

Return(lRetorno)
*********************************************************************************
Static Function ENVIA_1_A_1()
*********************************************************************************
Local lRetorno		:=	.F.
Local cNaoRecebeu	:=	''
Local nCount		:=	0
Local nErro			:=	0

Conout('ENVIANDO 1 - 1') 

******************************
	Conecta_Server()
******************************

For Y:=1 To Len(aTodosEmail)

	If nConectou == 0
		
		oMessage :=	TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom		:= Lower(cRemetente)
		oMessage:cTo 		:= Lower(aTodosEmail[Y])
		oMessage:cCc 		:= Lower(cTCopia)
		oMessage:cBcc 		:= Lower(cTCopOculta)
		oMessage:cSubject 	:= cAssunto
		oMessage:cBody 		:= cCorpoEmail
		oMessage:AttachFile( cAnexo )
	 
	 	nErro := oMessage:Send( oServer )
			
	   If nErro != 0 
   	   Conout( "Não enviou o e-mail. 1-1 - ", oServer:GetErrorString( nErro ) )
   	   ALERT( "Não enviou o e-mail. 1-1 - ", oServer:GetErrorString( nErro ) )
   	   
			cNaoRecebeu+= aTodosEmail[Y]+ENTER
		EndIf

	Endif
	
Next

//Desconecta do servidor
If oServer:SmtpDisconnect() != 0
	Conout( "Erro ao disconectar do servidor SMTP" )
EndIf	

If nConectou != 0 .Or. nErro != 0
	cNaoRecebeu	+= IIF(nConectou!=0,'NAO CONECTOU NO SERVIDOR DE E-MAIL   ', 'PROBLEMA NO E-MAIL   ' ) + cNaoRecebeu+ENTER
	nCount++
Endif

		
If !Empty(cNaoRecebeu)                                  

	cDataHora		:= AllTrim(Str(Year(dDataBase))) 	+'_'+ Time()
	cTexto		:=	'ERRO NO ENVIO DE EMAIL'+ENTER+'PROGRAMA: '+cNomeRotina +ENTER+ENTER+'PROBLEMA NOS SEGUINTES E-MAIL:'+ENTER+ cNaoRecebeu                                                                       
	
	******************************
		Conecta_Server()
	******************************
	
	If nConectou == 0

		oMessage :=	TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom		:= Lower(cRemetente)
		oMessage:cTo 		:= Lower(AllTrim(cEmailProb))
		oMessage:cCc 		:= Lower(cTCopia)
		oMessage:cBcc 		:= Lower(cTCopOculta)
		oMessage:cSubject 	:= cAssunto+' ERRO...'
		oMessage:cBody 		:= cTexto
 
	 	nErro := oMessage:Send( oServer )
			
	   If( nErro != 0 )
   	   Conout( "Não enviou o e-mail. ADMIN - ", oServer:GetErrorString( nErro ) )
  	   ALERT( "Não enviou o e-mail. ADMIN - ", oServer:GetErrorString( nErro ) )
		EndIf

		//Desconecta do servidor
		If oServer:SmtpDisconnect() != 0
			Conout( "Erro ao disconectar do servidor SMTP" )
		EndIf

	Else
		Conout('NAO CONECTOU NO SERVIDOR DE E-MAIL - ADMINISTRADOR')
	Endif

Endif
		
Return(IIF(nCount==Len(aTodosEmail), .F., .T.) )
*********************************************************************************
Static Function Conecta_Server()
*********************************************************************************

oServer    :=    TMailManager():New()
									//	SERVER RECEBIMENTO,	 SERVER ENVIO	   ,		EMAIL		  ,	    SENHA	  	  , PORTA ENVIO  ,  PORTA RECEBIMENTO
nConfig    :=    oServer:Init( AllTrim(cServer), AllTrim(cServer), AllTrim(cAccount), AllTrim(cPassword), nPortEnv,  )

nTimeConect	:=	 IIF(oServer:GetSMTPTimeOut()!=0, oServer:GetSMTPTimeOut(), 60 )
oServer:SetSMTPTimeout(nTimeConect)  

nConectou 	:= oServer:SMTPConnect()
 //	oServer:SMTPAuth(oServer:GetUser(), AllTrim(cPassword))
 	        
//realiza a conexão SMTP
If nConectou  != 0
	Conout( "Falha ao conectar" +  oServer:GetErrorString(nConectou) )
	ALERT( "Falha ao conectar" +  oServer:GetErrorString(nConectou) )
EndIf


Return(nConectou)