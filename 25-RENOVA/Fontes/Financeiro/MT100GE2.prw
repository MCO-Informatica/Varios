#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  MT100GE2    Autor � Romay Oliveira     � Data �  07/2015     ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada na geracao da nota fiscal de entrada	  ���
���				para carregar campo observa��o do pedido para titulo SE2  ���
���																		  ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico Renova		                                      ���
�������������������������������������������������������������������������͹��
���Obs		 �Inova Solution											  ���
�������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������*/ 

User Function MT100GE2 
Local nOpc    := PARAMIXB[2]

If nOpc == 1 //.. inclusao       
	SE2->E2_XOBSCT	:=	SC7->C7_XOBSSE2
EndIf 

Return Nil