User Function MTA410T()

Local aAreaSC5 := SC5->(GetArea())
Local aAreaSE3 := SE3->(GetArea())

dbSelectArea("SE3")
dbSetOrder(5)
If dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.F.)
	If SE3->E3_VEND <> SC5->C5_VEND1
		If MsgYesNo("Deseja trocar o vendedor nas comissões já geradas?","Atenção")
			
			While Eof() == .f. .And. SE3->E3_FILIAL+SE3->E3_PEDIDO == SC5->C5_FILIAL+SC5->C5_NUM
				RecLock("SE3",.f.)
				SE3->E3_VEND := SC5->C5_VEND1
				MsUnLock()
				dbSelectArea("SE3")
				dbSkip()
			EndDo
	   
		EndIf
	EndIf
EndIf
    
RestArea(aAreaSE3)
RestArea(aAreaSC5)

Return
