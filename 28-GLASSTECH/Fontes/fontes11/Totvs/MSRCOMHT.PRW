#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AIMAILM   ºAutor  ³Hermes Vieira Jr	 º Data ³  16/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Pedido de Venda / Orçamento / Despacho PV      º±±
±±           ³chamado via menu para envio via E-mail.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MP8 - TOP                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSRCOMHT(lAuto,cPedNum)

	Local 	lReg		:= .F. && Verifica a existencia de Registros
	Local 	nLastKey	:= 0
	Local 	titulo   	:= "Relatório Pedido de Compra"
	Local 	cMens 		:= "Não há registros para os parametros informados !!"
	Local 	cEmail    	:= ""
	Local 	cMailDig    := Space(60)
	Local 	oDL, oMail

	Local nCount		:= 0
	Local cNPc
	Local nFrete
	Local nTotal  := 0
	Local nTotal2 := 0
	Local nFrete := 0
	Local nDespesa := 0
	Local cHtml
	Local cOpt
	Local cQuery
	Local cEMISSAO
	Local cCond
	Local cTpFrete
	Local cE4Desc
	Local cValid
	Local cDesc1
	Local cDesc2
	Local cDesc3
	Local cTrans
	Local cNTran

	Local cEmail 		:= UsrRetMail(oApp:cUserId)//GetMV("ZZ_SCEMAIL")
	Local cConta 		:= GETMV("MV_RELACNT")
	Local cAutent 		:= GETMV("MV_RELAUTH")
	Local cEmailDe 	:= GETMV("MV_RELFROM")
	Local cPass 		:= GETMV("MV_RELPSW")
	Local cServ 		:= GETMV("MV_RELSERV")
	Local cLogo	:= GetSrvProfString("Startpath","") + "\Logo\lgrl" + cFilAnt + ".BMP"
	Local cLogoD  := GetSrvProfString("Startpath","") + "\Logo\lgrl" + cFilAnt + ".BMP"
	Local cDescr  := ""

	Local cPerg		:= "ALRCOM"

	Private nVlrTotal    := 0
	Private nVlrSol      := 0
	Private nTpag	       := 0
	Private nBasIPI      := 0
	Private nAlqIPI      := 0
	Private nValIPI      := 0
	Private nBasICM      := 0
	Private nAlqICM      := 0
	Private nValICM      := 0
	Private ntotIpi 		:= 0
	Private ntotIcm 		:= 0
	Private ntotSol 		:= 0
	Private ntotFrt 		:= 0
	Private ntotGer 		:= 0
	Private QtdItem      := 0
	Private ntotMerc     := 0
	Private nPrcLista    := 0
	Private cNivel       := ''
	Private nValMerc     := 0
	Private nDescZF := 0

	&& Faz a chamada do grupo de perguntas, caso a chamada seja feita a partir do menu
	If !lAuto
		ValidPerg(cPerg)
		If !(Pergunte(cPerg,.T.))
			Return
		Endif
	Endif

	If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
		return
	Endif

	&& Query que retorna os dados do pedido de compra e os dados dos itens.
	cQuery := "SELECT "
	cQuery += 	 "C7_EMISSAO,C7_NUM,C7_DATPRF,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_UM,C7_QUANT,C7_IPI,C7_PRECO,C7_TOTAL,"
	cQuery += 	 "C7_VALIPI,C7_VALFRE,C7_SEGURO,C7_VALICM,C7_DESPESA,C7_VLDESC,C7_TPFRETE,C7_CC,C7_OBS,C7_CONAPRO,C7_USER,C7_IPI,"
	cQuery += 	 "C7_MSG,C7_DESC1,C7_DESC2,C7_DESC3,C7_COND,C7_VALFRE,C7_ZZVALID,C7_ZZTRANS,C7_TES,"
	cQuery += 	 "A2_COD,A2_LOJA, A2_HPAGE, A2_NOME,A2_END,A2_CEP,A2_DDD,A2_TEL,A2_FAX,A2_EMAIL,A2_CGC,A2_INSCR,A2_MUN, A2_EST, A2_CONTATO, A2_BAIRRO,"
	cQuery +=    "E4_DESCRI,"
	cQuery +=    "CTT_DESC01,"
