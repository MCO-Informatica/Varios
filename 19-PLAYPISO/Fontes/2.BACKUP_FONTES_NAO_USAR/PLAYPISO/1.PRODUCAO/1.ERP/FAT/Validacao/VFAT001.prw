/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VFAT001   �Autor  �Alexandre Sousa     � Data �  09/17/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se o cadastro esta bloqueado para uso.             ���
���          �(utiliza campo de bloqueio padrao do sistema).              ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VFAT001(c_alias, c_chave, n_ind, l_msg)

	Local l_avisa	:=  Iif(l_msg=nil, .T., l_msg)
	Local l_Ret		:= .T.
	Local a_area	:= GetArea()

	DbSelectArea(c_alias)
	DbSetOrder(n_ind)
	If DbSeek(c_chave)
		If (c_alias)->&(PrefixoCpo(c_alias)+"_MSBLQL") = '1'
			If l_msg
				msgAlert("Esse registro encontra-se bloqueado para uso. Solicite revis�o do cadastro!!!", "A T E N � � O")
			Endif
			l_Ret := .F.
		EndIf
	EndIf



Return l_Ret