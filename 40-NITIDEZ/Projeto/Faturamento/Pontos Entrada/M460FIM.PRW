#include 'topconn.ch'    

User Function M460FIM
Local aArea := GetArea()
Local nRecSE1:=0

nRecSE1:=SE1->(Recno())
If SF2->F2_TIPO == 'N' .And. SE1->(dbSetOrder(2), dbSeek(xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC)))
	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	While SE1->(!Eof()) .And. xFilial("SF2")+SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC)==xFilial("SE1")+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
		If RecLock("SE1",.F.)
			SE1->E1_NUMCTR  := SC5->C5_NUMCTR
			SE1->E1_SEQCTR  := SC5->C5_SEQCTR
			SE1->(MsUnLock())
		Endif
		
		SE1->(dbSkip())
	End
	SE1->(dbGoto(nRecSE1))	
EndIf

If RecLock("SF2",.F.)
	SF2->F2_NOMCLI	:=	SC5->C5_NOMCLI
	SF2->(MsUnlock())
Endif

// Atualiza campo Preço e Data negociados

If SD2->(dbSetOrder(3), dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
	While SD2->(!Eof()) .And. SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
			If RecLock("SD2",.F.)
				SD2->D2_PRCNEG	:=	SC6->C6_PRCNEG
				SD2->D2_DATNEG	:=	SC6->C6_DATNEG
				SD2->(MsUnlock())
			Endif
		Endif

		SD2->(dbSkip(1))
	Enddo
Endif

RestArea(aArea)
RETURN
