#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT410TOK � Autor � Junior carvalho    � Data � 15/01/2019  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATA410                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT410TOK()

Local lRet	:= .T.

If M->C5_XINCO $ 'CIF|CIP'
	IF M->C5_XFRETE <= 0
		Alert("Para Incoterm CIF ou CIP, informar el valor del flete.." )
		lRet	:= .F.
	ENDIF
	IF M->C5_XSEGURO <= 0
		Alert("Para Incoterm CIF o CIP, informar el valor del seguro." )
		lRet	:= .F.
	ENDIF
	
ELSEIF M->C5_XINCO $ 'CFR|CPT'
	IF M->C5_XFRETE <= 0
		Alert("Para Incoterm CFR o CPT, informar el valor del flete.."  )
		lRet	:= .F.
	ENDIF
ENDIF

Return(lRet)