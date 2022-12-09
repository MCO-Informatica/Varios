
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F300FIL   ºAutor  ³Sérgio Santana      º Data ³  21/08/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Extrai IDCNAB do arquivo de retorno para realização da     º±±
±±º          ³ baixa independente da filial.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F300FIL()

    LOCAL _cDescOco := ''
    LOCAL _nIdx     := 0
    LOCAL _cIdCNAB  := 0

    _nIdx := SE2->( IndexOrd() )
    
    If _nIdx <> 13
       SE2->( dbSetOrder( 13 ) )
    End
    
    If Substr( xBuffer, 14, 1 ) = 'O'

       _cIdCNAB := Substr( xBuffer, 175, 10 )

    ElseIf Substr( xBuffer, 14, 1 ) = 'A'

       _cIdCNAB := Substr( xBuffer, 74, 10 )

    ElseIf Substr( xBuffer, 14, 1 ) = 'J'    

       _cIdCNAB := Substr( xBuffer, 183, 10 )

    ElseIf Substr( xBuffer, 14, 1 ) = 'N'

       _cIdCNAB := Substr( xBuffer, 196, 10 )
       aValores[ 10 ] := Substr( xBuffer, 231, 2 )

       If ( Substr( xBuffer, 231, 2 ) = '00' )

          If ( Substr( xBuffer, 18, 2 ) = '01' ) // gps

             cData  := Substr( xBuffer, 100, 8 )
             dBaixa := CtoD( Substr( xBuffer, 100, 2 ) + '/' + Substr( xBuffer, 102, 2 ) + '/' + Substr( xBuffer, 104, 4 ) )
             cValPag  := Substr( xBuffer, 86, 14 )

          ElseIf ( Substr( xBuffer, 18, 2 ) = '02' ) // darf                                             

             cData  := Substr( xBuffer, 128, 8 )
             dBaixa := CtoD( Substr( xBuffer, 128, 2 ) + '/' + Substr( xBuffer, 130, 2 ) + '/' + Substr( xBuffer, 132, 4 ) )
             cValPag  := Substr( xBuffer, 106, 14 )

          ElseIf ( Substr( xBuffer, 18, 2 ) = '03' ) // darf simples

             cData  := Substr( xBuffer, 128, 8 )
             dBaixa := CtoD( Substr( xBuffer, 128, 2 ) + '/' + Substr( xBuffer, 130, 2 ) + '/' + Substr( xBuffer, 132, 4 ) )
             cValPag  := Substr( xBuffer, 106, 14 )

          ElseIf ( Substr( xBuffer, 18, 2 ) = '04' ) // darj

             cData  := Substr( xBuffer, 142, 8 )
             dBaixa := CtoD( Substr( xBuffer, 142, 2 ) + '/' + Substr( xBuffer, 144, 2 ) + '/' + Substr( xBuffer, 146, 4 ) )
             cValPag  := Substr( xBuffer, 120, 14 )

		  ElseIf ( Substr( xBuffer, 18, 2 ) = '05' ) // icms

		     cData  := Substr( xBuffer, 147, 8 )
		     dBaixa := CtoD( Substr( xBuffer, 147, 2 ) + '/' + Substr( xBuffer, 149, 2 ) + '/' + Substr( xBuffer, 151, 4 ) )
             cValPag  := Substr( xBuffer, 125, 14 )

		  ElseIf ( Substr( xBuffer, 18, 2 ) $ '07/08' ) // ipva/dpvat

		     cData  := Substr( xBuffer, 117, 8 )
		     dBaixa := CtoD( Substr( xBuffer, 117, 2 ) + '/' + Substr( xBuffer, 119, 2 ) + '/' + Substr( xBuffer, 121, 4 ) )
             cValPag  := Substr( xBuffer, 95, 14 )

		  ElseIf ( Substr( xBuffer, 18, 2 ) = '11' ) // fgts/gfip

		     cData  := Substr( xBuffer, 144, 8 )
		     dBaixa := CtoD( Substr( xBuffer, 144, 2 ) + '/' + Substr( xBuffer, 146, 2 ) + '/' + Substr( xBuffer, 148, 4 ) )
             cValPag  := Substr( xBuffer, 152, 14 )

          End

          aValores[ 7 ] := Val( cValPag )
          aValores[ 7 ] /= 100
          nValPgto := aValores[ 7 ]
          aValores[ 5 ] := dBaixa

       End

    End    

	If ( SE2->( dbSeek( _cIdCNAB, .F. ) ) )

       nRecTit := SE2->( RecNo() )

    Else

       nRecTit := 0    

    End

	If _nIdx <> 13
	   SE2->( dbSetOrder( _nIdx ) )
	End
    
    _nValPag := Val( cValPag )
    _nValPag /= 100

    If ( Type( '_oProcess' ) = 'U' )

       PUBLIC _oProcess
       PUBLIC _oHtml
       PUBLIC _nValPagto
       PUBLIC _nLenList

       _oProcess := TWFProcess():New( "000003", "Retorno CNAB SISPAG" )
       _oProcess:NewTask( "Processamento", "\WORKFLOW\WFCNABRet.htm" )
       _oProcess:cSubject := 'Baixas Contas a Pagar'
       _oProcess:bReturn  := "U_WFW120P( 1 )"
       _oProcess:bTimeOut := {{"U_WFW120P( 2 )", 30, 0, 5 }}
       _oHtml := _oProcess:oHtml
       _oHtml:ValByName( "empresa", rTrim( SM0->M0_NOMECOM ) )
       _oHtml:ValByName( "tipo", 'SISPAG ' + Substr( MV_PAR04, RAt( '\', MV_PAR04 ) + 1 ) + ' ' + if( Type('_cDtHr') <> 'U',_cDtHr,'') )
       _oHtml:ValByName( "conta", MV_PAR06 + '-' + rtrim(MV_PAR07) + '-' + rtrim(MV_PAR08) )
    
       _nValPagto := 0
       _nLenList  := 0

    End
        
    aAdd( ( _oHtml:ValByName( "t1.1" ) ), SE2->E2_FILIAL )
    aAdd( ( _oHtml:ValByName( "t1.b" ) ), SE2->E2_TIPO )
    aAdd( ( _oHtml:ValByName( "t1.2" ) ), SE2->E2_NUM )
    aAdd( ( _oHtml:ValByName( "t1.3" ) ), rtrim(SE2->E2_PARCELA) )
    aAdd( ( _oHtml:ValByName( "t1.4" ) ), if( Empty(SE2->E2_NOMFOR) , 'T I T U L O   E X C L U I D O', rtrim(SE2->E2_NOMFOR) ) )
    aAdd( ( _oHtml:ValByName( "t1.5" ) ), TRANSFORM( SE2->E2_EMISSAO,'@DE 99/99/9999' ) )
    aAdd( ( _oHtml:ValByName( "t1.6" ) ), TRANSFORM( SE2->E2_VENCREA,'@DE 99/99/9999' ) )
    aAdd( ( _oHtml:ValByName( "t1.7" ) ), TRANSFORM( _nValPag       ,'@E 99,999,999.99' ) )
    aAdd( ( _oHtml:ValByName( "t1.8" ) ), TRANSFORM( SE2->E2_SALDO  ,'@E 99,999,999.99' ) )		                     
    aAdd( ( _oHtml:ValByName( "t1.9" ) ), _cIdCNAB )
    aAdd( ( _oHtml:ValByName( "t1.c" ) ), ' ' )
    _nLenList := Len( _oHtml:aListTables[1][1][2] )

    _cRej    := alltrim( Substr( aValores[ 16 ], 231, 10 ) )
    _nLen    := Len( Alltrim(  _cRej ) )
    _cFilSEB := xFilial( 'SEB' )

    For _nCnt := 1 To _nLen Step 2
        
        If _nCnt > 1
        
		   aAdd( ( _oHtml:ValByName( "t1.1" ) ), ' ' )
		   aAdd( ( _oHtml:ValByName( "t1.b" ) ), ' ' )
		   aAdd( ( _oHtml:ValByName( "t1.2" ) ), ' ' )
		   aAdd( ( _oHtml:ValByName( "t1.3" ) ), ' ' )
		   aAdd( ( _oHtml:ValByName( "t1.4" ) ), ' ' )
		   aAdd( ( _oHtml:ValByName( "t1.5" ) ), ' ' )
		   aAdd( ( _oHtml:ValByName( "t1.6" ) ), ' ' )
		   aAdd( ( _oHtml:ValByName( "t1.7" ) ), ' ' )
		   aAdd( ( _oHtml:ValByName( "t1.8" ) ), ' ' )		                     
		   aAdd( ( _oHtml:ValByName( "t1.9" ) ), ' ' )
		   aAdd( ( _oHtml:ValByName( "t1.c" ) ), ' ' )	        

        End
        
        If SEB->( dbSeek( _cFilSEB + cBanco + Substr( _cRej, _nCnt, 2 ) + ' P', .T. ) )

           _cDescOco := SEB->EB_DESCRI

        ElseIf Substr( _cRej, _nCnt, 2 ) = '00'

           _cDescOco  := 'PAGAMENTO EFETUADO'
           _nValPagto += nValPgto

        End

 	    aAdd( ( _oHtml:ValByName( "t1.a" ) ), _cDescOco )


    Next

	cFilAnt := SEE->EE_ZFILORI

Return( NIL )