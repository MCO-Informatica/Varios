//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zCompX3XG
Fun��o que compara o grupo de campos (SX3 e SXG)
@type function
@author Atilio
@since 02/04/2017
@version 1.0
    @example
    u_zCompX3XG()
/*/
 
User Function zCompX3XG()
    Local aArea   := GetArea()
    Local oReport
    Private cPerg := "X_zCompX3XG"
 
    fValidPerg(cPerg)
     
    //Cria as defini��es do relat�rio
    If Pergunte(cPerg, .T.)
        oReport := fReportDef()
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
    Local oSectPar := Nil
    Local oSectDad := Nil
     
    //Cria��o do componente de impress�o
    oReport := TReport():New(    "zCompX3XG",;        //Nome do Relat�rio
                                    "Compara��o de Grupo de Campos (SX3 x SXG)",;        //T�tulo
                                    cPerg,;        //Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
                                    {|oReport| fRepPrint(oReport)},;        //Bloco de c�digo que ser� executado na confirma��o da impress�o
                                    )        //Descri��o
    oReport:SetTotalInLine(.F.)
    oReport:lParamPage := .F.
    oReport:oPage:SetPaperSize(9) //Folha A4
    oReport:SetPortrait()
    oReport:SetLineHeight(60)
    oReport:nFontBody := -16
     
    //Criando a se��o de dados
    oSectPar := TRSection():New(    oReport,;        //Objeto TReport que a se��o pertence
                                        "Par�metros",;        //Descri��o da se��o
                                        {})        //Tabelas utilizadas, a primeira ser� considerada como principal da se��o
    oSectPar:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
     
    //Colunas dos Par�metros
    TRCell():New(oSectPar, "XX_PARAM", "",        "Parametro",   /*Picture*/, 030,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectPar, "XX_CONTE", "",        "Conteudo",    /*Picture*/, 030,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
     
    //Criando a se��o de dados
    oSectDad := TRSection():New(    oReport,;        //Objeto TReport que a se��o pertence
                                        "Dados",;        //Descri��o da se��o
                                        {})        //Tabelas utilizadas, a primeira ser� considerada como principal da se��o
    oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
     
    //Colunas do relat�rio
    TRCell():New(oSectDad, "XX_GRUPO", "",        "Grupo",        /*Picture*/, 003,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "XX_GRDES", "",        "Grup. Desc.",  /*Picture*/, 015,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "XX_CAMPO", "",        "Campo",        /*Picture*/, 010,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "XX_CPTIT", "",        "Camp. Tit.",   /*Picture*/, 012,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "XX_GRTAM", "",        "Tam. Grupo",   /*Picture*/, 003,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "XX_CPTAM", "",        "Tam. Campo",   /*Picture*/, 003,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "XX_STATU", "",        "Status",       /*Picture*/, 015,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
     
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Fun��o que imprime o relat�rio                                         |
 *-------------------------------------------------------------------------------*/
     
Static Function fRepPrint(oReport)
    Local aArea    := GetArea()
    Local aAreaX3  := SX3->(GetArea())
    Local aAreaXG  := SXG->(GetArea())
    Local oSectPar := Nil
    Local oSectDad := Nil
    Local nAtual   := 0
    Local nTotal   := 0
    Local nTipo    := MV_PAR01
    Local lFil     := MV_PAR02 == 1
    Local cStatus  := ""
     
    //Pegando as se��es do relat�rio
    oSectPar := oReport:Section(1)
    oSectDad := oReport:Section(2)
     
    //Par�metros
    oSectPar:Init()
    oSectPar:Cell("XX_PARAM"):SetValue("Tipo?")
    oSectPar:Cell("XX_CONTE"):SetValue(Iif(nTipo==1, "TODOS", Iif(nTipo==2, "SOMENTE DIFERENTES", "SOMENTE IGUAIS")))
    oSectPar:PrintLine()
    oSectPar:Cell("XX_PARAM"):SetValue("Campo Filial?")
    oSectPar:Cell("XX_CONTE"):SetValue(Iif(lFil, "SIM", "NAO"))
    oSectPar:PrintLine()
    oSectPar:Finish()
     
    DbSelectArea("SXG")
    SXG->(DbSetOrder(1)) //XG_GRUPO
    DbSelectArea("SX3")
    SX3->(DbSetOrder(1)) //X3_ARQUIVO+X3_ORDEM
    SX3->(DbSetFilter({|| X3_GRPSXG != ' ' }, "X3_GRPSXG != ' '"))
    SX3->(DbGoTop())
     
    //Setando o tamanho da r�gua
    Count To nTotal
    oReport:SetMeter(nTotal)
    SX3->(DbGoTop())
     
    //Enquanto houver dados
    oSectDad:Init()
    While !SX3->(EOF())
        nAtual++
        oReport:SetMsgPrint("Processando campo "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+" ("+Alltrim(SX3->X3_CAMPO)+")...")
        oReport:IncMeter()
         
        //Se for pular campo de filial
        If !lFil .And. "_FILIAL" $ SX3->X3_CAMPO
            SX3->(DbSkip())
            Loop
        EndIf
                 
        //Se conseguir posicionar no grupo de campso
        SXG->(DbGoTop())
        If SXG->(DbSeek(SX3->X3_GRPSXG))
            oSectDad:Cell("XX_GRUPO"):SetValue(SXG->XG_GRUPO)
            oSectDad:Cell("XX_GRDES"):SetValue(SXG->XG_DESCRI)
            oSectDad:Cell("XX_CAMPO"):SetValue(SX3->X3_CAMPO)
            oSectDad:Cell("XX_CPTIT"):SetValue(SX3->X3_TITULO)
            oSectDad:Cell("XX_GRTAM"):SetValue(SXG->XG_SIZE)
            oSectDad:Cell("XX_CPTAM"):SetValue(SX3->X3_TAMANHO)
            oSectDad:Cell("XX_STATU"):SetValue("")
             
            //Verificando se � igual ou diferente
            If SXG->XG_SIZE == SX3->X3_TAMANHO
                cStatus := "IGUAIS"
            Else
                cStatus := "DIFERENTES"
            EndIf
            oSectDad:Cell("XX_STATU"):SetValue(cStatus)
             
            //Se for todos, ou somente diferentes ou somente iguais
            If nTipo == 1 .Or. (nTipo == 2 .And. cStatus == "DIFERENTES") .Or. (nTipo == 3 .And. cStatus == "IGUAIS")
                oSectDad:PrintLine()
            EndIf
        EndIf
         
        SX3->(DbSkip())
    EndDo
    oSectDad:Finish()
    SX3->(DbClearFilter())
     
    RestArea(aAreaXG)
    RestArea(aAreaX3)
    RestArea(aArea)
Return
 
/*---------------------------------------------------------------------*
 | Func:  fValidPerg                                                   |
 | Desc:  Fun��o para cria��o do grupo de perguntas                    |
 *---------------------------------------------------------------------*/
 
Static Function fValidPerg(cPerg)
    //(            cGrupo,    cOrdem,    cPergunt,            cPergSpa,        cPergEng,    cVar,        cTipo,    nTamanho,                    nDecimal,    nPreSel,    cGSC,    cValid,    cF3,    cGrpSXG,    cPyme,    cVar01,        cDef01,    cDefSpa1,    cDefEng1,    cCnt01,    cDef02,                        cDefSpa2,    cDefEng2,    cDef03,                    cDefSpa3,        cDefEng3,    cDef04,    cDefSpa4,    cDefEng4,    cDef05,    cDefSpa5,    cDefEng5,    aHelpPor,    aHelpEng,    aHelpSpa,    cHelp)
    PutSx1(    cPerg,        "01",        "Tipo?",            "",                "",            "mv_ch0",    "N",    1,                            0,            1,            "C",    "",         "",        "",            "",        "mv_par01",    "Todos",    "",            "",            "",            "Somente Diferentes",        "",            "",            "Somente Iguais",            "",                "",            "",            "",            "",            "",            "",            "",            {},            {},            {},            "")
    PutSx1(    cPerg,        "02",        "Campo Filial?",    "",                "",            "mv_ch1",    "N",    1,                            0,            1,            "C",    "",         "",        "",            "",        "mv_par02",    "Sim",        "",            "",            "",            "N�o",                            "",            "",            "",                            "",                "",            "",            "",            "",            "",            "",            "",            {},            {},            {},            "")
Return