/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA200FIL ºAutor  ³ Sérgio Santana     º Data ³ 22/01/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no processamento do Retorno do CNAB para  º±±
±±ºDesc.     ³ localição da filial do titulo.                             º±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glastech                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
 Estrutura de aValores
	Numero do T¡tulo	- 01
    data da Baixa		- 02
	Tipo do T¡tulo		- 03
	Nosso Numero		- 04
	Valor da Despesa	- 05
	Valor do Desconto	- 06
	Valor do Abatiment  - 07
	Valor Recebido      - 08
	Juros				- 09
	Multa				- 10
	Outras Despesas		- 11
	Valor do Credito	- 12
	Data Credito		- 13
	Ocorrencia			- 14
	Motivo da Baixa 	- 15
	Linha Inteira		- 16 
	Data de Vencto		- 17
*/

User Function FA200FIL()
                                             
//	Local nIdBolet := ParamIxb[4] // Id Vecto Titulo Gestoq
/*	Local _aValores := ParamIxb   
	Local _l109     := .F.
	
	If SE1->( IndexOrd() ) <> 30

	   SE1->( dbSetOrder( 30 ) )

	End

	If Empty( _aValores[4] )

       _aValores[4] := Substr( _aValores[16], 63, 8 ) + Space( 2 )       
       cTipo := 'NF '
       SE1->( dbSetOrder( 19 ) )
       _l109 := .T.	

	End
    
    If Upper( rTrim( MV_PAR05 ) ) = 'BRADESCO.RET'

       _cTitulo := StrZero( Val( Substr( _aValores[1], 1, 6 ) ), 9, 0 )
       _cParcel := Substr( _aValores[1] ,   7,  1 )
       _cValor  := Substr( _aValores[16], 153, 13 )
       _cValor  := Val( _cValor )
       _cValor  /= 100
       _cValor  := Str( _cValor, 14, 2 )
       _cValor  := ltrim( _cValor )
       
       _aSaveArea := GetArea()

       _cQry := 'SELECT R_E_C_N_O_ nRecNo FROM ' + RetSqlName( 'SE1' ) + " WHERE (D_E_L_E_T_ <> '*') AND (E1_NUM = '" + _cTitulo + "') AND (E1_PARCELA = '" 
       _cQry += _cParcel + "') AND (E1_VLCRUZ = " + _cValor + ")"
       dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry), 'TMP' )
       _nRecNo := TMP->nRecNo
       TMP->( dbCloseArea() )

       RestArea( _aSaveArea )

       If _nRecNo <> 0

           SE1->( dbGoTo( _nRecNo ) )
           dDataCred := if( Empty( DtoS( dDataCred ) ), dBaixa, dDataCred )

       End

    ElseIf ( Val( _aValores[4] ) <> SE1->E1_IDBOLET ) .And. ( _l109 )

       cNumTit := Space( Len( cNumTit ) )

       If ( SE1->( dbSeek( _aValores[4], .F. ) ) )
	
	      While SE1->E1_IDCNAB = _aValores[4]
       
             If ( SE1->E1_VALOR <> ( Val( Substr( _aValores[16], 154, 12 ) ) / 100 ) )

                SE1->( dbSkip() )

             Else

                cNumTit := rTrim( SE1->E1_PREFIXO )
                cNumTit += SE1->E1_NUM
                cNumTit += SE1->E1_PARCELA
                Exit

             End
       
          End

       End

	ElseIf ( SE1->( dbSeek( _aValores[4], .F. ) ) ) .And. ! ( _l109 )

       cNumTit := rTrim( SE1->E1_PREFIXO )
       cNumTit += SE1->E1_NUM
       cNumTit += SE1->E1_PARCELA

	End

    If ( Valtype( _oHtml ) <> 'U' )

	   _nValRec := nValRec
	   
	   If SEE->EE_DESPCRD = 'S'

	      _nValRec += ( nDespes + nOutrDesp - nValCC )

	   End

       aAdd( ( _oHtml:ValByName( "t1.1" ) ), SE1->E1_FILIAL )
       aAdd( ( _oHtml:ValByName( "t1.b" ) ), SE1->E1_TIPO )
       aAdd( ( _oHtml:ValByName( "t1.2" ) ), SE1->E1_NUM )
       aAdd( ( _oHtml:ValByName( "t1.3" ) ), rtrim(SE1->E1_PARCELA) )
       aAdd( ( _oHtml:ValByName( "t1.4" ) ), rtrim(SE1->E1_NOMCLI) )
       aAdd( ( _oHtml:ValByName( "t1.5" ) ), TRANSFORM( SE1->E1_EMISSAO,'@DE 99/99/9999' ) )
       aAdd( ( _oHtml:ValByName( "t1.6" ) ), TRANSFORM( SE1->E1_VENCREA,'@DE 99/99/9999' ) )
       aAdd( ( _oHtml:ValByName( "t1.7" ) ), TRANSFORM( _nValRec       ,'@E 99,999,999.99' ) )
       aAdd( ( _oHtml:ValByName( "t1.8" ) ), TRANSFORM( SE1->E1_SALDO,'@E 99,999,999.99' ) )
       aAdd( ( _oHtml:ValByName( "t1.9" ) ), SE1->E1_NUMBCO )
       aAdd( ( _oHtml:ValByName( "t1.c" ) ), ' ' )

       _cRej    := Alltrim( _aValores[ 14 ] )
       _cRej    += Alltrim( Substr( _aValores[ 16 ], 393, 2 ) )
       _cRej    += Alltrim( Substr( _aValores[ 16 ], 378, 8 ) )
       _nLen    := Len( Alltrim(  _cRej ) )
       _cFilSEB := xFilial( 'SEB' )
       _nRecSEB := SEB->( RecNo() )

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

           If SEB->( dbSeek( _cFilSEB + cBanco + Substr( _cRej, _nCnt, 2 ) + ' R   ', .F. ) )

              aAdd( ( _oHtml:ValByName( "t1.a" ) ), SEB->EB_DESCRI )

           Else

              aAdd( ( _oHtml:ValByName( "t1.a" ) ), Substr( _cRej, _nCnt, 2 ) + ' Ocorrencia não cadastrada' )
           
           End
           
       Next
       
       SEB->( dbGoTo( _nRecSEB ) )

    End 
*/
    MV_PAR11 := 2  // setagem contabilizacao off-line
	MV_PAR13 := 2
	//A GlassTech não soube explicar o preenchimento deste campo customizado, desta forma, foi efetuado este tratamento para impedir erros no caso de não preenchimento do campo
    cFilAnt  := Iif(!Empty(SEE->EE_ZFILORI), SEE->EE_ZFILORI, cFilAnt)

Return( NIL )