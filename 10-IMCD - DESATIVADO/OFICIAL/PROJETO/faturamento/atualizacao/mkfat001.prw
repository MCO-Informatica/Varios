#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MKFAT001 � Autor � Paulo - ADV Brasil � Data �  05/10/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o de usu�rio que verifica a situa��o do cliente, quan-���
���          � do da inclus�o dos Pedidos de Venda ou orcamento           ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI                                          ���
�������������������������������������������������������������������������͹��
���                            MANUTENCAO                                 ���
�������������������������������������������������������������������������͹��
��� SEQ  � DATA       | DESCRICAO                                         ���
�������������������������������������������������������������������������͹��
��� 001  � 02/12/2015 | JUNIOR CARVALHO - Se vier de amostra, n�o precisa ���
���      �            | passar pela validacao                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MKFAT001()
	//funcao usada nos gatilhos dos campos: C5_CLIENTE(001)  e UA_CLIENTE()
	Local _aArea := GetArea()
	Local _cMens := ""
	Local cChave := M->C5_CLIENTE+M->C5_LOJACLI
	LOCAL lRet := .T.

	IF !IsInCallStack("U_AFT20GPV") .AND. M->C5_CONDPAG <> "100" .AND. !(M->C5_TIPO $ 'D|B')
		// Verifica o status do cliente antes de continuar a an�lise do PV
		dbSelectArea("SA1")
		dbSetOrder(1)

		If dbSeek(xFilial("SA1")+cChave)

				If	SA1->A1_POSCLI == "A"
					_cMens := "� VISTA"
					IF(M->C5_CONDPAG <> "000" .AND. cEmpAnt == '01') .OR. (alltrim(M->C5_CONDPAG) <> "01" .AND. cEmpAnt == '02') 
						lRet := .F.
						MSGSTOP(OemToAnsi("A Condi��o de Pagamento deve ser "+ _cMens),"MKFAT001")
					ENDIF
				ElseIf SA1->A1_POSCLI == "B"
					_cMens := "BLOQUEADO"
					MSGSTOP(OemToAnsi("Favor entrar em contato com o Depto. de Cr�dito, para tratar do cliente em quest�o."),"MKFAT001")
					lRet := .F.
				ElseIf SA1->A1_POSCLI == "M"
					_cMens := "MONITORADO"
					MSGINFO(OemToAnsi("O Status do cliente � : "+_cMens),"MKFAT001")
				Else
					_cMens := "LIBERADO"
				EndIf

				if IsInCallStack("U_MT410INC")  .AND. lRet
					U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Situa��o do Cliente',"O Status do cliente � : "+_cMens)
				EndIf
			
		ELSE
			Alert("Cliente n�o localizado")
			lRet := .F.
		EndIf

	Endif

	RestArea(_aArea)

Return(lRet)
