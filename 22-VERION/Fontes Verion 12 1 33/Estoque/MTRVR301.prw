#include "rwmake.ch"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �MTRVR301  �Autor�Ricardo Cavalini      � Data �  07/12/06    ���
��������������������������������������������������������������������������͹��
���Descricao � altera endereco no sb2 com base no sb1                      ���
��������������������������������������������������������������������������͹��
���Uso       �Especifico verion                                            ���
��������������������������������������������������������������������������͹��
��� Ajustes  � 						  � Data          ���� 
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function MTRVR301()
_cVerProd := SB2->B2_COD

// PRODUTO
dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
IF dbSeek(xFilial()+_cverProd)
      Reclock("SB1",.F.)
       Replace B1_VEREND with M->B2_LOCALIZ
      MsUnLock("SB1")
EndIf

Return 
