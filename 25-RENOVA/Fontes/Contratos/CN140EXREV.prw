#Include "Rwmake.ch"
#Include "Protheus.ch"
/*
================================================================
Programa.: 	CN140EXGREV  
Autor....:	Pedro Augusto
Data.....: 	16/05/2015 º±±
Descricao: 	PE para exclusão de alçada da Revisão Gerada via
            CN140GREV
Uso......: 	RENOVA
================================================================
*/                                                        
User Function CN140EXREV()
	Local aArea     := GetArea()
	Local cContra	:= Paramixb[1]
	Local cNRevisa	:= Paramixb[3]
	Local cCodTR	:= Paramixb[4] 
	
	DbSelectArea("SCR")
	SCR->(DbGoTop()) 
	SCR->(DbSetOrder(1))  &&CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
	If SCR->(DbSeek(xFilial("SCR")+"CT"+cContra+cNRevisa))
		Do While SCR->(!EoF()) .And. SCR->(CR_FILIAL+CR_TIPO+AllTrim(CR_NUM)) == xFilial("SCR")+"CT"+cContra+cNRevisa
			RecLock("SCR", .F.)
				SCR->(DbDelete())
			MsUnlock()
			SCR->(DbSkip())
		EndDo
	EndIf               
	
	RestArea(aArea)	
Return