//cQuery +=    "AL_NOME, "
	cQuery +=    "A4_NOME "
	cQuery += "FROM "
	cQuery +=    RetSqlName("SC7") + " AS SC7 "
	cQuery += "INNER JOIN "
	cQuery +=    RetSqlName("SA2") + " AS SA2 ON A2_FILIAL = '" + xFilial("SA2") + "' AND C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("SA4") + " AS SA4 ON A4_FILIAL = '" + xFilial("SA4") + "' AND C7_ZZTRANS = A4_COD AND SA4.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("SE4") + " AS SE4 ON E4_FILIAL = '" + xFilial("SE4") + "' AND C7_COND = E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("CTT") + " AS CTT ON CTT_FILIAL = '" + xFilial("CTT") + "' AND C7_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ' ' "
//cQuery += "LEFT JOIN "
//cQuery +=    RetSqlName("SAL") + " AS SAL ON AL_FILIAL = '" + xFilial("SAL") + "' AND C7_APROV = AL_COD AND SAL.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE "
	cQuery +=    "C7_FILIAL = '" + xFilial("SC7") + "' "
	If !lAuto
		cQuery +=    "AND C7_NUM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		If !Empty(mv_par03) .AND. !Empty(mv_par04)
			cQuery +=    "AND C7_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
		EndIf
		cQuery +=    "AND C7_PRODUTO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
	Else
		cQuery +=    "AND C7_NUM = '" + cPedNum + "' "
	Endif
	cQuery +=    "AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY C7_NUM, C7_ITEM "

	TCQUERY cQuery NEW ALIAS "cAlias"

	TCSETFIELD("cAlias","C7_EMISSAO","D",08,00)
	TCSETFIELD("cAlias","C7_DATPRF","D",08,00)
	TCSETFIELD("cAlias","C7_ZZVALID","D",08,00)
	Count to nCount

	cAlias->(dbgotop())

	If 	cAlias->(EOF())
		MsgSTOP(cMens)
		cAlias->(dbCloseArea())
	Else

		oEmail   := CONEMAIL():New(cServ, cConta , cPass ,, cAutent)

		oEmail:PegaEmail()
		cEmailDe := AllTrim(oEmail:cEmail)

		Do While  cAlias->(!Eof())
			cNPc 		:= cAlias->C7_NUM
			cEmissao	:= cAlias->C7_EMISSAO
			cCond		:= cAlias->C7_COND
			cTpFrete	:= cAlias->C7_TPFRETE
			cE4Desc	:= cAlias->E4_DESCRI
			cValid		:= cAlias->C7_ZZVALID
			cDesc1		:= cAlias->C7_DESC1
			cDesc2 	:= cAlias->C7_DESC2
			cDesc3		:= cAlias->C7_DESC3
			cTrans		:= cAlias->C7_ZZTRANS
			cNTran		:= cAlias->A4_NOME

