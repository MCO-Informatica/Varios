#Include "totvs.ch"

/*
Renato Ruy - 06/04/2018
Notifica todas os adiantamentos pendentes para Custos Canais e Financeiro.
*/

User Function CRPA051(dDiasVen,aRet2,cPreTit)

Local cHead 	:= ""
Local cFoot 	:= ""
Local cBody 	:= ""
Local nTotal	:= 0
Local lEnviou	:= .F.
Local aRecZZ7	:= {}
Local nTentativas	:= 0
Local aAreaZZ7	:= ZZ7->(GetArea())

Default dDiasVen := dDatabase
Default aRet2	   := {" "}
Default cPreTit	 := Space(TamSX3("ZZ7_PRETIT")[1])

//Cria cabecalho e rodape do modelo de email.
cHead := addhead()
cFoot := addfoot()

While !ZZ7->(EOF()) .And. ZZ7->ZZ7_CODPAR == SZ3->Z3_CODENT .And. ZZ7->ZZ7_PERIOD == ZZ6->ZZ6_PERIOD
    If ZZ7->ZZ7_SALDO > 0 .And. ZZ7->ZZ7_PRETIT == cPreTit
    
    	dDiasVen := dDataBase+Val(RTrim(Posicione("SE4",1,xFilial("SE4")+aRet2[1],"E4_COND")))
    	
    	cBody += '<tr>'
		cBody += '<td><span style="color:#000080;">'+ZZ7->ZZ7_CODPAR+'</span></td>'
		cBody += '<td><span style="color:#000080;">'+AllTrim(SZ3->Z3_DESENT)+'</span></td>'
		cBody += '<td><span style="color:#000080;">'+Transform(ZZ7->ZZ7_VALOR,"@E 999,999,999.99")+'</span></td>'
		cBody += '<td><span style="color:#000080;">'+ZZ7->ZZ7_TITULO+'</span></td>'
		cBody += '<td><span style="color:#000080;">'+SZ3->Z3_CODFOR+'</span></td>'
		cBody += '<td><span style="color:#000080;">'+DtoC(dDiasVen)+'</span></td>'
		cBody += '</tr>'
		
		nTotal += ZZ7->ZZ7_VALOR
		
		ZZ7->(RecLock("ZZ7",.F.))
			ZZ7->ZZ7_SALDO := 0
		ZZ7->(MsUnlock())
		
		aAdd(aRecZZ7, ZZ7->(Recno()))
	EndIf
	ZZ7->(DbSkip())
Enddo

cBody += '<tr>'
cBody += '<td><span style="color:#000080;"></span></td>'
cBody += '<td><span style="color:#000080;">VALOR TOTAL</span></td>'
cBody += '<td><span style="color:#000080;">'+Transform(nTotal,"@E 999,999,999.99")+'</span></td>'
cBody += '<td><span style="color:#000080;"></span></td>'
cBody += '<td><span style="color:#000080;"></span></td>'
cBody += '<td><span style="color:#000080;"></span></td>'
cBody += '</tr>'

//Yuri Volpe - 21.08.2019
//Melhoria para controle do envio de mensagens
While !lEnviou .And. nTentativas <= 3

	lEnviou := FSSendMail( ;
				AllTrim(GetNewPar("MV_XCRPA51", "custos_canais@certisign.com.br")),; 
				"["+GetEnvServer()+"] - Remuneração de Parceiros - Relacao de Adiantamentos", ;
				cHead+cBody+cFoot )
	Sleep(1000)
	nTentativas++			
EndDo

RestArea(aAreaZZ7)
//ZZ7->(dbGoTo(aRecZZ7[1]))

If ZZ7->(!EoF())
	RecLock("ZZ7",.F.)
		ZZ7->ZZ7_NOTIFI := Iif(lEnviou,"S","N")
		ZZ7->ZZ7_LOGNOT := Iif(lEnviou,;
								"[" + DTOC(Date()) + "-" + Time() + "]: E-mail enviado com sucesso.",;
								"[" + DTOC(Date()) + "-" + Time() + "]: O envio da notificação falhou.") + ZZ7->ZZ7_LOGNOT
	ZZ7->(MsUnlock())
EndIf
		
ConOut("Notificou os usuarios de custos canais dos postos inativos")

Return

Static Function addhead()

Local cHead := ""

cHead += ' <html>																																												 '
cHead += ' 	<head>                                                                                                                                                                               '
cHead += ' 		<title>Adiantamentos de Remuneracao</title>                                                                                                                                              '
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
cHead += ' 												<span style="color:#000080;"><font face="Myriad Pro, Arial, Century"><b>Adiantamentos - Custos Canais</b></font></span></p>     '
cHead += ' 											<hr />                                                                                                                                       '
cHead += ' 											<p>                                                                                                                                          '
cHead += ' 												<font color="#000080"><b>Ol&aacute; Custos Canais!</b></font></p>                                                                        '
cHead += ' 											<p>                                                                                                                                          '
cHead += ' 												<span style="color:#000080;">Segue abaixo o adiantamento a ser compensado no pedido: '+ZZ6->ZZ6_PEDIDO+'.</span></p>     '
cHead += ' 											<table border="0">                                                                                                                           '
cHead += ' 												<thead>                                                                                                                                  '
cHead += ' 													<tr>                                                                                                                                 '
cHead += ' 														<td>                                                                                                                             '
cHead += ' 															<span style="color:#000080;"><b>C&oacute;digo Entidade</b></span></td>                                                       '
cHead += ' 														<td>                                                                                                                             '
cHead += ' 															<span style="color:#000080;"><b>Descri&ccedil;&atilde;o da Entidade</b></span></td>                                          '
cHead += ' 														<td>'
cHead += ' 															<span style="color:#000080;"><b>Valor</b></span></td>'
cHead += ' 														<td>'
cHead += ' 															<span style="color:#000080;"><b>T&iacute;tulo</b></span></td>'
cHead += ' 														<td>'
cHead += ' 															<span style="color:#000080;"><b>Fornecedor</b></span></td>'
cHead += ' 														<td>'
cHead += ' 															<span style="color:#000080;"><b>Dt.Vencimento</b></span></td>'
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