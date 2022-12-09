#Include 'Protheus.ch'

User Function SE5FI330()


Local aAreaSE1     := SE1->( GetArea() )
Local aAreaSE5     := SE5->( GetArea() )

Local cPrefixo   	:= SE1->E1_PREFIXO
Local cNumero 		:= SE1->E1_NUM
Local cParcela    	:= SE1->E1_PARCELA
Local cTipo			:= SE1->E1_TIPO
Local cCliFor		:= SE1->E1_CLIENTE
Local cLoja			:= SE1->E1_LOJA
Local cItemCC		:= SE1->E1_XXIC		


dbSelectArea("SE5")
SE5->( dbGoTop() )
SE5->(dbSetOrder(7) ) 

If SE5->( dbSeek(xFilial("SE5")+cPrefixo+cNumero+cParcela+cTipo+cCliFor+cLoja) )

                While SE5->( ! EOF() ) 	.AND. SE5->E5_PREFIXO == cPrefixo    ;
                           				.AND. SE5->E5_NUMERO  == cNumero     ;
                           				.AND. SE5->E5_PARCELA  == cParcela	;
                           				.AND. SE5->E5_TIPO  == cTipo	;
                           				.AND. SE5->E5_CLIFOR  == cCliFor	;
                           				.AND. SE5->E5_LOJA  == cLoja	;
                
                               RecLock("SE5",.F.)            
                                               SE5->E5_XXIC := cItemCC
                               MsUnlock()  
 
                               SE5->( dbSkip() )
                EndDo

EndIf

RestArea(aAreaSE1)
RestArea(aAreaSE5) 

Return ( NIL )


