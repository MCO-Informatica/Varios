#INCLUDE "protheus.ch"

User Function FC0103FAT()
Local cAliasTmp := ParamIxb[1]
Local cAliasQry := ParamIxb[2]

Reclock(cAliasTmp,.F.)
(cAliasTmp)->F2_REDESP  := (cAliasQry)->F2_REDESP
(cAliasTmp)->F2_X_NOMRD := (cAliasQry)->F2_X_NOMRD
(cAliasTmp)->(MsUnlock())

Return()