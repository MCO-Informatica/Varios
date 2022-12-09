//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#INCLUDE "rptdef.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} RFATR10
Relatório - Relatorio                     
@author rickson.oliveira
@since 02/12/2020
/*/
	
User Function RFATR10()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := Padr( "RFATR07", LEN( SX1->X1_GRUPO ) )

	Pergunte(cPerg,.f. )

   	//Cria as definições do relatório
	oReport := fReportDef(cAlias, cPerg)
	
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
	
	//Criação do componente de impressão
	oReport := TReport():New(	"RFATR10",;		//Nome do Relatório
								"Relatorio",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "C5_EMISSAO", "QRY_AUX", "DT Emissao", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B1_DESC", "QRY_AUX", "Descricao", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_LOCAL", "QRY_AUX", "Armazem", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NNR_DESCRI", "QRY_AUX", "Descricao", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_QTDVEN", "QRY_AUX", "Quantidade", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT SUBSTRING(C5_EMISSAO,1,6) C5_EMISSAO, C6_PRODUTO, B1_DESC,C6_LOCAL, NNR_DESCRI,SUM(C6_QTDVEN) C6_QTDVEN FROM SC6010 SC6"		+ STR_PULA
	cQryAux += "INNER JOIN SC5010 SC5 ON"		+ STR_PULA
	cQryAux += "C5_NUM = C6_NUM"		+ STR_PULA
	cQryAux += "AND SUBSTRING(C5_EMISSAO,1,6) BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR01)+"' "		+ STR_PULA
	cQryAux += "AND SC5.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "INNER JOIN SB1010 SB1 ON "		+ STR_PULA
	cQryAux += "B1_COD = C6_PRODUTO"		+ STR_PULA
	cQryAux += "AND SB1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "INNER JOIN SF4010 SF4 ON"		+ STR_PULA
	cQryAux += "F4_CODIGO = C6_TES"		+ STR_PULA
	cQryAux += "AND F4_DUPLIC = 'S'"		+ STR_PULA
	cQryAux += "AND F4_ESTOQUE = 'S'"		+ STR_PULA
	cQryAux += "AND SF4.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "INNER JOIN NNR010 NNR ON"		+ STR_PULA
	cQryAux += "NNR_CODIGO = C6_LOCAL"		+ STR_PULA
	cQryAux += "AND NNR.D_E_L_E_T_=''"		+ STR_PULA
	cQryAux += "AND C6_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "		+ STR_PULA
	cQryAux += "WHERE SC6.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "GROUP BY C6_PRODUTO, B1_DESC,C6_LOCAL, NNR_DESCRI,SUBSTRING(C5_EMISSAO,1,6)"		+ STR_PULA
	cQryAux += "ORDER BY C6_PRODUTO, B1_DESC,C6_LOCAL, NNR_DESCRI,SUBSTRING(C5_EMISSAO,1,6)"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "C5_EMISSAO", "D")
	
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
