//---------------------------------------------------------------------
// Rotina | CSFA450      | Autor | Robson Gonçalves | Data | 08.10.2014 
//---------------------------------------------------------------------
// Descr. | Fornecedor com PA e outros títulos em aberto.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
#Include 'Protheus.ch'
#Include 'Report.ch'
User Function CSFA450()
	Local oReport
	oReport := A450Proc()
	oReport:PrintDialog()
Return
//---------------------------------------------------------------------
// Rotina | A450Proc     | Autor | Robson Gonçalves | Data | 08.10.2014 
//---------------------------------------------------------------------
// Descr. | Processamento e definição de células de impressão.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A450Proc()
	Local oReport
	Local oSection
	Local cTitulo := "Mapa de PA em aberto"
	Local cDescr := "Relatório que apresenta fornecedor com PA e outros títulos em aberto."
	Local cPerg := 'CSFA450'
	
	CriaSX1( cPerg )
	
	Pergunte(cPerg,.F.)
	
	oReport := TReport():New("CSFA450", cTitulo, cPerg, {|oReport| A450Print( oReport, cPerg )}, cDescr)
	oReport:DisableOrientation()
	oReport:cFontBody := 'Consolas'
	oReport:nFontBody	:= 7
	oReport:nLineHeight := 42
	oReport:SetPortrait() 
	oReport:SetTotalInLine( .F. )
	
	DEFINE SECTION oSection OF oReport TABLES "SE2" TITLE cTitulo
	oSection:SetTotalInLine(.F.)

