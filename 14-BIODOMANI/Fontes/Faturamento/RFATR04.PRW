#Include 'Protheus.ch'
#Include 'Rwmake.ch'
#INCLUDE 'TOPCONN.CH'

User Function RFATR04()

    Local oReport
    Local cPerg		:= Padr( "RFATR04", LEN( SX1->X1_GRUPO ) )
    Local cAlias 	:= "SF2"
    Local _aGrupo   := UsrRetGrp(,RetCodUsr())
    Local _cGrupo   := Iif(__cUserID$"000000","000003",_aGrupo[1])

    If Alltrim(_cGrupo)$"000003"
        oReport := reportDef(cAlias, cPerg)
        oReport:printDialog()
    Else
        MsgAlert("Você não tem permissão para emitir este relatório")
    EndIf

return


//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

    local cTitle  := "RELACAO FATURAMENTO GLOBAL"
    local cHelp   := "Emissao do relatório de faturamento global"
    local oReport
    local oSection1
    local oSection2

    oReport := TReport():New('RFATR04',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
    oReport:SetPortrait()
    oReport:SetTotalInLine(.F.)

//Primeira seção
    oSection1 := TRSection():New(oReport,"Empresa",{"TMPSF2","SF2"})

    TRCell():New(oSection1,"EMPRESA"		, "TMPSF2", "EMPRESA"			,"@!"						,20		)

    oSection2:= TRSection():New(oReport, "Empresa",{"TMPSF2","SF2"})


//TRCell():New(oSection2,"EMPRESA"		, "TMPSF2", "EMPRESA"			,"@!"						,20		)
    TRCell():New(oSection2,"SERIE"			, "TMPSF2", "SERIE"				,"@!"						,05		)
    TRCell():New(oSection2,"NOTA"			, "TMPSF2", "NOTA"				,"@!"						,10		)
    TRCell():New(oSection2,"EMISSAO"		, "TMPSF2", "EMISSAO" 			,"@!"						,10		)
    TRCell():New(oSection2,"VALORNF"		, "TMPSF2", "VALOR NF"			,"@E 999,999,999.99"		,20		)
    TRCell():New(oSection2,"VALORVL"		, "TMPSF2", "VALOR VL"			,"@E 999,999,999.99"		,20		)
    TRCell():New(oSection2,"TOTAL"			, "TMPSF2", "TOTAL"				,"@E 999,999,999.99"		,20		)
    TRCell():New(oSection2,"NOME"			, "TMPSF2", "CLIENTE"			,"@!"						,50		)
    TRCell():New(oSection2,"UF"				, "TMPSF2", "UF"				,"@!"						,03		)
    TRCell():New(oSection2,"VENDCOSM"		, "TMPSF2", "VEND COSMO"		,"@!"						,06		)
    TRCell():New(oSection2,"VENDSAMA"		, "TMPSF2", "VEND SAMANA"		,"@!"						,06		)

    oSection2:SetTotalInLine(.f.)

    TRFunction():New(oSection2:Cell("VALORNF"),NIL,"SUM",,,,,.T.,.T.)
    TRFunction():New(oSection2:Cell("VALORVL"),NIL,"SUM",,,,,.T.,.T.)
    TRFunction():New(oSection2:Cell("TOTAL"),NIL,"SUM",,,,,.T.,.T.)


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

    Local cAliasNew		:= "TMPSF2"
    Local aStruSF2 		:= SF2->(dbStruct())
    Local nX



    cQuery := ""

    cQuery += "SELECT "
    cQuery += "'LIFE SKIN' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('001','F01') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'BIOCOSMETICOS' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('002','F02') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'BIODOMANI' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('003','F03') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'PHARMA NUTRI' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('004','F04') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'DERMA COSMETICOS' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('005','F05') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'SCD RIO MATRIZ' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('006','F06') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'SCD RIO FILIAL' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('007','F07') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'SCD RECIFE' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('008','F08') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'BIOBEAUTY' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('009','F09') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'TOTAL DERMA' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('010','F10') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'NEW DERMA' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('011','F11') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'INOVA BEAUTY' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA',
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('012','F12') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'PERFECTHA SKIN' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('013','F13') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'DERM COSMETIC' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('014','F14') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'NOVA DERMA' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('015','F15') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'COSMETIC SKIN' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('016','F16') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'BEAUTY SKIN' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('017','F17') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'TOP DERMA' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('018','F18') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'DERMA CENTER' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('019','F19') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'RENOVA BEAUTY' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 "
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('020','F20') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'ESTETICA CENTER' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 " 
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('021','F21') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'MED LIKE' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 " 
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('022','F22') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "UNION ALL "

    cQuery += "SELECT "
    cQuery += "'INOVA COSMETICOS' 'EMPRESA', "
    cQuery += "F2_SERIE 'SERIE', "
    cQuery += "F2_DOC 'NOTA', "
    cQuery += "SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) 'EMISSAO', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN F2_VALFAT "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN 0 "
    cQuery += "END "
    cQuery += "'VALORNF', "
    cQuery += "CASE "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='0' THEN 0 "
    cQuery += "WHEN SUBSTRING(F2_SERIE,1,1)='F' THEN F2_VALFAT "
    cQuery += "END "
    cQuery += "'VALORVL', "
    cQuery += "F2_VALFAT 'TOTAL', "
    cQuery += "A1_NOME 'NOME', "
    cQuery += "A1_EST 'UF', "
    cQuery += "F2_VEND1 'VENDCOSM', "
    cQuery += "F2_VEND2 'VENDSAMA' "
    cQuery += "FROM SF2010 SF2 "
    cQuery += "INNER JOIN SA1010 SA1 ON "
    cQuery += "A1_COD = F2_CLIENTE "
    cQuery += "AND A1_LOJA = F2_LOJA "
    cQuery += "AND SA1.D_E_L_E_T_='' "
    cQuery += "WHERE "
    cQuery += "F2_VALFAT > 0 " 
    cQuery += "AND SF2.D_E_L_E_T_='' "
    cQuery += "AND F2_SERIE IN ('023','F23') "
    cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

    cQuery += "ORDER BY F2_SERIE,F2_DOC "

    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

    For nX := 1 To Len(aStruSF2)
        If aStruSF2[nX][2] <> "C" .and.  FieldPos(aStruSF2[nX][1]) > 0
            TcSetField(cAliasNew,aStruSF2[nX][1],aStruSF2[nX][2],aStruSF2[nX][3],aStruSF2[nX][4])
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

        _cPedido := (cAliasNew)->EMPRESA


        oSection1:Cell("EMPRESA"):SetValue((cAliasNew)->EMPRESA)
        oSection1:Printline()

        //inicializo a segunda seção
        oSection2:init()


        While (cAliasNew)->(!Eof()) .and. (cAliasNew)->EMPRESA == _cPedido


            oReport:IncMeter()


            //oSection2:Cell("EMPRESA"):SetValue((cAliasNew)->EMPRESA)
            oSection2:Cell("SERIE"):SetValue((cAliasNew)->SERIE)
            oSection2:Cell("NOTA"):SetValue((cAliasNew)->NOTA)
            oSection2:Cell("EMISSAO"):SetValue((cAliasNew)->EMISSAO)
            oSection2:Cell("VALOR NF"):SetValue((cAliasNew)->VALORNF)
            oSection2:Cell("VALOR VL"):SetValue((cAliasNew)->VALORVL)
            oSection2:Cell("TOTAL"):SetValue((cAliasNew)->TOTAL)
            oSection2:Cell("CLIENTE"):SetValue((cAliasNew)->NOME)
            oSection2:Cell("UF"):SetValue((cAliasNew)->UF)
            oSection2:Cell("VEND COSMO"):SetValue((cAliasNew)->VENDCOSM)
            oSection2:Cell("VEND SAMANA"):SetValue((cAliasNew)->VENDSAMA)

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

