#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'Ap5Mail.ch'
#Include 'TbiConn.ch'

#Define cMSG1 'Prezado(a), '
#Define cMSG2 ', '+CRLF
#Define cMSG3 'Relacionamos abaixo uma lista de solicita็ใo(๕es) de compra(s) pendente(s) de aprova็ใo(๕es).'+CRLF
#Define cMSG4 'Por favor e assim que possํvel, anแlise cada solicita็ใo clicando no link ao lado e efetue a aprova็ใo ou a rejei็ใo de cada solicita็ใo de compra.'
#Define cTITULO_EMAIL 'Aprova็ใo da Solicita็ใo de Compras'
#Define aTITULO_TABELA {'Nบ SC', 'Produto', 'Quantidade', 'Centro Custo', 'Link'} //-- Corpo do email - tabela.
#Define aTYPE_COL {'T', 'T', 'N', 'T', 'A'}
#Define aALIGN_COL {'left', 'left', 'left', 'left', 'left'}

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณCSJB06    บAutor: ณDavid Alves dos Santos บData: ณ13/09/2016 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณFuncao[JOB] que varre a tabela SC1 de solicitacao de compras บฑฑ
ฑฑบ           ณbuscando registros pendentes para aprovacao/rejeicao.        บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CSJB06(aParam)

	Local cQuery       := ""												//-- Consulta SQL.
	Local cTmp         := getNextAlias()								//-- Alias reservado para consulta SQL.
	Local aHeader      := {}												//-- Dados que irao compor o envio do email.
	Local aBody        := {}												//-- Dados que irao compor a tabela do html.
	Local aLogArq      := {}												//-- Array arquivo de log.
	Local cMV_MAIL_ENV := 'MV_720EPAR'									//-- Parametro utilizado para teste de recebimento de e-mail.
	Local cEmailCorp   := 'sistemascorporativos@certisign.com.br'	//-- E-mail do setor de sistemas corporativos.
	Local aChaveSCR    := {}												//-- Array com chaves para atualizar apos email.
	Local _cUser       := ""												//-- Pasta do usuario onde fica o .html
	Local cUserAnte    := ""												//-- Usuario anterior.
	Local cTitArq      := ""												//-- Titulo do arquivo de log. 
	Local cSubTit      := ""												//-- Sub titulo do arquivo de log.
	
	DEFAULT aParam     := {'01', '02'}
		
	//-- Informa o servidor que nao ira consumir licensas.
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2] MODULO 'COM' TABLES 'SCR', 'SC7', 'SA2', 'SAL', 'SAK', 'CND', 'CNE', 'WF6'
		
		//-- Se nao existir o parametro no SX6 ele cria.
		If .Not. GetMv( cMV_MAIL_ENV, .T. )
			CriarSX6( cMV_MAIL_ENV, 'C', 'EMAIL QUE SERA USADA PARA ENVIO DE EMAIL TESTE. EM PRODUCAO DEIXAR VAZIO CSFA720.prw', cEmailCorp )
		EndIf
		cMV_MAIL_ENV := GetMv( cMV_MAIL_ENV, .F. )
		
		//-- Montagem da query.
		cQuery := " SELECT DISTINCT C1.C1_FILIAL, "
		cQuery += "                 C1.C1_NUM, "
		cQuery += "                 C1.C1_CC, "
		cQuery += "                 C1.C1_ITEM, "
		cQuery += "                 CT.CTT_FILIAL, "
		cQuery += "                 CT.CTT_XAPROV, "
		cQuery += "                 AL.AL_FILIAL, "
		cQuery += "                 AL.AL_COD, "
		cQuery += "                 AL.AL_ITEM, "
		cQuery += "                 AL.AL_USER "
		cQuery += " FROM   " + RetSqlName("SC1") + " C1 "
		cQuery += " INNER JOIN " + RetSqlName("CTT") + " CT "
		cQuery += " ON C1.C1_CC = CT.CTT_CUSTO "
		cQuery += " INNER JOIN " + RetSqlName("SAL") + " AL "
		cQuery += " ON CT." + AllTrim(GetMv("MV_710GRAP")) + " = AL.AL_COD "
		cQuery += " WHERE  C1.C1_FILIAL = '" + xFilial("SC1") + "' "
		cQuery += "        AND C1_APROV = 'B' "
		cQuery += "        AND C1_MAIL_ID <> ' ' "
		cQuery += "        AND C1_PEDIDO = ' ' "
		cQuery += "        AND AL.AL_NIVEL = '01' "
		cQuery += "        AND C1.D_E_L_E_T_ = ' ' "
		cQuery += "        AND CT.D_E_L_E_T_ = ' ' "
		cQuery += "        AND AL.D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY  AL.AL_USER, C1.C1_NUM, C1.C1_ITEM "
	
		//-- Monta link para acessar workflow de aprovacao.
		cLink := GetNewPar('MV_XLINKWF', 'http://192.168.16.10:1804/wf/')
		cLink += 'emp'+ cEmpAnt +'/'
		
		//-- Verifica se a tabela esta aberta.
		If Select(cTmp) > 0
			cTmp->(DbCloseArea())				
		EndIf
		
		//-- Execucao da query.
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.F.,.T.)
		
		If (cTmp)->(!EoF())
			
			//-- Varre o resultado da query.
			While (cTmp)->(!EoF())
		
				//-- Se o usuario atual e diferente do usuario anterior.
				If (cTmp)->AL_USER <> cUserAnte
					If Len(aHeader) > 0
						EnvMail(aHeader, aBody, aTYPE_COL, cTITULO_EMAIL, aTITULO_TABELA, aChaveSCR, aALIGN_COL)
						aAdd(aLogArq, {aHeader, aBody})
						aHeader   := {}
						aBody     := {}
						aChaveSCR := {}
					EndIf
								
					aAdd(aHeader, (cTmp)->AL_USER)         														//-- Codigo do usario aprovador.
					aAdd(aHeader, Iif(Empty(cMV_MAIL_ENV), UsrRetMail( (cTmp)->AL_USER ), cMV_MAIL_ENV))	//-- Email do usuario aprovador -- UsrRetMail( (cTmp)->AL_USER ).
					aAdd(aHeader, RTrim(UsrFullName((cTmp)->AL_USER)))											//-- Nome do usuario aprovador.
					aAdd(aHeader, cMSG1 + aHeader[3] + cMSG2 + cMSG3 + cMSG4)									//-- Mensagem titulo.
					aAdd(aHeader, (cTmp)->AL_FILIAL)																//-- Codigo do usario aprovador.				
				EndIf
				
				//-- Retorna o nome completo do usuario.
				_cUser := StrTran(StrTran(UsrRetName((cTmp)->AL_USER),'.',''),'\','')
										
				DbSelectArea("SC1")
				DbSetOrder(1)
				SC1->(DbSeek(xFilial("SC1") + (cTmp)->C1_NUM + (cTmp)->C1_ITEM))
				
				//-- Conteudo da linha.
				aAdd(aBody, {	(cTmp)->C1_NUM,;	
								SC1->C1_DESCRI,;
								SC1->C1_QUANT,;
								SC1->C1_CC,;
								cLink + _cUser + '/' + SC1->C1_MAIL_ID + '.htm', SC1->C1_FILIAL, SC1->C1_ITEM } )			
				
				cUserAnte := (cTmp)->AL_USER
			
				(cTmp)->(DbSkip())
			EndDo
		
			aAdd(aLogArq, {aHeader, aBody})
			EnvMail(aHeader, aBody, aTYPE_COL, cTITULO_EMAIL, aTITULO_TABELA, aChaveSCR, aALIGN_COL)
			
			cTitArq := '| ******** WORKFLOW DE LISTA DE PENDENCIA DE SOLICITAวรO DE COMPRA EM: ' + Dtoc(Date()) + ' AS ' + Time() + ' ******** |'
			cSubTit := 'FILIAL_Nบ SC_____APROVADOR______________PRODUTO_________________________EMAIL ENVIADO_________________'
			
			u_CSGAqLog(aLogArq, "ascwf", cTitArq, cSubTit)			
		EndIf
	RESET ENVIRONMENT
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณEnvMail   บAutor: ณDavid Alves dos Santos บData: ณ15/09/2016 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณFuncao[JOB] que varre a tabela SC1 de solicitacao de compras บฑฑ
ฑฑบ           ณbuscando registros pendentes para aprovacao/rejeicao.        บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function EnvMail(aHeader, aBody, aTypeCol, cTituloEmail, aTabTitulo, aChaveSCR)
	
	Local nLinha      := 1  //-- Linha do array.
	Local nColuna     := 1  //-- Posicao da coluna no array.
	Local aLinha      := {} //-- Array temporario.
	Local cHtml       := '' //-- Strinf com html.
	Local cUserAnte   := '' //-- Usuario da leitura anterior.
	Local cUserAprov  := '' //-- Usuario aprovador.
	Local cEmailAprov := '' //-- Email do aprovador.
	Local cNomeAprov  := '' //-- Nome do aprovador.
	Local cMsgHTML    := '' //-- Mensagem do email.
	Local cClassLin   := '' //-- Nome da classe que controla linha no html.

	Default cTituloEmail := 'Email enviado pelo Protheus'
	Default aTabTitulo   := Array(Len(aBody))
	
	/******
	 *
	 * Antes de mandar o e-mail para o aprovador, verificar se ้ necessแrio refazer o HTML de aprova็ใo.
	 * Sendo necessแrio, chamar a rotina que faz este processo, modificar o link do e-mail que serแ enviardo e seguir.
	 * Data: 20/09/2018
	 *
	 */
	checkNeed( @aBody )
	
	cUserAprov  := aHeader[1] //-- Codigo do usario aprovador.
	cEmailAprov := aHeader[2] //-- E-mail do usuario aprovador.
	cNomeAprov  := aHeader[3] //-- Nome do usuario aprovador.
	cMsgHTML    := aHeader[4] //-- Mensagem titulo.
	
	//-- Inicia construcao do HTML.  
	cHtml += '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
	cHtml += '<html>'
	cHtml += '<head>'
	cHtml += '		<meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type" />'
	cHtml += '</head>'
	cHtml += '<body>'
	cHtml += '<table align="center" border="0" cellpadding="0" cellspacing="0" width="630">'
	cHtml += '		<tr>'
	cHtml += '			<td align="center">'
	cHtml += '				<table>'
	cHtml += '					<tr>'
	cHtml += '						<td style="align="left">'
	cHtml += '							<em>'
	cHtml += '								<font color="#F4811D" face="Arial, Helvetica, sans-serif" size="5">'
	cHtml += '									<strong>' + cTituloEmail + '</strong>'
	cHtml += '								</font><br />'
	cHtml += '								<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font>'
	cHtml += '							</em>'
	cHtml += '						</td>'
	cHtml += '						<td align="left">'
	cHtml += '							<img  alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" />'
	cHtml += '						</td>'
	cHtml += '					</tr>'  
	cHtml += '					<tr>'
	cHtml += '						<td colspan="2" >'
	cHtml += '							<hr style="border-style: solid; border-width: 10px; color: #F4811D">     '
	cHtml += '						</td>'
	cHtml += '					</tr>'
	cHtml += '				</table>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	cHtml += '		<tr>'
	cHtml += '			<td style="padding:15px;">'                          
	cHtml += '				<p><font color="#333333" face="Arial, Helvetica, sans-serif" size="2">' + cMsgHTML + '</font><br /></p>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	cHtml += '		<tr>'
	cHtml += '			<td  align="center">'
	cHtml += '				<table style="width:100%"  border="0" cellpadding="0" cellspacing="0">'
	cHtml += '					<thead  >'
	cHtml += '						<tr>'
	
	//-- Loop para titulo da tabela.
	For nLinha := 1 To Len(aTabTitulo)
		cHtml += '<th bgcolor="#F4811D" align="' + aALIGN_COL[nLinha] + '" style="padding-left:5px" ><font color="#ffffff face="Arial, Helvetica, sans-serif" size="2">' + Alltrim(aTabTitulo[nLinha]) + '</font></th>' //-- Monta cabecalho da tabela
	Next nLinha
	           
	cHtml += '						</tr>'      
	cHtml += '</thead>'
	
	//-- Loop para informacoes do corpo do email.
	For nLinha := 1 To Len(aBody)
		aLinha := aBody[nLinha]
		
		Iif (cClassLin == 'bgcolor:#DCDCDC', cClassLin := 'bgcolor:#FFF', cClassLin := 'bgcolor:#DCDCDC')
		
		cHtml += '<tr>'
		For nColuna := 1 To Len(aLinha)-2
			If aTypeCol[nColuna] == 'T'
				cHtml += '<td '+cClassLin+' align="' + aALIGN_COL[nColuna] + '"  style="padding-left:5px"><font color="#333333 face="Arial, Helvetica, sans-serif" size="2">' + Alltrim(aLinha[nColuna]) + '</font></td>'										//-- Insere coluna
			ElseIf aTypeCol[nColuna] == 'N'
				cHtml += '<td '+cClassLin+' align="' + aALIGN_COL[nColuna] + '"  style="padding-left:5px"><font color="#333333 face="Arial, Helvetica, sans-serif" size="2">' + cValToChar(aLinha[nColuna]) + '</font></td>'									//-- Insere coluna
			ElseIf aTypeCol[nColuna] == 'A'
				cHtml += '<td '+cClassLin+' align="' + aALIGN_COL[nColuna] + '"  style="padding-left:5px"><font color="#333333 face="Arial, Helvetica, sans-serif" size="2"><a href="' + Alltrim(aLinha[nColuna]) + '">Aprovar / Reprovar</a></font></td>'	//-- Insere coluna
			EndIf
		Next nColuna
		cHtml += '</tr>'
	Next nLinha
	
	cHtml += '				</table>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	cHtml += '		<tr>'
	cHtml += '			<td colspan="3" height=50>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	cHtml += '					<tr>'
	cHtml += '						<td >'
	cHtml += '							<hr style="border-style: solid; border-width: 10px; color: #02519B">     </td>'
	cHtml += '					</tr>'
	cHtml += '					<tr>'
	cHtml += '						<td colspan="2" style="padding:5px" width="0">'
	cHtml += '							<p align="left">'
	cHtml += '								<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
	cHtml += '						</td>'
	cHtml += '					</tr>'
	cHtml += '					</table>'
	cHtml += '</body>'
	cHtml += '</html>'
	
	//-- Funcao para envio de e-mail.
	FsSendMail(cEmailAprov, cTituloEmail, cHtml)

Return

Static Function checkNeed( aBody )
	Local cSQL := ''
	Local cTRB := 'CHKNEED'
	Local lPendParcial := .F.
	
	cSQL := "SELECT SUM(PENDENTE) AS PENDENTE, SUM(APROVADO) AS APROVADO FROM ( "
	
	cSQL += "SELECT COUNT(*) AS PENDENTE, 0 AS APROVADO "
	cSQL += "FROM   "+RetSqlName("SC1")+" SC1a "
	cSQL += "WHERE SC1a.C1_FILIAL = "+ValToSQL(aBody[1,6])+" "
	cSQL += "      AND SC1a.C1_NUM = "+ValToSQL(aBody[1,1])+" "
	cSQL += "      AND SC1a.D_E_L_E_T_ = ' ' "
	cSQL += "      AND SC1a.C1_APROV = 'B' "
	cSQL += "      AND SC1a.C1_MAIL_ID <> ' ' "
	cSQL += "      AND SC1a.C1_RESIDUO <> 'S' "
	cSQL += "      AND SC1a.C1_QUJE = 0 "
	
	cSQL += "UNION "
	
	cSQL += "SELECT 0 AS PENDENTE, COUNT(*) AS APROVADO "
	cSQL += "FROM   "+RetSqlName("SC1")+" SC1b "
	cSQL += "WHERE SC1b.C1_FILIAL = "+ValToSQL(aBody[1,6])+" "
	cSQL += "      AND SC1b.C1_NUM = "+ValToSQL(aBody[1,1])+" "
	cSQL += "      AND SC1b.D_E_L_E_T_ = ' ' "
	cSQL += "      AND SC1b.C1_APROV = 'L' "
	cSQL += "      AND SC1b.C1_MAIL_ID <> ' ' "
	cSQL += "      AND SC1b.C1_RESIDUO <> 'S' "
	cSQL += "      AND SC1b.C1_QUJE = 0 "
	
	cSQL += ") TABELASC1 "
	
	cSQL := ChangeQuery(cSQL)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
	
	If (cTRB)->( .NOT. EOF() )
		If (cTRB)->PENDENTE > 0 .AND. (cTRB)->APROVADO > 0
			lPendParcial := .T.
		Endif
	Endif
	(cTRB)->( dbCloseArea() )
	
	If lPendParcial
		goCreate( aBody[1,6], aBody[1,1], @aBody )
	Endif
Return( lPendParcial )

Static Function goCreate( cFil, cNumSC, aBody )
	Local aArea := {}
	Local cLink := ''
	Local cNewLink := ''
	Local lJobNotify := .T.
	
	Local i := 0
	
	aArea := { SC1->( GetArea() ), CTT->( GetArea() ) }
	
	dbSelectArea('CTT')
	CTT->( dbSetOrder( 1 ) )
	
	dbSelectArea('SC1')
	SC1->( dbSetOrder( 1 ) )
	SC1->( dbSeek( cFil + cNumSC ) )
	
	U_CSFA710( SC1->C1_NUM, NIL, lJobNotify, @cNewLink )
	
	If cNewLink <> ''
		For i := 1 To Len( aBody )
			nP := Rat( '/', aBody[i,5] )
			If nP > 0
				cLink := SubStr( aBody[i,5], 1, nP ) + cNewLink + '.htm'
				aBody[i,5] := cLink
			Endif
		Next i
	Endif
	
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return

