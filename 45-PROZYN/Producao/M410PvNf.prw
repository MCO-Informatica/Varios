#Include "Protheus.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410PVNF  �Autor  �Henio Brasil        � Data � 30/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto Entrada para validar conteudo do prdido momentos antes  ���
���          �de gerar NF de faturamento                                  ���
�������������������������������������������������������������������������͹�� 
���Chamada   �MATA410 - Inclusao de Pedido de Vendas                      ���
�������������������������������������������������������������������������͹��
���Empresa   �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function M410PVNF() 

	Local lRet	:= .T.
	/* 
	�������������������������������������������������������������������Ŀ
	�Valida o Codigo CFD para validacao de dados da FCI                 �
	���������������������������������������������������������������������*/         
	If !U_PFatA001()
		lRet:= .F.
	Endif

	cQry := "SELECT CB7_ORDSEP FROM CB7010 WHERE CB7_PEDIDO = '"+SC5->C5_NUM+"' and D_E_L_E_T_ = '' AND CB7_STATUS < '2' "
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),'PEDSEP',.T.,.T.)

	If PEDSEP->(!Eof())
		If !empty(trim(PEDSEP->CB7_ORDSEP))
			MsgAlert("Pedido com ordem de separa��o: "+trim(PEDSEP->CB7_ORDSEP)+" em andamento, imposs�vel faturar neste momento.","Aten��o!")
			lRet := .F.
			PEDSEP->(DbCloseArea())
			Return
		EndIf
	EndIf

	PEDSEP->(DbCloseArea())
	
	cAmbiente := UPPER(ALLTRIM(GetEnvServer()))
	
	If cAmbiente $ "PROZYN_AT;PROZYN_AT2;PROZYN_HM"
		SC5->(RecLock("SC5",.F.))
		SC5->C5_TXMOEDA := U_MoedaFat(SC5->C5_XTPFATU,SC5->C5_TXREF)
		SC5->(MsUnlock())
	EndIf

Return(lRet)
