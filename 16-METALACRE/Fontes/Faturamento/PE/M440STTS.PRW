#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"
#INCLUDE "AP5MAIL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M440STTS  º Autor ³FLAVIA AGUIAR       º Data ³ 25/08/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PE APOS A GRAVACAO DOS REGISTROS DA LIBERACAO.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Validacao do campo de bloqueio de credito conforme regras. º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   

USER FUNCTION M440STTS()    
 
LOCAL PEDIDO := SC9->C9_PEDIDO

If cEmpAnt <> '01'
	Return
Endif
                           
lCredito	:=	.f.

DBSELECTAREA("SC9")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SC9") + PEDIDO)  
	DO WHILE !EOF() .AND. ALLTRIM(SC9->C9_PEDIDO) == alltrim(PEDIDO) .And. SC9->C9_FILIAL == xFilial("SC9")
		// Avalia se o Pedido Esta Bloqueado no Credito e Envia email ao Depto Financeiro

		If SC9->C9_BLCRED $ '01*02*04*05*06'
			lCredito := .t.
		Endif
	
	
		RECLOCK("SC9",.F.)
		SC9->C9_LOTECTL := U_PROCURA(PEDIDO,"C6_LOTECTL","SC6","C6_NUM","C6_ITEM",SC9->C9_ITEM,"C6_PRODUTO",C9_PRODUTO)
		SC9->(MSUNLOCK()) 
		if !EMPTY(SC9->C9_LOTECTL)
			RECLOCK("SC9",.F.)
			SC9->C9_BLEST := '' 
			SC9->(MSUNLOCK()) 
		ENDIF  
 				
		dbselectArea("SC6")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM  + SC9->C9_PRODUTO)
			RECLOCK("SC6",.F.)
			SC6->C6_LIBERAD := 'S' 
			SC6->(MSUNLOCK())
		ENDIF
		         
		DBSELECTAREA("SC9")
		DBSKIP()
	ENDDO
ENDIF

SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+PEDIDO))

// Se For a Tela de Atendimento Telemarketing então não é orçamento retorna verdadeiro
If lCredito .And. SC5->C5_TIPO == 'N' // Apenas Pedidos Normais
	U_PrcWrkFin(SC5->C5_NUM)
Endif
Return .t.