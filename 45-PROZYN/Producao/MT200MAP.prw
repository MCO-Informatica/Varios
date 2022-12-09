#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � MT200MAP � Autor � Adriano Leonardo    � Data � 14/07/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para determinar se o mapa da diverg�ncia  ���
���          � das estruturas dever� ser exibido na confirma��o da mesma. ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MT200MAP()

Local _lRet		:= SuperGetMv("MV_MSTDIV",,.F.)
Public nCount	:= Paramixb[6] //Torno a vari�vel publica para uso no ponto de entrada A200GRVE (RPCPE002)

Return(_lRet)