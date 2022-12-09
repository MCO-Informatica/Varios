#Include 'Protheus.ch'

User Function CONSIC_NOMECLI()
	Local _cRetorno
	Local cCliente 
	Local cItemCC := M->Z4_ITEMCTA
	
	dbSelectArea("SC5")
	SC5->( dbSetOrder(10) ) 
 
 	if M->Z4_ITEMCTA = "ADMINISTRACAO" .OR. M->Z4_ITEMCTA = "PROPOSTA" .OR. M->Z4_ITEMCTA = "QUALIDADE" .OR. M->Z4_ITEMCTA = "ENGENHARIA" .OR. M->Z4_ITEMCTA = "ESTOQUE" .OR. M->Z4_ITEMCTA = "OPERACOES"
   //	If !SC5->( dbSeek( xFilial("SC5")+cItemCC) )
		cCliente := "000000"  
	
 	else
		If SC5->( dbSeek( xFilial("SC5")+cItemCC) )
		     cCliente := SC5->C5_CLIENTE
		
	
		ELSE
			if M->Z4_ITEMCTA == "ADMINISTRACAO" .OR. M->Z4_ITEMCTA == "PROPOSTA" .OR. M->Z4_ITEMCTA == "QUALIDADE" .OR. M->Z4_ITEMCTA == "ENGENHARIA" .OR. M->Z4_ITEMCTA == "ESTOQUE" .OR. M->Z4_ITEMCTA == "OPERACOES"
		   //	If !SC5->( dbSeek( xFilial("SC5")+cItemCC) )
				cCliente := "000000"  
			elseIf CTD->( dbSeek( xFilial("CTD")+cItemCC) )
				cCliente := CTD->CTD_XCLIEN
			ELSE
				msginfo ( "Pedido de Venda não cadastrado." )
				return .F.
			ENDIF
		
		end if
	
	ENDIF
	
	dbSelectArea("SA1")
	SA1->( dbSetOrder(1) )
	If SA1->( dbSeek( xFilial("SA1")+cCliente) )
	     _cRetorno := SA1->A1_NREDUZ 
	end if
	
Return _cRetorno
