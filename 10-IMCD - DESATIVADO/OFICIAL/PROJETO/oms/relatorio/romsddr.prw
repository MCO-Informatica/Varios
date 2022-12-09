#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  04/28/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ROMSDDR

	Local nOpcA       := 0
	Local aSays       := {}
	Local aButtons    := {}
	Local cCadastro   := "Gera Planilha DDR - "+SM0->M0_NOMECOM
	Local cPerg       := "ROMSDDR"

	Pergunte( cPerg, .F.)

	aAdd( aSays, "Essa rotina efetua a geracao da planilha com" )
	aAdd( aSays, "as movimentações por transportado DDR" )

	aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
	aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
	aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1
		Processa( { || ROMSDDRProc() }, "Gerando Planilha DDR" )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROMSDDR   ºAutor  ³Microsiga           º Data ³  04/28/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ROMSDDRProc

	Local aAreaAtu := GetArea()
	Local cQuery := ""
	Local nCount := 0

	Local aCabec := {}
	Local aDados := {}

	cQuery += "SELECT 'S' TIPO, F2_EMISSAO EMISSAO, F2_SERIE SERIE, F2_DOC DOC, F2_TRANSP CODTRAN, A4_NOME NOMTRA, 'SP' ORIG, A1_EST DEST, F2_VALBRUT VALOR "
	cQuery += "  FROM " + RetSQLName( "SF2" ) + " SF2 "
	cQuery += "  JOIN " + RetSQLName( "SA1" ) + " SA1 ON ( SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.D_E_L_E_T_ = ' ' ) "
	cQuery += "  JOIN " + RetSQLName( "SA4" ) + " SA4 ON ( SA4.A4_FILIAL = '" + xFilial( "SA4" ) + "' AND SA4.A4_COD = SF2.F2_TRANSP AND SA4.D_E_L_E_T_ = ' ' ) "
	cQuery += " WHERE SF2.F2_FILIAL  = '" + xFilial( "SF2" ) + "' "
	cQuery += "   AND SF2.F2_EMISSAO BETWEEN '" + Dtos( mv_par01 ) + "' AND '" + Dtos( mv_par02 ) + "' "
	cQuery += "   AND SA4.A4_DDR     = '1' "
	cQuery += "   AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += "UNION "
	cQuery += "SELECT 'E' TIPO, F1_EMISSAO EMISSAO, F1_SERIE SERIE, F1_DOC DOC, F1_TRANSP CODTRAN, A4_NOME NOMTRA, A2_EST ORIG, 'SP' DEST, F1_VALBRUT VALOR "
	cQuery += "  FROM " + RetSQLName( "SF1" ) + " SF1 "
	cQuery += "  JOIN " + RetSQLName( "SA2" ) + " SA2 ON ( SA2.A2_FILIAL = '" + xFilial( "SA2" ) + "' AND SA2.A2_COD = SF1.F1_FORNECE AND SA2.A2_LOJA = SF1.F1_LOJA AND SA2.D_E_L_E_T_ = ' ' ) "
	cQuery += "  JOIN " + RetSQLName( "SA4" ) + " SA4 ON ( SA4.A4_FILIAL = '" + xFilial( "SA4" ) + "' AND SA4.A4_COD = SF1.F1_TRANSP AND SA4.D_E_L_E_T_ = ' ' ) "
	cQuery += " WHERE SF1.F1_FILIAL = '" + xFilial( "SF1" ) + "' "
	cQuery += "   AND SF1.F1_EMISSAO BETWEEN '" + Dtos( mv_par01 ) + "' AND '" + Dtos( mv_par02 ) + "' "
	cQuery += "   AND SA4.A4_DDR = '1' "
	cQuery += "   AND SF1.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY TIPO, EMISSAO, SERIE, DOC, CODTRAN "
	cQuery := ChangeQuery( cQuery )
	If Select( "TMP_DDR" ) > 0
		TMP_DDR->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_DDR", .T., .F. )
	TCSetField( "TMP_DDR", "EMISSAO", "D" )
	TCSetField( "TMP_DDR", "VALOR", "N", 17, 2 )
	TMP_DDR->( dbGoTop() )
	TMP_DDR->( dbEval( { || nCount++ } ) ) 
	TMP_DDR->( dbGoTop() )

	If nCount == 0
		MsgStop( "Não foram encontrados dados para os parametros informados. Verifique os Parametros" )
		TMP_DDR->( dbCloseArea() )
		Return
	Endif

	aAdd( aCabec, "Tipo ( E/S )" )
	aAdd( aCabec, "Data Emissão" )
	aAdd( aCabec, "Serie NF" )
	aAdd( aCabec, "Numero NF" )
	aAdd( aCabec, "Codigo Transportadora" )
	aAdd( aCabec, "Nome Transportadora" )
	aAdd( aCabec, "Origem" )
	aAdd( aCabec, "Destino" )
	aAdd( aCabec, "Valor" )

	ProcRegua( nCount )

	While TMP_DDR->( !Eof() )

		IncProc( "Gerando DDR..." )

		aAdd( aDados, { TMP_DDR->TIPO, TMP_DDR->EMISSAO, TMP_DDR->SERIE, TMP_DDR->DOC, TMP_DDR->CODTRAN, TMP_DDR->NOMTRA, TMP_DDR->ORIG, TMP_DDR->DEST, TMP_DDR->VALOR } )

		TMP_DDR->( dbSkip() )
	End

	TMP_DDR->( dbCloseArea() )

	DlgToExcel( { { "ARRAY", "Planilha DDR", aCabec, aDados } } ) 

	RestArea( aAreaAtu )

Return()