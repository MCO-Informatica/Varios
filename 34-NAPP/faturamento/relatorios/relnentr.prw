//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} relnentr
Relatrio - Relatorio notas de entrada    
@author zReport
@since 08/06/2022
@version 1.0
	@example
	u_relnentr()
	@obs Funo gerada pelo zReport()
/*/
	
User Function relnentr()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definies da pergunta
	cPerg := "RELNENTR "

	Pergunte(cPerg,.T.)
	
	//Se a pergunta no existir, zera a varivel
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	EndIf
	
	//Cria as definies do relatrio
	oReport := fReportDef()
	
	//Ser enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Seno, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Funo que monta a definio do relatrio                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	//Criao do componente de impresso
	oReport := TReport():New(	"relnentr",;		//Nome do Relatrio
								"Relatorio notas de entrada",;		//Ttulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser impresso uma pgina com os parmetros, conforme privilgio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de cdigo que ser executado na confirmao da impresso
								)		//Descrio
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	//Criando a seo de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seo pertence
									"Dados",;		//Descrio da seo
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser considerada como principal da seo
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores sero impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatrio
	TRCell():New(oSectDad, "DIGITACAO", "QRY_AUX", "Dt. Digitacao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOTA", "QRY_AUX", "Nota", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_PROD", "QRY_AUX", "Cod_prod", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_FORNECEDOR", "QRY_AUX", "Cod_fornecedor", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME_FANT", "QRY_AUX", "Nome_fant", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME", "QRY_AUX", "Nome", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	TRCell():New(oSectDad, "DESPESAS_FRETE", "QRY_AUX", "Despesas", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LIQUIDO", "QRY_AUX", "Liquido", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TOTAL", "QRY_AUX", "Total", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COND_PGTO", "QRY_AUX", "Cond_pgto", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TES", "QRY_AUX", "TES", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFOP", "QRY_AUX", "Cfop", /*Picture*/, 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DT_CONTABIL", "QRY_AUX", "Dt_contabil", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCONTO", "QRY_AUX", "Desconto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PEDIDO", "QRY_AUX", "Pedido", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRIMEIRO_VENCTO", "QRY_AUX", "Primeiro_vencto", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CENTRO_CUSTO", "QRY_AUX", "Cod. CC", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESC_CC", "QRY_AUX", "Desc. CC", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "STATUS", "QRY_AUX", "Status", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Funo que imprime o relatrio                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as sees do relatrio
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT "		+ STR_PULA
	cQryAux += "SUBSTRING(D1_EMISSAO,7,2)+'/'+SUBSTRING(D1_EMISSAO,5,2)+'/'+SUBSTRING(D1_EMISSAO,1,4) EMISSAO,"		+ STR_PULA
	cQryAux += "D1_DOC NOTA, "		+ STR_PULA
	cQryAux += "D1_COD COD_PROD,"		+ STR_PULA
	cQryAux += "B1_DESC PRODUTO,"		+ STR_PULA
	cQryAux += "D1_FORNECE COD_FORNECEDOR,"		+ STR_PULA
	cQryAux += "A2_NREDUZ NOME_FANT,"		+ STR_PULA
	cQryAux += "A2_NOME NOME,"		+ STR_PULA
	cQryAux += "A2_MUN MUNICIPIO,"		+ STR_PULA
	cQryAux += "A2_EST ESTADO,"		+ STR_PULA
	cQryAux += "B1_CODISS COD_ISS,"		+ STR_PULA
	cQryAux += "D1_QUANT QUANTIDADE,"		+ STR_PULA
	cQryAux += "D1_VUNIT PRECO_UNIT,"		+ STR_PULA
	cQryAux += "COALESCE(FT_VRETPIS,D1_VALPIS) PIS,"		+ STR_PULA
	cQryAux += "COALESCE(FT_VRETCOF,D1_VALCOF) COFINS,"		+ STR_PULA
	cQryAux += "COALESCE(FT_VRETCSL,D1_VALCSL) CSLL,"		+ STR_PULA
	cQryAux += "COALESCE(FT_VALIRR,D1_VALIRR) IRR,"		+ STR_PULA
	cQryAux += "D1_CONTA CONTA_CONTABIL,"		+ STR_PULA
	cQryAux += "(SELECT CT1_DESC01 FROM CT1010 WHERE CT1_CONTA = D1_CONTA AND CT1010.D_E_L_E_T_='') DESC_CONTA,"		+ STR_PULA
	cQryAux += "D1_VALFRE+D1_SEGURO+D1_DESPESA DESPESAS_FRETE,"		+ STR_PULA
	cQryAux += "D1_TOTAL - (D1_VALPIS+D1_VALCOF+D1_VALCSL) LIQUIDO,"		+ STR_PULA
	cQryAux += "D1_TOTAL+D1_VALFRE+D1_SEGURO+D1_DESPESA TOTAL,"		+ STR_PULA
	cQryAux += "(SELECT E4_DESCRI FROM SE4010 WHERE (SELECT F1_COND FROM SF1010 WHERE F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA AND F1_FILIAL=D1_FILIAL AND SF1010.D_E_L_E_T_=' ') = E4_CODIGO AND SE4010.D_E_L_E_T_ =' ') COND_PGTO,"		+ STR_PULA
	cQryAux += "COALESCE(FT_CFOP,D1_CF) CFOP,"		+ STR_PULA
	cQryAux += "(SELECT F1_DTLANC FROM SF1010 WHERE F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA AND F1_FILIAL=D1_FILIAL AND SF1010.D_E_L_E_T_=' ') DT_CONTABIL,"		+ STR_PULA
	cQryAux += "D1_VALDESC DESCONTO,"		+ STR_PULA
	cQryAux += "D1_PEDIDO PEDIDO,"		+ STR_PULA
	cQryAux += "(SELECT SUBSTRING(MIN(E2_VENCTO),7,2)+'/'+SUBSTRING(MIN(E2_VENCTO),5,2)+'/'+SUBSTRING(MIN(E2_VENCTO),1,4) FROM SE2010 WHERE E2_PREFIXO=D1_SERIE AND E2_NUM=D1_DOC AND E2_FORNECE=D1_FORNECE AND E2_LOJA=D1_LOJA AND E2_FILIAL=D1_FILIAL AND SE2010.D_E_L_E_T_=' ') PRIMEIRO_VENCTO,"		+ STR_PULA
	cQryAux += "SUBSTRING(D1_DTDIGIT,7,2)+'/'+SUBSTRING(D1_DTDIGIT,5,2)+'/'+SUBSTRING(D1_DTDIGIT,1,4) DIGITACAO, "		+ STR_PULA
	cQryAux += "D1_CC CENTRO_CUSTO, "		+ STR_PULA
	cQryAux += "(SELECT CTT_DESC01 FROM CTT010 WHERE CTT_CUSTO = D1_CC AND CTT010.D_E_L_E_T_='') DESC_CC,"		+ STR_PULA
	cQryAux += "D1_TES TES "		+ STR_PULA
	cQryAux += "FROM SD1010"		+ STR_PULA
	cQryAux += "LEFT JOIN SFT010 ON FT_NFISCAL = D1_DOC AND FT_SERIE = D1_SERIE AND FT_CLIEFOR = D1_FORNECE AND FT_LOJA = D1_LOJA AND SFT010.D_E_L_E_T_ = ' ' AND FT_FILIAL = D1_FILIAL AND FT_ITEM = D1_ITEM "		+ STR_PULA
	cQryAux += "JOIN SA2010 ON A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND SA2010.D_E_L_E_T_=' '"		+ STR_PULA
	cQryAux += "JOIN SB1010 ON B1_COD = D1_COD AND SB1010.D_E_L_E_T_ =' '"		+ STR_PULA
	cQryAux += "WHERE SD1010.D_E_L_E_T_=' ' "		+ STR_PULA
	cQryAux += "AND D1_DTDIGIT BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "		+ STR_PULA
	cQryAux += ";"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da rgua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a rgua
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
