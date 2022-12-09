#Include "PROTHEUS.CH" 

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AFAT025  � Autor � Molina             � Data � 11/02/10    ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa Manutencao no Cabecalho de Orcamento e Pedido de   ���
���          � Vendas (SUA e SC5)                                         ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function AFAT025()

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "AFAT025" , __cUserID )

	Private lAbortPrint := .F.

	If MsgYesNo("Inicia manuten��o no Or�amento e Pedido?")
		Processa({||Processar()},"Manuten��o...","",.T.)
	EndIf
Return Nil

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Processar� Autor � Molina             � Data � 11/02/10    ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa manutencao                                         ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/  
Static Function Processar()
	Local lProcesso	:= .T.
	Local cGrupo 	:= ""
	Local cDGrupo	:= ""

	cMsg := ""
	Begin Transaction  

		// Pedidos
		dbSelectArea("SC5")
		dbSetOrder(1)
		Do While .Not. SC5->(EOF()) 
			cGrupo 	:= ""
			cDGrupo	:= ""

			IncProc("Manuten��o no Pedido de n� " + SC5->C5_NUM + " . . .")

			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI))
				cGrupo := SA1->A1_GRPVEN
			EndIf

			If cGrupo <> ""
				dbSelectArea("ACY")
				ACY->(dbSetOrder(1))
				If ACY->(dbSeek(xFilial("ACY") + cGrupo))
					cDGrupo := ACY->ACY_DESCRI
				EndIf  
			EndIf

			If cGrupo <> ""
				dbSelectArea("SC5")
				RecLock("SC5", .F.)

				SC5->C5_GRPVEN 	:= cGrupo
				SC5->C5_DGRPVEN	:= cDGrupo

				MSUnlock()
			EndIf

			SC5->(dbSkip())
		EndDo

		// Orcamentos
		cMsg := ""
		dbSelectArea("SUA")
		dbSetOrder(1)
		Do While .Not. SUA->(EOF()) 
			cGrupo 	:= ""
			cDGrupo	:= ""

			IncProc("Manuten��o no Or�amento de n� " + SUA->UA_NUM + " . . .")

			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA))
				cGrupo := SA1->A1_GRPVEN
			EndIf

			If cGrupo <> ""
				dbSelectArea("ACY")
				ACY->(dbSetOrder(1))
				If ACY->(dbSeek(xFilial("ACY") + cGrupo))
					cDGrupo := ACY->ACY_DESCRI
				EndIf  
			EndIf

			If cGrupo <> ""
				dbSelectArea("SUA")
				RecLock("SUA", .F.)

				SUA->UA_GRPVEN 	:= cGrupo
				SUA->UA_DGRPVEN	:= cDGrupo

				MSUnlock()
			EndIf

			SUA->(dbSkip())
		EndDo

	End Transaction

	If lProcesso
		MsgInfo("Manuten��o Finalizada com Sucesso!") 
	Else
		MsgStop("Manuten��o Cancelada pelo Operador!") 
	EndIf
Return