Return( oReport )
//---------------------------------------------------------------------
// Rotina | A450Print    | Autor | Robson Gonçalves | Data | 08.10.2014 
//---------------------------------------------------------------------
// Descr. | Processamento e impressão dos dados.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function A450Print( oReport, cPerg )
	Local cTRB := GetNextAlias()
	
	Local oSection1 := oReport:Section(1)
   Local oSection2
   
   Local cPict := "@E 999,999,999.99"
   
	oSection1:SetPageBreak(MV_PAR15==1)
	
	DEFINE SECTION oSection2 OF oSection1 TABLES "SE2" TITLE 'Fornecedores' TOTAL TEXT 'TOTAL FORNECEDOR' TOTAL IN COLUMN

	DEFINE CELL NAME "A2_NOME"    OF oSection2 ALIAS "SA2" TITLE "Nome fornecedor" 
	DEFINE CELL NAME "E2_FORNECE" OF oSection2 ALIAS "SE2" TITLE "Código"     SIZE 06
	DEFINE CELL NAME "E2_LOJA"    OF oSection2 ALIAS "SE2" TITLE "Loja"       SIZE 02
	DEFINE CELL NAME "E2_EMISSAO"	OF oSection2 ALIAS "SE2" TITLE 'Emissao'    SIZE 10
	DEFINE CELL NAME "E2_VENCTO"  OF oSection2 ALIAS "SE2" TITLE 'Vencimento' SIZE 10 
	DEFINE CELL NAME "E2_PREFIXO"	OF oSection2 ALIAS "SE2" TITLE 'Prefixo'    SIZE 03
	DEFINE CELL NAME "E2_NUM"	   OF oSection2 ALIAS "SE2" TITLE 'Titulo'     SIZE 09
	DEFINE CELL NAME "E2_PARCELA" OF oSection2 ALIAS "SE2" TITLE 'Parcela'    SIZE 02
	DEFINE CELL NAME "E2_TIPO"    OF oSection2 ALIAS "SE2" TITLE 'Tipo'       SIZE 03
	DEFINE CELL NAME "E2_VALOR"   OF oSection2 ALIAS "SE2" TITLE 'Valor'      SIZE 14 ALIGN RIGHT PICTURE cPict   
	DEFINE CELL NAME "E2_SALDO"   OF oSection2 ALIAS "SE2" TITLE 'Saldo'      SIZE 14 ALIGN RIGHT PICTURE cPict   
	
	oSection2:SetColSpace(1)
	
	oSection1:BeginQuery()
		BeginSql Alias cTRB
			SELECT SA2.A2_NOME, 
			       SE2.E2_FORNECE, 
			       SE2.E2_LOJA, 
			       SE2.E2_EMISSAO, 
			       SE2.E2_VENCTO, 
			       SE2.E2_PREFIXO, 
			       SE2.E2_NUM, 
			       SE2.E2_PARCELA, 
			       SE2.E2_TIPO, 
			       CASE 
			          WHEN SE2.E2_TIPO = 'PA'  THEN SE2.E2_VALOR * (-1)
			          WHEN SE2.E2_TIPO = 'NDF' THEN SE2.E2_VALOR * (-1)
			          ELSE E2_VALOR
			       END AS E2_VALOR,
			       CASE 
			          WHEN SE2.E2_TIPO = 'PA'  THEN SE2.E2_SALDO * (-1)
			          WHEN SE2.E2_TIPO = 'NDF' THEN SE2.E2_SALDO * (-1)
			          ELSE SE2.E2_SALDO
			       END AS E2_SALDO
			FROM   %table:SE2% SE2 
			       INNER JOIN (SELECT SE2A.E2_FILIAL, 
			                          SE2A.E2_FORNECE, 
			                          SE2A.E2_LOJA 
			                   FROM   %table:SE2% SE2A
			                   WHERE  E2_FILIAL = %xFilial:SE2%
			                          AND SE2A.E2_TIPO IN ('PA','NDF')
			                          AND SE2A.E2_SALDO > 0
			                          AND SE2A.%notDel% 
			                   GROUP  BY SE2A.E2_FILIAL, 
			                             SE2A.E2_FORNECE, 
			                             SE2A.E2_LOJA) ONLY_PA 
			               ON SE2.E2_FILIAL = ONLY_PA.E2_FILIAL 
			                  AND SE2.E2_FORNECE = ONLY_PA.E2_FORNECE 
			                  AND SE2.E2_LOJA = ONLY_PA.E2_LOJA 
			       INNER JOIN %table:SA2% SA2
			               ON A2_FILIAL = %xFilial:SA2%
			                  AND SA2.A2_COD = SE2.E2_FORNECE 
			                  AND SA2.A2_LOJA = SE2.E2_LOJA 
			                  AND SA2.%notDel% 
			WHERE  SE2.E2_FILIAL = %xFilial:SE2%
			       AND SE2.E2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			       AND SE2.E2_VENCTO  BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
			       AND SE2.E2_FORNECE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR07%
			       AND SE2.E2_LOJA    BETWEEN %Exp:MV_PAR06% AND %Exp:MV_PAR08%
			       AND SE2.E2_PREFIXO BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
			       AND SE2.E2_NUM     BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12%
			       AND SE2.E2_PARCELA BETWEEN %Exp:MV_PAR13% AND %Exp:MV_PAR14%
			       AND SE2.E2_SALDO > 0
			       AND SE2.%notDel% 
			ORDER  BY SA2.A2_NOME, 
			          E2_EMISSAO 
		EndSql
	oSection1:EndQuery()

	oSection2:SetParentQuery()
	oSection2:SetParentFilter({|cParam| (cTRB)->( E2_FORNECE + E2_LOJA ) == cParam },{|| (cTRB)->( E2_FORNECE + E2_LOJA ) } )
	
	TRFunction():New(oSection2:Cell("E2_NUM")    ,"","COUNT",,"","@E 999")
	TRFunction():New(oSection2:Cell("E2_VALOR")  ,"","SUM"  ,,"",cPict   )
	TRFunction():New(oSection2:Cell("E2_SALDO")  ,"","SUM"  ,,"",cPict   )
	
	If MV_PAR16==1
		DEFINE COLLECTION OF oSection2 FUNCTION SUM FORMULA oSection2:Cell('E2_TIPO') CONTENT oSection2:Cell("E2_SALDO") TITLE 'Total por tipo'
	Endif
	
	oSection1:Print()
