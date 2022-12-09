#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ JobFinan   ∫Autor  ≥ Luiz Alberto   ∫ Data ≥  Nov/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Job Departamento Financeiro, envio de aviso de titulos a
				a vencer e vencidos
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function JobFinan()
Local aEmpresa := {{'01','01'}}


For nI := 1 To Len(aEmpresa)
	If !(Select("SX2")<>0)
		RpcSetType( 3 )
		RpcSetEnv( aEmpresa[nI,1], aEmpresa[nI,2] )
	Endif
	
	Processa( {|| RunProc() } )			

	If !(Select("SX2")<>0)
		RpcClearEnv()
	Endif
Next

Return
   	 
Static Function RunProc()
Local aArea := GetArea()

ConOut(OemToAnsi("InÌcio Job Financeiro " + Dtoc(date()) +" - " + Time()))
                                      
If cEmpAnt <> '01'
	Return .F.
Endif
	
// Envia Email aos Clientes com Vencimento Daqui 3 Dias ⁄teis

dProxData := dDataBase+4

cQuery := 	 " SELECT A1_COD, A1_LOJA, A1_NOME, A1_CONTATO, A1_DDD, A1_TEL, A1_EMAIL1, E1_NATUREZ, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, E1_SALDO, E1_VENCREA "
cQuery +=	 " FROM " + RetSqlName("SA1") + " SA1 (NOLOCK), " + RetSqlName("SE1") + " SE1 (NOLOCK) "
cQuery +=	 " WHERE A1_COD = E1_CLIENTE "
cQuery +=	 " AND SA1.A1_LOJA = E1_LOJA "
cQuery +=	 " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
cQuery +=	 " AND SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
cQuery +=	 " AND E1_VENCREA = '" + DtoS(dProxData) + "' "
cQuery +=	 " AND E1_SALDO > 0 "
cQuery +=	 " AND SA1.D_E_L_E_T_ = '' "
cQuery +=	 " AND SE1.D_E_L_E_T_ = '' "
cQuery +=	 " AND SE1.E1_NATUREZ IN('101004','101003','101005') "
cQuery +=	 " ORDER BY SA1.A1_COD, SA1.A1_LOJA, SE1.E1_NUM "

TCQUERY cQuery NEW ALIAS "CHK1"
	
TcSetField('CHK1','E1_EMISSAO','D')
TcSetField('CHK1','E1_VENCREA','D')

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
cCabecalho += ' style="font-family: Helvetica,Arial,sans-serif; width: 1151px; height: 323px; text-align: left; margin-left: 0px; margin-right: auto;" '
cCabecalho += ' border="1" cellpadding="2" cellspacing="2"> '
cCabecalho += '  <tbody> '
cCabecalho += '    <tr style="font-weight: bold;" '
cCabecalho += ' align="center"> '
cCabecalho += '      <td '                         ï
cCabecalho += ' style="background-color: rgb(255, 255, 255);" colspan="4" '
cCabecalho += ' rowspan="1"><big><big><img '
cCabecalho += ' style="width: 300px; height: 88px;" alt="" '
cCabecalho += ' src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br> '
cCabecalho += '      </big></big></td> '
cCabecalho += '    </tr> '
cCabecalho += '    <tr style="font-weight: bold;" '
cCabecalho += ' align="center"> '
cCabecalho += '      <td '
cCabecalho += ' style="background-color: rgb(255, 255, 204);" colspan="4" '
cCabecalho += ' rowspan="1"><big><big>Aviso '
cCabecalho += 'de Vencimento</big></big></td> '
cCabecalho += '    </tr> '
cCabecalho += '    <tr style="font-weight: bold;" '
cCabecalho += ' align="center"> '
cCabecalho += '      <td colspan="4" rowspan="1"> '
cCabecalho += '      <p style="text-align: left;" '
cCabecalho += ' class="MsoNormal"><span '
cCabecalho += ' style="color: black;">Informamos &nbsp;o&nbsp;</span><span '
cCabecalho += ' style="color: rgb(34, 34, 34);">vencimento</span><span '
cCabecalho += ' style="color: black;">&nbsp;de '
cCabecalho += 'seu(s) t&iacute;tulo(s) listado(s) abaixo, referente a venda de '
cCabecalho += 'mercadorias, '
cCabecalho += 'caso n&atilde;o tenha recebido o boleto referente aos titulos apresentados, favor entrar em contato com nosso departamento financeiro imediatamente. '
cCabecalho += '<br> '
cCabecalho += '      </span></p> '
cCabecalho += '      </td> '
cCabecalho += '    </tr> '
cCabecalho += '    <tr> '
cCabecalho += '      <td><small>Cliente:</small></td> '
cCabecalho += '      <td><small>Contato:</small></td> '
cCabecalho += '      <td colspan="1" rowspan="1"><small>Fone:</small></td> '
cCabecalho += '      <td><small>Email:</small></td> '
cCabecalho += '    </tr> '
cCabecalho += '    <tr style="font-weight: bold;" '
cCabecalho += ' align="center"> '
cCabecalho += '      <td '
cCabecalho += ' style="background-color: rgb(255, 255, 204);" colspan="4" '
cCabecalho += ' rowspan="1"><big>Hist&oacute;rico '
cCabecalho += 'Financeiro</big></td> '
cCabecalho += '    </tr> '
cCabecalho += '    <tr> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Titulo '
cCabecalho += 'No.</td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Emiss&atilde;o</td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Vencimento</td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: right;">Valor '
cCabecalho += 'Titulo</td> '
cCabecalho += '    </tr> '

