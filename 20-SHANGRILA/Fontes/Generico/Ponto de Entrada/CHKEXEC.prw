#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"
#include "rwmake.ch"

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	14/02/2014
* Descricao		:	
* Retorno		: 	
*/
User Function CHKEXEC()

	SetKey(K_CTRL_F7,{|| U_ZCHGDATA() })

Return

User Function ZCHGDATA()
	Private oDlg
	Private _aArea    	:= GetArea()
	Private _dParam		:= dDataBase
	Private oBut1
	Private oBut2
	Private lRet := .F.
	Private oData

	_lSair      :=  .F.

	DEFINE MSDIALOG oDlg FROM 050,100 TO 160,430 TITLE OemToAnsi('Altera Data Base') PIXEL

	@ 005,002 TO 035,165 LABEL "Data"   OF oDlg PIXEL
	@ 015,005 MSGET oData VAR _dParam SIZE 060,010 Of oDlg PIXEL 

	@ 038,070 BUTTON oBut1 PROMPT ("&Ok")      SIZE 044,012 Of oDlg PIXEl Action (lRet := GravaData() , IIf(lRet,oDlg:End(),"") )
	@ 038,120 BUTTON oBut2 PROMPT ("&Cancela") SIZE 044,012 Of oDlg PIXEl Action (lRet := .F. , oDlg:End() )

	ACTIVATE MSDIALOG oDlg
	
Return	

Static Function GravaData()

	dDataBase := _dParam
	
	_lSair := .T.

	
Return _lSair
