//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} rpms008
#6587
Relatorio que tem como finalidade efetuar a compação da versão 1 com a última
versão dos projetos filtrados de acordo com os parametros.
@type function
@version  
@author rico3
@since 19/10/2022
@return variant, return_description
/*/	

User Function rpms008()

	Local aArea   := GetArea()
	Local oReport
	Local aPergs   := {}
	Local xPar0 := Space(10)
	Local xPar1 := Space(10)
	Local xPar2 := Space(10)
	Local xPar3 := Space(10)
	
	//Cria as definições do relatório   
	oReport := fReportDef()
	
	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Projeto De: "			, xPar0,  "", ".T.", "AF8", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Projeto Ate: "		, xPar1,  "", ".T.", "AF8", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Obra De: "			, xPar2,  "", ".T.", "CTT", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Obra Ate: "			, xPar3,  "", ".T.", "CTT", ".T.", 80,  .F.})
	
	//Se a pergunta for confirma, cria as definicoes do relatorio
	If ParamBox(aPergs, "Informe os parametros")
		oReport := fReportDef()
		oReport:PrintDialog()
	EndIf
	
	FWRestArea(aArea)

Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	                                                //Criação do componente de impressão
	oReport := TReport():New(	"Comparativo de Versões",;		    //Nome do Relatório
								"Comparativo de Versões",;		//Título
								,;		            //Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		            //Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									" ",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "AFA_PROJET"     , "QRY_AUX", "Projeto"          , /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_OBRA"       , "QRY_AUX", "Cod. Obra"        , /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AFA_REVISA"     , "QRY_AUX", "Versao"           , /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AF9_EDTPAI"     , "QRY_AUX", "EDT Pai"          , /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO_EDT"  , "QRY_AUX", "Descricao EDT"    , /*Picture*/, 90, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AFA_TAREFA"     , "QRY_AUX", "Tarefa"           , /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AF9_DESCRI"     , "QRY_AUX", "Descricao"        , /*Picture*/, 90, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AFA_ITEM"       , "QRY_AUX", "Item"             , /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_PROD"       , "QRY_AUX", "Cod.Prod"         , /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO"        , "QRY_AUX", "Produto"          , /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UNIDADE"        , "QRY_AUX", "Unidade"          , /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANT_A"        , "QRY_AUX", "Quant A"          , /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANT_B"        , "QRY_AUX", "Quant B"          , /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CUSTO_A"        , "QRY_AUX", "Custo A"          , /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CUSTO_B"        , "QRY_AUX", "Custo B"          , /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B1_CUSTD"       , "QRY_AUX", "Custo Stand."     , /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CUSTO_INICIAL"  , "QRY_AUX", "Custo Inicial"    , /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CUSTO_FINAL"    , "QRY_AUX", "Custo Final"      , /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AFA_COMPOS"     , "QRY_AUX", "Sub-Compos."      , /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""                                                                                 
