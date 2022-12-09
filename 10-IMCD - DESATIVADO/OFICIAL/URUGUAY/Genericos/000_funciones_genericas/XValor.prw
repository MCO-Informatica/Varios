#include 'protheus.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ PegaTasa ³ Autor ³ Diego Fernando Rivero ³ Data ³ 26/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Retorna la tasa de un d¡a determinado                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Microsiga Argentina....                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
 U_XVALOR(SE1->E1_VALOR,SE1->E1_EMISSAO,SE1->E1_MOEDA,1,2,SE1->E1_TXMOEDA)  /*/ 
User Function xValor( nValor, dDataOri, nMoeOri, nMoneda, nVerTasa, nTxMoeda, lMantem )

	Local aArea    := GetArea()
	Local aSM2     := SM2->(GetArea())
	Local nTipoMov := 2
	Local nTasaOri := 0.00
	Local nTasaDes := 0.00
	Local cCampoOri:= ""
	Local cCampoDes:= ""
	Local nValRet  := 0.00

	default lMantem := .F.

	if lMantem .and. nMoeOri == 2
		nValRet  := Round( nValor, 2 )// Round( nTxMoeda * nValor, 2 )
	else
		If ValType( nMoeOri ) != 'N'
			nMoeOri:=val(nMoeOri)
		EndIf

		If ValType( nMoneda ) != 'N'
			nMoneda:=val(nMoneda)
		EndIf

		cCampoOri:= 'M2_MOEDA' + Alltrim( Str( nMoeOri ) )
		cCampoDes:= 'M2_MOEDA' + Alltrim( Str( nMoneda ) )

		If ValType( nMoeOri ) != 'N' .or. nMoeOri < 1 .or. nMoeOri > 10
			//	MsgAlert( 'Alguna de las Moneda es incorrecta!', 'Verificar Datos' )
			Return( 0 )
		EndIf

		SM2->(DbSetOrder(1))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Si la moneda del documento es la misma que la pedida en el   ³
		//³ informe, o si el Tipo de Movimiento pedido es Solo Movi-     ³
		//³ mientos en moneda...                                         ³
		//³ Retorno el mismo valor del Documento                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( Round( nMoeOri, 0 ) == Round( nMoneda, 0 ) ) .or. ( nTipoMov == 1 )
			RestArea( aSM2 )
			RestArea( aArea )
			Return( nValor )
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Si la moneda del Documento es 1, dejo establezco que la tasa ³
		//³ es 1, sino, busco la tasa teniendo en cuenta si es Hist¢rica ³
		//³ o Actual                                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Round( nMoeOri, 0 ) == 1
			nTasaOri := 1
		Else
			If !Empty( nTxMoeda ) .and. nVerTasa == 2
				nTasaOri := nTxMoeda
			Else
				SM2->(DbSeek( Iif( nVerTasa == 1, dDataBase, dDataOri ), .T. ))
				If !SM2->(Found())
					SM2->(DbSkip(-1))
				EndIf
				nTasaOri := SM2->( FieldGet( FieldPos( cCampoOri ) ) )
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Si la moneda del Informe es 1, dejo establezco que la tasa   ³
		//³ es 1, sino, busco la tasa teniendo en cuenta si es Hist¢rica ³
		//³ o Actual                                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Round( nMoneda, 0 ) == 1
			nTasaDes := 1
		Else
			If !Empty( nTxMoeda ) .and. nVerTasa == 2 .and. Round( nMoneda, 0 ) == 1
				nTasaDes := nTxMoeda
			Else
				SM2->(DbSeek( Iif( nVerTasa == 1, dDataBase, dDataOri ), .T. ))
				If !SM2->(Found())
					SM2->(DbSkip(-1))
				EndIf
				nTasaDes := SM2->( FieldGet( FieldPos( cCampoDes ) ) )
			EndIf
		EndIf

		If ValType(nTasaDes) == "N"
			If nTasaDes != 0
				nValRet  := Round( nTasaOri * nValor / nTasaDes, 2 )
			EndIf
		Else
			nValRet  := Round( 1 * nValor / 1, 2 )
		EndIf
	EndIf

	RestArea( aSM2 )
	RestArea( aArea )

Return( nValRet )
