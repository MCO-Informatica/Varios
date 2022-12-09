//-----------------------------------------------------------------------
// Rotina | CSFA190    | Autor | Robson Gonçalves     | Data | 02.07.2013
//-----------------------------------------------------------------------
// Descr. | Clientes descontinuados - Gerar Agenda Certisign.
//        | Campanha volta pra mim.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'

User Function CSFA190()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Local cDescr1 := ''
	Local cDescr2 := ''
	
	Private l190Query := .F. 
	Private cCadastro := 'Clientes descontinuados'
	
	cDescr1 := 'Esta rotina aponta a não recorrência e a recorrência de vendas por clientes.'
	cDescr2 := 'Com isso será possível gerar Agenda Certisign para regastar clientes descontinuados.'
	
	SetKey( VK_F12 , {|| l190Query := MsgYesNo('Exportar a string da query principal?',cCadastro ) } )

	AAdd( aSay, cDescr1 )
	AAdd( aSay, cDescr2 )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	SetKey( VK_F12 , NIL )

	If nOpcao==1
		A190Param()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A190Param  | Autor | Robson Gonçalves     | Data | 02.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para solicitar os parâmetros de processamento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190Param()
	Local lRet := .T.
	
	Local bOk := {|| .T. }
	
	Local aPar := {}
	Local aRet := {}
	Local aOpcResult:= {}
	
	Private n190AnoDe := 0
	Private n190AnoAte := 0
	Private n190Result := 0
	
	Private c190Segm := ''
	Private c190Result := ''
	Private c190Campan := ''
	
	Private aCOLS1 := {}
	Private aHeader1 := {}
	
	Private aCOLS2 := {}
	Private aHeader2 := {}

	A190CanUse()
	
	aOpcResult := {'1-Não recorrentes','2-Recorrentes','3-Ambos'}
	
	bOk := {|| Iif(((mv_par02-mv_par01)+1)<7,;
	           (MsgAlert('Período menor que sete anos, selecione período maior ou igual a sete anos.',cCadastro),.F.),.T.) }
	
	AAdd( aPar, { 1, 'Ano inicial'           ,2007,'','U_A190DtVl()','','',050,.F. } )
	AAdd( aPar, { 1, 'Ano final'             ,Year(dDataBase),'','(mv_par02>=mv_par01).And.U_A190DtVl()','','.F.',050,.T. } )
	AAdd( aPar, { 1, 'Quais segmentos'       ,Space(70),'','','CFA190','',110,.T. } )
	AAdd( aPar, { 3, 'Apresentar resultados' ,1,aOpcResult,99,'',.T. } )
	AAdd( aPar, { 1, "Campanha"              ,Space(Len(SUO->(UO_CODCAMP))),"@!","Vazio().Or.ExistCpo('SUO')","SUO","",50,.F.})

	If !ParamBox( aPar, 'Parâmetros de processamento',@aRet,bOk,,,,,,,.F.,.F.)
		Return
	Endif
	
	n190AnoDe  := aRet[ 1 ]
	n190AnoAte := aRet[ 2 ]
	c190Segm   := RTrim( aRet[ 3 ] )
	n190Result := aRet[ 4 ]
	c190Result := SubStr( aOpcResult[ n190Result ], 3 )
	c190Campan := aRet[ 5 ]
	
	Processa( {|| lRet := A190Proc() }, cCadastro,"Aguarde, processando os dados...", .F. ) 
	
	If lRet
		A190Show()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A190Proc   | Autor | Robson Gonçalves     | Data | 02.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para montar a query e os arrays aHeader e aCOLS.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190Proc()
	Local nI := 0
	Local nP := 0
	Local nJ := 0
	Local nK := 0
	Local nPeso := 10
	
	Local cAno := ''
	Local cAux := ''
	Local cYear := ''
	Local cColuna := ''
	Local cContido := ''

	Local cSQL := ''
	Local cTRB := ''
	
	Local aAnos := {}
	Local aCPO := {}
	Local aCPO_COL := {}

	//-------------------------------------------
	// Montar vetor com início e fim de cada ano.
	//-------------------------------------------
	For nI := n190AnoDe To n190AnoAte
		cAno := LTrim( Str( nI, 4, 0 ) )
		// [1] Início do ano (aaaammdd).
		// [2] Fim do ano (aaaammdd).
		// [3] Ano.
		// [4] Peso, valor incial 10.
		AAdd( aAnos, { cAno +'0101', cAno+'1231', nI, nPeso++ } )
	Next nI
	
	//---------------------------------
	// Montar a condição IN para query.
	//---------------------------------
	If Right( c190Segm, 1) <> ';'
		c190Segm := c190Segm + ';'
	Endif
	
	cAux := c190Segm
	cContido := "('"
	While ! Empty( cAux )
		nP := At( ';', cAux )
		cContido += SubStr( cAux, 1, nP-1 ) + "','"
		cAux := SubStr( cAux, nP+1 )
	End
	cContido := SubStr( cContido, 1, Len( cContido ) -2 )
	cContido := cContido + ")"

	//-----------------------
	// Campos fixos da query.
	//-----------------------
	AAdd( aCPO, 'C7_ITEM' )
	AAdd( aCPO, 'B1_XSEG' )
	AAdd( aCPO, 'Z1_DESCSEG' )
	AAdd( aCPO, 'A1_COD' )
	AAdd( aCPO, 'A1_LOJA' )
	AAdd( aCPO, 'A1_NOME' )
	AAdd( aCPO, 'K1_OPERAD' )
	AAdd( aCPO, 'PAB_DTATUA' )
	AAdd( aCPO, 'B1_COD' )
	AAdd( aCPO, 'B1_DESC' )
	
	//---------------------------
	// Campos flexíveis da query.
	//---------------------------
	For nI := n190AnoDe To n190AnoAte
		cAno := LTrim( Str( nI, 4, 0 ) )
		AAdd( aCPO, 'ANO_'+cAno )
	Next nI	

	//---------------------------------------------------
	// Montagem da string para query conforme parâmetros.
	//---------------------------------------------------
	cSQL := "SELECT B1_XSEG      SEGMENTO, " + CRLF 
	cSQL += "       Z1_DESCSEG   DESCR_SEGMENTO, " + CRLF 
	cSQL += "       CODIGO,  " + CRLF 
	cSQL += "       LOJA,  " + CRLF 
	cSQL += "       A1_NOME      CLIENTE,  " + CRLF 
	cSQL += "       PRODUTO,  " + CRLF 
	cSQL += "       B1_DESC      DESCRICAO,  " + CRLF 
	
	For nI := n190AnoDe To n190AnoAte
		cAno := LTrim( Str( nI, 4, 0 ) )
		If nI <> n190AnoAte
			cColuna += "       MAX(ANO"+cAno+") ANO_"+cAno+", " + CRLF
		Else
			cColuna += "       MAX(ANO"+cAno+") ANO_"+cAno+" " + CRLF
		Endif
	Next nI
	cSQL += cColuna 
	
	cSQL += "FROM   ( " + CRLF
	
	nP := 0
	cColuna := ""
	For nI := n190AnoDe To n190AnoAte
		nP++
		cAno := LTrim( Str( nI, 4, 0 ) )
		cColuna += " SELECT D2_CLIENTE AS CODIGO, " + CRLF
		cColuna += "        D2_LOJA    AS LOJA, " + CRLF
		cColuna += "        D2_COD     AS PRODUTO, " + CRLF
		
		For nJ := n190AnoDe To n190AnoAte
			nK++
			cYear := LTrim( Str( nJ, 4, 0 ) )
			If nK == nP
				cColuna += "        'X'        AS ANO"+cYear+", " + CRLF
			Else
				cColuna += "        ' '        AS ANO"+cYear+", " + CRLF
			Endif
		Next nJ
		nK := 0
		cColuna := SubStr( cColuna, 1, Len( cColuna ) -4 )
		
		cColuna += " FROM "+RetSqlName("SD2")+" " + CRLF
		cColuna += " WHERE D2_FILIAL = "+ValToSql(xFilial("SD2"))+" AND D2_COD IN ( SELECT B1_COD " + CRLF
		cColuna += "                                                                FROM "+RetSqlName("SB1")+" SB1 " + CRLF
		cColuna += "                                                                WHERE B1_FILIAL = "+ValToSql(xFilial("SB1"))+" " + CRLF
		cColuna += "                                                                      AND SB1.D_E_L_E_T_ = ' ' " + CRLF
		cColuna += "                                                                      AND B1_XSEG IN "+cContido+") " + CRLF
		cColuna += "       AND D2_EMISSAO BETWEEN "+ValToSql(aAnos[nP,1])+" AND "+ValToSql(aAnos[nP,2])+" " + CRLF
		cColuna += "       AND D_E_L_E_T_ = ' ' " + CRLF
		cColuna += " UNION "
	Next nI
	cColuna := SubStr( cColuna, 1, Len( cColuna ) -7 ) + ") " + CRLF
	
	cSQL += cColuna 
	
	cSQL += "       INNER JOIN "+RetSqlName("SA1")+" SA1  " + CRLF 
	cSQL += "               ON A1_FILIAL = "+ValToSql( xFilial( "SA1" ) )+"  " + CRLF 
	cSQL += "                  AND A1_COD = CODIGO  " + CRLF 
	cSQL += "                  AND A1_LOJA = LOJA  " + CRLF 
	cSQL += "                  AND SA1.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" SB1  " + CRLF 
	cSQL += "               ON B1_FILIAL = "+ValToSql( xFilial( "SB1" ) )+"  " + CRLF 
	cSQL += "                  AND B1_COD = PRODUTO  " + CRLF 
	cSQL += "                  AND SB1.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "       INNER JOIN "+RetSqlName("SZ1")+" SZ1 " + CRLF 
	cSQL += "               ON SZ1.Z1_FILIAL = "+ValToSql( xFilial( "SZ1" ) )+" " + CRLF 
	cSQL += "                  AND SZ1.Z1_CODSEG = SB1.B1_XSEG " + CRLF 
	cSQL += "                  AND SZ1.D_E_L_E_T_ = ' ' " + CRLF 
	cSQL += "GROUP  BY B1_XSEG, " + CRLF 
	cSQL += "          PRODUTO, " + CRLF 
	cSQL += "          CODIGO,  " + CRLF 
	cSQL += "          LOJA,  " + CRLF 
	cSQL += "          A1_NOME,  " + CRLF 
	cSQL += "          B1_DESC,  " + CRLF 
	cSQL += "          Z1_DESCSEG " + CRLF 
	cSQL += "ORDER BY B1_XSEG, PRODUTO, CLIENTE"

   If l190Query
		A190Script( cSQL )   
   Endif

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	
	If !(cTRB)->(BOF()) .And. !(cTRB)->(EOF())
		//-----------------------------------------------------
		// Associação dos campos da query com o campo do vetor.
		// [1] COLUNA DA QUERY
		// [2] NOME DO CAMPO NO aCOLS
		//-----------------------------------------------------
		AAdd( aCPO_COL, { 'SEGMENTO'      , 'B1_XSEG' } )
		AAdd( aCPO_COL, { 'DESCR_SEGMENTO', 'Z1_DESCSEG' } )
		AAdd( aCPO_COL, { 'CODIGO'        , 'A1_COD' } )
		AAdd( aCPO_COL, { 'LOJA'          , 'A1_LOJA' } )
		AAdd( aCPO_COL, { 'CLIENTE'       , 'A1_NOME' } )
		AAdd( aCPO_COL, { 'PRODUTO'       , 'B1_COD' } )
		AAdd( aCPO_COL, { 'DESCRICAO'     , 'B1_DESC' } )
		
		//---------------------------
		// Montagem do(s) aHeader(s).
		//---------------------------
		A190Header( aCPO, @aHeader1, @aHeader2 )
		
		//-------------------------
		// Montagem do(s) aCOLS(s).
		//-------------------------
		A190Cols( cTRB, aCPO, aCPO_COL, aHeader1, @aCOLS1, @aCOLS2, aAnos )
		
		(cTRB)->( dbCloseArea() )
	Else
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
	Endif
