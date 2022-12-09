#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JobFinBlq   ºAutor  ³ Luiz Alberto   º Data ³  Nov/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job Departamento Financeiro, envio de aviso de titulos a
				Bloqueados Para Liberação de Alçadas
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function JobFinBlq()
Local aEmpresa := {{'01','01'},{'02','01'},{'04','01'}}


For nI := 1 To Len(aEmpresa)
	RpcSetType( 3 )
	RpcSetEnv( aEmpresa[nI,1], aEmpresa[nI,2] )

	Processa( {|| RunProc() } )			

	RpcClearEnv()
Next

Return
   	 
Static Function RunProc()
Local aArea := GetArea()
Local nTamanho  := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + TamSX3("E2_TIPO")[1] + TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1]

ConOut(OemToAnsi("Início Job Financeiro " + Dtoc(date()) +" - " + Time()))
	
// Envia Email aos Clientes com Vencimento Daqui 3 Dias Úteis

dProxData := dDataBase+3

cQuery := 	 " SELECT DISTINCT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_NOMFOR, CR_NUM, E2_VALOR, E2_EMISSAO, E2_VENCREA "
cQuery +=	 " FROM " + RetSqlName("SE2") + " E2, " + RetSqlName("SCR") + " CR "
cQuery +=	 " WHERE CR_FILIAL = E2_FILIAL "
cQuery +=	 " AND E2_FILIAL = '" + xFilial("SE2") + "' "
cQuery +=	 " AND E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA = CR_NUM "
cQuery +=	 " AND E2.D_E_L_E_T_ = '' "
cQuery +=	 " AND CR.D_E_L_E_T_ = '' "
cQuery +=	 " AND CR_TIPO = 'PG' "
cQuery +=	 " AND CR_STATUS = '02' "
cQuery +=	 " AND E2_XCONAP = 'B' "
cQuery +=	 " AND E2_SALDO > 0 "
cQuery +=	 " ORDER BY E2_VENCREA "

TCQUERY cQuery NEW ALIAS "CHK1"
	
TcSetField('CHK1','E2_EMISSAO','D')
TcSetField('CHK1','E2_VENCREA','D')

cCabecalho := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
cCabecalho += '<html> '
cCabecalho += '<head> '
cCabecalho += '  <meta content="text/html; charset=ISO-8859-1" '
cCabecalho += ' http-equiv="content-type"> '
cCabecalho += '  <title>WorkFlow Metalacre</title> '
cCabecalho += '</head> '
cCabecalho += '<body> '
cCabecalho += '<table '
cCabecalho += ' style="font-family: Helvetica,Arial,sans-serif; text-align: left; width: 1151px; height: 323px;" '
cCabecalho += ' border="1" cellpadding="2" cellspacing="2"> '
cCabecalho += '  <tbody> '
cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
cCabecalho += '      <td style="background-color: rgb(255, 255, 255);" '
cCabecalho += ' colspan="5" rowspan="1"><big><big><img '
cCabecalho += ' style="width: 300px; height: 88px;" alt="" '
cCabecalho += ' src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br> '
cCabecalho += '      </big></big></td> '
cCabecalho += '    </tr> '
cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
cCabecalho += '      <td style="background-color: rgb(255, 255, 204);" '
cCabecalho += ' colspan="5" rowspan="1"> EMPRESA: ' + SM0->M0_CODIGO + ' - ' + SM0->M0_NOMECOM + '</td> '
cCabecalho += '    </tr> '
cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
cCabecalho += '      <td colspan="5" rowspan="1"> '
cCabecalho += '      <p class="MsoNormal" style=""><span '
cCabecalho += ' style="font-size: 13.5pt; font-family: &quot;Arial&quot;,&quot;sans-serif&quot;; color: black;">Titulos '
cCabecalho += 'lan&ccedil;ados manualmente pelo financeiro aguardando '
cCabecalho += 'libera&ccedil;&atilde;o para futuro pagamento.</span><o:p></o:p></p> '
cCabecalho += '      </td> '
cCabecalho += '    </tr> '
cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
cCabecalho += '      <td style="background-color: rgb(255, 255, 204);" '
cCabecalho += ' colspan="5" rowspan="1"><big>Hist&oacute;rico '
cCabecalho += 'Financeiro</big></td> '
cCabecalho += '    </tr> '
cCabecalho += '    <tr> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Titulo '
cCabecalho += 'No.</td> '
cCabecalho += '      <td style="background-color: rgb(204, 204, 204);"><span '
cCabecalho += ' style="font-weight: bold;">Fornecedor</span></td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Emiss&atilde;o</td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Vencimento</td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: right;">Valor '
cCabecalho += ' Titulo</td> '
cCabecalho += '    </tr> '
cRodape    := '    <tr> '
cRodape    += '      <td style="background-color: rgb(255, 255, 204);" '
cRodape    += ' colspan="5" rowspan="1"><small><small><span '
cRodape    += ' style="font-weight: bold;">Data Envio:</span> '
cRodape    += 'Hora Envio: Operador:<br> '
cRodape    += '      </small></small> '
cRodape    += '      <div style="text-align: center;"><small '
cRodape    += ' style="font-weight: bold;"><small>Envio '
cRodape    += 'de Email Efetuado Autom&aacute;ticamente por nosso sistema Interno, '
cRodape    += 'favor n&atilde;o responder</small></small></div> '
cRodape    += '      </td> '
cRodape    += '    </tr> '
cRodape    += '  </tbody> '
cRodape    += '</table> '
cRodape    += '<br style="font-family: Helvetica,Arial,sans-serif;"> '
cRodape    += '</body> '
cRodape    += '</html> '

