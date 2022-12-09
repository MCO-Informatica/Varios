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
±±ºPrograma  ³ M110STTS º Autor ³ Luiz Alberto     º Data ³ 24/04/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ WorkFlow de Solicitações de Compras
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   

User Function M110STTS() 
Local cNumSol	:= Paramixb[1]
Local nOpt		:= Paramixb[2]
Local aArea		:= SC1->(GetArea())

If INCLUI .Or. ALTERA //nOpt == 1 .Or. nOpt == 2	// Inclusão e Alteração de SC´s

  	// Inicia Envio de Email do WorkFlow
	  	
  	cCabecalho := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
  	cCabecalho += '<html> '
  	cCabecalho += '<head> '
  	cCabecalho += '  <meta content="text/html; charset=ISO-8859-1" '
  	cCabecalho += ' http-equiv="content-type"> '
  	cCabecalho += '  <title>WorkFlow Metalacre</title> '
  	cCabecalho += '</head> '
  	cCabecalho += '<body> '
  	cCabecalho += '<table '
  	cCabecalho += ' style="font-family: Helvetica,Arial,sans-serif; width: 100%; text-align: left; margin-left: auto; margin-right: 0px;" '
  	cCabecalho += ' border="1" cellpadding="2" cellspacing="2"> '
  	cCabecalho += '  <tbody> '
  	cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
  	cCabecalho += '      <td colspan="9" rowspan="1"><big><big><img '
  	cCabecalho += ' style="width: 541px; height: 120px;" alt="" '
  	cCabecalho += ' src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br> '
  	cCabecalho += '      </big></big></td> '
  	cCabecalho += '    </tr> '
  	cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
  	cCabecalho += '      <td colspan="9" rowspan="1"><big><big>' + Iif(nOpt==3,'Inclusao','Alteracao')+' Solicita&ccedil;&atilde;o '
  	cCabecalho += 'de Compras</big></big></td> '
  	cCabecalho += '    </tr> '
  	cCabecalho += '    <tr> '
  	cCabecalho += '      <td colspan="2" rowspan="1"><small>No.Solicitacao:</small></td> '
  	cCabecalho += '      <td colspan="2" rowspan="1"><small>Solicitante:</small><small></small></td> '
  	cCabecalho += '      <td colspan="3" rowspan="1"><small>Comprador:</small></td> '
  	cCabecalho += '      <td colspan="2" rowspan="1"><small>Emissao:</small><small><br> '
  	cCabecalho += '      </small></td> '
  	cCabecalho += '    </tr> '
  	cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
  	cCabecalho += '      <td style="background-color: rgb(255, 255, 204);" '
  	cCabecalho += ' colspan="9" rowspan="1">Itens Solicitados</td> '
  	cCabecalho += '    </tr> '
  	cCabecalho += '    <tr> '
  	cCabecalho += '      <td '
  	cCabecalho += ' style="background-color: rgb(204, 204, 204); text-align: center;"><span '
  	cCabecalho += ' style="font-weight: bold;">Item</span></td> '
  	cCabecalho += '      <td '
  	cCabecalho += ' style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: left;"><small>Codigo</small></td> '
  	cCabecalho += '      <td '
  	cCabecalho += ' style="background-color: rgb(204, 204, 204); font-weight: bold;"><small>Descricao</small></td> '
  	cCabecalho += '      <td '
  	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;"><small>Und</small></td> '
  	cCabecalho += '      <td '
  	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: right;"><small>Quantidade</small></td> '
  	cCabecalho += '      <td '
  	cCabecalho += ' style="background-color: rgb(204, 204, 204); font-weight: bold; text-align: center;">Armazem</td> '
  	cCabecalho += '      <td '
  	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;"><small>C.Custo</small></td> '
  	cCabecalho += '      <td '
  	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: left;"><small>Fornecedor</small></td> '
  	cCabecalho += '      <td '
  	cCabecalho += ' style="background-color: rgb(204, 204, 204); text-align: center;"><small><span '
  	cCabecalho += ' style="font-weight: bold;">Necessidade</span></small></td> '
  	cCabecalho += '    </tr> '

  	cItens		:= ''
  	cSolicita   := ''
  	cComprador  := '' 
  	dEmissao  	:= CtoD('')                                                     
  	cEmaCompra  := ''
  	
  	If SC1->(dbSetOrder(1), dbSeek(xFilial("SC1")+cNumSol))
  		cSolicita := SC1->C1_SOLICIT
  		cComprador:= Posicione("SY1",1,xFilial("SY1")+SC1->C1_CODCOMP,"Y1_NOME")
  		cEmaCompra:= AllTrim(SY1->Y1_EMAIL)
  		dEmissao  := SC1->C1_EMISSAO
  		
		While SC1->(!Eof()) .And. SC1->C1_FILIAL == xFilial("SC1") .And. SC1->C1_NUM == cNumSol

			SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
			SA2->(dbSetOrder(1), dbSeek(xFilial("SA2")+SC1->C1_FORNECE+SC1->C1_LOJA))

 			cItens	+=	'   <tr>'
 			cItens	+=	'         <td style="text-align: center;">'+SC1->C1_ITEM+'</td> '
 			cItens	+=	'         <td style="text-align: left;">'+SC1->C1_PRODUTO+'</td> '
 			cItens	+=	'         <td>'+AllTrim(SB1->B1_DESC)+'</td> '
 			cItens	+=	'         <td style="text-align: center;">'+SB1->B1_UM+'</td> '
 			cItens	+=	'         <td style="text-align: right;">'+TransForm(SC1->C1_QUANT,'@E 999,999.999')+'</td> '
 			cItens	+=	'         <td style="text-align: center;">'+SC1->C1_LOCAL+'</td> '
 			cItens	+=	'         <td style="text-align: right;">'+SC1->C1_CC+'</td> '
 			cItens	+=	'         <td style="text-align: right;">'+Iif(!Empty(SC1->C1_FORNECE),SA2->A2_COD+'/'+SA2->A2_LOJA+'-'+Capital(SA2->A2_NOME),'')+'</td> '
 			cItens	+=	'         <td style="text-align: center;">'+DtoC(SC1->C1_DATPRF)+'</td> '
 			cItens	+=	'       </tr> '
 			
 			SC1->(dbSkip(1))
 		Enddo
 	Endif

	cRodape	:=	'        <tr>	'
	cRodape	+=	'      <td style="background-color: rgb(255, 255, 204);" '
	cRodape	+=	' colspan="9" rowspan="1"><small><small><span '
	cRodape	+=	' style="font-weight: bold;">Data Envio:</span> '
	cRodape	+=	'Hora Envio:&nbsp;</small></small></td> '
	cRodape	+=	'    </tr> '
	cRodape	+=	'  </tbody> '
	cRodape	+=	'</table> '
	cRodape	+=	'<br style="font-family: Helvetica,Arial,sans-serif;"> '
	cRodape	+=	'</body> '
	cRodape	+=	'</html> '


	cNomRespo := UsrFullName(__cUserID)
	cEmaRespo := cEmaCompra
	  			
	xCabecalho	:= cCabecalho
	xRodape		:= cRodape

	xCabecalho := StrTran(xCabecalho,'No.Solicitacao:','No.Solicitacao: <span style="font-weight: bold;">'+cNumSol)+'</span>'
	xCabecalho := StrTran(xCabecalho,'Solicitante:','Solicitante: <span style="font-weight: bold;">'+cSolicita)+'</span>'
	xCabecalho := StrTran(xCabecalho,'Comprador:','Comprador: <span style="font-weight: bold;">'+cComprador)+'</span>'
	xCabecalho := StrTran(xCabecalho,'Emissao:','Emissao: <span style="font-weight: bold;">'+DtoC(dEmissao))+'</span>'
	xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
	xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
  			
	EnvWrk(cNomRespo,cEmaRespo,'Solicitação de Compras No. ' + cNumSol,xCabecalho+cItens+xRodape)

	cItens := ''
Endif
RestArea(aArea)
Return Nil

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