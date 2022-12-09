#INCLUDE "rwmake.ch"
/*
�������������������������������������������������������������������������ͻ��
���Programa  �GVRESTOQ  � Autor � RICARDO CAVALINI   � Data �  11/01/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
*/

User Function GVRESTUB()
_aArea     := GetArea()
_cVrPrdSld := M->UB_PRODUTO
_nSldAtual := 0

// SALDO DE ESTOQUE
DbSelectArea("SB2")
DbSetOrder(1)
If DbSeek(Xfilial("SB2")+_cVrPrdSld+"01")
   _nSldAtual := (SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP))
Endif

RestArea(_aArea)
Return(_nSldAtual)