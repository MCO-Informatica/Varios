#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

//==================================================================================
// Programa.....: MT120ALT
// Autor........: Anderson Goncalves
// Data.........: 23/09/21
// Descricao....: Ponto de entrada para permitir alteração somento em pedidos 
//                liberados
// Uso..........: Verquimica
//==================================================================================

User Function MT120ALT()

//===============================================
// Variaveis da Rotina
//===============================================
Local lRet  := .T.
Local lAltPed   := GetMv("VQ_ALTSC7",,.F.)

If ALTERA .and. lAltPed
    If SC7->C7_CONAPRO <> 'L'
        msgStop("Este pedido somente pode ser alterado se o mesmo já estiver liberado!","Atenção")
        lRet := .F.
    EndIf
EndIf

Return(lRet)

