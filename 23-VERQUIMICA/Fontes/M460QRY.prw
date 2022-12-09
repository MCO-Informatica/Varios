#include "protheus.ch"

User Function M460QRY()
Local cQuery := paramixb[1]

//----> CONSIDERA PARAMETROS ABAIXO? (SIM/NAO)
If MV_PAR03 == 1 // SIM	
	//----> TRANSPORTADORA E TIPO DE FRETE
	If (!Empty(MV_PAR20) .AND. MV_PAR19 <> 1)
		cQuery += " AND SC9.C9_VQ_TRAN = '"+MV_PAR20+"' "
	ElseIf (!Empty(MV_PAR20))                      
		cQuery += " AND SC9.C9_VQ_TRAN = '"+MV_PAR20+"' "
	ElseIf (Empty(MV_PAR20) .AND. MV_PAR19 <> 1)
		cQuery += " AND SC9.C9_VQ_TRAN <= 'ZZZZZZ' "
	Else
		cQuery += " AND SC9.C9_VQ_TRAN <= 'ZZZZZZ' "
	EndIf
	    
	If MV_PAR19 == 2
		cQuery += "AND SC9.C9_VQ_FVER = 'N' "
	ElseIf MV_PAR19 == 3
		cQuery += "AND (SC9.C9_VQ_FVER = 'R' OR C9_VQ_FCLI = 'R') "
	ElseIf MV_PAR19 == 4
		cQuery += "AND (SC9.C9_VQ_FVER = 'D' OR C9_VQ_FCLI = 'D') "
	EndIf
Else
	cQuery += " AND SC9.C9_VQ_TRAN <= 'ZZZZZZ' "
EndIf

//MSGINFO(CQUERY)

Return(cQuery)