//Incluso tratamento com variavel cEmail para pegar os contatos atraves da tabela SA2
			//cEmail 		:= Alltrim(cAlias->A2_EMAIL)

			cHtml   := '<body>'

			cHtml   += '<table width="100%" border="0">'
			cHtml   += '<tr>'
			cHtml   += '	<td width="53%" height="99"><div align="left"><img src="'+cLogo+'" width="252" height="88"></div></td>'
			cHtml   += '	<td width="47%"><div align="left"><p><font size="2" face="Arial, Helvetica, sans-serif"><strong>'+ RTrim(SM0->M0_NOMECOM)+ '<br>'
			cHtml   +=  AllTrim(SM0->M0_ENDENT) + ' ' + AllTrim(SM0->M0_CIDENT) + '/' + AllTrim(SM0->M0_ESTENT) + ' ' + LEFT(AllTrim(SM0->M0_CEPENT),5) + '-' + RIGHT(AllTrim(SM0->M0_CEPENT),3) + '<br>'

			cHtml   += '	E-mail: ' + Alltrim(cEmail) + '<br>'

			cHtml   += '	Fone: '+AllTrim(SM0->M0_TEL) + ' FAX: ' + AllTrim(SM0->M0_FAX)+'<br>'
			cHtml   += ' 	CNPJ: '+ AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + ' - IE: ' +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999"))+ '</p>'
			cHtml   += '	</strong></font></div></td>'
			cHtml   += '</tr>'
			cHtml   += '</table>'

			cHtml   += '<hr> '
			cHtml   += '<table width="100%" border="0">'
			cHtml   += ' <tr>'
			cHtml   += '   <td><font size="3" face="Arial, Helvetica, sans-serif"><strong>Pedido de Compra N° '+cNPc+'</strong></font></td>'
			cHtml   += '   <td><div align="right"><font size="3" face="Arial, Helvetica, sans-serif"><strong>Data: ' + DTOC(cEMISSAO)+ '</strong></font></div></td>'
			cHtml   += ' </tr>'
			cHtml   += '</table>'
			cHtml   += '<hr>'

			cHtml   += '<table width="100%" border="0"> '
			cHtml   += '  <tr>'
			cHtml   += '    <td width="12%"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Fornecedor:</strong></font></td>'
			cHtml   += '    <td width="39%"><font size="2" face="Arial, Helvetica, sans-serif">'+ cAlias->A2_COD + " - " + cAlias->A2_NOME+'</font></td>'
			cHtml   += '    <td width="9%"><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>'
			cHtml   += '    <td width="40%">&nbsp;</td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>E-Mail:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A2_EMAIL+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Contato:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A2_CONTATO+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Endereço:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A2_END+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Bairro:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A2_BAIRRO+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cidade:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(cAlias->A2_MUN)+"/"+cAlias->A2_EST+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cep:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+LEFT(cAlias->A2_CEP,5) + "-" + RIGHT(cAlias->A2_CEP,3)+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Tel:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cAlias->A2_DDD + ') ' + LEFT(cAlias->A2_TEL,4) + '-' + SUBSTR(cAlias->A2_TEL,5,8)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>FAX:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cAlias->A2_DDD + ') ' + LEFT(cAlias->A2_FAX,4) + '-' + SUBSTR(cAlias->A2_FAX,5,8)+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'

			If LEN(ALLTRIM(cAlias->A2_CGC)) > 11
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>CNPJ:</strong></font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">' + AllTrim(Transform(cAlias->A2_CGC,"@R 99.999.999/9999-99")) + '</font></td>'
			eLSE
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>CPF:</strong></font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">' + AllTrim(Transform(cAlias->A2_CGC,"@R 999.999.999-99")) + '</font></td>'
			ENDIF
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>IE:</strong></font></td>'
			If LEN(ALLTRIM(cAlias->A2_INSCR)) > 6
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">' + AllTrim(Transform(cAlias->A2_INSCR,"@R 999.999.999.999")) + '</font></td>'
			Else
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">' + AllTrim(cAlias->A2_INSCR) + '</font></td>'
			EndIF
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Site:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">' + cAlias->A2_HPAGE + '</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>&nbsp;</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '</table>'
			cHtml   += '	<table width="100%" border="1">'
			cHtml   += '<tr>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Item</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Produto</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Descrição</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>UM</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Qtde.</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Unit.</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>%IPI</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Entrega</strong></font></td>'
			cHtml   += '  </tr>'

			nTotal:=0

			While cNPc == cAlias->C7_NUM
				
				cDescr  := Posicione("SB1",1,xFilial("SB1") + cAlias->C7_PRODUTO,"B1_DESC") 
				cHtml   += '  <tr>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->C7_ITEM)+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->C7_PRODUTO)+'</font></td>'
				//cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->C7_DESCRI)+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cDescr)+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+LTrim(cAlias->C7_UM)+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(cAlias->C7_QUANT))+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(cAlias->C7_PRECO,PesqPict('SC7', 'C7_PRECO')))+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(cAlias->C7_TOTAL,PesqPict('SC7', 'C7_TOTAL')))+'</font></td>'

				aRet:= {}
				aRet:= CalcImp()

				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4") + cAlias->C7_TES)
				If SF4->F4_IPI == "S"
					cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(aRet[2],4,1))+'</font></td>'
				Else
					cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">0.0</font></td>'
				EndIf
				SF4->(dbCloseArea())

				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+DTOC(cAlias->C7_DATPRF)+'</font></td>'
				cHtml   += '  </tr>'

				nTotal := cAlias->C7_TOTAL + nTotal

				nDespesa += cAlias->C7_DESPESA

				nFrete += cAlias->C7_VALFRE

				cNPc := cAlias->C7_NUM

				cAlias->(dbskip())

			EndDo

			cHtml   += '</table>'

			nTotal2 := nTotal + nDespesa + nFrete

			cHtml   += '<table width="100%" border="0">'

			cHtml   += '<tr>'
			cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Frete R$: </strong></font></div></td>'
			cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nFrete,PesqPict('SC7', 'C7_VALFRE'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
			cHtml   += '<td width="8%">&nbsp;</td>'
			cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total do Pedido R$:</strong></font></div></td>'
			cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nTotal,PesqPict('SC7', 'C7_TOTAL'))) + '</font></div></td>'
			cHtml   += '<tr> '
			cHtml   += '<tr>'
			cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Quantidade Peca R$: </strong></font></div></td>'
			cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(QtdItem,PesqPict('SC7', 'C7_VALFRE'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
			cHtml   += '<td width="8%">&nbsp;</td>'
			cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor do IPI R$:</strong></font></div></td>'
			cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(aRet[9],PesqPict('SC7', 'C7_TOTAL'))) + '</font></div></td>'
			cHtml   += '<tr> '
			cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Despesa R$:&nbsp;&nbsp;</strong></font></div></td>'
			cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nDespesa,PesqPict('SC7', 'C7_DESPESA'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
			cHtml   += '<td width="8%">&nbsp;</td>'
			cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total R$:</strong></font></div></td>'
			cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(aRet[15],PesqPict('SC7', 'C7_TOTAL'))) + '</font></div></td>'

			cHtml   += '</table>'

			cHtml   += '<hr>  '
			cHtml   += '<table width="100%" border="0">'
			cHtml   += '  <tr> '
			cHtml   += '    <td colspan="2"><div align="center"><strong><font size="3" face="Arial, Helvetica, sans-serif">Informações Gerais</font></strong></div></td> '
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td width="20%"><p><strong><font size="2" face="Arial, Helvetica, sans-serif">Forma de Pagamento:</font></strong></p></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+ cCond + ' - ' + cE4Desc +'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '    <td width="20%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Tipo de Frete:</font></strong></td>'
			If AllTrim(cTpFrete) = "C"
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">CIF</font></td> '
			Else
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">FOB</font></td> '
			EndIf
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td width="20%"><p><strong><font size="2" face="Arial, Helvetica, sans-serif">Validade:</font></strong></p></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+ DTOC(cValid) +'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr> '
			cHtml   += '    <td width="20%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Descontos %:</font></strong></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(TRANSFORM(cDesc1,PesqPict('SC7', 'C7_DESC1'))) + ' + ' + AllTrim(TRANSFORM(cDesc2,PesqPict('SC7', 'C7_DESC2'))) + ' + ' + AllTrim(TRANSFORM(cDesc3,PesqPict('SC7', 'C7_DESC3')))+'</font></td> '
			cHtml   += '  </tr>'
			cHtml   += '  <tr> '
			cHtml   += '    <td width="20%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Transportadora:</font></strong></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cTrans +') ' + cNTran + '</font></td> '
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'

