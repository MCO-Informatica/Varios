#INCLUDE "PROTHEUS.CH"

/* ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±± ³Programa  ³MA440MNU  ³ Autor ³ Eneovaldo Roveri Jr   ³ Data ³20/11/2009³±±
±± ³Descricao ³PONTO DE ENTRADA PARA INCLUIR OPÇÃO REPROVAR                ³±±
*/

User Function MA440MNU()
	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MA440MNU" , __cUserID )
	//local lExcept := cEmpAnt == '02'

	aadd( aRotina, {"Reprovar"			,"U_A440REPR"	,0,2,0,NIL} )
	aadd( aRotina, {"e-mail"			,"U_A440EMAIL"	,0,2,0,NIL} )
	aadd( aRotina, {"Só a liberar"		,"U_A440SOAL"	,0,2,0,NIL} )
	aadd( aRotina, {"Gera Excel"		,"U_A440XLS"	,0,2,0,NIL} )
	//if lExcept
		aadd( aRotina, {"Liberar MARGEM"	,"U_A440MARG(1)"	,0,2,0,NIL} )
	//endif
	aadd( aRotina, {"Reprovar MARGEM"	,"U_A440MARG(2)"	,0,2,0,NIL} )
	aadd( aRotina, {'Licenças MNU' ,"U_A440BT01()",0,2,0,NIL} )	
	aadd( aRotina, {"Liberar Risco de Fraude"	,"U_A440MARG(3)"	,0,2,0,NIL} )
	aadd( aRotina, {"Liberar Consignado"	,"U_A440MARG(4)"	,0,2,0,NIL} )
Return( .T. )  


User Function A440SOAL()
	Local cFiltra := "SC5->C5_X_CANC != 'C' .and. SC5->C5_X_REP != 'R'"  // Filtro do Eneo
	Local cFiltro := "Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .AND. DTOS(C5_XENTREG) >= '20100301'"  // Filtro do Daniel
	// cFiltro := BuildExpr("ZAB")
	If !Empty(cFiltro)
		cFiltra := "(" + cFiltra + ") .and. " + cFiltro 
		SC5->(MsFilter(cFiltra))
	Else
		SC5->(DbClearFilter())
		SC5->(MsFilter(cFiltra))
	EndIf

	oMbObj:= GetObjBrow()
	oMbObj:REFRESH()
	Return Nil




	*--------------------*
User Function A440XLS
	*--------------------*
	Local cPerg := "A440XLS"
	Local cQuery     := ""

	If !Pergunte(cPerg, .T.)
		Return .t.
	Endif

	cQuery :="SELECT C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_TRANSP,C5_XENTREG,SA1.A1_NREDUZ,SA1.A1_CGC,SA4.A4_NREDUZ,SA4.A4_CGC,SA1.A1_CONSRF,SA1.A1_VALIDRF,SA1.A1_CONSJ, "
	cQuery +="SA1.A1_VALIDJ ,SA1.A1_CONSSI , SA1.A1_VALIDSI,SA4.A4_CONSRF,SA4.A4_VALIDRF,SA4.A4_CONSJ,SA4.A4_VALIDJ ,SA4.A4_CONSSI , SA4.A4_VALIDSI FROM "+RetSqlName("SC5")+" SC5 "
	cQuery +="LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial('SA1')+"' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
	cQuery +="LEFT JOIN "+RetSqlName("SA4")+" SA4 ON SA4.A4_FILIAL = '"+xFilial('SA4')+"' AND SA4.A4_COD = SC5.C5_TRANSP AND SA4.D_E_L_E_T_ = ' ' "
	cQuery +="WHERE SC5.C5_TIPO IN ('N','C','I','P') AND SC5.D_E_L_E_T_  = ' ' AND SC5.C5_FILIAL = '"+xFilial('SC5')+"' "

	If ! Empty( mv_par01 ) .And. ! Empty( mv_par02 )
		cQuery += "  AND    SC5.C5_XENTREG  between '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02)+ "' "
	Endif

	cQuery+=" ORDER BY SC5.C5_XENTREG "

	If Select("TSC5") > 0
		TSC5->( dbCloseArea() )
	EndIf

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TSC5", .F., .T.)

	TCSETFIELD( "TSC5","C5_XENTREG","D")
	TCSETFIELD( "TSC5","A1_CONSRF","D")
	TCSETFIELD( "TSC5","A1_CONSJ","D")
	TCSETFIELD( "TSC5","A1_CONSSI","D")
	TCSETFIELD( "TSC5","A1_VALIDRF","D")
	TCSETFIELD( "TSC5","A1_VALIDJ","D")
	TCSETFIELD( "TSC5","A1_VALIDSI","D")
	TCSETFIELD( "TSC5","A4_CONSRF","D")
	TCSETFIELD( "TSC5","A4_CONSJ","D")
	TCSETFIELD( "TSC5","A4_CONSSI","D")
	TCSETFIELD( "TSC5","A4_VALIDRF","D")
	TCSETFIELD( "TSC5","A4_VALIDJ","D")
	TCSETFIELD( "TSC5","A4_VALIDSI","D")

	Processa( {||GeraXLS() }, OemToAnsi("Gerando Planilha"), "Geracao da Planilha" )


	*---------------------*
