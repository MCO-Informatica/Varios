#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SISPCC �Autor  �Rodrigo Okamoto        � Data �  30/12/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para grava��o da Agencia e Conta no arquivo       ���
���          � remessa do SISPAG                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 - LINCIPLAS                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


user function SISPCC()
Private cRet

IF SA2->A2_BANCO == "341" 
	cRet :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" 0000000"+StrZero(Val(SUBS(SA2->A2_NUMCON,1,5)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,6,1)),1)
Else
	cRet :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,1,12)),12)+"  "
Endif

Return(cRet)

