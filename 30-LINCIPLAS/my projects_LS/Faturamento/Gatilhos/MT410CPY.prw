#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
// Funcao      	MT410CPY
// Autor 		Alexandre Dalpiaz
// Data 		20/06/2013
// Descricao    Ponto de entrada na cópia do pedido de vendas. Limpa os campos C5_CLIENTE, C5_LOJACLI, C6_NFORI, C6_ITEMORI, C6_SERIORI, C6_TES, C6_CF
// Uso         	Especifico para laselva
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT410CPY()
////////////////////////
M->C5_CLIENTE := space(6)
M->C5_LOJACLI := space(2)
M->C5_CLIENT  := space(6)
M->C5_LOJAENT := space(2)

For _nI := 1 to len(aCols)
	GdFieldPut('C6_TES'		,'   '	,_nI)
	GdFieldPut('C6_CF'		,'     ',_nI)
	GdFieldPut('C6_NFORI'	,'   '	,_nI)
	GdFieldPut('C6_ITEMORI'	,'   '	,_nI)
	GdFieldPut('C6_SERIORI'	,'   '	,_nI)
Next
Return()