#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSRORCHT  ºAutor  ³Hermes Vieira Jr	 º Data ³  16/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Pedido de Venda / Orçamento / Despacho PV      º±±
±±           ³chamado via menu para envio via E-mail.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MP8 - TOP                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSRORCHT(lAuto,cNum)

	Local 	lReg		:= .F. && Verifica a existencia de Registros
	Local 	nLastKey	:= 0
	Local 	titulo   	:= "Relatório de Orçamento"
	Local 	cMens 		:= "Não há registros para os parametros informados !!"
	Local 	cEmail    	:= ""
	Local 	cMailDig    := Space(60)
	Local 	oDL, oMail

	Local nCount		:= 0
	Local nFrete
	Local nTotal
	Local cHtml
	Local cOpt
	Local cQuery
	Local cEMISSAO

	Local	cCond 		:=	""
	Local	cDescri 	:= 	""
	Local	cPedCli		:= 	""
	Local	cDesc1		:=  ""
	Local	cDesc2		:= 	""
	Local	cDesc3		:= 	""
	Local	cValid		:= 	""
	Local	cTrans		:= 	""
	Local	cNTrans		:= 	""
	Local	cVend		:= 	""
	Local	cNVend 		:= 	""
	Local	cObs		:=  ""
	Local 	cEmail 		:= GetMV("ZZ_SCEMAIL")

	Local cConta 		:= GETMV("MV_RELACNT")
	Local cAutent 		:= GETMV("MV_RELAUTH")
	Local cEmailDe 		:= GETMV("MV_RELFROM")
	Local cPass 		:= GETMV("MV_RELPSW")
	Local cServ 		:= GETMV("MV_RELSERV")
	Local cLogoMail   := GETMV("ZZ_LOGOEMA")

	Local cPerg				:= "PERORC"
	Private nVlrTotal    := 0
	Private nVlrSol      := 0
	Private nDescZF := 0
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
	Private cCliloja     := ''
	Default lAuto := .F.
	Default cNum  := ""

	ValidPerg(cPerg)

	If lAuto
		mv_par01 := cNum
		mv_par02 := cNum
		mv_par03 := Ctod("01/01/1990")
		mv_par04 := Ctod("31/12/2060")
	Else
		If !(Pergunte(cPerg,.T.))
			Return
		Endif
	Endif

	If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
		return
	Endif

