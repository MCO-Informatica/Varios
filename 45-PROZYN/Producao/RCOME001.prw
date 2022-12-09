#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCOME001 �Autor  � Adriano Leonardo     �Data � 06/06/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina respons�vel por retornar a m�scara apropriada para o���
���          � campo de c�digo oficial do produto, levando em conta se o  ���
���          � usu�rio possui ou n�o acesso para visualizar a informa��o. ���
��������������������������������?����������������������������������������͹��
���Uso       � Protheus 12 - Empresa Prozyn.                              ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RCOME001()

Local _aSavArea := GetArea()
Local _cRotina	:= "RCOME001"
Local _cPicture	:= "@*%C"

If __cUserId $ SuperGetMv("MV_USRCOD",,"000000")
	_cPicture	:= "@!%C"
EndIf

RestArea(_aSavArea)

Return(_cPicture)