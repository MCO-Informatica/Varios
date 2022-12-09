#INCLUDE "rwmake.ch"
#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A410CONS � Autor � Giane - ADV Brasil � Data �  28/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para acrescentar botao no pedido de vendas���
���          � que monta tela de visualizacao dos logs do pedido de vendas���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI  - faturamento/pedido de vendas          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A410CONS()
	Local aButtons := {}
	Local nPosCod := GdFieldPos("C6_PRODUTO", aHeader)
	
	if !INCLUI
		aAdd(aButtons,{'S4WB007N', {|lEnd| U_AFAT003(M->C5_NUM)} ,"Historico", "Historico"}) //HISTORICO DO PEDIDO DE VENDA
	Endif

	//aAdd(aButtons,{"TROCO", 	{|| U_MFAT004()}, "Consulta tabela de pre�o", "Tab.Pre�o"})
	aAdd(aButtons,{"NOTE" , {|| U_CFAT020(M->C5_CLIENTE,M->C5_LOJACLI)}, "Ultimos Itens Comprados", "Ult.Compra"})
	aAdd(aButtons,{"NOTE" , {|| U_CFAT009(ACOLS[n,nPosCod])}, "Consulta de Produto", "Consulta Produto"})
	aAdd(aButtons,{"TROCO", {|| U_C010VEND(ACOLS[n,nPosCod], M->C5_CLIENTE,M->C5_LOJACLI )}, "Consulta Pre�o Hist�rico", "Consulta Pre�o Hist�rico"})

Return aButtons
