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

User Function RELQP6()
    Local cQuery        := ""
    //Local cPerg         := "RELSN1"
    Local cTitulo       := "Relatorio de Especificacoes"

    //Chama tela de Parâmetros
    // If !Pergunte(cPerg, .T.)
    //    Return .F.
    //EndIf

    //Pegando os dados
    cQuery := "SELECT QP7_PRODUT AS PRODUTO,"
    cQuery += "    B1_DESC AS DESCRICAO, "
    cQuery += "    QP7_ENSAIO AS ENSAIO, "
    cQuery += "    QP1_DESCPO AS DESCENSAIO,"
    cQuery += "    QP7_UNIMED AS UNIDADEMEDIDA,"
    cQuery += "	   AH_UMRES AS DESCUNIMEDIDA, "
    cQuery += "    QP7_NOMINA AS MINIMOMAXIMO, "
    cQuery += "    QP7_LIE AS MINIMO, "
    cQuery += "    QP7_LSE AS MAXIMO, "
    cQuery += "    '' AS TEXTO "
    cQuery += " FROM QP7010 QP7"
    cQuery += " INNER JOIN SB1010 ON B1_COD = QP7_PRODUT"
    cQuery += " INNER JOIN QP1010 ON QP7_ENSAIO = QP1_ENSAIO"
    cQuery += " INNER JOIN SAH010 ON QP7_UNIMED = AH_UNIMED "
    cQuery += " WHERE QP7.D_E_L_E_T_ =''"
    cQuery += " union ALL"
    cQuery += " SELECT  QP8_PRODUT,B1_DESC, QP8_ENSAIO, QP1_DESCPO,'' AS UNIMED,'' AS UMRES,'' AS NOMINA,'' AS LIE,'' AS LSE ,QP8_TEXTO FROM QP8010 QP8  "
    cQuery += " INNER JOIN SB1010 ON B1_COD = QP8_PRODUT"
    cQuery += " INNER JOIN QP1010 ON QP8_ENSAIO = QP1_ENSAIO"
    cQuery += " WHERE  QP8.D_E_L_E_T_ =''"
      
    //Gera Arquivo Excel
    u_zQry2Excel(cQuery,cTitulo)
Return
