#include "rwmake.ch"

User Function KFAT20M()

Local _nQtdLib	:=	M->C6_QTDLIB


If MsgBox("Deseja atualizar as linhas de saldo do pedido?","Saldo do Pedido","YesNo")
	
	AADD(aCols,Array(Len(aHeader)))
	For nCntFor:=1 To Len(aHeader)
		If ( aHeader[nCntFor,10] <>  "V" .And. AllTrim(aHeader[nCntFor,2]) <> "C6_QTDLIB" )
			aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
		Else
			aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
		EndIf
	Next nCntFor
	

	_cPedido				:= SC6->C6_NUM
	_cItem					:= SC6->C6_ITEM
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
		SC6->C6_LOTECTL         := ""
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
EndIf

Return(_nQtdLib)
