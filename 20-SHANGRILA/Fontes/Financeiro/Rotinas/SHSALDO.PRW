#include "PROTHEUS.CH"

User Function SHSALDO()

Local _cRet
Local _aArea  	:= GetArea()
Local _cTitulo	:= SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
Local _nAbat	:= 0

dbSelectArea("SE1")
_aAreaSE1 	:= GetArea()
_nRecSE1	:= Recno()
dbSetOrder(1)

If dbSeek(_cTitulo,.f.)

	While Eof() == .f. .and. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA == _cTitulo
	
		If Alltrim(SE1->E1_TIPO)$"AB-"
		
			_nAbat	+= SE1->E1_VALOR
		
		EndIf
		
		dbSkip()
	EndDo
	
EndIf

RestArea(_aAreaSE1)
dbSelectArea("SE1")
dbGoTo(_nRecSE1)

_cRet	:= 	StrZero((SE1->E1_SALDO - _nAbat)*100,13)
_nAbat	:=	0

Return(_cRet)