Return(Len(aCOLS1)>0)

//-----------------------------------------------------------------------
// Rotina | A190Header | Autor | Robson Gonçalves     | Data | 05.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para montar a query e os arrays aHeader e aCOLS.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190Header( aCPO, aHeader1, aHeader2 )
	Local nI := 0
	Local nP := 0
	
	SX3->(dbSetOrder(2))
	For nI := 1 To Len( aCPO )
		If Left( aCPO[ nI ], 4 ) == 'ANO_'
			AAdd( aHeader1, { aCPO[ nI ], aCPO[ nI ] , '@!', 1, 0, 'AllWaysTrue', '', 'C', '', 'V'} )
		Else
			SX3->( dbSeek( aCPO[ nI ] ) )
			SX3->( AAdd( aHeader1, {RTrim(X3_TITULO),RTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT } ) )
		Endif
	Next nI
	
	//--------------------------------
	// Modificar o título das colunas.
	//--------------------------------
	nP := AScan( aHeader1, {|p| p[2]=='A1_COD' } )
	If nP > 0
		aHeader1[ nP, 1 ] := 'Cliente'
	Endif
	
	nP := AScan( aHeader1, {|p| p[2]=='A1_NOME' } )
	If nP > 0
		aHeader1[ nP, 1 ] := 'Razão Social'
	Endif
	
	nP := AScan( aHeader1, {|p| p[2]=='K1_OPERAD' } )
	If nP > 0
		aHeader1[ nP, 1 ] := 'Operador'
		aHeader1[ nP, 6 ] := "Vazio().Or.ExistCpo('SU7',,1)"
	Endif
	
	nP := AScan( aHeader1, {|p| p[2]=='PAB_DTATUA' } )
	If nP > 0
		aHeader1[ nP, 1 ] := 'Data Agenda'
	Endif

	nP := AScan( aHeader1, {|p| p[2]=='B1_COD' } )
	If nP > 0
		aHeader1[ nP, 1 ] := 'Cód. Produto'
	Endif
	
	//-----------------------------------------------------
	// Se for selecionado Ambas, deverá haver dois vetores.
	//-----------------------------------------------------
	If n190Result == 3
		aHeader2 := AClone( aHeader1 )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A190Cols   | Autor | Robson Gonçalves     | Data | 05.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para montar a query e os arrays aHeader e aCOLS.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190Cols( cTRB, aCPO, aCPO_COL, aHeader1, aCOLS1, aCOLS2, aAnos )
	Local nI := 0
	Local nJ := 0
	Local nK := 0
	Local nP := 0
	Local nAno := 0
	Local nPeso := 0
	Local nElem := 0
	Local nQtCpos := 0
	Local nAnoCorte := 0
	Local nPesoCorte := 0
	Local nPosCpoIni := 0
	
	Local cCpoCorte := ''

	//---------------------------------------------
	// Determinar o ano, o campo e o peso de corte.
	//---------------------------------------------
	nAnoCorte  := n190AnoAte - 2
	cCpoCorte  := 'ANO_' + StrZero( nAnoCorte, 4, 0 )
	nP := AScan( aAnos, {|p| p[3] == nAnoCorte } )
	nPesoCorte := aAnos[ nP, 4 ]
	nPosCpoIni := (cTRB)->( FieldPos( 'ANO_' + StrZero( aAnos[ 1, 3 ], 4, 0 ) ) )
	nQtCpos := ( Len( aAnos ) + nPosCpoIni ) - 1
	
	ProcRegua(0)
	While ! (cTRB)->( EOF() )
		IncProc()
		
		//---------------------------
		// Calcular o peso do campos.
		//---------------------------
		For nI := nPosCpoIni To nQtCpos
			If (cTRB)->( FieldGet( nI ) ) == 'X'
				nAno := Val( Right( (cTRB)->( FieldName( nI ) ), 4 ) )
				nP := AScan( aAnos, {|p| p[3] == nAno } )
				nPeso := aAnos[ nP, 4 ]
		   Endif
		Next nI
		
		//-----------------------------------------------------------------------------------
		// Se o peso calculado for menor que o peso determinado como corte, não é recorrente, então montar 
		//-----------------------------------------------------------------------------------
		If (nPeso < nPesoCorte .And. (n190Result == 1 .Or. n190Result == 3)) .Or. (nPeso >= nPesoCorte .And. n190Result == 2)
		   nJ++
		   AAdd( aCOLS1, Array( Len( aHeader1 ) + 1 ) )
		   nElem := Len( aCOLS1 )		   
			For nI := 1 To Len( aHeader1 )
				If aHeader1[ nI, 2 ] == 'C7_ITEM'
					aCOLS1[ nElem, nI ] := StrZero( nJ, 4, 0 )
				Else
					nP := AScan( aCPO_COL, {|p| p[2] == aHeader1[ nI, 2 ] } )
					If nP > 0
						aCOLS1[ nElem, nI ] := (cTRB)->( FieldGet( FieldPos( aCPO_COL[ nP, 1 ] ) ) )
					Else
						If aHeader1[ nI, 2 ] $ 'K1_OPERAD|PAB_DTATUA'
							If aHeader1[ nI, 2 ] == 'K1_OPERAD'
								aCOLS1[ nElem, nI ] := Space( Len( SK1->K1_OPERAD ) )
							Elseif aHeader1[ nI, 2 ] == 'PAB_DTATUA'
								aCOLS1[ nElem, nI ] := Ctod( Space( 8 ) )
							Endif
						Else
							aCOLS1[ nElem, nI ] := (cTRB)->( FieldGet( FieldPos( aHeader1[ nI, 2 ] ) ) )
						Endif
					Endif
				Endif
			Next nI                                     
			aCOLS1[ nElem, Len( aHeader1 ) + 1 ] := .F.
		Endif
		
		//-----------------------------------------------------------------------------------------------------------------
		// Se o peso calculado for maior ou igual ao peso determinado como corte é recorrente e é para apresentar os dados.
		//-----------------------------------------------------------------------------------------------------------------
		If (nPeso >= nPesoCorte .And. n190Result == 3)
		   nK++
		   AAdd( aCOLS2, Array( Len( aHeader2 ) + 1 ) )
		   nElem := Len( aCOLS2 )
		   
			For nI := 1 To Len( aHeader2 )
				If aHeader2[ nI, 2 ] == 'C7_ITEM'
					aCOLS2[ nElem, nI ] := StrZero( nK, 4, 0 )
				Else
					nP := AScan( aCPO_COL, {|p| p[2] == aHeader2[ nI, 2 ] } )
					If nP > 0
						aCOLS2[ nElem, nI ] := (cTRB)->( FieldGet( FieldPos( aCPO_COL[ nP, 1 ] ) ) )
					Else
						If aHeader2[ nI, 2 ] $ 'K1_OPERAD|PAB_DTATUA'
							If aHeader2[ nI, 2 ] == 'K1_OPERAD'
								aCOLS2[ nElem, nI ] := Space( Len( SK1->K1_OPERAD ) )
							Elseif aHeader2[ nI, 2 ] == 'PAB_DTATUA'
								aCOLS2[ nElem, nI ] := Ctod( Space( 8 ) )
							Endif
						Else
							aCOLS2[ nElem, nI ] := (cTRB)->( FieldGet( FieldPos( aHeader2[ nI, 2 ] ) ) )
						Endif
					Endif
				Endif
			Next nI                                     
			aCOLS2[ nElem, Len( aHeader2 ) + 1 ] := .F.
		Endif
		(cTRB)->( dbSkip() )
	End	
