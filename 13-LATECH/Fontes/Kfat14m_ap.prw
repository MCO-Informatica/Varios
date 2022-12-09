#include "protheus.ch"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfat14m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AAREASB8,_AAREASC6,_AAREASC5,_CDIR,_CFILE,_CINDICE")
SetPrvt("_CPEDIDO,_CITEM,_CBARRAS,_CPRODUTO,_CLOCAL,_NQTDALIB")
SetPrvt("_NQTDLIB,_NQTDLOTE,_NTOTLIB,_NSALDO,_LSAIR,NQTDLIB")
SetPrvt("_CPEDANT,_CITEANT,_AVALORCPO,NCNTFOR,_NGRVQTDLIB,_NGRVVALOR")
SetPrvt("_NVALUNIT,_LULTLIB,_NRECSC6,CITEM,LCREDITO,LESTOQUE")
SetPrvt("LLIBER,LTRANSF,_AAREAFUNCAO,_CPROGRAM,_LPAPEL,_CP")
SetPrvt("_AAREASC9,_LRETORNO,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT14M  ³ Autor ³ Sergio Oliveira       ³ Data ³27/09/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Liberacao dos Itens do Pedido e Geracao da Etiqueta        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

If Rastro(SC6->C6_PRODUTO) == .f.
	
	MsgInfo("O produto "+SC6->C6_PRODUTO+" nao tem controle de rastreabilidade","Rastrabilidade")
	
	Return
EndIf

DbSelectArea("SB8")
_aAreaSB8 := GetArea()

DbSelectArea("SC6")
_aAreaSC6 := GetArea()

DbSelectArea("SC5")
_aAreaSC5 := GetArea()

_cDir     := "\SYSTEM\ETIQUETA\"
_cFile          := "Z3.DBF"                         // Nome do arquivo de etiquetas
_cIndice        := _cDir+"Z3"                       // Path + Nome do arquivo de Indice de etiquetas
_cPedido        := SC6->C6_NUM                      // Numero do Pedido
_cItem          := SC6->C6_ITEM                     // Item do Pedido
_cBarras        := Space(12)                        // Variavel que recebe o codigo de barras
_cProduto       := SC6->C6_PRODUTO                  // Produto referente ao item do pedido
_cLocal         := SC6->C6_LOCAL
_nQtdAlib       := SC6->C6_QTDVEN - SC6->C6_QTDENT                                      // Quantidade a liberar
_nQtdLib        := _nQtdAlib                        // Quantidade liberada
_nQtdLote       := 0                                // Quantidade do lote
_nTotLib        := SC6->C6_QTDEMP                   // Quantidade total liberada(somatoria geral)
_nSaldo         := 0                                // Saldo do lote
_lSair          := .F.                              // Se deve sair ou nao do dialogo
nQtdLib         := 0                                // Variavel do siga de quantidade a liberar

While .T.
	_cPedAnt        := SC6->C6_NUM                  // Numero do Pedido
	_cIteAnt        := SC6->C6_ITEM                 // Item do Pedido
	_cPedido        := SC6->C6_NUM                  // Numero do Pedido
	_cItem          := SC6->C6_ITEM                 // Item do Pedido
	_cBarras        := Space(12)                    // Variavel que recebe o codigo de barras
	_cProduto       := SC6->C6_PRODUTO              // Produto referente ao item do pedido
	_cLocal         := SC6->C6_LOCAL
	
	@ 75,06  To 466,574 Dialog janela1 Title OemToAnsi("Liberacao de Pedidos de Vendas")
	@ 06,005 To 186,276 Title OemToAnsi("Liberacao item a item")
	@ 34,146 To 112,237 Title OemToAnsi("Liberacoes ja efetuadas para o item")
	
	@ 24,9   Say OemToAnsi("Codigo de Barras") Size 300,20
	@ 52,9   Say OemToAnsi("Produto") Size 100,20
	@ 79,9   Say OemToAnsi("Qtde a Liberar") Size 100,20
	@ 108,9  Say OemToAnsi("Qtde do Lote") Size 100,20
	@ 133,9  Say OemToAnsi("Qtde Liberada") Size 120,20
	@ 75,165 Say OemToAnsi("Acumulado") Size 100,20
	
	@ 53,166 Say OemToAnsi("Pedido")
	@ 63,166 Get _cPedido  Picture "999999"            When .F. Size 50,20
	
	@ 53,207 Say OemToAnsi("Item")
	
	@ 63,207 Get _cItem    Picture "@!"                When .F. Size 20,20
	@ 35,9   Get _cBarras  Picture "@!"                Valid VerCodBarra() Size 100,20// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     @ 35,9   Get _cBarras  Picture "@!"                Valid Execute(VerCodBarra)
	@ 63,9   Get _cProduto Picture "@!"                When .F. Size 50,20
	@ 91,9   Get _nQtdAlib Picture "@E 999,999,999.99" When .F. Size 50,20
	@ 118,9  Get _nQtdLote Picture "@E 999,999,999.99" When .F. Size 50,20
	@ 146,9  Get _nQtdLib  Picture "@E 999,999,999.99" Valid _nQtdLib <= SaldoLote(_cProduto, _cLocal,Subs(_cBarras,3,10)) .And. !Empty(_cBarras) .And. _nQtdLib >= 0.01 .And. _nQtdAlib > 0 Size 50,20
	@ 85,165 Get _nTotLib  Picture "@E 999,999,999.99" When .F. Size 50,20
	
	@ 135,186 BmpButton Type 1 Action GravaLib()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	@ 135,186 BmpButton Type 1 Action Execute(GravaLib)
	@ 135,216 BmpButton Type 2 Action CloseJan()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	@ 135,216 BmpButton Type 2 Action Execute(CloseJan)
	
	Activate Dialog janela1
	
	If _lSair
		Exit
	EndIf
EndDo

//MarkBRefresh()

Return

*---------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CloseJan
Static Function CloseJan()
*---------------------------------------------------------------------------*

_lSair := .T.

Close(janela1)

RestArq()

Return

*---------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function GravaLib
Static Function GravaLib()
*---------------------------------------------------------------------------*

If _nQtdLib == 0
	MsgBox("Nao e possivel liberar o pedido sem quantidade a liberar","Atencao","Alert")
	
	Close(janela1)
	
	Return
EndIf

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xFilial("SC5")+_cPedido)

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial()+_cPedido+_cItem)