cNomRespo := 'Automatico'//UsrFullName(__cUserId)
cEmaRespo := 'automatico@metalacre.com.br'//UsrRetMail(__cUserId)

CHK1->(dbGoTop())
While CHK1->(!Eof())                 

	xCabecalho	:= cCabecalho
	xRodape     := cRodape
	xItens      := ''

	xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
	xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
	xRodape := StrTran(xRodape,'Operador:','Operador: <span style="font-weight: bold;">'+Capital(cNomRespo))+'</span>'
	
	aAprovadores := {}
	
	While CHK1->(!Eof())
		xItens  +=  '    <tr>
		xItens	+=	'      <td>'+CHK1->E2_PREFIXO+' '+CHK1->E2_NUM+' '+CHK1->E2_PARCELA+'</td>'
		xItens	+=	'      <td>'+Capital(CHK1->E2_NOMFOR)+'</td>'
		xItens	+=	'      <td style="text-align: center;">'+DtoC(CHK1->E2_EMISSAO)+'</td>'
		xItens	+=	'      <td style="text-align: center;">'+DtoC(CHK1->E2_VENCREA)+'</td>'
		xItens	+=	'      <td style="text-align: right;">'+TransForm(CHK1->E2_VALOR,'@E 9,999,999.99')+'</td>'
		xItens  +=  '    </tr>'
		
		cTitulo	:= CHK1->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)	// Chave Busca
		If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+PadR(cTitulo,nTamanho)))
			nAchou := Ascan(aAprovadores,SCR->CR_USER)
			If Empty(nAchou)
				AAdd(aAprovadores,SCR->CR_USER)
			Endif
		Endif

		CHK1->(dbSkip(1))
	Enddo
	
	cEmail := ''
	For nAprov := 1 To Len(aAprovadores)
		cEmail += AllTrim(UsrRetMail(aAprovadores[nAprov]))+';'
	Next
	cEmail += 'financeiro@metalacre.com.br;lalberto@3lsystems.com.br'+Iif(SM0->M0_CODIGO=='04',';pamella.sobral@mpmdistribuicao.com.br','')
	WrkLibAl(cNomRespo,cEmail,'Titulos Aguardando Liberação - Empresa: ' + SM0->M0_CODIGO + ' - ' + Capital(SM0->M0_NOMECOM),xCabecalho+xItens+xRodape)
	
Enddo

CHK1->(dbCloseArea())

RestArea(aArea)
Return


Static Function WrkLibAl(cNomRespo,cEmaRespo,cAssunto,mCorpo,lContrato)
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
	
DEFAULT lContrato := .f.

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
				BCC      	'financeiro@metalacre.com.br';
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