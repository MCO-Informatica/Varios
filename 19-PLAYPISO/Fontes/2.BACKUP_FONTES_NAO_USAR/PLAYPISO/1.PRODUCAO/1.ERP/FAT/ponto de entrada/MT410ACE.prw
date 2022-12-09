/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410ACE  �Autor  �Alexandre Sousa     � Data �  10/27/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. para validar o acesso do usuario ao pedido.            ���
���          �utilizado para verificar os usuarios do financeiro.         ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT410ACE()

	Local c_usuario := GetMv('MV_XUSRFIN')
	
	If !INCLUI .and. SC5->C5_XPEDFIN = 'S'

		If __cuserid $ c_usuario
			Return .T.
		EndIf
	
		msgalert('O pedido n�o poder� ser visualizado por esse usu�rio.', 'A T E N � � O')
		Return .F.
		
	EndIf

Return .T.