/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110VLD  �Autor  �Alexandre Sousa     � Data �  05/19/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pe.para valiadar a alteracao de uma solicitacao de compras. ���
���          �utiliizado para nao permitir solicitacoes em cotacao.       ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT110VLD()
	
	Local l_Ret := .T.

	If SC1->C1_STATUS = 'C'
		l_Ret := .F.
		msgAlert('Essa solicita��o n�o poder� ser alterada!!', 'Inclua nova solicita��o')
	EndIf

Return l_Ret