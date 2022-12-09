#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "MsgOpManual.ch"
#INCLUDE "RWMAKE.CH" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA650A   �Autor  �Bruno Daniel Abrigo � Data �  29/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Apos deletar o registro do SC2 (OP)						  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Metalacre                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA650A() 
Local aArea := GetArea()
Local lRet:=.T. 
Local cNumOPx := ALLTRIM(SC2->C2_NUM)  // PEGA O NUMERO DA OP QUE ESTA SENDO EXCLUIDA

// Ajusta Carga Fabrica

If cEmpAnt == '01'
	If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cNumOpx)) .And. Empty(SC5->C5_PEDWEB)

		If RecLock("SC5",.f.)
			SC5->C5_TEMOP	:= ''
			SC5->C5_LIBEROK	:= ''
			SC5->(MsUnlock())
		Endif

		U_CargaPed(cNumOPx) // Ajusta Saldo Carga Fabrica
	Endif
Endif

Return(lRet)