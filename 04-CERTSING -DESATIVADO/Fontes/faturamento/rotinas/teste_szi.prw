#INCLUDE "PROTHEUS.CH"

User Function testeszi()

Local cAtivCbo := "1"
Local var01 := "3126667"                                      
Local var02 := "SINSRFA3PFSL1AHV2"
Local Tempini
Local Tempfim

DbSelectArea("U00")                       
             
Tempini := TIME()
SZI->( DbSetOrder(3) ) //SZI_FILIAL + SZI_PROGAR
SZI->( DbGoTop() )
If 	cAtivCbo == "1"
 	conout("Linha-1483 - PEDIDO GAR "+var01+" Prod - "+var02)
 	If SZI->( DbSeek( xFilial("SZI") + var02 ))
	 	conout("Linha-1485 - PEDIDO GAR "+var01+" - Prod - "+var02 + " - regra - " +SZI->ZI_FILIAL+alltrim(SZI->ZI_PROGAR) + " - fim.")
		While (SZI->ZI_FILIAL+alltrim(SZI->ZI_PROGAR) == xFilial("SZI") + var02) .AND. SZI->(!Eof())
		Sleep(30000) //30 segundos
		SZI->(DbSkip())
		EndDo
	EndIf
EndIf
                 
Tempfim := TIME()                    
TempTot := ELAPTIME(Tempini,Tempfim)
conout("Tempo total de processamento: "+TempTot)
DbCloseArea("SZI")                                                                 

Return

	