cRodape    := '    <tr> '
cRodape    += '      <td colspan="4" rowspan="1"> '
cRodape    += '      <p style="text-align: center;" '
cRodape    += ' class="MsoNormal"><span '
cRodape    += ' style="font-family: &quot;Arial&quot;,&quot;sans-serif&quot;; color: black; font-weight: bold;">Se '
cRodape    += 'houver necessidade de prorroga&ccedil;&atilde;o ou maiores '
cRodape    += 'informa&ccedil;&otilde;es entre em contato<br> '
cRodape    += '      </span><span '
cRodape    += ' style="font-weight: bold;">com '
cRodape    += 'nosso departamento financeiro:<br> '
cRodape    += '      <br> '
cRodape    += 'Fone: (11) 2884-3640</span><br '
cRodape    += ' style="font-weight: bold;"> '
cRodape    += '      <a '
cRodape    += ' href="mailto:financeiro@metalacre.com.br"><span '
cRodape    += ' style="font-family: &quot;Arial&quot;,&quot;sans-serif&quot;; color: black; font-weight: bold;">financeiro@metalacre.com.br</span></a></p> '
cRodape    += '      </td> '
cRodape    += '    </tr> '
cRodape    += '    <tr> '
cRodape    += '      <td '
cRodape    += ' style="background-color: rgb(255, 255, 204);" colspan="4" '
cRodape    += ' rowspan="1"><small><small><span '
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
cRodape    += '<br '
cRodape    += ' style="font-family: Helvetica,Arial,sans-serif;"> '
cRodape    += '</body> '
cRodape    += '</html> '

cNomRespo := 'Automatico'//UsrFullName(__cUserId)
cEmaRespo := 'automatico@metalacre.com.br'//UsrRetMail(__cUserId)

CHK1->(dbGoTop())
While CHK1->(!Eof())                 

	cCliente := CHK1->A1_COD
	cLoja    := CHK1->A1_LOJA
	xCabecalho	:= cCabecalho
	xRodape     := cRodape
	xItens      := ''

	xCabecalho := StrTran(xCabecalho,'Cliente:','Cliente: <span style="font-weight: bold;">('+cCliente+'/'+cLoja+') '+Capital(CHK1->A1_NOME))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Contato:','Contato: <span style="font-weight: bold;">'+Capital(CHK1->A1_CONTATO))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Fone:','Fone: <span style="font-weight: bold;"> ('+CHK1->A1_DDD+') '+CHK1->A1_TEL)+'</span>'
	xCabecalho := StrTran(xCabecalho,'Email:','Email: <span style="font-weight: bold;">'+CHK1->A1_EMAIL1)+'</span>'

	If CHK1->E1_NATUREZ == '101005'	// Natureza Deposito
		xCabecalho := StrTran(xCabecalho,'caso n&atilde;o tenha recebido o boleto referente aos titulos apresentados, favor entrar em contato com nosso departamento financeiro imediatamente.','<span style="font-weight: bold;">seguem nossos dados bancarios para pagamento: Banco do Brasil - Agencia: 3222 - Conta: 101517-6 ')+'</span> '
	Endif

	xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
	xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
	xRodape := StrTran(xRodape,'Operador:','Operador: <span style="font-weight: bold;">'+Capital(cNomRespo))+'</span>'
	
	cEmailFinan := CHK1->A1_EMAIL1
	
	If Empty(CHK1->A1_EMAIL1)
		CHK1->(dbSkip(1));Loop
	Endif

	While CHK1->(!Eof()) .And. CHK1->A1_COD == cCliente .And. CHK1->A1_LOJA == cLoja
		xItens  +=  '    <tr>'
		xItens	+=	'      <td style="text-align: center;">'+CHK1->E1_PREFIXO+' '+CHK1->E1_NUM+' '+CHK1->E1_PARCELA+'</td>'
		xItens	+=	'      <td style="text-align: center;">'+DtoC(CHK1->E1_EMISSAO)+'</td>'
		xItens	+=	'      <td style="text-align: center;">'+DtoC(CHK1->E1_VENCREA)+'</td>'
		xItens	+=	'      <td style="text-align: right;">'+TransForm(CHK1->E1_SALDO,'@E 9,999,999.99')+'</td>'
		xItens  +=  '    </tr>'
		
		CHK1->(dbSkip(1))
	Enddo

	WrkAviFin(cNomRespo,cEmailFinan,'Aviso de Vencimento',xCabecalho+xItens+xRodape)
	
