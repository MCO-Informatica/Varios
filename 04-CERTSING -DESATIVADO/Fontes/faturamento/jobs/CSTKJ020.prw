#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'Ap5Mail.ch'
#Include 'TbiConn.ch'

#Define Pula_Linha Chr(13)+Chr(10)

//+-----------+----------+--------+------------------------+-------+------------+
//|Programa:  | CSTKJ020 | Autor: | David Alves dos Santos | Data: | 15/05/2017 |
//+-----------+----------+--------+------------------------+-------+------------+
//|Descricao: | Função de envio de e-mail para agendas que foram marcadas a     |
//|           | opção de lembrete, para que o agente receba uma notificação     |
//+-----------+-----------------------------------------------------------------+
//|Uso:       | Certisign - Certificadora Digital.                              |
//+-----------+-----------------------------------------------------------------+
User Function CSTKJ020()

	Local cQuery       := ""												//-- Consulta SQL.
	Local cTmp         := getNextAlias()								//-- Alias reservado para consulta SQL.
	Local cMV_MAIL_ENV := 'MV_TKJ020E'									//-- Parametro utilizado para teste de recebimento de e-mail.
	Local cEmailCorp   := 'sistemascorporativos@certisign.com.br'	//-- E-mail do setor de sistemas corporativos.
	Local cMailTo      := ""												//-- Destinatario do e-mail.
	Local cHtml        := ""												//-- HTML que será enviado via e-mail.
	Local cBody        := ""												//-- Corpo do e-mail que será armazenado dentro do modelo html.
	Local cAssunt      := ""												//-- Assunto do e-mail.
	Local cHoraAux     := ""												//-- Variavel para auxiliar no tratamento da hora.
	
	//-- Informa o servidor que nao ira consumir licensas.
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02" MODULO 'TMK' TABLES 'SUD', 'SA1'
		
		//-- Se nao existir o parametro no SX6 ele cria.
		If .Not. GetMv( cMV_MAIL_ENV, .T. )
			CriarSX6( cMV_MAIL_ENV, 'C', 'EMAIL QUE SERA USADA PARA ENVIO DE EMAIL TESTE. EM PRODUCAO DEIXAR VAZIO CSTKJ020.prw', cEmailCorp )
		EndIf
		cMV_MAIL_ENV := GetMv( cMV_MAIL_ENV, .F. )
				
		//-- Montagem da query.
		cQuery := " SELECT * "
		cQuery += " FROM   " +RetSqlName("ZZY")+ "  "
		cQuery += " WHERE  ZZY_STATUS = 'P' "
		cQuery += "        AND ZZY_DATAG = '" + dToS(Date()) + "' "
		cQuery += "        AND D_E_L_E_T_ = ' ' "
		
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
				
				cHoraAux := CSTKJ20HOR((cTmp)->(ZZY_HORAG), "00:01")
				
				If (cTmp)->(ZZY_DATAG) <= DtoS(Date()) .or. ((cTmp)->(ZZY_DATAG) == DtoS(Date()) .And. (alltrim((cTmp)->(ZZY_HORAG)) <= SubStr(Time(),1,5)) )
					
					//-- Destinatario do e-mail.
					cMailTo := AllTrim(Iif(Empty(cMV_MAIL_ENV),(cTmp)->ZZY_MAILOP, cMV_MAIL_ENV))
					
					//-- Assunto do e-mail.
					cAssunt := "VDS Alerta de agendamento! - " + (cTmp)->(ZZY_AGENDA)
					
					//-- Formatação da hora/data.
					cHoraG := CSTKJ20HOR(AllTrim((cTmp)->(ZZY_HORAG)), "00:05")
					cDataG := SubStr((cTmp)->(ZZY_DATAG),7,2) + "/" +SubStr((cTmp)->(ZZY_DATAG),5,2) + "/" + SubStr((cTmp)->(ZZY_DATAG),1,4)
					
					//-- Construção do corpo do e-mail.
					cBody := '<td style="text-align: left; vertical-align: top;">'
					cBody += '<p style="font-family: "Myriad Pro", Arial, Century; font-size: 16px; color: #515151;">'
					cBody += 		'<span style="font-size:20px;"><b style="color: rgb(0, 79, 159);">Alerta de agendamento!</b></span></p>'
					cBody += 		'<hr />'
					cBody += 	'<p>'
					cBody += 	'<span style="font-size:14px;"><span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century;">Atenção!</span></span><br />'
					cBody += 	'<br />'
					cBody += 	'<span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Existe um atendimento agendado para ás: ' + cHoraG + ' - ' + cDataG +  '</span></p>'
					cBody += 	'<table align="center" bgcolor="#CCCCCC" border="0" cellpadding="2" cellspacing="1" style="width: 545px" width="100%">'
					cBody += 		'<tbody>'
					cBody += 			'<tr bgcolor="#F0F0F0">'
					cBody += 				'<td style="text-align: left; vertical-align: top; width: 100px;">'
					cBody += 				'<span style="font-size:12px;"><strong style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Numero:</strong></span></td>'
					cBody += 				'<td style="text-align: left; vertical-align: top;">'
					cBody += 				'<span style="font-size:12px;"><span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century;">' + (cTmp)->(ZZY_AGENDA) + '</span></span></td>'
					cBody += 			'</tr>'
					cBody += 			'<tr bgcolor="#F0F0F0">'
					cBody += 				'<td style="text-align: left; vertical-align: top; width: 100px;">'
					cBody += 				'<span style="font-size:12px;"><strong style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Empresa:</strong></span></td>'
					cBody += 				'<td style="text-align: left; vertical-align: top;">'
					cBody += 				'<span style="font-size:12px;"><span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century;">' + (cTmp)->(ZZY_EMPRES) + '</span></span></td>'
					cBody += 			'</tr>'
					cBody += 			'<tr bgcolor="#F0F0F0">'
					cBody += 				'<td style="text-align: left; vertical-align: top; width: 100px;">'
					cBody += 				'<span style="font-size:12px;"><strong style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Contato:</strong></span></td>'
					cBody += 				'<td style="text-align: left; vertical-align: top;">'
					cBody += 				'<span style="font-size:12px;"><span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century;">' + (cTmp)->(ZZY_CONTAT) + '</span></span></td>'
					cBody += 			'</tr>'
					cBody += 		'</tbody>'
					cBody += 	'</table>'
					cBody += '</td>'
					
					//-- Montagem do html de acordo com o modelo.
					cHtml := u_CSModHtm(cBody, , .T.)
					
					//-- Funcao para envio de e-mail.
					FsSendMail(cMailTo, cAssunt, cHtml)
					
					//-- Atualização do ZZY_LOG.
					DbSelectArea("ZZY")
					DbSetOrder(1)
					If ZZY->(MsSeek(xFilial("ZZY") + (cTmp)->(ZZY_AGENDA)))
						
						RecLock("ZZY", .F.)
							ZZY_LOG    += "["+DToC(Date()) +" "+ Time() +"] " + "Alerta de agendamento enviado via e-mail." + Pula_Linha	//-- Log.
							ZZY_STATUS := "E"
						ZZY->(MsUnLock())
						
					EndIf
					
				EndIf
				
				(cTmp)->(DbSkip())
			EndDo
			
		EndIf
		
	RESET ENVIRONMENT

