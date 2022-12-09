#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

Static aIndSZ6
Static lCopia

User Function SHGEN003()
Local lRet := .F.
Local nValor := 0
  
SM4->(DbSetOrder(1))
SZD->(DbSetOrder(1))
SM4->(DbGotop())
While !SM4->(Eof())
	SZD->(DbGotop()) 
	SZD->(DbSetOrder(1)) 
	nValor := SHGETVLR(SM4->M4_CODIGO)
	If Substr(SM4->M4_CODIGO,1,2) == 'PV'
		While !SZD->(Eof())
			If Reclock('SZD',.F.)
				FieldPut(FieldPos(Alltrim(SM4->M4_DESCR)),nValor)
				MsUnlock()
			EndIf
			SZD->(DbSkip())
		EndDo
	EndIf
	SM4->(DbSkip())
EndDo

Return

Static Function SHGETVLR(cFormula)
Local nValor := 0
Local aArea := GetArea()

nValor := Formula(cFormula)

RestArea(aArea)

Return nValor
