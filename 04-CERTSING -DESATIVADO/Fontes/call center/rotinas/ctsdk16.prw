#include 'protheus.ch'    


//-------------------------------------------------------------------------------------
/*/{Protheus.doc} CTSDK16
Função que monta o corpo do HTML do workflow
   
@param		String que será exibida na área do título do workflow
@param		String que será exibida na área do texto do workflow
@param		String que será exibida na área do rodapé do workflow
@author		Renan Guedes Alexandre
@version   	P10
@since      21/11/2012
/*/
//-------------------------------------------------------------------------------------
User Function CTSDK16(cTitulo,cTexto,cRodape)

Local aArea						:= GetArea()
Local cCabec					:= ''
Local cLinItem					:= ''
Local aAreaADF					:= {}
Local aAreaSU0					:= {}
Local aItens					:= {}
Local nX						:= 0
Local nPosItem					:= 0
Local cCPFCNPJ					:= ''
Local cTelefone					:= ''
Local nItem						:= 0
Local lSLA						:= .F.
Local lItem						:= .F.
Local lArea						:= .F.
Local lAcao						:= .F.
Local lOcorrencia				:= .F.
Local lAnalista					:= .F.
Local lAchouSU0					:= .F.                 

Default cTitulo					:= ''
Default cTexto					:= ''
Default cRodape					:= ''

//Monta o logo do workflow
cCabec += '		<p align="center"><a href="http://www.certisign.com.br"><img src="http://icp-brasil.certisign.com.br/img/logo_certisign.gif"></a></p>'
cCabec += '		&nbsp;'

//Monta o título do workflow
If ValType(cTitulo) == "C"
	If !Empty(AllTrim(cTitulo))
		cCabec += '		<table align="center" border="0" cellpadding="0" cellspacing="0">'
		cCabec += '			<thead>'
		cCabec += '				<tr>'
		cCabec += '					<td bgcolor="#788EA7">' + AllTrim(cTitulo) + '</td>'
		cCabec += '		   		</tr>'
		cCabec += '			</thead>'
		cCabec += '		</table>'
		cCabec += '		&nbsp;'
	EndIf
EndIf

//Monta o texto do workflow
If ValType(cTexto) == "C"
	If !Empty(AllTrim(cTexto))
		cCabec += '		<table align="center" border="0" cellpadding="0" cellspacing="0">'
		cCabec += '			<tr>'
		cCabec += '				<td class="texto1">' + AllTrim(cTexto) + '</td>'
		cCabec += '			</tr>'
		cCabec += '		</table>'
		cCabec += '		&nbsp;'
	EndIf
EndIf

cCabec += '		<table align="center" border="0" cellpadding="0" cellspacing="0">'
cCabec += '			<thead>'
cCabec += '				<tr>'
cCabec += '			   		<td bgcolor="#788EA7">PROTOCOLO ' + AllTrim(ADE->ADE_CODIGO) + '</td>'
cCabec += '		   		</tr>'
cCabec += '			</thead>'
cCabec += '		</table>'
cCabec += '		&nbsp;'
cCabec += '		<table align="center" border="0" cellpadding="0" cellspacing="2">'
cCabec += '			<thead>'
cCabec += '				<tr>'
cCabec += '			   		<td bgcolor="#788EA7" colspan="6">DADOS CADASTRAIS</td>'
cCabec += '		   		</tr>'
cCabec += '			</thead>'

//Monta a tabela de dados cadastrais
cCPFCNPJ := AllTrim(GetCPFCNPJ(ADE->ADE_ENTIDA,ADE->ADE_CHAVE))		//Pesquisa o CPF/CNPJ do contato

If Len(cCPFCNPJ) == 14
	cCPFCNPJ := Transform(cCPFCNPJ,"@R 99.999.999/9999-99")
Else
	cCPFCNPJ := Transform(cCPFCNPJ,"@R 999.999.999-99")
EndIf

cTelefone := AllTrim(TKENTIDADE(ADE->ADE_ENTIDA,ADE->ADE_CHAVE,9))

If !Empty(cTelefone)
	cTelefone := '(' + cTelefone + ')'
EndIf

cTelefone += ' ' + AllTrim(TKENTIDADE(ADE->ADE_ENTIDA,ADE->ADE_CHAVE,6))

