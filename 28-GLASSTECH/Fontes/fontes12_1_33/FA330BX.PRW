/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA330BX   ºAutor  ³                    º Data ³  13/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE NA COMPENSACAO CR                                       º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³ Transferencia GESTOQ                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glastech                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA330BX()

	LOCAL _aRecNo    := aBaixaSE5
	LOCAL _nPos      := 0
	LOCAL _nRecNo    := Len( aTitulos )
	LOCAL _nRecSE1   := SE1->( RecNo() )
	LOCAL _nRecSE5   := SE5->( RecNo() )
	LOCAL _nIdxSE1   := SE5->( IndexOrd() )
	LOCAL _nIdVctTit := 0
	LOCAL _nIdAdto   := 0
	LOCAL _cTitPai   := ''

    _cTitPai := SE5->E5_FILIAL
    _cTitPai += SE5->E5_CLIFOR
    _cTitPai += SE5->E5_LOJA
    _cTitPai += Substr( SE5->E5_DOCUMEN, 1, nTamTit + nTamTip )
	
	SE1->( dbSetOrder( 2 ) )
	SE1->( dbSeek( _cTitPai, .F. ) )
	SA6->( dbSeek( xFilial( 'SA6' ) + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA , .F. ) )
	_nIdAdto := int( SE1->E1_IDBOLET )
	SE1->( dbGoTo( _nRecSE1 ) )
	
    If (SE5->E5_MOTBX   = 'CMP') .And.;
       (SE5->E5_TIPODOC = 'CP')  .And.;
       ! ('NCC' $ SE5->E5_DOCUMEN)

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
	       SE5->E5_MSEXP  := DTOS(DATE())
	       SE5->( MSUnLock() )       
	
	     EndIf	     
           
    ElseIf (SE5->E5_MOTBX   = 'CMP') .And.;
           (SE5->E5_TIPODOC = 'CP')  .And.;
           ('NCC' $ SE5->E5_DOCUMEN)

	  _cData := DtoS( SE5->E5_DATA )
	  _cDta  := Substr( _cData, 1, 4 ) 
	  _cDta  += '-'
	  _cDta  += Substr( _cData, 5, 2 )
	  _cDta  += '-'
	  _cDta  += Substr( _cData, 7, 2 )
    
      _cData := DtoS( SE5->E5_DTDIGIT )
      _cMvt  := Substr( _cData, 1, 4 ) 
      _cMvt  += '-'
      _cMvt  += Substr( _cData, 5, 2 )
      _cMvt  += '-'
      _cMvt  += Substr( _cData, 7, 2 )  

	  _nResult := TCSPExec("f300SE5",;
	                       SE1->E1_IDBOLET       ,;
	                       22                    ,;
	                       _cDta                 ,;
	                       Val( SE5->E5_NUMCHEQ ),;
	                       rTrim( SE5->E5_NUMERO ) + '/' +SE5->E5_PARCELA + ' ' +rTrim( SE5->E5_BENEF ),;
	                       SE5->E5_VLJUROS       ,;
	                       SE5->E5_VALOR         ,;
	                       _cMvt                 ,;
	                       'R'				     ,;
	                       'FA330BX'             ,;
	                       SE1->E1_ORIGBD        ,;
	                       0;
	                      )

       
      If ValType( _nResult ) = 'A'
       
         SE5->E5_IDMOVI := Str( _nResult[1], 10, 0 )
         SE5->E5_ORIGBD := DTOS(DATE())
       
      Else
    
         MsgInfo('Não conformidade ao baixar o Titulo ' + rTrim( SE5->E5_NUMERO ) + '/' +SE5->E5_PARCELA + ' ' +rTrim( SE5->E5_BENEF ) + '.', 'Rotina f300SE5' )

	  EndIf

    EndIf

Return( NIL )

