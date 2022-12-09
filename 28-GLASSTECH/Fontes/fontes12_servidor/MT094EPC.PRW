/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT094EPC ºAutor  ³Sérgio Santana      º Data ³  22/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de Entrada para excluir o pedido de compra via apro º±±
±±º          ³  vacao do pedido de compra.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Glasstech                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION MT094EPC()
		
	If SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE" .Or. SCR->CR_TIPO == "IP"
	
	   _aArea := SCR->( GetArea() )
	
	   dbSelectArea("SC7")
	   dbSetOrder(1)
	
	   If MsSeek( xFilial("SC7") + Substr( SCR->CR_NUM, 1, Len( SC7->C7_NUM ) ) )
	
	      _nRec    := SC7->( RecNo() )
	      _cFilial := SC7->C7_FILIAL
	      _cPedido := SC7->C7_NUM
	      _cCompr  := SC7->C7_USER
	      
	      While _cFilial = SC7->C7_FILIAL .And. _cPedido = SC7->C7_NUM .And. ! ( SC7->( Eof() ) )

	         RecLock( 'SC7', .F. )
	         SC7->C7_USER := __cUserId
	         SC7->( MSUnLock() )	         
	         SC7->( dbSkip() )

	      End

	      SC7->( dbGoTo( _nRec ) )

	      MATA120(NIL,NIL,NIL,5)

	      SC7->( dbGoTo( _nRec ) )
	      
	      While _cFilial = SC7->C7_FILIAL .And. _cPedido = SC7->C7_NUM .And. ! ( SC7->( Eof() ) )

	         RecLock( 'SC7', .F. )
	         SC7->C7_USER := _cCompr
	         SC7->( MSUnLock() )	         
	         SC7->( dbSkip() )

	      End
	
	   End
	   
	   RestArea( _aArea )
	
	End
	
Return()