_aValorCpo := {}

For nCntFor := 1 To FCount()
	Aadd(_aValorCpo,FieldGet(nCntFor))
Next nCntFor

_nGrvQtdLib             := SC6->C6_QTDVEN - _nQtdLib
_nGrvValor              := SC6->C6_PRCVEN * _nGrvQtdLib
_nValUnit               := SC6->C6_PRCVEN
_cLocal                 := SC6->C6_LOCAL

RecLock("SC6",.F.)

If _nQtdLib >= SC6->C6_QTDVEN
	SC6->C6_LOTECTL         := Subs(_cBarras,3,10)
	SC6->C6_QTDVEN          := _nQtdLib
	SC6->C6_VALOR           := (_nQtdLib * _nValUnit)
	SC6->C6_VALDESC         := (SC6->C6_VALOR/100) * SC6->C6_DESCONTO
	SC6->C6_BLQ             := Space(02)
	SC6->C6_QTDLIB          := _nQtdLib
	_lUltLib                := .T.
	_nRecSc6                := Recno()
Else
	SC6->C6_BLQ             := Space(02)
	SC6->C6_LOTECTL         := Space(10)
	SC6->C6_QTDLIB          := 0
	SC6->C6_QTDVEN          := _nGrvQtdLib
	SC6->C6_QTDEMP          := 0
	SC6->C6_QTDLIB          := 0
	SC6->C6_VALOR           := _nGrvValor
	_lUltLib                := .F.
EndIf

MsUnlock()

DbSelectArea("SC9")
DbSetOrder(1)
If DbSeek(xFilial("SC9")+_cPedido+_cItem)
	While Eof() == .F. .And. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == xFilial("SC9")+_cPedido+_cItem
		If ( SC9->C9_BLCRED != "10"  .And. SC9->C9_BLEST != "10" )
			A460Estorna(.T.)
		EndIf
		DbSkip()
	EndDo
EndIf

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial()+_cPedido)

cItem := Space(02)

While .t.
	If Eof() == .F. .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+_cPedido
		_cItem := SC6->C6_ITEM
		DbSkip()
	Else
		DbSkip(-1)
		Exit
	EndIf
EndDo

_cItem := Soma1(_cItem)