dbSelectArea("SU0")
aAreaSU0 := SU0->(GetArea())
SU0->(dbSetOrder(1))		//U0_FILIAL+U0_CODIGO
lAchouSU0 := SU0->(MsSeek(xFilial("SU0")+ADE->ADE_GRUPO))

cCabec += '			<tr>'
cCabec += '				<td bgcolor="#ECF0EE" class="tdTitulo">					C&oacute;digo:												</td>'
cCabec += '				<td bgcolor="#F7F9F8" class="tdTexto">' + 				AllTrim(ADE->ADE_CODCON) + '								</td>'
cCabec += '				<td bgcolor="#ECF0EE" class="tdTitulo">					Raz&atilde;o Social:										</td>'
cCabec += '				<td bgcolor="#F7F9F8" class="tdTexto" colspan="3">' +	AllTrim(TKENTIDADE(ADE->ADE_ENTIDA,ADE->ADE_CHAVE,1)) + '	</td>'
cCabec += '				</tr>'
cCabec += '			<tr>'
cCabec += '				<td bgcolor="#ECF0EE" class="tdTitulo">					CPF/CNPJ:																			</td>'
cCabec += '				<td bgcolor="#F7F9F8" class="tdTexto">' +				cCPFCNPJ + '																		</td>'
cCabec += '				<td bgcolor="#ECF0EE" class="tdTitulo">					Contato:																			</td>'
cCabec += '				<td bgcolor="#F7F9F8" class="tdTexto">' +		 		AllTrim(GetAdvFVal('SU5','U5_CONTAT',XFILIAL('SU5')+ADE->ADE_CODCONT,1,'')) + '		</td>'
cCabec += '				<td bgcolor="#ECF0EE" class="tdTitulo">					Telefone:																			</td>'
cCabec += '				<td bgcolor="#F7F9F8" class="tdTexto">' +		 		cTelefone + '																		</td>'
cCabec += '			</tr>'
cCabec += '			<tr>'
cCabec += '				<td bgcolor="#ECF0EE" class="tdTitulo">					e-mail do contato:					</td>'
cCabec += '				<td bgcolor="#F7F9F8" class="tdTexto" colspan="5">' +	Lower(AllTrim(ADE->ADE_TO)) + '		</td>'
cCabec += '			</tr>'

// Indica se deve enviar e-mails CC no modelo de workflow
If lAchouSU0 .And. SU0->U0_XMAILAD <> "2"
	cCabec += '			<tr>'
	cCabec += '				<td bgcolor="#ECF0EE" class="tdTitulo">					e-mail adicional:					</td>'
	cCabec += '				<td bgcolor="#F7F9F8" class="tdTexto" colspan="5">' +	Lower(AllTrim(ADE->ADE_CC)) + '		</td>'
	cCabec += '			</tr>'
EndIf	

cCabec += '			<tr>'
cCabec += '				<td>&nbsp;</td>'
cCabec += '			</tr>'

//Monta a tabela de situação atual do chamado
If !Empty(AllTrim(DTOC(ADE->ADE_DTEXPI))) .And. !Empty(AllTrim(ADE->ADE_HREXPI))
	lSLA := .T.
EndIf

cCabec += '			<thead>'
cCabec += '				<tr>'
cCabec += '					<td bgcolor="#788EA7" colspan="6">SITUA&Ccedil;&Atilde;O ATUAL DO CHAMADO</td>'
cCabec += '		   		</tr>'
cCabec += '			</thead>'
cCabec += '			<tr>'
cCabec += '				<td bgcolor="#ECF0EE" class="tdTitulo">					Data abertura:							   				</td>'
If lSLA
	cCabec += '			<td bgcolor="#F7F9F8" class="tdTexto">' + 				DTOC(ADE->ADE_DATA) + '							   		</td>'
	cCabec += '			<td bgcolor="#ECF0EE" class="tdTitulo">					Criticidade:											</td>'
	cCabec += '			<td bgcolor="#F7F9F8" class="tdTexto" colspan="3">' +	AllTrim(X3Combo("ADE_SEVCOD",ADE->ADE_SEVCOD)) + '		</td>'
