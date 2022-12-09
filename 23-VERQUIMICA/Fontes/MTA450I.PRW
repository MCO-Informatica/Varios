#include "rwmake.ch"
#include "Protheus.ch"

User Function MTA450I()

		
Local _aArea := GetArea()   

dbSelectArea("SC6");DbSetOrder(1)
dbSelectArea("SC9");DbSetOrder(1)

If dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.F.)
	While Eof() == .f. .And. SC9->(C9_FILIAL+C9_PEDIDO) == SC5->(C5_FILIAL+C5_NUM)
		//----> INICIO GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
		RecLock("SC9",.f.)
		SC9->C9_VQ_TRAN		:=	SC5->C5_TRANSP
		SC9->C9_VQ_NTRA		:=	Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")
		SC9->C9_VQ_NCLI		:=	POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
		SC9->C9_VQ_FVER		:=	SC5->C5_VQ_FVER
		SC9->C9_VQ_FCLI		:=	SC5->C5_VQ_FCLI
		SC9->(MsUnLock())
		//----> FIM GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
		
		If SC6->(DbSeek(xFilial("SC6")+SC9->(C9_PEDIDO+C9_ITEM)))
			RecLock("SC6",.f.)
		        SC6->C6_FCICOD	:=	POSICIONE("SD1",26,xFilial("SD1")+SC9->C9_LOTECTL,"D1_FCICOD")                                        
			SC6->(MsUnLock())
		EndIf
		SC9->(DbSkip())
	EndDo
EndIf
RestArea(_aArea)
			

Return()