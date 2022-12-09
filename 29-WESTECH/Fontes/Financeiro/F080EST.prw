#include 'protheus.ch'
#include 'parmtype.ch'

user function F080EST()

// MOV. BANCARIO BAIXA A RECEBER
Local aAreaSE2     := SE2->( GetArea() )
Local aAreaSE5     := SE5->( GetArea() )

Local cPrefixo   	:= SE2->E2_PREFIXO
Local cNumero 		:= SE2->E2_NUM
Local cParcela    	:= SE2->E2_PARCELA
Local cTipo			:= SE2->E2_TIPO
Local cCliFor		:= SE2->E2_FORNECE
Local cLoja			:= SE2->E2_LOJA
Local cItemCC		:= SE2->E2_XXIC		

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


RestArea(aAreaSE2)
RestArea(aAreaSE5) 

return