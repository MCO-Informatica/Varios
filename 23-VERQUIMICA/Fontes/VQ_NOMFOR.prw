/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VQ_NOMFOR �Autor  �Felipe Pieroni      � Data �  01/22/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � alimenta o campo virtual dentro da tabela SCR 			   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function VQ_NOMFOR()
Local _xRet := ""
Local aArea   := GetArea()
Local aAreaC7 := SC7->(GetArea())
Local aAreaA2 := SC7->(GetArea())

If SCR->CR_TIPO = "PC"
	DbSelectArea("SC7")
	DbSetOrder(1)
	If DbSeek(xFilial("SC7")+SUBSTR(SCR->CR_NUM,1,6))
		DbSelectArea("SA2")
		DbSetORder(1)
		If DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
			_xRet := SA2->A2_NOME
		EndIf
	EndIf
EndIf

RestArea(aArea)
RestArea(aAreaC7)
RestArea(aAreaA2)

Return(_xRet)