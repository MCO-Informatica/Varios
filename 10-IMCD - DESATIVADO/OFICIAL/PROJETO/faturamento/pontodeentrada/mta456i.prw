#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA456I  � Autor � Giane - ADV Brasil � Data �  26/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar o log de liberacao do credito ���
���          � ou estoque pela analise de cred/estoque do pedido          ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / Analise credito estoque MANUAL         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MTA456I()
	//apenas liberacao manual

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MTA456I" , __cUserID )

	U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,'Liberacao Cred/Est', ,SC9->C9_ITEM)

Return 