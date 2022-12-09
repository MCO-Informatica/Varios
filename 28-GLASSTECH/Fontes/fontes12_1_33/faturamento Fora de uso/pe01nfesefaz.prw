#include 'protheus.ch'
#include 'parmtype.ch'
#include 'rwmake.ch'

User Function pe01nfesefaz()

	Local aProd		:= ParamIXB[1]
	Local cMensCli	:= ParamIXB[2]
	Local cMensFis	:= ParamIXB[3]
	Local aDest 	:= ParamIXB[4]
	Local aNota 	:= ParamIXB[5]
	Local aInfoItem	:= ParamIXB[6]
	Local aDupl		:= ParamIXB[7]
	Local aTransp	:= ParamIXB[8]
	Local aEntrega	:= ParamIXB[9]
	Local aRetirada	:= ParamIXB[10]
	Local aVeiculo	:= ParamIXB[11]
	Local aReboque	:= ParamIXB[12]
	Local aNfVincRur:= ParamIXB[13]
	Local aEspVol   := ParamIXB[14]
	Local aNfVinc	:= ParamIXB[15]

	Local aIPI      := {}		//aCSTIPI			//Era preenchido com esse parametro => ParamIxb[14]

	Local   _cMenNota := Space( 254 )
	Local   _cCodTran := Space( 6 )
	Local   _cPlc     := Space( 7 )
	Local   _aCodEsp  := { '   ' ,'   ', '   ' }
	Local   _nLen     := 0
	Local   i         := 0

	Private _cFilCB3 := xFilial( 'CB3' )
	Private _cFilDA3 := xFilial( 'DA3' )
	Private _aDscEsp := { SF2->F2_ESPECI1, SF2->F2_ESPECI2, SF2->F2_ESPECI3 }
	Private _aQdeEsp := { SF2->F2_VOLUME1, SF2->F2_VOLUME2, SF2->F2_VOLUME3 }
	Private _aPsoEsp := { 0, 0, 0 }
	Private _cEst    := Space( 2 )
	Private _lAtu    := .F.

	IF SF2->F2_TIPO <> 'I'

		_cMenNota := SF2->F2_MENNOTA + CCeMail()
		_cCodTran := SF2->F2_TRANSP
		_cPlc     := SF2->F2_VEICUL1

		aAdd(aTransp,SA4->A4_BAIRRO)
		aAdd(aTransp,SA4->A4_CEP)

		@ 62,1 TO 455,780 DIALOG oDlg1 TITLE 'Dados Complementares'
		@ 10, 9 SAY 'Transpordadora:'
		@ 09, 50 GET _cCodTran F3 "SA4" valid VldTrans( _cCodTran, @aTransp )

		@ 10, 105 SAY 'Placa:'
		@ 09, 125 GET _cPlc F3 "DA3" picture "@R !!!-9999" size 30,10 Valid PlcVeic( _cPlc, @aTransp )

		@ 10, 220 SAY 'Nota Fiscal:'
		@ 09, 260 GET SF2->F2_DOC when .F.

		@ 10, 168 SAY 'UF:'
		@ 09, 180 GET _cEst picture "@R !!"

		@ 35, 9 SAY 'Nome:'
		@ 34, 25 get aTransp[2] when .F. size 160, 7

		@ 50, 9 SAY 'Endereço:'
		@ 49, 35 get aTransp[4] when .F. size 110, 7

		@ 50, 155 SAY 'Bairro:'
		@ 49, 180 get aTransp[8] when .F.

		@ 50, 245 SAY 'CEP:'
		@ 48, 260 get aTransp[9] picture "@R 99999-999" when .F.

		@ 65, 9 SAY 'Municipio:'
		@ 64, 36 get aTransp[5] when .F. size 50,7

		@ 65, 90 SAY 'Estado:'
		@ 64, 112 get aTransp[6] when .F.

		@ 65, 130 SAY 'CNPJ:'
		@ 64, 147 get aTransp[1] picture '@R 99.999.999/9999-99'  when .F. size 60, 7

		@ 65, 208 SAY 'IE:'
		@ 64, 215 get aTransp[3] when .F. size 60,7

		@ 85,5   To 110,130 Title 'Especie 1'
		@ 85,135 To 110,260 Title 'Especie 2'
		@ 85,266 To 110,388 Title 'Especie 3'

		@ 95, 9  get _aCodEsp[1] F3 "CB3" valid TpEmb( _aCodEsp[1], 1 )
		@ 95,39  get _aDscEsp[1]
		@ 95,100 get _aQdeEsp[1] size 25,7

		@ 95,139 get _aCodEsp[2] F3 "CB3" valid TpEmb( _aCodEsp[2], 2 )
		@ 95,169 get _aDscEsp[2]
		@ 95,230 get _aQdeEsp[2] size 25, 7

		@ 95,270 get _aCodEsp[3] F3 "CB3" valid TpEmb( _aCodEsp[3], 3 )
		@ 95,300 get _aDscEsp[3]
		@ 95,360 get _aQdeEsp[3] size 25, 7

		@ 120,5 To 175,388 Title "Mensagem Nota"
		@ 130,9  get oObs Var _cMenNota Multiline Size 375,40 Pixel

		@ 180, 325 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
		@ 180, 361 BMPBUTTON TYPE 1 ACTION GrvDadAd( _cCodTran, _cMenNota, _cPlc, _aPsoEsp )

		ACTIVATE DIALOG oDlg1 CENTERED

		If ( _lAtu )


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Reboque Placa do Veiculo                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			aVeiculo := {}
			aAdd(aVeiculo,iif(Empty(DA3->DA3_PLACA),_cPlc,DA3->DA3_PLACA))
			aAdd(aVeiculo,iif(Empty(DA3->DA3_ESTPLA),_cEst,DA3->DA3_ESTPLA))
			aAdd(aVeiculo,Iif(DA3->(FieldPos("DA3_RNTC")) > 0 ,DA3->DA3_RNTC,"")) //RNTC

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Volumes / Especie Nota de Saida                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aEspVol := {}
			cScan   := "1"

			While ( !Empty(cScan) )
				cEspecie := Upper(FieldGet(FieldPos("F2_ESPECI"+cScan)))
				If ! ( Empty(cEspecie) )
					nScan := aScan(aEspVol,{|x| x[1] == cEspecie})
					If ( nScan = 0 )
						aAdd(  aEspVol,{ cEspecie, FieldGet(FieldPos("F2_VOLUME"+cScan)) , SF2->F2_PLIQUI , SF2->F2_PBRUTO})
					Else
						aEspVol[nScan][2] += FieldGet(FieldPos("F2_VOLUME"+cScan))
					End
				End
				cScan := Soma1(cScan,1)
				If ( FieldPos("F2_ESPECI"+cScan) == 0 )
					cScan := ""
				End

			End

			_nLen := Len( aIPI )
			If _nLen > 0
				For i := 1 To _nLen
					If (SA1->A1_CODMUN = '00255' .And. ! Empty( SA1->A1_SUFRAMA ))
						aIPI[i][4] := '337'
					ElseIf SA1->A1_CODMUN = '00307'
						aIPI[i][4] := '343'
					ElseIf (SA1->A1_CODMUN = '00615' .Or. SA1->A1_CODMUN = '00605')
						aIPI[i][4] := '344'
					ElseIf (SA1->A1_CODMUN = '09841' .Or. SA1->A1_CODMUN = '09843')
						aIPI[4] := '336'
					ElseIf SA1->A1_MUN = 'TABATINGA'
						aIPI[i][4] := '341'
					ElseIf SA1->A1_MUN = 'GUAJARA-MIRIM'
						aIPI[i][4] := '342'
					ElseIf SA1->A1_MUN = 'BOA VISTA'
						aIPI[i][4] := '343'
					ElseIf (SA1->A1_MUN = 'BRASILEIA' .Or. SA1->A1_MUN = 'CRUZEIRO DO SUL')
						aIPI[i][4] := '345'
					ElseIf (SA1->A1_MUN = 'RIO BRANCO' .And. SA1->A1_MUN = 'AC')
						aIPI[i][4] := '336'
					End
				Next
			End

		Else

			aNota := {}

		End

	END

	ParamIXB[1] := aProd
	ParamIXB[2] := cMensCli
	ParamIXB[3] := cMensFis
	ParamIXB[4] := aDest
	ParamIXB[5] := aNota
	ParamIXB[6] := aInfoItem
	ParamIXB[7] := aDupl
	ParamIXB[8] := aTransp
	ParamIXB[9] := aEntrega
	ParamIXB[10] := aRetirada
	ParamIXB[11] := aVeiculo
	ParamIXB[12] := aReboque
	ParamIXB[13] := aNfVincRur
	ParamIXB[14] := aEspVol
	ParamIXB[15] := aNfVinc

