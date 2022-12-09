#include "protheus.ch"
#include "topconn.ch"

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNPE001()
//|Autor.....: Luiz ALberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação: Ponto de Entrada para tratamento das informações adicionais
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNPE001()
*-----------------------------------------------------------*

Local cAdic  := PARAMIXB[1]
Local cLote  := ''
Local dValid := ''
Local cOp    := ''
Local nC     := 0
Local aLinPE := {}

// Pega Lote
If At('Lote:',cAdic) > 0
	nPosLote := At('Lote:',cAdic)+Len('Lote:')
	For nC := nPosLote To Len(cAdic)
		cLote += SubStr(cAdic,nC,1)
		
		If SubStr(cAdic,nC,1)$' /'
			nC := Len(cAdic) + 10
		Endif
	Next
Endif

// Pega Validade
If At('dv:',cAdic) > 0
	nPosValid := At('dv:',cAdic)+Len('dv:')
	For nC := nPosValid To Len(cAdic)
		If SubStr(cAdic,nC,1)$'0123456789.'
			dValid += SubStr(cAdic,nC,1)
		Endif
		If SubStr(cAdic,nC,1)$' /'
			nC := Len(cAdic) + 10
		Endif
	Next
Endif
dValid := CtoD(dValid)

// Pega PO:	XML VERSÃO 1 EMBRAER
If At('po:',cAdic) > 0
	nPosLote := At('po:',cAdic)+Len('po:')
	For nC := nPosLote To Len(cAdic)
		If !SubStr(cAdic,nC,1)$'/'
			cOp += SubStr(cAdic,nC,1)
		Endif
		
		If SubStr(cAdic,nC,1)$' '
			nC := Len(cAdic) + 10
		Endif
	Next
Else
	// Pega PO:	XML VERSÃO 2 EMBRAER
	If At('302294',cAdic) > 0
		nPosPO := At('302294',cAdic)
		cOp := ''
		For nC := nPosPO To Len(cAdic)
			If !SubStr(cAdic,nC,1)$'/'
				cOp += SubStr(cAdic,nC,1)
			Endif
			
			If SubStr(cAdic,nC,1)$' '
				nC := Len(cAdic) + 10
			Endif
		Next
		cOp := ' '+cOp
	Endif
Endif

If !Empty(cLote)
	aadd(aLinPE,{"D1_LOTECTL",cLote,Nil,Nil})
EndIf

If !Empty(dValid)
	aadd(aLinPE,{"D1_DTVALID",dValid,Nil,Nil})
Else
	aadd(aLinPE,{"D1_DTVALID",CtoD(''),Nil,Nil})
EndIf

If !Empty(cOp) .And. SD1->(FieldPos("D1_XXEMPEN")) > 0
	aAdd(aLinPE,{"D1_XXEMPEN",SubStr(cOp,2),Nil,Nil})
EndIf

Return(aLinPE)