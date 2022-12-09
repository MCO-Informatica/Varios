#include 'PROTHEUS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050FIN  ºAutor  ³ Sergio Santana     º Data ³ 20/01/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao dos titulos GESTOQ                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA050FIN()

	Local aArea		:= getarea()
	Local aAreaSC7	:= sc7->(getarea())
	Local aAreaSE4	:= se4->(getarea())
	Local aAreaFIE	:= fie->(getarea())

	LOCAL _nIdTitulo := 0
	LOCAL _nEmpresa  := 0
	LOCAL _cFornec   := ''
	LOCAL _cNumero   := ''
	LOCAL _cTipo     := ''
	LOCAL _cFilial   := ''
	LOCAL _cTitPai   := ''
	LOCAL _aResult   := {}
	LOCAL _nRecNo    := SE2->( RecNo() )

    /*
    -- Pirolo - 16/01/2020 - Removido para adequação ao ambiente Unificado.
    If ( AllTrim( UPPER( GetEnvServer() ) ) <> 'GERENCIAL' ) .Or.; // Realiza atualização GESTOQ valida para este ambiente
       ( SE2->E2_TIPO = 'PA ' ) // Pagamento antecipado não gera titulo GESTOQ é gerado pela movimentação bancária
    */
	If ( SE2->E2_TIPO = 'PA ' ) .OR. nModulo <> 6

		if SE2->E2_TIPO = 'PA ' .and. nModulo == 6

			se4->(DbSetOrder(1))
			sc7->(DbSetOrder(1))
			if sc7->(DbSeek(xFilial()+substr(se2->e2_num,4,6)))
				if se4->(DbSeek(xFilial()+sc7->c7_cond)) .and. se4->e4_ctradt == "1"    //com adiantamento
					fie->(DbSetOrder(3))  //FIE_FILIAL + FIE_CART + FIE_FORNEC + FIE_LOJA + FIE_PREFIX + FIE_NUM + FIE_PARCEL + FIE_TIPO + FIE_PEDIDO
					if !fie->(DbSeek(xFilial()+"P"+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SUBSTR(SE2->E2_NUM,4,6)))
						fie->(RecLock("FIE", .t.))
						FIE->FIE_FILIAL := FIE->(xfilial())
						FIE->FIE_CART   :=  "P"
						FIE->FIE_PEDIDO := SUBSTR(SE2->E2_NUM,4,6)
						FIE->FIE_PREFIX := SE2->E2_PREFIXO
						FIE->FIE_NUM    := SE2->E2_NUM
						FIE->FIE_PARCEL := SE2->E2_PARCELA
						FIE->FIE_TIPO   := SE2->E2_TIPO
						FIE->FIE_CLIENT := ""
						FIE->FIE_FORNEC := SE2->E2_FORNECE
						FIE->FIE_LOJA   := SE2->E2_LOJA
						FIE->FIE_VALOR  := SE2->E2_VALOR
						FIE->FIE_SALDO  := SE2->E2_VALOR
						FIE->FIE_FILORI := SE2->E2_FILORIG
						fie->(MsUnlock())
					endif
				endif
			endif

			RestArea(aAreaSE4)
			RestArea(aAreaSC7)
			RestArea(aAreaFIE)
			RestArea(aArea)

		endif

		Return( NIL )
	EndIf

	If SE2->E2_FILIAL = '0101'
		_nEmpresa := 1
	ElseIf SE2->E2_FILIAL = '0102'
		_nEmpresa := 2
	ElseIf SE2->E2_FILIAL = '0201'
		_nEmpresa := 3
	ElseIf SE2->E2_FILIAL = '0601'
		_nEmpresa := 4
	ElseIf SE2->E2_FILIAL = '0103'
		_nEmpresa := 5
	ElseIf SE2->E2_FILIAL = '0202'
		_nEmpresa := 6
	ElseIf SE2->E2_FILIAL = '0301'
		_nEmpresa := 7
	ElseIf SE2->E2_FILIAL = '0401'
		_nEmpresa := 8
	ElseIf SE2->E2_FILIAL = '0501'
		_nEmpresa := 9
	ElseIf SE2->E2_FILIAL = '0215'
		_nEmpresa := 15
	ElseIf SE2->E2_FILIAL = '0701'
		_nEmpresa := 12
	ElseIf SE2->E2_FILIAL = '9001'
		_nEmpresa := 13
	ElseIf SE2->E2_FILIAL = '0801'
		_nEmpresa := 16
	ElseIf SE2->E2_FILIAL = '1001'
		_nEmpresa := 18
	ElseIf SE2->E2_FILIAL = '1101'
		_nEmpresa := 19
	ElseIf SE2->E2_FILIAL = '1201'
		_nEmpresa := 17
	ElseIf SE2->E2_FILIAL = '1601'
		_nEmpresa := 16
	ElseIf SE2->E2_FILIAL = '1602'
		_nEmpresa := 20
	ElseIf SE2->E2_FILIAL = '2001'
		_nEmpresa := 21
	Else
		_nEmpresa := NIL
	End

	_nIdTitulo := TCSPExec( "IncCPgCGSTQ", SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_FORNECE, SE2->E2_EMISSAO, _nEmpresa, 0 )

	_cFornec := SE2->E2_FORNECE
	_cNumero := SE2->E2_NUM
	_cTipo   := SE2->E2_TIPO
	_cFilial := SE2->E2_FILIAL
	_cTitPai := SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
	_cTitPai += Space( Len( SE2->E2_TITPAI ) - Len( _cTitPai ) )

	While ( _cFornec = SE2->E2_FORNECE ) .And.;
			( _cNumero = SE2->E2_NUM )     .And.;
			( _cTipo   = SE2->E2_TIPO )    .And.;
			( _cFilial = SE2->E2_FILIAL )  .And.;
			( ! SE2->( Eof() ) )

		_aResult := TCSPExec( "IncCPgIGSTQ", _nIdTitulo[1], SE2->( RecNo() ), SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_FORNECE, SE2->E2_NATUREZ, SE2->E2_CODRET )

		RecLock( 'SE2', .F. )
		SE2->E2_IDMOV  := StrZero( _aResult[1], 10, 0 )
		SE2->E2_ORIGBD := "G" //GESTOQ
		SE2->( MsUnLock() )

		SE2->( dbSkip() )
	EndDo

	_nIdx := SE2->( IndexOrd() )
	dbSetOrder( 17 )

	SE2->( dbSeek( _cFilial + _cTitPai, .F. ) )

	While ( _cFilial = SE2->E2_FILIAL ) .And.;
			( _cTitPai = SE2->E2_TITPAI ) .And.;
			( ! SE2->( Eof() ) )

		If _cFornec <> SE2->E2_FORNECE

			_nIdTitulo := TCSPExec( "IncCPgCGSTQ", SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_FORNECE, SE2->E2_EMISSAO, _nEmpresa, 0 )
			_cFornec   := SE2->E2_FORNECE

		EndIf

		If ValType( _nIdTitulo ) = 'A'

			RecLock( 'SE2', .F. )
			If SE2->E2_NATUREZ = '20516     '

				RecLock( 'SE2', .F. )
				SE2->E2_FORNECE := '005361'
				SE2->E2_LOJA    := '00'
				SE2->E2_NOMFOR  := 'IRF S/FORNEC'
				SE2->E2_CODRET  := '1708'
				SE2->E2_VENCREA := CtoD( '20/' + StrZero( Month( SE2->E2_EMISSAO + 30 ), 2, 0 ) + '/' +  StrZero( Year( SE2->E2_EMISSAO + 30 ), 4, 0 ) )
				SE2->E2_VENCTO  := SE2->E2_VENCREA
				SE2->E2_VENCORI := SE2->E2_VENCREA
				SE2->( MsUnLock() )

			ElseIf SE2->E2_NATUREZ = '20515     '

				RecLock( 'SE2', .F. )
				SE2->E2_FORNECE := '014108'
				SE2->E2_LOJA    := '00'
				SE2->E2_VENCREA := CtoD( '20/' + StrZero( Month( SE2->E2_EMISSAO + 30 ), 2, 0 ) + '/' +  StrZero( Year( SE2->E2_EMISSAO + 30 ), 4, 0 ) )
				SE2->E2_VENCTO  := SE2->E2_VENCREA
				SE2->E2_VENCORI := SE2->E2_VENCREA
				SE2->( MsUnLock() )

			ElseIf SE2->E2_NATUREZ = '20517     '

				RecLock( 'SE2', .F. )
				SE2->E2_FORNECE := '005363'
				SE2->E2_LOJA    := '00'
				SE2->E2_VENCREA := CtoD( '20/' + StrZero( Month( SE2->E2_EMISSAO + 30 ), 2, 0 ) + '/' +  StrZero( Year( SE2->E2_EMISSAO + 30 ), 4, 0 ) )
				SE2->E2_VENCTO  := SE2->E2_VENCREA
				SE2->E2_VENCORI := SE2->E2_VENCREA
				SE2->( MsUnLock() )

			ElseIf SE2->E2_NATUREZ = '20513     '

				RecLock( 'SE2', .F. )
				SE2->E2_FORNECE := '006877'
				SE2->E2_LOJA    := '00'
				SE2->E2_VENCREA := CtoD( '25/' + StrZero( Month( SE2->E2_EMISSAO + 30 ), 2, 0 ) + '/' +  StrZero( Year( SE2->E2_EMISSAO + 30 ), 4, 0 ) )
				SE2->E2_VENCTO  := SE2->E2_VENCREA
				SE2->E2_VENCORI := SE2->E2_VENCREA
				SE2->( MsUnLock() )

			EndIf

			_aResult := TCSPExec( "IncCPgIGSTQ", _nIdTitulo[1], SE2->( RecNo() ), SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_FORNECE, SE2->E2_NATUREZ, SE2->E2_CODRET )
			RecLock( 'SE2', .F. )
			SE2->E2_IDMOV  := StrZero( _aResult[1], 10, 0 )
			SE2->E2_ORIGBD := "G" //GESTOQ
			If SE2->(FIELDPOS("E2_MSEXP")) > 0
				SE2->E2_MSEXP := DTOS(DATE())
			EndIf
			SE2->( MsUnLock() )

		EndIf

		SE2->( dbSkip() )
	EndDo

	SE2->( dbSetOrder( _nIdx ) )
	SE2->( dbGoTo( _nRecNo ) )

Return( NIL )