DbSelectArea("SC6")

IF !_lUltLib
	RecLock("SC6",.T.)
	For nCntFor := 1 TO FCount()
		FieldPut(nCntFor,_aValorCpo[nCntFor])
	Next nCntFor
	
	SC6->C6_FILIAL          := xFilial("SC6")
	SC6->C6_NUM             := _cPedido
	SC6->C6_ITEM            := _cItem
	SC6->C6_CLI             := SC5->C5_CLIENTE
	SC6->C6_LOJA            := SC5->C5_LOJACLI
	SC6->C6_LOTECTL         := Subs(_cBarras,3,10)
	SC6->C6_QTDVEN          := _nQtdLib
	SC6->C6_VALOR           := (_nQtdLib * _nValUnit)
	SC6->C6_VALDESC         := (SC6->C6_VALOR/100) * SC6->C6_DESCONTO
	SC6->C6_BLQ             := Space(02)
	MsUnLock()
	_nRecSc6                := Recno()
EndIF

lCredito        := .T.
lEstoque        := .T.
lLiber          := .F.                                          // Libera somente com estoque
lTransf         := .F.                                          // Transferencia de locais

DbSelectArea("SC6")
DbGoTo(_nRecSc6)

MaLibDoFat(_nRecSc6,@_nQtdLib,@lCredito,@lEstoque,.T.,.T.,lLiber,lTransf)

_nTotLib  := _nTotLib  + _nQtdLib
_nQtdAlib := _nQtdAlib - _nQtdLib

If !Empty(SC9->C9_BLCRED)
	
	MsgBox("O pedido "+SC9->C9_PEDIDO+" esta bloqueado por credito. Caso voce tenha outros pedidos para liberar do lote "+Subs(_cBarras,3,10)+" solicite a Liberacao de Credito desse pedido antes de prosseguir com a Liberacao Kenia para que as etiquetas sejam geradas corretamente.","Validacao Bloqueio de Credito","Alert")
	
EndIf

If _nSaldo - _nQtdLib > 0
	DbSelectArea("SZ3")
	RecLock("SZ3",.T.)
	SZ3->Z3_LOTE    := Subs(_cBarras,3,10)
	SZ3->Z3_QUANTID := _nQtdLib
	SZ3->Z3_UM      := SC6->C6_UM
	SZ3->Z3_LARGURA := SB1->B1_X_LARG
	SZ3->Z3_DESCRI  := SC6->C6_DESCRI
	SZ3->Z3_COMP    := SB1->B1_X_COMP
	SZ3->Z3_ORDEM   := Subs(SC6->C6_PRODUTO,1,3)
	SZ3->Z3_ARTIGO  := Subs(SC6->C6_PRODUTO,1,3)+Subs(SC6->C6_PRODUTO,7)
	SZ3->Z3_IMP     := "N" // Etiqueta nao foi impressa.
	SZ3->Z3_COR     := Subs(SC6->C6_PRODUTO,4,3)
	SZ3->Z3_PARTIDA := ""
	SZ3->Z3_SAIDA   := "S" // Quantidade de Saida
	SZ3->Z3_COPIAS  := 1
	SZ3->Z3_DOC     := _cPedido
	SZ3->Z3_CLIENTE := IIF(SB1->B1_TIPO$"TT",SC6->C6_CLI,"")
	SZ3->Z3_NOME	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NREDUZ"),"")
	SZ3->Z3_CNPJ	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_CGC"),"")
	MsUnLock()
	
	RecLock("SZ3",.T.)
	SZ3->Z3_LOTE    := Subs(_cBarras,3,10)
	SZ3->Z3_QUANTID := _nSaldo - _nQtdLib
	SZ3->Z3_UM      := SC6->C6_UM
	SZ3->Z3_LARGURA := SB1->B1_X_LARG
	SZ3->Z3_DESCRI  := SC6->C6_DESCRI
	SZ3->Z3_COMP    := SB1->B1_X_COMP
	SZ3->Z3_ORDEM   := Subs(SC6->C6_PRODUTO,1,3)
	SZ3->Z3_ARTIGO  := Subs(SC6->C6_PRODUTO,1,3)+Subs(SC6->C6_PRODUTO,7)
	SZ3->Z3_IMP     := "N" // Etiqueta nao foi impressa.
	SZ3->Z3_COR     := Subs(SC6->C6_PRODUTO,4,3)
	SZ3->Z3_PARTIDA := ""
	SZ3->Z3_SAIDA   := "R" // Quantidade de Saldo
	SZ3->Z3_COPIAS  := 1
	SZ3->Z3_DOC     := _cPedido
	SZ3->Z3_CLIENTE := IIF(SB1->B1_TIPO$"TT",SC6->C6_CLI,"")
	SZ3->Z3_NOME	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NREDUZ"),"")
	SZ3->Z3_CNPJ	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_CGC"),"")
	
	MsUnLock()
	
	DbSelectArea("SZB")
	RecLock("SZB",.t.)
	SZB->ZB_FILIAL  :=  xFilial("SZB")
	SZB->ZB_DATA    :=  dDataBase
	SZB->ZB_LOTECTL :=  Subs(_cBarras,3,10)
	SZB->ZB_PRODUTO :=  SC6->C6_PRODUTO
	SZB->ZB_QUANT   :=  _nSaldo
	MsUnLock()
	
	/*
	If !Empty(SC9->C9_BLCRED)
	DbSelectArea("SB8")
	DbSetOrder(3)
	DbSeek(xFilial("SB8")+_cProduto+_cLocal+Subs(_cBarras,3,10))
	
	RecLock("SB8",.f.)
	SB8->B8_EMPENHO :=  SB8->B8_EMPENHO - SC9->C9_QTDLIB
	MsUnLock()
	EndIf
	*/
	MsgBox("Serao geradas as etiquetas de saida"+Chr(13)+"e de saldo do produto "+_cProduto,"Informacao","Info")
