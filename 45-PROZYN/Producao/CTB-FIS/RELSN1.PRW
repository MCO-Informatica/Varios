#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA    Chr(13)+Chr(10)

/*/{Protheus.doc} RELSN1
Relatório de Ativos em Excel
@author Gustavo Gonzalez
@since 28/08/2020
@version 1.0
 /*/

User Function RELSN1()
    Local cQuery        := ""
    Local cPerg         := "RSN1PERG"
    Local cTitulo       := "Relatório de Ativos"

    //Chama tela de Parâmetros
    If !Pergunte(cPerg, .T.)
        Return .F.
    EndIf

    //Pegando os dados
    cQuery := "     SELECT "
    cQuery += "     N1_CBASE, "
    cQuery += "     N1_DESCRIC , "
    cQuery += "     N1_CHAPA , "
    cQuery += "     N1_FORNEC , "
    cQuery += "     N1_AQUISIC , "
    cQuery += "     N1_NFISCAL , "
    cQuery += "     N1_ITEM , "
    cQuery += "     N3_HISTOR , "
    cQuery += "     N3_CCONTAB , "
    cQuery += "     N3_CUSTBEM , "
    cQuery += "     N3_CDEPREC , "
    cQuery += "     N3_CCUSTO , "
    cQuery += "     N3_CCDEPR , "
    cQuery += "     N3_DINDEPR , "
    cQuery += "     N3_FIMDEPR , "
    cQuery += "     N3_VORIG1 , "
    cQuery += "     N3_VRDMES1 , "
    cQuery += "     N3_TXDEPR1 , "
    cQuery += "     N3_VRDACM1 , "
    cQuery += "     (N3_VORIG1-N3_VRDACM1) AS Saldo_a_Depreciar ,"
//coluna calculo depreciação
    cQuery += "       CASE WHEN 
    cQuery += "       N3_TXDEPR1 = 0
    cQuery += "       THEN 0
    cQuery += "       WHEN round(DATEDIFF(month,substring(N3_DINDEPR,1,4)+'-'+substring(N3_DINDEPR,5,2)+'-'+substring(N3_DINDEPR,7,2), convert(varchar(4),'"+Year2Str(Date())+"')+'-'+convert(varchar(2),'"+Month2Str(Date())+"')+'-'+convert(varchar(2),'01')),0) > 100 / N3_TXDEPR1 * 12
    cQuery += "       THEN N3_VORIG1
    cQuery += "       ELSE round(DATEDIFF(month,substring(N3_DINDEPR,1,4)+'-'+substring(N3_DINDEPR,5,2)+'-'+substring(N3_DINDEPR,7,2), convert(varchar(4),'"+Year2Str(Date())+"')+'-'+convert(varchar(2),'"+Month2Str(Date())+"')+'-'+convert(varchar(2),'01')) *  N3_VORIG1 *  N3_TXDEPR1 / 12 / 100,2)
    cQuery += "       END CALCULO_ACUMULADO, "
//coluna calculo depreciação
    cQuery += "     N1_BAIXA, "
    cQuery += "     N1_ALIQPIS as ALIQ_PIS, "
    cQuery += "     N3_VORIG1 * N1_ALIQPIS / 100 as PIS, "
    cQuery += "     N1_ALIQCOF as ALIQ_COFINS, "
    cQuery += "     N3_VORIG1 * N1_ALIQCOF / 100 as COFINS, "
    cQuery += "     N3_VORIG1 - (N3_VORIG1 * N1_ALIQCOF / 100) - (N3_VORIG1 * N1_ALIQPIS / 100) as LIQUIDO "
    cQuery += " FROM " + RetSqlName('SN1') + " N1 "
    cQuery += " INNER JOIN " + RetSqlName('SN3') + " N3 "
    cQuery += "     ON N1_CBASE = N3_CBASE  AND N1.N1_AQUISIC = N3.N3_AQUISIC AND N1.N1_ITEM = N3.N3_ITEM "
    cQuery += " WHERE N1.D_E_L_E_T_ = '' "
    cQuery += "     AND N3.D_E_L_E_T_ = '' "
    cQuery += "     AND N1.N1_AQUISIC BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
    If MV_PAR03 == 2
        cQuery += "     AND N1.N1_BAIXA = '' "
    EndIf
    
    //Gera Arquivo Excel
    u_zQry2Excel(cQuery,cTitulo,"relatorio_de_ativos")
Return
