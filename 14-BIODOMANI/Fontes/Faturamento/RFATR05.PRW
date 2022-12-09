#Include "Protheus.ch"
#Include "Rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function RFATR05()

    Local oReport
    Local cPerg		:= Padr( "RFATR05", LEN( SX1->X1_GRUPO ) )
    Local cAlias 	:= "SD2"
    Local _aGrupo   := UsrRetGrp(,RetCodUsr())
    Local _cGrupo   := Iif(__cUserID$"000000.000286.000287","000003",_aGrupo[1])

    If Alltrim(_cGrupo)$"000003"
        oReport := reportDef(cAlias, cPerg)
        oReport:printDialog()
  
        Pergunte(cPerg,.f. )

    Else
        MsgAlert("Você não tem permissão para emitir este relatório")
    EndIf

return


//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

    local cTitle  := "RELACAO MOVIMENTACAO PRODUTOS LOOK LOG/FEIRAS"
    local cHelp   := "Emissao do relatório de movimentação de produtos Look Log/Feiras"
    local oReport
    local oSection1
    local oSection2

    oReport := TReport():New('RFATR05',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
    oReport:SetPortrait()
    oReport:SetTotalInLine(.F.)

//Primeira seção
    oSection1 := TRSection():New(oReport,"Empresa",{"TMPSD2","SD2"})

    TRCell():New(oSection1,"EMPRESA"		, "TMPSD2", "EMPRESA"			,"@!"						,20		)

    oSection2:= TRSection():New(oReport, "Empresa",{"TMPSD2","SD2"})


    TRCell():New(oSection2,"SERIE"			, "TMPSD2", "SERIE"				,"@!"						,05		)
    TRCell():New(oSection2,"NOTA"			, "TMPSD2", "NOTA"				,"@!"						,15		)
    TRCell():New(oSection2,"EMISSAO"		, "TMPSD2", "EMISSAO" 			,"@!"						,14		)
    TRCell():New(oSection2,"PRODUTO"		, "TMPSD2", "PRODUTO"			,"@!"						,20		)
    TRCell():New(oSection2,"DESCRICAO"		, "TMPSD2", "DESCRIC"			,"@!"						,30		)
    TRCell():New(oSection2,"QTDE"			, "TMPSD2", "QTDE"				,"@E 999"					,05		)
    TRCell():New(oSection2,"PRECO"			, "TMPSD2", "PRCVEN"			,"@E 999,999.99"			,15		)
    TRCell():New(oSection2,"TOTAL"			, "TMPSD2", "TOTAL"				,"@E 999,999,999.99"		,20		)
    TRCell():New(oSection2,"CFOP"			, "TMPSD2", "CFOP"				,"@!"						,05		)
    TRCell():New(oSection2,"NOME"			, "TMPSD2", "CLIENTE"			,"@!"						,50		)
    TRCell():New(oSection2,"UF"				, "TMPSD2", "UF"				,"@!"						,03		)

    oSection2:SetTotalInLine(.f.)

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

    Local cAliasNew		:= "TMPSD2"
    Local aStruSD2 		:= SD2->(dbStruct())
    Local aCab:={}
    Local ASC5:={}
    Local aItens:={}
    Local aLinha:={}
    Local _nPrcVen:=1
    Local _cEmpFat:=""
    Local _dDataIni := MV_PAR01
    Local _dDataFim := MV_PAR02
    Local _cEmpIni  := MV_PAR04
    Local _cEmpFim  := MV_PAR05
    Local _cArmaz   := MV_PAR06
    Local nX


    cQuery := ""

    If '0101' >= _cEmpIni .and. '0101' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'LIFE SKIN' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('001') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")
        
        _cEmpIni := "0101"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf
    EndIf

    If '0102' >= _cEmpIni .and. '0102' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'BIOCOSMETICOS' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('002') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0102"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0103' >= _cEmpIni .and. '0103' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'BIODOMANI' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('003') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0103"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    Endif

    If '0104' >= _cEmpIni .and. '0104' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'PHARMA NUTRI' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('004') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0104"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0105' >= _cEmpIni .and. '0105' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'DERMA COSMETICOS' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('005') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0105"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0106' >= _cEmpIni .and. '0106' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'SCD RIO MATRIZ' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('006') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0106"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0107' >= _cEmpIni .and. '0107' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'SCD RIO FILIAL' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('007') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0107"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0108' >= _cEmpIni .and. '0108' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'SCD RECIFE' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('008') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0108"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0109' >= _cEmpIni .and. '0109' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'BIOBEAUTY' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('009') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0109"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0110' >= _cEmpIni .and. '0110' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'TOTAL DERMA' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('010') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0110"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0111' >= _cEmpIni .and. '0111' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'NEW DERMA' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('011') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0111"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0112' >= _cEmpIni .and. '0112' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'INOVA BEAUTY' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('012') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0112"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0113' >= _cEmpIni .and. '0113' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'PERFECTHA SKIN' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('013') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0113"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0114' >= _cEmpIni .and. '0114' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'DERM COSMETIC' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('014') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0114"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0115' >= _cEmpIni .and. '0115' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'NOVA DERMA' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('015') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0115"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0116' >= _cEmpIni .and. '0116' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'COSMETIC SKIN' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('016') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0116"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0117' >= _cEmpIni .and. '0117' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'BEAUTY SKIN' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('017') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0117"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0118' >= _cEmpIni .and. '0118' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'TOP DERMA' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('018') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0118"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0119' >= _cEmpIni .and. '0119' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'DERMA CENTER' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('019') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

        _cEmpIni := "0119"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0120' >= _cEmpIni .and. '0120' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'RENOVA BEAUTY' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('020') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

         _cEmpIni := "0120"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf

    If '0121' >= _cEmpIni .and. '0121' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'ESTETICA CENTER' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('021') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

         _cEmpIni := "0121"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf


    If '0122' >= _cEmpIni .and. '0122' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'MED LIKE' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('021') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

         _cEmpIni := "0122"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf


    If '0123' >= _cEmpIni .and. '0123' <= _cEmpFim
        cQuery += "SELECT  "
        cQuery += "'INOVA COSMETICOS' 'EMPRESA', "
        cQuery += "D2_SERIE 'SERIE', "
        cQuery += "D2_DOC 'NOTA', "
        cQuery += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'EMISSAO', "
        cQuery += "D2_COD 'PRODUTO', "
        cQuery += "B1_DESC 'DESCRIC', "
        cQuery += "D2_QUANT 'QTDE', D2_LOCAL 'LOCAL', "
        cQuery += "D2_PRCVEN 'PRCVEN', "
        cQuery += "D2_TOTAL 'TOTAL', "
        cQuery += "D2_CF 'CFOP', "
        cQuery += "SUBSTRING(D2_DTVALID,7,2)+'/'+SUBSTRING(D2_DTVALID,5,2)+'/'+SUBSTRING(D2_DTVALID,1,4) 'VALIDADE', "
        cQuery += "D2_LOTECTL 'LOTE', "
        cQuery += "F4_ESTOQUE 'ATUEST', "
        cQuery += "A1_NOME 'NOME', "
        cQuery += "A1_EST 'UF' "
        cQuery += "FROM SD2010 SD2 "
        cQuery += "INNER JOIN SA1010 SA1 ON "
        cQuery += "A1_COD = D2_CLIENTE "
        cQuery += "AND A1_LOJA = D2_LOJA "
        cQuery += "AND SA1.D_E_L_E_T_='' "
        cQuery += "INNER JOIN SB1010 SB1 ON "
        cQuery += "B1_COD = D2_COD "
        cQuery += "AND B1_MSBLQL = '2' "
        cQuery += "AND SB1.D_E_L_E_T_ = '' "
        cQuery += "INNER JOIN SF4010 SF4 ON "
        cQuery += "F4_CODIGO = D2_TES  "
        Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND F4_ESTOQUE = 'S' ")
        cQuery += "AND SF4.D_E_L_E_T_='' "
        cQuery += "WHERE  "
        cQuery += "SD2.D_E_L_E_T_='' "
        cQuery += "AND D2_SERIE IN ('021') "
        cQuery += "AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
        cQuery += "AND D2_LOCAL = '"+_cArmaz+"' "
         Iif(_cArmaz$"01AF",cQuery +="",cQuery += "AND D2_DTVALID >= '"+DTOS(dDataBase)+"' ")

         _cEmpIni := "0123"

        If _cEmpIni <> _cEmpFim
            cQuery += "UNION ALL "
        Else
            cQuery += "ORDER BY D2_SERIE, D2_COD, D2_DOC "
        EndIf

    EndIf   


    cQuery := ChangeQuery(cQuery)
    MemoWrite("C:\temp\RFATR05.txt",cQuery)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

    For nX := 1 To Len(aStruSD2)
        If aStruSD2[nX][2] <> "C" .and.  FieldPos(aStruSD2[nX][1]) > 0
            TcSetField(cAliasNew,aStruSD2[nX][1],aStruSD2[nX][2],aStruSD2[nX][3],aStruSD2[nX][4])
        EndIf
    Next nX

    oReport:SetMeter((cAliasNew)->(LastRec()))

    oReport:SetTitle(cTitulo)

    _nGeraPv := MV_PAR03

    (cAliasNew)->(dbGoTop())
    While (cAliasNew)->(!Eof())

        If oReport:Cancel()
            Exit
        EndIf

        //inicializo a primeira seção
        oSection1:Init()

        oReport:IncMeter()

        IncProc("Imprimindo Relatorio")

        //alert("iniciando a varredura")

        _cPedido := (cAliasNew)->EMPRESA


        If Alltrim((cAliasNew)->EMPRESA)$"LIFE SKIN"
            _cEmpFat := "0101"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"BIOCOSMETICOS"
            _cEmpFat := "0102"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"BIODOMANI"
            _cEmpFat := "0103"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"PHARMA NUTRI"
            _cEmpFat := "0104"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"DERMA COSMETICOS"
            _cEmpFat := "0105"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"SCD RIO MATRIZ"
            _cEmpFat := "0106"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"SCD RIO FILIAL"
            _cEmpFat := "0107"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"SCD RECIFE"
            _cEmpFat := "0108"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"BIOBEAUTY"
            _cEmpFat := "0109"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"TOTAL DERMA"
            _cEmpFat := "0110"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"NEW DERMA"
            _cEmpFat := "0111"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"INOVA BEAUTY"
            _cEmpFat := "0112"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"PERFECTHA SKIN"
            _cEmpFat := "0113"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"DERM COSMETIC"
            _cEmpFat := "0114"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"NOVA DERMA"
            _cEmpFat := "0115"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"COSMETIC SKIN"
            _cEmpFat := "0116"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"BEAUTY SKIN"
            _cEmpFat := "0117"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"TOP DERMA"
            _cEmpFat := "0118"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"DERMA CENTER"
            _cEmpFat := "0119"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"RENOVA BEAUTY"
            _cEmpFat := "0120"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"ESTETICA CENTER"
            _cEmpFat := "0121"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"MED LIKE"
            _cEmpFat := "0122"
        ElseIf Alltrim((cAliasNew)->EMPRESA)$"INOVA COSMETICOS"
            _cEmpFat := "0123"
        Else
            _cEmpFat := ""
        EndIf
        oSection1:Cell("EMPRESA"):SetValue((cAliasNew)->EMPRESA)
        oSection1:Printline()

        //inicializo a segunda seção
        oSection2:init()


        If _nGeraPv==1

            //cNumPed := GetSxENum("SC5","C5_NUM")
            //ConfirmSX8()

            //Alert("Novo Pedido "+cNumPed)
            aCab   := {		{"C5_FILIAL"   	  	,""					,Nil},;
                {"C5_TIPO"        	,"N"      						,Nil},;
                {"C5_CLIENTE"     	,Iif(_cArmaz$"01AF","391657","384794"),Nil},;
                {"C5_TIPOCLI"     	,"R"							,Nil},;
                {"C5_CONDPAG"     	,"001"							,Nil},;
                {"C5_LOJACLI"     	,"01"   						,Nil},;
                {"C5_LOJAENT"     	,"01"							,Nil},;
                {"C5_VENDE"			,"4"							,Nil},;
                {"C5_FORMAPG"		,"DV"   						,Nil},;
                {"C5_XDIA"			,"Liberado Entrega"   			,Nil},;
                {"C5_X_ARMAZ"		,(cAliasNew)->LOCAL				,Nil},;
                {"C5_X_EMPFA"		,_cEmpFat  						,Nil},;
                {"C5_TRANSP"	  	,"198"  						,Nil},;
                {"C5_X_USERS"		,CUSERNAME						,Nil},;
                {"C5_DF"		  	,"S"		   					,Nil},;
                {"C5_TPFRETE"	  	,"F"							,Nil},;
                {"C5_OBS1"		  	,Iif(_cArmaz$"01AF","","ARMAZENAGEM LOOKLOG/"+ALLTRIM((cAliasNew)->EMPRESA)+" DE "+DTOC(_dDataIni)+" ATE "+DTOC(_dDataFim))   		,Nil}}



        EndIf

        cSEQITEM:="00"

        While (cAliasNew)->(!Eof()) .and. (cAliasNew)->EMPRESA == _cPedido

            //Alert("Estou dentro do pedido "+_cPedido)

            oReport:IncMeter()

            If _nGeraPv==1

                _nPrcVen := Iif(Posicione("DA1",1,xFilial("DA1")+"999"+(cAliasNew)->PRODUTO,"DA1_PRCVEN"),Posicione("DA1",1,xFilial("DA1")+"999"+(cAliasNew)->PRODUTO,"DA1_PRCVEN"),1)

                cSeqItem := Soma1(cSeqItem)

                aLinha := {}
                //aadd(aLinha,{"C6_NUM"    ,cNumPed		 							,nil}) //,; // Valor Total
                aadd(aLinha,{"C6_ITEM"   ,cSeqItem                              	,nil}) //,; // Item do pedido
                aadd(aLinha,{"C6_PRODUTO",(cAliasNew)->PRODUTO						,nil}) //,; // Produto
                aadd(aLinha,{"C6_DESCRI" ,Alltrim((cAliasNew)->DESCRIC)		    ,nil}) //,; // Produto
                aadd(aLinha,{"C6_QTDVEN" ,(cAliasNew)->QTDE							,nil}) //,; // Quantidade
                aadd(aLinha,{"C6_PRCVEN" ,_nPrcVen  								,nil}) //,; // Preco Venda
                aadd(aLinha,{"C6_PRUNIT" ,_nPrcVen									,nil}) //,; // Preco Unit
                aadd(aLinha,{"C6_VALOR"  ,Round(((cAliasNew)->QTDE*_nPrcVen),2)		,nil}) //,; // Valor Total
                aadd(aLinha,{"C6_LOCAL"  ,(cAliasNew)->LOCAL  						,nil}) //,; // Local
                aadd(aLinha,{"C6_TES"    ,Iif(_cArmaz$"01AF","996","531")    			,nil}) //,; // TES
                aadd(aLinha,{"C6_X_LOTE" ,Alltrim((cAliasNew)->LOTE)				,nil}) //,; // TES
                aadd(aLinha,{"C6_X_DTLOT",CTOD((cAliasNew)->VALIDADE)				,nil}) //,; // TES

                aAdd(aItens,aLinha)
            EndIf

            oSection2:Cell("SERIE"):SetValue((cAliasNew)->SERIE)
            oSection2:Cell("NOTA"):SetValue((cAliasNew)->NOTA)
            oSection2:Cell("EMISSAO"):SetValue((cAliasNew)->EMISSAO)
            oSection2:Cell("PRODUTO"):SetValue((cAliasNew)->PRODUTO)
            oSection2:Cell("DESCRICAO"):SetValue((cAliasNew)->DESCRIC)
            oSection2:Cell("QTDE"):SetValue((cAliasNew)->QTDE)
            oSection2:Cell("PRECO"):SetValue((cAliasNew)->PRCVEN)
            oSection2:Cell("TOTAL"):SetValue((cAliasNew)->TOTAL)
            oSection2:Cell("CFOP"):SetValue((cAliasNew)->CFOP)
            oSection2:Cell("CLIENTE"):SetValue((cAliasNew)->NOME)
            oSection2:Cell("UF"):SetValue((cAliasNew)->UF)

            oSection2:Printline()

            DbSelectArea(cAliasNew)
            (cAliasNew)->(dbSkip())

        EndDo

        If _nGeraPv==1
            //Begin Transaction
            lMsErroAuto := .f.
            MSExecAuto({|x,y,z|Mata410(x,y,z)},aCab,aItens,3) //FAZ A INCLUSAO DO PEDIDO
            If lMsErroAuto
                MsgStop("Nao foi possivel gerar o Pedido de Venda")
                MostraErro()
                lRet := .F.
                DisarmTransaction()
                Break
            Else
                ALERT("Pedido Gerado com Sucesso: "+SC5->C5_NUM)
            EndIf
            //End Transaction
        EndIf

        oSection2:Finish()
        oReport:ThinLine()

        aCab:={}
        aItens:={}
        aLinha:={}
        cSEQITEM:="00"

        DbSelectArea(cAliasNew)
        //(cAliasNew)->(dbSkip())
    EndDo

    oReport:ThinLine()

//finalizo a primeira seção
    oSection1:Finish()

    IF Select(cAliasNew) <> 0
        DbSelectArea(cAliasNew)
        DbCloseArea()
    ENDIF


return

