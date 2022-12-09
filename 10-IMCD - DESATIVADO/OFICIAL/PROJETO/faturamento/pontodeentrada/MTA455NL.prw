#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA455NL � Autor � Junior Carvalho    � Data � 17/05/2021  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar o log de liberacao do estoque ���
���          � Executado apos atualizacao dos arquivos na op��o de nova   ���
���          � liberac�o ap�s selecionar OK.                             ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico IMCD / faturamento/liberacao estoque manual     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MTA455NL()
	Local cMsg := "Op��o Nova Libera��o - MTA455NL"

	if empty(SC9->C9_BLEST)
		U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,'Libera��o Estoque', cMsg ,SC9->C9_ITEM )
	ENDIF

Return
