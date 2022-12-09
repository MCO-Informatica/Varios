#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#Include 'FWMVCDEF.ch'

//===========================================================================
// Programa.......: RWOKF01
// Autor..........: Anderson Goncalves
// Data...........: 19/03/21
// Descricao......: Ponto de entrada antes da gravacao do pedido de vendas
// Uso............: Verquimica
//===========================================================================

User Function A410TudOk()

//===============================================
// Variaveis da Rotina
//===============================================
Local lRet  := .T.

If M->C5_TIPO == "C" .and. Empty(M->C5_VEND1)
    msgInfo("Para pedidos de complemento de valor ou quantidade, é necessário informar o vendedor!","Atenção")
    lRet := .F.
EndIf

Return(lRet)
