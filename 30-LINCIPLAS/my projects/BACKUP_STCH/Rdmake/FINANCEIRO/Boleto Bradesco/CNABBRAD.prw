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
/* ABRE OLD
Private cRet //:= ""
//EXECBLOCK("CNABBRAD",.F.,.F.) --> fun��o que estava no cnab
//		modulo11(Conjunto de N�meros                  , 2 (in�cio dos pesos), Base)
cRet := MODULO11("02"+=STRZERO(VAL(SE1->E1_NUMBCO),11), 2                   , 7)
If cRet == "0"
cRet := "0"
ElseIf cRet == "1"
cRet := "P"
Else
return (cRet)
EndIf
FECHA OLD */
//IF EMPTY(SE1->E1_NUMBCO)
	xcpo := "0200"+SE1->E1_NUMBCO
	_cDig := U_MOD11(xcpo,2,7)
	IF val(_cDig) == 10
		_cDig := "P"
	ELSE
		_cDig := SUBSTR(_cDig,2,1)
	ENDIF
//ELSE
//	_cDig := SUBSTR(SE1->E1_NUMBCO,12,1)
	
//ENDIF



Return(_cDig)
