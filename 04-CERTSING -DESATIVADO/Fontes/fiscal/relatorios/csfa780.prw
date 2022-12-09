//--------------------------------------------------------------------------
// Rotina | CSFA780    | Autor | Robson Gonçalves        | Data | 11.01.2017
//--------------------------------------------------------------------------
// Descr. | Rotina para analisar divergência entre PC e NFE.
//        | Esta rotina é acionada pelo ponto de entrada MT100Grv.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
#Include 'Protheus.ch'

#DEFINE cFONT   '<b><font size="4" color="blue"><b>'
#DEFINE cALERT  '<b><font size="4" color="red"><b>'
#DEFINE cNOFONT '</b></font></b></u>'

Static dDataSE2 := CtoD("  /  /  ")

User Function CSFA780()
	Local aArea := {}
	Local aCond := {}
	Local aUser := {}
	Local cAL_USER := ''
	Local cD1_ITEMPC := ''
	Local cD1_PEDIDO := ''
	Local cEmailAprov := ''
	Local cEmailElab := ''
	Local cFil := ''
	Local cFornec := ''
	Local cMV_780_01 := 'MV_780_01'
	Local cMsg := ''
	Local cMsgAlert := ''
	Local cNomeAprov := ''
	Local cNomeElab := ''
	Local cQuebra := ''
	Local cSQL := ''
	Local cTRB := ''
	Local cUserAtual := ''
	Local lRet := .T.
	Local nD1_ITEMPC := 0
	Local nD1_PEDIDO := 0
	Local nD1_VUNIT := 0
	Local nDELETADO := 0
	Local nLoop := 0
	Local nP := 0
	Local nI := 0
 
	If .NOT. GetMv( cMV_780_01, .T. )
		CriarSX6( cMV_780_01, 'N', 'HABILITAR O USO DA ROTINA CSFA780. 0=DESABILITADO E 1=HABILITADO', '1' )
	Endif
	
	If GetMv( cMV_780_01, .F. ) == 0
		Return( .T. )
	Endif

	aArea := SC7->( GetArea() )

	nD1_PEDIDO := AScan( aHeader, {|e| RTrim( e[ 2 ] ) == 'D1_PEDIDO' } ) 
	nD1_ITEMPC := AScan( aHeader, {|e| RTrim( e[ 2 ] ) == 'D1_ITEMPC' } )
	nD1_VUNIT  := AScan( aHeader, {|e| RTrim( e[ 2 ] ) == 'D1_VUNIT' } )
	nDELETADO  := Len( aCOLS[ 1 ] )
	
	dbSelectArea( 'SC7' )
	dbSetOrder( 14 )
	
	For nLoop := 1 To Len( aCOLS )
		If .NOT. aCOLS[ nLoop, nDELETADO ]
			cD1_PEDIDO := aCOLS[ nLoop, nD1_PEDIDO ]
			cD1_ITEMPC := aCOLS[ nLoop, nD1_ITEMPC ]		
			
			IF SC7->( dbSeek( xFilEnt( xFilial( 'SC7' ) ) + cD1_PEDIDO + cD1_ITEMPC ) )
			
				If SC7->C7_PRECO < aCOLS[ nLoop, nD1_VUNIT ] .AND. SC7->C7_MOEDA == 1
					cMsg := 'O valor unitário informado no documento de entrada está maior que o valor unitário do pedido de compras.'
				Endif
							
				nP := AScan( aCond, {|e| e == SC7->C7_COND } )
				If nP == 0
					AAdd( aCond, SC7->C7_COND )
					nP := Len( aCond )
				Endif
			ENDIF	
		Endif
	Next nLoop
	
	If Len( aCond ) > 1
		If cMsg <> ''
			cMsg := cMsg + '<br>'
		Endif
		cMsg += 'Existem códigos de condição de pagamento diferente entre os itens do documento fiscal.'
	Endif
	
	If Len( aCond ) > 0 .AND. cCondicao < aCond[ 1 ] 
		If cMsg <> ''
			cMsg := cMsg + '<br>'
		Endif
		cMsg += 'O código ('+cCondicao+') da condição de pagamento do documento de entrada está menor do código ('+aCond[1]+') do pedido de compras.'
	Endif
	
	If SF1->F1_DOC == cNFiscal     .AND. ;
	   SF1->F1_SERIE == cSerie     .AND. ;
	   SF1->F1_FORNECE == cA100For .AND. ;
	   SF1->F1_TIPO == cTipo       .AND. ; 
	   .NOT. Empty( cMsg )
	   
	   PswOrder( 1 )
	   
	   PswSeek( SC7->C7_USER )
	   aUser := PswRet( 1 )
	   
	   cEmailElab := aUser[ 1, 14 ]
	   cNomeElab := aUser[ 1, 4 ]
	   nP := At(' ', cNomeElab )
	   cNomeElab := Iif( nP > 0, Capital( SubStr( cNomeElab, 1, nP-1 ) ), cNomeElab )	
	   
		cSQL := "SELECT AL_USER "
		cSQL += "FROM   "+RETSQLNAME("CTT")+" CTT "
		cSQL += "       INNER JOIN "+RETSQLNAME("SAL")+" SAL "
		cSQL += "               ON AL_FILIAL = "+VALTOSQL(xFilial("SAL"))+" " 
		cSQL += "                  AND AL_COD = CTT_GARFIX "
		cSQL += "                  AND AL_NIVEL = '01' "
		cSQL += "                  AND SAL.D_E_L_E_T_ = ' ' " 
		cSQL += "WHERE  CTT_FILIAL = "+VALTOSQL(xFilial("CTT"))+" "
		cSQL += "       AND CTT_CUSTO = "+VALTOSQL(SC7->C7_CCAPROV)+" "
		cSQL += "       AND CTT.D_E_L_E_T_ = ' ' "
		cSQL := ChangeQuery( cSQL )
		cTRB := GetNextAlias()
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
		cAL_USER := (cTRB)->AL_USER
	   (cTRB)->(dbCloseArea())
	   
	   PswSeek( cAL_USER )
	   aUser := PswRet( 1 )
	   cEmailAprov := aUser[ 1, 14 ]
	   cNomeAprov := aUser[ 1, 4 ]
	   nP := At(' ', cNomeAprov )
	   cNomeAprov := Iif( nP > 0, Capital( SubStr( cNomeAprov, 1, nP-1 ) ), cNomeAprov )	
	   
	   PswSeek( __cUserID )
	   aUser := PswRet( 1 )
	   cUserAtual := aUser[ 1, 4 ]
	   nP := At(' ', cUserAtual )
	   cUserAtual := Iif( nP > 0, Capital( SubStr( cUserAtual, 1, nP-1 ) ), cUserAtual )
	   
	   SF1->( RecLock( 'SF1', .F. ) )
	   SF1->F1_COND := cCondicao
	   
	   If .NOT. Empty( SF1->F1_LOG )
	   	cQuebra := CRLF + AllTrim( SF1->F1_LOG )
	   Endif
	   
	   SF1->F1_LOG := 'Em ' + Dtoc(dDataBase) + ;
	                  ' as ' + Time() + ;
	                  ' o usuário ' + cUserAtual + ;
	                  ' tentou classificar a NF e não foi possível, motivo: ' + cMsg + ;
	                  ' logo será enviado e-mail de aviso para o elaborador do pedido ' + cNomeElab + ;
	                  ' e para aprovador ' + cNomeAprov + '.' + cQuebra 
	   SF1->( MsUnLock() )
	   
	   SD1->( dbSetOrder( 1 ) )
	   For nI := 1 To Len( aCOLS )
	   	If .NOT. aCOLS[ nI, Len( aHeader ) + 1 ]
	   		If SD1->( dbSeek( xFilial( 'SD1' ) + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_TIPO + ; 
	   			aCOLS[ nI, GdFieldPos('D1_COD') ] + aCOLS[ nI, GdFieldPos('D1_ITEM') ] ) ) )
	   			SD1->( RecLock( 'SD1', .F. ) )
	   			SD1->D1_TES := aCOLS[ nI, GdFieldPos('D1_TES') ]
	   			SD1->D1_CF  := aCOLS[ nI, GdFieldPos('D1_CF') ]
	   			SD1->( MsUnLock() )
	   		Endif
	   	Endif
	   Next nI
	   
	   If cMsg <> ''
	   	lRet := .F.
		   cFornec := SC7->C7_FORNECE+'-'+SC7->C7_LOJA+' '+SA2->(Posicione('SA2',1,xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA ),'A2_NOME')) 
		   cFil := SC7->C7_FILIAL + '-' + RTrim( SM0->M0_FILIAL )
		   
		   // Enviar e-mail para o elaborador.
			If .NOT. Empty( cEMailElab )
		   	A780EMail( cNomeElab, cEMailElab, SC7->C7_FILIAL + '-' + SC7->C7_NUM, SF1->F1_DOC, cFornec, cFil, cMsg )
		   Endif
		   
		   // Enviar e-mail para o aprovador.
		   If .NOT. Empty( cEMailAprov )
		   	A780EMail( cNomeAprov, cEMailAprov, SC7->C7_FILIAL + '-' + SC7->C7_NUM, SF1->F1_DOC, cFornec, cFil, cMsg )
		   Endif
		   
		   cMsgAlert := cALERT+'ATENÇÃO' + '<br>'
		   cMsgAlert += cFONT +'Existe(m) divergência(s) na classificação deste documento fiscal. ' + '<br>'
		   cMsgAlert += cFONT +'A divergência é: ' + cALERT + cMsg + '<br>'
		   
		   If .NOT. Empty( cEMailElab )
		   	cMsgAlert += cFONT + 'Foi enviado e-mail para o elaborador do PC ' + cNomeElab
		   Endif
		   
		   If .NOT. Empty( cEMailAprov )
		   	cMsgAlert += cFONT + ' e para o aprovador da despesa ' + cNomeAprov
		   Endif
		   
		   cMsgAlert += '.' + cNOFONT
		   
		   MsgAlert( cMsgAlert, 'Divergência PC x NFE' )
	   Endif 
	Endif
	
	//Renato Ruy - 19/12/2017
	//OTRS: 2017120610002165  
	//Enviar notificação na classificação pré nota
	If lRet
		U_CSFA780A()
	Endif
	
	RestArea( aArea )
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A780EMail  | Autor | Robson Gonçalves        | Data | 11.01.2017
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para elaborar e enviar e-mail.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A780EMail( cNome, cEmail, cPedido, cDoc, cFornec, cFil, cDiverg )
	Local cHTML := ''

	cHTML := '<!doctype html>'
	cHTML += '<html>'
	cHTML += '	<head>'
	cHTML += '		<meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type" />'
	cHTML += '		<title>Certisign</title>'
	cHTML += '	</head>'
	cHTML += '	<body>'
	cHTML += '		<table align="center" bgcolor="#F0F0F0" border="0" cellpadding="0" cellspacing="0" width="600px">'
	cHTML += '			<tbody>'
	cHTML += '				<tr>'
	cHTML += '					<td>'
	cHTML += '						<img alt="" height="69" src="http://www.comunicacaocertisign.com.br/mensagerias/topo.jpg" style="border:none; display:block" width="600" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td>'
	cHTML += '						<table border="0" cellpadding="0" cellspacing="0" width="100%">'
	cHTML += '							<tbody>'
	cHTML += '								<tr>'
	cHTML += '									<td style="width:30px" width="30">'
	cHTML += '										&nbsp;</td>'
	cHTML += '									<td>'
	cHTML += '										<table border="0" cellpadding="0" cellspacing="0" width="100%">'
	cHTML += '											<tbody>'
	cHTML += '												<tr>'
	cHTML += '													<td style="text-align: left; vertical-align: top;">'
	cHTML += '														<p style="font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color: #515151;">'
	cHTML += '															<span style="font-size:20px;"><b style="color: rgb(0, 79, 159);">Notifica&ccedil;&atilde;o de diverg&ecirc;ncia do PC x Doc. Fiscal</b></span></p>'
	cHTML += '														<hr />'
	cHTML += '														<p>'
	cHTML += '															<span style="font-size:14px;"><span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century;">Sr.(a) '+cNome+'</span></span><br />'
	cHTML += '															<br />'
	cHTML += '															<span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Este e-mail &eacute; para inform&aacute;-lo que ao registrar o documento fiscal foi identificado diverg&ecirc;ncia. Por favor, entre em contato com a &aacute;rea FISCAL para regularizar.</span></p>'
	cHTML += '														<p>'
	cHTML += '															<span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;"><strong>Pedido de compras:</strong>&nbsp;'+cPedido+'</span><br />'
	cHTML += '															<strong style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Documento fiscal:</strong><span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">&nbsp;'+cDoc+'</span><br />'
	cHTML += '															<strong style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Fornecedor:</strong><span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">&nbsp;'+cFornec+'</span><br />'
	cHTML += '															<span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;"><strong>Filial do sistema:</strong>&nbsp;'+cFil+'</span><br />'
	cHTML += '															<strong style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Diverg&ecirc;ncia: </strong><span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">'+cDiverg+'</span></p>'
	cHTML += '													</td>'
	cHTML += '												</tr>'
	cHTML += '												<tr>'
	cHTML += '													<td>'
	cHTML += '														<br />'
	cHTML += '														<hr />'
	cHTML += '													</td>'
	cHTML += '												</tr>'
	cHTML += '												<!--rodape-->'
	cHTML += '												<tr>'
	cHTML += '													<td>'
	cHTML += '														<table border="0" cellpadding="0" cellspacing="0" width="100%">'
	cHTML += '															<tbody>'
	cHTML += '																<tr>'
	cHTML += '																	<td width="55%">'
	cHTML += '																		<table border="0" cellpadding="0" cellspacing="0" width="100%">'
	cHTML += '																			<tbody>'
	cHTML += '																				<tr>'
	cHTML += '																					<td width="20%">'
	cHTML += '																						<img alt="" height="64" src="http://www.comunicacaocertisign.com.br/mensagerias/sign.jpg" style="border:none; display:block" width="63" /></td>'
	cHTML += '																					<td width="80%">'
	cHTML += '																						<p style="font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color: #004f9f;">'
	cHTML += '																							<span style="font-size:14px;"><b>Aten&ccedil;&atilde;o</b></span><br />'
	cHTML += '																							<span style="font-size:12px;">Esta mensagem foi gerada e enviada<br />'
	cHTML += '																							automaticamente, n&atilde;o responda a<br />'
	cHTML += '																							este e-mail.</span></p>'
	cHTML += '																					</td>'
	cHTML += '																				</tr>'
	cHTML += '																			</tbody>'
	cHTML += '																		</table>'
	cHTML += '																	</td>'
	cHTML += '																	<td width="45%">'
	cHTML += '																		<br />'
	cHTML += '																		<span style="font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color: #004f9f;"><span style="color:#EF7D00">Certisign</span>, a sua identidade na rede</span>'
	cHTML += '																		<table border="0" cellpadding="0" cellspacing="0" width="98%">'
	cHTML += '																			<tbody>'
	cHTML += '																				<tr>'
	cHTML += '																					<td>'
	cHTML += '																						<a href="http://www.linkedin.com/company/certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/in.jpg" style="border:none; display:block" width="43" /></a></td>'
	cHTML += '																					<td>'
	cHTML += '																						<a href="http://twitter.com/certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/twi.jpg" style="border:none; display:block" width="43" /></a></td>'
	cHTML += '																					<td>'
	cHTML += '																						<a href="http://www.facebook.com/Certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/face.jpg" style="border:none; display:block" width="43" /></a></td>'
	cHTML += '																					<td>'
	cHTML += '																						<a href="http://www.youtube.com/user/mktcertisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/you.jpg" style="border:none; display:block" width="43" /></a></td>'
	cHTML += '																					<td>'
	cHTML += '																						<a href="http://www.certisignexplica.com.br" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/blog.jpg" style="border:none; display:block" width="43" /></a></td>'
	cHTML += '																				</tr>'
	cHTML += '																			</tbody>'
	cHTML += '																		</table>'
	cHTML += '																	</td>'
	cHTML += '																</tr>'
	cHTML += '															</tbody>'
	cHTML += '														</table>'
	cHTML += '													</td>'
	cHTML += '												</tr>'
	cHTML += '												<tr>'
	cHTML += '													<td>'
	cHTML += '														&nbsp;</td>'
	cHTML += '												</tr>'
	cHTML += '											</tbody>'
	cHTML += '										</table>'
	cHTML += '									</td>'
	cHTML += '									<td style="width:30px" width="30">'
	cHTML += '										<p>'
	cHTML += '											&nbsp;</p>'
	cHTML += '									</td>'
	cHTML += '								</tr>'
	cHTML += '							</tbody>'
	cHTML += '						</table>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '			</tbody>'
	cHTML += '		</table>'
	cHTML += '		<p>'
	cHTML += '			&nbsp;</p>'
	cHTML += '	</body>'
	cHTML += '</html>'
	FSSendMail( cEMail, 'Divergência PC x Doc.Fiscal', cHTML, /*cAnexo*/ )
