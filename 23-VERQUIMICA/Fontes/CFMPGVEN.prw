#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CFMPGVEN  | Autor: Celso Ferrone Martins  | Data: 24/07/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Retorno do codigo do vendedor                              |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CFMPGVEN()

Local cRet := ""
Local cAreaSu7 := SU7->(GetArea())
Local cUsrLib  := ""

AjustaSx6()

cUsrLib := AllTrim(Upper(GetMv("VQ_RELVEN")))

If ! AllTrim(Upper(cUserName)) $ cUsrLib
	DbSelectArea("SU7") ; DbSetOrder(4)
	If SU7->(DbSeek(xFilial("SU7") + __cUserId))
		cRet := SU7->U7_CODVEN
	EndIf
	SU7->(RestArea(cAreaSu7))
EndIf


Return(cRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: AjustaSx6 | Autor: Celso Ferrone Martins  | Data: 24/07/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Ajuste de Parametros SX6                                   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function AjustaSx6()

Local cX6Var    := ""
Local cX6Desc1  := ""
Local cX6Desc2  := ""
Local cX6Desc3  := ""
Local cX6Tipo   := ""
Local cConteud  := ""

cX6Var   := "VQ_RELVEN"
cX6Desc1 := "Usuarios sem trava nos relatorios de vendedores   "
cX6Desc2 := "                                                  "
cX6Desc3 := "CFMPGVEN.PRW                                      "
cX6Tipo  := "C"
cConteud := "ADMINISTRADOR/VERA/ANILTON"

DbSelectArea("SX6") ; DbSetOrder(1)

If !SX6->(DbSeek(Space(2) + cX6Var))
	If !SX6->(DbSeek(cFilAnt + cX6Var))
		RecLock("SX6",.T.)
		SX6->X6_FIL     := cFilAnt
		SX6->X6_VAR     := cX6Var
		SX6->X6_TIPO    := cX6Tipo
		SX6->X6_DESCRIC := cX6Desc1
		SX6->X6_DSCSPA  := cX6Desc1
		SX6->X6_DSCENG  := cX6Desc1
		SX6->X6_DESC1   := cX6Desc2
		SX6->X6_DSCSPA1 := cX6Desc2
		SX6->X6_DSCENG1 := cX6Desc2
		SX6->X6_DESC2   := cX6Desc3
		SX6->X6_DSCSPA2 := cX6Desc3
		SX6->X6_DSCENG2 := cX6Desc3
		SX6->X6_CONTEUD := cConteud
		SX6->X6_PROPRI  := "U"
		SX6->X6_PYME    := "N"
		MsUnlock()
	EndIf
EndIf

Return()
