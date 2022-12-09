#Include "totvs.ch"

/*
Renato Ruy - 28/09/2017
Notifica todas as entidades desativadas e que contem quebra por cartorio.
*/

User Function CRPA042()

Local cHead := ""
Local cFoot := ""
Local cBody := ""

//Abre a conexão com a empresa
RpcSetType(3)
RpcSetEnv("01","02")
ConOut("CRPA042 - Inicia Job para notificar ITs desativadas!")

//Cria cabecalho e rodape do modelo de email.
cHead := addhead()
cFoot := addfoot()

//Busca dados para envio de e-mail.
Beginsql Alias "TMPCRT"
	SELECT Z3_CODENT,
	       Z3_DESENT
	FROM %Table:SZ3%
	WHERE
	Z3_FILIAL = %xFilial:SZ3% AND
	Z3_QUEBRA = '2' AND
	Z3_ATIVO = 'N' AND
	%NOTDEL%
Endsql

If TMPCRT->(EOF())
	ConOut("CRPA042 - Não existe IT desativada!")
	Return
Endif

While !TMPCRT->(EOF())

	cBody += '<tr>'
	cBody += '<td>'
	cBody += '<span style="color:#000080;">'+TMPCRT->Z3_CODENT+'</span></td>'
	cBody += '<td>'
	cBody += '	<span style="color:#000080;">'+TMPCRT->Z3_DESENT+'</span></td>'
	cBody += '</tr>'

	TMPCRT->(DbSkip())
Enddo

FSSendMail( ;
			AllTrim(GetNewPar("MV_XNOTREM", "custos_canais@certisign.com.br")),; 
			"["+GetEnvServer()+"] - Remuneração de Parceiros - Relacao de ITs Desativadas", ;
			cHead+cBody+cFoot )

TMPCRT->(DbCloseArea())			
ConOut("Notificou os usuarios de custos canais dos postos inativos")

Return

Static Function addhead()

Local cHead := ""

cHead += ' <html>																																												 '
cHead += ' 	<head>                                                                                                                                                                               '
cHead += ' 		<title>Entidade Remuneracao</title>                                                                                                                                              '
cHead += ' 	</head>                                                                                                                                                                              '
cHead += ' 	<body>                                                                                                                                                                               '
cHead += ' 		<div style="text-align: left;">                                                                                                                                                  '
cHead += ' 			<table align="center" bgcolor="#F0F0F0" border="0" cellpadding="0" cellspacing="0" style="width: 600px">                                                                     '
cHead += ' 				<tbody>                                                                                                                                                                  '
cHead += ' 					<tr>                                                                                                                                                                 '
cHead += ' 						<td>                                                                                                                                                             '
cHead += ' 							<img alt="" height="69" src="http://www.comunicacaocertisign.com.br/mensagerias/topo.jpg" style="border:none; display:block" width="600px" /></td>           '
cHead += ' 					</tr>                                                                                                                                                                '
cHead += ' 					<tr>                                                                                                                                                                 '
cHead += ' 						<td>                                                                                                                                                             '
cHead += ' 							<table align="center" border="0" cellpadding="0" cellspacing="0" style="width: 598px">                                                                       '
cHead += ' 								<tbody>                                                                                                                                                  '
cHead += ' 									<tr>                                                                                                                                                 '
cHead += ' 										<td style="width: 30px;">                                                                                                                        '
cHead += ' 											&nbsp;</td>                                                                                                                                  '
cHead += ' 										<td>                                                                                                                                             '
cHead += ' 											<p>                                                                                                                                          '
cHead += ' 												<span style="color:#000080;"><font face="Myriad Pro, Arial, Century"><b>Prenchimento de Regras - Custos Canais</b></font></span></p>     '
cHead += ' 											<hr />                                                                                                                                       '
cHead += ' 											<p>                                                                                                                                          '
cHead += ' 												<font color="#000080"><b>Ol&aacute; Custos Canais!</b></font></p>                                                                        '
cHead += ' 											<p>                                                                                                                                          '
cHead += ' 												<span style="color:#000080;">A lista de ITs abaixo deve ser alterada para n&atilde;o quebrar por cart&oacute;rio:</span></p>     '
cHead += ' 											<table border="0">                                                                                                                           '
cHead += ' 												<thead>                                                                                                                                  '
cHead += ' 													<tr>                                                                                                                                 '
cHead += ' 														<td>                                                                                                                             '
cHead += ' 															<span style="color:#000080;"><b>C&oacute;digo Entidade</b></span></td>                                                       '
cHead += ' 														<td>                                                                                                                             '
cHead += ' 															<span style="color:#000080;"><b>Descri&ccedil;&atilde;o da Entidade</b></span></td>                                          '
cHead += ' 													</tr>                                                                                                                                '
cHead += ' 												</thead>                                                                                                                                 '
cHead += ' 												<tbody>                                                                                                                                  '

