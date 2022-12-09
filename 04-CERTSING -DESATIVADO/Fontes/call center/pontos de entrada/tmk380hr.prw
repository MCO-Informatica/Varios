/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMK380HR  �Autor  � Opvs(Warleson)     � Data �  07/25/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada, reponsavel pela amarra��o entre as       ���
���          � tabelas SU4 e SU6                                          ���
�������������������������������������������������������������������������͹��
���Uso       � CERTISIGN/SERVICEDESK                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Usado na rotina agenda do operador

User Function TMK380HR()
	Local lRet := .T.

	RecLock("SU4",.F.)	
	Replace U4_CODLIG   With SU6->(U6_CODLIG)  	// Codigo do atendimento
	MsUnlock()
	
	//----------------------------------------------------------------
	// Rotina para acionar as vari�veis encapsulada na rotina CSFA060.
	//----------------------------------------------------------------
	U_CSFA070()
	
Return(.T.)