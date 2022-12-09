//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} RELSZ2
Relat�rio - Relatorio Contatos            
@author zReport
@since 19/05/2021
@version 1.0
	@example
	u_RELSZ2()
	@obs Fun��o gerada pelo zReport()
/*/
	
User Function RELSZ2()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
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
	Local oFunTot1 := Nil
	
	//Cria��o do componente de impress�o
	oReport := TReport():New(	"RELSZ2",;		//Nome do Relat�rio
								"Contatos do Cliente - "+SA1->A1_COD+"-"+SA1->A1_NOME,;		//T�tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
								)		//Descri��o
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	oReport:nFontBody := 12
	
	//Criando a se��o de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Dados",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	TRCell():New(oSectDad, "Z2_COD"		, "QRY_AUX", "Codigo"	, /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "Z2_NOME"	, "QRY_AUX", "Nome"		, /*Picture*/, 35, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "Z2_DDD"		, "QRY_AUX", "DDD"		, /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "Z2_TELEFON"	, "QRY_AUX", "Telefone"	, /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "Z2_DDDC"	, "QRY_AUX", "DDD Cel"	, /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "Z2_CELULAR"	, "QRY_AUX", "Celular"	, /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "Z2_EMAIL"	, "QRY_AUX", "E-mail"	, /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "Z2_DEPTO"	, "QRY_AUX", "Depto"	, /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "Z2_FUNCAO"	, "QRY_AUX", "Funcao"	, /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
	//Totalizadores
	//oFunTot1 := TRFunction():New(oSectDad:Cell("Z2_COD"),,"COUNT",,,/*cPicture*/)
	//oFunTot1:SetEndReport(.F.)
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
	cQryAux += " SELECT  "		+ STR_PULA
	cQryAux += " Z2_CLIENTE,Z2_COD,Z2_NOME,Z2_DDD,Z2_TELEFON,Z2_DDDC,Z2_CELULAR,Z2_EMAIL,"		+ STR_PULA
	
	cQryAux += " CASE WHEN Z2_DEPTO = 1 THEN 'DIRETORIA' "		+ STR_PULA
	cQryAux += " 	  WHEN Z2_DEPTO = 2 THEN 'GERENCIA' "		+ STR_PULA
	cQryAux += " 	  WHEN Z2_DEPTO = 3 THEN 'COMPRAS' "		+ STR_PULA
	cQryAux += " 	  WHEN Z2_DEPTO = 4 THEN 'VENDAS' "		+ STR_PULA
	cQryAux += " 	  WHEN Z2_DEPTO = 5 THEN 'MONTAGEM' "		+ STR_PULA
	cQryAux += " 	  WHEN Z2_DEPTO = 6 THEN 'FINANCEIRO' "		+ STR_PULA
	cQryAux += " 	  ELSE ' ' END AS Z2_DEPTO, "		+ STR_PULA

	cQryAux += " CASE WHEN Z2_FUNCAO = 1 THEN 'PROPRIETARIO' "		+ STR_PULA
	cQryAux += " 	  WHEN Z2_FUNCAO = 2 THEN 'GERENTE' "		+ STR_PULA
	cQryAux += " 	  WHEN Z2_FUNCAO = 3 THEN 'COMPRADOR' "		+ STR_PULA
	cQryAux += " 	  WHEN Z2_FUNCAO = 4 THEN 'BALCONISTA' "		+ STR_PULA
	cQryAux += " 	  WHEN Z2_FUNCAO = 5 THEN 'VENDEDOR' "		+ STR_PULA
	cQryAux += " 	  WHEN Z2_FUNCAO = 6 THEN 'MONTADOR' "		+ STR_PULA
	cQryAux += " 	  WHEN Z2_FUNCAO = 7 THEN 'CONTAS A PAGAR' "		+ STR_PULA
	cQryAux += " 	  ELSE ' ' END AS Z2_FUNCAO "		+ STR_PULA

	cQryAux += " FROM "+RetSqlName("SZ2")+" SZ2 "		+ STR_PULA
	cQryAux += " WHERE SZ2.D_E_L_E_T_<>'*' AND Z2_CLIENTE = '"+SA1->(A1_COD+A1_LOJA)+"' AND Z2_FILIAL = '"+xFilial('SZ2')+"' "		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
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
