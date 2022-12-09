#INCLUDE "PROTHEUS.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" ?>'
#DEFINE nDIMENSAO_ESPESS 2
#DEFINE nDIMENSAO_LARG   54
#DEFINE nDIMENSAO_COMPR  85 

/*/{Protheus.doc} VNDA580

Funcao criada transmitir ao hub as etiquetas que devem ser entregues aos correios (PLP)

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
User Function VNDA580(aParSch)
	Local cCategory := "NOTIFICA-POSTAGEM"
	Local cDocument := ""
	Local cDocument1:= ""
	Local cDocument2:= ""
	Local cJobEmp	:= ''
	Local cJobFil	:= ''
	Local _lJob 	:= (Select('SX6')==0)
	Local cAlias	:= ""
	Local nI		:= 0
	Local cCrtCorr	:= ""
	Local cCtrCorr	:= ""
	Local cAdmCorr	:= ""
	Local cDirCorr	:= ""
	Local aPag		:= {}
	Local cMsgRet	:= ""
	Local cNum		:= ""
	Local cCompl    := ""
	Local cEnvUnit	:= ""
	Local nEspess   := 0
	Local nLarg     := 0
	Local nCompr    := 0
	Local cEspess 	:= ""
	Local cLarg   	:= ""
	Local cCompr  	:= ""	 
	
	cJobEmp := Iif( aParSch == NIL, '01', aParSch[ 1 ] )
	cJobFil := Iif( aParSch == NIL, '02', aParSch[ 2 ] )
	
	If _lJob
		RpcSetType(3)
		RpcSetEnv(cJobEmp, cJobFil)
	EndIf

	cEnvUnit	:= GetNewPar("MV_XENVUNT", "1")
	cCrtCorr	:= GetNewPar("MV_XCRTCOR", "0000000000")
	cCtrCorr	:= GetNewPar("MV_XCTRCOR", "0000000000")
	cAdmCorr	:= GetNewPar("MV_XADMCOR", "00000000")
	cDirCorr	:= GetNewPar("MV_XDIRCOR", "72")

	cAlias := GetNextALias()

	BeginSql Alias cAlias
		SELECT
		  PAG.R_E_C_N_O_ RECPAG,
		  SA4.A4_XCODCOR,
		  PAG.PAG_CODRAS,
		  PAG.PAG_CODPED,
		  DAI.DAI_CLIENT,
		  DAI.DAI_LOJA,
		  DAI.DAI_NFISCA,
		  DAI.DAI_SERIE
		FROM
		  %Table:PAG% PAG INNER JOIN %Table:SA4% SA4 ON
		    PAG.PAG_FILIAL = %xFilial:PAG% AND
		    SA4.A4_FILIAL = %xFilial:SA4% AND
		    PAG.PAG_CODTRA = SA4.A4_COD INNER JOIN %Table:DAI% DAI ON
		      DAI.DAI_FILIAL = %xFilial:DAI% AND
		      PAG.PAG_CODPED = DAI.DAI_PEDIDO
		WHERE
		  PAG.PAG_STATUS = '3' AND
		  PAG.PAG_ENTREG = ' ' AND
		  PAG.%NotDel%  AND
		  SA4.%NotDel%  AND
		  DAI.%NotDel%
		ORDER BY
		  SA4.A4_XCODCOR
	EndSql

	If !(cAlias)->(EoF())

		cDocument := XML_VERSION + CRLF
		cDocument += '<correioslog>'+ CRLF
		cDocument += '	<tipo_arquivo>Postagem</tipo_arquivo>'+ CRLF
		cDocument += '	<versao_arquivo>2.3</versao_arquivo>'+ CRLF
		cDocument += '	<plp>'+ CRLF
		cDocument += '		<id_plp />'+ CRLF
		cDocument += '		<valor_global />'+ CRLF
		cDocument += '		<mcu_unidade_postagem />'+ CRLF
		cDocument += '		<nome_unidade_postagem />'+ CRLF
		cDocument += '		<cartao_postagem>'+cCrtCorr+'</cartao_postagem>'+ CRLF
		cDocument += '	</plp>'+ CRLF
		cDocument += '	<remetente>'+ CRLF
		cDocument += '		<numero_contrato>'+cCtrCorr+'</numero_contrato>'+ CRLF
		cDocument += '		<numero_diretoria>'+cDirCorr+'</numero_diretoria>'+ CRLF
		cDocument += '		<codigo_administrativo>'+cAdmCorr+'</codigo_administrativo>'+ CRLF
		cDocument += '		<nome_remetente><![CDATA['+Alltrim(SM0->M0_NOMECOM)+']]></nome_remetente>'+ CRLF
		cDocument += '		<logradouro_remetente><![CDATA['+Alltrim(SubStr(SM0->M0_ENDENT,1,at(",",SM0->M0_ENDENT)))+']]></logradouro_remetente>'+ CRLF

		cNum	:= Alltrim(SubStr(SM0->M0_ENDENT,at(",",SM0->M0_ENDENT)+1))

		cDocument += '		<numero_remetente>'+Alltrim(cNum)+'</numero_remetente>'+ CRLF
		cDocument += '		<complemento_remetente><![CDATA['+Alltrim(SM0->M0_COMPENT)+']]></complemento_remetente>'+ CRLF
		cDocument += '		<bairro_remetente><![CDATA['+Alltrim(SM0->M0_BAIRENT)+']]></bairro_remetente>'+ CRLF
		cDocument += '		<cep_remetente><![CDATA['+Alltrim(SM0->M0_CEPENT)+']]></cep_remetente>'+ CRLF
		cDocument += '		<cidade_remetente><![CDATA['+Alltrim(SM0->M0_CIDENT)+']]></cidade_remetente>'+ CRLF
		cDocument += '		<uf_remetente>'+Alltrim(SM0->M0_ESTENT)+'</uf_remetente>'+ CRLF
		cDocument += '		<telefone_remetente><![CDATA['+Alltrim(SM0->M0_TEL)+']]></telefone_remetente>'+ CRLF
		cDocument += '		<fax_remetente><![CDATA['+Alltrim(SM0->M0_FAX)+']]></fax_remetente>'+ CRLF
		cDocument += '		<email_remetente></email_remetente>'+ CRLF
		cDocument += '	</remetente>'+ CRLF
		cDocument += '	<forma_pagamento />'+ CRLF

		cDocument1:= ''
		nEtiquetas:= 0

		SB1->(DbSetOrder(1))
		SC5->(DbSetOrder(1))
		SC6->(DbSetOrder(1))
		SA1->(DbSetOrder(1))
		SA2->(DbSetOrder(1))
		SB5->(DbSetOrder(1))

		While !(cAlias)->(EoF())

			aadd(aPag,(cAlias)->RECPAG)
			cProdCor		:= (cAlias)->A4_XCODCOR
			nEtiquetas++

			SC5->(DbSeek(xFilial("SC5")+(cAlias)->PAG_CODPED))
			If !Empty(SC5->C5_XNPSITE)
				U_GTPutIN(SC5->C5_XNPSITE,"Q",SC5->C5_XNPSITE,.T.,{"U_VNDA580",SC5->C5_XNPSITE,"Inicio Geração XML de Etiquetas dos Correios"},SC5->C5_XNPSITE)
			EndIf

			SC6->(DbSeek(xFilial("SC6")+(cAlias)->PAG_CODPED))
			SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			If SC5->C5_TIPO == "D"
				SA2->(DbSeek(xFilial("SA2")+(cAlias)->(DAI_CLIENT+DAI_LOJA)))
				If !Empty(SA2->A2_NREDUZ)
					cNome	:= SA2->A2_NREDUZ
				Else
					cNome	:= Left(SA2->A2_NOME,50)
				EndIf
				cEnd	:= SA2->A2_END
				cNum	:= ""
				cCompl	:= ""

				StaticCall(VNDA570,VD570END,@cEnd,@cCompl,@cNum)

				cBairro	:= SA2->A2_BAIRRO
				cCep	:= SA2->A2_CEP
				cMun	:= Left(SA2->A2_MUN,30)
				cEst	:= SA2->A2_EST
				cEmail	:= Left(SA2->A2_EMAIL,50)
				cTel	:= Left(SA2->A2_TEL,24)
			ElseIF SC5->C5_TIPO == "B"
				SA2->(DbSeek(xFilial("SA2")+(cAlias)->(DAI_CLIENT+DAI_LOJA)))
				If !Empty(SA2->A2_NREDUZ)
					cNome	:= SA2->A2_NREDUZ
				Else
					cNome	:= Left(SA2->A2_NOME,50)
				EndIf
				cEnd	:= SA2->A2_ENDENT
				cNum	:= ""
				cCompl	:= ""

				StaticCall(VNDA570,VD570END,@cEnd,@cCompl,@cNum)

				cBairro	:= SA2->A2_BAIRROE
				cCep	:= SA2->A2_CEPENT
				cMun	:= Left(SA2->A2_MUNE,30)
				cEst	:= SA2->A2_ESTE
				cEmail	:= Left(SA2->A2_EMAIL,50)
				cTel	:= Left(SA2->A2_TEL,24)
			Else
				SA1->(DbSeek(xFilial("SA1")+(cAlias)->(DAI_CLIENT+DAI_LOJA)))
				If !Empty(SA1->A1_NREDUZ)
					cNome	:= SA1->A1_NREDUZ
				Else
					cNome	:= Left(SA1->A1_NOME,50)
				EndIf
				cEnd	:= SA1->A1_ENDENT
				cNum	:= ""
				cCompl	:= ""

				If SA1->A1_XNUMENT > 0
					cNum	:= Alltrim(Str(SA1->A1_XNUMENT))
					cCompl	:= SA1->A1_XCOMPEN
				EndIf

				StaticCall(VNDA570,VD570END,@cEnd,@cCompl,@cNum)

				cBairro	:= SA1->A1_BAIRROE
				cCep	:= SA1->A1_CEPE
				cMun	:= Left(SA1->A1_MUNE,30)
				cEst	:= SA1->A1_ESTE
				IF Empty( cEst )
					cEst := SA1->A1_EST
				EndIF
				cEmail	:= Left(SA1->A1_EMAIL,50)
				cTel	:= Left(SA1->A1_TEL,24)

			EndIf

			if SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))
				nEspess   := SB5->B5_ESPESS
				nLarg     := SB5->B5_LARG
				nCompr    := SB5->B5_COMPR 
			else
				nEspess   := nDIMENSAO_ESPESS
				nLarg     := nDIMENSAO_LARG
				nCompr    := nDIMENSAO_COMPR

				//Envia email para estoque cadastrar produto
				envMailSB5()

				conout("[VNDA580] Produto nao existe na tabela SB5 - Dados Adicionais do Produto: "+SB1->B1_COD)
			endif			
			cEspess := Alltrim(Transform(nEspess, "999999"))
			cLarg   := Alltrim(Transform(nLarg  , "999999"))
			cCompr  := Alltrim(Transform(nCompr , "999999"))
			
			cDocument1 += '	<objeto_postal>'+ CRLF
			cDocument1 += '		<numero_etiqueta>'+(cAlias)->PAG_CODRAS+'</numero_etiqueta>'+ CRLF
			cDocument1 += '		<codigo_objeto_cliente />'+ CRLF
			cDocument1 += '		<codigo_servico_postagem>'+(cAlias)->A4_XCODCOR+'</codigo_servico_postagem>'+ CRLF
			cDocument1 += '		<cubagem></cubagem>'+ CRLF
			cDocument1 += '		<peso>'+Iif(SB1->B1_PESBRU < 1,"30",Alltrim(Transform(SB1->B1_PESBRU, "@E 999999")))+'</peso>'+ CRLF
			cDocument1 += '		<rt1>rt1</rt1>'+ CRLF
			cDocument1 += '		<rt2>rt2</rt2>'+ CRLF
			cDocument1 += '		<destinatario>'+ CRLF
			cDocument1 += '			<nome_destinatario><![CDATA['+Alltrim(cNome)+']]></nome_destinatario>'+ CRLF
			cDocument1 += '			<telefone_destinatario><![CDATA['+Alltrim(cTel)+']]></telefone_destinatario>'+ CRLF
			cDocument1 += '			<celular_destinatario><![CDATA['+Alltrim(cTel)+']]></celular_destinatario>'+ CRLF
			cDocument1 += '			<email_destinatario><![CDATA['+Alltrim(cEmail)+']]></email_destinatario>'+ CRLF
			cDocument1 += '			<logradouro_destinatario><![CDATA['+Alltrim(cEnd)+']]></logradouro_destinatario>'+ CRLF
			cDocument1 += '			<complemento_destinatario><![CDATA['+Iif(Empty(cCompl) .or. Len(cCompl)< 3,"",Alltrim(cCompl))+']]></complemento_destinatario>'+ CRLF
			cDocument1 += '			<numero_end_destinatario>'+Alltrim(IIf(Empty(cNum),"0",cNum))+'</numero_end_destinatario>'+ CRLF
			cDocument1 += '		</destinatario>'+ CRLF
			cDocument1 += '		<nacional>'+ CRLF
			cDocument1 += '			<bairro_destinatario><![CDATA['+If(Len(Alltrim(cBairro))>30,left(cBairro,30),Alltrim(cBairro))+']]></bairro_destinatario>'+ CRLF
			cDocument1 += '			<cidade_destinatario><![CDATA['+Alltrim(cMun)+']]></cidade_destinatario>'+ CRLF
			cDocument1 += '			<uf_destinatario>'+Alltrim(cEst)+'</uf_destinatario>'+ CRLF
			cDocument1 += '			<cep_destinatario><![CDATA['+Alltrim(cCep)+']]></cep_destinatario>'+ CRLF
			cDocument1 += '			<codigo_usuario_postal />'+ CRLF
			cDocument1 += '			<centro_custo_cliente />'+ CRLF
			cDocument1 += '			<numero_nota_fiscal>'+Alltrim(Str(Val((cAlias)->DAI_NFISCA)))+'</numero_nota_fiscal>'+ CRLF
			cDocument1 += '			<serie_nota_fiscal>'+Alltrim((cAlias)->DAI_SERIE)+'</serie_nota_fiscal>'+ CRLF
			cDocument1 += '			<valor_nota_fiscal />'+ CRLF
			cDocument1 += '			<natureza_nota_fiscal />'+ CRLF
			cDocument1 += '			<descricao_objeto><![CDATA[HARDWARE]]></descricao_objeto>'+ CRLF
			cDocument1 += '			<valor_a_cobrar />'+ CRLF
			cDocument1 += '		</nacional>'+ CRLF
			cDocument1 += '		<servico_adicional>'+ CRLF
			cDocument1 += '			<codigo_servico_adicional>025</codigo_servico_adicional>'+ CRLF
			cDocument1 += '			<valor_declarado>0</valor_declarado>'+ CRLF
			cDocument1 += '		</servico_adicional>'+ CRLF
			cDocument1 += '		<dimensao_objeto>'+ CRLF
			cDocument1 += '			<tipo_objeto>002</tipo_objeto>'+ CRLF
			cDocument1 += '			<dimensao_altura>'+ cEspess +'</dimensao_altura>'+ CRLF
			cDocument1 += '			<dimensao_largura>'+ cLarg +'</dimensao_largura>'+ CRLF
			cDocument1 += '			<dimensao_comprimento>'+ cCompr +'</dimensao_comprimento>'+ CRLF
			cDocument1 += '			<dimensao_diametro>5</dimensao_diametro>'+ CRLF
			cDocument1 += '		</dimensao_objeto>'+ CRLF
			cDocument1 += '		<data_postagem_sara />'+ CRLF
			cDocument1 += '		<status_processamento>0</status_processamento>'+ CRLF
			cDocument1 += '		<numero_comprovante_postagem />'+ CRLF
			cDocument1 += '		<valor_cobrado />'+ CRLF
			cDocument1 += '	</objeto_postal>'+ CRLF

			(cAlias)->(DbSkip())

			If (cAlias)->(EoF()) .or. cEnvUnit == "1" .or. cProdCor	<> (cAlias)->A4_XCODCOR .or. nEtiquetas > 10
				cDocument2 := '</correioslog>'+ CRLF
				If VD580TRF(cDocument+cDocument1+cDocument2,cCategory,@cMsgRet)

					For nI:=1 to Len(aPAG)
						PAG->(DbGoTo(aPAG[nI]))

						RecLock("PAG",.F.)
							PAG->PAG_ENTREG := "00"
						PAG->(MsUnlock())

						SC5->(DbSeek(xFilial("SC5")+PAG->PAG_CODPED))

						RecLock("SC5",.F.)
						SC5->C5_XFLAGEN := ""
						SC5->(MsUnlock())

						If !Empty(SC5->C5_XNPSITE)
							U_GTPutOUT(SC5->C5_XNPSITE,"Q",SC5->C5_XNPSITE,{"VNDA580",{.T.,"M00001",SC5->C5_XNPSITE,"Etiqueta enviada ao Hub com sucesso"}},SC5->C5_XNPSITE)
						EndIf

					Next nI

				Else
					For nI:=1 to Len(aPAG)
						PAG->(DbGoTo(aPAG[nI]))

						if SC5->(DbSeek(xFilial("SC5")+PAG->PAG_CODPED))
						If !Empty(SC5->C5_XNPSITE)
							U_GTPutOUT(SC5->C5_XNPSITE,"Q",SC5->C5_XNPSITE,{"VNDA580",{.F.,"E00024",SC5->C5_XNPSITE,"Inconsistência: "+cMsgRet}},SC5->C5_XNPSITE)
							Conout("[VNDA580] Inconsistência ao enviar informações aos correios do pedido Site "+SC5->C5_XNPSITE+" rastreamento "+PAG->PAG_CODRAS+", vide GTOUT")
						Else
							U_GTPutOUT(SC5->C5_NUM,"Q",SC5->C5_NUM,{"VNDA580",{.F.,"E00024",SC5->C5_NUM,"Inconsistência: "+cMsgRet}},SC5->C5_NUM)
							Conout("[VNDA580] Inconsistência ao enviar informações aos correios do pedido "+PAG->PAG_CODPED+" rastreamento "+PAG->PAG_CODRAS+", vide GTOUT")
						EndIf
						else
							Conout("[VNDA580] Pedido não encontrado: "+PAG->PAG_CODPED)
						endif

					Next nI

				EndIf

				cDocument1	:= ''
				aPAG 		:= {}
				nEtiquetas	:= 0

			EndIf

		EndDo

	EndIf

	(cAlias)->(DbCloseArea())

Return
/*/{Protheus.doc} VD580TRF

