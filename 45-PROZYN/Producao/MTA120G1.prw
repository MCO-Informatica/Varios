#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA120G1  �Autor  �Roberta Alonso        � Data �  18/01/11 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na gravacao dos itens do pedido de compra.���
���Desc.     � Trabalha junto com o PE MTA120G2.                          ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus10 - Espec�fico para a HDB                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA120G1()

_cAlias	:= Alias()
_nRec	:= Recno()
_nIndex	:= IndexOrd() 
 
Public _cNumPo
_aHistPg := {}

AADD(_aHistPg,_cNumPo)
//AADD(_aHistPg,_cObsPed)
                             
DbSelectArea(_cAlias)
DbSetOrder(_nIndex)
DbgoTo(_nRec)

Return(_aHistPg)