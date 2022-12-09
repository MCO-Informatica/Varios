#include 'protheus.ch'
#include 'parmtype.ch'

user function CSAGMATF()

Local cMatricula := ""
Local cQryPAX := ""
Local nMatricula := 0

If Select("_PAX") > 0
	DbSelectArea("_PAX")
	DbCloseArea("_PAX")
End If 
	
cQRYPAX := " SELECT MAX(PAX_MAT) PAX_MAT"
cQRYPAX += " FROM "+ RETSQLNAME("PAX")
cQRYPAX += " WHERE D_E_L_E_T_ = '' "
cQRYPAX += " AND PAX_FILIAL = '" + xFilial("PAX") + "' "
cQRYPAX += " AND PAX_TERCEI = '2' "

cQRYPAX := changequery(cQRYPAX)
				   
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQRYPAX),"_PAX",.F.,.T.)

cMatricula := _PAX->PAX_MAT

If !Empty(cMatricula)

	cMatricula := SubStr(cMatricula,4,3)
	nMatricula := Val(cMatricula)
	nMatricula := nMatricula + 1
	cMatricula := "TER"+STRZERO(nMatricula, 3)

Else

	cMatricula := "TER001"

End If

return cMatricula