#INCLUDE "rwmake.ch"
/*
�������������������������������������������������������������������������ͻ��
���Programa  �GAT002    � Autor � AP6 IDE            � Data �  07/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
*/
User Function Gat002()

Local _aArea := GetArea()
Local _nVend := ""

IF funname() $ "CNTA120"                    
   RETURN(_nVend)
ENDIF

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial()+SA1->A1_VEND)
                                           
_nVend := SA3->A3_NOME

RestArea(_aArea)
Return (_nVend)