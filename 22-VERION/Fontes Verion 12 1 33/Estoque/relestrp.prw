//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} RELESTRP
Relat�rio - Relatorio de Estrutura        
@author zReport
@since 28/03/2022
@version 1.0
	@example
	u_RELESTRP()
	@obs Fun��o gerada pelo zReport()
/*/
	
User Function RELESTRP()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""

	//Defini��es da pergunta
	cPerg := "RELESTRP  "

	Pergunte(cPerg , .T.)
	
	//Cria as defini��es do relat�rio
	oReport := fReportDef()
	
	//Ser� enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Sen�o, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Fun��o que monta a defini��o do relat�rio                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	//Cria��o do componente de impress�o
	oReport := TReport():New(	"RELESTRP",;		//Nome do Relat�rio
								"Relatorio de Estrutura",;		//T�tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
								)		//Descri��o
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	//Criando a se��o de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Dados",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	//TRCell():New(oSectDad, "PRODUTO_PRINCIPAL", "QRY_AUX", "Principal", /*Picture*/, 22, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_KIT"		  , "QRY_AUX", "SubKit", /*Picture*/, 22, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COMPONENTE"		  , "QRY_AUX", "Componente", /*Picture*/, 22, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO_ITEM"	  , "QRY_AUX", "Produto", /*Picture*/, 80, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE"		  , "QRY_AUX", "Quantidade", "@E 999,999.9999" /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CUSTO"			  , "QRY_AUX", "Custo", "@E 9,999,999.9999" /*Picture*/, 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	oBreak := TRBreak():New(oSectDad,{|| QRY_AUX->(PRODUTO_PRINCIPAL) },{|| "Total: "  })
	oSectDad:SetHeaderBreak(.T.)
	
