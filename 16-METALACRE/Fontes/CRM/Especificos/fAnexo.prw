#include 'protheus.ch'
#include 'parmtype.ch'

user function fAnexo()
Local aArea := GetArea()
Local lRet  := .F.

If AC9->(dbSetOrder(2),dbSeek(xFilial("AC9")+'AD101'+AD1->AD1_NROPOR))
	lRet := .T.
Endif

RestArea(aArea)
return lRet