cQryAux += " SELECT DISTINCT A.AFA_PROJET                                                        " + STR_PULA
cQryAux += " 	,AF8.AF8_CODOBR COD_OBRA                                                         " + STR_PULA
cQryAux += " 	,A.AFA_REVISA                                                                    " + STR_PULA
cQryAux += " 	,AF9_EDTPAI                                                                      " + STR_PULA
cQryAux += " 	,(                                                                               " + STR_PULA
cQryAux += " 		SELECT X.AFC_DESCRI                                                          " + STR_PULA
cQryAux += " 		FROM AFC010 X                                                                " + STR_PULA
cQryAux += " 		WHERE X.AFC_PROJET = COALESCE(B.AFA_PROJET, A.AFA_PROJET)                    " + STR_PULA
cQryAux += " 			AND X.AFC_REVISA = COALESCE(B.AFA_REVISA, A.AFA_REVISA)                  " + STR_PULA
cQryAux += " 			AND X.AFC_EDT = AF9.AF9_EDTPAI                                           " + STR_PULA
cQryAux += " 			AND X.D_E_L_E_T_ = ' '                                                   " + STR_PULA
cQryAux += " 		) DESCRICAO_EDT                                                              " + STR_PULA
cQryAux += " 	,A.AFA_TAREFA                                                                    " + STR_PULA
cQryAux += " 	,AF9_DESCRI                                                                      " + STR_PULA
cQryAux += " 	,A.AFA_ITEM                                                                      " + STR_PULA
cQryAux += " 	,COALESCE(NULLIF(A.AFA_PRODUT, ' '), A.AFA_RECURS) COD_PROD                      " + STR_PULA
cQryAux += " 	,COALESCE(NULLIF(B1.B1_DESC, ' '), AE8_DESCRI) PRODUTO                           " + STR_PULA
cQryAux += " 	,B1_UM UNIDADE                                                                   " + STR_PULA
cQryAux += " 	,A.AFA_QUANT QUANT_A                                                             " + STR_PULA
cQryAux += " 	,B.AFA_QUANT QUANT_B                                                             " + STR_PULA
cQryAux += " 	,A.AFA_CUSTD CUSTO_A                                                             " + STR_PULA
cQryAux += " 	,B.AFA_CUSTD CUSTO_B                                                             " + STR_PULA
cQryAux += " 	,B1_CUSTD                                                                        " + STR_PULA
cQryAux += " 	,ROUND(A.AFA_CUSTD * A.AFA_QUANT, 2) CUSTO_INICIAL                               " + STR_PULA
cQryAux += " 	,ROUND(B.AFA_CUSTD * B.AFA_QUANT, 2) CUSTO_FINAL                                 " + STR_PULA
cQryAux += " 	,A.AFA_COMPOS                                                                    " + STR_PULA
cQryAux += " FROM AFA010 A                                                                       " + STR_PULA
cQryAux += " FULL OUTER JOIN AFA010 B ON A.AFA_FILIAL = B.AFA_FILIAL                             " + STR_PULA
cQryAux += " 	AND B.AFA_PROJET = A.AFA_PROJET                                                  " + STR_PULA
cQryAux += " 	AND B.AFA_TAREFA = A.AFA_TAREFA                                                  " + STR_PULA
cQryAux += " 	AND B.AFA_PRODUT = A.AFA_PRODUT                                                  " + STR_PULA
cQryAux += " 	AND B.AFA_ITEM = A.AFA_ITEM                                                      " + STR_PULA
cQryAux += " 	AND B.AFA_REVISA = (                                                             " + STR_PULA
cQryAux += " 		SELECT MAX(AF8_REVISA)                                                       " + STR_PULA
cQryAux += " 		FROM AF8010                                                                  " + STR_PULA
cQryAux += " 		WHERE AF8_PROJET = A.AFA_PROJET                                              " + STR_PULA
cQryAux += " 			AND AF8_FILIAL = A.AFA_FILIAL                                            " + STR_PULA
cQryAux += " 			AND AF8010.D_E_L_E_T_ = ' '                                              " + STR_PULA
cQryAux += " 		)                                                                            " + STR_PULA
cQryAux += " 	AND B.D_E_L_E_T_ = ' '                                                           " + STR_PULA
cQryAux += " FULL OUTER JOIN SB1010 B1 ON B1.B1_COD = COALESCE(B.AFA_PRODUT, A.AFA_PRODUT)       " + STR_PULA
cQryAux += " 	AND B1.D_E_L_E_T_ = ' '                                                          " + STR_PULA
cQryAux += " 	AND B1_FILIAL = COALESCE(B.AFA_FILIAL, A.AFA_FILIAL)                             " + STR_PULA
cQryAux += " FULL OUTER JOIN AF9010 AF9 ON AF9_PROJET = COALESCE(B.AFA_PROJET, A.AFA_PROJET)     " + STR_PULA
cQryAux += " 	AND AF9_REVISA = COALESCE(B.AFA_REVISA, A.AFA_REVISA)                            " + STR_PULA
cQryAux += " 	AND AF9_TAREFA = COALESCE(B.AFA_TAREFA, A.AFA_TAREFA)                            " + STR_PULA
cQryAux += " 	AND AF9.D_E_L_E_T_ = ' '                                                         " + STR_PULA
cQryAux += " FULL OUTER JOIN AE8010 AE8 ON AE8_RECURS = COALESCE(B.AFA_RECURS, A.AFA_RECURS)     " + STR_PULA
cQryAux += " 	AND AE8.D_E_L_E_T_ = ' '                                                         " + STR_PULA
cQryAux += " INNER JOIN AF8010 AF8 ON AF8.AF8_PROJET = COALESCE(B.AFA_PROJET, A.AFA_PROJET)      " + STR_PULA
cQryAux += " 	AND AF8.AF8_REVISA = COALESCE(B.AFA_REVISA, A.AFA_REVISA)                        " + STR_PULA
cQryAux += " 	AND AF8.D_E_L_E_T_ = ' '                                                         " + STR_PULA
cQryAux += " WHERE A.AFA_PROJET >= '" + MV_PAR01 + "' "		+ STR_PULA
cQryAux += " 	AND A.AFA_PROJET <= '" + MV_PAR02 + "' "		+ STR_PULA
cQryAux += " 	AND A.D_E_L_E_T_ = ' '                                                           " + STR_PULA
cQryAux += " 	AND A.AFA_REVISA = '0001'                                                        " + STR_PULA
cQryAux += " 	AND AF8.AF8_CODOBR >= '" + MV_PAR03 + "' "		+ STR_PULA
cQryAux += " 	AND AF8.AF8_CODOBR <= '" + MV_PAR04 + "' "		+ STR_PULA
cQryAux += "                                                                                     " + STR_PULA
cQryAux += " UNION                                                                               " + STR_PULA
cQryAux += "                                                                                     " + STR_PULA
cQryAux += " SELECT DISTINCT A.AFA_PROJET                                                        " + STR_PULA
cQryAux += " 	,AF8.AF8_CODOBR COD_OBRA                                                         " + STR_PULA
cQryAux += " 	,A.AFA_REVISA                                                                    " + STR_PULA
cQryAux += " 	,AF9_EDTPAI                                                                      " + STR_PULA
cQryAux += " 	,(                                                                               " + STR_PULA
cQryAux += " 		SELECT X.AFC_DESCRI                                                          " + STR_PULA
cQryAux += " 		FROM AFC010 X                                                                " + STR_PULA
cQryAux += " 		WHERE X.AFC_PROJET = COALESCE(B.AFA_PROJET, A.AFA_PROJET)                    " + STR_PULA
cQryAux += " 			AND X.AFC_REVISA = COALESCE(B.AFA_REVISA, A.AFA_REVISA)                  " + STR_PULA
cQryAux += " 			AND X.AFC_EDT = AF9.AF9_EDTPAI                                           " + STR_PULA
cQryAux += " 			AND X.D_E_L_E_T_ = ' '                                                   " + STR_PULA
cQryAux += " 		) DESCRICAO_EDT                                                              " + STR_PULA
cQryAux += " 	,A.AFA_TAREFA                                                                    " + STR_PULA
cQryAux += " 	,AF9_DESCRI                                                                      " + STR_PULA
cQryAux += " 	,A.AFA_ITEM                                                                      " + STR_PULA
cQryAux += " 	,COALESCE(NULLIF(A.AFA_PRODUT, ' '), A.AFA_RECURS)                               " + STR_PULA
cQryAux += " 	,COALESCE(NULLIF(B1.B1_DESC, ' '), AE8_DESCRI)                                   " + STR_PULA
cQryAux += " 	,B1_UM UNIDADE                                                                   " + STR_PULA
cQryAux += " 	,B.AFA_QUANT QUANT_A                                                             " + STR_PULA
cQryAux += " 	,A.AFA_QUANT QUANT_B                                                             " + STR_PULA
cQryAux += " 	,B.AFA_CUSTD CUSTO_A                                                             " + STR_PULA
cQryAux += " 	,A.AFA_CUSTD CUSTO_B                                                             " + STR_PULA
cQryAux += " 	,B1_CUSTD                                                                        " + STR_PULA
cQryAux += " 	,ROUND(B.AFA_CUSTD * B.AFA_QUANT, 2) CUSTO_INICIAL                               " + STR_PULA
cQryAux += " 	,ROUND(A.AFA_CUSTD * A.AFA_QUANT, 2) CUSTO_FINAL                                 " + STR_PULA
cQryAux += " 	,A.AFA_COMPOS                                                                    " + STR_PULA
cQryAux += " FROM AFA010 A                                                                       " + STR_PULA
cQryAux += " LEFT JOIN AFA010 B ON A.AFA_FILIAL = B.AFA_FILIAL                                   " + STR_PULA
cQryAux += " 	AND B.AFA_PROJET = A.AFA_PROJET                                                  " + STR_PULA
cQryAux += " 	AND B.AFA_TAREFA = A.AFA_TAREFA                                                  " + STR_PULA
cQryAux += " 	AND B.AFA_PRODUT = A.AFA_PRODUT                                                  " + STR_PULA
cQryAux += " 	AND B.AFA_ITEM = A.AFA_ITEM                                                      " + STR_PULA
cQryAux += " 	AND B.AFA_REVISA = '0001'                                                        " + STR_PULA
cQryAux += " 	AND B.D_E_L_E_T_ = ' '                                                           " + STR_PULA
cQryAux += " LEFT JOIN SB1010 B1 ON B1.B1_COD = COALESCE(B.AFA_PRODUT, A.AFA_PRODUT)             " + STR_PULA
cQryAux += " 	AND B1.D_E_L_E_T_ = ' '                                                          " + STR_PULA
cQryAux += " 	AND B1_FILIAL = COALESCE(B.AFA_FILIAL, A.AFA_FILIAL)                             " + STR_PULA
cQryAux += " LEFT JOIN AF9010 AF9 ON AF9_PROJET = COALESCE(B.AFA_PROJET, A.AFA_PROJET)           " + STR_PULA
cQryAux += " 	AND AF9_REVISA = COALESCE(B.AFA_REVISA, A.AFA_REVISA)                            " + STR_PULA
cQryAux += " 	AND AF9_TAREFA = COALESCE(B.AFA_TAREFA, A.AFA_TAREFA)                            " + STR_PULA
cQryAux += " 	AND AF9.D_E_L_E_T_ = ' '                                                         " + STR_PULA
cQryAux += " LEFT JOIN AE8010 AE8 ON AE8_RECURS = COALESCE(B.AFA_RECURS, A.AFA_RECURS)           " + STR_PULA
cQryAux += " 	AND AE8.D_E_L_E_T_ = ' '                                                         " + STR_PULA
cQryAux += " INNER JOIN AF8010 AF8 ON AF8.AF8_PROJET = COALESCE(B.AFA_PROJET, A.AFA_PROJET)      " + STR_PULA
cQryAux += " 	AND AF8.AF8_REVISA = COALESCE(B.AFA_REVISA, A.AFA_REVISA)                        " + STR_PULA
cQryAux += " 	AND AF8.D_E_L_E_T_ = ' '                                                         " + STR_PULA
cQryAux += " WHERE A.AFA_PROJET >= '" + MV_PAR01 + "' "		+ STR_PULA
cQryAux += " 	AND A.AFA_PROJET <= '" + MV_PAR02 + "' "		+ STR_PULA
cQryAux += " 	AND A.D_E_L_E_T_ = ' '                                                           " + STR_PULA
cQryAux += " 	AND A.AFA_REVISA = (                                                             " + STR_PULA
cQryAux += " 		SELECT MAX(AF8_REVISA)                                                       " + STR_PULA
cQryAux += " 		FROM AF8010                                                                  " + STR_PULA
cQryAux += " 		WHERE AF8_PROJET = A.AFA_PROJET                                              " + STR_PULA
cQryAux += " 			AND AF8_FILIAL = A.AFA_FILIAL                                            " + STR_PULA
cQryAux += " 			AND AF8010.D_E_L_E_T_ = ' '                                              " + STR_PULA
cQryAux += " 		)                                                                            " + STR_PULA
cQryAux += " 	AND B.AFA_PRODUT IS NULL                                                         " + STR_PULA
cQryAux += " 	AND AF8.AF8_CODOBR >= '" + MV_PAR03 + "' "		+ STR_PULA
cQryAux += " 	AND AF8.AF8_CODOBR <= '" + MV_PAR04 + "' "		+ STR_PULA
cQryAux += " ORDER BY AF9_EDTPAI                                                                 " + STR_PULA
cQryAux += " 	,A.AFA_TAREFA                                                                    " + STR_PULA
cQryAux += " 	,A.AFA_REVISA                                                                    " + STR_PULA
cQryAux += " 	,COALESCE(NULLIF(A.AFA_PRODUT, ' '), A.AFA_RECURS);                              " + STR_PULA

	cQryAux := ChangeQuery(cQryAux)

	MemoWrite("rpms008.SQL", cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a régua
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