Return

//-----------------------------------------------------------------------
// Rotina | UPD780     | Autor | Robson Gonçalves     | Data | 11.01.2016
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD780()
	Local cModulo := 'COM'
	Local bPrepar := {|| U_U780Ini() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//-----------------------------------------------------------------------
// Rotina | U780Ini    | Autor | Robson Gonçalves     | Data | 11.01.2016
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U780Ini()
	aSX3 := {}
	AAdd(aSX3,{"SF1",NIL,"F1_LOG","M",10,0 ,"Log" ,"Log" ,"Log", "Log", "Log", "Log", "@!", "", "€€€€€€€€€€€€€€ ","","",0,"þA","","","U","N","V","R","","","","","","","","","","","","","","","N","N","",""})
Return

//--------------------------------------------------------------------------
// Rotina | CSFA780A   | Autor | Robson Gonçalves        | Data | 24.01.2017
//--------------------------------------------------------------------------
// Descr. | Rotina para enviar e-mail para o elaborador quando a NFE for
//        | registrada sem nenhuma critica.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA780A()
	Local cFil := ''
	Local cFornec := ''
	Local cMV_780_02 := 'MV_780_02'
	Local cNomeElab := ''
	Local cTRB := ''
	Local cE2_EMISSAO := ''
	
	Local nDELETADO := 0
	Local nD1_ITEMPC := 0
	Local nD1_PEDIDO := 0
	Local nI := 0

	Local aArea := {}
	Local aElab := {}
	Local aUser := {}
	Local aDupl := {}
	
	If .NOT. GetMv( cMV_780_02, .T. )
		CriarSX6( cMV_780_02, 'N', 'HABILITAR O USO DA ROTINA CSFA780A. 0=DESABILITADO E 1=HABILITADO', '1' )
	Endif
	
	If GetMv( cMV_780_02, .F. ) == 0
		Return( .T. )
	Endif
	
	aArea := { GetArea(), SC7->( GetArea() ) }
	
	nD1_PEDIDO := AScan( aHeader, {|e| RTrim( e[ 2 ] ) == 'D1_PEDIDO' } ) 
	nD1_ITEMPC := AScan( aHeader, {|e| RTrim( e[ 2 ] ) == 'D1_ITEMPC' } )
	nDELETADO  := Len( aCOLS[ 1 ] )

	dbSelectArea( 'SC7' )
	dbSetOrder( 14 )

	For nI := 1 To Len( aCOLS )
		If .NOT. aCOLS[ nI, nDELETADO ]
			If SC7->( dbSeek( xFilial( 'SC7' ) + aCOLS[ nI, nD1_PEDIDO ] + aCOLS[ nI, nD1_ITEMPC ] ) )
				nP := AScan( aElab, {|e| e[1]==SC7->C7_USER } )
				If nP == 0
					cFornec := SC7->C7_FORNECE+'-'+SC7->C7_LOJA+' '+SA2->(Posicione('SA2',1,xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA ),'A2_NOME'))
					cFil := SC7->C7_FILIAL + '-' + RTrim( SM0->M0_FILIAL )
					AAdd( aElab, { SC7->C7_USER, '', '', SC7->(C7_FILIAL+'-'+C7_NUM), SF1->F1_DOC, cFornec, cFil } )
				Endif 
			Endif
		Endif 
	Next 
	
	PswOrder( 1 )
	For nI := 1 To Len( aElab )
		PswSeek( aElab[ nI, 1 ] )
   	aUser := PswRet( 1 )
   	cNomeElab := aUser[ 1, 4 ]
   	nP := At(' ', cNomeElab )
   	aElab[ nI, 2 ] := Iif( nP > 0, Capital( SubStr( cNomeElab, 1, nP-1 ) ), cNomeElab )	
		aElab[ nI, 3 ] := aUser[ 1, 14 ]
	Next nI
	
	cTRB := GetNextAlias()
	BEGINSQL ALIAS cTRB
		SELECT E2_VENCTO 
		FROM   %Table:SE2% SE2 
		WHERE  E2_FILIAL = %xFilial:SE2%
		       AND E2_NUM = %Exp:SF1->F1_DOC%
		       AND E2_PREFIXO = %Exp:SF1->F1_PREFIXO% 
		       AND E2_FORNECE = %Exp:SF1->F1_FORNECE%
		       AND E2_LOJA = %Exp:SF1->F1_LOJA%
		       AND SE2.%NotDel%
		ORDER  BY 1 
	ENDSQL
	cE2_EMISSAO := Dtoc( Stod( (cTRB)->E2_VENCTO ) )
	(cTRB)->( dbCloseArea())
	
	AEval( aArea, {|xArea| RestArea( xArea ) } )
	
	For nI := 1 To Len( aElab )
		cHTML := '<!doctype html>'
		cHTML += '<html>'
		cHTML += '<head>'
		cHTML += '	<meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type" />'
		cHTML += '	<title>Certisign</title>'
		cHTML += '</head>'
		cHTML += '<body>'
		cHTML += '<table align="center" bgcolor="#F0F0F0" border="0" cellpadding="0" cellspacing="0" width="600px">'
		cHTML += '	<tbody>'
		cHTML += '	<tr>'
		cHTML += '		<td>'
		cHTML += '			<img alt="" height="69" src="http://www.comunicacaocertisign.com.br/mensagerias/topo.jpg" style="border:none; display:block" width="600" /></td>'
		cHTML += '	</tr>'
		cHTML += '	<tr>'
		cHTML += '		<td>'
		cHTML += '			<table border="0" cellpadding="0" cellspacing="0" width="100%">'
		cHTML += '				<tbody>'
		cHTML += '					<tr>'
		cHTML += '						<td style="width:30px" width="30">'
		cHTML += '							&nbsp;</td>'
		cHTML += '						<td>'
		cHTML += '							<table border="0" cellpadding="0" cellspacing="0" width="100%">'
		cHTML += '								<tbody>'
		cHTML += '									<tr>'
		cHTML += '										<td style="text-align: left; vertical-align: top;">'
		cHTML += '											<p style="font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color: #515151;">'
		cHTML += '												<span style="font-size:20px;"><b style="color: rgb(0, 79, 159);">Documento fiscal registrado</b></span></p>'
		cHTML += '											<hr />'
		cHTML += '											<p>'
		cHTML += '												<span style="font-size:14px;"><span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century;">Sr.(a) '+aElab[nI,2]+'</span></span><br />'
		cHTML += '												<br />'
		cHTML += '												<span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Este e-mail &eacute; para inform&aacute;-lo que o documento fiscal foi registrado.</span></p>'
		cHTML += '											<p>'
		cHTML += '												<span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;"><strong>Pedido de compras:</strong>&nbsp;'+aElab[nI,4]+'</span><br />'
		cHTML += '												<strong style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Documento fiscal:</strong><span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">&nbsp;'+aElab[nI,5]+'</span><br />'
		cHTML += '												<strong style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Fornecedor:</strong><span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">&nbsp;'+aElab[nI,6]+'</span><br />'
		cHTML += '												<span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;"><strong>Filial do sistema:</strong>&nbsp;'+aElab[nI,7]+'</span><br />'
		//cHTML += '												<span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;"><strong>Pagto Previsto para:</strong>&nbsp;'+cE2_EMISSAO+'</span></p>'
		cHTML += '												<span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;"><strong>Pagto Previsto para:</strong>&nbsp;'+DtoC(dDataSE2)+'</span></p>'
		cHTML += '										</td>'
		cHTML += '									</tr>'
		cHTML += '									<tr>'
		cHTML += '										<td>'
		cHTML += '											<br />'
		cHTML += '											<hr />'
		cHTML += '										</td>'
		cHTML += '									</tr>'
		cHTML += '									<!--rodape-->'
		cHTML += '									<tr>'
		cHTML += '										<td>'
		cHTML += '											<table border="0" cellpadding="0" cellspacing="0" width="100%">'
		cHTML += '												<tbody>'
		cHTML += '													<tr>'
		cHTML += '														<td width="55%">'
		cHTML += '															<table border="0" cellpadding="0" cellspacing="0" width="100%">'
		cHTML += '																<tbody>'
		cHTML += '																	<tr>'
		cHTML += '																		<td width="20%">'
		cHTML += '																			<img alt="" height="64" src="http://www.comunicacaocertisign.com.br/mensagerias/sign.jpg" style="border:none; display:block" width="63" /></td>'
		cHTML += '																		<td width="80%">'
		cHTML += '																			<p style="font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color: #004f9f;">'
		cHTML += '																				<span style="font-size:14px;"><b>Aten&ccedil;&atilde;o</b></span><br />'
		cHTML += '																				<span style="font-size:12px;">Esta mensagem foi gerada e enviada<br />'
		cHTML += '																				automaticamente, n&atilde;o responda a<br />'
		cHTML += '																				este e-mail.</span></p>'
		cHTML += '																		</td>'
		cHTML += '																	</tr>'
		cHTML += '																</tbody>'
		cHTML += '															</table>'
		cHTML += '														</td>'
		cHTML += '														<td width="45%">'
		cHTML += '															<br />'
		cHTML += '															<span style="font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 16px; color: #004f9f;"><span style="color:#EF7D00">Certisign</span>, a sua identidade na rede</span>'
		cHTML += '															<table border="0" cellpadding="0" cellspacing="0" width="98%">'
		cHTML += '																<tbody>'
		cHTML += '																	<tr>'
		cHTML += '																		<td>'
		cHTML += '																			<a href="http://www.linkedin.com/company/certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/in.jpg" style="border:none; display:block" width="43" /></a></td>'
		cHTML += '																		<td>'
		cHTML += '																			<a href="http://twitter.com/certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/twi.jpg" style="border:none; display:block" width="43" /></a></td>'
		cHTML += '																		<td>'
		cHTML += '																			<a href="http://www.facebook.com/Certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/face.jpg" style="border:none; display:block" width="43" /></a></td>'
		cHTML += '																		<td>'
		cHTML += '																			<a href="http://www.youtube.com/user/mktcertisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/you.jpg" style="border:none; display:block" width="43" /></a></td>'
		cHTML += '																		<td>'
		cHTML += '																			<a href="http://www.certisignexplica.com.br" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/blog.jpg" style="border:none; display:block" width="43" /></a></td>'
		cHTML += '																	</tr>'
		cHTML += '																</tbody>'
		cHTML += '															</table>'
		cHTML += '														</td>'
		cHTML += '													</tr>'
		cHTML += '												</tbody>'
		cHTML += '											</table>'
		cHTML += '										</td>'
		cHTML += '									</tr>'
		cHTML += '									<tr>'
		cHTML += '										<td>'
		cHTML += '											&nbsp;</td>'
		cHTML += '									</tr>'
		cHTML += '								</tbody>'
		cHTML += '							</table>'
		cHTML += '						</td>'
		cHTML += '						<td style="width:30px" width="30">'
		cHTML += '							<p>'
		cHTML += '								&nbsp;</p>'
		cHTML += '						</td>'
		cHTML += '					</tr>'
		cHTML += '				</tbody>'
		cHTML += '			</table>'
		cHTML += '		</td>'
		cHTML += '	</tr>'
		cHTML += '</tbody>'
		cHTML += '</table>'
		cHTML += '<p>'
		cHTML += '	&nbsp;</p>'
		cHTML += '</body>'
		cHTML += '</html>'
		FSSendMail( aElab[nI,3], 'Documento fiscal registrado', cHTML, /*cAnexo*/ )
	Next nI
Return

// Renato Ruy - 20/12/2017 
// Atualiza data de Vencimento
User Function CSFA780D(dDtNova)
	dDataSE2 := dDtNova
Return
