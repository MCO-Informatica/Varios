#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: fGVendedor | Autor: Celso Ferrone Martins | Data: 29/09/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Gatilho para trazer o codigo e nome do vendedor            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function fGVendedor(cCpoRet)

Local cRet      := ""
Local aAreaSu7  := SU7->(GetArea())
Local aAreaSA3  := SA3->(GetArea())
Default cCpoRet := "UA_VEND"

DbSelectArea("SU7") ; DbSetOrder(4)
DbSelectArea("SA3") ; DbSetOrder(1)
If SU7->(DbSeek(xFilial("SU7") + __cUserId))
	If SA3->(DbSeek(xFilial("SA3")+SU7->U7_CODVEN))
		If cCpoRet == "UA_VEND"
			cRet := SA3->A3_COD
		ElseIf cCpoRet == "UA_DESCVEN"
			cRet := SA3->A3_NOME
		EndIf
	EndIf
EndIf

SA3->(RestArea(aAreaSa3))
SU7->(RestArea(aAreaSu7))

Return(cRet)