Enddo

CHK1->(dbCloseArea())

// Envio de Email de Titulos Vencidos

// Envia Email aos Clientes com Vencimento Daqui 3 Dias ⁄teis

dProxData := dDataBase-3

cQuery := 	 " SELECT A1_COD, A1_LOJA, A1_NOME, A1_CONTATO, A1_DDD, A1_TEL, A1_EMAIL1, E1_NATUREZ, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, E1_SALDO, E1_VENCREA "
cQuery +=	 " FROM " + RetSqlName("SA1") + " SA1 (NOLOCK), " + RetSqlName("SE1") + " SE1 (NOLOCK) "
cQuery +=	 " WHERE A1_COD = E1_CLIENTE "
cQuery +=	 " AND SA1.A1_LOJA = E1_LOJA "
cQuery +=	 " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
cQuery +=	 " AND SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
cQuery +=	 " AND E1_VENCREA = '" + DtoS(dProxData) + "' "
cQuery +=	 " AND E1_SALDO > 0 "
cQuery +=	 " AND SA1.D_E_L_E_T_ = '' "
cQuery +=	 " AND SE1.D_E_L_E_T_ = '' "
cQuery +=	 " AND SE1.E1_NATUREZ IN('101004','101003','101005') "
cQuery +=	 " ORDER BY SA1.A1_COD, SA1.A1_LOJA, SE1.E1_NUM "

TCQUERY cQuery NEW ALIAS "CHK1"
	
TcSetField('CHK1','E1_EMISSAO','D')
TcSetField('CHK1','E1_VENCREA','D')

