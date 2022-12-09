//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} RELSZ2
Relatório - Relatorio Contatos            
@author zReport
@since 19/05/2021
@version 1.0
	@example
	u_RELSZ2()
	@obs Função gerada pelo zReport()
/*/
	
User Function RELSZ2()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Cria as definições do relatório
	oReport := fReportDef()
	
	//Será enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Senão, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	Local oFunTot1 := Nil
	
	//Criação do componente de impressão
	oReport := TReport():New(	"RELSZ2",;		//Nome do Relatório
								"Contatos do Cliente - "+SA1->A1_COD+"-"+SA1->A1_NOME,;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	oReport:nFontBody := 12
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
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