Static Function GeraXLS()
	*---------------------*                         
	Local aCabec := {}
	Local aDados := {}     
	Local nJ := 0
	Local ni := 0 

	aadd(aCabec, "Nr.Pedido"  )
	aadd(aCabec, "Entrega"  )
	aadd(aCabec, "TP.Cadastro"  )
	aadd(aCabec, "Codigo"  )
	aadd(aCabec, "CNPJ"  )
	aadd(aCabec, "Nome Reduz." )
	aadd(aCabec, "Tipo Consulta" )
	aadd(aCabec, "Data Consulta" )
	aadd(aCabec, "Data Validade" )
	aadd(aCabec, "Prazo" )
	aadd(aCabec, "Situacao")

	cSituacao:=""

	TSC5->( dbGoTop() )

	ProcRegua(0)
	While TSC5->( !EOF() )

		incproc()

		For nI:=1 to 2
			cTipo:=If(nI==1,"Cliente","Transportadora")

			cSituacao:=""
			If nI == 1
				nPrazo:=TSC5->A1_VALIDRF - dDataBase

				If Empty(TSC5->A1_VALIDRF)
					cSituacao:= "Nao Efetuada"
					nPrazo:=0
				Else
					If nPrazo < 0
						cSituacao:= "Vencida"
					Else
						cSituacao:= "A Vencer"   
					Endif
				Endif
				If cSituacao <> "A Vencer" // Empty(TSC5->A1_CONSRF)
					aadd(aDados, { "'"+TSC5->C5_NUM+"'"												,;
					TSC5->C5_XENTREG													,;
					cTipo															,;
					"'"+TSC5->C5_CLIENTE+"'"											,;
					Trans(TSC5->A1_CGC,'@R 99.999.999/9999-99')					 	,;
					TSC5->A1_NREDUZ												 	,;
					"Receita Federal" 												,;
					TSC5->A1_CONSRF 													,;
					TSC5->A1_VALIDRF													,;
					STR(nPrazo,5)+" Dias" 											,;
					cSituacao														})
				Endif      
			Else

				/*	  	   aadd(aDados, {  "" 																,;
				""																,;
				""																,;
				""																,;
				""															 	,;
				""															 	,;
				""				 												,;
				""			 													,;
				""																,;
				"" 																,;
				"" 																})
				*/
				nPrazo:=TSC5->A4_VALIDRF - dDataBase
				If Empty(TSC5->A4_VALIDRF)
					cSituacao:= "Nao Efetuada"
					nPrazo:= 0
				Else
					If nPrazo < 0
						cSituacao:= "Vencida"
					Else
						cSituacao:= "A Vencer"   
					Endif
				Endif
				If cSituacao <> "A Vencer" // Empty(TSC5->A4_CONSRF )
					aadd(aDados, { "'"+TSC5->C5_NUM+"'"												,;
					TSC5->C5_XENTREG													,;
					cTipo															,;
					"'"+TSC5->C5_TRANSP+"'"											,;
					Trans(TSC5->A4_CGC,'@R 99.999.999/9999-99')					 	,;
					TSC5->A4_NREDUZ												 	,;
					"Receita Federal" 												,;
					TSC5->A4_CONSRF 													,;
					TSC5->A4_VALIDRF													,;
					STR(nPrazo,5)+" Dias"											,;
					cSituacao														 })
				Endif
			Endif

			For nJ := 2 to 3

				cTipCons:=If(nJ==2,"Simples Nacional","Sintegra")

				If cTipCons == "Simples Nacional"  .and. cTipo == "Cliente"
					nPrazo:= TSC5->A1_VALIDJ - dDatabase
					dData:=TSC5->A1_VALIDJ
				Endif

				If cTipCons == "Simples Nacional" .and. cTipo == "Transportadora"
					nPrazo:= TSC5->A4_VALIDJ - dDatabase
					dData := TSC5->A4_VALIDJ
				Endif

				If cTipCons == "Sintegra" .and. cTipo == "Cliente"
					nPrazo:= TSC5->A1_VALIDSI - dDatabase
					dData := TSC5->A1_VALIDSI
				Endif

				If cTipCons == "Sintegra" .and. cTipo == "Transportadora" 
					nPrazo:= TSC5->A4_VALIDSI - dDatabase
					dData := TSC5->A4_VALIDSI
				Endif

				If Empty(dData)
					cSituacao:= "Nao Efetuada"
					nPrazo:=0
				Else
					If nPrazo < 0
						cSituacao:= "Vencida"
					Else
						cSituacao:= "A Vencer"   
					Endif
				Endif

				If nI == 1
					If cSituacao <> "A Vencer" // Empty( If(nJ==2,TSC5->A1_CONSJ ,TSC5->A1_CONSSI) )
						aadd(aDados, { ""																,;
						"" 																,;
						cTipo															,;
						"'"+TSC5->C5_CLIENTE+"'"											,;
						Trans(TSC5->A1_CGC,'@R 99.999.999/9999-99')					 	,;
						TSC5->A1_NREDUZ												 	,;
						cTipCons	`		 												,;
						If(nJ==2,TSC5->A1_CONSJ ,TSC5->A1_CONSSI)						,;
						If(nJ==2,TSC5->A1_VALIDJ,TSC5->A1_VALIDSI)						,;
						STR(nPrazo,5)+" Dias" 											,;
						cSituacao														})
					Endif            
				Else
					If cSituacao <> "A Vencer" // Empty( If(nJ==2,TSC5->A4_CONSJ ,TSC5->A4_CONSSI) )
						aadd(aDados, { ""																,;
						"" 																,;
						cTipo															,;
						"'"+TSC5->C5_TRANSP+"'"											,;
						Trans(TSC5->A4_CGC,'@R 99.999.999/9999-99')					 	,;
						TSC5->A4_NREDUZ												 	,;
						cTipCons	`		 												,;
						If(nJ==2,TSC5->A4_CONSJ ,TSC5->A4_CONSSI)						,;
						If(nJ==2,TSC5->A4_VALIDJ,TSC5->A4_VALIDSI)						,;
						STR(nPrazo,5)+" Dias" 											,;
						cSituacao														})

					Endif
				Endif
			Next nJ
		Next nI
		/*	aadd(aDados, {  "" 																,;
		""																,;
		""																,;
		""																,;
		""															 	,;
		""															 	,;
		""				 												,;
		""			 													,;
		""																,;
		""																,;
		"" 																})
		*/   
		TSC5->(dbskip())
	End
	DlgToExcel({ {"ARRAY", "Consultas Periodicas", aCabec, aDados} }) 

	//TSZJ->( dbCloseArea() )

Return .t.
