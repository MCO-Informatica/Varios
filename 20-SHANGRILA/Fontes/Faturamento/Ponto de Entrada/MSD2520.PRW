#INCLUDE "protheus.ch"

User function MSD2520()
Local aArea := GetArea()

//----> GRAVA REGISTRO C111 SPED (PROCESSO JUDICIAL)
If SD2->D2_TIPO$"NICP" .AND. Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_DUPLIC")$"S"
	If SD2->D2_SERIE $ "0" .AND. SD2->D2_VALICM > 0
	
		dbSelectArea("CDG")
		CDG->(dbSetOrder(3))
		If dbSeek(xFilial("CDG")+"S"+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM,.F.)
		
            While !CDG->(Eof()) .And. CDG->CDG_FILIAL+CDG->CDG_TPMOV+CDG->CDG_DOC+CDG->CDG_SERIE+CDG->CDG_CLIFOR+CDG->CDG_LOJA+CDG->CDG_ITEM = xFilial("CDG")+"S"+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM
                RecLock("CDG",.F.)
                DbDelete()
                CDG->(MsUnLock())
                CDG->(dbSkip())
            EndDo    
        
            dbSelectArea("SD2")

        EndIf
	EndIf
EndIf

Return


cCondP := M->C5_CONDPAG
