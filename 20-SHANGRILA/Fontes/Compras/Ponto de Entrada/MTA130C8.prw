#INCLUDE "totvs.ch"

/*
* PE			:	MTA130C8
* Autor			:	João Zabotto
* Data			:	15/06/2015
* Descricao		:	PE chamada rotina para preenchimento campos personalizados
*/

User Function MTA130C8()
Local   aAlias      :=  GetArea()
Local   aAliasSC8   :=  SC8->(GetArea())

If RecLock('SC8',.F.)
	SC8->C8_ZZCC    := SC1->C1_CC
	SC8->C8_ZZCCDES := POSICIONE('CTT',1,xFilial('CTT') + SC1->C1_CC,'CTT_DESC01')
	MsUnLock()
EndIf

RestArea(aAliasSC8)
RestArea(aAlias)

Return