return( ParamIXB )


Static Function TpEmb( _cEmb, _nEmb )

	_lRet := .T.

	If ! ( CB3->( dbSeek( _cFilCB3 + _cEmb, .F. ) ) ) .And. ! ( Empty( _cEmb ) )

		MsgInfo( 'Embalagem não cadastrada, por favor verifique o código...' )
		_lRet := .F.

	ElseIf ( _nEmb = 2 .Or. _nEmb = 3) .And. Empty( _cEmb )

		_aDscEsp[ _nEmb ] := space( 30 )
		_aPsoEsp[ _nEmb ] := 0

	ElseIf ! Empty( _cEmb )

		_aDscEsp[ _nEmb ] := CB3->CB3_DESCRI
		_aQdeEsp[ _nEmb ] := CB3->CB3_PESO

	End

Return( _lRet )

Static Function PlcVeic( _cPlcVeic, aTransp )

	LOCAL _cTransp := 'N'
	LOCAL _aPlacas := {;
		{'BOQ9877','48254858000109'},;
		{'BPG9037','03061254000299'},;
		{'BVU9809','48254858000109'},;
		{'BYT8813','48254858000109'},;
		{'CPS3850','04051564000104'},;
		{'CZE8693','03061254000108'},;
		{'CZE9492','03061254000108'},;
		{'DCP8139','48254858000109'},;
		{'DEQ7466','48254858000109'},;
		{'DHU6698','48254858000109'},;
		{'DKX2896','48254858000109'},;
		{'DPB2546','48254858000109'},;
		{'DQB1872','48254858000109'},;
		{'ETL1438','04051564000104'},;
		{'ETL1439','48254858000109'},;
		{'ETL1461','48254858000109'},;
		{'ETL1463','48254858000109'},;
		{'ETL1465','48254858000109'},;
		{'EYD5793','49925225000148'},;
		{'EYD8291','49925225000148'},;
		{'EYI1716','48254858000109'},;
		{'FFP1692','04051564000104'},;
		{'FJW2809','04051564000104'} ;
		}

	If ! ( DA3->( dbSeek( _cFilDA3 + _cPlcVeic, .F. ) ) )

		MsgInfo( 'Placa de Veiculo não cadastrada, por favor verifique a Placa...' )
		_lRet := .T.

	Else

		_lRet    := .T.
		_cEst    := DA3->DA3_ESTPLA
		_nPos    :=  aScan( _aPlacas , {|x| x[1] = _cPlcVeic } )
		_cCgcPlc := iif( _nPos <> 0, _aPlacas[ _nPos ][ 2 ], ' ' )

		If _cCgcPlc <> ' '

			_cTransp := 'S'

		End

		If SA1->A1_CGC = _cCgcPlc

			_cCgcPlc := 'S'

		Else

			_cCgcPlc := 'N'

		End

		If (_cCgcPlc = 'S')

			_cTransp := 'S'

		End

		If ( _cPlcVeic $ 'EYD5793,EYD8291,EYI1716') .Or.;
				( _cTransp = 'S' .And.  _cCgcPlc = 'N' )

			aAdd(aTransp,'')
			aAdd(aTransp,'NOSSO CARRO')
			aAdd(aTransp,'')
			aAdd(aTransp,'')
			aAdd(aTransp,'')
			aAdd(aTransp,'SP')
			aAdd(aTransp,'')
			aAdd(aTransp,'')
			aAdd(aTransp,'')

		End

		If (_cCgcPlc = 'S') .And.;
				! ( _cPlcVeic $ 'EYD5793,EYD8291,EYI1716' )

			aAdd( aTransp, AllTrim( SM0->M0_CGC ) )
			aAdd( aTransp, Upper( Alltrim( SM0->M0_NOMECOM ) ) )
			aAdd( aTransp, Alltrim( SM0->M0_INSC ) )
			aAdd( aTransp, Upper( Alltrim( SM0->M0_ENDCOB ) ) )
			aAdd( aTransp, Upper( Alltrim( SM0->M0_CIDCOB ) ) )
			aAdd( aTransp, Upper( Alltrim( SM0->M0_ESTCOB ) ) )
			aAdd( aTransp, '' )
			aAdd( aTransp,Upper( Alltrim( SM0->M0_BAIRCOB ) ) )
			aAdd( aTransp,Transform(SM0->M0_CEPCOB,'@R 99999-999'))

		End

		If rTrim( SA4->A4_NREDUZ ) = 'RETIRA (GRANEL)' .Or.;
				rTrim( SA4->A4_NREDUZ ) = 'RETIRA (CAIXA)'

			aAdd( aTransp, AllTrim( SA1->A1_CGC ) )
			aAdd( aTransp, Upper( Alltrim( SA1->A1_NOME ) ) )
			aAdd( aTransp, Alltrim( SA1->A1_INSCR ))
			aAdd( aTransp, Upper( Alltrim( SA1->A1_END ) ) )
			aAdd( aTransp, Upper( Alltrim( SA1->A1_MUN ) ) )
			aAdd( aTransp, Upper( Alltrim( SA1->A1_EST ) ) )
			aAdd( aTransp, '' )
			aAdd( aTransp,Upper( Alltrim( SA1->A1_BAIRRO ) ) )
			aAdd( aTransp,Transform( SA1->A1_CEP,'@R 99999-999'))

		End

	End

