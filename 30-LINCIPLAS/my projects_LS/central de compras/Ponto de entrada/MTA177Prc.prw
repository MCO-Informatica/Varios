#Include "Protheus.CH"

User Function MTA177Prc()

Local aArea		:= GetArea()		
Local aParam	:= PARAMIXB
Local nRet 		:= 0

If aParam[1][1] $ GetMv('LA_FILDIST') //.And. aParam[1][5] == "0003"
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+aParam[1][3]))
		nRet := SB1->B1_UPRC
	EndIf		
Else	
	DbSelectArea("DA1")
	DA1->(DbSetOrder(1))
	If DA1->(DbSeek(xFilial("DA1")+"01 "+aParam[1][3]))
		nRet := DA1->DA1_PRCVEN
	EndIf	
EndIf

RestArea(aArea)

Return( nRet )