cCabecalho := ' <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
cCabecalho += ' <html> '
cCabecalho += ' <head> '
cCabecalho += '   <meta '
cCabecalho += '  content="text/html; charset=ISO-8859-1" '
cCabecalho += '  http-equiv="content-type"> '
cCabecalho += '   <title>WorkFlow Metalacre</title> '
cCabecalho += ' </head> '
cCabecalho += ' <body> '
cCabecalho += ' <table '
cCabecalho += '  style="font-family: Helvetica,Arial,sans-serif; text-align: left; width: 1151px; height: 323px;" '
cCabecalho += '  border="1" cellpadding="2" cellspacing="2"> '
cCabecalho += '   <tbody> '
cCabecalho += '     <tr style="font-weight: bold;" '
cCabecalho += '  align="center"> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(255, 255, 255);" colspan="4" '
cCabecalho += '  rowspan="1"><big><big><img '
cCabecalho += '  style="width: 300px; height: 88px;" alt="" '
cCabecalho += '  src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br> '
cCabecalho += '       </big></big></td> '
cCabecalho += '     </tr> '
cCabecalho += '     <tr style="font-weight: bold;" '
cCabecalho += '  align="center"> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(255, 255, 204);" colspan="4" '
cCabecalho += '  rowspan="1"><big><big>Aviso '
cCabecalho += ' de Duplicata(s) Pendente(s) </big></big></td> '
cCabecalho += '     </tr> '
cCabecalho += '     <tr style="font-weight: bold;" '
cCabecalho += '  align="center"> '
cCabecalho += '       <td colspan="4" rowspan="1"> '
cCabecalho += '       <p class="MsoNormal" style=""><span '
cCabecalho += '  style="font-size: 13.5pt; font-family: &quot;Arial&quot;,&quot;sans-serif&quot;; color: black;">Informamos '
cCabecalho += ' que, at&eacute; o momento, n&atilde;o recebemos a '
cCabecalho += ' confirma&ccedil;&atilde;o do pagamento de seu(s)<br> '
cCabecalho += ' t&iacute;tulo(s) listado(s) abaixo, referente(s) a venda de '
cCabecalho += ' mercadorias.</span><o:p></o:p></p> '
cCabecalho += '       </td> '
cCabecalho += '     </tr> '
cCabecalho += '     <tr> '
cCabecalho += '       <td><small>Cliente:</small></td> '
cCabecalho += '       <td><small>Contato:</small></td> '
cCabecalho += '       <td colspan="1" rowspan="1"><small>Fone:</small></td> '
cCabecalho += '       <td><small>Email:</small></td> '
cCabecalho += '     </tr> '
cCabecalho += '     <tr style="font-weight: bold;" '
cCabecalho += '  align="center"> '
cCabecalho += '       <td '
cCabecalho += '  style="background-color: rgb(255, 255, 204);" colspan="4" '
cCabecalho += '  rowspan="1"><big>Hist&oacute;rico '
cCabecalho += ' Financeiro</big></td> '
cCabecalho += '     </tr> '
cCabecalho += '     <tr> '
cCabecalho += '       <td '
cCabecalho += '  style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Titulo '
cCabecalho += ' No.</td> '
cCabecalho += '       <td '
cCabecalho += '  style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Emiss&atilde;o</td> '
cCabecalho += '       <td '
cCabecalho += '  style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Vencimento</td> '
cCabecalho += '       <td '
cCabecalho += '  style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: right;">Valor '
cCabecalho += ' Titulo</td> '
cCabecalho += '     </tr> '

cRodape    := '     <tr> '
cRodape    += '       <td style="text-align: center;" '
cRodape    += '  colspan="4" rowspan="1"> '
cRodape    += '       <p style="text-align: center;" '
cRodape    += '  class="MsoNormal"><span '
cRodape    += '  style="font-size: 13.5pt; font-family: &quot;Arial&quot;,&quot;sans-serif&quot;; color: black;">Caso '
cRodape    += ' o(s)&nbsp;t&iacute;tulo(s) listados '
cRodape    += ' acima estejam quitados, por favor, entrar em contato com o Departamento '
cRodape    += '       <br> '
cRodape    += ' financeiro '
cRodape    += ' ou '
cRodape    += ' envie-nos o comprovante de pagamento do(s) mesmo(s).</span><span '
cRodape    += '  style="font-weight: bold;"><br> '
cRodape    += '       <br> '
cRodape    += ' Fone: (11) 2884-3640</span><br '
cRodape    += '  style="font-weight: bold;"> '
cRodape    += '       <a '
cRodape    += '  href="mailto:financeiro@metalacre.com.br"><span '
cRodape    += '  style="font-family: &quot;Arial&quot;,&quot;sans-serif&quot;; color: black; font-weight: bold;">financeiro@metalacre.com.br</span></a></p> '
cRodape    += '       </td> '
cRodape    += '     </tr> '
cRodape    += '     <tr> '
cRodape    += '       <td '
cRodape    += '  style="background-color: rgb(255, 255, 204);" colspan="4" '
cRodape    += '  rowspan="1"><small><small><span '
cRodape    += '  style="font-weight: bold;">Data Envio:</span> '
cRodape    += ' Hora Envio: Operador:<br> '
cRodape    += '       </small></small> '
cRodape    += '       <div style="text-align: center;"><small '
cRodape    += '  style="font-weight: bold;"><small>Envio '
cRodape    += ' de Email Efetuado Autom&aacute;ticamente por nosso sistema Interno, '
cRodape    += ' favor n&atilde;o responder</small></small></div> '
cRodape    += '       </td> '
cRodape    += '     </tr> '
cRodape    += '   </tbody> '
cRodape    += ' </table> '
cRodape    += ' <br '
cRodape    += '  style="font-family: Helvetica,Arial,sans-serif;"> '
cRodape    += ' </body> '
cRodape    += ' </html> '
 