Return
//---------------------------------------------------------------------
// Rotina | CriaSX1      | Autor | Robson Gonçalves | Data | 08.10.2014 
//---------------------------------------------------------------------
// Descr. | Rotina para criar o grupo de perguntas.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function CriaSX1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}

	AAdd(aP,{"Emissão de?"    ,"D",08,0,"G","","","","","","","",""})
	AAdd(aP,{"Emissão ate?"   ,"D",08,0,"G","","","","","","","",""})
	AAdd(aP,{"Vencimento de?" ,"D",08,0,"G","","","","","","","",""})
	AAdd(aP,{"Vencimento ate?","D",08,0,"G","","","","","","","",""})
	AAdd(aP,{"Fornecedor de?" ,"C",06,0,"G","","SA2","","","","","",""})
	AAdd(aP,{"Loja de?"       ,"C",02,0,"G","","","","","","","",""})
	AAdd(aP,{"Fornecedor ate?","C",06,0,"G","","SA2","","","","","",""})
	AAdd(aP,{"Loja ate?"      ,"C",02,0,"G","","","","","","","",""})
	AAdd(aP,{"Prefixo de?"    ,"C",03,0,"G","","","","","","","",""})
	AAdd(aP,{"Prefixo ate?"   ,"C",03,0,"G","","","","","","","",""})
	AAdd(aP,{"Titulo de?"     ,"C",09,0,"G","","","","","","","",""})
	AAdd(aP,{"Titulo ate?"    ,"C",09,0,"G","","","","","","","",""})
	AAdd(aP,{"Parcela de?"    ,"C",02,0,"G","","","","","","","",""})
	AAdd(aP,{"Parcela ate?"   ,"C",02,0,"G","","","","","","","",""})
	AAdd(aP,{"Saltar pagina por fornecedor?","N",01,0,"C","","","Sim","Nao","","","",""})
	AAdd(aP,{"Imprimir total por tipo?"      ,"N",01,0,"C","","","Sim","Nao","","","",""})

	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})
	AAdd(aHelp,{"",""})

	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		
		PutSx1(cPerg,;
		cSeq,;
		aP[i,1],aP[i,1],aP[i,1],;
		cMvCh,;
		aP[i,2],;
		aP[i,3],;
		aP[i,4],;
		0,;
		aP[i,5],;
		aP[i,6],;
		aP[i,7],;
		"",;
		"",;
		cMvPar,;
		aP[i,8],aP[i,8],aP[i,8],;
		aP[i,13],;
		aP[i,9],aP[i,9],aP[i,9],;
		aP[i,10],aP[i,10],aP[i,10],;
		aP[i,11],aP[i,11],aP[i,11],;
		aP[i,12],aP[i,12],aP[i,12],;
		aHelp[i],;
		{},;
		{},;
		"")
	Next i
Return

//---------------------------------------------------------------------
// Rotina | A450HaPa     | Autor | Robson Gonçalves | Data | 09.10.2014 
//---------------------------------------------------------------------
// Descr. | Rotina acionada pelos gatilhos E2_FORNECE e E2_LOJA.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A450HaPA()
	Local lRet := .T.
	Local cSQL := ''
	Local cTRB := ''
	Local cReadVar := ''
	Local aArea := {}
	Local cDBMS := ''
	cReadVar := ReadVar()
	aArea := { GetArea(), SA2->( GetArea() ), SE2->( GetArea() ) }
	If .NOT. Empty(M->E2_FORNECE) .AND. .NOT. Empty(M->E2_LOJA)
		cDBMS := Upper( TcGetDb() )
		If cDBMS == 'ORACLE'
			cSQL := "SELECT NVL(COUNT(*),0) AS QUANTREG "
		Elseif cDBMS == 'MSSQL'
			cSQL := "SELECT ISNULL(COUNT(*),0) AS QUANTREG "
		Endif
		If .NOT. Empty( cSQL )
			cSQL += "FROM   " + RetSqlName( "SE2" ) + " SE2 "
			cSQL += "WHERE  E2_FILIAL = " + ValToSql( xFilial( "SE2" ) ) + " "
			cSQL += "       AND E2_FORNECE = "+ValToSql (M->E2_FORNECE ) + " "
			cSQL += "       AND E2_TIPO = 'PA' "
			cSQL += "       AND E2_SALDO > 0 "
			cSQL += "       AND SE2.D_E_L_E_T_ = ' ' "
			cTRB := GetNextAlias()
			PLSQuery( cSQL, cTRB )
			If (cTRB)->( QUANTREG ) > 0
				MsgAlert( '*** ATENÇÃO ***' + Chr( 13 ) + Chr( 10 ) + ;
				'Existem pagamentos antecipados (PA) para o forncedor informado:' + Chr( 13 ) + Chr( 10 ) + ;
				'[' + M->E2_FORNECE + '-' + M->E2_LOJA + '] ' + RTrim( Posicione( 'SA2', 1, xFilial( 'SA2' ) + 	M->E2_FORNECE + M->E2_LOJA, 'A2_NOME' ) ) )
			Endif
			(cTRB)->( dbCloseArea() )
		Endif
	Endif
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return( &( cReadVar ) )

//---------------------------------------------------------------------
// Rotina | A450ALPA     | Autor | Robson Gonçalves | Data | 09.10.2014 
//---------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada FA050Alt.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A450ALPA()
	U_A450HaPa()
Return(.T.)

