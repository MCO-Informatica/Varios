#Include "Protheus.ch"

/*
+=============================================================+
|Programa: MT140LOK |Autor: Antonio Carlos  |Data: 10/08/09   |
+=============================================================+
|Descrição: PE utilizado para validar o preenchimento do campo|
|Serie na rotina de Pré-Nota.                                 |
+=============================================================+
|Uso: Laselva                                                 |
+=============================================================+
*/

User Function MT140LOK()


Local aArea := GetArea()
Local _lRet	:= .T.
Local nPosCod  := "" 
Local nPosTes  := ""
Local cTipoEmp := "" 
Local nPosCf   := ""

if len(_acols) = 0
	_acols := aclone(acols)	
	_acols[1][2] := SC7->C7_PRODUTO
	_acols[1][23] := SC7->C7_ITEM
	_acols[1][9] := SC7->C7_QUANT
	_acols[1][10] := SC7->C7_PRECO
	_acols[1][11] := SC7->C7_TOTAL
	_acols[1][22] := SC7->C7_NUM	
Endif


If Empty(cSerie).and. cFormul == "N"
	MsgStop("Favor informar a serie!")
	_lRet := .F.
ElseIf Len(AllTrim(cNFiscal)) < 9
	M->cNFiscal := Strzero(Val(Alltrim(cNFiscal)), 9)
EndIf       

RestArea(aArea)

Return(_lRet)