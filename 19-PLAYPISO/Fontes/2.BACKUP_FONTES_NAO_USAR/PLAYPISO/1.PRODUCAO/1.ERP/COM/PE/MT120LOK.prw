/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120LOK  �Autor  �Microsiga           � Data �  10/26/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. durante a validacao da linha do pedido de compras.     ���
���          �utilizado para validar o cc quando for faturamento direto.  ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT120LOK()
	
	Local n_posFtd := aScan(aHeader, {|x| AllTrim(x[2])=="C7_XFATD"})
	Local n_posCCF := aScan(aHeader, {|x| AllTrim(x[2])=="C7_XCCFTD"})
		
	If aCols[n, n_posFtd] = 'S'
		If Empty(aCols[n, n_posCCF])
			msgAlert('Se o pedido for para faturamento direto ser� necess�rio identificar a obra!!!!', 'A T E N � � O')
			Return .F.
		EndIf
	EndIf
	
Return .T.
