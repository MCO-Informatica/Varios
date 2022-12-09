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

User Function GVRESTC6()

_aArea     := GetArea()

_cVrPrdSld := aCols[n][Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})]
_cVrPrdLcl := aCols[n][Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_LOCAL"})]
_nSldAtual := 0

//_cVrPrdSld := M->C6_PRODUTO
//_cVrPrdLcl := M->C6_LOCAL

DbSelectArea("SB2")
DbSetOrder(1)
If DbSeek(xFilial("SB2")+_cVrPrdSld+_cVrPrdLcl)
   _nSldAtual := (SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP))
Endif

RestArea(_aArea)
Return(_nSldAtual)
