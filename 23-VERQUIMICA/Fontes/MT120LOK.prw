#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: MT120LOK  | Autor: Celso Ferrone Martins  | Data: 01/07/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function MT120LOK()

Local lRet := .T.

IF nModulo <> 17 // 17 - SIGAEIC

	lRet := U_CFMSC7CC()

ENDIF

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CFMSC7CC  | Autor: Celso Ferrone Martins  | Data: 01/07/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CFMSC7CC()

Local lRet := .T.
Local nPosCc := aScan(aHeader,{|x| Alltrim(x[2])=="C7_CC"}) // Centro de Custo

If Empty(cA120Cc)
	If !Empty(aCols[1][nPosCc])
		cA120Cc := aCols[1][nPosCc]
	EndIf
EndIf

If ValType(lRet) <> "L"
	lRet := .T.
EndIf

oA120Cc:Refresh()

Return(lRet)
