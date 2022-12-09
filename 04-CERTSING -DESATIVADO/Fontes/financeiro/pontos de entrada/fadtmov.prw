#Include 'Protheus.ch'

User Function fadtmov()
Local lRetPE	:= .T.
Local dData		:= paramixb[1]

If IsInCallStack('U_CODAUTCC') .OR. IsInCallStack('U_CFSA510G') .OR. IsInCallStack("U_FCOMPSUB") .OR. IsInCallStack("U_FATPLTGRT") 
	lRetPE	:=.T.
Else
	If dData < GetMv("MV_DATAFIN")
		lRetPE	:=.F.
	EndIf
Endif

Return(lRetPE)