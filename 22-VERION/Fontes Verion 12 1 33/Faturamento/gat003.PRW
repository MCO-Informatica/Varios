#INCLUDE "rwmake.ch"

/*
�������������������������������������������������������������������������ͻ��
���Programa  �GAT003    � Autor � AP6 IDE            � Data �  21/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
*/

User Function Gat003()

Local _aArea  := GetArea()
Local _nPreco := 0

If SB1->B1_IMPIMPO > 0
   _nPreco := M->D1_VUNIT + (M->D1_VUNIT * SB1->B1_IMPIMPO)
Else
   _nPreco := M->D1_VUNIT   
EndIf   

RestArea(_aArea)

Return (_nPreco)