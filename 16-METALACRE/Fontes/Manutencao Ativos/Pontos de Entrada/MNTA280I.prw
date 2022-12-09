#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"
#INCLUDE "AP5MAIL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MNTA280I º Autor ³ Luiz Alberto     º Data ³ 24/04/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ WorkFlow de Solicitações Manutencao de Ativos
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   

User Function MNTA280I() 
Local aArea		:= GetArea()

If Type("M->TQB_SOLICI")=="U"
	Return .T.
Endif

cSolicit 	:= 	Iif(Type("M->TQB_SOLICI")=="U",TQB->TQB_SOLICI,M->TQB_SOLICI)
dSolidAb	:=	Iif(Type("M->TQB_SOLICI")=="U",TQB->TQB_DTABER,M->TQB_DTABER)
cSoliHor	:=	Iif(Type("M->TQB_SOLICI")=="U",TQB->TQB_HOABER,M->TQB_HOABER)
cServiPri	:=	Iif(Type("M->TQB_SOLICI")=="U",TQB->TQB_CDSERV,M->TQB_CDSERV)
cBemPri		:=	Iif(Type("M->TQB_SOLICI")=="U",TQB->TQB_CODBEM,M->TQB_CODBEM)
cObsTqb		:=	Iif(Type("M->TQB_SOLICI")=="U",TQB->TQB_DESCSS,M->TQB_DESCSS)
cCdSolici	:=	Iif(Type("M->TQB_SOLICI")=="U",TQB->TQB_CDSOLI,M->TQB_CDSOLI)

