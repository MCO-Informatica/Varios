#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F200TIT  ³Autor  ³Giovanni Rodrigues   ³ Data ³  01/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pto de Entrada para tratar o historico baixa CNAB           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CertiSign Certificados                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
*/

User Function F200TIT() 

Local aArea:=GetArea()

If (!empty(SE1->E1_PEDGAR).OR. !empty(SE1->E1_XNPSITE)) .AND. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO
		
		RecLock("SE5",.F.)
		
		If (!EMPTY(SE1->E1_PEDGAR) .AND. EMPTY(SE1->E1_XNPSITE))  //Tratamento para novo meio de pagamento - Rene Lopes
			SE5->E5_HISTOR := "PEDGAR  "+SE1->E1_PEDGAR 
		Elseif (EMPTY(SE1->E1_PEDGAR) .AND. !EMPTY(SE1->E1_XNPSITE))
	   		SE5->E5_HISTOR := "PEDSITE "+SE1->E1_XNPSITE
	 	Elseif (!EMPTY(SE1->E1_PEDGAR) .AND. !EMPTY(SE1->E1_XNPSITE))  
	 		SE5->E5_HISTOR := "PEDSITE "+SE1->E1_XNPSITE
	 	Endif  

			//SE5->E5_HISTOR:= IF(!EMPTY(SE1->E1_PEDGAR),"PEDGAR  "+SE1->E1_PEDGAR , "PEDSITE "+ SE1->E1_XNPSITE)  */
		MsUnLock()
		
Endif     

RestArea(aArea)
Return         