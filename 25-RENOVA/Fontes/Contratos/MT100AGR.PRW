#include "rwmake.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Pt.Entrada³ MT100AGR ³Totvs                             ³ Data ³ 09/11 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descricao ³ Ponto de Entrada utilizado para gravacao do codigo WBS do  ³±±
//±±³          ³ Pedido de Compras para a NF Entrada, atraves da rotina de  ³±±
//±±³          ³ Inclusao Documento de Entrada.                             ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ Renova                                                     ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function MT100AGR()

Local aArea    := GetArea()
Local cNota    := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
Local lAtuSX6  := .F.
Local cCodWBSI := ""

Local _nPosTot := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TOTAL"})
Local _nPosPC  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
Local _nPosIPC := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMPC"})
Local _lExc	   := IIf(!INCLUI .And. !ALTERA, .T., .F.)
Local _lMedic  := Nil //!Empty(SC7->C7_CONTRA)

//If !_lMedic .And. SF1->F1_TIPO == "N"	// cTipo == "N"  Alterado em 24/06/10
If SF1->F1_TIPO == "N"
	For nX := 1 to Len(aCols)
		_lMedic := !Empty(Posicione("SC7",1,xFilial("SC7") + aCols[nX,_nPosPC] + aCols[nX, _nPosIPC], "C7_CONTRA"))
		If !_lMedic
			dbSelectArea("PA2")
			dbSetOrder(3)
			If dbSeek(xFilial("PA2") + aCols[nX,_nPosPC] + aCols[nX, _nPosIPC])
				If !_lExc
					Reclock("PA2", .F.)
						PA2->PA2_NUMNFE := cNFiscal
						PA2->PA2_SERNFE := cSerie
						PA2->PA2_FORN   := cA100For
						PA2->PA2_LOJA   := cLoja
						PA2->PA2_EMINFE := dDEmissao
						PA2->PA2_DIGNFE := dDataBase
						PA2->PA2_VALOR  := aCols[nX, _nPosTot]
						PA2->PA2_SALDO  := aCols[nX, _nPosTot]
					MsUnlock()
				Else
					Reclock("PA2", .F.)
						PA2->PA2_NUMNFE := ""
						PA2->PA2_SERNFE := ""
						PA2->PA2_FORN   := ""
						PA2->PA2_LOJA   := ""
						PA2->PA2_EMINFE := Ctod("  /  /  ")
						PA2->PA2_DIGNFE := Ctod("  /  /  ")
						PA2->PA2_VALOR  := 0
						PA2->PA2_SALDO  := 0
					MsUnlock()
				EndIf
			EndIf
		EndIf
	Next nX
EndIf                                

RestArea(aArea)

Return