#INCLUDE "PROTHEUS.CH"

User Function SHGAT005()

_cProd	:=	M->UB_PRODUTO
_cVend	:=	Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_VEND")
_cTpVd	:=	Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_TIPO")
_nCmsPd	:=	Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_COMIS")
_nCmsCl	:=	Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_COMIS")
_nComis := 	0

                                                              
//----> VENDEDOR INTERNO TEM COMISSAO FIXA DE 1%
If _cTpVd$"I" 

	_nComis	:=	1

//----> COMISSAO POR PRODUTO
ElseIf _nCmsPd > 0
	
	_nComis	:=	_nCmsPd

//----> COMISSAO POR CLIENTE
ElseIf _nCmsCl > 0 
	
	_nComis	:=	_nCmsPd

//----> COMISSAO POR VENDEDOR
Else

	_nComis :=	Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_COMIS")

EndIf

M->UA_COMIS := 0

Return(_nComis)