/*	cHtml   += '  <tr> '
cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Reservado:</font></strong></td> '
cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>'
cHtml   += '  </tr> '
cHtml   += '  <tr> '
cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Mensagem:</font></strong></td> '
cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Transform(cAlias->C7_MSG,'@!S050')+'</font></td>'
cHtml   += '  </tr>'
*/
			cHtml   += '</table>'
			cHtml   += '<hr>

//Esta rotina nao sera mais utilizada, pois nao existe amarracao entre a tabela SU5 e SA2.
//cEmail := U_SU5COM(cNPC)

			oEmail:CONECTAR()

			Define MsDialog oDL Title "Complemento do E-mail do Destinátario" From 0, 0 To 70, 330 Pixel Style 128
			oDL:lEscClose := .f.
			Define Font oBold Name "Arial" Size 0, -13 Bold
			@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDL Size 30, 120 NoBorder When .f. Pixel
			@ 003,040 Say "E-Mail: " Font oBold Pixel
			@ 014, 030 To 016, 400 Label '' Of oDL  Pixel
			@ 003,070 MsGet oEndMa Var cMailDig Size 090,008 Pixel
			@ 020, 120 Button "Confirmar" Size 40, 13 Pixel Of oDL Action oDL:End()
			Activate MsDialog oDL Centered

			cEmail := IIF(!Empty(cMailDig), cEmail + ";" + cMailDig, cEmail)

			If oEmail:ENVIAR(cEmailDe,alltrim(cEmail),"Relatório de Pedido de Compra",cHtml)
				MsgInfo("Relatório do Pedido " + cNPc + " Enviado com Sucesso!!!","Envio de E-mail")
			EndIF

		EndDo
		cAlias->(dbCloseArea())
	EndIF

	Return .T.

