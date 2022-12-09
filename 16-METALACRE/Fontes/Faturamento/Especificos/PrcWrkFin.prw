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
±±ºPrograma  ³ PrcWrkFin º Autor ³ Luiz Alberto     º Data ³ 07/05/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsavel pelo Envio de Email de Pedidos Bloqueados
				no credito para os responsaveis do depto financeiro      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   

User Function PrcWrkFin(cPedido) 
Local aArea := GetArea()

	If !SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cPedido))
		RestArea(aArea)
		Return .f.
	Endif
	lCredito	:=	.F.
	
	If SC9->(dbSetOrder(1), dbSeek(xFilial("SC9")+cPedido))
		While SC9->(!Eof()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == cPedido
			If !Empty(SC9->C9_BLCRED) .And. SC9->C9_BLCRED<>'10'
				lCredito := .t.       
				Exit
			Endif              
			
			SC9->(dbSkip(1))
		Enddo
	Endif
	

	// Busca Últimos 20 Titulos do Cliente

	aArea := GetArea()
	
	cQuery := ""
	cQuery += " SELECT TOP 20 E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_HIST, E1_VENCTO, E1_VENCREA, E1_BAIXA, E1_VALOR, E1_SALDO, R_E_C_N_O_ REG "
	cQuery += " FROM " + RetSqlName("SE1") + " SE1 "
	cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
	cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
	cQuery += " AND SE1.E1_CLIENTE = '" + SC5->C5_CLIENTE + "' "
	cQuery += " AND SE1.E1_LOJA = '" + SC5->C5_LOJACLI + "' "
	cQuery += " AND SE1.E1_VENCREA < '" + DtoS(dDataBase) + "' "
	cQuery += " AND SE1.E1_SALDO > 0 "
	cQuery += " ORDER BY E1_EMISSAO DESC "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)

	TcSetField("CAD","E1_EMISSAO","D",8,0)
	TcSetField("CAD","E1_VENCREA","D",8,0)
	TcSetField("CAD","E1_VENCTO","D",8,0)
	TcSetField("CAD","E1_BAIXA","D",8,0)
	
	Count To nReg
	
	CAD->(dbGoTop())
	
	If Empty(nReg) .Or. !lCredito
		CAD->(dbCloseArea())
		RestArea(aArea)
		Return .f.
	Endif
	
	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

 	cCabecalho := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
 	cCabecalho += '    <html> '
 	cCabecalho += '    <head> '
  	cCabecalho += '      <meta '
  	cCabecalho += '     content="text/html; charset=ISO-8859-1" '
  	cCabecalho += '     http-equiv="content-type"> '
  	cCabecalho += '      <title>WorkFlow Metalacre</title> '
  	cCabecalho += '    </head> '
  	cCabecalho += '    <body> '
  	cCabecalho += '    <table '
  	cCabecalho += '     style="font-family: Helvetica,Arial,sans-serif; width: 100%; text-align: left; margin-left: auto; margin-right: 0px;" '
  	cCabecalho += '     border="1" cellpadding="2" cellspacing="2"> '
  	cCabecalho += '      <tbody> '
  	cCabecalho += '        <tr style="font-weight: bold;" '
  	cCabecalho += '     align="center"> '
  	cCabecalho += '          <td '
  	cCabecalho += '     style="background-color: rgb(255, 255, 255);" colspan="8" '
  	cCabecalho += '     rowspan="1"><big><big><img '
  	cCabecalho += '     style="width: 300px; height: 88px;" alt="" '
  	cCabecalho += '     src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br> '
  	cCabecalho += '          </big></big></td> '
  	cCabecalho += '        </tr> '
  	cCabecalho += '        <tr style="font-weight: bold;" '
  	cCabecalho += '     align="center"> '
  	cCabecalho += '          <td '
  	cCabecalho += '     style="background-color: rgb(255, 255, 204);" colspan="8" '
  	cCabecalho += '     rowspan="1"><big><big>Pedido '
  	cCabecalho += '    com Bloqueio Cr&eacute;dito</big></big></td> '
  	cCabecalho += '        </tr> '
  	cCabecalho += '        <tr> '
  	cCabecalho += '          <td><small>No.Pedido:</small></td> '
  	cCabecalho += '          <td><small>Emissao:</small></td> '
  	cCabecalho += '          <td colspan="2" rowspan="1"><small>Valor Total:</small></td> '
  	cCabecalho += '          <td><small>Previsao de Entrega:</small></td> '
  	cCabecalho += '          <td><small>Cond.Pagto:</small></td> '
  	cCabecalho += '          <td><small>Limite Credito:</small></td> '
  	cCabecalho += '          <td><small>Vencto Limite:</small></td> '
  	cCabecalho += '        </tr> '
  	cCabecalho += '        <tr> '
  	cCabecalho += '          <td><small>Cliente:</small></td> '
  	cCabecalho += '          <td><small>Contato:</small></td> '
  	cCabecalho += '          <td colspan="2" rowspan="1"><small>Fone:</small></td> '
  	cCabecalho += '          <td><small>Email:</small></td> '
  	cCabecalho += '          <td colspan="1" rowspan="1"><small>Cidade/UF:</small></td>'
  	cCabecalho += '          <td rowspan="1" colspan="2"><small>Vendedor(a):</small></td>'
  	cCabecalho += '        </tr> '
  	cCabecalho += '        <tr> '
  	cCabecalho += '          <td colspan="8" rowspan="1"><small>Observacoes:</small></td> '
  	cCabecalho += '        </tr> '
  	cCabecalho += '        <tr> '
  	cCabecalho += '          <td colspan="8" rowspan="1"><small>Tipo Risco:</small></td> '
  	cCabecalho += '        </tr> '
  	cCabecalho += '        <tr style="font-weight: bold;" '
  	cCabecalho += '     align="center"> '
  	cCabecalho += '          <td '
  	cCabecalho += '     style="background-color: rgb(255, 255, 204);" colspan="8" '
  	cCabecalho += '     rowspan="1"><big>Hist&oacute;rico '
  	cCabecalho += '    Financeiro</big></td> '
  	cCabecalho += '        </tr> '
  	cCabecalho += '        <tr> '
  	cCabecalho += '          <td style="background-color: rgb(204, 204, 204); font-weight: bold;">Titulo No.</td> '
  	cCabecalho += '          <td style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Emiss&atilde;o</td> '
  	cCabecalho += '          <td style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Vencimento</td> '
  	cCabecalho += '          <td style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Vencto Real</td> '
  	cCabecalho += '          <td style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: right;">Valor Titulo</td> '
  	cCabecalho += '          <td style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Data Baixa</td> '
  	cCabecalho += '          <td style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Dias Atraso</td> '
  	cCabecalho += '          <td style="background-color: rgb(204, 204, 204); font-weight: bold;">Histórico</td> '
  	cCabecalho += '        </tr> '

  	cItens		:= ''
	xCabecalho	:= cCabecalho
	nTotalDev	:= 0.00

	Dbselectarea("CAD")
	dbGoTop()	
	While CAD->(!EOF())
		cItens	+=	'   <tr>'
		cItens	+=	'      <td>'+CAD->E1_PREFIXO+' '+CAD->E1_NUM+'/'+CAD->E1_PARCELA+'</td>'
		cItens	+=	'      <td style="text-align: center;">'+DtoC(CAD->E1_EMISSAO)+'</td>'
		cItens	+=	'      <td style="text-align: center;">'+DtoC(CAD->E1_VENCTO)+'</td>'
		cItens	+=	'      <td style="text-align: center;">'+DtoC(CAD->E1_VENCREA)+'</td>'
		cItens	+=	'      <td style="text-align: right;">'+TransForm(CAD->E1_SALDO,'@E 9,999,999.99')+'</td>'
		cItens	+=	'      <td style="text-align: center;">'+DtoC(CAD->E1_BAIXA)+'</td>'
		cItens	+=	'      <td style="text-align: center;">'+Iif(!Empty(CAD->E1_BAIXA),Str(CAD->E1_BAIXA-CAD->E1_VENCREA,5),Str(dDataBase-CAD->E1_VENCREA,5)) +'</td>'
		cItens	+=	'      <td>'+Capital(CAD->E1_HIST)+'</td>'
		cItens	+=	'    </tr>'
	
		nTotalDev += CAD->E1_SALDO

		CAD->(dbSkip(1))
	Enddo
	
	CAD->(dbCloseArea())
	
	RestArea(aArea)

	cRodape	:=	'        <tr> '
	cRodape	+=	'          <td colspan="5" rowspan="1"></td> '
	cRodape	+=	'                <td><span '
	cRodape	+=	'           style="font-weight: bold;">Valor Total em Aberto</span></td> '
	cRodape	+=	'                <td colspan="2" rowspan="1" style="text-align: right;">'+TransForm(nTotalDev,'@E 9,999,999,999.99')+'</td>' 
	cRodape	+=	'              </tr> '
	cRodape	+=	'              <tr> '
	cRodape	+=	'                <td '
	cRodape	+=	'           style="background-color: rgb(255, 255, 204);" colspan="8" '
	cRodape	+=	'           rowspan="1"><small><small><span '
	cRodape	+=	'           style="font-weight: bold;">Data Envio:</span> '
	cRodape	+=	'          Hora Envio: Operador:</small></small></td> '
	cRodape	+=	'              </tr> '
	cRodape	+=	'            </tbody> '
	cRodape	+=	'          </table> '
	cRodape	+=	'          <br '
	cRodape	+=	'           style="font-family: Helvetica,Arial,sans-serif;"> '
	cRodape	+=	'          </body> '
	cRodape	+=	'          </html> '

	xRodape		:= cRodape                                                                           
	cNomRespo := UsrFullName(__cUserId)
	cEmaRespo := UsrRetMail(__cUserId)
	
	cNome := ''
	xCabecalho := StrTran(xCabecalho,'Cliente:','Cliente: <span style="font-weight: bold;">'+SA1->A1_COD+'/'+SA1->A1_LOJA+' '+Capital(SA1->A1_NOME))+'</span>'
	cNome := SA1->A1_NOME       
	
	SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+SC5->C5_VEND1))

	xCabecalho := StrTran(xCabecalho,'No.Pedido:','No.Pedido: <span style="font-weight: bold;">'+SC5->C5_NUM)+'</span>'
	xCabecalho := StrTran(xCabecalho,'Emissao:','Emissão: <span style="font-weight: bold;">'+DtoC(SC5->C5_EMISSAO))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Valor Total:','Valor Total: <span style="font-weight: bold;">'+TransForm(SC5->C5_TOTPED,'@E 999,999,999,999.99'))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Previsao de Entrega:','Previsao de Entrega: <span style="font-weight: bold;">'+DtoC(SC5->C5_FECENT))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Cond.Pagto:','Cond.Pagto: <span style="font-weight: bold;">'+SC5->C5_CONDPAG + ' - ' + Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,'E4_DESCRI'))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Limite Credito:','Limite Credito: <span style="font-weight: bold;">'+TransForm(SA1->A1_LC,'@E 999,999,999,999.99'))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Vencto Limite:','Vencto Limite: <span style="font-weight: bold;">'+DtoC(SA1->A1_VENCLC))+'</span>'
	
	xCabecalho := StrTran(xCabecalho,'Contato:','Contato: <span style="font-weight: bold;">'+Capital(SA1->A1_CONTATO))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Fone:','Fone: <span style="font-weight: bold;">'+SA1->A1_DDD+' '+SA1->A1_TEL)+'</span>'
	xCabecalho := StrTran(xCabecalho,'Email:','Email: <span style="font-weight: bold;">'+SA1->A1_EMAIL)+'</span>'
	xCabecalho := StrTran(xCabecalho,'Cidade/UF:','Cidade/UF: <span style="font-weight: bold;">'+SA1->A1_MUN + '/' + SA1->A1_EST)+'</span>'
	xCabecalho := StrTran(xCabecalho,'Vendedor(a):','Vendedor(a): <span style="font-weight: bold;">'+SA3->A3_COD + '-' + Capital(SA3->A3_NOME))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Observacao:','Observacao: <span style="font-weight: bold;">'+Capital(SA1->A1_OBSERV))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Tipo Risco:','Tipo Risco: <span style="font-weight: bold;">'+SA1->A1_RISCO)+'</span>'

	xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
	xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
	xRodape := StrTran(xRodape,'Operador:','Operador: <span style="font-weight: bold;">'+Capital(cNomRespo))+'</span>'
  			
	cEmaFina	:=	SuperGetMV('MV_USRFIN', .F., 'financeiro@metalacre.com.br;mariana@metalacre.com.br;lalberto@3lsystems.com.br') 
	cEmaRespo	:=  AllTrim(cEmaRespo)+';'+cEmaFina

	EnvWrkFin(cNomRespo,cEmaRespo,'Pedido com Bloqueio de Crédito Pedido No. ' + SC5->C5_NUM + ' - ' + Capital(cNome),xCabecalho+cItens+xRodape)

	cItens := ''

RestArea(aArea)
Return .t.




// Envio de Email do WorkFlow Financeiro

Static Function EnvWrkFin(cNomRespo,cEmaRespo,cAssunto,mCorpo)
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