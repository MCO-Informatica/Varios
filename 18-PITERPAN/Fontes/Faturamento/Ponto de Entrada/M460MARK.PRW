#include "protheus.ch"
#include "topconn.ch"

User Function M460MARK()

Local _lRet 	:= .T.
Local _cQuery	:= ""
Local _cAlias 	:= CriaTrab(Nil,.F.)

If Alltrim(FunName()) $"MATA460A"

	cQuery := "SELECT DISTINCT "
	cQuery += " C9_PEDIDO, C9_X_PRIOR "
	cQuery += " FROM "
	cQuery += " SC9010 "
	cQuery += " WHERE "
	cQuery += " C9_FILIAL = '01' "
	cQuery += " AND D_E_L_E_T_ = '' "
	cQuery += " AND C9_NFISCAL = '' "
	cQuery += " AND C9_SERIENF = '' "
	If MV_PAR19 == 1
		cQuery += " AND C9_X_PRIOR = 'S' "
	Else
		cQuery += " AND C9_X_PRIOR = 'N' "
	EndIf	
	cQuery += " AND C9_OK = '"+PARAMIXB[1]+"' "
	
	TCQuery cQuery NEW ALIAS (_cAlias)
	
	(_cAlias)->(dbGoTop())
	
	While !(_cAlias)->(Eof())
		
		(_cAlias)->(dbSkip())
	
	EndDo
	
EndIf

(_cAlias)->(dbCloseArea())

Return(_lRet)