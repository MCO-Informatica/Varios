#Include 'Protheus.ch'

User Function ConsIC_Cli()
	Local _cRetorno
	Local cCliente 
	Local cItemCC := M->Z4_ITEMCTA
	
	if M->Z4_ITEMCTA = "ADMINISTRACAO" .OR. M->Z4_ITEMCTA = "PROPOSTA" .OR. M->Z4_ITEMCTA = "QUALIDADE" .OR. M->Z4_ITEMCTA = "ENGENHARIA" .OR. M->Z4_ITEMCTA = "ESTOQUE" .OR. M->Z4_ITEMCTA = "OPERACOES"
   //	If !SC5->( dbSeek( xFilial("SC5")+cItemCC) )
		_cRetorno := "000000"  
	ENDIF
	
	dbSelectArea("SC5")
	SC5->( dbSetOrder(10) ) 

	If SC5->( dbSeek( xFilial("SC5")+cItemCC) )
	     _cRetorno := SC5->C5_CLIENTE
		
	ELSE
		
		if M->Z4_ITEMCTA = "ADMINISTRACAO" .OR. M->Z4_ITEMCTA = "PROPOSTA" .OR. M->Z4_ITEMCTA = "QUALIDADE" .OR. M->Z4_ITEMCTA = "ENGENHARIA" .OR. M->Z4_ITEMCTA = "ESTOQUE" .OR. M->Z4_ITEMCTA = "OPERACOES"
	   //	If !SC5->( dbSeek( xFilial("SC5")+cItemCC) )
			_cRetorno := "000000" 
		elseIf CTD->( dbSeek( xFilial("CTD")+cItemCC) )
				_cRetorno := Alltrim(CTD->CTD_XCLIEN)
			 
		ELSE
			msginfo ( "Pedido de Venda não cadastrado." )
			return .F.
		ENDIF
	   
	END IF 
                  
 	

Return _cRetorno


