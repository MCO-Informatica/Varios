#INCLUDE "PROTHEUS.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA410E    �Autor  �Roberto Marques  � Data �  01/29/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada Para gravar o saldo da tarefa ref  ao     ���
���          � pedido EXCLUIDO.                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA410E()
/*		Local nValor	:= 0
				
		dbSelectArea("AF9")
		dbSetOrder(1)
		MsSeek(xFilial("AF9")+SC6->C6_PROJPMS+SC6->C6_REVISA+SC6->C6_TASKPMS)
		nValor := AF9->AF9_FATPV - SC6->C6_VALOR
		RecLock( "AF9", .F. )
		AF9->AF9_FATPV := nValor
		AF9->( MsUnlock() )
*/
Return