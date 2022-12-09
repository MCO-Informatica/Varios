//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} RelNsaid
Relatùrio - Relatorio Notas de saida      
@author zReport
@since 08/06/2022
@version 1.0
	@example
	u_RelNsaid()
	@obs Funùùo gerada pelo zReport()
/*/
	
User Function RelNsaid()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definiùùes da pergunta
	cPerg := "NDESAIDA  "
	
	//Se a pergunta nùo existir, zera a variùvel
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	EndIf
	
	//Cria as definiùùes do relatùrio
	oReport := fReportDef()
	
	//Serù enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Senùo, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Funùùo que monta a definiùùo do relatùrio                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	//Criaùùo do componente de impressùo
	oReport := TReport():New(	"RelNsaid",;		//Nome do Relatùrio
								"Relatorio Notas de saida",;		//Tùtulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, serù impresso uma pùgina com os parùmetros, conforme privilùgio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de cùdigo que serù executado na confirmaùùo da impressùo
								)		//Descriùùo
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	//Criando a seùùo de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seùùo pertence
									"Dados",;		//Descriùùo da seùùo
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira serù considerada como principal da seùùo
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serùo impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatùrio
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOTA", "QRY_AUX", "Nota", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_PROD", "QRY_AUX", "Cod_prod", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_CLIENTE", "QRY_AUX", "Cod_cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME_FANT", "QRY_AUX", "Nome_fant", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME", "QRY_AUX", "Nome", /*Picture*/, 80, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MUNICIPIO", "QRY_AUX", "Municipio", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ESTADO", "QRY_AUX", "Estado", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_ISS", "QRY_AUX", "Cod_iss", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE", "QRY_AUX", "Quantidade", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRECO_UNIT", "QRY_AUX", "Preco_unit", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PIS", "QRY_AUX", "Pis", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COFINS", "QRY_AUX", "Cofins", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CSLL", "QRY_AUX", "Csll", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "IRR", "QRY_AUX", "Irr", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CONTA_CONTABIL", "QRY_AUX", "Cta Contabil", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESC_CONTA", "QRY_AUX", "Desc Cta Contabil", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LIQUIDO", "QRY_AUX", "Liquido", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TOTAL", "QRY_AUX", "Total", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COND_PGTO", "QRY_AUX", "Cond_pgto", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TES", "QRY_AUX", "TES", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFOP", "QRY_AUX", "Cfop", /*Picture*/, 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "D2_DTLCTCT", "QRY_AUX", "Dt. do Lanc.", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCONTO", "QRY_AUX", "Desconto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PEDIDO", "QRY_AUX", "Pedido", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRIMEIRO_VENCTO", "QRY_AUX", "Primeiro_vencto", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CENTRO_CUSTO", "QRY_AUX", "Cod. CC", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESC_CC", "QRY_AUX", "Desc. CC", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "STATUS", "QRY_AUX", "Status", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Funùùo que imprime o relatùrio                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as seùùes do relatùrio
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT "		+ STR_PULA
	cQryAux += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) EMISSAO,"		+ STR_PULA
	cQryAux += "D2_DOC NOTA, "		+ STR_PULA
	cQryAux += "D2_COD COD_PROD,"		+ STR_PULA
	cQryAux += "B1_DESC PRODUTO,"		+ STR_PULA
	cQryAux += "D2_CLIENTE COD_CLIENTE,"		+ STR_PULA
	cQryAux += "A1_NREDUZ NOME_FANT,"		+ STR_PULA
	cQryAux += "A1_NOME NOME,"		+ STR_PULA
	cQryAux += "A1_MUN MUNICIPIO,"		+ STR_PULA
	cQryAux += "A1_EST ESTADO,"		+ STR_PULA
	cQryAux += "B1_CODISS COD_ISS,"		+ STR_PULA
	cQryAux += "D2_QUANT QUANTIDADE,"		+ STR_PULA
	cQryAux += "D2_PRUNIT PRECO_UNIT,"		+ STR_PULA
	cQryAux += "FT_VRETPIS PIS,"		+ STR_PULA
	cQryAux += "FT_VRETCOF COFINS,"		+ STR_PULA
	cQryAux += "FT_VRETCSL CSLL,"		+ STR_PULA
	cQryAux += "FT_VALIRR IRR,"		+ STR_PULA
	cQryAux += "D2_CONTA CONTA_CONTABIL,"		+ STR_PULA
	cQryAux += "CASE WHEN FT_DTCANC <> ' ' THEN 'CANCELADA' ELSE 'AUTORIZADA' END STATUS," + STR_PULA
	cQryAux += "(SELECT CT1_DESC01 FROM CT1010 WHERE CT1_CONTA = D2_CONTA AND CT1010.D_E_L_E_T_='') DESC_CONTA,"		+ STR_PULA
	cQryAux += "D2_TOTAL - (D2_VALPIS+D2_VALCOF+D2_VALCSL) LIQUIDO,"		+ STR_PULA
	cQryAux += "D2_TOTAL TOTAL,"		+ STR_PULA
	cQryAux += "(SELECT E4_DESCRI FROM SE4010 WHERE (SELECT F2_COND FROM SF2010 WHERE F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA AND F2_FILIAL=D2_FILIAL AND SF2010.D_E_L_E_T_=' ') = E4_CODIGO AND SE4010.D_E_L_E_T_ =' ') COND_PGTO,"		+ STR_PULA
	cQryAux += "FT_CFOP CFOP,"		+ STR_PULA
	cQryAux += "D2_DTLCTCT,"		+ STR_PULA
	cQryAux += "D2_DESCON DESCONTO,"		+ STR_PULA
	cQryAux += "D2_PEDIDO PEDIDO,"		+ STR_PULA
	cQryAux += "(SELECT SUBSTRING(MIN(E1_VENCTO),7,2)+'/'+SUBSTRING(MIN(E1_VENCTO),5,2)+'/'+SUBSTRING(MIN(E1_VENCTO),1,4) FROM SE1010 WHERE E1_PREFIXO=D2_SERIE AND E1_NUM=D2_DOC AND E1_CLIENTE=D2_CLIENTE AND E1_LOJA=D2_LOJA AND E1_FILIAL=D2_FILIAL AND SE1010.D_E_L_E_T_=' ') PRIMEIRO_VENCTO, "		+ STR_PULA
	cQryAux += "D2_CCUSTO CENTRO_CUSTO, "		+ STR_PULA
	cQryAux += "(SELECT CTT_DESC01 FROM CTT010 WHERE CTT_CUSTO = D2_CCUSTO AND CTT010.D_E_L_E_T_='') DESC_CC,"		+ STR_PULA
	cQryAux += "D2_TES TES "		+ STR_PULA
	cQryAux += "FROM SD2010"		+ STR_PULA
	cQryAux += "JOIN SFT010 ON FT_NFISCAL = D2_DOC AND FT_SERIE = D2_SERIE AND FT_CLIEFOR = D2_CLIENTE AND FT_LOJA = D2_LOJA AND SFT010.D_E_L_E_T_ = ' ' AND FT_FILIAL = D2_FILIAL AND D2_ITEM = FT_ITEM "		+ STR_PULA
	cQryAux += "JOIN SA1010 ON A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SA1010.D_E_L_E_T_=' '"		+ STR_PULA
	cQryAux += "JOIN SB1010 ON B1_COD = D2_COD AND SB1010.D_E_L_E_T_ =' '"		+ STR_PULA
	cQryAux += "WHERE SD2010.D_E_L_E_T_=' '"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da rùgua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "D2_DTLCTCT", "D")
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a rùgua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()
		
		//Imprimindo a linha atual
		oSectDad:PrintLine()
		
		QRY_AUX->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return