// Query que retorna os dados do orcamento e os dados dos itens.
	cQuery := "SELECT "
	cQuery += "		SCJ.CJ_NUM, SCJ.CJ_EMISSAO, SCJ.CJ_CONDPAG, SCJ.CJ_DESC1, SCJ.CJ_DESC2, SCJ.CJ_DESC3, SCJ.CJ_FRETE, SCJ.CJ_DESPESA, "
	cQuery += "		SCJ.CJ_DESC4, SCJ.CJ_DATA1, SCJ.CJ_DATA2, SCJ.CJ_DATA3, SCJ.CJ_DATA4, SCJ.CJ_PARC1, SCJ.CJ_PARC2,SCJ.CJ_COTCLI,CJ_ZZNIVEL, "
	cQuery += "		SCJ.CJ_PARC3, SCJ.CJ_PARC4, SCJ.CJ_CLIENTE, SCJ.CJ_LOJA, SCJ.CJ_VALIDA, SCJ.CJ_ZZTRANS,SCJ.CJ_VEND,SCJ.CJ_ZZOBS,SE4.E4_DESCRI, "
	cQuery += "		SCK.CK_ITEM, SCK.CK_NUM, SCK.CK_PRODUTO, SCK.CK_DESCRI, SCK.CK_UM,SCK.CK_TES,CK_ENTREG,CK_ZZPRCD,CK_ZZPRCF, "
	cQuery += "		SCK.CK_QTDVEN,SCK.CK_PEDCLI, SCK.CK_PRCVEN, SCK.CK_VALOR,SCK.CK_OBS, SB1.B1_IPI, "
	cQuery += "		SA1.A1_COD,	SA1.A1_NOME, SA1.A1_EMAIL, SA1.A1_END, SA1.A1_MUN, SA1.A1_EST, SA1.A1_DDD, SA1.A1_TEL, SA1.A1_FAX, SA1.A1_CEP, SA1.A1_BAIRRO, SA1.A1_CONTATO, SA1.A1_HPAGE, SA1.A1_CGC, SA1.A1_INSCR, "
	cQuery += "		SA3.A3_NOME,"
	cQuery += "		SA4.A4_NOME "
	cQuery += "FROM " + RetSqlName("SCJ") + " AS SCJ "
	cQuery += "		INNER JOIN " + RetSqlName("SCK") + " AS SCK ON "
	cQuery += "			SCK.CK_FILIAL = '" + xFilial("SCK")+ "' AND SCJ.CJ_NUM = SCK.CK_NUM AND SCK.D_E_L_E_T_ = ' ' "
	cQuery += "		INNER JOIN " + RetSqlName("SA1") + " AS SA1 ON "
	cQuery += "				SA1.A1_FILIAL = '" + xFilial("SA1")+ "' AND SCJ.CJ_CLIENTE = SA1.A1_COD AND SCJ.CJ_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SE4") + " AS SE4 ON "
	cQuery += "				SE4.E4_FILIAL = '" + xFilial("SE4")+ "' AND SCJ.CJ_CONDPAG = SE4.E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SB1") + " AS SB1 ON "
	cQuery += "				SB1.B1_FILIAL = '" + xFilial("SB1")+ "' AND SCK.CK_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA3") + " AS SA3 ON "
	cQuery += "				SA3.A3_FILIAL = '" + xFilial("SA3")+ "' AND SA3.A3_COD = SCJ.CJ_VEND AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA4") + " AS SA4 ON "
	cQuery += "				SA4.A4_FILIAL = '" + xFilial("SA4")+ "' AND SA4.A4_COD = SCJ.CJ_ZZTRANS AND SA4.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE SCJ.CJ_FILIAL = '" + xFilial("SCJ")+ "' AND SCJ.D_E_L_E_T_ = ' ' AND SCJ.CJ_NUM >= '"+ mv_par01 +"' AND SCJ.CJ_NUM <= '"+ mv_par02 +"' "
	If !Empty(mv_par03) .AND. !Empty(mv_par04)
		cQuery += " AND CJ_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
	EndIf
	cQuery += "ORDER BY SCJ.CJ_NUM, SCK.CK_ITEM "

	TCQUERY cQuery NEW ALIAS "cAlias"

	Count to nCount

	cAlias->(dbgotop())

	If 	cAlias->(EOF())
		MsgSTOP(cMens)
		cAlias->(dbCloseArea())
	Else

		oEmail:= CONEMAIL():New(cServ, cConta , cPass ,, cAutent)

		oEmail:PegaEmail()
		cEmailDe := AllTrim(oEmail:cEmail)

		Do While  cAlias->(!Eof())

			TCSETFIELD("cAlias","CJ_EMISSAO","D",08,00)
			TCSETFIELD("cAlias","CJ_VALIDA","D")

			cCliLoja := Alltrim(cAlias->CJ_CLIENTE+cAlias->CJ_LOJA)

			cOrc 	:= cAlias->CJ_NUM
			cEmissao:= cAlias->CJ_EMISSAO
			cHtml   := '<body>'

			cHtml   += '<table width="100%" border="0">'
			cHtml   += '<tr>
			cHtml   += '	<td width="53%" height="99"><div align="left"><img src="'+cLogoMail+'" width="252" height="88"></div></td>'
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
			cHtml   += '   <td><font size="3" face="Arial, Helvetica, sans-serif"><strong>Orçamento N° '+cOrc+'</strong></font></td>'
			cHtml   += '   <td><div align="right"><font size="3" face="Arial, Helvetica, sans-serif"><strong>Data: ' + DTOC(cEMISSAO)+ '</strong></font></div></td>'
			cHtml   += ' </tr>'
			cHtml   += '</table>'
			cHtml   += '<hr>'

			cHtml   += '<table width="100%" border="0"> '
			cHtml   += '  <tr>'
			cHtml   += '    <td width="12%"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cliente:</strong></font></td>'
			cHtml   += '    <td width="39%"><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->CJ_CLIENTE + '/' + cAlias->CJ_LOJA +'-'+cAlias->A1_NOME+'</font></td>'
			cHtml   += '    <td width="9%"><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>'
			cHtml   += '    <td width="40%">&nbsp;</td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>E-Mail:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_EMAIL+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Contato:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_CONTATO+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Endereço:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_END+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Bairro:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_BAIRRO+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cidade:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(cAlias->A1_MUN)+"/"+cAlias->A1_EST+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cep:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+LEFT(cAlias->A1_CEP,5) + "-" + RIGHT(cAlias->A1_CEP,3)+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Tel:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cAlias->A1_DDD + ') ' + LEFT(cAlias->A1_TEL,4) + '-' + SUBSTR(cAlias->A1_TEL,5,8) + '</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>FAX:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cAlias->A1_DDD + ') ' + LEFT(cAlias->A1_FAX,4) + '-' + SUBSTR(cAlias->A1_FAX,5,8) + '</font></td>'
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
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>%ICMS</strong></font></td>'
			cHtml   += '  </tr>'

			nTotal:=0

			nFrete   := cAlias->CJ_FRETE

			nDespesa := cAlias->CJ_DESPESA

			cCond 		:=	cAlias->CJ_CONDPAG
			cDescri 	:= 	cAlias->E4_DESCRI
			cPedCli	:= 	cAlias->CJ_COTCLI
			cDesc1		:=  cAlias->CJ_DESC1
			cDesc2		:= 	cAlias->CJ_DESC2
			cDesc3		:= 	cAlias->CJ_DESC3
			cValid		:= 	cAlias->CJ_VALIDA
			cTrans		:= 	cAlias->CJ_ZZTRANS
			cNTrans	:= 	cAlias->A4_NOME
			cVend		:= 	cAlias->CJ_VEND
			cNVend 		:= 	cAlias->A3_NOME
			cObs		:=  cAlias->CJ_ZZOBS

			cNivel := Alltrim(cAlias->CJ_ZZNIVEL)

			While cOrc == cAlias->CJ_NUM

				TCSETFIELD("cAlias","CK_ENTREG","D")

				IF cNivel == '1'
					nPrcLista := cAlias->CK_PRCVEN
					nValMerc  := cAlias->CK_QTDVEN * cAlias->CK_PRCVEN
				ElseIf cNivel == '2' .Or. cNivel == '3'
					nPrcLista := cAlias->CK_ZZPRCD
					nValMerc  := cAlias->CK_QTDVEN * cAlias->CK_ZZPRCD
				ElseIf cNivel == '4' .Or. cNivel == '6'
					nPrcLista := cAlias->CK_ZZPRCF
					nValMerc  := cAlias->CK_QTDVEN * cAlias->CK_ZZPRCF
				ElseIf cNivel == '8'
					nPrcLista := cAlias->CK_ZZPRCF
					nValMerc  := cAlias->CK_QTDVEN * cAlias->CK_ZZPRCF
				EndIF

				cHtml   += '  <tr>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->CK_ITEM)+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->CK_PRODUTO)+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->CK_DESCRI)+'-Ped.Cli:' +  If(!Empty(cAlias->CK_PEDCLI),'-Ped.Cli:' + Alltrim(cAlias->CK_PEDCLI),'')+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+LTrim(cAlias->CK_UM)+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(cAlias->CK_QTDVEN))+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(nPrcLista, PesqPict('SCK', 'CK_PRCVEN')))+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(nValMerc, PesqPict('SCK', 'CK_VALOR')))+'</font></td>'


				aRet:= {}
				aRet:= CalcImp()

				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4") + cAlias->CK_TES)
				If SF4->F4_IPI == "S"
					cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(aRet[2],4,1))+'</font></td>'
				Else
					cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">0.0</font></td>'
				EndIf
				If SF4->F4_ICM == "S"
					cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(aRet[6],4,1))+'</font></td>'
				Else
					cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">0.0</font></td>'
				EndIf
				SF4->(dbCloseArea())

				&&				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+DtoC(cAlias->CK_ENTREG)+'</font></td>'
				cHtml   += '  </tr>'


				nTotal 	:= cAlias->CK_VALOR + nTotal

				cOrc 	:= cAlias->CK_NUM

				cAlias->(dbskip())

			EndDo

			nTotal := nTotal + nFrete + nDespesa

			cHtml   += '</table>'
			cHtml   += '<br>'

			cHtml   += '<table width="100%" border="0">'

			cHtml   += '<tr>'
			cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Frete R$: </strong></font></div></td>'
			cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(aRet[12], PesqPict('SCJ', 'CJ_FRETE'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
			cHtml   += '<td width="8%">&nbsp;</td>'
			cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor da Despesa R$:</strong></font></div></td>'
			cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(aRet[13], PesqPict('SCJ', 'CJ_DESPESA'))) + '</font></div></td>'
			cHtml   += '</tr><tr> '
			cHtml   += '<tr>'
			cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor IPI R$: </strong></font></div></td>'
			cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(aRet[9], PesqPict('SCJ', 'CJ_FRETE'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
			cHtml   += '<td width="8%">&nbsp;</td>'
			cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor da ICMS R$:</strong></font></div></td>'
			cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(aRet[10], PesqPict('SCJ', 'CJ_DESPESA'))) + '</font></div></td>'
			cHtml   += '</tr><tr> '
			cHtml   += '<tr>'
			cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Total Merc. R$: </strong></font></div></td>'
			cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(aRet[16], PesqPict('SCK', 'CK_VALOR'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
			cHtml   += '<td width="8%">&nbsp;</td>'
			cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Qtd Peças:</strong></font></div></td>'
			cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(QtdItem, PesqPict('SCK', 'CK_QTDVEN'))) + '</font></div></td>'
			cHtml   += '</tr><tr> '
			cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor ST R$: </strong></font></div></td>'
			cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">'+ Alltrim(Transform(aRet[11], PesqPict('SCJ', 'CJ_FRETE'))) +'</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
			cHtml   += '<td width="8%">&nbsp;</td>'
			cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total R$:</strong></font></div></td>'
			If nDescZF >0
				aRet[15]:= aRet[15] - nDescZF
			EndIF
			cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(aRet[15], PesqPict('SCK', 'CK_VALOR'))) + '</font></div></td>'
			cHtml   += "</tr>"

			cHtml   += '</table>'

			cHtml   += '<hr>  '
			cHtml   += '<table width="100%" border="0">'
			cHtml   += '  <tr> '
			cHtml   += '    <td colspan="2"><div align="center"><strong><font size="3" face="Arial, Helvetica, sans-serif">Informações Gerais</font></strong></div></td> '
			cHtml   += '  </tr>'
			cHtml   += '  <tr>'
			cHtml   += '    <td> <p><strong><font size="2" face="Arial, Helvetica, sans-serif">Forma de Pagamento:</font></strong></p></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+ cCond + ' - ' + cDescri +'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr> '
			cHtml   += '    <td width="23%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Nº Orçamento Cliente:</font></strong></td>'
			cHtml   += '    <td width="77%"><font size="2" face="Arial, Helvetica, sans-serif">'+ cPedCli +'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr> '
			cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Nível:</font></strong></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim("Nível do Cliente") + ' + ' + AllTrim(TRANSFORM(cDesc2, PesqPict('SCJ', 'CJ_DESC2'))) + ' + ' + AllTrim(TRANSFORM(cDesc3, PesqPict('SCJ', 'CJ_DESC3')))+'</font></td> '
			cHtml   += '  </tr>'
			cHtml   += '  <tr> '
			cHtml   += '    <td width="23%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Validade:</font></strong></td>'
			cHtml   += '    <td width="77%"><font size="2" face="Arial, Helvetica, sans-serif">'+ DTOC(cValid) +'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr> '
			cHtml   += '    <td width="23%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Transportadora:</font></strong></td>'
			cHtml   += '    <td width="77%"><font size="2" face="Arial, Helvetica, sans-serif">('+ cTrans + ') ' + cNTrans + '</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr> '
			cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Vendedor:</font></strong></td> '
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cVend + ') ' +cNVend  + '</font></td>'
			cHtml   += '  </tr> '
			cHtml   += '  <tr> '
			cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Obs.:</font></strong></td> '
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+SubStr(cObs,1,100)+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr> '
			cHtml   += '    <td colspan="2"><font size="2" face="Arial, Helvetica, sans-serif">'+SubStr(cObs,101,100)+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr> '
			cHtml   += '    <td colspan="2"><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td> '
			cHtml   += '  </tr>'
			cHtml   += '</table>'
			cHtml   += '<hr>'

			oEmail:CONECTAR()

/*cEmail := U_SU5Orc(cOrc)
If Empty(cEmail)
cEmail := Alltrim(cAlias->A1_EMAIL)
Endif


Define MsDialog oDL Title "Complemento do E-mail do Destinátario" From 0, 0 To 70, 330 Pixel Style 128
oDL:lEscClose := .f.
Define Font oBold Name "Arial" Size 0, -13 Bold
@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDL Size 30, 120 NoBorder When .f. Pixel
@ 003,040 Say "E-Mail: " Font oBold Pixel
@ 014, 030 To 016, 400 Label '' Of oDL  Pixel
@ 003,070 MsGet oEndMa  		Var cMailDig  					Size 090,008 Pixel //	Valid cMailDig <> Space(60) .AND. "@" $ cMailDig
@ 020, 120 Button "Confirmar" 		Size 40, 13 Pixel Of oDL Action oDL:End()
Activate MsDialog oDL Centered
*/
			cEmail := U_TWMKCONT(cCliLoja)

			&&cEmail := IIF(!Empty(cMailDig), cEmail + ";" + cMailDig, cEmail)

			If oEmail:ENVIAR(cEmailDe,alltrim(cEmail),"Relatório de Orçamento",cHtml)
				MsgInfo("Relatório do Orçamento referente ao Pedido " + cOrc + " Enviado com Sucesso!!!","Envio de E-mail")
			EndIF

		EndDo
		cAlias->(dbCloseArea())
	EndIF

	Return .T.

Static Function CalcImp()
	Local aArea           := GetArea()
	Local cTipoCli        := POSICIONE("SA1",1,xFilial("SA1") + cAlias->CJ_CLIENTE + cAlias->CJ_LOJA,"A1_TIPO")
	Local cTipoNF         := "N"
	Local nVlrTotItem     := cAlias->CK_VALOR
	Local nQuant         := cAlias->CK_QTDVEN
	Local nVlUnit         := cAlias->CK_PRCVEN

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&| Verifico o tipo da nota para efetuar o calculo                                          |
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	MaFisSave()
	MaFisEnd()

	MaFisIni(cAlias->CJ_CLIENTE,;&& 1-Codigo Cliente/Fornecedor
	cAlias->CJ_LOJA,;		&& 2-Loja do Cliente/Fornecedor
	"C",;				&& 3-C:Cliente , F:Fornecedor
	"N",;				&& 4-Tipo da NF
	cTipoCli,;		&& 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")

	&&Na argentina o calculo de impostos depende da serie.
	If cPaisLoc == 'ARG'
		MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
	Endif

	MaFisAdd(    cAlias->CK_PRODUTO                    ,;           // 1-Codigo do Produto ( Obrigatorio )
	cAlias->CK_TES                        ,;          // 2-Codigo do TES ( Opcional )
	cAlias->CK_QTDVEN                    ,;          // 3-Quantidade ( Obrigatorio )
	nPrcLista                    ,;          // 4-Preco Unitario ( Obrigatorio )
	0                                ,;           // 5-Valor do Desconto ( Opcional )
	""                                ,;          // 6-Numero da NF Original ( Devolucao/Benef )
	""                                ,;          // 7-Serie da NF Original ( Devolucao/Benef )
	""                                ,;          // 8-RecNo da NF Original no arq SD1/SD2
	0                                ,;          // 9-Valor do Frete do Item ( Opcional )
	0                                ,;          // 10-Valor da Despesa do item ( Opcional )
	0                                ,;        // 11-Valor do Seguro do item ( Opcional )
	0                                ,;          // 12-Valor do Frete Autonomo ( Opcional )
	(nPrcLista*cAlias->CK_QTDVEN)    ,;          // 13-Valor da Mercadoria ( Obrigatorio )
	0                                ,;          // 14-Valor da Embalagem ( Opiconal )
	0                                ,;          // 15-RecNo do SB1
	0                                )           // 16-RecNo do SF4

	MaFisWrite(1)

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
	nDescZF := MaFisRet(,"NF_DESCZF")
	ntotSol  := MaFisRet(,"NF_VALSOL")
	ntotFrt  := MaFisRet(,"NF_FRETE")
	ntotDesp := MaFisRet(,"NF_DESPESA")
	ntotDesc := MaFisRet(,"NF_DESCONTO")
	ntotGer  := MaFisRet(,"NF_TOTAL")
	ntotMerc += MaFisRet(,"NF_VALMERC")


	nVlrSol += ntotSol

	nVlrTotal += ntotGer

	MaFisEnd()
	QtdItem += cAlias->CK_QTDVEN
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
	aAdd(aRegs, {cPerg, "01", "Pedido de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SCJ"})
	aAdd(aRegs, {cPerg, "02", "Pedido até "        			,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SCJ"})
	aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "04", "Data até "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
//aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
//aAdd(aRegs, {cPerg, "06", "Produto até "     			,"" ,"" ,"mv_ch6", "C", 06, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
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

