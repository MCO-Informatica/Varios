#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch" 
/*/                                                

�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TKGRPED   � Autor �Mateus Hengle       � Data � 18/03/2014  ���
�������������������������������������������������������������������������͹��
���Descricao �PE que nao deixa fazer a alteracao sem antes tirar a   	  ���
�������������������������������������������������������������������������͹��
���          �liberacao do Pedido de venda						          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TKGRPED ()   // NAO DEIXA FAZER A ALTERACAO SEM ANTES TIRAR A LIBERACAO

Local cLibX := M->UA_STATUS
Local cOper := M->UA_OPER 
Local lRet  := .T.

IF cLibX == 'LIB' .AND. cOper == '1' .AND. !INCLUI  

	ALERT("Favor Tirar a Libera�� do Pedido via modulo Faturamento pra depois fazer a altera�ao!")
	lRet := .F.
ENDIF 
	 
Return lRet