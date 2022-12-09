#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

User Function MT120FOL()

	Local	aArea		:= GetArea()
	Local   nOpc    	:= PARAMIXB[1]  /* 3 - inclusao , 4 = alteracao , 6 - copia*/
	Local  	aPosGet		:= PARAMIXB[2]
	Local	aComboHCI	:= TipoEmbarqueHCI()
	Local	oGet1	
	
	/*STATIC*/PUBLIC	__cNumPO	/*:=	SPACE(50)*/
	/*STATIC*/PUBLIC 	__cNumCOT	/*:=	SPACE(30)*/
	/*STATIC*/PUBLIC	__cTPEmba	/*:=	SPACE(01)*/
	/*STATIC*/PUBLIC	__cTPFreteHCI/*:=	SPACE(01)*/   
	
	__cNumPO := IIF(nOpc == 3, CriaVar("C7_XNUMPO",.F.),SC7->C7_XNUMPO)
	__cNumCOT:=	IIF(nOPC == 3, CriaVar("C7_XNUMCOT",.F.),SC7->C7_XNUMCOT)
	__cTPEmba:= IIF(nOpc == 3, CriaVar("C7_XTPEMBA",.F.),SC7->C7_XTPEMBA)
	__cTPFreteHCI:= IIF(nOpc == 3, CriaVar("C7_XTPFRET",.F.),SC7->C7_XTPFRET)
	
	IF nOpc <> 1
		@ 006,aPosGet[1,1] SAY OemToAnsi("Numero da P.O.") OF oFolder:aDialogs[7] PIXEL SIZE 070,009
		@ 005,aPosGet[1,2] MSGET __cNumPO /*Var __cNumPO*/ PICTURE PesqPict('SC7','C7_XNUMPO') OF oFolder:aDialogs[7] PIXEL SIZE /*100*/160,009 /*HASBUTTON WHEN .F.*/
		@ 019,aPosGet[1,1] SAY OemToAnsi("Numero da Cotacao") OF oFolder:aDialogs[7] PIXEL SIZE 070,009
		@ 018,aPosGet[1,2] MSGET __cNumCOT /*VAr __cNumCOT*/ PICTURE PesqPict('SC7','C7_XNUMCOT') OF oFolder:aDialogs[7] PIXEL SIZE /*100*/150,009 /*HASBUTTON WHEN .F.*/
		@ 031,aPosGet[1,1] SAY OemToAnsi("Tipo de Embarque") OF oFolder:aDialogs[7] PIXEL SIZE 070,009
		@ 032,aPosGet[1,2]	MSCOMBOBOX oGet1 Var __cTPEmba ITEMS aComboHCI OF oFolder:aDialogs[7] PIXEL SIZE /*100*/050,009 /*HASBUTTON WHEN .F.*/
		@ 043,aPosGet[1,1] SAY OemtoAnsi("Tipo de Frete HCI") OF oFolder:aDialogs[7] PIXEL SIZE 070,009
		@ 042,aPosGet[1,2] MSGET __cTPFreteHCI PICTURE PesqPict('SC7','C7_XTPFRET') F3 CpoRetF3('C7_XTPFRET','A99') OF oFolder:aDialogs[7] PIXEL SIZE 150,009	         
	EndIF
	
	RestArea( aArea )

Return Nil                                                                 

STATIC Function TipoEmbarqueHCI()

	STATIC __aEmbarqueHCI	:=	{}  

	__aEmbarqueHCI  := {" ","A=By Air","S=By Sea"}

Return __aEmbarqueHCI