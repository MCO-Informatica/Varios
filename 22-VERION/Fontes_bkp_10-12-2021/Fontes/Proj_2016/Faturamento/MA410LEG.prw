#Include "Protheus.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410LEG  �Autor  �Paulo Sampaio		 � Data � 07/12/2007  ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. para alterar cores da legenda do Pedido de Venda.	  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SERCON MP8.11.											  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA410LEG()
Local aCoresAux := aClone(ParamIxb)
aAdd( aCoresAux , { "BR_PINK",'Nota Devolvida'} )
		
Return(aCoresAux)