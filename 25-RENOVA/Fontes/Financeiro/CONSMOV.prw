#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONSMOV  �Autor  �                				25/08/2015���
�������������������������������������������������������������������������͹��
���Desc.     �Cria filtro na consulta personalizada.                      ���
��           �					                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Renova                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CONSMOV()

Local _cFilter := ''

If ISINCALLSTACK("FINA470")
	_cFilter :=	ALLTRIM(Substr(CV0->CV0_CODIGO,1,2)) = ALLTRIM(Substr(NEWSE5->E5_ITEMD,1,2))  .AND. CV0->CV0_CLASSE == '2'
Else
	_cFilter :=	ALLTRIM(Substr(CV0->CV0_CODIGO,1,2)) = ALLTRIM(Substr(M->E5_ITEMD,1,2))  .AND. CV0->CV0_CLASSE == '2'
EndIF

RETURN (_cFilter)