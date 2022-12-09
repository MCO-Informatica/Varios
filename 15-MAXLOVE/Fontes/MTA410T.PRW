//
// NÃO COMPILAR
//

User Function MTA410T()

Local _aArea	:= GetArea()
Local nPrcVen	:= GDFieldGet("C6_PRCVEN",n)
Local nValDif	:= nPrcVen
Local lTransf	:= .F.
Local _aAreaSC6
Local cSvFil := cFilAnt 
dbSelectArea("SC6")
_aAreaSC6 := GetArea()
dbSetOrder(1)
If dbSeek(xFilial("SC5")+SC5->C5_NUM,.f.)
	
	While !Eof() .and. SC6->C6_FILIAL = SC5->C5_FILIAL .and. SC6->C6_NUM = SC5->C5_NUM
		If !SC5->C5_TIPO$"IPC"
			Do Case
				Case SC5->C5_XPRIORI == "A"
					If Inclui
						nPrcVen	:= SC6->C6_PRCTAB
						nValDif := SC6->C6_PRCVEN - nPrcVen 
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB
						nValDif := SC6->C6_PRCTAB - nPrcVen 
					Endif
				Case SC5->C5_XPRIORI == "B"
					If Inclui
						nPrcVen	:= SC6->C6_PRCVEN * GETMV("MV_X_PERC1") //50%
						nValDif := SC6->C6_PRCVEN - nPrcVen 
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB * GETMV("MV_X_PERC1") //50%
						nValDif := SC6->C6_PRCTAB - nPrcVen 
					Endif
				Case SC5->C5_XPRIORI == "C" 
					If Inclui 
						nPrcVen	:= SC6->C6_PRCVEN * GETMV("MV_X_PERC2") //40%
						nValDif := SC6->C6_PRCVEN - nPrcVen 
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB * GETMV("MV_X_PERC2") //40%
						nValDif := SC6->C6_PRCTAB - nPrcVen 
					Endif
				Case SC5->C5_XPRIORI == "D"
					If Inclui  
						nPrcVen	:= SC6->C6_PRCVEN * GETMV("MV_X_PERC3")//20%
						nValDif := SC6->C6_PRCVEN - nPrcVen 
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB * GETMV("MV_X_PERC3") //20%
						nValDif := SC6->C6_PRCTAB - nPrcVen 
					Endif
				Case SC5->C5_XPRIORI == "E"
					If Inclui  
						nPrcVen	:= SC6->C6_PRCVEN * GETMV("MV_X_PERC4")//70%
						nValDif := SC6->C6_PRCVEN - nPrcVen 
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB * GETMV("MV_X_PERC4") //70%
						nValDif := SC6->C6_PRCTAB - nPrcVen 
					Endif
				Case SC5->C5_XPRIORI == "F"
					If Inclui  
						nPrcVen	:= SC6->C6_PRCVEN * GETMV("MV_X_PERC5")//70%
						nValDif := SC6->C6_PRCVEN - nPrcVen 
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB * GETMV("MV_X_PERC5") //70%
						nValDif := SC6->C6_PRCTAB - nPrcVen 
					Endif

				Otherwise
					nPrcVen	:= SC6->C6_PRCVEN
					nValDif := 0
			EndCase
			
			dbSelectArea("SC6")
			Reclock("SC6",.F.)
 
 //			If Inclui
 //				SC6->C6_PRCTAB	:= nPrcven
 //			Endif 
 
			SC6->C6_PRCVEN  := nPrcVen
			SC6->C6_PRUNIT	:= nPrcVen
			SC6->C6_PRCVEN2 := nValDif
			SC6->C6_VALOR 	:= nPrcVen * SC6->C6_QTDVEN
			MsUnlock()
		
			dbSelectArea("SC9")
			dbSetOrder(1)
			If dbSeek(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM,.F.)
				RecLock("SC9",.f.)
				SC9->C9_PRCVEN  := nPrcVen
				MsUnLock()
			EndIf
		EndIf
		
		dbSelectArea("SC6")
		dbSkip()
		
	EndDo
EndIf

RestArea(_aAreaSC6)
RestArea(_aArea)

Return()
