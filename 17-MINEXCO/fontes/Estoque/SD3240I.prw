#INCLUDE "rwmake.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � SD3240I  � Autor � Ricardo Correa de Souza � Data � 25/10/2004 ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Grava a NCM das movimentacoes internas no saldos por lote      ���
�����������������������������������������������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Scenika Diagnosticos Ltda                                      ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
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
	If MSGBOX("Deseja atualizar tabela de pre�o de venda do produto "+ALLTRIM(SD3->D3_COD)+"?","Atualiza��o Tabela de Pre�o","YesNo")
		
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
