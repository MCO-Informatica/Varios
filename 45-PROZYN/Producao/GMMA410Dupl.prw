
User Function M460FIM()

//INCLUSÃO DA TRATATIVA DE SEGUNDA UNIDADE DE MEDIDA NO FATURAMENTO - DANIEL NB - 08-12-17
Local _aAreaMem := GetArea()
Local _aAreaSc6 := SC6->(GetArea())
Local _aAreaSd2 := SD2->(GetArea()) 
Local _aAreaSC5 := SC5->(GetArea())

SD2->(DbSetOrder(3)) // Indice 3 - D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
If SD2->(DbSeek(xFilial('SD2')+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
	
	While SD2->(!EOF()) .And. SD2->D2_FILIAL == xFilial('SD2') .And. SD2->D2_DOC == SF2->F2_DOC .And.;
	SD2->D2_SERIE == SF2->F2_SERIE .And. SD2->D2_CLIENTE == SF2->F2_CLIENTE .And. SD2->D2_LOJA == SF2->F2_LOJA
		
		SC6->(DbSetOrder(1)) // Indice 1 - C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		If SC6->(DbSeek(xFilial('SC6')+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))
			
			SC5->(DbSetOrder(1))
			SC5->(DbSeek(xFilial('SC5')+SD2->D2_PEDIDO))
			
			IF SC5->C5_MOEDA # 1
						
			RecLock('SD2', .F.)
				
				SD2->D2_PRC2UM := SC6->C6_PRC2UN * SC5->C5_TXREF 
				
			SD2->(MsUnlock())
			
			ELSE                                
			
			RecLock('SD2', .F.)
				
				SD2->D2_PRC2UM := SC6->C6_PRC2UN
				
			SD2->(MsUnlock())
			
			ENDIF
			
		EndIf
		
		SD2->(DbSkip())
		
	EndDo
	
EndIf

RestArea(_aAreaSd2)
RestArea(_aAreaSc6)
RestArea(_aAreaMem) 
RestArea(_aAreaSc5)

//FIM -- INCLUSÃO DA TRATATIVA DE SEGUNDA UNIDADE DE MEDIDA NO FATURAMENTO - DANIEL NB - 08-12-17 

IF SE1->E1_MOEDA == 2
DbSELECTAREA("SE1")
Dbsetorder(1)

If Dbseek(xFilial("SE1")+ SF2->F2_SERIE + SF2->F2_DOC  ) 


IF SF2->F2_VALIPI > 0 
nValor := (SE1->E1_VLM2  -  SF2->F2_VALIPI ) /  SE1->E1_TXMOEDA
Else 
nValor := SE1->E1_VLM2 /  SE1->E1_TXMOEDA
EndIf

Reclock("SE1",.F.) 


SE1->E1_VALOR := SE1->E1_VLM2
SE1->E1_SALDO := SE1->E1_VLM2
SE1->E1_VLCRUZ:= SE1->E1_VLM2
SE1->E1_VLM2  := round(nValor,2)
SE1->E1_MOEDA := 1

msUnlock()
EndIf  
EndIf 




Return   