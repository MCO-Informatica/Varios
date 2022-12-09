#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	FATG005
// Autor 		Alexandre Dalpiaz
// Data 		03/06/11
// Descricao  	GATILHO NO CAMPO C5_TES - REPLICA O TES NOS ITENS DO PEDIDO DE VENDAS.
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FatG005()
///////////////////////
Local _nI
Local CEST:=''
If !empty(M->C5_TES)
	SF4->(DbSeek(xFilial('SF4') + M->C5_TES,.f.))
	

	For _nI := 1 to len(aCols)
//		If !U_LS_C6QTD(100,GdFieldGet('C6_PRODUTO',_nI), M->C5_TES, GdFieldGet('C6_ITEM',_nI), GdFieldGet('C6_QTDVEN',_nI),0,GdFieldGet('C6_LOCAL',_nI))
//			Exit
//		EndIf
		GdFieldPut('C6_TES', M->C5_TES, _nI)
		GdFieldPut('C6_CLASFIS', left(GdFieldGet('C6_CLASFIS',_nI),1) + SF4->F4_SITTRIB, _nI)  
		CEST:=iif(M->C5_TIPO $ 'N/C/I/P',SA1->A1_EST,SA2->A2_EST) 
		
		
		IF CEST=='EX'
		GdFieldPut('C6_CF' , '7' + SUBSTR(SF4->F4_CF,2,3), _nI)		
		ELSE
		
		If SM0->M0_ESTENT == CEST
			GdFieldPut('C6_CF' , '5' + SUBSTR(SF4->F4_CF,2,3), _nI)
		Else
			GdFieldPut('C6_CF' , '6' + SUBSTR(SF4->F4_CF,2,3), _nI)
		EndIf
		ENDIF
	Next
EndIf

GetDRefresh()
Return(M->C5_TES)

/*
User Function FATG005

Local _nDesc := 0

For _nI := 1 to len(aCols)
	If !GdDeleted(_nI)    // verifica se a linha atual esta apagada (linha apagada parametro = .T.)
		_nDesc 	  := GdFieldGet('C6_DESCONT',_nI)
		Exit
	EndIf
Next

For _nJ := _nI+1 to len(aCols)
	If !GdDeleted(_nJ)
		GdFieldPut('C6_DESCONT',_nDesc,_nJ)
	EndIf
Next

GetDRefresh()

Return(_nDesc)
*/