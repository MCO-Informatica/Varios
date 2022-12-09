#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "SET.CH"              

//PONTO DE ENTRADA PARA GRAVAÇÃO DE DADOS NA CLASSIFICAÇÃO DA NF DE ENTRADA ( BOTÃO CLASSIFICAR )
// LUIZ ALBERTO OLIVEIRA  -  TOTVS 14-01-2014

User Function MT100CLA() 

	dbselectarea("SD1")
	dbsetorder(1)
	dbgotop()
	dbseek(xFilial("SF1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)

	If("SV" $ Upper(SD1->D1_COD) )  
		while !EOF() .and. SD1->D1_DOC = SF1->F1_DOC .and. SD1->D1_SERIE = SF1->F1_SERIE .and. SD1->D1_FORNECE = SF1->F1_FORNECE
			RecLock("SD1",.F.)
			SD1->(&("D1_X_ATUTQ")) := "N"
			SD1->(&("D1_X_VIA")) := "01"
			SD1->(MSUnLock())  
			dbskip()
		end
	Endif        

	SD1->(DBCLOSEAREA())
Return .T.