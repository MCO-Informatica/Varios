#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

User Function M410FSQL()
Local cVend     := ""
Local _vpFiltro := ""

cVend := RetVend()

If !Empty(cVend)
 	_vpFiltro += "C5_VEND1 = '"+cVend+"' .OR. "
 	_vpFiltro += "C5_VEND2 = '"+cVend+"' .OR.  "
  	_vpFiltro += "C5_VEND3 = '"+cVend+"'  "
 
Endif

Return(_vpFiltro)


Static Function RetVend()
Local cVend :=""

dbselectarea("SA3")
dbsetorder(1)

SA3->(DBGotop())

Do While !SA3->(Eof())

	If __cUserID == SA3->A3_CODUSR
		cVend := SA3->A3_COD
	Endif

	SA3->(DBSkip())

EndDo
return cVend