//---------------------------------------------------------------------
// Rotina | A450BAPA     | Autor | Robson Gonçalves | Data | 13.10.2014 
//---------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada FA080Pos.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A450BAPA()
	M->E2_FORNECE := SE2->E2_FORNECE
	M->E2_LOJA    := SE2->E2_LOJA
	U_A450HaPa()
Return

//---------------------------------------------------------------------
// Rotina | A450BOPA     | Autor | Robson Gonçalves | Data | 13.10.2014 
//---------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada F240Tit.
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A450BOPA()
	M->E2_FORNECE := E2_FORNECE
	M->E2_LOJA    := E2_LOJA
	U_A450HaPa()
Return

//---------------------------------------------------------------------
// Rotina | A450UPX7     | Autor | Robson Gonçalves | Data | 09.10.2014 
//---------------------------------------------------------------------
// Descr. | Rotina update que deverá ser executada pelo formulas. O 
//        | objetivo é criar os gatilhos em E2_FORNECE e E2_LOJA.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function A450UPX7()
	Local lExiste := .F.
	Local cX7_SEQUENC := ''
	If MsgYesNo('Este UpDate irá criar dois gatilhos E2_FORNECE e E2_LOJA, prosseguir com a atualização?')
		SX7->( dbSetOrder( 1 ) )
		If SX7->( dbSeek( 'E2_FORNECE') )
			While .NOT. SX7->( EOF() ) .AND. RTrim( SX7->X7_CAMPO ) == 'E2_FORNECE'
				If RTrim( SX7->X7_CAMPO ) == 'E2_FORNECE' .AND. RTrim( SX7->X7_REGRA ) == 'U_A450HAPA()' 
					lExiste := .T.
				Endif
				cX7_SEQUENC := SX7->X7_SEQUENC
				SX7->( dbSkip() )
			End
		Else
			cX7_SEQUENC := '000'
		Endif
		If .NOT. lExiste .AND. cX7_SEQUENC <> ''
			SX7->( RecLock( 'SX7', .T. ) )
			SX7->X7_CAMPO   := 'E2_FORNECE'
			SX7->X7_SEQUENC := Soma1( cX7_SEQUENC )
			SX7->X7_REGRA   := 'U_A450HAPA()' 
			SX7->X7_CDOMIN  := 'E2_FORNECE'
			SX7->X7_TIPO    := 'P'
			SX7->X7_SEEK    := 'N'
			SX7->X7_PROPRI  := 'U'
			SX7->( MsUnLock() )
			SX3->( dbSetOrder( 2 ) )
			If SX3->( dbSeek( 'E2_FORNECE' ) )
				If SX3->X3_TRIGGER <> 'S'
					SX3->( RecLock( 'SX3', .F. ) )
					SX3->X3_TRIGGER := 'S'
					SX3->( MsUnLock() )
				Endif
			Endif
		Endif
		lExiste := .F.
		cX7_SEQUENC := ''
		SX7->( dbSetOrder( 1 ) )
		If SX7->( dbSeek( 'E2_LOJA') )
			While .NOT. SX7->( EOF() ) .AND. RTrim( SX7->X7_CAMPO ) == 'E2_LOJA'
				If RTrim( SX7->X7_CAMPO ) == 'E2_LOJA' .AND. RTrim( SX7->X7_REGRA ) == 'U_A450HAPA()' 
					lExiste := .T.
				Endif
				cX7_SEQUENC := SX7->X7_SEQUENC
				SX7->( dbSkip() )
			End
		Else
			cX7_SEQUENC := '000'
		Endif
		If .NOT. lExiste .AND. cX7_SEQUENC <> ''
			SX7->( RecLock( 'SX7', .T. ) )
			SX7->X7_CAMPO   := 'E2_LOJA'
			SX7->X7_SEQUENC := Soma1( cX7_SEQUENC )
			SX7->X7_REGRA   := 'U_A450HAPA()' 
			SX7->X7_CDOMIN  := 'E2_LOJA'
			SX7->X7_TIPO    := 'P'
			SX7->X7_SEEK    := 'N'
			SX7->X7_PROPRI  := 'U'
			SX7->( MsUnLock() )
			SX3->( dbSetOrder( 2 ) )
			If SX3->( dbSeek( 'E2_LOJA' ) )
				If SX3->X3_TRIGGER <> 'S'
					SX3->( RecLock( 'SX3', .F. ) )
					SX3->X3_TRIGGER := 'S'
					SX3->( MsUnLock() )
				Endif
			Endif
		Endif
	Endif
Return