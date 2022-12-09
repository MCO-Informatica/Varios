#Include 'Protheus.ch'

User Function ClienteAPTHR_SZ4()
	Local _cRetorno 
	Local cCliente 
	Local cItemCC := M->Z4_ITEMCTA
	
	dbSelectArea("SC5")
	SC5->( dbSetOrder(10) )
	
	if M->Z4_ITEMCTA = "ADMINISTRACAO" .OR. M->Z4_ITEMCTA = "PROPOSTA" .OR. M->Z4_ITEMCTA = "QUALIDADE" .OR. M->Z4_ITEMCTA = "ENGENHARIA" .OR. M->Z4_ITEMCTA = "ESTOQUE" .OR. M->Z4_ITEMCTA = "OPERACOES"
	//If !SC5->( dbSeek( xFilial("SC5")+cItemCC) )
		cCliente := "000000" 
	      
	ELSE 

		If SC5->( dbSeek( xFilial("SC5")+cItemCC) )
		     cCliente := SC5->C5_CLIENTE
		     
		     
		     If   !INCLUI
				If ALLTRIM(SC5->C5_TIPO) = "N" .OR. ALLTRIM(SC5->C5_TIPO) = "C" .OR. ALLTRIM(SC5->C5_TIPO) = "P" .OR. ALLTRIM(SC5->C5_TIPO) = "I"
			     	_cRetorno := Posicione("SA1",1,xFilial("SA1")+cCliente,"SA1->A1_NOME") 
		 
			    End if     
			     
			    If ALLTRIM(SC5->C5_TIPO) = "D" .OR. ALLTRIM(SC5->C5_TIPO) = "B"
			     	_cRetorno := Posicione("SA2",1,xFilial("SA2")+cCliente,"SA2->A2_NOME")
			    End if
			
			//End if
			    
			//If EMPTY(ALLTRIM(M->C5_CLIENTE)) 
			else
			
			    _cRetorno := ""
			      
			Endif 
		    
			  
		END IF
	END IF
	
	
	
      
Return _cRetorno