Funcao criada se comunicar com o HUB  enviar XML PLP

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
Static Function VD580TRF(cXml,cCategory,cMsgRet)

	Local cError	:= ""
	Local cWarning	:= ""
	Local cSvcError := ""
	Local cSoapFCode:= ""
	Local cSoapFDescr:= ""
	Local lOk		:= .T.
	Local oWsObj
	Local oWsRes
	Local cXSD		:= GetNewPar("MV_XXSDDEL", "\system\xsd_delivery.xsd")

	// Valida o arquivo XML com o XSD
	If !XmlSVldSch( cXml, cXSD, @cError, @cWarning )
	    cMsgRet	:= "Error:"+cError+" Warning:"+ cWarning
	    conout("[VNDA580] XmlSVldSch: "+cMsgRet)
	    lOk		:= .F.
	Else

		oWsObj := WSVVHubServiceService():New()

		lOk := oWsObj:sendMessage(cCategory,cXml)

		cSvcError   := GetWSCError()  // Resumo do erro
		cSoapFCode  := GetWSCError(2)  // Soap Fault Code
		cSoapFDescr := GetWSCError(3)  // Soap Fault Description

		If !empty(cSoapFCode)
			//Caso a ocorrência de erro esteja com o fault_code preenchido ,
			//a mesma teve relação com a chamada do serviço .
			cMsgRet	:= cSoapFDescr + ' ' + cSoapFCode
			conout("[VNDA580] "+cMsgRet)
			lOk 	:= .F.
		ElseIf !Empty(cSvcError)
			//Caso a ocorrência não tenha o soap_code preenchido
			//Ela está relacionada a uma outra falha ,
			//provavelmente local ou interna.
			lOk := .F.
			cMsgRet	:= cSvcError
			conout("[VNDA580] "+cMsgRet)
		Endif

		If lOk
			oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )

			If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1" .AND. Empty(cError)
				lOk := .T.

			ElseIf !Empty(cError)
				lOk := .F.
				cMsgRet	:= cError
				conout("[VNDA580] "+cMsgRet)
			Else
				lOk := .F.
				cMsgRet	:= oWsRes:_CONFIRMATYPE:_MSG:TEXT
				conout("[VNDA580] "+cMsgRet)
			EndIf

			FreeObj(oWsRes)
			FreeObj(oWsObj)
			DelClassIntf()
		EndIf
	EndIf
