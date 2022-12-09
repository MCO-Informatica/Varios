#include "totvs.ch"

User Function LOCXFILT()

If Upper(AllTrim(FunName())) == "MATA467N" .And. Type("aRotina") == "A"
	aAdd(aRotina, {"Imprimir Invoice", "U_UYFATL01", 0, 2, 0, NIL})   
	aAdd(aRotina, {"Impr Invoice New", "U_UYFATL03", 0, 2, 0, NIL})
	aAdd(aRotina, {"Imprimir Factura", "U_UYFATL02", 0, 2, 0, NIL})
elseif Upper(AllTrim(FunName())) == "MATA465N" .And. Type("aRotina") == "A"
	aAdd(aRotina, {"Imprimir Nota de Credito", "U_UYFATL04", 0, 2, 0, NIL})
EndIf

Return()
