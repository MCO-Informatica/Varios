

/*
Número do Título	aValores[1,1]
Data da Baixa		aValores[1,2]
Tipo do Título		aValores[1,3]
Nosso Número		aValores[1,4]
Despesa				aValores[1,5]
Desconto			aValores[1,6]
Abatimento			aValores[1,7]
Valor Recebido		aValores[1,8]
Juros				aValores[1,9]
Multa				aValores[1,10]
Valor CC			aValores[1,11]
Credito				aValores[1,12]
Ocorrência			aValores[1,13]
Buffer				aValores[1,14]
*/

User Function FR650FIL()
Local _aValores := ParamIxb
Local _nIdx     := SE1->( IndexOrd() )
Local _lRet     := .F.
Local _l109     := .F.
Local cE1_NUM	:= ""
Local cE1_PARC	:= ""
	
	If Empty( _aValores[1][4] )

       _aValores[1][4] := substr( _aValores[ 1 ][14], 63, 8 ) + Space( 2 )
       SE1->( dbSetOrder( 19 ) )
       _l109 := .T.

	
	Else

        SE1->( dbSetOrder( 30 ) )	
	
	End
    
    If upper( rTrim( MV_PAR02 ) ) = 'BRADESCO.RET'

       _cTitulo := StrZero( Val( Substr( _aValores[1][1], 1, 6 ) ), 9, 0 )
       _cParcel := Substr( _aValores[1][1] ,   7,  1 )
       _cValor  := Substr( _aValores[1][14], 153, 13 )
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
          _lRet := .T.

       End

	ElseIf ( SE1->( dbSeek( _aValores[1][4], .F. ) ) ) .And. ( _l109 )
	
       While SE1->E1_IDCNAB = _aValores[1][4]
       
          If ( SE1->E1_VALOR <> ( Val( Substr( xBuffer, 154, 12 ) ) / 100 ) )

             SE1->( dbSkip() )

          Else

             _lRet := .T.
             Exit

          End
       
       End

	ElseIf ( SE1->( dbSeek( _aValores[1][4], .F. ) ) ) .And. ! ( _l109 )

       _lRet := .T.
       
	ElseIf MV_PAR07 = 1 .AND. AllTrim(Upper(MV_PAR02))$ "BRDFAC.RET|" //Pirolo - Ajustado para projeto FDICs
		//Busca por IDCNAB sem filial no indice
		dbSelectArea("SE1")
		SE1->(dbSetOrder(19))
		cChave := Substr(cNumTit,1,10)
		_lRet := SE1->(DbSeek(cChave))
	End
	
	SE1->( dbSetOrder( _nIdx ) )

Return( _lRet )