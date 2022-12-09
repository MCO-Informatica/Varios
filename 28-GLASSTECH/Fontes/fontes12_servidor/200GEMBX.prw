/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ 200GEMBX บAutor  ณ Desconhecido       บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada no retorno do CNAB a Receber              บฑฑ
ฑฑบ          ณ tratamento de localizacao de titulo.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Glasstech                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function 200GEMBX()

	Local _aValores := ParamIxb[ 1 ]
	Local _l109     := .F.
	Local _nCnt     := 0
	Local _nPos     := 0

	If Type( '_nPosList' ) <> 'N'

		Public _nPosList := 0

	EndIf

	SE1->( dbSetOrder( 19 ) )

	If ! ( SE1->( dbSeek( substr( _aValores[ 4 ], 1, 10 ) ) ) ) .And.;
			! ( Empty( _aValores[4] ) )

		SE1->( dbSetOrder( 30 ) )

	EndIf

	If Empty( _aValores[4] )

		_aValores[4] := Substr( _aValores[16], 63, 8 ) + Space( 2 )
		cTipo := 'NF '
		SE1->( dbSetOrder( 19 ) )
		_l109 := .T.

	EndIf

	If Upper( rTrim( MV_PAR05 ) ) = 'BRADESCO.RET'

		_cTitulo := rTrim( _aValores[1] )
		_nLen    := Len( _cTitulo )

		For _nPos := 1 To _nLen

			If ! ( Substr( _aValores[1], _nPos, 1 ) $ '0;1;2;3;4;5;6;7;8;9' )

				Exit

			EndIf

		Next

		_cTitulo := StrZero( Val( Substr( _cTitulo, if( MV_PAR07 = '1676 ' , 2, 1 ), _nPos - 1 ) ), 9, 0 )  // alterado em 02/08/2017 ag 1676 RedAsset FIDC
		_cParcel := Substr( _aValores[1] , _nPos  ,  1 )
		_cValor  := Substr( _aValores[16], 153, 13 )
		_cValor  := Val( _cValor )
		_cValor  /= 100
		_cValor  := Str( _cValor, 14, 2 )
		_cValor  := ltrim( _cValor )

		//_aSaveArea := GetArea()

		_cFlt := "@ (D_E_L_E_T_ <> '*') AND (E1_NUM = '" + _cTitulo + "') AND (E1_PARCELA = '" + _cParcel + "') AND (E1_VLCRUZ = " + _cValor + ")"
		SE1->( dbSetFilter( { || &_cFlt }, _cFlt ) )
		SE1->( dbGoTop() )
		_nRecNo := SE1->( RecNo() )

		//_cQry := 'SELECT R_E_C_N_O_ nRecNo FROM ' + RetSqlName( 'SE1' ) + " WHERE (D_E_L_E_T_ <> '*') AND (E1_NUM = '" + _cTitulo + "') AND (E1_PARCELA = '"
		//_cQry += _cParcel + "') AND (E1_VLCRUZ = " + _cValor + ")"
		//dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry), 'TMP' )
		//_nRecNo := TMP->nRecNo
		//TMP->( dbCloseArea() )

		//RestArea( _aSaveArea )

		SE1->( dbClearFilter() )

		If _nRecNo <> 0

			SE1->( dbGoTo( _nRecNo ) )
			dDataCred := if( Empty( DtoS( dDataCred ) ), dBaixa, dDataCred )

		Else

			cNumTit := ' '

		EndIf

	ElseIf ( Val( _aValores[4] ) <> SE1->E1_IDBOLET ) .And. ( _l109 )

		cNumTit := Space( Len( cNumTit ) )

		If ( SE1->( dbSeek( _aValores[4], .F. ) ) )

			While SE1->(!EOF()) .And. SE1->E1_IDCNAB = _aValores[4]

				If ( SE1->E1_VALOR <> ( Val( Substr( _aValores[16], 154, 12 ) ) / 100 ) )

					SE1->( dbSkip() )

				Else

					cNumTit := rTrim( SE1->E1_PREFIXO )
					cNumTit += SE1->E1_NUM
					cNumTit += SE1->E1_PARCELA
					Exit

				EndIf

			EndDo

		EndIf

	ElseIf ( SE1->( dbSeek( _aValores[4], .F. ) ) ) .And. ! ( _l109 )

		cNumTit := rTrim( SE1->E1_PREFIXO )
		cNumTit += SE1->E1_NUM
		cNumTit += SE1->E1_PARCELA

      /*MARCOS UPDUO - 17/11/2021 - CORREวรO POSICIONAMENTO NO TอTULO CORRETO DA FAIXA DE IDCNAB NO IF ABAIXO*/
		if SE1->E1_IDCNAB >= '3623055260' .and. SE1->E1_IDCNAB <= '3623112791'

			cNumTit := Space( Len( cNumTit ) )
			While SE1->(!EOF()) .And. SE1->E1_IDCNAB == substr(_aValores[4],1,TamSx3("E1_IDCNAB")[1])

				If SE1->E1_NUM == substr(_aValores[1],1,TamSx3("E1_NUM")[1]) .and. ;
						SEE->EE_CODIGO == SE1->E1_PORTADO .and. ;
						SEE->EE_AGENCIA == SE1->E1_AGEDEP .and. ;
						SEE->EE_CONTA == SE1->E1_CONTA

					cNumTit := rTrim( SE1->E1_PREFIXO )
					cNumTit += SE1->E1_NUM
					cNumTit += SE1->E1_PARCELA
					exit

				EndIf

				SE1->( dbSkip() )
			End

		endif

	ElseIf ! ( SE1->( Found() ) )

		cNumTit := ' '

	EndIf

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
		aAdd( ( _oHtml:ValByName( "t1.9" ) ), if( empty(SE1->E1_NUMBCO), _aValores[ 1 ], SE1->E1_NUMBCO ) )
		aAdd( ( _oHtml:ValByName( "t1.c" ) ), ' ' )
		_nPosList := Len( _oHtml:aListTables[1][1][2] )
		_cRej    := Alltrim( _aValores[ 14 ] )
		_cRej    += Alltrim( Substr( _aValores[ 16 ], 393, 2 ) )
		_cRej    += Alltrim( Substr( _aValores[ 16 ], 378, 8 ) )
		_nExc    := at( '00', _cRej ) - 1

		If _nExc > 0

			_cRej := Substr( _cRej, 1, _nExc )

		EndIf

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

			EndIf

			If SEB->( dbSeek( _cFilSEB + cBanco + Substr( _cRej, _nCnt, 2 ) + ' R   ', .F. ) )

				aAdd( ( _oHtml:ValByName( "t1.a" ) ), SEB->EB_DESCRI )

			Else

				aAdd( ( _oHtml:ValByName( "t1.a" ) ), Substr( _cRej, _nCnt, 2 ) + ' Ocorrencia nใo cadastrada' )

			EndIf

		Next

		SEB->( dbGoTo( _nRecSEB ) )

	EndIf

	MV_PAR11 := 2  // setagem contabilizacao off-line
	MV_PAR13 := 2
	cFilAnt  := SA6->A6_ZFILORI

Return( NIL )
