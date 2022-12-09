#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � QEGRVALL � Autor �  Daniel   Gondran  � Data �  12/07/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar a data de fabricacao e        ���
���          � validade na tabala QEK                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function QEGRVALL

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "QEGRVALL" , __cUserID )

	If FunName() $ "MATA103/MATA116"          
		IF QEK->(!Eof())
			RecLock("QEK",.F.)
			QEK->QEK_DTVAL := SD1->D1_DTVALID
			QEK->QEK_DTFAB := SD1->D1_DFABRIC    
			msUnlock()       
		Endif
	Endif

Return 