Else
	cCabec += '			<td bgcolor="#F7F9F8" class="tdTexto" colspan="5">' +	DTOC(ADE->ADE_DATA) + '							   		</td>'
EndIf
cCabec += '			</tr>'
cCabec += '			<tr>'
cCabec += '				<td bgcolor="#ECF0EE" class="tdTitulo">					Situa&ccedil;&atilde;o atual:							</td>'
If lSLA
	cCabec += '			<td bgcolor="#F7F9F8" class="tdTexto">' + 				AllTrim(X3Combo("ADE_STATUS",ADE->ADE_STATUS)) + '		</td>'
	cCabec += '			<td bgcolor="#ECF0EE" class="tdTitulo">					Data previs&atilde;o:									</td>'
	cCabec += '			<td bgcolor="#F7F9F8" class="tdTexto">' + 				DTOC(ADE->ADE_DTEXPI) + ' 								</td>'
Else
	cCabec += '			<td bgcolor="#F7F9F8" class="tdTexto" colspan="5">' +	AllTrim(X3Combo("ADE_STATUS",ADE->ADE_STATUS)) + '		</td>'
EndIf
cCabec += '			</tr>'
cCabec += '			<tr>'
cCabec += '				<td bgcolor="#ECF0EE" class="tdTitulo">					&Aacute;rea respons&aacute;vel:												</td>'
cCabec += '				<td bgcolor="#F7F9F8" class="tdTexto" colspan="5">' + 	AllTrim(GetAdvFVal('SU0','U0_NOME',xFilial('SU0')+ADE->ADE_GRUPO,1,'')) + '	</td>'
cCabec += '			</tr>'
cCabec += '			<tr>'
cCabec += '				<td bgcolor="#ECF0EE" class="tdTitulo">					Solicita&ccedil;&atilde;o:										   			</td>'
cCabec += '				<td bgcolor="#F7F9F8" class="tdTexto" colspan="5">' + 	AllTrim(MSMM(ADE->ADE_CODINC,TamSX3("ADE_INCIDE")[1])) + '	</td>'
cCabec += '			</tr>'
cCabec += '		</table>'
cCabec += '		&nbsp;'

//Verifica quais colunas dos itens do atendimento devem ser exibidas para o grupo de atendimento
If lAchouSU0
	If SU0->(FieldPos("U0_XITEM")) > 0
		lItem := IIF(SU0->U0_XITEM == "1",.T.,.F.)
	EndIf
	If SU0->(FieldPos("U0_XAREA")) > 0
		lArea := IIF(SU0->U0_XAREA == "1",.T.,.F.)
	EndIf
	If SU0->(FieldPos("U0_XACAO")) > 0
		lAcao := IIF(SU0->U0_XACAO == "1",.T.,.F.)
	EndIf
	If SU0->(FieldPos("U0_XOCORRE")) > 0
		lOcorrencia := IIF(SU0->U0_XOCORRE == "1",.T.,.F.)
	EndIf
	If SU0->(FieldPos("U0_XANALIS")) > 0
		lAnalista := IIF(SU0->U0_XANALIS == "1",.T.,.F.)
	EndIf
EndIf

RestArea(aAreaSU0)
	
