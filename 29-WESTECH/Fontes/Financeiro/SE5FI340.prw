#Include 'Protheus.ch'

User Function SE5FI340()
/*
	Local cPrefixo   	:= SE2->E2_PREFIXO
	Local cNumero 		:= SE2->E2_NUM
	Local cParcela    	:= SE2->E2_PARCELA
	Local cTipo			:= SE2->E2_TIPO
	Local cCliFor		:= SE2->E2_FORNECE
	Local cBenef		:= Posicione("SA2",1,xFilial("SA2") + cCliFor,"A2_NREDUZ")
	Local cLoja			:= SE2->E2_LOJA
	
	Local cItemCC		:= SE2->E2_XXIC	
	Local dData			:= dDatabase
	Local cTPDESC		:= "I"

	
	Local cCamposE5 := PARAMIXB[1]
	Local oSubModel := PARAMIXB[2]
	
	
If oSubModel:cID == "FK2DETAIL"


               cCamposE5 := "{{ 'E5_XXIC', '" + cItemCC + "'},{ 'E5_TPDESC', '" + cTPDESC + "'},{ 'E5_NUMERO', '" + cNumero + "'},{ 'E5_PREFIXO', '" + cPrefixo + "'},{ 'E5_TIPO', '" + cTipo + "'},{ 'E5_CLIFOR', '" + cCliFor + "'},{ 'E5_FORNECE', '" + cCliFor + "'},{ 'E5_BENEF', '" + cBenef + "'},{ 'E5_LOJA', '" + cLoja + "'},{ 'E5_DTDIGIT', '" + dtos(dData) + "'}"
              

EndIf

Return cCamposE5 

*/


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