
User Function INVB2LA()

lOCAL 		lTemLocali := .F.
Local       aArea := GetArea()

	//BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE                                                                                       
	DbSelectArea("SB2")
	DbSetOrder(1)
	If !DbSeek(xFilial("SB2")+M->(SB7->B7_COD+B7_LOCAL)) 
		RecLock("SB2",.T.)
			SB2->B2_FILIAL   := xFilial("SB2")
			SB2->B2_COD 	 := M->B7_COD
			SB2->B2_LOCAL    := M->B7_LOCAL
			SB2->B2_QATU     := 0
			SB2->B2_VATU1    := 0			
		SB2->(MsUnlock())
	EndIf
		
RestArea(aArea)     

Return()



User Function INVBFLA()

lOCAL 		lTemLocali := .F.
Local       aArea := GetArea()

	lTemLocali := .F.
	lTemLote   := .F.
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+M->B7_COD)

	If SB1->B1_LOCALIZ = 'S'
		lTemLocali := .T.
	EndIf

	If SB1->B1_RASTRO = 'S'
		lTemLote := .T.
	EndIf

    
	//BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE                                                                                       
	DbSelectArea("SBF")
	DbSetOrder(7)      //SB7->(B7_LOCAL+•B7_COD+B7_LOTECTL+B7_NUMLOTE+B7_LOCALIZ))  //SB7->(B7_LOCAL+B7_LOCALIZ+B7_COD+B7_NUMSERI)
	If !DbSeek(xFilial("SBF")+M->(B7_LOCAL+B7_COD+B7_LOTECTL+B7_NUMLOTE+B7_LOCALIZ)) //.AND. lTemLocali
		RecLock("SBF",.T.)
			SBF->BF_FILIAL   := xFilial("SBF")
			SBF->BF_PRODUTO  := M->B7_COD
			SBF->BF_LOCAL    := M->B7_LOCAL
			SBF->BF_LOCALIZ  := M->B7_LOCALIZ
			SBF->BF_LOTECTL  := M->B7_LOTECTL
			SBF->BF_NUMLOTE  := M->B7_NUMLOTE
			SBF->BF_QUANT    := 0
			SBF->BF_PRIOR    := "XXX"
		SBF->(MsUnlock())
	EndIf        
	

	//BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE                                                                                       
	DbSelectArea("SB8")
	DbSetOrder(3)
	If !DbSeek(xFilial("SB8")+M->(B7_COD+B7_LOCAL+B7_LOTECTL+B7_NUMLOTE)) //.AND. lTemLote
		RecLock("SB8",.T.)
			SB8->B8_FILIAL   := xFilial("SB8")
			SB8->B8_PRODUTO  := M->B7_COD
			SB8->B8_LOCAL    := M->B7_LOCAL
			SB8->B8_LOTECTL  := M->B7_LOTECTL
			SB8->B8_NUMLOTE  := M->B7_NUMLOTE
			SB8->B8_DATA     := CTOD("26/12/14")
			SB8->B8_DTVALID  := M->B7_DTVALID
			SB8->B8_SALDO    := 0
		SB8->(MsUnlock())
	Else
	
	EndIf
		     
RestArea(aArea)     

Return()