//Monta as linhas da tabela de itens do atendimento
If Type("aWFs") == "A"
	aItens	:= aWFs[1]:ITENS
	
	dbSelectArea("ADF")
	aAreaADF := ADF->(GetArea())
	ADF->(dbSetOrder(1))		//ADF_FILIAL+ADF_CODIGO+ADF_ITEM
	
	If !Empty(aItens)
		nPosItem := ASCAN(aItens[1]:FIELDS, {|xItem| Upper(AllTrim(xItem:NAME)) == "ITEM"})
		
		If (nPosItem > 0)
			For nX := 1 To Len(aItens)						
				If ADF->(MsSeek(xFilial("ADF")+ADE->ADE_CODIGO+aItens[nX]:FIELDS[nPosItem]:VALUE))
					//Verifica se o item deve ser visível no workflow
					If AllTrim(GetAdvFVal('SU9','U9_VISIVEL',xFilial('SU9')+ADF->ADF_CODSU9,2,'')) != "2"
						If MOD(nItem,2) == 0
							cLinItem += '		<tr bgcolor="#F3F3F3">'
						Else
							cLinItem += '		<tr>'
						EndIf
						If lItem
							cLinItem += '				<td class="tdTexto">' + AllTrim(ADF->ADF_ITEM) + '																									</td>'
						EndIf
						If lArea
							cLinItem += '			<td class="tdTexto">' + AllTrim(GetAdvFVal('SU0','U0_NOME',XFILIAL('SU0')+GetAdvFVal('SU7','U7_POSTO',XFILIAL('SU7')+TKOPERADOR(),1,''),1,'')) + '	</td>'
						EndIf
						If lOcorrencia
							cLinItem += '			<td class="tdTexto">' + AllTrim(GetAdvFVal('SU9','U9_DESC',xFilial('SU9')+ADF->ADF_CODSU9,2,'')) + '												</td>'
						EndIf
						If lAcao
							cLinItem += '			<td class="tdTexto">' + AllTrim(GetAdvFVal('SUQ','UQ_DESC',xFilial('SUQ')+ADF->ADF_CODSUQ,1,'')) + '												</td>'
						EndIf
						cLinItem += '				<td class="tdTexto">' + AllTrim(MSMM(ADF->ADF_CODOBS,TamSX3("ADF_OBS")[1])) + '																		</td>'
						If lAnalista
							cLinItem += '			<td class="tdTexto">' + AllTrim(GetAdvFVal('SU7','U7_NOME',XFILIAL('SU7')+ADF->ADF_CODSU7,1,'')) + '												</td>'
						EndIf
						cLinItem += '				<td class="tdTexto">' + DTOC(ADF->ADF_DATA) + ' ' + AllTrim(ADF->ADF_HORA) + '																		</td>'
						cLinItem += '			</tr>'
						
						nItem++
					EndIf
				EndIf
			Next nX
		EndIf
	EndIf
	
	RestArea(aAreaADF)
EndIf
	
//Monta as colunas da tabela de itens do atendimento
If !Empty(AllTrim(cLinItem)) .And. (nItem > 0)
	cCabec += '		<table align="center" border="1" bordercolor="#CCCCCC" cellpadding="2" cellspacing="0">'
	cCabec += '			<tr bgcolor="#788EA7">'
	If lItem
		cCabec += '		 		<td width="4%" class="tdTitulo">	Item		   			</td>'
	EndIf	
	If lArea
		cCabec += '			<td width="10%" class="tdTitulo">	&Aacute;rea				</td>'
	EndIf
	If lOcorrencia
		cCabec += '			<td width="10%" class="tdTitulo">	Ocorr&ecirc;ncia		</td>'
	EndIf
	If lAcao
		cCabec += '			<td width="10%" class="tdTitulo">	A&ccedil;&atilde;o		</td>'
	EndIf
	cCabec += '	  			<td class="tdTitulo">				Descri&ccedil;&atilde;o	</td>'
	If lAnalista
		cCabec += '			<td width="15%" class="tdTitulo">' + IIF(AllTrim(ADE->ADE_GRUPO)=="34",'Consultor','Analista alocado') + '</td>'
	EndIf
	cCabec += '				<td width="10%" class="tdTitulo">	Data/Hora				</td>'
	cCabec += '		   	</tr>'
	
	//Incrementa o corpo do workflow com as linhas dos itens do atendimento
	cCabec += cLinItem

	cCabec += '		</table>'
	cCabec += '		&nbsp;'
EndIf

//Monta o rodapé do workflow
If ValType(cRodape) == "C"
	If !Empty(AllTrim(cRodape))
		cCabec += '		<table align="center" border="0" cellpadding="0" cellspacing="0">'
		cCabec += '			<tr>'
		cCabec += '				<td class="rodape">' + AllTrim(cRodape) + '</td>'
		cCabec += '			</tr>'
		cCabec += '		</table>'
	EndIf
EndIf

cCabec := CharSet(AllTrim(StrTran(cCabec,CHR(9))))

RestArea(aArea)

Return cCabec