Return

//-----------------------------------------------------------------------
// Rotina | A190Show   | Autor | Robson Gonçalves     | Data | 03.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar os dados em tela.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190Show()
	Local cFldTitle1 := ''
	Local cFldTitle2 := ''
	
	Local aFolder := {}
	Local aSize := {}
	Local aAlter := {}
	
	Local nOpc := 0
	Local nLargura := 0
	Local nAltura := 0	
	
	Local oDlg 
	Local oPnlInfDlg
	Local oPnlDlg
	Local oFld
	Local oFld1
	Local oFld2
	Local oPnlSupFo1
	Local oPnlSupFo2
	Local oPnlFld1
	Local oPnlFld2
	Local oGride1
	Local oGride2
	Local oBtnExc1
	Local oBtnExc2
	Local oBtPesq1
	Local oBtPesq2
	Local oBtnGera
	Local oBtnSair
	Local oBtInOp1
	Local oBtInOp2
	Local oBtInDt1
	Local oBtInDt2
	
	Local bSair := {|| .T. }
   Local bGerar := {|| .T. }
   
	If n190Result == 3
		aFolder := { 'Não recorrentes ', 'Recorrentes' }
	Else
		aFolder := { c190Result }
	Endif
   
	aSize := {0,0,0,0,(GetScreenRes()[1]-7),(GetScreenRes()[2]-85),120}
	nLargura := aSize[5]
	nAltura  := aSize[6]
		
	aAlter := {'K1_OPERAD','PAB_DTATUA'}
	
	bSair := {|| Iif(MsgYesNo('Deseja realmente sair da rotina?',cCadastro),oDlg:End(),NIL)}

	bGerar := {|| Iif(A190VlOpDt(oGride1,oGride2),;
	(Iif(MsgYesNo('A rotina está apta a gerar as Agendas Certisign, confirma a operação?',cCadastro),(nOpc:=1,oDlg:End()),NIL)),NIL) }
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 TO nAltura-5,nLargura COLOR CLR_BLACK,CLR_WHITE PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lMaximized := .T.
		oDlg:lEscClose  := .F.
		
		// Painel inferiorr para os botões na MsDialog.
		oPnlInfDlg := TPanel():New(0,0,,oDlg,,,,,RGB(214,214,214),0,16,.F.,.F.)
		oPnlInfDlg:Align := CONTROL_ALIGN_BOTTOM
		
		oBtnGera := TButton():New( 2, 02, 'Gerar Agenda'  ,oPnlInfDlg,bGerar ,60,11,,,.F.,.T.,.F.,,.F.,,,.F.)
		oBtnSair := TButton():New( 2, 66, 'Sair'          ,oPnlInfDlg,bSair  ,60,11,,,.F.,.T.,.F.,,.F.,,,.F.)

		// Painel allclient na MsDialog.
		oPnlDlg := TPanel():New(0,0,,oDlg,,,,,,0,12,.F.,.F.)
		oPnlDlg:Align := CONTROL_ALIGN_ALLCLIENT

		// Pastas no painel da MsDialog.
		oFld := TFolder():New(0,0,aFolder,,oPnlDlg,,,,.T.,,260,184 )
		oFld:Align := CONTROL_ALIGN_ALLCLIENT

		oFld1 := oFld:aDialogs[1]
		cFldTitle1 := oFld:aDialogs[1]:cCaption
		
		// Painel superior na folder 1.
		oPnlSupFo1 := TPanel():New(0,0,,oFld1,,,,,RGB(214,214,214),0,16,.F.,.F.)
		oPnlSupFo1:Align := CONTROL_ALIGN_TOP
      
		oBtPesq1 := TButton():New( 2,002,'Pesquisar'             ,oPnlSupFo1,{|| GdSeek(oGride1,,/*aHeader1*/,/*aCOLS1*/,.F.)  },70,11,,,.F.,.T.,.F.,,.F.,,,.F.)
		oBtInOp1 := TButton():New( 2,076,'Inserir Operador'      ,oPnlSupFo1,{|| A100Operad( @oGride1 )                        },70,11,,,.F.,.T.,.F.,,.F.,,,.F.)
		oBtInDt1 := TButton():New( 2,150,'Inserir Data p/ Agenda',oPnlSupFo1,{|| A100DtAgen( @oGride1 )                        },70,11,,,.F.,.T.,.F.,,.F.,,,.F.)
      oBtnExc1 := TButton():New( 2,224,'Exportar Excel'        ,oPnlSupFo1,{|| A190Excel(cFldTitle1,oGride1)                 },70,11,,,.F.,.T.,.F.,,.F.,,,.F.)
		
		// Painel allclient na folder 1.
		oPnlFld1 := TPanel():New(0,0,,oFld1,,,,,,0,12,.F.,.F.)
		oPnlFld1:Align := CONTROL_ALIGN_ALLCLIENT

		oGride1 := MsNewGetDados():New(1,1,1000,1000,GD_UPDATE,,,,aAlter,,Len(aCOLS1),,,,oPnlFld1,aHeader1,aCOLS1)
		oGride1:oBrowse:bHeaderClick := {|| NIL }
		oGride1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
		If Len( oFld:aDialogs ) > 1
			oFld2 := oFld:aDialogs[2]
			cFldTitle2 := oFld:aDialogs[2]:cCaption
			
			// Painel superior na folder 1.
			oPnlSupFo2 := TPanel():New(0,0,,oFld2,,,,,RGB(214,214,214),0,16,.F.,.F.)
			oPnlSupFo2:Align := CONTROL_ALIGN_TOP
	      
			oBtPesq2 := TButton():New( 2,002,'Pesquisar'             ,oPnlSupFo2,{|| GdSeek(oGride2,,/*aHeader2*/,/*aCOLS2*/,.F.)  },70,11,,,.F.,.T.,.F.,,.F.,,,.F.)
			oBtInOp2 := TButton():New( 2,076,'Inserir Operador'      ,oPnlSupFo2,{|| A100Operad( @oGride2 )                        },70,11,,,.F.,.T.,.F.,,.F.,,,.F.)
			oBtInDt2 := TButton():New( 2,150,'Inserir Data p/ Agenda',oPnlSupFo2,{|| A100DtAgen( @oGride2 )                        },70,11,,,.F.,.T.,.F.,,.F.,,,.F.)
	      oBtnExc2 := TButton():New( 2,224,'Exportar Excel'        ,oPnlSupFo2,{|| A190Excel(cFldTitle2,oGride2)                 },70,11,,,.F.,.T.,.F.,,.F.,,,.F.)
			
			// Painel allclient na folder 2.
			oPnlFld2 := TPanel():New(0,0,,oFld2,,,,,,0,12,.F.,.F.)
			oPnlFld2:Align := CONTROL_ALIGN_ALLCLIENT
	
			oGride2 := MsNewGetDados():New(1,1,1000,1000,GD_UPDATE,,,,aAlter,,Len(aCOLS2),,,,oPnlFld2,aHeader2,aCOLS2)
			oGride2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
			oGride2:oBrowse:bHeaderClick := {|| NIL }
		Endif
	ACTIVATE MSDIALOG oDlg CENTER ON INIT (oGride1:ForceRefresh(),oGride1:oBrowse:SetFocus())
	
	If nOpc == 1
		Begin Transaction
			Processa( {|| A190Create(oGride1,oGride2)}, cCadastro,'Aguarde, gerando Agenda Certisign...', .F. )
		End Transaction
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A190Create | Autor | Robson Gonçalves     | Data | 05.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para gerar as Agendas Certisign.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190Create( oGride1, oGride2 )
	Local nI := 0
	Local nCpoAno := 0
	
	Local nK1_OPERAD := 0
	Local nPAB_DTATUA
	
	Local nA1_COD := 0
	Local nA1_LOJA := 0
	Local nB1_COD := 0
	Local nB1_DESC := 0
	
	Local cA1_COD := ''
	Local cA1_LOJA := ''
	Local cK1_OPERAD := ''
	Local cU4_DESC := ''
	Local cU4_LISTA := ''
	Local cU6_CODIGO := ''
	Local cB1_COD := ''
	Local cB1_DESC := ''
	Local cAno := ''
	
	Local dPAB_DTATUA := Ctod(Space(8))
	
	ProcRegua(0)
	
	nB1_COD  := AScan( oGride1:aHeader, {|p| p[2]=='B1_COD' })
	nB1_DESC := AScan( oGride1:aHeader, {|p| p[2]=='B1_DESC' })

	nK1_OPERAD  := AScan( oGride1:aHeader, {|p| p[2]=='K1_OPERAD' })
	nPAB_DTATUA := AScan( oGride1:aHeader, {|p| p[2]=='PAB_DTATUA' })
	
	nA1_COD  := AScan( oGride1:aHeader, {|p| p[2]=='A1_COD' })
	nA1_LOJA := AScan( oGride1:aHeader, {|p| p[2]=='A1_LOJA' })
	
	nCpoAno := AScan( oGride1:aHeader, {|p| Left( p[2], 4 ) == 'ANO_' } )
	
	For nI := 1 To Len( oGride1:aCOLS )
		IncProc()
		
		cK1_OPERAD := oGride1:aCOLS[ nI, nK1_OPERAD ]
		dPAB_DTATUA := oGride1:aCOLS[ nI, nPAB_DTATUA ]
				
		If !Empty( cK1_OPERAD ) .And. !Empty( dPAB_DTATUA )
		
			cB1_COD := oGride1:aCOLS[ nI, nB1_COD ]
			cB1_DESC := oGride1:aCOLS[ nI, nB1_DESC ]

			cA1_COD  := oGride1:aCOLS[ nI, nA1_COD ]
			cA1_LOJA := oGride1:aCOLS[ nI, nA1_LOJA ]
	
			SU7->( dbSetOrder( 1 ) )
			SU7->( MsSeek( xFilial( 'SU7' ) + cK1_OPERAD ) )

			SA1->( dbSetOrder( 1 ) )
			SA1->( MsSeek( xFilial( 'SA1' ) + cA1_COD + cA1_LOJA ) )
			
			// Procurar um contato deste cliente na tabela de relacionamento.
			AC8->( dbSetOrder( 2 ) )
			If ! AC8->( dbSeek( xFilial( 'AC8' ) + 'SA1' + xFilial( 'SA1' ) + SA1->( A1_COD + A1_LOJA ) ) )
				// Gravar o contato que será o próprio cliente.
				A190SU5()
				// Gerar o relacionamento entre o cliente e o contato.
				A190AC8()
			Else
				SU5->( dbSetOrder( 1 ) )
				SU5->( MsSeek( xFilial( 'SU5' ) + AC8->AC8_CODCON ) )
			Endif
			
			For nJ := nCpoAno To Len( oGride1:aCOLS[ nI ] ) -1
				If oGride1:aCOLS[ nI, nJ ] == 'X'
					cAno := Right( oGride1:aHeader[ nJ, 1 ], 4 )
				Endif 
			Next nJ
			
			cU4_DESC := 'CLIENTE DESCONTINUADO - ULT.COMPRA '+ cAno +' PROD: '+RTrim( cB1_COD ) +' - '+RTrim( cB1_DESC )
			
			A190Grava( cU4_DESC, dPAB_DTATUA )
		Endif
	Next nI
	
	If oGride2 <> NIL
		For nI := 1 To Len( oGride2:aCOLS )
			IncProc()
			
			cK1_OPERAD := oGride2:aCOLS[ nI, nK1_OPERAD ]
			dPAB_DTATUA := oGride2:aCOLS[ nI, nPAB_DTATUA ]
			
			If !Empty( cK1_OPERAD ) .And. !Empty( dPAB_DTATUA )
			
				cB1_COD := oGride1:aCOLS[ nI, nB1_COD ]
				cB1_DESC := oGride1:aCOLS[ nI, nB1_DESC ]

				cA1_COD  := oGride2:aCOLS[ nI, nA1_COD ]
				cA1_LOJA := oGride2:aCOLS[ nI, nA1_LOJA ]
		
				SU7->( dbSetOrder( 1 ) )
				SU7->( MsSeek( xFilial( 'SU7' ) + cK1_OPERAD ) )
	
				SA1->( dbSetOrder( 1 ) )
				SA1->( MsSeek( xFilial( 'SA1' ) + cA1_COD + cA1_LOJA ) )
				
				// Procurar um contato deste cliente na tabela de relacionamento.
				AC8->( dbSetOrder( 2 ) )
				If ! AC8->( dbSeek( xFilial( 'AC8' ) + 'SA1' + xFilial( 'SA1' ) + SA1->( A1_COD + A1_LOJA ) ) )
					// Gravar o contato que será o próprio cliente.
					A190SU5()
					// Gerar o relacionamento entre o cliente e o contato.
					A190AC8()
				Else
					SU5->( dbSetOrder( 1 ) )
					SU5->( MsSeek( xFilial( 'SU5' ) + AC8->AC8_CODCON ) )
				Endif	
				
				For nJ := nCpoAno To Len( oGride1:aCOLS[ nI ] ) -1
					If oGride1:aCOLS[ nI, nJ ] == 'X'
						cAno := Right( oGride1:aHeader[ nJ, 1 ], 4 )
					Endif 
				Next nJ
				
				cU4_DESC := 'CLIENTE DESCONTINUADO - ULT.COMPRA '+ cAno +' PROD: '+RTrim( cB1_COD ) +' - '+RTrim( cB1_DESC )

				A190Grava( cU4_DESC, dPAB_DTATUA )
			Endif
		Next nI	
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A190Grava | Autor | Robson Gonçalves     | Data | 08.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para gravar as Agendas Certisign.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190Grava( cU4_DESC, dPAB_DTATUA )
	Local cU4_LISTA := ''
	Local cU6_CODIGO := ''
	
	cU4_LISTA  := A190GetNum( 'SU4', 'U4_LISTA' )
	
	cU6_CODIGO := A190GetNum( 'SU6', 'U6_CODIGO' )

	SU4->( dbSetOrder( 1 ) )
	SU4->( RecLock( 'SU4', .T. ) )
	SU4->U4_FILIAL  := xFilial( 'SU4' )
	SU4->U4_TIPO    := '1' //1=Marketing;2=Cobrança;3=Vendas;4=Teleatendimento.
	SU4->U4_STATUS  := '1' //1=Ativa;2=Encerrada;3=Em Andamento
	SU4->U4_LISTA   := cU4_LISTA
	SU4->U4_DESC    := cU4_DESC
	SU4->U4_DATA    := dPAB_DTATUA //Data da inclusão da agenda do consultor.
	SU4->U4_DTEXPIR := dPAB_DTATUA
	SU4->U4_HORA1   := '06:00:00'
	SU4->U4_FORMA   := '6' //1=Voz;2=Fax;3=CrossPosting;4=Mala Direta;5=Pendencia;6=WebSite.
	SU4->U4_TELE    := '1' //1=Telemarkeing;2=Televendas;3=Telecobrança;4=Todos;5=Teleatendimento.
	SU4->U4_OPERAD  := SU7->U7_COD
	SU4->U4_TIPOTEL := '4' //1=Residencial;2=Celular;3=Fax;4=Comercial 1;5=Comercial 2.
	SU4->U4_NIVEL   := '1' //1=Sim;2=Nao.
	If SU4->( FieldPos( 'U4_XDTVENC' ) ) > 0
		SU4->U4_XDTVENC := dPAB_DTATUA
	Endif
	If SU4->( FieldPos( 'U4_XGRUPO' ) ) > 0
		SU4->U4_XGRUPO  := SU7->U7_POSTO
	Endif
	If ! Empty( c190Campan )
		SU4->U4_CODCAMP  := c190Campan
	Endif
	SU4->( MsUnLock() )
	
	SU6->( dbSetOrder( 1 ) )
	SU6->( RecLock( 'SU6', .T. ) )
	SU6->U6_FILIAL  := xFilial( 'SU6' )
	SU6->U6_LISTA   := cU4_LISTA
	SU6->U6_CODIGO  := cU6_CODIGO
	SU6->U6_CONTATO := SU5->U5_CODCONT
	SU6->U6_ENTIDA  := 'SA1'
	SU6->U6_CODENT  := SA1->( A1_COD, A1_LOJA )
	SU6->U6_ORIGEM  := '1' //1=Lista;2=Manual;3=Atendimento.
	SU6->U6_DATA    := dPAB_DTATUA //Data da inclusão da agenda do consultor.
	SU6->U6_HRINI   := '06:00'
	SU6->U6_HRFIM   := '23:59'
	SU6->U6_STATUS  := '1' //1=Nao Enviado;2=Em uso;3=Enviado.
	SU6->U6_DTBASE  := MsDate()
	SU6->( MsUnLock() )
