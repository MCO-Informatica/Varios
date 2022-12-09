#include "rwmake.ch" 
#include "protheus.ch"

User Function RFATM02()

Local _nPerComis := 0

DbSelectArea("SA1")
DbSetorder(1)
DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,.f.)

DbSelectArea("SA3")
DbSetOrder(1)
DbSeek(xFilial("SA3")+M->C5_VEND1,.F.)

If Alltrim(SA3->A3_TIPO) == "E" .And. M->C5_X_PRIOR$"N"

	If !Empty(M->C5_VEND2)
		_nPerComis	:=	(SA3->A3_COMIS - 1)
	Else
		_nPerComis	:=	SA3->A3_COMIS
	EndIf

ElseIf Alltrim(SA3->A3_TIPO) == "E" .And. M->C5_X_PRIOR$"S"

	If !Empty(M->C5_VEND2)
		_nPerComis	:=	((SA3->A3_COMIS + 3) - 1)
	Else
		_nPerComis	:=	(SA3->A3_COMIS + 3)
	EndIf

ElseIf Alltrim(SA3->A3_TIPO) <> "E" .And. M->C5_X_PRIOR$"N"

	If !Empty(M->C5_VEND2)
		_nPerComis	:=	(SA3->A3_COMIS - 0.5)
	Else
		_nPerComis	:=	SA3->A3_COMIS
	EndIf

ElseIf Alltrim(SA3->A3_TIPO) <> "E" .And. M->C5_X_PRIOR$"S"

	If !Empty(M->C5_VEND2)
		_nPerComis	:=	((SA3->A3_COMIS + 0.5) - 0.5)
	Else
		_nPerComis	:=	(SA3->A3_COMIS + 0.5)
	EndIf
	
Else
•
	_nPerComis := 0
        
EndIf


Return(_nPerComis)
