#Include "TOTVS.CH"

User Function SF1100I()

	Local aArea:=GetArea()

	If SF1->(FieldPos("F1_XUSER"))>0
		RecLock("SF1",.F.)
		SF1->F1_XUSER := UsrRetName(RetCodUsr())
		SF1->(msUnlock())
	EndIf

	If SF1->(FieldPos("F1_XDATA"))>0
		RecLock("SF1",.F.)
		SF1->F1_XDATA := Date()
		SF1->F1_DTDIGIT := SF1->F1_EMISSAO
		SF1->(msUnlock())
	EndIf

	RestArea(aArea)

Return Nil
