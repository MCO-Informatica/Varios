#INCLUDE "PROTHEUS.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CN130ALT  �Autor  �TOTVS               � Data �  08/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza PA2 na exclusao da medicao                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � RENOVA                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CN130PGRV()

Local nOpc   := PARAMIXB[1]
Local _aArea := GetArea()

If nOpc == 5
	dbSelectArea("PA2")
	dbSetOrder(1)
	If dbSeek(xFilial("PA2") + CND->CND_CONTRA)
		While PA2->(!EOF()) .And. (xFilial("PA2") + CND->CND_CONTRA == PA2->PA2_FILIAL + PA2->PA2_CONTRA)
			RecLock("PA2",.F.)
				PA2->PA2_USADO  := IIf((CND->CND_DESCME + PA2->PA2_SALDO) == PA2->PA2_VALOR , "2", "3")
				PA2->PA2_SALDO  += CND->CND_DESCME
			MsUnlock()
			PA2->(dbSkip())
		EndDo
	EndIf
EndIf

RestArea(_aArea)

Return