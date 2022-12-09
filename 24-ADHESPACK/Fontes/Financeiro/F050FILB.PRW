#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"  

//==================================================================================
// Programa.....: F050FILB
// Autor........: Lucas Baia
// Data.........: 27/06/2022
// Descricao....: Filtro do mBrowse do Contas a Pagar (FINA050)
// Uso..........: Verquimica
//==================================================================================

User Function F050FILB()

//============================================
// Variaveis da Rotina
//============================================
Local _cRet      := ""
Local _aGrupo    := UsrRetGrp(,RetCodUsr())
Local _cGrupo    := IIF(__cUserID$"000000","000000",IIF(Empty(_aGrupo), " ",_aGrupo[1]))
//============================================
// Expressao de filtro em SQL
//============================================

If Alltrim(_cGrupo)$"000001"
    _cRet := "E2_TIPO = 'PA '"
ENDIF

Return(_cRet)
