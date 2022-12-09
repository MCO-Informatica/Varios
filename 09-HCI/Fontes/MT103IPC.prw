#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � MT103IPC � Ponto de entrada para complementar a inicializa��o do item da���
���             �          � nota fiscal via pedido de compra.                            ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 02.03.07 � Osmil Squarcine de Souza Leite                               ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � PARAMIXB = array com o item que esta sendo processado.                  ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es � Programa desenvolvido por Solicitacao do Robson no dia 02/03/2007       ���
���             � Uso Exclusivo da HCI                                                    ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function MT103IPC()

Local aAreaAtu	:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
Local nItem		:= PARAMIXB[1]
Local nPProduto	:= aScan(aHeader,{|x| Trim(x[2]) == "D1_COD"} )
Local nPDesc  	:= aScan(aHeader,{|x| Trim(x[2]) == "D1_XDESCRI"} )

dbSelectArea("SB1")
dbSetOrder(1)
If !MsSeek(xFilial("SB1")+aCols[nItem,nPProduto])
	Aviso("Nota Fiscal de Entrada","Produto n�o localizado no cadastro!",{"&Ok"},,"Produto: "+Trim(aCols[nItem,nPProduto]) )
EndIf

// Atualiza os itens da nota com base no pedido 
aCols[nItem,nPDesc]		:= SB1->B1_DESC

RestArea(aAreaSB1)
RestArea(aAreaAtu)

Return(Nil)
