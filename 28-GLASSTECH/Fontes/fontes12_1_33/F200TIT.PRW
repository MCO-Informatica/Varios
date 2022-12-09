#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F200TIT   ºAutor  ³Sérgio Santana      º Data ³  20/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina utiliza a Store Procedure f300SE5 para realiazação  º±±
±±º          ³ das baixas sistema GESTOQ ambientes TPCP e BV.             º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glasstech                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F200TIT()

    LOCAL _cData   := ''
    LOCAL _cDta    := ''
    LOCAL _nResult := NIL
    
    _cData := DtoS( dDataCred )
    _cDta  := Substr( _cData, 1, 4 ) 
    _cDta  += '-'
    _cDta  += Substr( _cData, 5, 2 )
    _cDta  += '-'
    _cDta  += Substr( _cData, 7, 2 )
    
    _cData := DtoS( dDataBase )
    _cMvt  := Substr( _cData, 1, 4 ) 
    _cMvt  += '-'
    _cMvt  += Substr( _cData, 5, 2 )
    _cMvt  += '-'
    _cMvt  += Substr( _cData, 7, 2 )  
    
    If ( nValRec = 0 ) .Or.;
       Empty( DtoS( dDataCred ) )
       
       Return( NIL )
    
    EndIf

    If ( SE5->E5_PREFIXO  = SE1->E1_PREFIXO ) .And.;
       ( SE5->E5_NUMERO   = SE1->E1_NUM     ) .And.;       
       ( SE5->E5_PARCELA  = SE1->E1_PARCELA ) .And.;
       ( SE5->E5_CLIFOR   = SE1->E1_CLIENTE )

       If (SE5->E5_TIPO = 'RA ') .Or.; // Inclui Pré-NOTA como adiantamento GESTOQ
          (SE5->E5_TIPO = 'PRE')

	      _nResult := TCSPExec("f300SE5Adt"        ,;
	                           SA6->A6_IDCONTA     ,;
	                           Val(SE1->E1_CLIENTE),;
	                           _cMvt               ,;
	                           nValRec             ,;
	                           rTrim( SE1->E1_NUM ) + '/' +SE1->E1_PARCELA + ' ' +rTrim( SE1->E1_NOMCLI ),;
	                           cUserName           ,;
	                           SE5->E5_NUMERO + SE5->E5_PARCELA,;
	                           'C'            ,;
	                           SE5->E5_FILORIG,;
	                           'A'            ,;
	                           0              ,;
	                           0			  ,;
	                           SE1->E1_ORIGBD ,;
                               0,;
                               0,;
                               "")

           If ValType( _nResult ) = 'A'

              RecLock( 'SE1', .F. )
		      SE1->E1_IDBOLET := _nResult[ 2 ]
		      SE1->E1_TIPO    := 'RA'
		      SE1->E1_SALDO   := nValRec
		      SE1->E1_VALLIQ  := 0
		      SE1->E1_MSEXP   := DTOS(DATE())
              SE1->( MSUnLock() )       

              If ValType( _oProcess ) <> 'U' // Dispara workflow contendo o status da pré-nota

                 aAdd( ( _oHtml:ValByName( "t1.1" ) ), ' ' )
                 aAdd( ( _oHtml:ValByName( "t1.b" ) ), ' ' )
                 aAdd( ( _oHtml:ValByName( "t1.2" ) ), ' ' )
                 aAdd( ( _oHtml:ValByName( "t1.3" ) ), ' ' )
                 aAdd( ( _oHtml:ValByName( "t1.4" ) ), _nResult[ 3 ] )
                 aAdd( ( _oHtml:ValByName( "t1.5" ) ), ' ' )
                 aAdd( ( _oHtml:ValByName( "t1.6" ) ), ' ' )
                 aAdd( ( _oHtml:ValByName( "t1.7" ) ), ' ' )
                 aAdd( ( _oHtml:ValByName( "t1.8" ) ), ' ' )		                     
                 aAdd( ( _oHtml:ValByName( "t1.9" ) ), ' ' )
                 aAdd( ( _oHtml:ValByName( "t1.a" ) ), ' ' )
                 aAdd( ( _oHtml:ValByName( "t1.c" ) ), ' ' ) 

              EndIf                 

           EndIf

       Else // Baixa Título GESTOQ

    	  _nResult := TCSPExec("f300SE5",;
	                           SE1->E1_IDBOLET,;
	                           SA6->A6_IDCONTA,;
	                           _cDta,;
	                           0,;
	                           rTrim( SE1->E1_NUM ) + '/' +SE1->E1_PARCELA + ' ' +rTrim( SE1->E1_NOMCLI ),;
	                           nJuros,;
	                           nValRec,;
	                           _cMvt, ;
	                           'R', ;
	                           SE5->E5_ARQCNAB,;
	                           SE1->E1_ORIGBD;
                              )
       EndIf

    EndIf
 
    If ValType( _nResult ) = 'A'

       RecLock( 'SE5', .F. )
       SE5->E5_FILIAL  := SA6->A6_ZFILORI
       SE5->E5_FILORIG := SE1->E1_FILIAL
       SE5->E5_ARQCNAB := Upper( rTrim( Substr( mv_par04, rAt( '\', mv_par04 ) + 1 ) ) )
       SE5->E5_IDMOVI  := Str( _nResult[ 1 ], 10, 0 )
       SE5->E5_MSEXP   := DTOS(DATE())      

       If SE5->E5_TIPO = 'PRE'

          SE5->E5_TIPO    := 'RA'
          SE5->E5_TIPODOC := 'RA'
          SE5->E5_RECPAG  := 'R' 
          
          RecLock( 'TRB', .F. )
          TRB->TOTAL -= SE5->E5_VALOR
          TRB->( MSUnLock() )

/*		  RecLock( 'FK5', .F. )
		  FK5->FK5_FILIAL := SA6->A6_ZFILORI
 		  FK5->FK5_FILORI := SE1->E1_FILIAL
 		  FK5->FK5_TPDOC  := 'RA'
 		  FK5->( MSUnLock() ) */

       EndIf

       SE5->( MSUnLock() )       

    Else
       
       MsgInfo('Não conformidade ao baixar o Titulo ' + rTrim( SE1->E1_NUM ) + '/' +SE1->E1_PARCELA + ' ' + rTrim( SE1->E1_NOMCLI ) + '.', 'Rotina f200Tit' )

	EndIf

    If ( Valtype( _oHtml ) <> 'U' )
       
       If Val( SE5->E5_IDMOVI ) <> 0

          _oHtml:aListTables[ 1 ][  9 ][ 2 ][ _nPosList ] := TRANSFORM( SE1->E1_SALDO  ,'@E 99,999,999.99' ) 

          If ValType( _nResult ) = 'A'          

             _oHtml:aListTables[ 1 ][ 11 ][ 2 ][ _nPosList ] := iif( _nResult[1] = 0, ' ', Alltrim( Str( _nResult[1], 10, 0 ) ) )

          EndIf

          _nValPagto += nValRec

/*       Else

          aAdd( ( _oHtml:ValByName( "t1.a" )), 'Baixa GESTOQ não realizada' )*/      
          
       EndIf

    EndIf

Return( NIL )
