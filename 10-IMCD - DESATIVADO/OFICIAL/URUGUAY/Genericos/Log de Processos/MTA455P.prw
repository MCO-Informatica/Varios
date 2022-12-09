#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA455P  � Autor �  Daniel   Gondran  � Data �  10/03/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para validar conforme tolerancia gravada  ���
���          � em parametro a quantidade na libera��o manual de estoque.  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico MAKENI / faturamento/liberacao estoque manual   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MTA455P()    
Local lRet := .T.

	If Type("SB8->B8_PRODUTO") <> "U"                 
		If SB8->B8_PRODUTO == SC9->C9_PRODUTO
			U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,'Liberacao Est.Manual', , SC9->C9_ITEM )     
		Endif	
	Endif
			

Return lRet