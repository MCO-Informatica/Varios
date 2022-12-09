#Include "Protheus.ch"

User Function MT010ALT()

	If SB1->B1_CICLOPC > 0 .AND. SB1->B1_CAVIDAD > 0
		RecLock("SB1",.F.)
		SB1->B1_PRODUCH := ROUND((3.6/SB1->B1_CICLOPC)*SB1->B1_CAVIDAD,6)
		SB1->(MsUnLock())
	EndIf

Return Nil
