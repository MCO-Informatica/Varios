#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � OS200PC9 � Autor � Giane - ADV Brasil � Data �  02/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar o log de roteirizacao do pedi ���
���          � do .                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / OMS - montagem da carga                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function OS200PC9() 

	Local cAlias := Paramixb[1]
    cCarga := IIF( empty((cAlias)->C9_CARGA) ,"","Carga "+(cAlias)->C9_CARGA )
	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "OS200PC9" , __cUserID )

	U_GrvLogPd((cAlias)->C9_PEDIDO,(cAlias)->C9_CLIENTE,(cAlias)->C9_LOJA,;
	'Roteirizacao',cCarga,(cAlias)->C9_ITEM )
Return .t.