#Include 'Protheus.ch'
#Include 'Rwmake.ch'
#INCLUDE 'TOPCONN.CH'

User Function RFATR07()

    Local oReport
    Local cPerg		:= Padr( "RFATR07", LEN( SX1->X1_GRUPO ) )
    Local cAlias 	:= "SC5"

    Pergunte(cPerg,.f. )

    oReport := reportDef(cAlias, cPerg)
    oReport:printDialog()

return


//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

    local cTitle  := "RELACAO VENDAS POR VENDEDOR"
    local cHelp   := "Emissao da relação de vendas por vendedor"
    local oReport
    local oSection1
    local oSection2

    oReport := TReport():New('RFATR07',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
    oReport:SetPortrait()
    oReport:SetTotalInLine(.F.)

//Primeira seção
    oSection1 := TRSection():New(oReport,"Vendedor",{"TMPSC5","SC5"})

    TRCell():New(oSection1,"VENDEDOR"		, "TMPSC5", "VENDEDOR"			,"@!"						,20		)
    TRCell():New(oSection1,"NOME"		    , "TMPSC5", "NOME"   			,"@!"						,50		)

    oSection2:= TRSection():New(oReport, "" ,{"TMPSC5","SC5"})

    TRCell():New(oSection2,"PEDIDO"			, "TMPSC5", "PEDIDO"			,"@!"						,08		)
    TRCell():New(oSection2,"EMISSAO"		, "TMPSC5", "EMISSAO" 			,"@!"						,14		)
    TRCell():New(oSection2,"CODCLI"			, "TMPSC5", "CODCLI"			,"@!"						,08		)
    TRCell():New(oSection2,"LOJA"			, "TMPSC5", "LOJA"				,"@!"						,04		)
    TRCell():New(oSection2,"CLIENTE"		, "TMPSC5", "CLIENTE"			,"@!"						,50		)
    TRCell():New(oSection2,"CIDADE"			, "TMPSC5", "CIDADE"			,"@!"						,50		)
    TRCell():New(oSection2,"UF"				, "TMPSC5", "UF"				,"@!"						,04		)
    TRCell():New(oSection2,"CEP"			, "TMPSC5", "CEP"				,"@R 99999-999"				,14		)
    TRCell():New(oSection2,"VISITA"			, "TMPSC5", "VISITA"			,"@!"						,14		)
    TRCell():New(oSection2,"ARMAZEM"		, "TMPSC5", "ARMAZEM"			,"@!"						,08		)
    TRCell():New(oSection2,"VALOR"			, "TMPSC5", "VALOR"				,"@E 999,999,999.99"		,20		)
    TRCell():New(oSection2,"VENDEDOR5"		, "TMPSC5", "VENDEDOR5"			,"@!"						,20		)
    TRCell():New(oSection2,"NOME5"		    , "TMPSC5", "NOME5"   			,"@!"						,50		)

    oSection2:SetTotalInLine(.f.)

    TRFunction():New(oSection2:Cell("VALOR"),NIL,"SUM",,,,,.T.,.T.)


    oReport:SetTotalInLine(.F.)

    oSection1:SetPageBreak(.T.)
    oSection1:SetTotalText(" ")

Return(oReport)


//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)


    Local oSection1 	:= oReport:Section(1)
    Local oSection2 	:= oReport:Section(2)
    Local cQuery			:= ""
    Local cRepTit		:= oReport:Title()
    Local cTitulo		:= oReport:Title()

    Local cAliasNew		:= "TMPSC5"
    Local aStruSC5 		:= SC5->(dbStruct())

    Local _aGrupo := UsrRetGrp(,RetCodUsr())
    Local _cGrupo := Iif(__cUserID$"000000","000003",_aGrupo[1])



    If !Empty(MV_PAR04)
        cQuery := " "
        cQuery += "SELECT "
        cQuery += "'COSMOBEAUTY' 'LINHA', "
        //cQuery += "C5_VEND1 'VENDEDOR', "
        //cQuery += "A3_NOME 'NOME', "
        cQuery += "C5_VEND1 'VENDEDOR', "
        cQuery += "(SELECT A3_NOME FROM SA3010 SA3 WHERE A3_COD = C5_VEND1 AND SA3.D_E_L_E_T_='' ) 'NOME', "
        cQuery += "C5_NUM 'PEDIDO', "
        cQuery += "SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "C5_CLIENTE 'CODCLI', "
        cQuery += "C5_LOJACLI 'LOJA', "
        cQuery += "A1_NOME 'CLIENTE', "
        cQuery += "A1_MUN 'CIDADE', "
        cQuery += "A1_EST 'UF', "
        cQuery += "A1_CEP 'CEP', "
        cQuery += "SUBSTRING(A1_ULTVIS,7,2)+'/'+SUBSTRING(A1_ULTVIS,5,2)+'/'+SUBSTRING(A1_ULTVIS,1,4) 'VISITA', "
        cQuery += "C5_X_ARMAZ 'ARMAZEM', "
        cQuery += "C5_VEND5 'VENDEDOR5', "
        cQuery += "(CASE WHEN C5_VEND5 <> '' THEN (SELECT A3_NOME FROM SA3010 SA3 WHERE A3_COD = C5_VEND5 AND SA3.D_E_L_E_T_='' )  ELSE '' END) AS 'NOME5', "
        cQuery += "SUM(C6_VALOR) 'VALOR' "
        
        cQuery += "FROM "
        cQuery += "SC5010 SC5 "
        cQuery += "INNER JOIN SC6010 SC6 ON "
        cQuery += "C6_NUM = C5_NUM "
        cQuery += "AND C6_CLI = C5_CLIENTE "
        cQuery += "AND C6_LOJA = C5_LOJACLI "
        cQuery += "AND SC6.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = C6_TES "
        cQuery += "AND F4_DUPLIC = 'S' "
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = C5_CLIENTE  "
        cQuery += "AND A1_LOJA = C5_LOJACLI "
        cQuery += "WHERE SC5.D_E_L_E_T_='' "
        cQuery += "AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND C5_X_ARMAZ BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "

        //----> GRUPO GERENCIAL
        If Alltrim(_cGrupo)$"000003"
            cQuery += "AND C5_VEND1 BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
        Else
            cQuery += "AND C5_VEND1 BETWEEN '"+Posicione("SA3",7,xFilial("SA3")+__cUserID,"A3_COD")+"' AND '"+Posicione("SA3",7,xFilial("SA3")+__cUserID,"A3_COD")+"' "
        EndIf

        /*
        If MV_PAR13 = 2
            cQuery += "AND C5_VEND5 = '' "
        Else
            cQuery += "AND C5_VEND5 <> '' "
        EndIf
        */

        cQuery += "GROUP BY C5_VEND1, C5_NUM, C5_EMISSAO, A1_NOME, A1_MUN, A1_EST, A1_CEP, C5_CLIENTE, C5_LOJACLI, A1_ULTVIS, C5_X_ARMAZ, C5_VEND5 "
        cQuery += "ORDER BY C5_VEND1, C5_NUM, C5_EMISSAO, A1_NOME, A1_MUN, A1_EST, A1_CEP, C5_CLIENTE, C5_LOJACLI, A1_ULTVIS, C5_X_ARMAZ, C5_VEND5 "
    EndIf

    If !Empty(MV_PAR06)
        cQuery := " "
        cQuery += "SELECT "
        cQuery += "'SAMANA' 'LINHA', "
        cQuery += "C5_VEND2 'VENDEDOR', "
        cQuery += "(SELECT A3_NOME FROM SA3010 SA3 WHERE A3_COD = C5_VEND2 AND SA3.D_E_L_E_T_='' ) 'NOME', "
        cQuery += "C5_NUM 'PEDIDO', "
        cQuery += "SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "C5_CLIENTE 'CODCLI', "
        cQuery += "C5_LOJACLI 'LOJA', "
        cQuery += "A1_NOME 'CLIENTE', "
        cQuery += "A1_MUN 'CIDADE', "
        cQuery += "A1_EST 'UF', "
        cQuery += "A1_CEP 'CEP', "
        cQuery += "SUBSTRING(A1_ULTVIS1,7,2)+'/'+SUBSTRING(A1_ULTVIS1,5,2)+'/'+SUBSTRING(A1_ULTVIS1,1,4) 'VISITA', "
        cQuery += "C5_X_ARMAZ 'ARMAZEM', "
        cQuery += "C5_VEND5 'VENDEDOR5', "
        cQuery += "(CASE WHEN C5_VEND5 <> '' THEN (SELECT A3_NOME FROM SA3010 SA3 WHERE A3_COD = C5_VEND5 AND SA3.D_E_L_E_T_='' )  ELSE '' END) AS 'NOME5', "
        cQuery += "SUM(C6_VALOR) 'VALOR' "

        cQuery += "FROM "
        cQuery += "SC5010 SC5 "
        cQuery += "INNER JOIN SC6010 SC6 ON "
        cQuery += "C6_NUM = C5_NUM "
        cQuery += "AND C6_CLI = C5_CLIENTE "
        cQuery += "AND C6_LOJA = C5_LOJACLI "
        cQuery += "AND SC6.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = C6_TES "
        cQuery += "AND F4_DUPLIC = 'S' "
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = C5_CLIENTE  "
        cQuery += "AND A1_LOJA = C5_LOJACLI "
        cQuery += "WHERE SC5.D_E_L_E_T_='' "
        cQuery += "AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND C5_X_ARMAZ BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "

        //----> GRUPO GERENCIAL
        If Alltrim(_cGrupo)$"000003"
            cQuery += "AND C5_VEND2 BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
        Else
            cQuery += "AND C5_VEND2 BETWEEN '"+Posicione("SA3",7,xFilial("SA3")+__cUserID,"A3_COD")+"' AND '"+Posicione("SA3",7,xFilial("SA3")+__cUserID,"A3_COD")+"' "
        EndIf

        /*
        If MV_PAR13 = 2
            cQuery += "AND C5_VEND5 = '' "
        Else
            cQuery += "AND C5_VEND5 <> '' "
        EndIf
        */

        cQuery += "GROUP BY C5_VEND2, C5_NUM, C5_EMISSAO, A1_NOME, A1_MUN, A1_EST, A1_CEP, C5_CLIENTE, C5_LOJACLI, A1_ULTVIS1, C5_X_ARMAZ, C5_VEND5 "
        cQuery += "ORDER BY C5_VEND2, C5_NUM, C5_EMISSAO, A1_NOME, A1_MUN, A1_EST, A1_CEP, C5_CLIENTE, C5_LOJACLI, A1_ULTVIS1, C5_X_ARMAZ, C5_VEND5 "
    EndIf

    If !Empty(MV_PAR08)
        cQuery := " "
        cQuery += "SELECT "
        cQuery += "'COSMO EXT' 'LINHA', "
        cQuery += "C5_VEND3 'VENDEDOR', "
        cQuery += "(SELECT A3_NOME FROM SA3010 SA3 WHERE A3_COD = C5_VEND3 AND SA3.D_E_L_E_T_='' ) 'NOME', "
        cQuery += "C5_NUM 'PEDIDO', "
        cQuery += "SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "C5_CLIENTE 'CODCLI', "
        cQuery += "C5_LOJACLI 'LOJA', "
        cQuery += "A1_NOME 'CLIENTE', "
        cQuery += "A1_MUN 'CIDADE', "
        cQuery += "A1_EST 'UF', "
        cQuery += "A1_CEP 'CEP', "
        cQuery += "SUBSTRING(A1_ULTVIS,7,2)+'/'+SUBSTRING(A1_ULTVIS,5,2)+'/'+SUBSTRING(A1_ULTVIS,1,4) 'VISITA', "
        cQuery += "C5_X_ARMAZ 'ARMAZEM', "
        cQuery += "C5_VEND5 'VENDEDOR5', "
        cQuery += "(CASE WHEN C5_VEND5 <> '' THEN (SELECT A3_NOME FROM SA3010 SA3 WHERE A3_COD = C5_VEND5 AND SA3.D_E_L_E_T_='' )  ELSE '' END) AS 'NOME5', "
        cQuery += "SUM(C6_VALOR) 'VALOR' "
        
        cQuery += "FROM "
        cQuery += "SC5010 SC5 "
        cQuery += "INNER JOIN SC6010 SC6 ON "
        cQuery += "C6_NUM = C5_NUM "
        cQuery += "AND C6_CLI = C5_CLIENTE "
        cQuery += "AND C6_LOJA = C5_LOJACLI "
        cQuery += "AND SC6.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = C6_TES "
        cQuery += "AND F4_DUPLIC = 'S' "
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = C5_CLIENTE  "
        cQuery += "AND A1_LOJA = C5_LOJACLI "
        cQuery += "INNER JOIN SA3010 SA3 ON "
        cQuery += "A3_COD = C5_VEND3 "
        cQuery += "AND SA3.D_E_L_E_T_='' "
        cQuery += "WHERE SC5.D_E_L_E_T_='' "
        cQuery += "AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND C5_X_ARMAZ BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "

        //----> GRUPO GERENCIAL
        If Alltrim(_cGrupo)$"000003"
            cQuery += "AND C5_VEND3 BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
        Else
            cQuery += "AND C5_VEND3 BETWEEN '"+Posicione("SA3",7,xFilial("SA3")+__cUserID,"A3_COD")+"' AND '"+Posicione("SA3",7,xFilial("SA3")+__cUserID,"A3_COD")+"' "
        EndIf

        /*
        If MV_PAR13 = 2
            cQuery += "AND C5_VEND5 = '' "
        Else
            cQuery += "AND C5_VEND5 <> '' "
        EndIf
        */

        cQuery += "GROUP BY C5_VEND3, C5_NUM, C5_EMISSAO, A1_NOME, A1_MUN, A1_EST, A1_CEP, C5_CLIENTE, C5_LOJACLI, A1_ULTVIS, C5_X_ARMAZ, C5_VEND5 "
        cQuery += "ORDER BY C5_VEND3, C5_NUM, C5_EMISSAO, A1_NOME, A1_MUN, A1_EST, A1_CEP, C5_CLIENTE, C5_LOJACLI, A1_ULTVIS, C5_X_ARMAZ, C5_VEND5 "
    EndIf

    If !Empty(MV_PAR10)
        cQuery := " "
        cQuery += "SELECT "
        cQuery += "'SAMANA EXT' 'LINHA', "
        cQuery += "C5_VEND4 'VENDEDOR', "
        cQuery += "(SELECT A3_NOME FROM SA3010 SA3 WHERE A3_COD = C5_VEND4 AND SA3.D_E_L_E_T_='' ) 'NOME', "
        cQuery += "C5_NUM 'PEDIDO', "
        cQuery += "SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "C5_CLIENTE 'CODCLI', "
        cQuery += "C5_LOJACLI 'LOJA', "
        cQuery += "A1_NOME 'CLIENTE', "
        cQuery += "A1_MUN 'CIDADE', "
        cQuery += "A1_EST 'UF', "
        cQuery += "A1_CEP 'CEP', "
        cQuery += "SUBSTRING(A1_ULTVIS1,7,2)+'/'+SUBSTRING(A1_ULTVIS1,5,2)+'/'+SUBSTRING(A1_ULTVIS1,1,4) 'VISITA', "
        cQuery += "C5_X_ARMAZ 'ARMAZEM', "
        cQuery += "C5_VEND5 'VENDEDOR5', "
        cQuery += "(CASE WHEN C5_VEND5 <> '' THEN (SELECT A3_NOME FROM SA3010 SA3 WHERE A3_COD = C5_VEND5 AND SA3.D_E_L_E_T_='' )  ELSE '' END) AS 'NOME5', "
        cQuery += "SUM(C6_VALOR) 'VALOR' "

        cQuery += "FROM "
        cQuery += "SC5010 SC5 "
        cQuery += "INNER JOIN SC6010 SC6 ON "
        cQuery += "C6_NUM = C5_NUM "
        cQuery += "AND C6_CLI = C5_CLIENTE "
        cQuery += "AND C6_LOJA = C5_LOJACLI "
        cQuery += "AND SC6.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = C6_TES "
        cQuery += "AND F4_DUPLIC = 'S' "
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = C5_CLIENTE  "
        cQuery += "AND A1_LOJA = C5_LOJACLI "
        cQuery += "INNER JOIN SA3010 SA3 ON "
        cQuery += "A3_COD = C5_VEND4 "
        cQuery += "AND SA3.D_E_L_E_T_='' "
        cQuery += "WHERE SC5.D_E_L_E_T_='' "
        cQuery += "AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND C5_X_ARMAZ BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "

        //----> GRUPO GERENCIAL
        If Alltrim(_cGrupo)$"000003"
            cQuery += "AND C5_VEND4 BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
        Else
            cQuery += "AND C5_VEND4 BETWEEN '"+Posicione("SA3",7,xFilial("SA3")+__cUserID,"A3_COD")+"' AND '"+Posicione("SA3",7,xFilial("SA3")+__cUserID,"A3_COD")+"' "
        EndIf

        /*
        If MV_PAR13 = 2
            cQuery += "AND C5_VEND5 = '' "
        Else
            cQuery += "AND C5_VEND5 <> '' "
        EndIf
        */

        cQuery += "GROUP BY C5_VEND4, C5_NUM, C5_EMISSAO, A1_NOME, A1_MUN, A1_EST, A1_CEP, C5_CLIENTE, C5_LOJACLI, A1_ULTVIS1, C5_X_ARMAZ, C5_VEND5 "
        cQuery += "ORDER BY C5_VEND4, C5_NUM, C5_EMISSAO, A1_NOME, A1_MUN, A1_EST, A1_CEP, C5_CLIENTE, C5_LOJACLI, A1_ULTVIS1, C5_X_ARMAZ, C5_VEND5 "
    EndIf


    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

    For nX := 1 To Len(aStruSC5)
        If aStruSC5[nX][2] <> "C" .and.  FieldPos(aStruSC5[nX][1]) > 0
            TcSetField(cAliasNew,aStruSC5[nX][1],aStruSC5[nX][2],aStruSC5[nX][3],aStruSC5[nX][4])
        EndIf
    Next nX

    oReport:SetMeter((cAliasNew)->(LastRec()))

    oReport:SetTitle(cTitulo)

    (cAliasNew)->(dbGoTop())
    While (cAliasNew)->(!Eof())

        If oReport:Cancel()
            Exit
        EndIf

        //inicializo a primeira seção
        oSection1:Init()

        oReport:IncMeter()

        IncProc("Imprimindo Relatorio")

        _cPedido := (cAliasNew)->VENDEDOR


        oSection1:Cell("VENDEDOR"):SetValue((cAliasNew)->VENDEDOR)
        oSection1:Printline()

        //inicializo a segunda seção
        oSection2:init()


        While (cAliasNew)->(!Eof()) .and. (cAliasNew)->VENDEDOR == _cPedido


            oReport:IncMeter()


            oSection2:Cell("PEDIDO"):SetValue((cAliasNew)->PEDIDO)
            oSection2:Cell("EMISSAO"):SetValue((cAliasNew)->EMISSAO)
            oSection2:Cell("CODCLI"):SetValue((cAliasNew)->CODCLI)
            oSection2:Cell("LOJA"):SetValue((cAliasNew)->LOJA)
            oSection2:Cell("CLIENTE"):SetValue((cAliasNew)->CLIENTE)
            oSection2:Cell("CIDADE"):SetValue((cAliasNew)->CIDADE)
            oSection2:Cell("UF"):SetValue((cAliasNew)->UF)
            oSection2:Cell("CEP"):SetValue((cAliasNew)->CEP)
            oSection2:Cell("VISITA"):SetValue((cAliasNew)->VISITA)
            oSection2:Cell("ARMAZEM"):SetValue((cAliasNew)->ARMAZEM)
            oSection2:Cell("VALOR"):SetValue((cAliasNew)->VALOR)
            oSection2:Cell("VENDEDOR5"):SetValue((cAliasNew)->VENDEDOR5)
            oSection2:Cell("NOME5"):SetValue((cAliasNew)->NOME5)

            oSection2:Printline()

            DbSelectArea(cAliasNew)
            (cAliasNew)->(dbSkip())

        End

        oSection2:Finish()
        oReport:ThinLine()

    End

    oReport:ThinLine()

//finalizo a primeira seção
    oSection1:Finish()

    IF Select(cAliasNew) <> 0
        DbSelectArea(cAliasNew)
        DbCloseArea()
    ENDIF


return

