#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA455I  � Autor � Giane - ADV Brasil � Data �  26/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar o log de liberacao do estoque ���
���          � ocorrida na 'lib.estoque manual' do faturamento.           ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / faturamento/liberacao estoque manual   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MTA455I()     

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MTA455I" , __cUserID )

	if empty(SC9->C9_BLEST)
		U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,'Liberacao Est.Manual', , SC9->C9_ITEM )
	endif

Return 