EndIf

PaPeleta()

Close(janela1)

_nQtdLib  := 0
_nQtdLote := 0
_nSaldo   := 0

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial()+_cPedAnt+_cIteAnt)

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek( xFilial("SC5")+_cPedAnt+_cIteAnt )

Return

*---------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Papeleta
Static Function Papeleta()
*---------------------------------------------------------------------------*

_aAreaFuncao := GetArea()

DbSelectArea("SC5")
_aAreaSC5 := GetArea()

DbSetOrder(1)
DbSeek(xFilial("SC5")+SC6->C6_NUM,.T.)

_cProgram := FunName()
_lPapel   := SC5->C5_PAPELET
_cP       := SC5->C5_NUM

DbSelectarea("SC9")

_aAreaSC9 := GetArea()

DbSetOrder(1)
DbSeek( xFilial("SC9") + _cP )

While SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == _cP .And. !Eof()
	RecLock("SC9", .F.)
	SC9->C9_PAPELET := _lPAPEL
	MsUnlock()
	
	DbSkip()
EndDo

DbSelectarea("SC9")

RestArea(_aAreaSc9)

DbSelectarea("SC5")

RestArea(_aAreaSC5)
RestArea(_aAreaFuncao)

Return

*---------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RestArq
Static Function RestArq()
*---------------------------------------------------------------------------*

DbSelectArea("SB8")
RestArea(_aAreaSB8)

DbSelectArea("SC6")
RestArea(_aAreaSC6)

DbSelectArea("SC5")
RestArea(_aAreaSC5)

Return

*---------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function VerCodBarra
Static Function VerCodBarra()
*---------------------------------------------------------------------------*

If Len(AllTrim(_cBarras)) < 12
	MsgAlert("O Codigo de barra e invalido","Codigo de Barras")
	
	_nQtdLote := 0
	
	Return(.F.)
EndIf

_nSaldo         := 0
_lRetorno       := .F.

DbSelectArea("SB8")
SB8->(DbSetOrder(3))
DBSeek(xFilial("SB8")+_cProduto+_cLocal+Subs(_cBarras,3,10))

If Found()
	_nSaldo := SaldoLote(_cProduto, _cLocal,Subs(_cBarras,3,10))
	
Else
	_nSaldo := 0
EndIf


If _nSaldo <= 0
	MsgAlert("O Saldo deste lote ja esta totalmente comprometido","Saldo do Lote")
	
	_nQtdLote       := 0
	_nQtdLib        := 0
	_lRetorno       := .F.
Else
	
	_nQtdLote       := _nSaldo
	_nQtdLib        := _nSaldo
	_lRetorno       := .T.
EndIf

SysRefresh()

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(_lRetorno)
Return(_lRetorno)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
