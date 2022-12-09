#include "protheus.ch"

User Function M460FIL()  
_cFil := ""              
//----> CONSIDERA PARAMETROS ABAIXO? (SIM/NAO)
If MV_PAR03 == 1 // SIM	
	//----> TRANSPORTADORA E TIPO DE FRETE
	If (!Empty(MV_PAR20) .AND. MV_PAR19 <> 1)
		_cFil += " SC9->C9_VQ_TRAN = '"+MV_PAR20+"' .AND. "
	ElseIf (!Empty(MV_PAR20))                      
		_cFil += " SC9->C9_VQ_TRAN = '"+MV_PAR20+"'
	ElseIf (Empty(MV_PAR20) .AND. MV_PAR19 <> 1)
		_cFil += " SC9->C9_VQ_TRAN <= 'ZZZZZZ' .AND. "
	Else
		_cFil += " SC9->C9_VQ_TRAN <= 'ZZZZZZ' "
	EndIf
	    
	If MV_PAR19 == 2
		_cFil += "SC9->C9_VQ_FVER = 'N' "
	ElseIf MV_PAR19 == 3
		_cFil += "(SC9->C9_VQ_FVER = 'R' .OR. SC9->C9_VQ_FCLI = 'R') "
	ElseIf MV_PAR19 == 4
		_cFil += "(SC9->C9_VQ_FVER = 'D' .OR. SC9->C9_VQ_FCLI = 'D') "
	EndIf
Else
	_cFil += " SC9->C9_VQ_TRAN <= 'ZZZZZZ' "
EndIf

Return(_cFil)