Return cHead

Static Function addfoot()
Local cFoot := ""

cFoot += '												</tbody																																																										 '
cFoot += '											</table>                                                                                                                                                                                                                                         '
cFoot += '											<p>                                                                                                                                                                                                                                              '
cFoot += '												&nbsp;</p>                                                                                                                                                                                                                                   '
cFoot += '											<hr />                                                                                                                                                                                                                                           '
cFoot += '											<br />                                                                                                                                                                                                                                           '
cFoot += '											<table align="center" border="0" cellpadding="0" cellspacing="0" style="width: 540px">                                                                                                                                                           '
cFoot += '												<tbody>                                                                                                                                                                                                                                      '
cFoot += '													<tr>                                                                                                                                                                                                                                     '
cFoot += '														<td>                                                                                                                                                                                                                                 '
cFoot += '															<table align="center" border="0" cellpadding="0" cellspacing="0" style="width: 270px">                                                                                                                                           '
cFoot += '																<tbody>                                                                                                                                                                                                                      '
cFoot += '																	<tr>                                                                                                                                                                                                                     '
cFoot += '																		<td>                                                                                                                                                                                                                 '
cFoot += '																			<img alt="" height="64" src="http://www.comunicacaocertisign.com.br/mensagerias/sign.jpg" style="border: none; display: block;" width="63" /></td>                                                               '
cFoot += '																		<td style="text-align: center;">                                                                                                                                                                                     '
cFoot += '																			<b style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 12px;">Custos Canais</b></td>                                                                                  '
cFoot += '																	</tr>                                                                                                                                                                                                                    '
cFoot += '																</tbody>                                                                                                                                                                                                                     '
cFoot += '															</table>                                                                                                                                                                                                                         '
cFoot += '														</td>                                                                                                                                                                                                                                '
cFoot += '														<td>                                                                                                                                                                                                                                 '
cFoot += '															<table align="center" border="0" cellpadding="0" cellspacing="0" style="width: 270px">                                                                                                                                           '
cFoot += '																<tbody>                                                                                                                                                                                                                      '
cFoot += '																	<tr>                                                                                                                                                                                                                     '
cFoot += '																		<td>                                                                                                                                                                                                                 '
cFoot += '																			<table align="center" border="0" cellpadding="0" cellspacing="0" style="width: 260px">                                                                                                                           '
cFoot += '																				<tbody>                                                                                                                                                                                                      '
cFoot += '																					<tr>                                                                                                                                                                                                     '
cFoot += '																						<td style="text-align: center;">                                                                                                                                                                     '
cFoot += '																							<br />                                                                                                                                                                                           '
cFoot += '																							<b style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 12px;"><span style="color:#ff8c00;">CERTISIGN</span>, a sua identidade na rede</b><br />       '
cFoot += '																							&nbsp;</td>                                                                                                                                                                                      '
cFoot += '																					</tr>                                                                                                                                                                                                    '
cFoot += '																					<tr>                                                                                                                                                                                                     '
cFoot += '																						<td>                                                                                                                                                                                                 '
cFoot += '																							<table align="center" border="0" cellpadding="0" cellspacing="0" style="width: 268px">                                                                                                           '
cFoot += '																								<tbody>                                                                                                                                                                                      '
cFoot += '																									<tr>                                                                                                                                                                                     '
cFoot += '																										<td>                                                                                                                                                                                 '
cFoot += '																											<a href="http://www.linkedin.com/company/certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/in.jpg" style="border: none; display: block;" width="43" /></a></td>'
cFoot += '																										<td>                                                                                                                                                                                 '
cFoot += '																											<a href="http://twitter.com/certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/twi.jpg" style="border: none; display: block;" width="43" /></a></td>'
cFoot += '																										<td>                                                                                                                                                                                 '
cFoot += '																											<a href="http://www.facebook.com/Certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/face.jpg" style="border: none; display: block;" width="43" /></a></td>'
cFoot += '																										<td>                                                                                                                                                                                 '
cFoot += '																											<a href="http://www.youtube.com/user/mktcertisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/you.jpg" style="border: none; display: block;" width="43" /></a></td>'
cFoot += '																										<td>                                                                                                                                                                                 '
cFoot += '																											<a href="http://www.certisignexplica.com.br" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/blog.jpg" style="border: none; display: block;" width="43" /></a></td>'
cFoot += '																									</tr>                                                                                                                                                                                    '
cFoot += '																								</tbody>                                                                                                                                                                                     '
cFoot += '																							</table>                                                                                                                                                                                         '
cFoot += '																						</td>                                                                                                                                                                                                '
cFoot += '																					</tr>                                                                                                                                                                                                    '
cFoot += '																				</tbody>                                                                                                                                                                                                     '
cFoot += '																			</table>                                                                                                                                                                                                         '
cFoot += '																		</td>                                                                                                                                                                                                                '
cFoot += '																	</tr>                                                                                                                                                                                                                    '
cFoot += '																</tbody>                                                                                                                                                                                                                     '
cFoot += '															</table>                                                                                                                                                                                                                         '
cFoot += '														</td>                                                                                                                                                                                                                                '
cFoot += '													</tr>                                                                                                                                                                                                                                    '
cFoot += '												</tbody>                                                                                                                                                                                                                                     '
cFoot += '											</table>                                                                                                                                                                                                                                         '
cFoot += '											<p>                                                                                                                                                                                                                                              '
cFoot += '												&nbsp;</p>                                                                                                                                                                                                                                   '
cFoot += '											<p>                                                                                                                                                                                                                                              '
cFoot += '												&nbsp;</p>                                                                                                                                                                                                                                   '
cFoot += '										</td>                                                                                                                                                                                                                                                '
cFoot += '										<td style="width: 30px;">                                                                                                                                                                                                                            '
cFoot += '											&nbsp;</td>                                                                                                                                                                                                                                      '
cFoot += '									</tr>                                                                                                                                                                                                                                                    '
cFoot += '								</tbody>                                                                                                                                                                                                                                                     '
cFoot += '							</table>                                                                                                                                                                                                                                                         '
cFoot += '						</td>                                                                                                                                                                                                                                                                '
cFoot += '					</tr>                                                                                                                                                                                                                                                                    '
cFoot += '				</tbody>                                                                                                                                                                                                                                                                     '
cFoot += '			</table>                                                                                                                                                                                                                                                                         '
cFoot += '		</div>                                                                                                                                                                                                                                                                               '
cFoot += '		<p>                                                                                                                                                                                                                                                                                  '
cFoot += '			&nbsp;</p>                                                                                                                                                                                                                                                                       '
cFoot += '		<p>                                                                                                                                                                                                                                                                                  '
cFoot += '			&nbsp;</p>                                                                                                                                                                                                                                                                       '
cFoot += '	</body>                                                                                                                                                                                                                                                                                  '
cFoot += '</html>                                                                                                                                                                                                                                                                                      '
cFoot += '                                                                                                                                                                                                                                                                                             '

Return cFoot