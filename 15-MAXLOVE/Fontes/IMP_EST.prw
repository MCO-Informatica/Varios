#INCLUDE "PROTHEUS.CH"

User Function IMP_EST()


processa({||RunProc()},"Saldo Inicial Zerado")
return

Static Function RunProc()

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
While !Eof() 
	
		
	IncProc("Processando o produto "+SB1->B1_COD+" - "+SB1->B1_DESC)
	
	//----> ALTERNATIVA
	dbSelectArea("SB9")
	dbSetOrder(1)
	If !dbSeek("0101"+SB1->B1_COD,.f.)
		RecLock("SB9",.t.)
	    SB9->B9_FILIAL	:=	"0101"
	    SB9->B9_COD		:=	SB1->B1_COD
	    SB9->B9_LOCAL	:=	SB1->B1_LOCPAD
	    SB9->B9_QINI	:=	0
	    SB9->B9_DATA	:=	CTOD("31/07/17")
	    MsUnLock()
    
    	dbSelectArea("SBJ")
		RecLock("SBJ",.t.)
	    SBJ->BJ_FILIAL	:=	"0101"
	    SBJ->BJ_COD		:=	SB1->B1_COD
	    SBJ->BJ_LOCAL	:=	SB1->B1_LOCPAD
	    SBJ->BJ_QINI	:=	0
	    SBJ->BJ_DATA	:=	CTOD("31/07/17")
	    SBJ->BJ_LOTECTL :=	"INVENTARIO"
	    SBJ->BJ_DTVALID :=	CTOD("31/07/17")
	    MsUnLock()
		    	
    EndIf
	
	//----> M.A. GIORGI
	dbSelectArea("SB9")
	dbSetOrder(1)
	If !dbSeek("0102"+SB1->B1_COD,.f.)
		RecLock("SB9",.t.)
	    SB9->B9_FILIAL	:=	"0102"
	    SB9->B9_COD		:=	SB1->B1_COD
	    SB9->B9_LOCAL	:=	SB1->B1_LOCPAD
	    SB9->B9_QINI	:=	0
	    SB9->B9_DATA	:=	CTOD("31/07/17")
	    MsUnLock()

    	dbSelectArea("SBJ")
		RecLock("SBJ",.t.)
	    SBJ->BJ_FILIAL	:=	"0102"
	    SBJ->BJ_COD		:=	SB1->B1_COD
	    SBJ->BJ_LOCAL	:=	SB1->B1_LOCPAD
	    SBJ->BJ_QINI	:=	0
	    SBJ->BJ_DATA	:=	CTOD("31/07/17")
	    SBJ->BJ_LOTECTL :=	"INVENTARIO"
	    SBJ->BJ_DTVALID :=	CTOD("31/07/17")
	    MsUnLock()

    EndIf

	//----> D.R. COSMETICOS
	dbSelectArea("SB9")
	dbSetOrder(1)
	If !dbSeek("0103"+SB1->B1_COD,.f.)
		RecLock("SB9",.t.)
	    SB9->B9_FILIAL	:=	"0103"
	    SB9->B9_COD		:=	SB1->B1_COD
	    SB9->B9_LOCAL	:=	SB1->B1_LOCPAD
	    SB9->B9_QINI	:=	0
	    SB9->B9_DATA	:=	CTOD("31/07/17")
	    MsUnLock()

    	dbSelectArea("SBJ")
		RecLock("SBJ",.t.)
	    SBJ->BJ_FILIAL	:=	"0103"
	    SBJ->BJ_COD		:=	SB1->B1_COD
	    SBJ->BJ_LOCAL	:=	SB1->B1_LOCPAD
	    SBJ->BJ_QINI	:=	0
	    SBJ->BJ_DATA	:=	CTOD("31/07/17")
	    SBJ->BJ_LOTECTL :=	"INVENTARIO"
	    SBJ->BJ_DTVALID :=	CTOD("31/07/17")
	    MsUnLock()

    EndIf

	//----> LUCK
	dbSelectArea("SB9")
	dbSetOrder(1)
	If !dbSeek("0104"+SB1->B1_COD,.f.)
		RecLock("SB9",.t.)
	    SB9->B9_FILIAL	:=	"0104"
	    SB9->B9_COD		:=	SB1->B1_COD
	    SB9->B9_LOCAL	:=	SB1->B1_LOCPAD
	    SB9->B9_QINI	:=	0
	    SB9->B9_DATA	:=	CTOD("31/07/17")
	    MsUnLock()

    	dbSelectArea("SBJ")
		RecLock("SBJ",.t.)
	    SBJ->BJ_FILIAL	:=	"0104ADMIN	"
	    SBJ->BJ_COD		:=	SB1->B1_COD
	    SBJ->BJ_LOCAL	:=	SB1->B1_LOCPAD
	    SBJ->BJ_QINI	:=	0
	    SBJ->BJ_DATA	:=	CTOD("31/07/17")
	    SBJ->BJ_LOTECTL :=	"INVENTARIO"
	    SBJ->BJ_DTVALID :=	CTOD("31/07/17")
	    MsUnLock()

    EndIf

	
	dbSelectArea("SB1")
	dbSkip()
EndDo


Return
