#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK271CPY  º Autor ³Mateus Hengle       º Data ³ 06/11/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±      		
±±ºDescricao ³PE que limpa alguns campos das tabelas SUA e SUB no momento º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ da copia do atendimento  - modulo CRM			          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TK271FCPY()

Local cOperZ  := SUA->UA_OPER
Local cCancel := SUA->UA_CANC

IF cCancel == 'S'

	ALERT("Não é permitido copiar um Atendimento cancelado!") 
		
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
		MSGINFO("Este Orçamento foi copiado com sucesso !")
	ELSEIF cOperZ == '1'
		MSGINFO("Esta copia foi realizada com sucesso !")
		MSGINFO("Para que este orçamento vire um Pedido de Venda é preciso altera-lo para Pedido de Venda e preencher os campos que estão em branco!")
	ENDIF

ENDIF

Return