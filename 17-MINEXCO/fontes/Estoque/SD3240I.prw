#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SD3240I  ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 25/10/2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava a NCM das movimentacoes internas no saldos por lote      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Scenika Diagnosticos Ltda                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SD3240I()

aArea	:=	GetArea()

dbSelectArea("SB8")
_aAreaSB8	:=	GetArea()
dbSetOrder(3)
If dbSeek(xFilial("SB8")+SD3->(D3_COD+D3_LOCAL+D3_LOTECTL),.F.)
	
	RecLock("SB8",.f.)
	SB8->B8_LOTEFOR	:=	SD3->D3_X_LOTEF
	MsUnLock()
	
EndIf

RestArea(_aAreaSB8)
RestArea(aArea)

If SD3->D3_X_PRCVE > 0
	If MSGBOX("Deseja atualizar tabela de preço de venda do produto "+ALLTRIM(SD3->D3_COD)+"?","Atualização Tabela de Preço","YesNo")
		
		dbSelectArea("DA1")
		dbSetOrder(3)
		dbGoTop()
		While !Eof()
		     _cItem	:=	DA1->DA1_ITEM
		     dbSkip()
		EndDo 
		
		dbSelectArea("DA1") 
		dbSetOrder(7)
		If dbSeek(xFilial("DA1")+"001"+SD3->D3_COD+SD3->D3_LOTECTL,.F.)
			RecLock("DA1",.F.)
		    DA1->DA1_MOEDA	:=	SD3->D3_X_MOEDA
		    DA1->DA1_PRCVEN	:=	SD3->D3_X_PRCVE
			MsUnLock()
		Else
			RecLock("DA1",.T.)
		    DA1->DA1_FILIAL	:=	XFILIAL("DA1")
		    DA1->DA1_CODTAB	:=	"001"
		    DA1->DA1_CODPRO	:=	SD3->D3_COD
		    DA1->DA1_ITEM	:=	Soma1(_cItem)
		    DA1->DA1_ATIVO	:=	"1"
		    DA1->DA1_TPOPER	:=	"4"
		    DA1->DA1_QTDLOT	:=	Round(Recno()+100,2)
		    DA1->DA1_MOEDA	:=	SD3->D3_X_MOEDA
		    DA1->DA1_PRCVEN	:=	SD3->D3_X_PRCVE
		    DA1->DA1_INDLOT	:=	"000000000999999.99"
			DA1->DA1_DATVIG	:=	SD3->D3_EMISSAO
			DA1->DA1_X_LOTE	:=	SD3->D3_LOTECTL
			MsUnLock()
		EndIf		    
	EndIf
EndIf

Return()
