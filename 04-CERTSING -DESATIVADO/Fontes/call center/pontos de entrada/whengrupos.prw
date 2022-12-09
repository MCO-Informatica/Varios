/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WHENGRUPOS�Autor  �Opvs(Warleson)      � Data �  07/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Controla Campos/Grupo com permissoes                       ���
���          � apenas de visualizacao da tabela ADE                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
//�������������������������������������������������������������������������������������������Ŀ
//�Par�metro SDK_WHEGR                                                                        �
//�Recebe o c�digo dos Grupos com restri��o de edi��o no cabe�alho do atendimento (Tabela ADE)�
//���������������������������������������������������������������������������������������������
*/

User Function WhenGrupos

Local lRet := .T.

	DbSelectArea("SU7")
	DbSetOrder(4)

	If MsSeek(xFilial("SU7")+__cUserId)
        // Testa grupo de atendimento
        // Testa se usuario nao � Supervisor
		If ALLTRIM(SU7->U7_POSTO)$SuperGetMv("SDK_WHENGR",,"48") .and. !(ALLTRIM(SU7->U7_TIPO)=='2')
			lRet := .F.
		Endif
	EndIf

Return lRet