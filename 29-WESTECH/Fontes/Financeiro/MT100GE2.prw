User Function MT100GE2()
	
	Local aAreaSE2     := SE2->( GetArea() )
	Local aAreaSD1     := SD1->( GetArea() )
	
	Local cPrefixo 	:= "" 
	Local cNTitulo	:= ""	 
	Local cLoja		:= ""
	Local cSerie	:= "" 
	Local cParcela	:= ""  
	Local cTipo		:= ""  	
	Local cFornece	:= "" 	
	Local cNatur	:= ""
	Local cPedido	:= ""

	Local cNum
	Local cItem
	Local cFornecedor
	Local cClasseValor
	
	Local aInd:={}
	Local cCondicao
	Local cCondicao2
	Local bFiltraBrw
	Local bFiltraBrw2
	
	cNum 			:= SD1->D1_DOC
	cSerie			:= SD1->D1_SERIE
	cFornece		:= SD1->D1_FORNECE
	cLoja		 	:= SD1->D1_LOJA
	cItem			:= SD1->D1_ITEMCTA
	cPedido			:= SD1->D1_PEDIDO
	//cNatur			:= CNATUREZA

	//Localiza classe de valor
	dbSelectArea("SC5")
	SC5->( dbSetOrder(10) ) 
	If SC5->( dbSeek( xFilial("SC5")+cItem) )
		cClasseValor  := SC5->C5_XXCLVL
	EndIf

	dbSelectArea("SE2")
	SE2->( dbGoTop() )
	SE2->(dbSetOrder(20) ) 

	if SE2->( dbSeek( xFilial("SE2")+cNum+cFornece) ) //  SE2->E2_NUM == cNum .AND. SE2->E2_FORNECE == cFornece 
	                
	                While SE2->( ! EOF() ) 
	                	
	                
	                	if SE2->E2_NUM == cNum .AND. SE2->E2_FORNECE == cFornece
	                			//msginfo("TITULO 1 " + cNum + " " + cNatur + " " + cItem )
	                			
	                			
	                                RecLock("SE2",.F.)            
	                                      SE2->E2_XXIC 	:= cItem
	                                      SE2->E2_XXCLVL := cClasseValor
	                                      SE2->E2_XNOC	:= cPedido
	                                               
	                                MsUnlock() 
	                                 
	                                cPrefixo  	:= SE2->E2_PREFIXO
									cNTitulo  	:= SE2->E2_NUM
									cParcela  	:= SE2->E2_PARCELA
									cTipo  		:= SE2->E2_TIPO
									cFornece 	:= SE2->E2_FORNECE
									cLoja		:= SE2->E2_LOJA
									cNatur  	:= SE2->E2_NATUREZ
	                    endif          	 
	                    SE2->( dbSkip() )
	                               
	                EndDo
	endif 
	//msginfo("TITULO 2 "+ cNum + " " + cNatur + " " + cItem) 

	dbSelectArea("SD1")
	SD1->( dbGoTop() )
	SD1->(dbSetOrder(25) ) 
	
	If SD1->( dbSeek(xFilial("SD1")+cNTitulo+cFornece+cLoja) )
	
		While SD1->( ! EOF() ) 
		                		
			if SD1->D1_DOC == cNTitulo    ;
		        .AND. SD1->D1_FORNECE  == cFornece ;
		        .AND. SD1->D1_LOJA  == cLoja
		        
		        //msginfo("TITULO 3 " + cNTitulo + " " + cNatur + " " + cItem )
		               
		        RecLock("SD1",.F.)            
		        SD1->D1_XNATURE := cNatur
		        MsUnlock()  
		    endif
		    SD1->(dbSkip())                             
		EndDo
	
	EndIf
	
	SD1->(DbClearFilter())
	
	RestArea(aAreaSD1)
	RestArea(aAreaSE2) 
	
Return ( nil )