Return

//-----------------------------------------------------------------------
// Rotina | A190SU5    | Autor | Robson Gonçalves     | Data | 08.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para gravar o contato.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190SU5()
	Local cU5_CODCONT := ''
	
	cU5_CODCONT := A190GetNum( 'SU5', 'U5_CODCONT' )
	
	SU5->( RecLock( 'SU5', .T. ) )
	SU5->U5_FILIAL  := xFilial( 'SU5' )
	SU5->U5_CODCONT := cU5_CODCONT
	SU5->U5_CONTAT  := Iif( ! Empty( SA1->A1_CONTATO ), SA1->A1_CONTATO, SA1->A1_NOME )
	SU5->U5_DDD     := SA1->A1_DDD
	SU5->U5_FCOM1   := SA1->A1_TEL
	SU5->U5_EMAIL   := SA1->A1_EMAIL
	SU5->( MsUnLock() )
Return

//-----------------------------------------------------------------------
// Rotina | A190AC8    | Autor | Robson Gonçalves     | Data | 08.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para gravar o relacionamento do contato com o cliente.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190AC8()
	AC8->( RecLock( 'AC8', .T. ) )
	AC8->AC8_FILIAL := xFilial('AC8')
	AC8->AC8_FILENT := xFilial('SA1')
	AC8->AC8_ENTIDA := 'SA1'
	AC8->AC8_CODENT := SA1->( A1_COD + A1_LOJA )
	AC8->AC8_CODCON := SU5->U5_CODCONT
	AC8->( MsUnLock() )
