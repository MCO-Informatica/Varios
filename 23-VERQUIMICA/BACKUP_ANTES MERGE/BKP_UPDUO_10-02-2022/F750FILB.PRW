#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"  

//==================================================================================
// Programa.....: F750FILB
// Autor........: Anderson Goncalves
// Data.........: 23/03/21
// Descricao....: Filtro do mBrowse do funções de contas a pagar
// Uso..........: Verquimica
//==================================================================================

User Function F750FILB()

//============================================
// Variaveis da Rotina
//============================================
Local cRet      := ""

//============================================
// Expressao de filtro em SQL
//============================================
cRet := "E2_FILIAL = '"+FWxFilial("SE2")+"' "
cRet += "AND E2_PREFIXO <> 'EIC' " 
cRet += "AND D_E_L_E_T_ = ' ' "

Return(cRet)

