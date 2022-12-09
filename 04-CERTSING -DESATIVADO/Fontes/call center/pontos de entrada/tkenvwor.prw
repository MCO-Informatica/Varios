/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TKENVWOR  �Autor  �Warleson(Opvs)     � Data �  10/29/12    ���
�������������������������������������������������������������������������͹��
���Desc.  � Ponto de entrada responsavel por validar o envio do workflow  ���
���       � O envio do email sera direcionado para a funcao CTSDK10       ���
�������������������������������������������������������������������������͹��
���Uso       � CERTISIGN-SERVICEDESK                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TKENVWOR()
	Local lRet  := .F. 
	Local aArea := GetArea()
	
	// lRet == .T. Envio de WF pela rotina padr�o
	// lRet == .F. Envio de WF PELA rotina personalizada
	U_CTSDK10()//Envio de Workflow pela rotina customizada
	
	RestArea(aArea)
Return lRet