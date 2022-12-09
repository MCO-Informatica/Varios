#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
+=========================================================+
|Programa: LSMIDDIV |Autor: Antonio Carlos |Data: 17/03/11|
+=========================================================+
|Descrição: Rotinas diversas referente ao projeto Midia.  |
+=========================================================+
|Uso: Especifico Laselva                                  |
+=========================================================+
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSMIDD01()
////////////////////////
Local _dDtTerm := ctod('')
Local _nI, _dDtTerm

_dDtTerm := MonthSum(date(),M->PAC_PRAZO)
For _nI := 1 to len(aCols)                  
	If empty(GdFieldGet('PAD_DTTERM',_nI))
		GdFieldPut('PAD_DTTERM',_dDtTerm,_nI)
	EndIf
Next

GetDRefresh()

Return(_dDtTerm)