//-------------------------------------------------------------------------------------
/*/{Protheus.doc} GetCPFCNPJ
Função que retorna o CPF/CNPJ do contato, a partir da entidade (alias) e chave.
   
@param		Alias do contato
@param		Chave de busca do registro do contato
@author		Renan Guedes Alexandre
@version   	P10
@since      22/11/2012
/*/
//-------------------------------------------------------------------------------------
Static Function GetCPFCNPJ(cEntidade,cChave)

Local cCPFCNPJ					:= ''
Local aArea						:= GetArea()
Local aAreaTmp					:= {}

Default cEntidade				:= ''
Default cChave					:= ''

If !Empty(cEntidade) .And. !Empty(cChave)
	dbSelectArea(cEntidade)
	aAreaTmp := (cEntidade)->(GetArea())
	(cEntidade)->(dbSetOrder(1))
	
	If (cEntidade)->(MsSeek(xFilial(cEntidade)+cChave))
		Do Case
			Case cEntidade == "ACH"
				cCPFCNPJ := ACH->ACH_CGC
			Case cEntidade == "SA1"
				cCPFCNPJ := SA1->A1_CGC
			Case cEntidade == "SA2"
				cCPFCNPJ := SA2->A2_CGC
			Case cEntidade == "SA3"
				cCPFCNPJ := SA3->A3_CGC
			Case cEntidade == "SA4"
				cCPFCNPJ := SA4->A4_CGC
			Case cEntidade == "SUS"
				cCPFCNPJ := SUS->US_CGC
			Case cEntidade == "JA2"
				cCPFCNPJ := JA2->JA2_CPF
			Case cEntidade == "BA1"
				cCPFCNPJ := BA1->BA1_CPFUSR
			Case cEntidade == "RD0"
				cCPFCNPJ := RD0->RD0_CIC
			Case cEntidade == "SZ3"
				cCPFCNPJ := SZ3->Z3_CGC				
		EndCase
	EndIf

	RestArea(aAreaTmp)
EndIf

RestArea(aArea)

cCPFCNPJ := AllTrim(cCPFCNPJ)

Return cCPFCNPJ


//-------------------------------------------------------------------------------------
/*/{Protheus.doc} CharSet
Função que transforma os símbolos e caracteres especiais da codificação ISO 8859-1 em
códigos HTML, para ser corretamente interpretado e exibido pelo browser.

@param		String a ser analisada e transformada
@author		Renan Guedes Alexandre
@version   	P10
@since      22/11/2012
/*/
//-------------------------------------------------------------------------------------
Static Function CharSet(cString)

Local aCharSet				:= {}
Local nX					:= 0

Default cString				:= ''