Static Function CalcImp()
	Local aArea           := GetArea()
	Local cTipoCli        := POSICIONE("SA2",1,xFilial("SA2") + cAlias->A2_COD + cAlias->A2_LOJA,"A2_TIPO")
	Local cTipoNF         := "N"
	Local nVlrTotItem     := cAlias->C7_TOTAL
	Local nQuant         := cAlias->C7_QUANT
	Local nVlUnit         := cAlias->C7_PRECO

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&| Verifico o tipo da nota para efetuar o calculo                                          |
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	MaFisSave()
	MaFisEnd()

	/*MaFisIni(cAlias->A2_COD,;&& 1-Codigo Cliente/Fornecedor
	cAlias->A2_LOJA,;		&& 2-Loja do Cliente/Fornecedor
	"C",;				&& 3-C:Cliente , F:Fornecedor
	"N",;				&& 4-Tipo da NF
	cTipoCli,;		&& 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA120")*/

	MaFisIniPC(cAlias->C7_NUM,,,)	

	&&Na argentina o calculo de impostos depende da serie.
	If cPaisLoc == 'ARG'
		MaFisAlt('NF_SERIENF',LocXTipSer('SA2',MVNOTAFIS))
	Endif

	/*MaFisAdd(    cAlias->C7_PRODUTO                    ,;           // 1-Codigo do Produto ( Obrigatorio )
	cAlias->C7_TES                        ,;          // 2-Codigo do TES ( Opcional )
	cAlias->C7_QUANT                    ,;          // 3-Quantidade ( Obrigatorio )
	nVlUnit                    ,;          // 4-Preco Unitario ( Obrigatorio )
	0                                ,;           // 5-Valor do Desconto ( Opcional )
	""                                ,;          // 6-Numero da NF Original ( Devolucao/Benef )
	""                                ,;          // 7-Serie da NF Original ( Devolucao/Benef )
	""                                ,;          // 8-RecNo da NF Original no arq SD1/SD2
	0                                ,;          // 9-Valor do Frete do Item ( Opcional )
	0                                ,;          // 10-Valor da Despesa do item ( Opcional )
	0                                ,;        // 11-Valor do Seguro do item ( Opcional )
	0                                ,;          // 12-Valor do Frete Autonomo ( Opcional )
	(nVlUnit*cAlias->C7_QUANT)    ,;          // 13-Valor da Mercadoria ( Obrigatorio )
	0                                ,;          // 14-Valor da Embalagem ( Opiconal )
	0                                ,;          // 15-RecNo do SB1
	0                                )           // 16-RecNo do SF4

	MaFisWrite(1)*/

	nBasIPI := MaFisRet(1,'IT_BASEIPI')
	nValIPI := MaFisRet(1,'IT_VALIPI')
	nAlqIPI := MaFisRet(1,'IT_ALIQIPI')
	nBasICM := MaFisRet(1,'IT_BASEICM')
	nValICM := MaFisRet(1,'IT_VALICM')
	nAlqICM := MaFisRet(1,'IT_ALIQICM')
	nBasSol := MaFisRet(1,'IT_BASESOL')
	nValSol := MaFisRet(1,'IT_VALSOL')

	ntotIpi  += nValIPI
	ntotIcm  += nValICM
	nDescZF  := MaFisRet(,"NF_DESCZF")
	ntotSol  := MaFisRet(,"NF_VALSOL")
	ntotFrt  := MaFisRet(,"NF_FRETE")
	ntotDesp := MaFisRet(,"NF_DESPESA")
	ntotDesc := MaFisRet(,"NF_DESCONTO")
	ntotGer  := MaFisRet(,"NF_TOTAL")
	ntotMerc := MaFisRet(,"NF_VALMERC")


	nVlrSol += ntotSol

	nVlrTotal := ntotGer

	MaFisEnd()
	QtdItem += cAlias->C7_QUANT
	RestArea( aArea )
	Return ({nBasIPI,nAlqIPI,nValIPI,nBasICM,nValICM,nAlqICM,nBasSol,nValSol,ntotIpi,ntotIcm,nVlrSol,ntotFrt,ntotDesp,ntotDesc,nVlrTotal,ntotMerc})



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Hermes Vieira Jr.   º Data ³  15/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se existe um grupo de perguntas caso contrario o    º±±
±±º          ³ o grupo de perguntas e criado.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 - DB2                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
//cPerg := PADR(cPerg,6)
	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Pedido de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC7"})
	aAdd(aRegs, {cPerg, "02", "Pedido até "        			,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC7"})
	aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "04", "Data até "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
	aAdd(aRegs, {cPerg, "06", "Produto até "     			,"" ,"" ,"mv_ch6", "C", 06, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
//aAdd(aRegs, {cPerg, "03", "Onde Criar?"  			,"" ,"" ,"mv_ch3", "C", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)

	Return .T.