cNomRespo := 'Automatico'//UsrFullName(__cUserId)
cEmaRespo := 'automatico@metalacre.com.br'//UsrRetMail(__cUserId)

CHK1->(dbGoTop())
While CHK1->(!Eof())                 

	cCliente := CHK1->A1_COD
	cLoja    := CHK1->A1_LOJA
	xCabecalho	:= cCabecalho
	xRodape     := cRodape
	xItens      := ''

	xCabecalho := StrTran(xCabecalho,'Cliente:','Cliente: <span style="font-weight: bold;">('+cCliente+'/'+cLoja+') '+Capital(CHK1->A1_NOME))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Contato:','Contato: <span style="font-weight: bold;">'+Capital(CHK1->A1_CONTATO))+'</span>'
	xCabecalho := StrTran(xCabecalho,'Fone:','Fone: <span style="font-weight: bold;"> ('+CHK1->A1_DDD+') '+CHK1->A1_TEL)+'</span>'
	xCabecalho := StrTran(xCabecalho,'Email:','Email: <span style="font-weight: bold;">'+CHK1->A1_EMAIL1)+'</span>'

	If CHK1->E1_NATUREZ == '101005'	// Natureza Deposito
		xCabecalho := StrTran(xCabecalho,'caso n&atilde;o tenha recebido o boleto referente aos titulos apresentados, favor entrar em contato com nosso departamento financeiro imediatamente.','<span style="font-weight: bold;">seguem nossos dados bancarios para pagamento: Banco do Brasil - Agencia: 3222 - Conta: 101517-6 ')+'</span> '
	Endif

	xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
	xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
	xRodape := StrTran(xRodape,'Operador:','Operador: <span style="font-weight: bold;">'+Capital(cNomRespo))+'</span>'
	
	cEmailFinan := CHK1->A1_EMAIL1

	If Empty(CHK1->A1_EMAIL1)
		CHK1->(dbSkip(1));Loop
	Endif

	While CHK1->(!Eof()) .And. CHK1->A1_COD == cCliente .And. CHK1->A1_LOJA == cLoja
		xItens  +=  '    <tr>'
		xItens	+=	'      <td style="text-align: center;">'+CHK1->E1_PREFIXO+' '+CHK1->E1_NUM+' '+CHK1->E1_PARCELA+'</td>'
		xItens	+=	'      <td style="text-align: center;">'+DtoC(CHK1->E1_EMISSAO)+'</td>'
		xItens	+=	'      <td style="text-align: center;">'+DtoC(CHK1->E1_VENCREA)+'</td>'
		xItens	+=	'      <td style="text-align: right;">'+TransForm(CHK1->E1_SALDO,'@E 9,999,999.99')+'</td>'
		xItens  +=  '    </tr>'
		
		CHK1->(dbSkip(1))
	Enddo

	WrkAviFin(cNomRespo,cEmailFinan,'Aviso de Duplicata(s) Pendente(s) ',xCabecalho+xItens+xRodape)

Enddo

CHK1->(dbCloseArea())

// Processamento de Encerramento automatico para contratos de parceria com vigencia vencida

