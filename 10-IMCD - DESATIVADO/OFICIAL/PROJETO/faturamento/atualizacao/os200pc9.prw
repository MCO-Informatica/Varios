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

	local cAlias   as character
	local aAreas as array

	cAlias   := Paramixb[1]
	aAreas := {SC9->(getArea()), getArea()}

	dbSelectArea("SC9")
	SC9->(dbGoTo((cAlias)->RECSC9))

    cCarga := IIF( empty(SC9->C9_CARGA) ,"","Carga "+SC9->C9_CARGA )
	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "OS200PC9" , __cUserID )

	U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,;
	'Roteirizacao',cCarga,SC9->C9_ITEM )

	aEval(aAreas, {|aArea|restArea(aArea)})
	aSize(aAreas,0)

Return .t.