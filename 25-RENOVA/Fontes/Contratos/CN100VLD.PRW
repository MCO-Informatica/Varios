#INCLUDE "PROTHEUS.CH"
/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CN100VLD  ³ Autor ³ Pedro Augusto       ³ Data ³  05/10/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida inclusao de contrato                                 ³±±
±±                                                                         ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CN100VLD()        
	Local aCN9 := GetArea("CN9") 
	Local aCN1 := GetArea("CN1") 
	Local lRet := .T.                    
	
	
	CN1->(dbSetOrder(1))
	CN1->(DbSeek(xfilial("CN1") + M->CN9_TPCTO))
	
	If !CN1->(Eof())
		If CN1->CN1_MEDAUT == "1" .and. Alltrim(M->CN9_XCODUS) == ""
			Alert("Contrato com medicao automatica, preencha o campo Usr.Med.Auto")
			lRet := .F.
	    EndIf
	EndIf                        

	RestArea(aCN1)
	RestArea(aCN9)
	Return (lRet)                                     
	