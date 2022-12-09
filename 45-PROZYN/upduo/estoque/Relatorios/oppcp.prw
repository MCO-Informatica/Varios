//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} oppcp01
Relat?rio - Rel. Producao OP PCP          
@author zReport
@since 04/10/2022
@version 1.0
	@example
	u_oppcp01()
	@obs Fun??o gerada pelo zReport()
/*/
	
User Function oppcp01()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Defini??es da pergunta
	cPerg := "OPPCP01   "
	
	//Se a pergunta n?o existir, zera a vari?vel
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	EndIf
	
	//Cria as defini??es do relat?rio
	oReport := fReportDef()
	
	//Ser? enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Sen?o, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Fun??o que monta a defini??o do relat?rio                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	//Cria??o do componente de impress?o
	oReport := TReport():New(	"oppcp01",;		//Nome do Relat?rio
								"Rel. Producao OP PCP",;		//T?tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser? impresso uma p?gina com os par?metros, conforme privil?gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c?digo que ser? executado na confirma??o da impress?o
								)		//Descri??o
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	
	//Criando a se??o de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a se??o pertence
									"Dados",;		//Descri??o da se??o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser? considerada como principal da se??o
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser?o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat?rio
	TRCell():New(oSectDad, "OP", "QRY_AUX", "Grupo", /*Picture*/, 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO", "QRY_AUX", "Tipo", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CODIGO", "QRY_AUX", "Codigo", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX", "Descricao", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE", "QRY_AUX", "Quantidade", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_REQUISCAO", "QRY_AUX", "Tipo_requiscao", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SEQUENCIAL", "QRY_AUX", "Sequencial", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_MOVIMENTO", "QRY_AUX", "Tipo_movimento", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Fun??o que imprime o relat?rio                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as se??es do relat?rio
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT  D3_OP OP"		+ STR_PULA
	cQryAux += "       ,B1_TIPO TIPO"		+ STR_PULA
	cQryAux += "       ,D3_COD  CODIGO"		+ STR_PULA
	cQryAux += "       ,B1_DESC DESCRICAO"		+ STR_PULA
	cQryAux += "       ,D3_QUANT QUANTIDADE"		+ STR_PULA
	cQryAux += "       ,D3_CF  TIPO_REQUISCAO"		+ STR_PULA
	cQryAux += "       ,D3_NUMSEQ SEQUENCIAL"		+ STR_PULA
	cQryAux += "       ,D3_TM   TIPO_MOVIMENTO"		+ STR_PULA
	cQryAux += "       ,SUBSTRING(D3_EMISSAO ,7,2)+'/'+SUBSTRING(D3_EMISSAO,5,2)+'/'+SUBSTRING(D3_EMISSAO,1,4)  AS EMISSAO "		+ STR_PULA
	cQryAux += "FROM SD3010 D3"		+ STR_PULA
	cQryAux += "INNER JOIN SB1010 B1"		+ STR_PULA
	cQryAux += "ON B1_COD = D3_COD AND B1.D_E_L_E_T_ <> '*'"		+ STR_PULA
	cQryAux += "WHERE D3_OP <> ''"		+ STR_PULA
	cQryAux += "AND D3_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "		+ STR_PULA
	cQryAux += "AND D3_CF = 'PR0'"		+ STR_PULA
	cQryAux += "AND D3.D_E_L_E_T_ <> '*'"		+ STR_PULA
	cQryAux += "AND D3_ESTORNO <> 'S' "		+ STR_PULA
	cQryAux += "UNION ALL"		+ STR_PULA
	cQryAux += "SELECT  D3_OP"		+ STR_PULA
	cQryAux += "       ,B1_TIPO"		+ STR_PULA
	cQryAux += "       ,D3_COD"		+ STR_PULA
	cQryAux += "       ,B1_DESC"		+ STR_PULA
	cQryAux += "       ,D3_QUANT"		+ STR_PULA
	cQryAux += "       ,D3_CF"		+ STR_PULA
	cQryAux += "       ,D3_NUMSEQ"		+ STR_PULA
	cQryAux += "       ,D3_TM"		+ STR_PULA
	cQryAux += "       ,SUBSTRING(D3_EMISSAO,7,2)+'/'+SUBSTRING(D3_EMISSAO,5,2)+'/'+SUBSTRING(D3_EMISSAO,1,4) AS D3_EMISSAO"		+ STR_PULA
	cQryAux += "FROM SD3010 D3"		+ STR_PULA
	cQryAux += "INNER JOIN SB1010 B1"		+ STR_PULA
	cQryAux += "ON B1_COD = D3_COD AND B1.D_E_L_E_T_ <> '*'"		+ STR_PULA
	cQryAux += "WHERE D3_OP <> ''"		+ STR_PULA
	cQryAux += "AND D3_EMISSAO BETWEEN '" + dTos(MV_PAR01) + "' AND '" + dTos(MV_PAR02) + "' "		+ STR_PULA
	cQryAux += "AND D3_CF <> 'PR0'"		+ STR_PULA
	cQryAux += "AND D3_COD LIKE 'MOD%'"		+ STR_PULA
	cQryAux += "AND D3.D_E_L_E_T_ <> '*'"		+ STR_PULA
	cQryAux += "AND D3_ESTORNO <> 'S'"		+ STR_PULA
	cQryAux += "ORDER BY D3.D3_OP, D3_NUMSEQ, D3_TM"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da r?gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a r?gua
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
