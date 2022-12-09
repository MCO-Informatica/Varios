#INCLUDE "Totvs.ch"

//===========================================================================
// Programa.......: MT110FIL
// Autor..........: Anderson Goncalves
// Data...........: 29/07/2021
// Descricao......: Filtros de usuarios para solicitação de compras
// Uso............: Verquimica
//===========================================================================

User Function MT110FIL()

//===========================================================================
//Variaveis da Rotina
//===========================================================================
Local cFiltro   := "C1_FILIAL == '"+ cFilAnt + "' "

If msgYesNo("Deseja filtrar apenas solicitações pendentes?","Atenção")
    cFiltro += ".and. C1_PEDIDO == ' ' "
    cFiltro += ".and. C1_RESIDUO == ' ' "
    cFiltro += ".and. C1_APROV $ 'B|L' "
    cFiltro += ".and. C1_QUJE == 0 "
    cFiltro += ".and. C1_COTACAO == ' ' "
EndIf


Return(cFiltro)
