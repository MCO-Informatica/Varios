#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#Include "VKEY.Ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SIGATMK  � Autor � Luiz Alberto       * Data �  12/05/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para checagem de Contratos Vencidos       ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function SIGAFAT()

SetKey(VK_F11, {|| U_CopyAcols() })		// Funcao para Replicar linha do Acols

Return