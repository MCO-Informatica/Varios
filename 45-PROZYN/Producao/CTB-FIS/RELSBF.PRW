#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

//Constantes
#Define STR_PULA    Chr(13)+Chr(10)


User Function RELSBF()
    Local cTitulo := "posicao_de_estoque"
    Default cQuery        := ""
    //Local cPerg         := "RSNPERG"
    // Default cTitulo       := "Posição de estoque/endereço Excel"

    //If !Pergunte(cPerg, .T.)
       // Return .F.
    //EndIf

    PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'


    //Pegando os dados
    // cQuery := "     SELECT "
    // cQuery += "     BF.BF_LOCAL 'Armazem', "
    // cQuery += "     B1.B1_GRUPO 'Grupo', "
    // cQuery += "     BM.BM_DESC 'DescricaoGrupo', "
    // cQuery += "     BF.BF_PRODUTO 'Produto', "
    // cQuery += "     B1.B1_DESC 'NomeComercial', "
    // cQuery += "     B1.B1_TIPO 'Tipo', "
    // cQuery += "     BF.BF_LOTECTL 'Lote', "
    // cQuery += "     SUBSTRING(B8.B8_DTVALID,7,2)+'/'+SUBSTRING(B8.B8_DTVALID,5,2)+'/'+SUBSTRING(B8.B8_DTVALID,1,4)  AS 'Validade', "
    // cQuery += "     BF.BF_LOCALIZ 'Endereco', "
    // cQuery += "     B1.B1_UM 'UM', Round(BF.BF_QUANT,4) 'Quantidade', "
    // cQuery += "     Round(BF.BF_EMPENHO,4) 'Empenho',
    // cQuery += "     Round((BF.BF_QUANT-BF.BF_EMPENHO),4) 'Disponivel', "
    // cQuery += "     B9_CM1 'Custo' "
    // cQuery += " FROM " + RetSqlName("SBF") + " BF "
    // cQuery += " INNER JOIN " + RetSqlName('SB2') + " AS B2 ON "
    // cQuery += "     BF.BF_PRODUTO = B2.B2_COD AND "
    // cQuery += "     BF.BF_LOCAL = B2.B2_LOCAL "
    // cQuery += " INNER JOIN " + RetSqlName("SB8") +" AS B8 ON "
    // cQuery += "     BF_PRODUTO = B8.B8_PRODUTO AND "
    // cQuery += "     BF_LOTECTL = B8.B8_LOTECTL AND "
    // cQuery += "     B8.B8_LOCAL = BF_LOCAL AND B8.D_E_L_E_T_ ='' "
    // cQuery += " INNER JOIN " + RetSqlName("SB1") +" B1 ON "
    // cQuery += "     BF.BF_PRODUTO = B1.B1_COD "
    // cQuery += " INNER JOIN " + RetSqlName("SBM") +" BM ON "
    // cQuery += "     B1.B1_GRUPO = BM.BM_GRUPO AND BM.D_E_L_E_T_ ='' "
    // cQuery += " INNER JOIN " + RetSqlName("SB9") +" B9 ON B9_COD = B1_COD AND B9_DATA = '"+DtoS(SuperGetMV("MV_ULMES",,CtoD("30/09/2021")))+"' AND B9.D_E_L_E_T_ = ''
    // cQuery += " WHERE BF.D_E_L_E_T_ ='' AND B1.D_E_L_E_T_ ='' AND B2.D_E_L_E_T_ ='' AND BF_QUANT >0 "
    // cQuery += " group by BF.BF_LOCAL, B1.B1_GRUPO, BM_DESC, B1.B1_TIPO, BF.BF_PRODUTO, B1.B1_DESC, BF.BF_LOTECTL, B8.B8_DTVALID, BF.BF_LOCALIZ, B1.B1_UM, BF.BF_QUANT, BF.BF_EMPENHO, B9_CM1 "




    cQuery := "  SELECT B2_LOCAL 'Armazem',B1_GRUPO 'Grupo' ,BM_DESC 'DescricaoGrupo',B1_COD 'Produto', B1_DESC 'NomeComercial', B1_TIPO 'Tipo', 
    cQuery += " '' 'Lote', 
    cQuery += " ''  AS 'Validade', 
    cQuery += " '' 'Endereco', B1_UM 'UM', 
    cQuery += "  B2_QATU-B2_RESERVA-B2_QPEDVEN 'Quantidade' ,
    cQuery += "  B2_QEMP 'Empenho',
    cQuery += "  B2_QACLASS 'Classificar',
    cQuery += "  B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP-B2_QPEDVEN 'Disponivel' , 
    cQuery += "  B9_CM1 'Custo' 
    cQuery += "  FROM SB1010 B1
    cQuery += "  INNER JOIN SBM010 BM ON B1.B1_GRUPO = BM.BM_GRUPO AND BM.D_E_L_E_T_ ='' 
    cQuery += "  INNER JOIN SB2010 B2 ON B2_COD = B1_COD AND B2_QATU > 0  AND B2.D_E_L_E_T_ = ''
    cQuery += "  LEFT JOIN SB8010 B8 ON B8_PRODUTO = B1_COD AND B8_LOCAL = B2_LOCAL AND B8.D_E_L_E_T_ = ''
    cQuery += "  LEFT JOIN SB9010 B9 ON B9_COD = B1_COD AND B9_LOCAL = B2_LOCAL AND B9_DATA = '"+DtoS(SuperGetMV("MV_ULMES",,CtoD("30/09/2021")))+"' AND B9.D_E_L_E_T_ = ''
    cQuery += "  WHERE B1.D_E_L_E_T_ = '' AND B8_PRODUTO IS NULL

    cQuery += "  UNION ALL

    cQuery += "  SELECT B2_LOCAL 'Armazem',B1_GRUPO 'Grupo' ,BM_DESC 'DescricaoGrupo',B1_COD 'Produto', B1_DESC 'NomeComercial', B1_TIPO 'Tipo', 
    cQuery += "  B8_LOTECTL 'Lote', 
    cQuery += "  SUBSTRING(B8.B8_DTVALID,7,2)+'/'+SUBSTRING(B8.B8_DTVALID,5,2)+'/'+SUBSTRING(B8.B8_DTVALID,1,4)  AS 'Validade', 
    cQuery += "  '' 'Endereco', B1_UM 'UM', 
    cQuery += "  B8_QTDORI 'Quantidade' ,
    cQuery += "  B8_EMPENHO 'Empenho',
    cQuery += "  B8_QACLASS 'Classificar',
    cQuery += "  B8_SALDO - B8_QACLASS 'Disponivel' , 
    cQuery += "      B9_CM1 'Custo' 
    cQuery += "  FROM SB1010 B1
    cQuery += "  INNER JOIN SBM010 BM ON B1.B1_GRUPO = BM.BM_GRUPO AND BM.D_E_L_E_T_ ='' 
    cQuery += "  INNER JOIN SB2010 B2 ON B2_COD = B1_COD AND B2.D_E_L_E_T_ = ''
    cQuery += "  INNER JOIN SB8010 B8 ON B8_PRODUTO = B1_COD AND B8_LOCAL = B2_LOCAL AND B8_SALDO > 0 AND B8.D_E_L_E_T_ = ''
    cQuery += "  LEFT JOIN SBF010 BF ON BF_LOTECTL = B8_LOTECTL AND BF_PRODUTO = B8_PRODUTO AND BF_LOCAL = B8_LOCAL AND BF.D_E_L_E_T_ = ''
    cQuery += "  LEFT JOIN SB9010 B9 ON B9_COD = B1_COD AND B9_LOCAL = B2_LOCAL AND B9_DATA = '"+DtoS(SuperGetMV("MV_ULMES",,CtoD("30/09/2021")))+"' AND B9.D_E_L_E_T_ = ''
    cQuery += "  WHERE B1.D_E_L_E_T_ = '' AND BF_PRODUTO IS NULL

    cQuery += " UNION ALL

    cQuery += " SELECT B2_LOCAL 'Armazem',B1_GRUPO 'Grupo' ,BM_DESC 'DescricaoGrupo',B1_COD 'Produto', B1_DESC 'NomeComercial', B1_TIPO 'Tipo', 
    cQuery += "  B8_LOTECTL 'Lote', 
    cQuery += "  SUBSTRING(B8.B8_DTVALID,7,2)+'/'+SUBSTRING(B8.B8_DTVALID,5,2)+'/'+SUBSTRING(B8.B8_DTVALID,1,4)  AS 'Validade', 
    cQuery += "  BF_LOCALIZ 'Endereco', B1_UM 'UM', 
    cQuery += " Round(BF.BF_QUANT,4) 'Quantidade', 
    cQuery += " Round(BF.BF_EMPENHO,4) 'Empenho',
    cQuery += " 0 'Classificar',
    cQuery += " Round((BF.BF_QUANT-BF.BF_EMPENHO),4) 'Disponivel', 
    cQuery += "      B9_CM1 'Custo' 
    cQuery += "  FROM SB1010 B1
    cQuery += "  INNER JOIN SBM010 BM ON B1.B1_GRUPO = BM.BM_GRUPO AND BM.D_E_L_E_T_ ='' 
    cQuery += "  INNER JOIN SB2010 B2 ON B2_COD = B1_COD AND B2.D_E_L_E_T_ = ''
    cQuery += "  INNER JOIN SB8010 B8 ON B8_PRODUTO = B1_COD AND B8_LOCAL = B2_LOCAL AND B8.D_E_L_E_T_ = ''
    cQuery += "  INNER JOIN SBF010 BF ON BF_LOTECTL = B8_LOTECTL AND BF_PRODUTO = B8_PRODUTO AND BF_LOCAL = B8_LOCAL AND BF_QUANT > 0 AND BF.D_E_L_E_T_ = ''
    cQuery += "  LEFT JOIN SB9010 B9 ON B9_COD = B1_COD AND B9_LOCAL = B2_LOCAL AND B9_DATA = '"+DtoS(SuperGetMV("MV_ULMES",,CtoD("30/09/2021")))+"' AND B9.D_E_L_E_T_ = ''
    cQuery += "  WHERE B1.D_E_L_E_T_ = ''

    cQuery += " ORDER BY B1_COD,B2_LOCAL,B1_DESC "

    //Gera Arquivo Excel
    u_zQry2Excel(cQuery,cTitulo,"posicao_de_estoque")

    RESET ENVIRONMENT
Return