If !Empty(AllTrim(cString))
	AADD(aCharSet,{'¡','&iexcl;'})
	AADD(aCharSet,{'¢','&cent;'})
	AADD(aCharSet,{'£','&pound;'})
	AADD(aCharSet,{'¤','&curren;'})
	AADD(aCharSet,{'¥','&yen;'})
	AADD(aCharSet,{'¦','&brvbar;'})
	AADD(aCharSet,{'§','&sect;'})
	AADD(aCharSet,{'¨','&uml;'})
	AADD(aCharSet,{'©','&copy;'})
	AADD(aCharSet,{'ª','&ordf;'})
	AADD(aCharSet,{'«','&laquo;'})
	AADD(aCharSet,{'¬','&not;'})
	AADD(aCharSet,{'®','&reg;'})
	AADD(aCharSet,{'¯','&macr;'})
	AADD(aCharSet,{'°','&deg;'})
	AADD(aCharSet,{'±','&plusmn;'})
	AADD(aCharSet,{'²','&sup2;'})
	AADD(aCharSet,{'³','&sup3;'})
	AADD(aCharSet,{'´','&acute;'})
	AADD(aCharSet,{'µ','&micro;'})
	AADD(aCharSet,{'¶','&para;'})
	AADD(aCharSet,{'·','&middot;'})
	AADD(aCharSet,{'¸','&cedil;'})
	AADD(aCharSet,{'¹','&sup1;'})
	AADD(aCharSet,{'º','&ordm;'})
	AADD(aCharSet,{'»','&raquo;'})
	AADD(aCharSet,{'¼','&frac14;'})
	AADD(aCharSet,{'½','&frac12;'})
	AADD(aCharSet,{'¾','&frac34;'})
	AADD(aCharSet,{'¿','&iquest;'})
	AADD(aCharSet,{'×','&times;'})
	AADD(aCharSet,{'÷','&divide;'})
	AADD(aCharSet,{'À','&Agrave;'})
	AADD(aCharSet,{'Á','&Aacute;'})
	AADD(aCharSet,{'Â','&Acirc;'})
	AADD(aCharSet,{'Ã','&Atilde;'})
	AADD(aCharSet,{'Ä','&Auml;'})
	AADD(aCharSet,{'Å','&Aring;'})
	AADD(aCharSet,{'Æ','&AElig;'})
	AADD(aCharSet,{'Ç','&Ccedil;'})
	AADD(aCharSet,{'È','&Egrave;'})
	AADD(aCharSet,{'É','&Eacute;'})
	AADD(aCharSet,{'Ê','&Ecirc;'})
	AADD(aCharSet,{'Ë','&Euml;'})
	AADD(aCharSet,{'Ì','&Igrave;'})
	AADD(aCharSet,{'Í','&Iacute;'})
	AADD(aCharSet,{'Î','&Icirc;'})
	AADD(aCharSet,{'Ï','&Iuml;'})
	AADD(aCharSet,{'Ð','&ETH;'})
	AADD(aCharSet,{'Ñ','&Ntilde;'})
	AADD(aCharSet,{'Ò','&Ograve;'})
	AADD(aCharSet,{'Ó','&Oacute;'})
	AADD(aCharSet,{'Ô','&Ocirc;'})
	AADD(aCharSet,{'Õ','&Otilde;'})
	AADD(aCharSet,{'Ö','&Ouml;'})
	AADD(aCharSet,{'Ø','&Oslash;'})
	AADD(aCharSet,{'Ù','&Ugrave;'})
	AADD(aCharSet,{'Ú','&Uacute;'})
	AADD(aCharSet,{'Û','&Ucirc;'})
	AADD(aCharSet,{'Ü','&Uuml;'})
	AADD(aCharSet,{'Ý','&Yacute;'})
	AADD(aCharSet,{'Þ','&THORN;'})
	AADD(aCharSet,{'ß','&szlig;'})
	AADD(aCharSet,{'à','&agrave;'})
	AADD(aCharSet,{'á','&aacute;'})
	AADD(aCharSet,{'â','&acirc;'})
	AADD(aCharSet,{'ã','&atilde;'})
	AADD(aCharSet,{'ä','&auml;'})
	AADD(aCharSet,{'å','&aring;'})
	AADD(aCharSet,{'æ','&aelig;'})
	AADD(aCharSet,{'ç','&ccedil;'})
	AADD(aCharSet,{'è','&egrave;'})
	AADD(aCharSet,{'é','&eacute;'})
	AADD(aCharSet,{'ê','&ecirc;'})
	AADD(aCharSet,{'ë','&euml;'})
	AADD(aCharSet,{'ì','&igrave;'})
	AADD(aCharSet,{'í','&iacute;'})
	AADD(aCharSet,{'î','&icirc;'})
	AADD(aCharSet,{'ï','&iuml;'})
	AADD(aCharSet,{'ð','&eth;'})
	AADD(aCharSet,{'ñ','&ntilde;'})
	AADD(aCharSet,{'ò','&ograve;'})
	AADD(aCharSet,{'ó','&oacute;'})
	AADD(aCharSet,{'ô','&ocirc;'})
	AADD(aCharSet,{'õ','&otilde;'})
	AADD(aCharSet,{'ö','&ouml;'})
	AADD(aCharSet,{'ø','&oslash;'})
	AADD(aCharSet,{'ù','&ugrave;'})
	AADD(aCharSet,{'ú','&uacute;'})
	AADD(aCharSet,{'û','&ucirc;'})
	AADD(aCharSet,{'ü','&uuml;'})
	AADD(aCharSet,{'ý','&yacute;'})
	AADD(aCharSet,{'þ','&thorn;'})
	AADD(aCharSet,{'ÿ','&yuml;'})
	
	For nX := 1 To Len(aCharSet)
		cString := StrTran(cString,aCharSet[nX,1],aCharSet[nX,2])
	Next nX
EndIf
	
Return cString