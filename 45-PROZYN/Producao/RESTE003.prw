#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RESTE003 ³ Autor ³ Adriano Leonardo    ³ Data ³ 24/01/2017 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para definição das observações do lote.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RESTE003()

Local _cRotina		:= "RESTE003"
Local _aSavArea		:= GetArea()
Local _aSavSB8		:= SB8->(GetArea())
Local _aSavSZQ		:= SZQ->(GetArea())
Local _aSavSD5		:= SD5->(GetArea())
Local _nCont		:= 1
Private _cProduto 	:= SD5->D5_PRODUTO
Private _cLote		:= SD5->D5_LOTECTL

Observacao()

RestArea(_aSavSB8)
RestArea(_aSavSZQ)
RestArea(_aSavSD5)
RestArea(_aSavArea)

Return()

Static Function Observacao()

Local oButton1
Local oButton2
Local oMultiGe1
Local cMultiGe1 := ""

dbSelectArea("SZQ")
dbSetOrder(1)
If !dbSeek(xFilial("SZQ")+_cProduto+_cLote)
	dbSelectArea("SZQ")
	RecLock("SZQ",.T.)
		SZQ->ZQ_FILIAL	:= xFilial("SZQ")
		SZQ->ZQ_PRODUTO	:= _cProduto
		SZQ->ZQ_LOTECTL	:= _cLote
		SZQ->ZQ_OBSERV	:= ""
	SZQ->(MsUnlock())
EndIf

cMultiGe1 := SZQ->ZQ_OBSERV

Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Observações do Lote" FROM 000, 000  TO 400, 500 COLORS 0, 16777215 PIXEL

    @ 020, 007 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 234, 148 COLORS 0, 16777215 HSCROLL PIXEL
    @ 175, 153 BUTTON oButton1 PROMPT "&Salvar" SIZE 037, 012 OF oDlg ACTION Gravar(cMultiGe1) PIXEL
    @ 175, 203 BUTTON oButton2 PROMPT "&Cancelar" SIZE 037, 012 OF oDlg ACTION Close(oDlg) PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return()

Static Function Gravar(cMultiGe1)

	dbSelectArea("SZQ")
	RecLock("SZQ",.F.)
		SZQ->ZQ_OBSERV := cMultiGe1
	SZQ->(MsUnlock())
	
	Close(oDlg)
	
Return()