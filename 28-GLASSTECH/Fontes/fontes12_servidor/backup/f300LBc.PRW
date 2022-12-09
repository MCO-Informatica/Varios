
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f300LBc   ºAutor  ³Sérgio Santana      º Data ³  20/08/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza paramentros com base na conta corrente informada  º±±
±±º          ³ no cabecalho do arquivo de retorno SISPAG                  º±±
±±º          ³ Utilizada na validação do parametro afi300.04              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glasstech                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function f300LBc( _pTipo )

	LOCAL  _cBco     := Space( Len( MV_PAR06 ) )
	LOCAL  _cAge     := Space( Len( MV_PAR07 ) )
	LOCAL  _cConta   := Space( Len( MV_PAR08 ) )
	LOCAL  _cSub     := Space( Len( MV_PAR09 ) )
	LOCAL  _lRet     := .F.
	PUBLIC _cDtHr    := Space( 20 )
	Public lFIDC	 := !IsInCallStack("FINA300") .AND. MsgYesNo("Arquivo de retorno se refere a uma FIDC?","FDIC")
	Public lFDVldVl	 := lFIDC .AND. MsgYesNo("Deseja validar valores para esta FIDC?","FDIC")
	
	If ! ( File( rTrim(MV_PAR04) ) )

		Help(" ",1,"NOARQPAR")
    
	Else
		If lFIDC
	    	MV_PAR05	:= "BRDFAC.RET"
	    	Return .T.
	    EndIf
	    
		_nHdl := fOpen( MV_PAR04, 0 )
		fSeek( _nHdl, 0, 0 )
	
		_cBuffer := Space(85)                               
		fRead( _nHdl, @_cBuffer, 241 )
		
		If _pTipo = 'P'
		
    	   _cBco := Substr( _cBuffer, 1, 3 )
           _cAge   := StrZero( Val( Substr( _cBuffer, 53, 5 ) ), 4, 0) + ' '
           _cConta := StrZero( Val( Substr( _cBuffer, 59,12 ) ), 5, 0) + Space( 5 )
           _cDtHr  := transform( Substr( _cBuffer, 144, 12 ), '@R 99/99/9999 99:99' )
          
        Else

     	   _cBco := Substr( _cBuffer, 77, 3 )
		   _cAge   := StrZero( Val( Substr( _cBuffer, 27, 4 ) ), 4, 0 ) + ' '

	       If _cBco = '341'
	          MV_PAR05 := 'itau.ret' + Space( Len(MV_PAR05) - 8 )
              _cConta := StrZero( Val( Substr( _cBuffer, 31, 7 ) ), 5, 0 ) + Space( 5 )
	       ElseIf _cBco = '237'
	          MV_PAR05 := 'bradesco.ret' + Space( Len(MV_PAR05) - 12 )
    		   _cConta := StrZero( Val( Substr( _cBuffer, 39, 7 ) ), 5, 0 ) + Space( 5 )
	       End
	       
	       _cDtHr := ''

        End
			
	    fClose( _nHdl )	 
	    	    
	    SEE->( dbSeek( xFilial( 'SEE' ) + _cBco + _cAge + _cConta, .T. ) )
	    
	    If (SEE->EE_CODIGO = _cBco)  .And.;
	       (SEE->EE_AGENCIA = _cAge) .And.;
	       (SEE->EE_CONTA = _cConta)
	       
	       If Empty( SEE->EE_CODOFI )

	          _cAge   := SEE->EE_AGENCIA
	          _cConta := SEE->EE_CONTA
	          _lRet   := .T.

           Else	       
	       
			  _cAge   := SEE->EE_AGEOFI 
			  _cConta := SEE->EE_CTAOFI
              SEE->( dbSeek( xFilial( 'SEE' ) + _cBco + _cAge + _cConta, .T. ) )

			  If (SEE->EE_CODIGO  = _cBco) .And.;
			     (SEE->EE_AGENCIA = _cAge) .And.;
			     (SEE->EE_CONTA   = _cConta)
			     
			     _lRet := .T.

              Else

				 _cBco := '   '
				 MsgInfo( 'Conta Corrente não configurada!', 'f300lbc' )

			  End

           End

	        _cSub   := SEE->EE_SUBCTA
	    
	    Else
	    
	       _cBco := '   '
	       MsgInfo( 'Conta Corrente não configurada!', 'f300lbc' )
	
	    End 

    End
    
    MV_PAR06 := _cBco
    MV_PAR07 := _cAge
    MV_PAR08 := _cConta
    MV_PAR09 := _cSub

    SA6->( dbSeek( xFilial( 'SA6' ) + _cBco + _cAge + _cConta, .F. ) )
    
    OpenSM0( cEmpAnt + Iif(Empty(SA6->A6_ZFILORI), cFilAnt, SA6->A6_ZFILORI) )

Return( _lRet )