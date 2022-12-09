#include "Rwmake.ch"
#include "Protheus.ch"
#include "TopConn.ch"

//========================================================================
// Programa....: MT500APO
// Autor.......: Anderson Goncalves
// Data........: 08/07/2021
// Descricao...: Ponto de entrada apos a liberação de residuo
// Uso.........: Verquimica
//========================================================================

User Function MT500APO()

// Verifica se o pedido foi cancelado no atendimento (CallCenter)
//=======================================
// Variaveis da Rotina
//=======================================
Local cQuery    := NIL

cQuery := "SELECT COUNT(*) TOTAL FROM "+RetSqlName("SC6") + " (NOLOCK) "
cQuery += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' "
cQuery += "AND C6_NUM = '" + SC6->C6_NUM + "' "
cQuery += "AND C6_QTDENT > 0 "
cQuery += "AND D_E_L_E_T_ = ' ' "

U_FinalArea("QUERY")
TcQuery cQuery New Alias "QUERY"

dbSelectArea("QUERY")
QUERY->(dbGoTop())
If QUERY->TOTAL > 0

    dbSelectArea("SD2")
    SD2->(dbSetOrder(8))
    If SD2->(dbSeek(xFilial("SD2")+SC6->C6_NUM))

        dbSelectArea("SF2")
        SF2->(dbSetOrder(1))
        SF2->(dbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA ))

        dbSelectArea("SUA")
        SUA->(dbSetOrder(1))
        If SUA->(dbSeek(xFilial("SUA")+SC6->C6_NUM ))
            RecLock("SUA",.F.)
            SUA->UA_STATUS 	:= "NF."
            SUA->UA_CANC 	:= ""
            SUA->UA_CODCANC := ""
            SUA->UA_EMISNF 	:= SF2->F2_EMISSAO
            SUA->UA_SERIE 	:= SF2->F2_SERIE
            SUA->UA_DOC 	:= SF2->F2_DOC
            SUA->(msUnlock())
        EndIf

    EndIf

EndIf

U_FinalArea("QUERY")

Return Nil

