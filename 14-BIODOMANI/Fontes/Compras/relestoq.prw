//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	

/*/{Protheus.doc} relestoq
Relatorio de Estoque
@type function
@version 12.1.33
@author Anderson Martins
@since 9/20/2022
/*/	

User Function relestoq()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definies da pergunta
	cPerg := "RELESTOQ"
	
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
	oReport := TReport():New(	"relestoq",;		//Nome do Relatario
								"Relatorio de Estoque",;		//Titulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser impresso uma pgina com os parmetros, conforme privilgio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de codigo que ser executado na confirmacao da impressao
								)		//Descrio
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	//Criando a seo de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seo pertence
									"Dados",;		//Descricao da seo
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser considerada como principal da seo
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores sero impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatrio
	TRCell():New(oSectDad, "ID_PRODUTO", "QRY_AUX", "Cod", PesqPict('SD1','D1_COD'), 22, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX", "Descricao", PesqPict('SB1','B1_DESC'), 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO", "QRY_AUX", "Tipo", PesqPict('SB1','B1_TIPO'), 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ARMAZEM", "QRY_AUX", "Armaz", PesqPict('SD1','D1_LOCAL'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOTE", "QRY_AUX", "Lote", PesqPict('SD1','D1_LOTECTL'), 11, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALIDADE", "QRY_AUX", "Valid", PesqPict('SD1','D1_DTVALID'), 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTDE", "QRY_AUX", "Qtde", PesqPict('SD1','D1_QUANT'), 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_TOTAL", "QRY_AUX", "Vl_total", PesqPict('SD1','D1_TOTAL'), 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NF", "QRY_AUX", "Nf", PesqPict('SD1','D1_DOC'), 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SERIE_NF", "QRY_AUX", "Serie", PesqPict('SD1','D1_SERIE'), 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD", "QRY_AUX", "Cod_Forn", PesqPict('SA2','A2_COD'), 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FORNECEDOR", "QRY_AUX", "Fornecedor", PesqPict('SA2','A2_NOME'), 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DIGITACAO", "QRY_AUX", "Digitacao", PesqPict('SD1','D1_DTDIGIT'), 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_UNITARIO", "QRY_AUX", "Vl_unitario", PesqPict('SD1','D1_VUNIT'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_FRETE", "QRY_AUX", "Vl_frete", PesqPict('SD1','D1_VALFRE'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_OUTRAS_DESP", "QRY_AUX", "Outras_Desp", PesqPict('SD1','D1_DESPESA'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_ICMS", "QRY_AUX", "Aliq_icms", PesqPict('SD1','D1_PICM'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_ICMS", "QRY_AUX", "ICMS", PesqPict('SD1','D1_VALICM'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_ICMS_ST", "QRY_AUX", "ICMS_ST", PesqPict('SD1','D1_ICMSRET'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_IPI", "QRY_AUX", "Aliq_ipi", PesqPict('SD1','D1_IPI'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_IPI", "QRY_AUX", "IPI", PesqPict('SD1','D1_VALIPI'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_PIS", "QRY_AUX", "Aliq_pis", PesqPict('SFT','FT_ALIQPIS'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_PIS", "QRY_AUX", "PIS", PesqPict('SFT','FT_VALPIS'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B8_EMPENHO", "QRY_AUX", "Emp. do Lote", PesqPict('SB8','B8_EMPENHO'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B8_SALDO", "QRY_AUX", "Saldo Lote", PesqPict('SB8','B8_SALDO'), 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DIAS_ESTOQUE", "QRY_AUX", "D_Estoq", PesqPict('SD1','D1_DTDIGIT'), 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

   // TRCell():New(oSection1,"D3_NUMSA", "TMPSD3", "Num S.A."	,PesqPict('SD3','D3_QUANT')	,10 ) //SUBISTITUIR
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
	cQryAux += "SELECT DISTINCT"		+ STR_PULA
	cQryAux += "D1_COD 'ID_PRODUTO',"		+ STR_PULA
	cQryAux += "B1_DESC 'DESCRICAO',"		+ STR_PULA
	cQryAux += "B1_TIPO 'TIPO',"		+ STR_PULA
	cQryAux += "D1_LOCAL 'ARMAZEM',"		+ STR_PULA
	cQryAux += "D1_LOTECTL 'LOTE',"		+ STR_PULA
	cQryAux += "SUBSTRING(D1_DTVALID,7,2)+'/'+SUBSTRING(D1_DTVALID,5,2)+'/'+SUBSTRING(D1_DTVALID,1,4) VALIDADE,"		+ STR_PULA
	cQryAux += "D1_QUANT 'QTDE',"		+ STR_PULA
	cQryAux += "D1_TOTAL 'VL_TOTAL',"		+ STR_PULA
	cQryAux += "D1_DOC 'NF',"		+ STR_PULA
	cQryAux += "D1_SERIE 'SERIE_NF',"		+ STR_PULA
	cQryAux += "A2_COD  'COD',"		+ STR_PULA
	cQryAux += "A2_NOME 'FORNECEDOR',"		+ STR_PULA
	cQryAux += "SUBSTRING(D1_DTDIGIT,7,2)+'/'+SUBSTRING(D1_DTDIGIT,5,2)+'/'+SUBSTRING(D1_DTDIGIT,1,4) DIGITACAO,"		+ STR_PULA
	cQryAux += "D1_VUNIT 'VL_UNITARIO',"		+ STR_PULA
	cQryAux += "D1_VALFRE 'VL_FRETE',"		+ STR_PULA
	cQryAux += "D1_DESPESA 'VL_OUTRAS_DESP',"		+ STR_PULA
	cQryAux += "D1_PICM 'ALIQ_ICMS',"		+ STR_PULA
	cQryAux += "D1_VALICM 'VL_ICMS',"		+ STR_PULA
	cQryAux += "D1_ICMSRET 'VL_ICMS_ST',"		+ STR_PULA
	cQryAux += "D1_IPI 'ALIQ_IPI',"		+ STR_PULA
	cQryAux += "D1_VALIPI 'VL_IPI',"		+ STR_PULA
	cQryAux += "FT_ALIQPIS 'ALIQ_PIS',"		+ STR_PULA
	cQryAux += "FT_VALPIS 'VL_PIS',"		+ STR_PULA
	cQryAux += "B8_EMPENHO,"		+ STR_PULA
	cQryAux += "B8_SALDO,"		+ STR_PULA
	cQryAux += "DATEDIFF(DAY,CAST(D1_DTDIGIT AS DATE),GETDATE()) 'DIAS_ESTOQUE'"		+ STR_PULA
	cQryAux += "FROM SD1010"		+ STR_PULA
	cQryAux += "INNER JOIN SA2010 ON"		+ STR_PULA
	cQryAux += "SA2010.D_E_L_E_T_ =''"		+ STR_PULA
	cQryAux += "AND A2_COD = D1_FORNECE "		+ STR_PULA
	cQryAux += "AND A2_LOJA = D1_LOJA "		+ STR_PULA
	cQryAux += "INNER JOIN SFT010 ON "		+ STR_PULA
	cQryAux += "SFT010.D_E_L_E_T_ =''"		+ STR_PULA
	cQryAux += "AND FT_FILIAL = D1_FILIAL "		+ STR_PULA
	cQryAux += "AND FT_NFISCAL = D1_DOC "		+ STR_PULA
	cQryAux += "AND FT_SERIE = D1_SERIE "		+ STR_PULA
	cQryAux += "AND FT_CLIEFOR = D1_FORNECE "		+ STR_PULA
	cQryAux += "AND FT_LOJA = D1_LOJA "		+ STR_PULA
	cQryAux += "AND FT_PRODUTO = D1_COD"		+ STR_PULA
	cQryAux += "INNER JOIN SB1010 ON "		+ STR_PULA
	cQryAux += "SB1010.D_E_L_E_T_ = ' '"		+ STR_PULA
	cQryAux += "AND B1_COD = D1_COD "		+ STR_PULA
	cQryAux += "INNER JOIN SB8010 ON "		+ STR_PULA
	cQryAux += "B8_PRODUTO = B1_COD"		+ STR_PULA
	cQryAux += "AND SB8010.D_E_L_E_T_ =' '"		+ STR_PULA
	cQryAux += "AND B8_DTVALID >= '20220101'"		+ STR_PULA
	cQryAux += "WHERE SD1010.D_E_L_E_T_ =' ' AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "	+ STR_PULA
    cQryAux += "AND D1_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + STR_PULA
	cQryAux += "ORDER BY D1_DOC, D1_SERIE"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da regua
	TCQuery cQryAux New Alias "QRY_AUX"
    /*TcSetField("QRY_AUX","D1_COD","N",15,0) // NUMERO
    TcSetField("QRY_AUX","B1_DESC","C",30,0) // CARACTERE
    TcSetField("QRY_AUX","B1_TIPO","C",02,0) // CARACTERE
    TcSetField("QRY_AUX","D1_LOCAL","C",04,0) // CARACTERE
    TcSetField("QRY_AUX","D1_LOTECTL","C",11,0) // CARACTERE
    TcSetField("QRY_AUX","D1_DTVALID","D") // DATA
    TcSetField("QRY_AUX","D1_QUANT","D") // DATA
    TcSetField("QRY_AUX","D1_QUANT","N",08,0) // NUMERO
	*/
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
