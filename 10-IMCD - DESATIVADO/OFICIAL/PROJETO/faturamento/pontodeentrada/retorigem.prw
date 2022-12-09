#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetOrigem ºAutor  ³ Otacilio A. Junior º Data ³  25/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retornar a origem do produto pela Nota de entrada ou pela  º±±
±±º          ³ produção do envaze.                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RetOrigem( cCodFil, cCodProd, cLocal, cDoc, cSerie )

	Local aAreaAtu := GetArea()
	Local aAreaSB1 := SB1->( GetArea() )
	Local cQuery   := ""
	Local nPos     := 0
	Local nAux     := 0
	Local lExit	   := .F.
	Local cOrigem  := ""

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RetOrigem" , __cUserID )

	SB1->( dbSetOrder( 1 ) )

	cQuery += "SELECT 'SD1' TIPO, D1_SERIE SERIE, D1_DOC DOC, D1_NUMSEQ NUMSEQ, D1_COD COD, D1_QUANT QUANT, D1_CLASFIS CLASFIS, ' ' CODORI, D1_LOTECTL LOTECTL "
	cQuery += "  FROM " + RetSQLName( "SD1" )
	cQuery += " WHERE D1_FILIAL  = '" + cCodFil + "' "
	cQuery += "   AND D1_COD     = '" + cCodProd + "' "
	//cQuery += "   AND D1_LOCAL   = '" + cLocal + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery += " UNION "
	cQuery += "SELECT D3_CF TIPO, ' ' SERIE, D3_DOC DOC, D3_NUMSEQ NUMSEQ, D3_COD COD, D3_QUANT QUANT, D3_CLASFIS CLASFIS, ' ' CODORI, D3_LOTECTL LOTECTL "
	cQuery += "  FROM " + RetSQLName( "SD3" )
	cQuery += " WHERE D3_FILIAL  = '" + cCodFil + "' "
	cQuery += "   AND D3_COD     = '" + cCodProd + "' "
	//cQuery += "   AND D3_LOCAL   = '" + cLocal + "' "
	cQuery += "   AND SUBSTR( D3_CF, 2, 2 ) != 'E4' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery += " UNION "
	cQuery += "SELECT A.D3_CF TIPO, '   ' SERIE, A.D3_DOC DOC, A.D3_NUMSEQ NUMSEQ, A.D3_COD COD, A.D3_QUANT QUANT, A.D3_CLASFIS CLASFIS, B.D3_COD CODORI, A.D3_LOTECTL LOTECTL "
	cQuery += "  FROM " + RetSQLName( "SD3" ) + " A "
	cQuery += "  JOIN " + RetSQLName( "SD3" ) + " B ON B.D3_FILIAL = A.D3_FILIAL AND B.D3_NUMSEQ = A.D3_NUMSEQ AND B.D3_COD != A.D3_COD AND B.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE A.D3_FILIAL  = '" + cCodFil + "' "
	cQuery += "   AND A.D3_COD     = '" + cCodProd + "' "
	//cQuery += "   AND A.D3_LOCAL   = '" + cLocal + "' "
	cQuery += "   AND SUBSTR( A.D3_CF, 2, 2 ) = 'E4' "
	cQuery += "   AND A.D_E_L_E_T_ = ' ' "
	cQuery += " UNION "
	cQuery += "SELECT 'SD2' TIPO, D2_SERIE SERIE, D2_DOC DOC, D2_NUMSEQ NUMSEQ, D2_COD COD, D2_QUANT QUANT, D2_CLASFIS CLASFIS, ' ' CODORI, D2_LOTECTL LOTECTL "
	cQuery += "  FROM " + RetSQLName( "SD2" )
	cQuery += " WHERE D2_FILIAL  = '" + cCodFil + "' "
	cQuery += "   AND D2_COD     = '" + cCodProd + "' "
	//cQuery += "   AND D2_LOCAL   = '" + cLocal + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY NUMSEQ "
	If Select( "TMP_SLD" ) > 0
		TMP_SLD->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SLD", .T., .F. )
	TMP_SLD->( dbGoTop() )
	While TMP_SLD->( !Eof() ) .and. !lExit

		If Left( TMP_SLD->TIPO, 1 ) = "D" .OR. TMP_SLD->TIPO = "SD1"
			cOrigem := ""
			If SubStr( TMP_SLD->TIPO, 2, 2 ) != "E4"
				If Substr ( TMP_SLD->TIPO, 2, 2 ) == "E6" .OR. TMP_SLD->TIPO = "SD1"
					cOrigem := Substr( TMP_SLD->CLASFIS, 1, 1 )
				Else
					SB1->( dbSeek( xFilial( "SB1" ) + TMP_SLD->COD ) )
					cOrigem := SB1->B1_ORIGEM
				Endif
			Else
				SB1->( dbSeek( xFilial( "SB1" ) + TMP_SLD->CODORI ) )
				cOrigem := SB1->B1_ORIGEM
			Endif
			If Empty(cOrigem)
				cOrigem := "0"
			Endif

		Endif

		TMP_SLD->( dbSkip() )
	End

	RestArea( aAreaSB1 )
	RestArea( aAreaAtu )

Return(cOrigem)
