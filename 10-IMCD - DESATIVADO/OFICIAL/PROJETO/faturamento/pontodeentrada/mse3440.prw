#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MSE3440   � Autor �  Daniel   Gondran  � Data � 31/03/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para deduzir do valor da comissao, o      ���
���          � frete (quando o PV for CIF)                                ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MSE3440() 
	Local _aArea   	:= GetArea()
	Local cPedido 	:= SE1->E1_PEDIDO   
	Local nFrete	:= 0                       
	Local nFator	:= 0 

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MSE3440" , __cUserID )

	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5") + cPedido)
	If SC5->C5_TPFRETE == "C"
		dbSelectArea("DAI")
		dbSetOrder(4)
		If dbSeek(xFilial("DAI") + cPedido)
			nFrete := DAI->DAI_VALFRE
		Endif
	Endif

	dbSelectArea("SE3")
	RecLock("SE3",.F.)  
	nFator 			:= SE3->E3_COMIS / SE3->E3_BASE
	SE3->E3_BASE 	:= SE3->E3_BASE - nFrete
	SE3->E3_COMIS 	:= SE3->E3_COMIS - ( nFrete * nFator)
	msUnlock()

	RestArea(_aArea)
Return 