#INCLUDE "rwmake.ch"

/*
�������������������������������������������������������������������������ͻ��
���Programa  �GAT001    � Autor � AP6 IDE            � Data �  16/11/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
*/

User Function Gat001()

Local _aArea  := GetArea()
Local _nPreco := 0

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial()+M->C7_PRODUTO)

If SB1->B1_ORIGEM == " " .OR. SB1->B1_ORIGEM == "0"
   If SB1->B1_UPRC == 0
      _nPreco := SB1->B1_VERCOM // CAMPO ESPECIFICO DO CLIENTE
   Else
      _nPreco := SB1->B1_UPRC   
   EndIf
Else
   If SB1->B1_VERCOM == 0  // CAMPO ESPECIFICO DO CLIENTE
      _nPreco := SB1->B1_UPRC
   Else
      _nPreco := SB1->B1_VERCOM  // CAMPO ESPECIFICO DO CLIENTE
   EndIf
EndIf

Eval(bgdRefresh)
RestArea(_aArea)
Return (_nPreco)