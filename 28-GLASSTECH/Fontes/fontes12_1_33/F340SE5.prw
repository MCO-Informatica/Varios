User Function F340SE5()
Local _nPos := 0
LOCAL _aRecSE5 := ParamIxb[ 1 ]
LOCAL _nLen    := Len( _aRecSE5 )
LOCAL _nRecSE2 := SE2->( RecNo() )
LOCAL _nRecSE5 := SE5->( RecNo() )

For _nPos := 1 To _nLen
    
    SE5->( dbGoTo( _aRecSE5[ _nPos ] ) )
    
    If SE5->E5_TIPODOC = 'CP'
    
       If SE2->( dbSeek( SE5->E5_FILORIG + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA, .F. ) )
       
		  _cData := DtoS( SE5->E5_DTDISPO )
		  _cDta  := Substr( _cData, 1, 4 ) 
		  _cDta  += '-'
		  _cDta  += Substr( _cData, 5, 2 )
		  _cDta  += '-'
		  _cDta  += Substr( _cData, 7, 2 )
		  
		  _nResult := TCSPExec("f300SE5",;
							   Val( SE2->E2_IDMOV ),;
							   30				   ,; // Adiantamento fornecedor Nacional
							   _cDta     ,;
							   0				   ,;
							   rTrim( SE2->E2_NUM ) + '/' +SE2->E2_PARCELA + ' ' +rTrim( SE2->E2_NOMFOR ),;
							   SE5->E5_VLJUROS  ,;
							   SE5->E5_VALOR,;
							   _cDta        ,;
							   'P',;
							   'F340SE5';
							  )
       
		  If ValType( _nResult ) <> 'U'

			 If _nResult[1] <> 0 
       
				SE5->E5_IDMOVI := Str( _nResult[1], 10, 0 )

			End
       
		  Else
    
			 MsgInfo('Não conformidade ao baixar o Titulo ' + rTrim( SE2->E2_NUM ) + '/' + SE2->E2_PARCELA + ' ' +rTrim( SE2->E2_NOMFOR ) + '.', 'Rotina F340SE5' )

		  End       
       
	   End
    
    End

Next

SE2->( dbGoTo( _nRecSE2 ) ) 
SE5->( dbGoTo( _nRecSE5 ) )

Return( NIL )