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

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "A410CONS" , __cUserID )

	if !INCLUI
		aAdd(aButtons,{'S4WB007N', {|lEnd| U_AFAT003(M->C5_NUM)} ,"Historico", "Historico"}) //HISTORICO DO PEDIDO DE VENDA
	Endif

Return aButtons