If (INCLUI .Or. ALTERA) //.And. Empty(M->TQB_CDEXEC) //nOpt == 1 .Or. nOpt == 2	// Inclusão e Alteração de SC´s

  	// Inicia Envio de Email do WorkFlow


  	cCabecalho := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
  	cCabecalho += '<html> '
  	cCabecalho += '<head> '
  	cCabecalho += '  <meta content="text/html; charset=ISO-8859-1" '
  	cCabecalho += ' http-equiv="content-type"> '
  	cCabecalho += '  <title>WorkFlow Metalacre</title> '
  	cCabecalho += '</head> '
  	cCabecalho += '<body> '
  	cCabecalho += '<p><strong><span style="font-family: Arial;">Solicita&ccedil;&atilde;o de Servi&ccedil;o a ser atendida - SS ' + cSolicit + '</span></strong></p>'
  	cCabecalho += '<div align="left">'
  	cCabecalho += '<table border="0" width="100%" cellpadding="2">'
  	cCabecalho += '<tbody>'
  	cCabecalho += '<tr>'
  	cCabecalho += '<td align="left" bgcolor="#C0C0C0" width="10%"><strong><span style="font-family: Arial; font-size: small;">Solicita&ccedil;&atilde;o</span></strong></td>'
  	cCabecalho += '<td align="left" bgcolor="#C0C0C0" width="10%"><strong><span style="font-family: Arial; font-size: small;">Id Solicitante</span></strong></td>'
  	cCabecalho += '<td align="left" bgcolor="#C0C0C0" width="30%"><strong><span style="font-family: Arial; font-size: small;">Nome Solic.</span></strong></td>'
  	cCabecalho += '<td align="left" bgcolor="#C0C0C0" width="15%"><strong><span style="font-family: Arial; font-size: small;">Data Abertura</span></strong></td>'
  	cCabecalho += '<td align="left" bgcolor="#C0C0C0" width="15%"><strong><span style="font-family: Arial; font-size: small;">Hora Abertura</span></strong></td>'
  	cCabecalho += '<td align="left" bgcolor="#C0C0C0" width="20%"><strong><span style="font-family: Arial; font-size: small;">Tipo Servi&ccedil;o</span></strong></td>'
  	cCabecalho += '</tr>'
  	cCabecalho += '<tr>'
  	cCabecalho += '<td align="left" bgcolor="#EEEEEE" width="10%"><span style="font-family: Arial; font-size: xx-small;">' + cSolicit + '</span></td>'
  	cCabecalho += '<td align="left" bgcolor="#EEEEEE" width="10%"><span style="font-family: Arial; font-size: xx-small;">' + cCdSolici + ' </span></td>'
    
	cCabecalho += '<td align="left" bgcolor="#EEEEEE" width="30%"><span style="font-family: Arial; font-size: xx-small;">' + UsrFullName(cCdSolici) + '</span></td>'
  	
  	cCabecalho += '<td align="left" bgcolor="#EEEEEE" width="15%"><span style="font-family: Arial; font-size: xx-small;">' + DtoC(dSolidAb) + '</span></td>'
  	cCabecalho += '<td align="left" bgcolor="#EEEEEE" width="15%"><span style="font-family: Arial; font-size: xx-small;">' + cSoliHor + '</span></td>'
  	cCabecalho += '<td align="left" bgcolor="#EEEEEE" width="20%"><span style="font-family: Arial; font-size: xx-small;">' + Posicione("TQ3",1,xFilial("TQ3")+cServiPri,"TQ3_NMSERV") + '</span></td>'
  	cCabecalho += '</tr>'
  	cCabecalho += '<tr>'
  	cCabecalho += '<td colspan="7" align="left" bgcolor="#C0C0C0" width="100%"><strong><span style="font-family: Arial; font-size: small;">Bem/Localiza&ccedil;&atilde;o</span></strong></td>'
  	cCabecalho += '</tr>'
  	cCabecalho += '<tr>'
  	cCabecalho += '<td colspan="7" align="left" bgcolor="#EEEEEE" width="100%"><span style="font-family: Arial; font-size: xx-small;">' + cBemPri + ' ' + Posicione("ST9",1,xFilial("ST9")+cBemPri,"T9_NOME") + '</span></td>'
  	cCabecalho += '</tr>'
  	cCabecalho += '<tr>'
  	cCabecalho += '<td colspan="7" align="left" bgcolor="#C0C0C0" width="100%"><strong><span style="font-family: Arial; font-size: small;">Servi&ccedil;o</span></strong></td>'
  	cCabecalho += '</tr>'
  	cCabecalho += '<tr>'
  	cCabecalho += '<td colspan="7" align="left" bgcolor="#EEEEEE" width="100%"><span style="font-family: Arial; font-size: xx-small;">' + cObsTqb + ' </span></td>'
  	cCabecalho += '</tr>'
  	cCabecalho += '</tbody>'
  	cCabecalho += '</table>'
  	cCabecalho += '</div>'
  	cCabecalho += '</table> '
  	cCabecalho += '<br style="font-family: Helvetica,Arial,sans-serif;"> '
  	cCabecalho += '</body> '
  	cCabecalho += '</html> '


	cNomRespo := UsrFullName(__cUserID)
	cEmaRespo := GetNewPar("MV_EMAMAN",'oficina.manutencao@metalacre.com.br;marcos.antonio@metalacre.com.br')
	
	xCabecalho	:= cCabecalho

	EnvWrk(cNomRespo,cEmaRespo,'Solicitação de Servicos No. ' + cSolicit ,xCabecalho)
Endif
RestArea(aArea)
Return .t.

// Envio de Email do WorkFlow Atendimentos

Static Function EnvWrk(cNomRespo,cEmaRespo,cAssunto,mCorpo)
Local cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))
Local cFrom		:= RTrim(SuperGetMV("MV_RELFROM"))
Local cPara		:= cEmaRespo
Local cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
Local cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))
Local lResult  := .F.							// Se a conexao com o SMPT esta ok
Local cError   := ""							// String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso 
Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
	//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	For nTenta := 1 To 5
	
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
				TO      	cPara;
				SUBJECT 	cAssunto;
				BODY    	mCorpo;
				RESULT lResult
		
				If !lResult
					//Erro no envio do email
					GET MAIL ERROR cError
						Help(" ",1,'Erro no Envio do Email',,cError+ " " + cPara,4,5)	//Atenção
					Loop
				Endif
		 		nTenta := 10	// Em Caso de Sucesso sai do Loop
		 		Loop
			Else
				GET MAIL ERROR cError
				Help(" ",1,'Autenticação',,cError,4,5)  //"Autenticacao"
				MsgStop('Erro de Autenticação','Verifique a conta e a senha para envio') 		 //"Erro de autenticação","Verifique a conta e a senha para envio"
			Endif
				
			DISCONNECT SMTP SERVER
			
		Else
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
		Endif
	Next
Return .t.

