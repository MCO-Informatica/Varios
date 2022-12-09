#include "rwmake.ch"

User Function RFINA01()

Private _aArea    	:= GetArea()
Private _dParam		:= GETMV("MV_DATAFIN")

_lSair      :=  .F.

While .t.
		
	@ 025,005 To 600,705 Dialog janela1 Title OemToAnsi("Data Fechamento Financeiro")
		
	@ 010,010 Say OemToAnsi("Data")
	@ 010,045 Get _dParam Picture "@!" When .t.
		
	@ 235,260 BmpButton Type 1 Action GravaObs()
		
	Activate Dialog janela1
		
	If _lSair
		Exit
	EndIf
EndDo
	

Static Function GravaObs()


PUTMV("MV_DATAFIN",_dParam)

_lSair := .T.

Close(janela1)

Return()
