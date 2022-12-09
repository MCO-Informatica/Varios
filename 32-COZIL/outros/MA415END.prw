#include "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±|Ponto de Entrada     ³MA415END |Elvis Kinuta           |Data  ³26.08.2010              |±±
±±³                     ³         |                       |      |                        |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|Descricao ³Ponto de entrada na finalizacao do Orcamento.                               |±± 
±±|          ³(Recalculo dos itens do Orçamento pelo campo percentual "CJ_XCAPER")        |±±
±±|          ³                                                                            |±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MA415END()

/* FUNCAO PARCIALMENTE DESATIVADA EM 26/01/2013, DEVIDO A NAO UTILIZACAO */

dbSelectArea("SCK")
dbSetOrder(1)
dbSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM)
While !Eof() .And. SCK->CK_FILIAL+SCK->CK_NUM == SCJ->CJ_FILIAL+SCJ->CJ_NUM
	/* RECALCULO DESATIVADO
	If Posicione("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_TIPO") <> "RV"  //Quando o Tipo do Produto for RV(Revenda) nao devera fazer o calculo
		RecLock("SCK",.F.)
		nRec := SCJ->CJ_XCAPER   // Campo que sera informado Percentual a ser calculado
		SCK->CK_PRCVEN := SCK->CK_PRCVEN-((SCK->CK_PRCVEN*nRec)/100)
		SCK->CK_VALOR := SCK->CK_QTDVEN*SCK->CK_PRCVEN
		MsUnlock()
	Endif                  
	*/
	//[WILLIAM] COPIA CAMPO DO TIPO DO PEDIDO (ORCAMENTO) PARA OS ITENS
	RecLock("SCK",.F.)
		SCK->CK_XTPPV := SCJ->CJ_XTPPV
	MsUnlock()                    
	//[FIM - WILLIAM]
	dbSelectArea('SCK')
	dbSkip()
EndDo

/*
dbSelectArea("SCJ")
Reclock("SCJ",.F.)
SCJ->CJ_XCAPER := Val("0,00")
MsUnlock()
*/

RETURN()