Return

//-----------------------------------------------------------------------
// Rotina | A190VlOpDt | Autor | Robson Gonçalves     | Data | 05.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que valida a preenchimento dos campos nas duas pastas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190VlOpDt( oGride1, oGride2 )
	Local nI := 0
	
	Local nC7_ITEM := 0
	Local nK1_OPERAD := 0
	Local nPAB_DTATUA := 0
	
	Local cC7_ITEM := ''
	
	Local lRet := .T.
	
	nC7_ITEM    := AScan( aHeader1, {|p| p[2] == 'C7_ITEM' } )
	nK1_OPERAD  := AScan( aHeader1, {|p| p[2] == 'K1_OPERAD' } )
	nPAB_DTATUA := AScan( aHeader1, {|p| p[2] == 'PAB_DTATUA' } )
	
	//-------------------------------
	// Avaliar se há algo preenchido.
	//-------------------------------
	If AScan( oGride1:aCOLS, {|p| !Empty( p[ nK1_OPERAD ] ) } ) == 0
		If n190Result == 3
			If AScan( oGride2:aCOLS, {|p| !Empty( p[ nK1_OPERAD ] ) } ) == 0
				MsgAlert('É preciso informar código do operador e data da agenda.',cCadastro)
				lRet := .F.
			Endif
		Else
			MsgAlert('É preciso informar código do operador e data da agenda.',cCadastro)
			lRet := .F.
		Endif
	Endif

	//-----------------------------------------------------------------------------------
	// Se há algo a ser preenchido, então verificar se o código e data estão preenchidos.
	//-----------------------------------------------------------------------------------
	If lRet
		For nI := 1 To Len( oGride1:aCOLS )
			lK1_OPERAD  := Empty( oGride1:aCOLS[ nI, nK1_OPERAD ] )
			lPAB_DTATUA := Empty( oGride1:aCOLS[ nI, nPAB_DTATUA ] )
			cC7_ITEM    := oGride1:aCOLS[ nI, nC7_ITEM ]
			If lK1_OPERAD <> lPAB_DTATUA
				lRet := .F.
				MsgAlert('Precisa ser informado Operador e Data da Agenda, verifique o item ' + cC7_ITEM+'.',cCadastro)
				Exit
			Endif
		Next nI
		
		If n190Result == 3 .And. lRet
			For nI := 1 To Len( oGride2:aCOLS )
				lK1_OPERAD  := Empty( oGride2:aCOLS[ nI, nK1_OPERAD ] )
				lPAB_DTATUA := Empty( oGride2:aCOLS[ nI, nPAB_DTATUA ] )
				cC7_ITEM    := oGride2:aCOLS[ nI, nC7_ITEM ]
				If lK1_OPERAD <> lPAB_DTATUA
					lRet := .F.
					MsgAlert('Precisa ser informado Operador e Data da Agenda, verifique o item ' + cC7_ITEM+'. Na pasta Recorrentes.',cCadastro)
					Exit
				Endif
			Next nI
		Endif	
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A100Operad | Autor | Robson Gonçalves     | Data | 04.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que insere o operador dentro de um intervalo.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A100Operad( oGride )
	Local aPar := {}
	Local aRet := {}
	
	Local nP_K1_OPERAD := 0
	Local nP_C7_ITEM := 0
	
	Private cSize := 0
	
	cSize := StrZero( Len( oGride:aCOLS ), 4, 0 )
	
	SU7->(dbSetOrder( 1 ) )
	
	AAdd(aPar,{1,'Do item'      ,Space(Len(SC7->C7_ITEM)),"","(mv_par01<=cSize)","","",0,.T.})
	AAdd(aPar,{1,'Até o item'   ,Space(Len(SC7->C7_ITEM)),"","(mv_par02>=mv_par01).And.(mv_par02<=cSize)","","",0,.T.})
	AAdd(aPar,{1,'Qual operador',Space(Len(SK1->K1_OPERAD)),"","ExistCpo('SU7',mv_par03)","SU7","",40,.T.})
	
	If ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.F.,.F.)	
		nP_C7_ITEM := AScan( oGride:aHeader,{|p| p[2]=='C7_ITEM' })
		nP_K1_OPERAD  := AScan( oGride:aHeader,{|p| p[2]=='K1_OPERAD' })
		For nI := 1 To Len( oGride:aCOLS )
			If oGride:aCOLS[ nI, nP_C7_ITEM ] >= aRet[ 1 ] .And. oGride:aCOLS[ nI, nP_C7_ITEM ] <= aRet[ 2 ]
				oGride:aCOLS[ nI, nP_K1_OPERAD ] := aRet[ 3 ]
			Endif
		Next nI
		oGride:Refresh()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A100DtAgen | Autor | Robson Gonçalves     | Data | 04.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que insere a data da agenda dentro de um intervalo.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A100DtAgen( oGride )
	Local aPar := {}
	Local aRet := {}
	
	Local nP_C7_ITEM := 0
	Local nP_PAB_DTATUA := 0
	
	Private cSize := 0
	
	cSize := StrZero( Len( oGride:aCOLS ), 4, 0 )
	
	SU7->(dbSetOrder( 1 ) )
	
	AAdd(aPar,{1,'Do item'            ,Space(Len(SC7->C7_ITEM)),"","(mv_par01<=cSize)","","",0,.T.})
	AAdd(aPar,{1,'Até o item'         ,Space(Len(SC7->C7_ITEM)),"","(mv_par02>=mv_par01).And.(mv_par02<=cSize)","","",0,.T.})
	AAdd(aPar,{1,'Qual data p/ agenda',Ctod(Space(8)),"","mv_par03>=dDataBase","","",40,.T.})
	
	If ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.F.,.F.)	
		nP_C7_ITEM := AScan( oGride:aHeader,{|p| p[2]=='C7_ITEM' })
		nP_PAB_DTATUA := AScan( oGride:aHeader,{|p| p[2]=='PAB_DTATUA' })
		For nI := 1 To Len( oGride:aCOLS )
			If oGride:aCOLS[ nI, nP_C7_ITEM ] >= aRet[ 1 ] .And. oGride:aCOLS[ nI, nP_C7_ITEM ] <= aRet[ 2 ]
				oGride:aCOLS[ nI, nP_PAB_DTATUA ] := aRet[ 3 ]
			Endif
		Next nI
		oGride:Refresh()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A190Excel  | Autor | Robson Gonçalves     | Data | 04.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que prepara os dados e exporta para o Excel.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190Excel( cTitulo, oGride )
	Local nI := 0
	Local nJ := 0
	Local cSpace := ''
	Local cCpos := ''
	Local aDADOS := {}
	
	aDADOS := AClone( oGride:aCOLS )
	
	cSpace := Chr( 160 )
	cCpos := 'C7_ITEM|B1_XSEG|A1_COD|A1_LOJA|B1_COD|K1_OPERAD'
	
	For nI := 1 To Len( oGride:aCOLS )
		For nJ := 1 To Len( oGride:aHeader )
			If oGride:aHeader[ nJ, 2 ] $ cCpos
				aDADOS[ nI, nJ ] := cSpace + oGride:aCOLS[ nI, nJ ]
			Endif
		Next nJ
	Next nI 

	MsgRun('Exportando dados...',cCadastro,{|| DlgToExcel({{'GETDADOS',cTitulo,oGride:aHeader,aDADOS}}) } )
