#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �MT410ACE		�Autor  �Microsiga	     � Data �  15/05/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o de acesso do pedido de vendas					  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT410ACE()

Local aArea := GetArea()
Local nOpc	:= ParamixB[1]
Local lRet	:= .T.	

AtuCpoPv()
	
RestArea(aArea)	
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �AtuCpoPv		�Autor  �Microsiga	     � Data �  15/05/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza��o de campos do pedido de venda antes de iniciar a ���
���          �tela                                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuCpoPv()

Local aArea := GetArea()

If INCLUI .Or. ALTERA
	M->C5_YESPPES := .F.
EndIf

RestArea(aArea)
Return