Return oReport 
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Fun��o que imprime o relat�rio                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as se��es do relat�rio
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT DISTINCT A.G1_COD PRODUTO_PRINCIPAL, "		+ STR_PULA
	cQryAux += "A.G1_COD COD_KIT, "		+ STR_PULA
	cQryAux += "A.G1_COMP COMPONENTE, "		+ STR_PULA
	cQryAux += "B1_DESC DESCRICAO_ITEM, "		+ STR_PULA
	cQryAux += "A.G1_QUANT QUANTIDADE, "		+ STR_PULA
	cQryAux += "ROUND((CASE WHEN COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) NOT IN ('R',' ') OR B1_COD = 'VBMONT2' THEN B1_VERCOM ELSE COALESCE(NULLIF(B1_UPRC,0),NULLIF(B1_CUSTD,0),0) / 5.45 END * A.G1_QUANT),2) CUSTO, "		+ STR_PULA
	cQryAux += "'A' TABELA, "		+ STR_PULA
	cQryAux += "B1_UPRC ULTIMO_PRECO,  "		+ STR_PULA
	cQryAux += "B1_CUSTD CUSTO_STAND, "		+ STR_PULA
	cQryAux += "B1_VERCOM VALOR_COMPRA, "		+ STR_PULA
	cQryAux += "COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) MOEDA "		+ STR_PULA
	cQryAux += "FROM SG1010 A  "		+ STR_PULA
	cQryAux += "JOIN SB1010 ON B1_COD = A.G1_COMP AND SB1010.D_E_L_E_T_=' ' "		+ STR_PULA
	cQryAux += "JOIN SBM010 ON BM_GRUPO = B1_GRUPO AND SBM010.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "WHERE A.G1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND A.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "AND B1_ESTRUT = '3' "		+ STR_PULA
	cQryAux += "AND B1_MSBLQL = '2' "		+ STR_PULA
	cQryAux += "UNION  "		+ STR_PULA
	cQryAux += "SELECT DISTINCT B.G1_COD PRODUTO_PRINCIPAL, "		+ STR_PULA
	cQryAux += "B.G1_COD COD_KIT, "		+ STR_PULA
	cQryAux += "B.G1_COMP COMPONENTE, "		+ STR_PULA
	cQryAux += "B1_DESC DESCRICAO_ITEM, "		+ STR_PULA
	cQryAux += "B.G1_QUANT QUANTIDADE, "		+ STR_PULA
	cQryAux += "ROUND((CASE WHEN COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) NOT IN ('R',' ') OR B1_COD = 'VBMONT2' THEN B1_VERCOM ELSE COALESCE(NULLIF(B1_UPRC,0),NULLIF(B1_CUSTD,0),0) / 5.45 END * B.G1_QUANT),2) CUSTO, "		+ STR_PULA
	cQryAux += "'B' TABELA, "		+ STR_PULA
	cQryAux += "B1_UPRC ULTIMO_PRECO,  "		+ STR_PULA
	cQryAux += "B1_CUSTD CUSTO_STAND, "		+ STR_PULA
	cQryAux += "B1_VERCOM VALOR_COMPRA, "		+ STR_PULA
	cQryAux += "COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) MOEDA  "		+ STR_PULA
	cQryAux += "FROM SG1010 B  "		+ STR_PULA
	cQryAux += "JOIN SB1010 ON B1_COD = B.G1_COMP AND SB1010.D_E_L_E_T_=' ' "		+ STR_PULA
	cQryAux += "JOIN SBM010 ON BM_GRUPO = B1_GRUPO AND SBM010.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 A ON A.G1_COMP = B.G1_COD AND B.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "WHERE A.G1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND B.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "AND B1_ESTRUT = '3' "		+ STR_PULA
	cQryAux += "AND B1_MSBLQL = '2' "		+ STR_PULA
	cQryAux += "UNION  "		+ STR_PULA
	cQryAux += "SELECT DISTINCT C.G1_COD PRODUTO_PRINCIPAL, "		+ STR_PULA
	cQryAux += "C.G1_COD COD_KIT, "		+ STR_PULA
	cQryAux += "C.G1_COMP COMPONENTE, "		+ STR_PULA
	cQryAux += "B1_DESC DESCRICAO_ITEM, "		+ STR_PULA
	cQryAux += "C.G1_QUANT QUANTIDADE, "		+ STR_PULA
	cQryAux += "ROUND((CASE WHEN COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) NOT IN ('R',' ') OR B1_COD = 'VBMONT2' THEN B1_VERCOM ELSE COALESCE(NULLIF(B1_UPRC,0),NULLIF(B1_CUSTD,0),0) / 5.45 END * C.G1_QUANT),2) CUSTO, "		+ STR_PULA
	cQryAux += "'C' TABELA, "		+ STR_PULA
	cQryAux += "B1_UPRC ULTIMO_PRECO,  "		+ STR_PULA
	cQryAux += "B1_CUSTD CUSTO_STAND, "		+ STR_PULA
	cQryAux += "B1_VERCOM VALOR_COMPRA, "		+ STR_PULA
	cQryAux += "COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) MOEDA  "		+ STR_PULA
	cQryAux += "FROM SG1010 C  "		+ STR_PULA
	cQryAux += "JOIN SB1010 ON B1_COD = C.G1_COMP AND SB1010.D_E_L_E_T_=' ' "		+ STR_PULA
	cQryAux += "JOIN SBM010 ON BM_GRUPO = B1_GRUPO AND SBM010.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 B ON B.G1_COMP = C.G1_COD AND B.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 A ON A.G1_COMP = B.G1_COD AND A.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "WHERE A.G1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND C.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "AND B1_ESTRUT = '3' "		+ STR_PULA
	cQryAux += "AND B1_MSBLQL = '2' "		+ STR_PULA
	cQryAux += "UNION  "		+ STR_PULA
	cQryAux += "SELECT DISTINCT D.G1_COD PRODUTO_PRINCIPAL, "		+ STR_PULA
	cQryAux += "D.G1_COD COD_KIT, "		+ STR_PULA
	cQryAux += "D.G1_COMP COMPONENTE, "		+ STR_PULA
	cQryAux += "B1_DESC DESCRICAO_ITEM, "		+ STR_PULA
	cQryAux += "D.G1_QUANT QUANTIDADE, "		+ STR_PULA
	cQryAux += "ROUND((CASE WHEN COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) NOT IN ('R',' ') OR B1_COD = 'VBMONT2' THEN B1_VERCOM ELSE COALESCE(NULLIF(B1_UPRC,0),NULLIF(B1_CUSTD,0),0) / 5.45 END * D.G1_QUANT),2) CUSTO, "		+ STR_PULA
	cQryAux += "'D' TABELA, "		+ STR_PULA
	cQryAux += "B1_UPRC ULTIMO_PRECO,  "		+ STR_PULA
	cQryAux += "B1_CUSTD CUSTO_STAND, "		+ STR_PULA
	cQryAux += "B1_VERCOM VALOR_COMPRA, "		+ STR_PULA
	cQryAux += "COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) MOEDA  "		+ STR_PULA
	cQryAux += "FROM SG1010 D  "		+ STR_PULA
	cQryAux += "JOIN SB1010 ON B1_COD = D.G1_COMP AND SB1010.D_E_L_E_T_=' ' "		+ STR_PULA
	cQryAux += "JOIN SBM010 ON BM_GRUPO = B1_GRUPO AND SBM010.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 C ON C.G1_COMP = D.G1_COD AND C.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 B ON B.G1_COMP = C.G1_COD AND B.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 A ON A.G1_COMP = B.G1_COD AND A.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "WHERE A.G1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND D.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "AND B1_ESTRUT = '3' "		+ STR_PULA
	cQryAux += "AND B1_MSBLQL = '2' "		+ STR_PULA
	cQryAux += "UNION  "		+ STR_PULA
	cQryAux += "SELECT DISTINCT E.G1_COD PRODUTO_PRINCIPAL, "		+ STR_PULA
	cQryAux += "E.G1_COD COD_KIT, "		+ STR_PULA
	cQryAux += "E.G1_COMP COMPONENTE, "		+ STR_PULA
	cQryAux += "B1_DESC DESCRICAO_ITEM, "		+ STR_PULA
	cQryAux += "E.G1_QUANT QUANTIDADE, "		+ STR_PULA
	cQryAux += "ROUND((CASE WHEN COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) NOT IN ('R',' ') OR B1_COD = 'VBMONT2' THEN B1_VERCOM ELSE COALESCE(NULLIF(B1_UPRC,0),NULLIF(B1_CUSTD,0),0) / 5.45 END * E.G1_QUANT),2) CUSTO, "		+ STR_PULA
	cQryAux += "'E' TABELA, "		+ STR_PULA
	cQryAux += "B1_UPRC ULTIMO_PRECO,  "		+ STR_PULA
	cQryAux += "B1_CUSTD CUSTO_STAND, "		+ STR_PULA
	cQryAux += "B1_VERCOM VALOR_COMPRA, "		+ STR_PULA
	cQryAux += "COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) MOEDA  "		+ STR_PULA
	cQryAux += "FROM SG1010 E  "		+ STR_PULA
	cQryAux += "JOIN SB1010 ON B1_COD = E.G1_COMP AND SB1010.D_E_L_E_T_=' ' "		+ STR_PULA
	cQryAux += "JOIN SBM010 ON BM_GRUPO = B1_GRUPO AND SBM010.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 D ON D.G1_COMP = E.G1_COD AND D.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 C ON C.G1_COMP = D.G1_COD AND C.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 B ON B.G1_COMP = C.G1_COD AND B.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 A ON A.G1_COMP = B.G1_COD AND A.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "WHERE A.G1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND E.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "AND B1_ESTRUT = '3' "		+ STR_PULA
	cQryAux += "AND B1_MSBLQL = '2' "		+ STR_PULA
	cQryAux += "UNION  "		+ STR_PULA
	cQryAux += "SELECT DISTINCT F.G1_COD PRODUTO_PRINCIPAL, "		+ STR_PULA
	cQryAux += "F.G1_COD COD_KIT, "		+ STR_PULA
	cQryAux += "F.G1_COMP COMPONENTE, "		+ STR_PULA
	cQryAux += "B1_DESC DESCRICAO_ITEM, "		+ STR_PULA
	cQryAux += "F.G1_QUANT QUANTIDADE, "		+ STR_PULA
	cQryAux += "ROUND((CASE WHEN COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) NOT IN ('R',' ') OR B1_COD = 'VBMONT2' THEN B1_VERCOM ELSE COALESCE(NULLIF(B1_UPRC,0),NULLIF(B1_CUSTD,0),0) / 5.45 END * F.G1_QUANT),2) CUSTO, "		+ STR_PULA
	cQryAux += "'F' TABELA, "		+ STR_PULA
	cQryAux += "B1_UPRC ULTIMO_PRECO,  "		+ STR_PULA
	cQryAux += "B1_CUSTD CUSTO_STAND, "		+ STR_PULA
	cQryAux += "B1_VERCOM VALOR_COMPRA, "		+ STR_PULA
	cQryAux += "COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) MOEDA  "		+ STR_PULA
	cQryAux += "FROM SG1010 F  "		+ STR_PULA
	cQryAux += "JOIN SB1010 ON B1_COD = F.G1_COMP AND SB1010.D_E_L_E_T_=' ' "		+ STR_PULA
	cQryAux += "JOIN SBM010 ON BM_GRUPO = B1_GRUPO AND SBM010.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 E ON E.G1_COMP = F.G1_COD AND E.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 D ON D.G1_COMP = E.G1_COD AND D.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 C ON C.G1_COMP = D.G1_COD AND C.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 B ON B.G1_COMP = C.G1_COD AND B.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 A ON A.G1_COMP = B.G1_COD AND A.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "WHERE A.G1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND F.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "AND B1_ESTRUT = '3' "		+ STR_PULA
	cQryAux += "AND B1_MSBLQL = '2' "		+ STR_PULA
	cQryAux += "UNION  "		+ STR_PULA
	cQryAux += "SELECT DISTINCT G.G1_COD PRODUTO_PRINCIPAL, "		+ STR_PULA
	cQryAux += "G.G1_COD COD_KIT, "		+ STR_PULA
	cQryAux += "G.G1_COMP COMPONENTE, "		+ STR_PULA
	cQryAux += "B1_DESC DESCRICAO_ITEM, "		+ STR_PULA
	cQryAux += "G.G1_QUANT QUANTIDADE, "		+ STR_PULA
	cQryAux += "ROUND((CASE WHEN COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) NOT IN ('R',' ') OR B1_COD = 'VBMONT2' THEN B1_VERCOM ELSE COALESCE(NULLIF(B1_UPRC,0),NULLIF(B1_CUSTD,0),0) / 5.45 END * G.G1_QUANT),2) CUSTO, "		+ STR_PULA
	cQryAux += "'G' TABELA, "		+ STR_PULA
	cQryAux += "B1_UPRC ULTIMO_PRECO,  "		+ STR_PULA
	cQryAux += "B1_CUSTD CUSTO_STAND, "		+ STR_PULA
	cQryAux += "B1_VERCOM VALOR_COMPRA, "		+ STR_PULA
	cQryAux += "COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) MOEDA "		+ STR_PULA
	cQryAux += "FROM SG1010 G "		+ STR_PULA
	cQryAux += "JOIN SB1010 ON B1_COD = G.G1_COMP AND SB1010.D_E_L_E_T_=' ' "		+ STR_PULA
	cQryAux += "JOIN SBM010 ON BM_GRUPO = B1_GRUPO AND SBM010.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 F ON F.G1_COMP = G.G1_COD AND F.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 E ON E.G1_COMP = F.G1_COD AND E.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 D ON D.G1_COMP = E.G1_COD AND D.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 C ON C.G1_COMP = D.G1_COD AND C.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 B ON B.G1_COMP = C.G1_COD AND B.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 A ON A.G1_COMP = B.G1_COD AND A.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "WHERE A.G1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND G.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "AND B1_ESTRUT = '3' "		+ STR_PULA
	cQryAux += "AND B1_MSBLQL = '2' "		+ STR_PULA
	cQryAux += "UNION  "		+ STR_PULA
	cQryAux += "SELECT DISTINCT H.G1_COD PRODUTO_PRINCIPAL, "		+ STR_PULA
	cQryAux += "H.G1_COD COD_KIT, "		+ STR_PULA
	cQryAux += "H.G1_COMP COMPONENTE, "		+ STR_PULA
	cQryAux += "B1_DESC DESCRICAO_ITEM, "		+ STR_PULA
	cQryAux += "H.G1_QUANT QUANTIDADE, "		+ STR_PULA
	cQryAux += "ROUND((CASE WHEN COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) NOT IN ('R',' ') OR B1_COD = 'VBMONT2' THEN B1_VERCOM ELSE COALESCE(NULLIF(B1_UPRC,0),NULLIF(B1_CUSTD,0),0) / 5.45 END * H.G1_QUANT),2) CUSTO, "		+ STR_PULA
	cQryAux += "'H' TABELA, "		+ STR_PULA
	cQryAux += "B1_UPRC ULTIMO_PRECO,  "		+ STR_PULA
	cQryAux += "B1_CUSTD CUSTO_STAND, "		+ STR_PULA
	cQryAux += "B1_VERCOM VALOR_COMPRA, "		+ STR_PULA
	cQryAux += "COALESCE(NULLIF(B1_TPMOEDA,' '),BM_MOEDA) MOEDA "		+ STR_PULA
	cQryAux += "FROM SG1010 H "		+ STR_PULA
	cQryAux += "JOIN SB1010 ON B1_COD = H.G1_COMP AND SB1010.D_E_L_E_T_=' ' "		+ STR_PULA
	cQryAux += "JOIN SBM010 ON BM_GRUPO = B1_GRUPO AND SBM010.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 G ON G.G1_COMP = H.G1_COD AND G.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 F ON F.G1_COMP = G.G1_COD AND F.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 E ON E.G1_COMP = F.G1_COD AND E.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 D ON D.G1_COMP = E.G1_COD AND D.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 C ON C.G1_COMP = D.G1_COD AND C.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 B ON B.G1_COMP = C.G1_COD AND B.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "LEFT JOIN SG1010 A ON A.G1_COMP = B.G1_COD AND A.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "WHERE A.G1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND H.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux += "AND B1_ESTRUT = '3' "		+ STR_PULA
	cQryAux += "AND B1_MSBLQL = '2' "		+ STR_PULA
	cQryAux += "ORDER BY 7,1,2"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	//TCSetField("QRY_AUX", "B1_UCALSTD", "D")
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a r�gua
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
