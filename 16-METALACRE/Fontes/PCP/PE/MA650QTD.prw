#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch" 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA650QTD  � Autor �Mateus Hengle       � Data � 18/02/2014  ���
�������������������������������������������������������������������������͹��
���Descricao �PE que grava a qtde que esta no Pedido na Geracao da OP	  ���
�������������������������������������������������������������������������͹��
���          � RESOLVEU O PROBLEMA DO AMBIENTE OLD				          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MA650QTD()   

Local nQtdeC6 := SC6->C6_QTDVEN 

Return nQtdeC6
