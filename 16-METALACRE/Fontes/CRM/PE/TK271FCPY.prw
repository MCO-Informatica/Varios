#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch" 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK271CPY  � Autor �Mateus Hengle       � Data � 06/11/2013  ���
�������������������������������������������������������������������������͹��      		
���Descricao �PE que limpa alguns campos das tabelas SUA e SUB no momento ���
�������������������������������������������������������������������������͹��
���          � da copia do atendimento  - modulo CRM			          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TK271FCPY()

Local cOperZ  := SUA->UA_OPER
Local cCancel := SUA->UA_CANC

IF cCancel == 'S'

	ALERT("N�o � permitido copiar um Atendimento cancelado!") 
		
ELSE 

	RECLOCK("SUA", .F.)
	SUA->UA_FECENT := CTOD(' / / ')
	SUA->UA_TEMOP  := 'N'
	MSUNLOCK()
	
	DBSELECTAREA("SUB")
	DBSETORDER(1)
	DBGOTOP()
	DBSEEK(xFilial("SUB") + SUA->UA_NUM)
	WHILE !EOF() .AND. xFilial("SUB") == SUB->UB_FILIAL .AND. SUB->UB_NUM == SUA->UA_NUM
		
		RECLOCK("SUB", .F.)
		SUB->UB_XINIC := 0
		SUB->UB_XFIM  := 0
		SUB->UB_NUMOP := ''
		SUB->UB_ITEMOP := ''
		MSUNLOCK()
		SUB->(DbSkip())
	ENDDO
	
	IF cOperZ == '3'
		MSGINFO("Este Atendimento foi copiado com sucesso !")
	ELSEIF cOperZ == '2'
		MSGINFO("Este Or�amento foi copiado com sucesso !")
	ELSEIF cOperZ == '1'
		MSGINFO("Esta copia foi realizada com sucesso !")
		MSGINFO("Para que este or�amento vire um Pedido de Venda � preciso altera-lo para Pedido de Venda e preencher os campos que est�o em branco!")
	ENDIF

ENDIF

Return