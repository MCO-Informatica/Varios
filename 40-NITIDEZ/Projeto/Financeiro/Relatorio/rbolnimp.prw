//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} rbolnimp
Relatùrio - Relatorio Boletos N Impressos 
@author zReport
@since 28/09/2022
@version 1.0
	@example
	u_rbolnimp()
	@obs Funùùo gerada pelo zReport()
/*/
	
User Function rbolnimp()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definiùùes da pergunta
	cPerg := "RBOLNOIMP "

	Pergunte(cPerg,.T.)
	
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
	Local oFunTot1 := Nil
	
	//Criaùùo do componente de impressùo
	oReport := TReport():New(	"rbolnimp",;		//Nome do Relatùrio
								"Relatorio Boletos N Impressos",;		//Tùtulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, serù impresso uma pùgina com os parùmetros, conforme privilùgio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de cùdigo que serù executado na confirmaùùo da impressùo
								)		//Descriùùo
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	
	//Criando a seùùo de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seùùo pertence
									"Dados",;		//Descriùùo da seùùo
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira serù considerada como principal da seùùo
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serùo impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatùrio
	TRCell():New(oSectDad, "PREFIXO", "QRY_AUX", "Prefixo", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMERO", "QRY_AUX", "Numero", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PARCELA", "QRY_AUX", "Parcela", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO", "QRY_AUX", "Tipo", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_NAT", "QRY_AUX", "Cod Naturez", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_FORN", "QRY_AUX", "Cod Fornec", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOJA_FORN", "QRY_AUX", "Loja Forn", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FORNECEDOR", "QRY_AUX", "Fornecedor", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENCIMENTO", "QRY_AUX", "Vencimento", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR", "QRY_AUX", "Valor", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BANCO", "QRY_AUX", "Banco", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BORDERO", "QRY_AUX", "Bordero", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
	//Totalizadores
	oFunTot1 := TRFunction():New(oSectDad:Cell("VALOR"),,"SUM",,,"@E 999,999,999.99")
	oFunTot1 := TRFunction():New(oSectDad:Cell("NUMERO"),,"COUNT",,,"@E")
	oFunTot1:SetEndReport(.F.)
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
	cQryAux += "E2_PREFIXO PREFIXO,"		+ STR_PULA
	cQryAux += "E2_NUM NUMERO,"		+ STR_PULA
	cQryAux += "E2_PARCELA PARCELA,"		+ STR_PULA
	cQryAux += "E2_TIPO TIPO,"		+ STR_PULA
	cQryAux += "E2_NATUREZ COD_NAT,"		+ STR_PULA
	cQryAux += "E2_FORNECE COD_FORN,"		+ STR_PULA
	cQryAux += "E2_LOJA LOJA_FORN,"		+ STR_PULA
	cQryAux += "E2_NOMFOR FORNECEDOR,"		+ STR_PULA
	cQryAux += "CONCAT(SUBSTRING(E2_EMISSAO,7,2),'/',SUBSTRING(E2_EMISSAO,5,2),'/',SUBSTRING(E2_EMISSAO,1,4)) EMISSAO,"		+ STR_PULA
	cQryAux += "CONCAT(SUBSTRING(E2_VENCTO,7,2),'/',SUBSTRING(E2_VENCTO,5,2),'/',SUBSTRING(E2_VENCTO,1,4)) VENCIMENTO,"		+ STR_PULA
	cQryAux += "E2_VALOR VALOR,"		+ STR_PULA
	cQryAux += "E2_BCOPAG BANCO,"		+ STR_PULA
	cQryAux += "E2_NUMBOR BORDERO"		+ STR_PULA
	cQryAux += "FROM SE2010 "		+ STR_PULA
	cQryAux += "WHERE E2_NUMBCO = ' ' "		+ STR_PULA
	cQryAux += "AND SE2010.D_E_L_E_T_ = ' ' "		+ STR_PULA
	cQryAux += "AND E2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"'AND'"+DtoS(MV_PAR02)+"' "		+ STR_PULA
	
	If MV_PAR03 == 1
		cQryAux += "AND E2_NUMBOR <> ' ' "		+ STR_PULA
	EndIf

	//cQryAux += "AND E2_ORIGEM = 'MATA100' "		+ STR_PULA
	cQryAux += "AND E2_TIPO IN ('BOL','NF') "		+ STR_PULA

	cQryAux += "ORDER BY 9,1,2,3 "		+ STR_PULA

	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da rùgua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
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
