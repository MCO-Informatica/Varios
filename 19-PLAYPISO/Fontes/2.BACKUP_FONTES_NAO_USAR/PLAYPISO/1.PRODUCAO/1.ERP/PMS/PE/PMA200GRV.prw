/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMA200GRV �Autor  �Microsiga           � Data �  10/15/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pe. Durante a confirmacao da alteracao de fase do projeto   ���
���          �Utilizado para validar o controle de revisoes.              ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PMA200GRV()
	
	Local l_Ret := .F.
	
	DbSelectArea('AFE')	
	DbSetOrder(1) // AFE_FILIAL, AFE_PROJET, AFE_REVISA, R_E_C_N_O_, D_E_L_E_T_
	
	If DbSeek(xFilial('AFE')+AF8->AF8_PROJET)
		While AFE->(!EOF()) .and. AFE->AFE_PROJET == AF8->AF8_PROJET
			If Empty(AFE->AFE_DATAF)
				l_Ret := .T.
				Exit
			EndIf
			AFE->(DbSkip())
		EndDo
	EndIf

	If !l_Ret
		msgAlert('Ser� necess�rio criar uma revis�o para alterar a fase do projeto!', 'A T E N � � O')
	Else
		RecLock('AFE', .F.)
		AFE->AFE_FASE := M->AF8_FASE	
		MsUnLock()
	EndIf
	

Return l_Ret
