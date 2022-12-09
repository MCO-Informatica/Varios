#include "rwmake.ch"

User Function RCOMA01()

Private _aArea    	:= GetArea()
Private _cParam		:= Space(5)
Private _cAliqIcm	:= GETMV("MV_ALIQICM")

_lSair      :=  .F.

While .t.
		
	@ 025,005 To 600,705 Dialog janela1 Title OemToAnsi("Alíquotas de ICMS")
		
	@ 010,010 Say OemToAnsi("Alíquotas")
	@ 010,045 Get _cParam Picture "@!" When .t.  Size 50,10
		
	@ 235,260 BmpButton Type 1 Action GravaObs()
		
	Activate Dialog janela1
		
	If _lSair
		Exit
	EndIf
EndDo
	

Static Function GravaObs()


_cParam := Alltrim(_cAliqIcm)+"/"+Alltrim(_cParam)

PUTMV("MV_ALIQICM",_cParam)

_lSair      :=  .t.

Close(janela1)

Return()
