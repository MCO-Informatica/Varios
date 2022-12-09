/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F300FLT   ºAutor  ³ Sergio Santana     º Data ³  12/04/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este ponto de entrada tem por finalidade criar um novo re  º±±
±±º          ³ gistro totalizador SISPAG, identificando registros com re  º±±
±±º          ³ torno diferente de '00' pagamento efetuado, desprezando de º±±
±±º          ³ nais registros.                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glasstech                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function F300FLT()

    LOCAL _lRet := .T.

	If ( Substr( xBuffer, 9, 5 ) = '00001' ) .And.;
	   ( TRB->TOTAL <> 0 )
   
	   _aArea   := GetArea()
	   _cFILMOV := TRB->FILMOV
	   _dData   := TRB->DATAD
	   _cNatur  := TRB->NATURE
	   _cMoeda  := TRB->MOEDA
	   _nTotal  := TRB->TOTAL

/*       aAdd( ( _oHtml:ValByName( "t1.1" ) ), ' ' ) Verificar ponto entrada para incluir os sub-total SISPAG
       aAdd( ( _oHtml:ValByName( "t1.b" ) ), ' ' )
       aAdd( ( _oHtml:ValByName( "t1.2" ) ), ' ' )
       aAdd( ( _oHtml:ValByName( "t1.3" ) ), ' ' )
       aAdd( ( _oHtml:ValByName( "t1.4" ) ), 'TOTAL' )
       aAdd( ( _oHtml:ValByName( "t1.5" ) ), ' ' )
       aAdd( ( _oHtml:ValByName( "t1.6" ) ), ' ' )
       aAdd( ( _oHtml:ValByName( "t1.7" ) ), TRANSFORM( _nTotal, '@E 99,999,999.99' ) )
       aAdd( ( _oHtml:ValByName( "t1.8" ) ), ' ' )		                     
       aAdd( ( _oHtml:ValByName( "t1.9" ) ), ' ' )
       aAdd( ( _oHtml:ValByName( "t1.a" ) ), ' ' )
       aAdd( ( _oHtml:ValByName( "t1.c" ) ), ' ' )	*/

	   RecLock( 'TRB', .F. )
	   TRB->TOTAL := 0
	   TRB->( MSUnLock() )
	   _nRecNo := TRB->( RecNo() )
	
	   RecLock( 'TRB', .T. )
	   TRB->FILMOV := SA6->A6_ZFILORI
	   TRB->DATAD  := _dData
	   TRB->NATURE := _cNatur
	   TRB->MOEDA  := _cMoeda
	   TRB->TOTAL  := _nTotal
	   TRB->( MSUnLock() )
	   TRB->( dbGoTo( _nRecNo  ) )
	   RestArea( _aArea )

	End
	
	If ('RJ' $ cRetorno) .Or.;
	   ('DV' $ cRetorno) .Or.;
	   (SE2->E2_TIPO = 'PA ' .And. ! ('00' $ cRetorno) )
	   
	   _lRet := .F.
	
	End

    _nValPag := TRB->TOTAL	

Return( _lRet )

