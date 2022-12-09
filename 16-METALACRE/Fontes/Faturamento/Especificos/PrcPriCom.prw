#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"
#INCLUDE "AP5MAIL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PrcPriCom บ Autor ณ Luiz Alberto     บ Data ณ 29/02/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Envia email de Parabeniza็ใo ao Cliente pela Primeira
				Compra
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/   

User Function PrcPriCom(cPedido) 
Local aArea := GetArea()

If cEmpAnt <> '01'
	RestArea(aArea)
	Return .f.
Endif

If SC5->(FieldPos("C5_PEDWEB"))>0 
	If !Empty(SC5->C5_PEDWEB)
		RestArea(aArea)
		Return .f.
	Endif
Endif		

If !SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cPedido))
	RestArea(aArea)
	Return .f.
Endif

If Empty(SC5->C5_NOTA) .Or. SC5->C5_CLIENTE+SC5->C5_LOJACLI $ GetNewPar("MV_MTLCVN",'00132001*01140401')
	RestArea(aArea)
	Return .f.
Endif

If !SF2->(dbSetOrder(1), dbSeek(xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	RestArea(aArea)
	Return .f.
Endif
              
If SF2->F2_TIPO <> 'N'
	RestArea(aArea)
	Return .f.
Endif

If Empty(SF2->F2_DUPL)
	RestArea(aArea)
	Return .f.
Endif

If SA1->A1_PRICOM <> SF2->F2_EMISSAO
	RestArea(aArea)
	Return .f.
Endif

// Primeira COmpra do Cliente

 	cCabecalho := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
 	cCabecalho += '<html> '
 	cCabecalho += '<head> '
 	cCabecalho += '  <meta '
 	cCabecalho += ' content="text/html; charset=ISO-8859-1" '
 	cCabecalho += ' http-equiv="content-type"> '
 	cCabecalho += '  <title>WorkFlow Metalacre</title> '
 	cCabecalho += '</head> '
 	cCabecalho += '<body> '
 	cCabecalho += '<table '
 	cCabecalho += ' style="font-family: Helvetica,Arial,sans-serif; text-align: left; width: 1151px; height: 323px;"   '
 	cCabecalho += ' border="1" cellpadding="2" cellspacing="2">                                                      '
 	cCabecalho += '  <tbody> '
 	cCabecalho += '    <tr style="font-weight: bold;" '
 	cCabecalho += ' align="center">                     '
 	cCabecalho += '      <td '
 	cCabecalho += ' style="background-color: rgb(255, 255, 255);" colspan="4" '
 	cCabecalho += ' rowspan="1"><big><big><img '
 	cCabecalho += ' style="width: 500px; height: 108px;" alt="" '
 	cCabecalho += ' src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br> '
 	cCabecalho += '      </big></big></td> '
 	cCabecalho += '    </tr> '
 	cCabecalho += '    <tr style="font-weight: bold;" '
 	cCabecalho += ' align="center"> '
 	cCabecalho += '      <td '
 	cCabecalho += ' style="background-color: rgb(255, 255, 204);" colspan="4" '
 	cCabecalho += ' rowspan="1"><big><big>Agradecimento</big></big></td> '
 	cCabecalho += '    </tr> ' 
 	cCabecalho += '    <tr style="font-weight: bold;" '
 	cCabecalho += ' align="center"> '
 	cCabecalho += '      <td colspan="4" rowspan="1"> '
 	cCabecalho += '      <p class="MsoNormal" style=""><big><span '
 	cCabecalho += ' style="font-size: 13.5pt; font-family: &quot;Arial&quot;,&quot;sans-serif&quot;; color: black;">Ol&aacute; '
 	cCabecalho += '[A1_CONTATO]<br> '
 	cCabecalho += '      <br> '
 	cCabecalho += 'Gostariamos de agradecer pela confian&ccedil;a em adquirir nossos ' 
 	cCabecalho += 'produtos e servi&ccedil;os.<br> '
 	cCabecalho += '&Eacute; uma grande satisfa&ccedil;&atilde;o ter '
 	cCabecalho += 'voc&ecirc; como '
 	cCabecalho += 'cliente.<br> '
 	cCabecalho += '      <br> '
 	cCabecalho += 'MUITO OBRIGADO !</span></big></p> '
 	cCabecalho += '      <p class="MsoNormal" style=""><span '
 	cCabecalho += ' style="font-size: 13.5pt; font-family: &quot;Arial&quot;,&quot;sans-serif&quot;; color: black;"></span><o:p></o:p></p> '
 	cCabecalho += '      <p class="Standard">Contatos:<br> '
 	cCabecalho += '      <a '
 	cCabecalho += ' href="mailto:vendas@metalacre.com.br"><span '
 	cCabecalho += ' style="color: windowtext; text-decoration: none;">www.metalacre.com.br<br> '
 	cCabecalho += 'vendas@metalacre.com.br</span></a><o:p></o:p></p> '


 	cRodape		:=	'      </td> '
 	cRodape		+=	'    </tr> '
 	cRodape		+=	'    <tr> '
 	cRodape		+=	'      <td '
 	cRodape		+=	' style="background-color: rgb(255, 255, 204);" colspan="4" '
 	cRodape		+=	' rowspan="1"><small><small><span '
 	cRodape		+=	' style="font-weight: bold;">Data Envio:</span> '
 	cRodape		+=	'Hora Envio: Operador:<br> '
 	cRodape		+=	'      </small></small> '
 	cRodape		+=	'      <div style="text-align: center;"><small '
 	cRodape		+=	' style="font-weight: bold;"><small>Envio '
 	cRodape		+=	'de Email Efetuado Autom&aacute;ticamente por nosso sistema Interno, '
 	cRodape		+=	'favor n&atilde;o responder</small></small></div> '
 	cRodape		+=	'      </td> '
 	cRodape		+=	'    </tr> '
 	cRodape		+=	'  </tbody> '
 	cRodape		+=	'</table> '
 	cRodape		+=	'<br        '
 	cRodape		+=	' style="font-family: Helvetica,Arial,sans-serif;"> '
 	cRodape		+=	'</body> '
 	cRodape		+=	'</html> '


	xRodape		:= cRodape                                                                           
	xCabecalho  := cCabecalho
	cNomRespo := UsrFullName(__cUserId)
	cEmaRespo := UsrRetMail(__cUserId)
	
	cNome := ''
	xCabecalho := StrTran(xCabecalho,'[A1_CONTATO]','<span style="font-weight: bold;">'+Iif(!Empty(SA1->A1_CONTATO),Capital(SA1->A1_CONTATO),Capital(SA1->A1_NOME)))+'</span>'

	xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
	xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
	xRodape := StrTran(xRodape,'Operador:','Operador: <span style="font-weight: bold;">'+Capital(cNomRespo))+'</span>'
  			
//	cEmaFina	:=	'lalberto@3lsystems.com.br;adriana.silva@metalacre.com.br' //SuperGetMV('MV_USRFIN', .F., 'martha.kelly@metalacre.com.br;mariana@metalacre.com.br;lalberto@3lsystems.com.br') 
	cEmaRespo	:=  AllTrim(SA1->A1_EMAIL)

	EnvPriCom(cNomRespo,cEmaRespo,'Obrigado por Sua Compra',xCabecalho+xRodape)

	cItens := ''

RestArea(aArea)
Return .t.




// Envio de Email do WorkFlow Financeiro

Static Function EnvPriCom(cNomRespo,cEmaRespo,cAssunto,mCorpo)
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
						Help(" ",1,'Erro no Envio do Email',,cError+ " " + cPara,4,5)	//Aten็ใo
					Loop
				Endif
		 		nTenta := 10	// Em Caso de Sucesso sai do Loop
		 		Loop
			Else
				GET MAIL ERROR cError
				Help(" ",1,'Autentica็ใo',,cError,4,5)  //"Autenticacao"
				MsgStop('Erro de Autentica็ใo','Verifique a conta e a senha para envio') 		 //"Erro de autentica็ใo","Verifique a conta e a senha para envio"
			Endif
				
			DISCONNECT SMTP SERVER
			
		Else
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
		Endif
	Next

Return .t.