Return( _lRet )

Static Function GrvDadAd( _cCodTran, _cMenNota, _cPlc, _aPsoEsp )

	_lAtu := MsgYesNo('Confirma a atualização dos dados adicionais?', 'Nota Fiscal nº ' + SF2->F2_DOC )

	If _lAtu

		RecLock( 'SF2', .F.  )
		SF2->F2_TRANSP  := _cCodTran
		SF2->F2_VEICUL1 := _cPlc
		SF2->F2_MENNOTA := _cMenNota

		SF2->F2_ESPECI1 := _aDscEsp[1]
		SF2->F2_ESPECI2 := _aDscEsp[2]
		SF2->F2_ESPECI3 := _aDscEsp[3]

		SF2->F2_VOLUME1  := _aQdeEsp[1]
		SF2->F2_VOLUME2  := _aQdeEsp[2]
		SF2->F2_VOLUME3  := _aQdeEsp[3]

		If (_aPsoEsp[1] + _aPsoEsp[2] + _aPsoEsp[3]) <> 0

			SF2->F2_PBRUTO := SF2->F2_PLIQUI + _aPsoEsp[1] + _aPsoEsp[2] + _aPsoEsp[3]

		End

		SF2->( dbUnLock() )

	End

Return( Close( oDlg1 ) )