Return

//-----------------------------------------------------------------------
// Rotina | FA190Seg   | Autor | Robson Gonçalves     | Data | 03.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para o usuário selecionar os segmentos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function FA190Seg()
	Local oDlg
	Local oLbx
	Local oWnd 
	Local oMrk 
	Local oNoMrk
	
	Local nI := 0
	Local nOpc := 0
	
	Local lMark := .F.
	
	Local cTitulo := 'Segmentos'
	Local cNomeCpo := ''
	Local cConteudo := ''
	
	Local aDados := {}
	Local aButton := {}
	
	cNomeCpo := ReadVar()
	cConteudo := RTrim( &( ReadVar() ) )
	
	SZ1->(dbSetOrder(1))
	SZ1->(dbSeek(xFilial('SZ1')))
	While ! SZ1->(EOF()) .And. SZ1->Z1_FILIAL==xFilial('SZ1')
		lMark := SZ1->Z1_CODSEG $ cConteudo
		SZ1->(AAdd( aDados, { lMark, Z1_CODSEG, Z1_DESCSEG } ) )
		SZ1->(dbSkip())
	End
	
	If Len( aDados ) > 0
		lMark := .T.
		oWnd := GetWndDefault()
		oMrk := LoadBitmap( GetResources(), 'LBOK' )
		oNoMrk := LoadBitmap( GetResources(), 'LBNO' )
		
		AAdd( aButton,{"PESQUISA"  ,{|| A190Pesq(@oLbx,aDados) },"Pesquisar","Pesquisa"} )
		
		DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 237,600 PIXEL
		   oLbx := TwBrowse():New(0,0,0,0,,{'   X','Código','Descrição'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		   oLbx:SetArray( aDados )
			oLbx:bLine := {|| {Iif(aDados[oLbx:nAt,1],oMrk,oNoMrk),aDados[oLbx:nAt,2],aDados[oLbx:nAt,3]}}
			oLbx:bLDblClick := {||  aDados[ oLbx:nAt, 1 ] := ! aDados[ oLbx:nAt, 1 ] }
			oLbx:bHeaderClick := {|| AEval( aDados, {|p| p[1] := lMark } ), lMark := !lMark, oLbx:Refresh() }
		ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, {|| nOpc := 1, oDlg:End() }, {|| oDlg:End() },,aButton)
		If nOpc == 1
			cConteudo := ''
			For nI := 1 To Len( aDados )
				If aDados[ nI, 1 ]
					cConteudo += aDados[ nI, 2 ] + ';'
				Endif
			Next nI
			cConteudo := Substr( cConteudo, 1, Len( cConteudo ) -1 )
			&( cNomeCpo ) := cConteudo
			If oWnd <> NIL
				GetdRefresh()
			Endif
		Endif
	Else
		MsgAlert( 'Dados não localizados', cTitulo )
	Endif
Return(cConteudo)

//-----------------------------------------------------------------------
// Rotina | A190Pesq   | Autor | Robson Gonçalves     | Data | 04.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para pesquisar os segmentos atribuídos ao array.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190Pesq(oLbx,aDados)
	Local oDlgPesq
	Local oOrdem
	Local oChave 
	Local oBtOk
	Local oBtCan
	
	Local cOrdem := ''
	Local cTitulo := 'Pesquisa'
	Local cChave := Space(50)
	
	Local aOrdens := {}

	Local nP := 0
	Local nOrdem := 1
	Local nOpcao := 0

	aOrdens := {'Código','Descrição'}
	
	DEFINE MSDIALOG oDlgPesq TITLE cTitulo FROM 00,00 TO 78,500 PIXEL
		@ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
		@ 021, 005 MSGET oChave VAR cChave SIZE 210,08 OF oDlgPesq PIXEL
	
		DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
		DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	ACTIVATE MSDIALOG oDlgPesq CENTER
	
	If nOpcao == 1
		cChave := Upper( AllTrim( cChave ) )
		nP := AScan( aDados,{|p| cChave $ Upper( p[ nOrdem+1 ] ) } )
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgAlert( 'Busca não localizada', cTitulo )
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A190DtVl   | Autor | Robson Gonçalves     | Data | 04.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar os anos informados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A190DtVl()
	Local cSQL := ''
	
	Local nAno := 0
	Local nCount := 0
	
	Local dIni := Ctod( Space( 8 ) )
	Local dFim := Ctod( Space( 8 ) )
	
	nAno := &( ReadVar() )
	
	If nAno >= 1000 .And. nAno <= 9999
		dIni := Ctod('01/01/'+LTrim( Str( nAno, 4, 0 ) ) )
		dFim := Ctod('31/12/'+LTrim( Str( nAno, 4, 0 ) ) )
	
		cSQL := "SELECT COUNT(*) AS D2_QTOSREG "
		cSQL += "FROM   "+RetSqlName("SD2")+" SD2 "
		cSQL += "WHERE  D2_FILIAL = "+ValToSql( xFilial( "SD2" ) )+" "
		cSQL += "       AND D2_EMISSAO BETWEEN "+ValToSql( dIni )+" AND "+ValToSql( dFim )+" "
		cSQL += "       AND SD2.D_E_L_E_T_ = ' ' "
	
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cSQL),"SQLCOUNT",.F.,.T.)
		nCount := SQLCOUNT->(D2_QTOSREG)
		SQLCOUNT->(dbCloseArea())
		
		If nCount == 0
			MsgAlert('O ano informado não existe na base de dados, por favor, ajuste.',cCadastro)
		Endif
	Else
		MsgAlert('Informe o ano com quatro dígitos, exemplo: 2000.',cCadastro)
	Endif
