#Include "Rwmake.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA120G2  �Autor  �Roberta Alonso        � Data �  18/01/11 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na gravacao dos itens do pedido de compra.���
���Desc.     � Trabalha junto com o PE MTA120G1.                          ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus10 - Espec�fico para a HDB                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA120G2()

_cAlias	:= Alias()
_nRec	:= Recno()
_nIndex	:= IndexOrd()   

_aArray      := PARAMIXB

SC7->C7_NUMPO := _aArray[1] // informa��es do Usuario
//SC7->C7_OBS2   := _aArray[2] // informa��es do Usuario

DbSelectArea(_cAlias)
DbSetOrder(_nIndex)
DbgoTo(_nRec)

Return