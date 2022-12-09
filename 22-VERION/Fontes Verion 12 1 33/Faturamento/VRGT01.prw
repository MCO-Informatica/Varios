#INCLUDE "rwmake.ch"

/*
�������������������������������������������������������������������������ͻ��
���Programa  � VRGT01   � Autor � Paulo Henrique     � Data �  28/08/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilho para verfica��o de C6_TES vazio ou n�o             ���
���          � no caso de produtos com aliquota zero de IPI               ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Verion                                          ���
�������������������������������������������������������������������������ͼ��
*/

User Function VRGT01()

Local _aArea  := {}
Local _cCdOpr := "",_cCdTes := ""

_aArea  := GetArea()
_cCdTes := aCols[n][Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_TES"})]

If _cCdTes == "521"
   MsgInfo(OemToAnsi("Campo de Tipo de Sa�da j� preenchdo"),OemToAnsi("Aten��o"))
Else   
   _cCdOpr := M->C6_OPER
EndIf   

RestArea(_aArea)
Return(_cCdOpr)
