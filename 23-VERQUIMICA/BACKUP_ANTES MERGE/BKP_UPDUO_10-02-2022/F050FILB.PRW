#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"  

//==================================================================================
// Programa.....: F050FILB
// Autor........: Anderson Goncalves
// Data.........: 23/03/21
// Descricao....: Filtro do mBrowse do funções de contas a pagar
// Uso..........: Verquimica
//==================================================================================

User Function F050FILB()

//============================================
// Variaveis da Rotina
//============================================
Local cRet      := ""

//============================================
// Expressao de filtro em SQL
//============================================
cRet := "E2_PREFIXO <> 'EIC'"

Return(cRet)

