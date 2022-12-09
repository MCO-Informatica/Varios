#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATga001 � Autor �Rodrigo Harmel      � Data �  07/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao �Nao permitir a utilizacao de CNPJ ja utilizado no cadastro  ���
���          �de clientes (SA1)                                           ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo para o cliente Certisign                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FATga001(_parm1)

Local _aArea
Local _cRet

_cRet  := U_CSFMTSA1(_parm1)
_aArea := {}

_aArea := GetArea()

dbSelectArea("SA1")
dbSetOrder(3)        // filial +  CNPJ
If dbSeek(xFilial("SA1")+_cRet,.f.)
   _cRet := ""
EndIf

RestArea(_aArea)

Return(_cRet)