Return(lOk)
/*/{Protheus.doc} envMailSB5

Envia email para estoque atualizar a tabela Dados Adicionais do Produto não cadastrado

@author Totvs SM - David
@since 10/03/2020
@version P11

/*/
static function envMailSB5()
	local cEmail   := "estoque@certisign.com.br"
	local cTitulo  := "Dados Adicionais do Produto não cadastrado"
	local cHtml    := ""
	local cAnexo   := ""
	local cMsgHTML := ""
	
	cMsgHTML :=	" O produto " + SB1->B1_COD + " - " + AllTrim( Capital( SB1->B1_DESC ) )
	cMsgHTML +=	" não possui as dimensões cadastradas na tabela <strong>Dados Adicionais do Produto.</strong>"	

	//Inicia construcao do html
	cHtml += '<!DOCTYPE HTML>'
	cHtml += '<html>'
	cHtml += '	<head>'
	cHtml += '		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> '
	cHtml += '	</head>'
	cHtml += '	<body style="font-family: Fontin Roman, Lucida Sans Unicode">'
	cHtml += '	<table align="center" border="0" cellpadding="0" cellspacing="0" width="630" >'
	cHtml += '		<tr>'
	cHtml += '			<td valign="top" align="center">'
	cHtml += '				<table width="627">'
	cHtml += '					<tr>'
	cHtml += '						<td valign="middle" align="left" style="border-bottom:2px solid #FE5000;">'
	cHtml += '							<h2>'
	cHtml += '								<span style="color:#FE5000" ><strong>'+cTitulo+'</strong></span>'
	cHtml += '								<br />'
	cHtml += '								<span style="color:#003087" >Recursos Humanos</span>'
	cHtml += '							</h2>'
	cHtml += '						</td>'
	cHtml += '						<td valign="top" align="left" style="border-bottom:2px solid #FE5000;">'
	cHtml += '							<img  alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" />'
	cHtml += '						</td>'
	cHtml += '					</tr>'
	cHtml += '				</table>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" style="padding:15px;">'
	chtml += '				<p>'+cMsgHTML+'<br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'
	cHtml += '		<tr>'
	cHtml += '			<td valign="top" colspan="2" style="padding:5px" width="0">'
	cHtml += '				<p align="left">'
	cHtml += '					<em style="color:#666666;">Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em>'
	cHtml += '				</p>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	cHtml += '	</table>'
	cHtml += '	</body>'
	cHtml += '</html>'
	
	fsSendMail( cEmail, cTitulo, cHtml, cAnexo )
return