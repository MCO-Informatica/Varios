#include "Protheus.ch"
#INCLUDE "TOTVS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATE003     �Autor  �Ricardo Nisiyama � Data �  30/06/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa o bloqueio de campo editavel para visual           ���
���          �  												          ���
���          �                                 	                          ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10                          	                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATE003()

Public _lOk := .T.
Public _aArea     := GetArea()
Public _nPosProd  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
Public _cProd     := aCols[N][_nPosProd]
Public _nTmpAna  := Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_TEMPANA")
Public _nTmpEnt  := Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_TEMPENT")

/*If !EMPTY(_nTmpEnt)
	If _nTmpEnt > "0"
 		_lOk := .T.          
 	Endif
EndIf */

Return(_lOk)