#Include 'Protheus.ch'

User Function PCOA3103()
	Local cProcesso := PARAMIXB[1]
	Local cItem	    := PARAMIXB[2]
	Local aRet      := PARAMIXB[3]
	Local cAlias    := PARAMIXB[4]
	Local cQuery    := PARAMIXB[5]

	AKC->(DbSetOrder(1))
	If AKC->(DbSeek(xFilial('AKC') + cProcesso + cItem))
		If Alltrim(cProcesso) == '000085'
			cQuery += " AND RD_DATARQ = '" + AnoMes( MV_PAR02 ) + "'"
		Else
			cQuery += " AND " + Alltrim(Replace(AKC->AKC_DATA,'->','.')) + " BETWEEN '" + Dtos(MV_PAR02) + "' AND '" + Dtos(MV_PAR03) + "'"
		EndIf
	EndIf
	
Return cQuery