Return


//+-----------+------------+--------+------------------------+-------+------------+
//|Programa:  | CSTKJ20HOR | Autor: | David Alves dos Santos | Data: | 19/06/2017 |
//+-----------+------------+--------+------------------------+-------+------------+
//|Descricao: | Tratamento de soma de horas.                                      |
//+-----------+-------------------------------------------------------------------+
//|Uso:       | Certisign - Certificadora Digital.                                |
//+-----------+-------------------------------------------------------------------+
Static Function CSTKJ20HOR(cHora, cMinSom)
	
	Local cRet      := ""
	Local nSubHoras := 0
	
	//-- Realiza a soma das horas.
	nSubHoras := SomaHoras(cHora, cMinSom)
	
	//+--------------------------------------------------------------+
	//| Através do tamanho retornado da soma é concetenado os zeros. |
	//+--------------------------------------------------------------+
	If Len(cValToChar(nSubHoras)) == 1
		cRet := "0" + cValToChar(nSubHoras) + ":00"
	ElseIf Len(cValToChar(nSubHoras)) == 2
		cRet := cValToChar(nSubHoras) + ":00"
	Else
		If nSubHoras < 10
			cRet := StrTran("0" + cValToChar(nSubHoras),".",":")
			If Len(cRet) <= 4
				cRet += "0"
			EndIf
		Else
			cRet := StrTran(cValToChar(nSubHoras),".",":")
			If Len(cRet) <= 4
				cRet += "0"
			EndIf
		EndIf
	EndIf
	
Return( cRet )