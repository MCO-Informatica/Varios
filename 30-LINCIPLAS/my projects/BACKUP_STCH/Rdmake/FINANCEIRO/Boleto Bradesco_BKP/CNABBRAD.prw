#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABSFR01 �Autor  Thiago Queiroz       � Data �  02/09/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza o calculo do digito verificador do arquivo CNAB    ���
���          � e do Boleto Bradesco                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 - LINCIPLAS                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CNABBRAD

Private cRet := ""

//EXECBLOCK("CNABBRAD",.F.,.F.) --> fun��o que estava no cnab

//00000000009
//		modulo11(Conjunto de N�meros                  , 2 (in�cio dos pesos), Base)
cRet := MODULO11("02"+=STRZERO(VAL(SE1->E1_NUMBCO),11), 2                   , 7)
//MSGBOX(cRet + " - " + SE1->E1_NUMBCO)
If cRet == "0"
	cRet := "1"
ElseIf cRet == "1"
	cRet := "P"
Else
	return (cRet)
EndIf

//cRet := "02600"+STRZERO(VAL(ALLTRIM(SA6->A6_NUMCON)),9,0)

Return(cRet)
