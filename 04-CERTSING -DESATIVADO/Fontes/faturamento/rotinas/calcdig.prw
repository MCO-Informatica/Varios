#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CALCDIG	�Autor  �Douglas Mello		 � Data �  13-11-2009 ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao no tratamento da mensagem do Boleto.              ���
���          �Tratamento de Geracao do arquivo Envio Cnab Itau ao Banco   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertiSign                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CALCDIG()
                      
Local _DIGITO	:=	0
//Local _DIGITO

IF A2_BANCO == "237"
	If LEN(ALLTRIM(A2_AGENCIA)) = 4
		_DIG1   := SUBSTR(A2_AGENCIA,1,1)
		_DIG2   := SUBSTR(A2_AGENCIA,2,1)
		_DIG3   := SUBSTR(A2_AGENCIA,3,1)
		_DIG4   := SUBSTR(A2_AGENCIA,4,1)
            
            
		_MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
		_RESUL  := INT(_MULT /11 )
		_RESTO  := INT(_MULT % 11)
		_DIGITO := 11 - _RESTO
	EndIf
	
EndIf

STR(_DIGITO)                   

Return(_DIGITO)