Static Function VldTrans( _cTrans, aTransp )

	If ! ( SA4->( dbSeek( xFilial( 'SA4' ) + _cTrans, .F. ) ) )

		MsgInfo( 'Transportadora não cadastrada, por favor verifique o cadastro...' )
		_lRet := .F.

	Else

		aTransp := {}
		aAdd(aTransp,AllTrim(SA4->A4_CGC))
		aAdd(aTransp,SA4->A4_NOME)

		If (SA4->A4_TPTRANS <> "3")
			aAdd(aTransp,VldIE(SA4->A4_INSEST))
		Else
			aAdd(aTransp,"")
		End

		aAdd(aTransp,SA4->A4_END)
		aAdd(aTransp,SA4->A4_MUN)
		aAdd(aTransp,Upper(SA4->A4_EST)	)
		aAdd(aTransp,SA4->A4_EMAIL	)
		aAdd(aTransp,SA4->A4_BAIRRO)
		aAdd(aTransp,SA4->A4_CEP)
		_lRet := .T.

	End

Return( _lRet )


Static Function CCeMail()

	LOCAL _cFilter := "@ (U5_CLIENTE = '" + SA1->A1_COD + "') AND (U5_NFE = 1) AND (D_E_L_E_T_ <> '*')"

	SU5->( dbSetFilter( { || &_cFilter }, _cFilter ) )
	SU5->( dbGoTop() )

	_cEmail := ''

	While ! ( SU5->( Eof() ) )

		_cEmail += Alltrim( SU5->U5_EMAIL )

		SU5->( dbSkip() )

		If ! ( SU5->( Eof() ) )
			_cEmail += ';'
		End

	End

	SU5->( dbClearFilter() )

	If ! Empty( _cEmail )

		_cEmail := '[EMAIL=' + _cEmail + ']'

	End

	SU5->( dbClearFilter() )

Return( _cEmail )

//[EMAIL=CLIENTE@ABC.COM.BR]
