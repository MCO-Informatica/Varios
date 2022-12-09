#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE 'COLORS.CH'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FT400GRV | Autor � Luiz Alberto        � Data � 30/04/15 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo  � Ponto de Entrada Na Grava��o do Contrato de Parceria
				Para todos os Contratos Nascerem Bloqueados
�������������������������������������������������������������������������Ĵ��
���Uso       � METALACRE                                        ���
��                                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FT400GRV()
Local aArea	:=	GetArea()
Local nOpc	:=	PARAMIXB[1]

If nOpc	==	1 .Or. nOpc == 2	// Inclus�o ou Altera��o Bloqueia o Contrato
	If RecLock("ADA",.f.)
		ADA->ADA_STATUS	:=	'X'
		ADA->(MsUnlock())
	Endif
Endif

RestArea(aArea)
Return .t.




