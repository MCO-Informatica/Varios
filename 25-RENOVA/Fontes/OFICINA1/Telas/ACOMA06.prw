#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACOMA06    �Autor  �Felipi Marques       Data �  07/16/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Altera��o de paramentro                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ACOMA06()

AreaAnt := Alias()

Private _cNSU  := PadR(GetMV("ES_XMLNSU"),15)

@ 0,0 TO 350,850 DIALOG oDlg1 TITLE "Altera��o do par�metro ultNSU"
@ 020,010 SAY "A consulta � realizada de forma sequencial a partir de uma posi��o do banco de dados informado no par�metro ultNSU"
@ 030,010 SAY "ES_XMLNSU : "
@ 040,010 GET _cNSU  SIZE 60,55 WHEN .T.  

@ 140,040 BUTTON "_Ok"   SIZE 35,15 ACTION (TROCA(),oDlg1:End())
@ 140,080 BUTTON "_Sair" SIZE 35,15 ACTION oDlg1:End()
ACTIVATE DIALOG oDlg1 CENTERED

dbSelectArea(AreaAnt)

Return

Static Function TROCA

PutMv("ES_XMLNSU",_cNSU)

MsgBox("Parametro alterado com sucesso!")

Return
