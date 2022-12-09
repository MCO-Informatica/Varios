#include "rwmake.ch"
#include "Protheus.ch"

User Function MTA455NL()

Local _nPesol	:= 0
Local _nPbruto	:= 0
		
dbSelectArea("SC9")
dbSetOrder(1)
If dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.F.)
	
	While Eof() == .f. .And. SC9->(C9_FILIAL+C9_PEDIDO) == SC5->(C5_FILIAL+C5_NUM)
		//----> INICIO GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
		RecLock("SC9",.f.)
		SC9->C9_VQ_TRAN		:=	SC5->C5_TRANSP
		SC9->C9_VQ_NTRA		:=	Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")
		SC9->C9_VQ_NCLI		:=	POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
		SC9->C9_VQ_FVER		:=	SC5->C5_VQ_FVER
		SC9->C9_VQ_FCLI		:=	SC5->C5_VQ_FCLI
		
		dbSelectArea("SC6")
		dbSetOrder(1)
		If dbSeek(SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO,.F.)
			If SC6->C6_UM == "KG"
				_nPesol += SC9->C9_QTDLIB
				_nPbruto+= SC9->C9_QTDLIB
			else
				_nPesol += SC9->C9_QTDLIB2
				_nPbruto+= SC9->C9_QTDLIB2
			EndIf
		EndIf
		//----> FIM GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
		dbSelectArea("SC9")
		dbSkip()
	EndDo
EndIf

RecLock("SC5",.f.)
SC5->C5_PESOL := _nPesol
SC5->C5_PBRUTO:= _nPbruto
MsUnLock()

Return()
