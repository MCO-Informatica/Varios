#include "rwmake.ch"
#include "Protheus.ch"

User Function MSD2520()

Local _aArea := GetArea()
		
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(SD2->D2_FILIAL+SD2->D2_PEDIDO,.F.)


dbSelectArea("SC9")
dbSetOrder(1)
If dbSeek(SD2->D2_FILIAL+SD2->D2_PEDIDO,.F.)
    
	While Eof() == .f. .And. SC9->(C9_FILIAL+C9_PEDIDO) == SD2->(D2_FILIAL+D2_PEDIDO)
		//----> INICIO GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
		RecLock("SC9",.f.)
		SC9->C9_VQ_TRAN		:=	SC5->C5_TRANSP
		SC9->C9_VQ_NTRA		:=	POSICIONE("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")
		SC9->C9_VQ_NCLI		:=	POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
		SC9->C9_VQ_FVER		:=	SC5->C5_VQ_FVER
		SC9->C9_VQ_FCLI		:=	SC5->C5_VQ_FCLI
		MsUnLock()
		//----> FIM GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
		dbSkip()
	EndDo
EndIf
			
RestArea(_aArea)

Return()