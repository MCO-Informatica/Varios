// inativado nao utilizar

User Function F330SE5()

	LOCAL _aRecNo    := aBaixaSE5
	LOCAL _nPos      := 0
	LOCAL _nRecNo    := Len( aBaixaSE5 )
	LOCAL _nRecSE1   := SE1->( RecNo() )
	LOCAL _nRecSE5   := SE5->( RecNo() )
	LOCAL _nIdxSE1   := SE5->( IndexOrd() )
	LOCAL _nIdVctTit := 0
	LOCAL _nIdAdto   := 0
	LOCAL _cTitPai   := ''
	
	//Este PE foi removido do projeto para a 12.1.17 pois estava sendo executado em duplicidade.
	Return
	
    _cTitPai := SE5->E5_FILIAL
    _cTitPai += SE5->E5_CLIFOR
    _cTitPai += SE5->E5_LOJA
    _cTitPai += Substr( SE5->E5_DOCUMEN, 1, nTamTit + nTamTip )
	
	SE1->( dbSetOrder( 2 ) )

	SE1->( dbSeek( _cTitPai, .F. ) )

	SA6->( dbSeek( xFilial( 'SA6' ) + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA , .F. ) )
	
	_nIdAdto := int( SE1->E1_IDBOLET )
	
	If _nRecNo = 0
	
	   _aRecNo := { _nRecSE5 }
	   _nRecNo := 1
	
	End
	
	For _nPos := 1 To _nRecNo
	
		SE5->( dbGoTo( _aRecNo[ _nPos ] ) )

        If (SE5->E5_MOTBX   = 'CMP') .And.;
           (SE5->E5_TIPODOC = 'CP')

		   SE1->( dbSeek( SE5->E5_FILORIG + SE5->E5_CLIFOR + SE5->E5_LOJA + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO, .F. ) )
           _nIdVctTit := SE1->E1_IDBOLET

		   _nResult := TCSPExec("f300SE5Adt",;
		                        SA6->A6_IDCONTA,;
		                        Val(SE5->E5_CLIFOR),;
		                        SE5->E5_DTDISPO, ;
		                        SE5->E5_VALOR,;
		                        'Compensacao ' + rTrim( SE5->E5_NUMERO ) + '/' +SE5->E5_PARCELA + ' ' +rTrim( SE5->E5_BENEF ),;
		                        cUserName,;
		                        SE5->E5_NUMERO + SE5->E5_PARCELA,;
		                        'D',;
		                        SE5->E5_FILORIG,;
		                        'C',;
						        _nIdAdto,;
						        _nIdVctTit,;
						        SE1->E1_ORIGBD;
	                           )
	
	       If ValType( _nResult ) = 'A'
	
	          RecLock( 'SE5', .F. )
	          SE5->E5_IDMOVI := Str( _nResult[ 1 ], 10, 0 )
	          SE5->( MSUnLock() )       
	
	       EndIf	     
           
        EndIf
	    
	Next

    SE5->( dbGoTo( _nRecSE5 ) )
    SE1->( dbGoTo( _nRecSE1 ) )    
    aBaixaSE5 := {}

Return( NIL )