Return(nCount>0)

//-----------------------------------------------------------------------
// Rotina | A190CanUse | Autor | Robson Gonçalves     | Data | 02.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que verifica se a estrutura de dicionário existe.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190CanUse()
	Local nI := 0
	Local nJ := 0
	Local aCpoSXB := {}
	Local aSXB := {}
	Local cTamSXB := 0
	Local cXB_ALIAS := 'CFA190'
	
	//--------------------------
	// Existe a consulta padrão.
	//--------------------------
	SXB->( dbSetOrder( 1 ) )
	If ! SXB->( dbSeek( cXB_ALIAS ) )
		nTamSXB := Len( SXB->XB_ALIAS )
		aCpoSXB := { "XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM","XB_WCONTEM" }
		
		AAdd(aSXB,{cXB_ALIAS,"1","01","RE","Segmentos","Segmentos","Segmentos","SZ1",""})
		AAdd(aSXB,{cXB_ALIAS,"2","01","01","Segmentos","Segmentos","Segmentos","U_FA190Seg()",""})
		AAdd(aSXB,{cXB_ALIAS,"5","01","","","","","SZ1->Z1_CODSEG",""})
		
		SXB->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aSXB )
			If ! SXB->( dbSeek( PadR( aSXB[ nI, 1 ], nTamSXB ) + aSXB[ nI,2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) )
				SXB->( RecLock( 'SXB', .T. )) 
				For nJ := 1 To Len( aCpoSXB )
					SXB->( FieldPut( FieldPos( aCpoSXB[ nJ ] ), aSXB[ nI, nJ ] ) )
				Next nJ
				SXB->( MsUnLock() )
			Endif
		Next nI
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A190Script | Autor | Robson Gonçalves     | Data | 03.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar o script de instrução SQL na tela.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190Script( cSQL )
	Local cNomeArq := ''
	Local nHandle := 0
	Local lEmpty := .F.
	AutoGrLog('ativar para apagar')
	cNomeArq := NomeAutoLog()
	lEmpty := Empty( cNomeArq )
	If !lEmpty
		nHandle := FOpen( cNomeArq, 2 )
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
	AutoGrLog( cSQL )
	MostraErro()
	If !lEmpty
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A190GetNum | Autor | Robson Gonçalves     | Data | 16.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para obter o número disponível da lista de contato.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A190GetNum( cAlias, cCpo )
	Local cRet := ''
	Local lSeek := .T.
	Local cFilial := xFilial( cAlias )
	Local cFilter	:= (cAlias)->( dbFilter() )
		
	(cAlias)->( dbClearFilter() )
	(cAlias)->( dbSetOrder( 1 ) )
	
	While lSeek
		cRet := GetSXENum( cAlias, cCpo )
		lSeek := (cAlias)->( dbSeek( cFilial + cRet ) )
		If !lSeek
			ConfirmSX8()
		Endif
	End
	
	If !Empty( cFilter )
		(cAlias)->( dbSetFilter( { || &cFilter }, cFilter ) )
	Endif
Return( cRet )

//-----------------------------------------------------------------------
// Rotina | UPD190     | Autor | Robson Gonçalves     | Data | 08.07.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de update p/ criar as estruturas no dicionário dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD190()
	Local cModulo := "TMK"
	Local bPrepar := {|| U_U190Ini() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//-----------------------------------------------------------------------
// Rotina | U190Ini    | Autor | Robson Gonçalves     | Data | 08.07.2013
//-----------------------------------------------------------------------
// Descr. | Estrutura de dados para criar o dicionário de dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U190Ini()
	aSX3 := {}
	
	AAdd( aSX3    ,{	'SU4',NIL,'U4_DESC','C',120,0,;                      //Alias,NIL,Campo,Tipo,Tamanho,Decimais
							'Nome Lista','Nome Lista','Nome Lista',;             //Tit. Port.,Tit.Esp.,Tit.Ing.
							'Nome da Lista','Nome da Lista','Nome da Lista',;    //Desc. Port.,Desc.Esp.,Desc.Ing.
							'@x',;                                               //Picture
							'NaoVazio()',;                                       //Valid
							X3_NAOALTERA_USADO,;                                 //Usado
							'',;                                                 //Relacao
							'',1,X3_USADO_RESERV,'','',;                         //F3,Nivel,Reserv,Check,Trigger
							' ','A',' ','R',' ',;                                //Propri,Browse,Visual,Context,Obrigat
							'',;	                                               //VldUser
							'','','',;                                           //Box Port.,Box Esp.,Box Ing.
							'','','','','',;                                     //PictVar,When,Ini BRW,GRP SXG,Folder
							'N','',''})                                          //Pyme,CondSQL,ChkSQL
	
Return(.T.)