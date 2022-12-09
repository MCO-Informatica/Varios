#include "protheus.ch"

user function CRIASXE()
	Local cNum := NIL
	Local aArea := getarea()
	Local aArea2 := {}
	Local cAlias    := paramixb[1]
	Local cCpoSx8   := paramixb[2]
	Local cAliasSx8 := paramixb[3]
	Local nOrdSX8   := paramixb[4]
	Local cChaveBusca   := ""

	 
	if cAlias  == 'SB1' .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )
		cChaveBusca := 'MANUTENCAO'
    ElseIf cAlias  == 'SA2' .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )
		cChaveBusca := 'ESTADO'
    ElseIf cAlias  == 'SN1' .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )
		cChaveBusca := 'NFS0000153'
	EndIf

	If !Empty(cChaveBusca)
		dbselectarea(cAlias)
		aArea2 := getarea()
		dbsetorder(nOrdSX8)
		dbseek(xfilial()+cChaveBusca)
		dbskip(-1)
		cNum := &(cCpoSx8)
		cnum := soma1(cNum)
		restarea(aArea2)
		restarea(aArea)
	EndIF
return cNum