If cEmpAnt == '01'	// apenas Metalacre
	
	cNomRespo := 'Automatico'//UsrFullName(__cUserId)
	cEmaRespo := 'automatico@metalacre.com.br'//UsrRetMail(__cUserId)
	
	cQuery := 	 " SELECT ADA.ADA_NUMCTR, ADA.ADA_CODCLI, ADA.ADA_LOJCLI,  ADA.ADA_CLIMTS, ADA.ADA_VIGINI, ADA.ADA_VIGFIM "
	cQuery +=	 " FROM " + RetSqlName("ADA") + " ADA (NOLOCK) "
	cQuery +=	 " WHERE ADA.ADA_STATUS NOT IN('E','D','X','Y') "
	cQuery +=	 " AND ADA.ADA_VIGFIM < '" + Dtos(Date()) + "' "
	cQuery +=	 " AND ADA.D_E_L_E_T_ = '' "
	cQuery +=	 " ORDER BY ADA.ADA_NUMCTR "
	
	TCQUERY cQuery NEW ALIAS "CHK1"
		
	TcSetField('CHK1','ADA_VIGINI','D')
	TcSetField('CHK1','ADA_VIGFIM','D')
	
	cEmail := ''
	aCtrVend := {}
	While CHK1->(!Eof())
		If ADA->(dbSetOrder(1), dbSeek(xFilial("ADA")+CHK1->ADA_NUMCTR))
			If RecLock("ADA",.f.)
				ADA->ADA_STATUS	:=	'Y'
				ADA->(MsUnlock())
			Endif
		          
		
			cEmail	+=	'Contrato No.: ' + ADA->ADA_NUMCTR
			
			cEmail += ' Vigencia Inicial: ' + DtoC(ADA->ADA_VIGINI) + " Vigencia Final: " + DtoC(ADA->ADA_VIGFIM) 
			cEmail += ' Contrato Cliente: ' + ADA->ADA_XCONTR + ' Cliente: '

			If !Empty(ADA->ADA_CLIMTS)
				SA1->(dbSetOrder(1), dbSeek(xFilial("ADA")+ADA->ADA_CLIMTS+ADA->ADA_LOJMTS))
				
				cEmail += SA1->A1_NOME
				cNome  := SA1->A1_NOME
			Else
				SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+ADA->ADA_CODCLI+ADA->ADA_LOJCLI))
				
				cEmail += SA1->A1_NOME
				cNome  := SA1->A1_NOME
			Endif
			
			AAdd(aCtrVend,{ADA->ADA_VEND1,;
							ADA->ADA_NUMCTR,;
							DtoC(ADA->ADA_VIGINI),;
							DtoC(ADA->ADA_VIGFIM),;
							cNome,;
							ADA->ADA_XCONTR})
			cEmail += CRLF
		Endif
	
		CHK1->(dbSkip(1))
	Enddo
	If !Empty(cEmail)
		cEmail += CRLF + CRLF
		cEmail += 'Os Seguintes contratos foram Encerrados automaticamente pelo Sistema, em ' + DtoC(Date()) + ' as ' + Time()
		
		cRespo := GetNewPar('MV_USMCTR','jose.sousa@metalacre.com.br;paulo.morsani@metalacre.com.br;marcelo.carlis@metalacre.com.br;lalberto@3lsystems.com.br')
		
		WrkAviFin(cNomRespo,cRespo,'Aviso de Encerramento de Contratos com VigÍncia Vencida',cEmail,.t.)
		
		aSort(aCtrVend,,, {|x, y| x[1] < y[1]})
		
		nVend := 1
		While nVend <= Len(aCtrVend)
			
			cTxt := ''
			cVend := aCtrVend[nVend,1]
			
			While cVend==aCtrVend[nVend,1]
				cTxt += 'Contrato No.: ' + aCtrVend[nVend,2]
				cTxt += ' Vigencia Inicial: ' + aCtrVend[nVend,3] + " Vigencia Final: " + aCtrVend[nVend,4]
				cTxt += ' Contrato Cliente: ' + aCtrVend[nVend,6] + ' Cliente: ' + aCtrVend[nVend,5]
				cTxt += CRLF
				
				nVend++
				If nVend > Len(aCtrVend)
					Exit
				Endif
			Enddo

			If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend)) .And. !Empty(SA3->A3_EMAIL) .And. !Empty(cTxt)
				cTxt += CRLF + CRLF
				cTxt += 'AtenÁ„o Seus Respectivos Contratos Foram Encerrados Automaticamente Pelo Sistema, em ' + DtoC(Date()) + ' as ' + Time()

				WrkAviFin(cNomRespo,SA3->A3_EMAIL,'Aviso de Encerramento de Contratos com VigÍncia Vencida',cTxt,.t.)
			Endif

			If nVend > Len(aCtrVend)
				Exit
			Endif
		Enddo
	Endif
	
	CHK1->(dbCloseArea())
Endif

RestArea(aArea)
Return


Static Function WrkAviFin(cNomRespo,cEmaRespo,cAssunto,mCorpo,lContrato)
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
						Help(" ",1,'Erro no Envio do Email',,cError+ " " + cPara,4,5)	//AtenÁ„o
					Loop
				Endif
		 		nTenta := 10	// Em Caso de Sucesso sai do Loop
		 		Loop
			Else
				GET MAIL ERROR cError
				Help(" ",1,'AutenticaÁ„o',,cError,4,5)  //"Autenticacao"
				MsgStop('Erro de AutenticaÁ„o','Verifique a conta e a senha para envio') 		 //"Erro de autenticaÁ„o","Verifique a conta e a senha para envio"
			Endif
				
			DISCONNECT SMTP SERVER
			
		Else
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
		Endif
	Next
Return .t.