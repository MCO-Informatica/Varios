//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} xfinr130
Relat?rio - Contas a receber
@author zReport
@since 17/10/2022
@version 1.0
	@example
	u_xfinr130()
	@obs Fun??o gerada pelo zReport()
/*/

User Function xfinr130()
    Local aArea   := GetArea()
    Local oReport
    Local lEmail  := .F.
    Local cPara   := ""
    Private cPerg := ""

    //Defini??es da pergunta
    cPerg := "XFINR130P"

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
    oReport := TReport():New(	"xfinr130",;		//Nome do Relat?rio
        "Contas a receber",;		//T?tulo
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
    TRCell():New(oSectDad, "CODIGO", "QRY_AUX", "Codigo", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "VALOR", "QRY_AUX", "Valor", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
    cQryAux += "SELECT  E1_CLIENTE CODIGO"		+ STR_PULA
    cQryAux += "       ,A1_NREDUZ CLIENTE"		+ STR_PULA
    cQryAux += "       ,SUM(CASE WHEN E1_TIPO IN ('RA ','NCC','IR-','IS-','PI-','CS-') THEN ROUND((E1_SALDO*(-1)),2)  ELSE ROUND(E1_SALDO,2) END) AS VALOR"		+ STR_PULA
    cQryAux += "FROM"		+ STR_PULA
    cQryAux += "       SE1010"		+ STR_PULA
    cQryAux += "       INNER JOIN SA1010 ON A1_COD = E1_CLIENTE"		+ STR_PULA
    cQryAux += "       AND A1_LOJA = E1_LOJA"		+ STR_PULA
    cQryAux += "       AND SA1010.D_E_L_E_T_ = ''"		+ STR_PULA
    cQryAux += "WHERE"		+ STR_PULA
    cQryAux += "       SE1010.D_E_L_E_T_ = ''"		+ STR_PULA
    cQryAux += "       AND E1_SALDO > 0"		+ STR_PULA
    cQryAux += "       AND E1_CLIENTE BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "       + STR_PULA
    cQryAux += "       AND E1_PREFIXO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "	    + STR_PULA
    cQryAux += "       AND E1_TIPO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "		                            + STR_PULA
    cQryAux += "       AND E1_VENCREA BETWEEN '" + dtos(MV_PAR07) + "' AND '" + dtos(MV_PAR08) + "' "		                + STR_PULA
    cQryAux += "       AND E1_EMISSAO BETWEEN '" + dtos(MV_PAR09) + "' AND '" + dtos(MV_PAR10) + "' "		                + STR_PULA
    
    If !Empty(MV_PAR11)
        cQryAux += "       AND E1_TIPO NOT LIKE '" + MV_PAR11 + "' "		                                    + STR_PULA
    EndIf

    If !Empty(MV_PAR12)
        cQryAux += "       AND E1_PREFIXO NOT LIKE '" + MV_PAR12 + "' "		                                + STR_PULA
    EndIf

    cQryAux += "  "		+ STR_PULA
    cQryAux += "GROUP BY"		+ STR_PULA
    cQryAux += "       E1_CLIENTE,"		+ STR_PULA
    cQryAux += "       A1_NREDUZ"		+ STR_PULA
    cQryAux += "ORDER BY"		+ STR_PULA
    cQryAux += "       E1_CLIENTE,"		+ STR_PULA
    cQryAux += "       A1_NREDUZ"		+ STR_PULA
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
