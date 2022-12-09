#INCLUDE "rwmake.ch"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A410CONS º Autor ³ Giane - ADV Brasil º Data ³  28/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para acrescentar botao no pedido de vendasº±±
±±º          ³ que monta tela de visualizacao dos logs do pedido de vendasº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI  - faturamento/pedido de vendas          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function A410CONS()
	Local aButtons := {}
	Local nPosCod := GdFieldPos("C6_PRODUTO", aHeader)
	
	if !INCLUI
		aAdd(aButtons,{'S4WB007N', {|lEnd| U_AFAT003(M->C5_NUM)} ,"Historico", "Historico"}) //HISTORICO DO PEDIDO DE VENDA
	Endif

	//aAdd(aButtons,{"TROCO", 	{|| U_MFAT004()}, "Consulta tabela de preço", "Tab.Preço"})
	aAdd(aButtons,{"NOTE" , {|| U_CFAT020(M->C5_CLIENTE,M->C5_LOJACLI)}, "Ultimos Itens Comprados", "Ult.Compra"})
	aAdd(aButtons,{"NOTE" , {|| U_CFAT009(ACOLS[n,nPosCod])}, "Consulta de Produto", "Consulta Produto"})
	aAdd(aButtons,{"TROCO", {|| U_C010VEND(ACOLS[n,nPosCod], M->C5_CLIENTE,M->C5_LOJACLI )}, "Consulta Preço Histórico", "Consulta Preço Histórico"})

Return aButtons
