#Include "Protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QVAL200D  �Autor  �Marcio Dias         � Data �  20/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Exclui os certificados e componentes (pecas) associadas as  ���
���          �entradas de valvulas (QZ1).                                 ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico HCI                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function QVAL200D()

DbSelectArea("QZ1")
DbSetOrder(1)
DbGoTop()

// ENQUANTO HOUVER CERTIFICADOS ASSOCIADOS A ENTRADA, FAZ A EXCLUSAO DOS MESMOS.

If QZ1->(DbSeek(xFilial("QZ1")+QEK_PRODUT+QEK_REVI+QEK_LOTE+QEK_FORNEC+QEK_LOJFOR))
	While QZ1_XPROD == QEK_PRODUT .AND. QZ1_XREV == QEK_REVI .AND. QZ1_XLOTE == QEK_LOTE .AND. ;
	      QZ1_XFORN == QEK_FORNEC .AND. QZ1_XLOJA == QEK_LOJFOR
	      
	      RecLock("QZ1",.F.)
	      QZ1->(DbDelete())
	      QZ1->(MsUnlock())
	      
	      QZ1->(DbSkip())
	EndDo
EndIf

Return .T.