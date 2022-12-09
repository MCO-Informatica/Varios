#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103IPC  �Autor � Roberta                � Data � 10/05/12 ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza os campos especificos dos itens do documento de    ��
���Desc.     � na atualizacao dos itens via botao Pedido ou Item.Ped.      ��
�������������������������������������������������������������������������͹��
���Uso       � Protheus                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103IPC()

//_cAlias := Alias()
//_nRecno := Recno()
//_nIndex := IndexOrd()

_nPosPro := aScan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})
_nPosPO  := aScan(aHeader,{|x|Alltrim(x[2])=="D1_NUMPO"})
_nPedCom   := aScan(aHeader,{|x|Alltrim(x[2])=="D1_PEDIDO"})
_nItem   := aScan(aHeader,{|x|Alltrim(x[2])=="D1_ITEM"})

_cCodPro := aCols[PARAMIXB[1],_nPosPro]
_cItem := aCols[PARAMIXB[1],_nItem]
_cNumPed := aCols[PARAMIXB[1],_nPedCom]

aCols[PARAMIXB[1],_nPosPO]  := Posicione("SC7",1,xFilial("SC7") + _cNumPed + _cItem + "","C7_NUMPO")
//ALERT(aCols[PARAMIXB[1],_nPosPO)
//DbSelectArea(_cAlias)                                 

//DbSetOrder(_nIndex)                    
//DbGoTop(_nRecno)                      

Return(.T.)