#include "protheus.ch"
#include "rwmake.ch"

User Function VPRDNFE()

_cPedido	:=	aCols[n,ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_XPEDITE"})]
_cProdOld	:=	Posicione("SC7",1,xFilial("SC7")+_cPedido,"C7_PRODUTO")
_cGrupOld	:=	Posicione("SB1",1,xFilial("SB1")+_cProdOld,"B1_GRUPO")
_cProdNew	:=	aCols[n,ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_COD"})]
_cGrupNew	:=	Posicione("SB1",1,xFilial("SB1")+_cProdNew,"B1_GRUPO")

// valida troca do produto na entrada da nota fiscal (verifica grupo)
If !Empty(_cPedido)
	If _cGrupOld <> _cGrupNew
		MsgBox("Não pode trocar o produto da nota fiscal para grupo de produto divergente do pedido de compra original.","Divergencia na Troca do Produto","Stop")
		_cProdNew	:=	_cProdOld
	EndIf
EndIf

Return(_cProdNew)

