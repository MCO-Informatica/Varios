#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT410INC � Autor � Giane - ADV Brasil � Data �  26/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar o log de inclusao do pedido   ���
���          � de vendas, qdo eh incluido direto pela tela do pedido      ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / faturamento/pedido de vendas           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT410INC()                 
	Local cMotivo := ""

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT410INC" , __cUserID )

	U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Inclusao',cMotivo)

Return 