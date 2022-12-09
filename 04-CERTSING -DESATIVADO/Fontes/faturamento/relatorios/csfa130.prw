//-----------------------------------------------------------------------
// Rotina | CSFA130    | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Apura��o Metas de Vendas
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'
#Include 'Report.ch'

User Function CSFA130()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private l130Query := .F.
	Private cCadastro := 'Apura��o Metas de Vendas'
	Private cDescriRel := 'Apurar as Metas de Vendas X Realizado conforme plano de metas e vis�o selecionados.'

	SetKey( VK_F12 , {|| l130Query := MsgYesNo('Exportar a string da query principal?',cCadastro ) } )

	AAdd( aSay, cDescriRel )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	SetKey( VK_F12 , NIL )

	If nOpcao==1
		If ApOleClient('MSExcel')
			A130Param()
		Else
			Msgalert('O aplicativo Microsoft Excel n�o est� instalado neste equipamento, verifique.',cCadastro)
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A130Param  | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de par�metros para usu�rio informar.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130Param()
	Local aVisao := {}
	Local aPar := {}
	Local aRet := {}
	Local aOpcDev := {'Sim','N�o'}
	Local aOpcDiverg := {'Considera','N�o considera'}
	Local aOpcResult := {'Sint�tico','Anal�tico'}
	Local nI := 0
	
	Local cF3 := ''
	Local cStrDe := ''
	Local cStrAte := ''
	Local cDado := 0
	
	Local lReport := .F.

	Private aParam := {}
	Private n130Visao := 0
	Private n130Devol := 0
	Private n130Diver := 0
	Private n130Result := 0
	
	Private c130Visao := ''
	Private c130VisDe := ''
	Private c130VisAte := ''
	Private c130DocDe := ''
	Private c130DocAte := ''
	Private c130Canal := ''
	Private c130Sellers := ''
	
	Private d130FatDe := Ctod(Space(8))
	Private d130FatAte := Ctod(Space(8))
	Private d130MetDe := Ctod(Space(8))
	Private d130MetAte := Ctod(Space(8))

	lReport := (Aviso(cCadastro,'Os dados devem ser apresentados diretos em:',{'Relat�rio','Planilha'},1,'Sa�da dos dados')==1)
	
	AAdd( aVisao, 'Por vendedor' )
	AAdd( aVisao, 'Por regi�o' )
	AAdd( aVisao, 'Por categoria de produto' )
	AAdd( aVisao, 'Por grupo de produto' )
	AAdd( aVisao, 'Por produto' )
	
	AAdd( aPar, { 3, 'Selecione a vis�o a processar', 1, aVisao, 99, '', .T. } )
	If !ParamBox( aPar, 'Par�metros de Vis�o', @aRet,,,,,,,,.F.,.F.)
		Return
	Endif
	
	n130Visao := aRet[ 1 ]
	c130Visao := aVisao[ aRet[ 1 ] ]
	
	If __cUserID <> '000000'
		AAdd( aParam, 'PARAMETROS INFORMADOS PELO USUARIO: '+ __cUserID + ' ' + Upper( RTrim( cUserName ) ) + ' em ' + Dtoc( dDataBase ) + ' as ' + Time() )
	Else
		AAdd( aParam, 'PARAMETROS INFORMADOS' )
	Endif
	
	AAdd( aParam, aPar[ 1, 2 ] + ': ' + c130Visao )
	
	A130CriaXB()
	
	If n130Visao == 1
		cF3 := 'SA3'
		cStrDe  := Space( Len( SA3->A3_COD ) )
		cStrAte := Space( Len( SA3->A3_COD ) )
	Elseif n130Visao == 2
		cF3 := 'A2'
		cStrDe  := Space( 3 )
		cStrAte := Space( 3 )
	Elseif n130Visao == 3
		cF3 := 'ACU'
		cStrDe  := Space( Len( ACU->ACU_COD ) )
		cStrAte := Space( Len( ACU->ACU_COD ) )
	Elseif n130Visao == 4
		cF3 := 'SBM'
		cStrDe  := Space( Len( SBM->BM_GRUPO ) )
		cStrAte := Space( Len( SBM->BM_GRUPO ) )
	Elseif n130Visao == 5
		cF3 := 'SB1'
		cStrDe  := Space( Len( SB1->B1_COD ) )
		cStrAte := Space( Len( SB1->B1_COD ) )
	Endif
	
	aPar := {}
	aRet := {}
	
	// 1� Pergunta.
	AAdd( aPar, { 1, c130Visao+' de' , cStrDe ,'',''                    ,cF3     , '', 50, .F. } )
	// 2� Pergunta.
	AAdd( aPar, { 1, c130Visao+' at�', cStrAte,'','(mv_par02>=mv_par01)',cF3     , '', 50, .T. } )
	// 3� Pergunta.
	AAdd( aPar, { 1, 'Data faturamento de' ,Ctod(Space(8)),'',''                    ,''      , '', 50, .F. } )
	// 4� Pergunta.
	AAdd( aPar, { 1, 'Data faturamento at�',Ctod(Space(8)),'','(mv_par04>=mv_par03)',''      , '', 50, .T. } )
	// 5� Pergunta.
	AAdd( aPar, { 1, 'N� Docto. Meta de' ,Space(Len(SCT->CT_DOC)),'',''                    ,'SCT'      , '', 50, .F. } )
	// 6� Pergunta.
	AAdd( aPar, { 1, 'N� Docto. Meta at�',Space(Len(SCT->CT_DOC)),'','(mv_par06>=mv_par05)','SCT'      , '', 50, .T. } )
	// 7� Pergunta.
	AAdd( aPar, { 1, 'Data meta de' ,Ctod(Space(8)),'',''                    ,''      , '', 50, .F. } )
	// 8� Pergunta.
	AAdd( aPar, { 1, 'Data meta at�',Ctod(Space(8)),'','(mv_par08>=mv_par07)',''      , '', 50, .T. } )
	// 9� Pergunta.
	AAdd( aPar, { 1, 'Canal venda',Space(Len(SA3->A3_XCANAL)),'','','SZ2'      , '', 50, .T. } )
	// 10� Pergunta.
	AAdd( aPar, { 3, 'Considera devolu��o', 1, aOpcDev, 99, '', .T. } )
	
	If n130Visao==3
		AAdd( aPar, { 3, 'Produtos divergentes da meta', 1, aOpcDiverg, 99, '', .T. } )
	Endif
	
	If n130Visao==1
		AAdd( aPar, { 3, 'Resultado', 1, aOpcResult, 99, '', .T. } )
	Endif
	
	If !ParamBox( aPar, 'Par�metros', @aRet,,,,,,,,.F.,.F.)
		Return
	Endif
	
	For nI := 1 To Len( aPar )
		If Valtype( aRet[ nI ] ) == 'D'
			cDado := Dtoc( aRet[ nI ] )
		Elseif ValType( aRet[ nI ] ) == 'N'
			cDado := LTrim( Str( aRet[ nI ] ) )
			If nI==10 //Considera devolu��o? 1=Sim e 2=N�o.
				cDado += '-' + aOpcDev[ aRet[ nI ] ]
			Endif
			If n130Visao==3 .And. nI==11 //Produtos divergentes da meta? 1=Considera e 2=N�o considera.
				cDado += '-' + aOpcDiverg[ aRet[ nI ] ]
			Endif
			If n130Visao==1 .And. nI==11 //Resultado? Sint�tico ou Analit�co.
				cDado += '-' + aOpcResult[ aRet[ nI ] ]
			Endif
		Else
			cDado := aRet[ nI ]
			If nI==9 //Canal de venda
				cDado += '-'+RTrim(Posicione('SZ2',1,xFilial('SZ2')+aRet[9],'Z2_CANAL'))
			Endif
		Endif
		AAdd( aParam, aPar[ nI, 2 ] + ': ' + cDado )
	Next nI
	
	c130VisDe  := aRet[1]
	c130VisAte := aRet[2]
	d130FatDe  := aRet[3]
	d130FatAte := aRet[4]
	c130DocDe  := aRet[5]
	c130DocAte := aRet[6]
	d130MetDe  := aRet[7]
	d130MetAte := aRet[8]
	c130Canal  := aRet[9]
	n130Devol  := aRet[10]
	If n130Visao==3
		n130Diver := aRet[11]
	Endif
	If n130Visao==1
		n130Result := aRet[11]
	Endif
	Processa( {|| A130Proc(lReport) }, cCadastro,'Processamento em andamento, aguarde...', .F. )
Return

//-----------------------------------------------------------------------
// Rotina | A130Proc   | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ destinar o processamento conforme vis�o selecionada
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130Proc(lReport)
	Local lRet := .F.
	Local oReport
	
	Private aCab := {}
	Private aDados := {} 
	Private aSize := {}
	
	A130Sellers()
	
	If n130Visao == 1 .And. n130Result == 1
		lRet := A130Vended()
	Elseif n130Visao == 1 .And. n130Result == 2
		lRet := A130VAnalit()
	Elseif n130Visao == 2
		lRet := A130Regiao()
	Elseif n130Visao == 3
		lRet := A130Catego()
	Elseif n130Visao == 4
		lRet := A130Grupo()
	Elseif n130Visao == 5
		lRet := A130Prod()
	Else
		MsgAlert('N�o h� processamento para esta vis�o.',cCadastro)
	Endif
	
	If lRet
		If lReport
			oReport := A130Report( aDados, aCab )
			oReport:PrintDialog()
		Else
			A130UnLoad()
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A130Vended | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Processar a apura��o por vis�o de vendedor.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130Vended()
	Local cSQL := ''
	Local cTRB := ''
	Local cCount := ''
	Local cKey := ''

	Local nLin := 0
	Local nCount := 0

	Local nValLiq := 0
	Local nT_Fat := 0
	Local nT_Meta := 0
	
	Local aVendas := {}
	Local aDevol := {}
	
	AAdd( aCab,{ 'DOC.META',;
	             'SEQ',;
	             'VENDEDOR.',;
	             'NOME VENDEDOR',;
	             'VALOR META',;
	             'VLR.FATURADO',;
	             '% DA META' } )
	             
	cSQL := "SELECT CT_DOC, " + CRLF
	cSQL += "       CT_SEQUEN, " + CRLF
	cSQL += "       CT_VEND, " + CRLF
	cSQL += "       UPPER(A3_NOME) AS A3_NOME, " + CRLF
	cSQL += "       CT_VALOR " + CRLF
	cSQL += "FROM   "+RetSqlName("SCT")+" SCT " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SA3")+" SA3 " + CRLF
	cSQL += "               ON A3_FILIAL = "+ValToSql(xFilial("SA3"))+" " + CRLF
	cSQL += "                  AND SA3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND A3_COD = CT_VEND " + CRLF
	cSQL += "                  AND A3_MSBLQL <> '1' " + CRLF
	cSQL += "WHERE  CT_FILIAL = "+ValToSql(xFilial("SCT"))+" " + CRLF
	cSQL += "       AND SCT.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND CT_DOC BETWEEN "+ValToSql(c130DocDe)+" AND "+ValToSql(c130DocAte)+" " + CRLF
	cSQL += "       AND CT_VEND BETWEEN "+ValToSql(c130VisDe)+" AND "+ValToSql(c130VisAte)+" " + CRLF
	cSQL += "       AND CT_DATA BETWEEN "+ValToSql(d130MetDe)+" AND "+ValToSql(d130MetAte)+" " + CRLF
	cSQL += "ORDER  BY A3_NOME " + CRLF

   If l130Query
		AutoGrLog( cSQL )
		MostraErro()   
   Endif
   
	cCount := " SELECT COUNT(*) nCOUNT FROM ( " + cSQL + " ) QUERY "
		
	If At("ORDER  BY", Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At("ORDER  BY",cCount)-1) + SubStr(cCount,RAt(")",cCount))
	Endif	
	
	cCount := ChangeQuery( cCount )
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cCount),"SQLCOUNT",.F.,.T.)
	nCount := SQLCOUNT->nCOUNT
	SQLCOUNT->( DbCloseArea() )

	If nCount == 0
		MsgInfo('N�o foi poss�vel encontrar registros com os par�metros informados.', cCadastro)
		Return(.F.)
	Endif
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	ProcRegua(nCount)
	
	AAdd( aDados, AClone( aCab[ 1 ] ) )

	While ! (cTRB)->( EOF() )
		IncProc()
		
		If cKey <> (cTRB)->( CT_DOC + CT_VEND )
			cKey := (cTRB)->( CT_DOC + CT_VEND )
			nT_Vlr := 0
		Endif
	
		//--------------------------------------
		// Chama a funcao de calculo das vendas.
		//--------------------------------------
		aVendas := FtNfVendas(4,;                    //Tipo de meta
										(cTRB)->CT_VEND,;    //C�digo do vendedor
										d130FatDe,;          //Emiss�o faturamento de
										d130FatAte,;         //Emiss�o faturamento at�
										'',;                 //Regi�o de vendas
										'',;                 //Tipo de produto
										'',;                 //Grupo de produto
										'',;                 //C�digo do produto
										1,;                  //Moeda
										'',;                 //C�digo do cliente
										'',;                 //Loja do cliente
										,;                   //Expressao a ser adicionada na Query
										,;                   //Determina se devem ser consideradas Notas fiscais (1) Remitos (2) ou ambos tipos de documento (3)
										"'S'",;              //Movimento que gera financeiro
										"'S','N'")           //Movimenta estoque
		
		//---------------------------------------------------
		// Chama a funcao de calculo das devolucoes de venda.
		//---------------------------------------------------
		If n130Devol == 1
			aDevol := FtNfDevol(4,;                   //Tipo de meta
										(cTRB)->CT_VEND,;    //C�digo do vendedor   
										d130FatDe,;          //Emiss�o devolu��o de
										d130FatDe,;          //Emiss�o devolu��o ate
										'',;                 //Regi�o de devolu��o
										'',;                 //Tipo de produto
										'',;                 //Grupo de produto
										'',;                 //C�digo do produto
										1,;                  //Moeda
										'',;                 //C�digo do cliente
										'',;                 //Loja do cliente
										,;                   //Determina se devem ser consideradas Notas fiscais (1) Remitos (2) ou ambos tipos de documento (3)
										"'S'",;              //Movimento que gera financeiro
										"'S','N'")           //Movimenta estoque
		Else
			AAdd( aDevol, 0 )
			AAdd( aDevol, 0 )
		Endif
	 	
	 	nValLiq := aVendas[ 1 ]-aDevol[ 1 ]
		
	 	AAdd( aDados, { (cTRB)->CT_DOC,;           //Documento da meta
	 						 (cTRB)->CT_SEQUEN,;        //Sequencia do documeto da meta
	 						 (cTRB)->CT_VEND,;          //C�digo do produto
	 						 (cTRB)->A3_NOME,;          //Nome do vendedor
	 						 (cTRB)->CT_VALOR,;         //Valor da meta
	 						 nValLiq,;                  //Valor liquido (venda-devolu��o)
	 						 (nValLiq / (cTRB)->CT_VALOR)*100 })//% atingida da meta
	 						 
	 	aVendas := {}
	 	aDevol := {}
	 	
	 	nT_Fat += nValLiq
	 	nT_Meta += (cTRB)->CT_VALOR
	 	
		(cTRB)->( dbSkip() )
	End	
	
	AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
	nLin := Len( aDados )
	
	aDados[ nLin, 4 ] := 'RESULTADO FINAL'
	aDados[ nLin, 5 ] := nT_Meta
	aDados[ nLin, 6 ] := nT_Fat
	aDados[ nLin, 7 ] := (nT_Fat / nT_Meta)*100
	
	AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
	
	(cTRB)->(dbCloseArea())	
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A130VAnalit | Autor | Robson Gon�alves    | Data | 10.06.2013
//-----------------------------------------------------------------------
// Descr. | Processar a apura��o por vis�o de vendedor - forma anal�tico.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130VAnalit()
	Local cTRB := ''
	Local cSQL := ''
	Local cSQL_AUX := ''
	Local cCntVend := ''
	Local cVend := '1'
	Local cCount := ''  
	Local cKey := ''
	
	Local nI   := 0
	Local nP   := 0
	Local nLin := 0
	Local nCount   := 0
	Local nCntFor  := 0
	Local nCntVend := 0
	Local nTOT_VEND  := 0
	Local nTOT_META  := 0
	Local nCT_DOC    := 1
	Local nCT_SEQUEN := 2
	Local nCT_VEND   := 3
	Local nCT_VALOR  := 4
	
	Local nTGFAT := 0
	Local nTGMET := 0
		
	Local aCabMeta := {}
	Local aMETAS := {}
		
	//----------------------------------------
	// Buscar as metas conforme os par�metros.
	//----------------------------------------
	cSQL := "SELECT CT_DOC, " + CRLF
	cSQL += "       CT_SEQUEN, " + CRLF
	cSQL += "       CT_VEND, " + CRLF
	cSQL += "       CT_VALOR " + CRLF
	cSQL += "FROM   "+RetSqlName("SCT")+" SCT " + CRLF
	cSQL += "WHERE  CT_FILIAL = "+ValToSql(xFilial("SCT"))+" " + CRLF
	cSQL += "       AND SCT.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND CT_DOC BETWEEN "+ValToSql(c130DocDe)+" AND "+ValToSql(c130DocAte)+" " + CRLF
	cSQL += "       AND CT_VEND BETWEEN "+ValToSql(c130VisDe)+" AND "+ValToSql(c130VisAte)+" " + CRLF
	cSQL += "       AND CT_DATA BETWEEN "+ValToSql(d130MetDe)+" AND "+ValToSql(d130MetAte)+" " + CRLF
	cSQL += "ORDER  BY CT_VEND " + CRLF

   //-------------------------------
   // Exportar a instru��o da query.
   //-------------------------------
   If l130Query
		AutoGrLog( cSQL )
		MostraErro()   
   Endif
   	
	//-------------------
	// Cabe�alho da meta.
	//-------------------
	aCabMeta := { 'DOC.META',;
	              'SEQ',;
	              'VENDEDOR.',;
	              'VALOR META' }
	
	//--------------------------------
	// Processar a query e ler a view.
	//--------------------------------
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	
   c130Sellers := "("
	While ! (cTRB)->( EOF() )
		nP := AScan( aMETAS, {|p| p[3]==(cTRB)->(CT_VEND) })
		c130Sellers += " SF2.F2_VEND1='"+ (cTRB)->CT_VEND + "' OR"
		(cTRB)->( AAdd( aMETAS, { CT_DOC, CT_SEQUEN, CT_VEND, CT_VALOR } ) )
		(cTRB)->( dbSkip() )
	End	
	c130Sellers := SubStr(c130Sellers,1,Len(c130Selleras)-2) + ")"
	(cTRB)->(dbCloseArea())

	//---------------------------------------
	// Verificar se h� vendas compartilhadas.
	//---------------------------------------
	nCntVend := FA440CntVen()
	cSQL_AUX := "( "
	For nCntFor := 1 To nCntVend
		cSQL_AUX += "SF2.F2_VEND"+cVend+"= A3_COD OR "
		cVend := Soma1( cVend, Len( SF2->F2_VEND1 ) )
	Next nCntFor
	cSQL_AUX := SubStr( cSQL_AUX, 1, Len( cSQL_AUX ) -3 )+" ) AND 
	
	//-----------------------------
	// Montar a instru��o da query.
	//-----------------------------
	cSQL := "SELECT F2_VEND1, " + CRLF
	cSQL += "       A3_NOME, " + CRLF
	cSQL += "       D2_DOC, " + CRLF
	cSQL += "       D2_SERIE, " + CRLF
	cSQL += "       D2_EMISSAO, " + CRLF
	cSQL += "       D2_CLIENTE, " + CRLF
	cSQL += "       D2_LOJA, " + CRLF
	cSQL += "       A1_NOME, " + CRLF
	cSQL += "       D2_EST, " + CRLF
	cSQL += "       D2_ITEM, " + CRLF
	cSQL += "       D2_COD, " + CRLF
	cSQL += "       B1_DESC, " + CRLF
	cSQL += "       D2_QUANT, " + CRLF
	cSQL += "       D2_TOTAL " + CRLF
	cSQL += "FROM "+RetSqlName( "SF2" )+" SF2 " + CRLF
	cSQL += "	    INNER JOIN "+RetSqlName( "SD2" )+" SD2 " + CRLF
	cSQL += "	            ON D2_FILIAL = "+ValToSql( xFilial( "SD2" ) )+" " + CRLF
	cSQL += "	               AND D2_SERIE = F2_SERIE " + CRLF
	cSQL += "	               AND D2_DOC = F2_DOC " + CRLF
	cSQL += "	               AND D2_CLIENTE = F2_CLIENTE " + CRLF
	cSQL += "	               AND D2_LOJA = F2_LOJA " + CRLF
	cSQL += "	               AND SD2.D_E_L_E_T_ = ' ' " + CRLF

	cSQL += "	    INNER JOIN "+RetSqlName( "SA1" )+" SA1 " + CRLF
	cSQL += "	            ON A1_FILIAL = "+ValToSql( xFilial( "SA1" ) )+" " + CRLF
	cSQL += "	               AND A1_COD = D2_CLIENTE " + CRLF
	cSQL += "	               AND A1_LOJA = D2_LOJA " + CRLF
	cSQL += "	               AND SA1.D_E_L_E_T_ = ' ' " + CRLF

	cSQL += "	    INNER JOIN "+RetSqlName( "SB1" )+" SB1 " + CRLF
	cSQL += "	            ON B1_FILIAL = "+ValToSql( xFilial( "SB1" ) )+" " + CRLF
	cSQL += "	               AND B1_COD = D2_COD " + CRLF
	cSQL += "	               AND SB1.D_E_L_E_T_ = ' ' " + CRLF
		
	cSQL += "	    INNER JOIN "+RetSqlName( "SF4" )+" SF4 " + CRLF
	cSQL += "	            ON F4_FILIAL = "+ValToSql( xFilial( "SF4" ) )+" " + CRLF
	cSQL += "	               AND F4_CODIGO = D2_TES " + CRLF
	cSQL += "	               AND F4_DUPLIC = 'S' " + CRLF
	cSQL += "	               AND F4_ESTOQUE IN ('S','N') " + CRLF
	cSQL += "	               AND SF4.D_E_L_E_T_ = ' ' " + CRLF
	
	cSQL += "	    INNER JOIN "+RetSqlName( "SA3" )+" SA3 " + CRLF
	cSQL += "	            ON A3_FILIAL = "+ValToSql( xFilial( "SA3" ) )+" " + CRLF
	cSQL += "	               AND A3_COD = F2_VEND1 " + CRLF
	cSQL += "	               AND SA3.D_E_L_E_T_ = ' ' " + CRLF

	cSQL += "WHERE  F2_FILIAL = "+ValToSql( xFilial( "SF2" ) )+"  " + CRLF
	cSQL += "       AND F2_TIPO = 'N' " + CRLF
	cSQL += "       AND SF2.F2_EMISSAO BETWEEN "+ValToSql(d130FatDe)+" AND "+ValToSql(d130FatAte)+" " + CRLF
	cSQL += "       AND " + c130Sellers + " " + CRLF 
	cSQL += "	    AND EXISTS (SELECT A3_FILIAL  " + CRLF
	cSQL += "		             FROM   "+RetSqlName( "SA3" )+" SA3 " + CRLF
	cSQL += "		             WHERE  " + cSQL_AUX + CRLF
	cSQL += "		                    SA3.D_E_L_E_T_ = ' ' )" + CRLF
	cSQL += "ORDER  BY F2_VEND1, " + CRLF
	cSQL += "          F2_EMISSAO, " + CRLF
	cSQL += "          D2_COD " + CRLF
	
   //-------------------------------
   // Exportar a instru��o da query.
   //-------------------------------
   If l130Query
		AutoGrLog( cSQL )
		MostraErro()   
   Endif
   
	//------------------------
	// Efetuar Count na query.
	//------------------------
	cCount := " SELECT COUNT(*) nCOUNT FROM ( " + cSQL + " ) QUERY "
		
	If At("ORDER  BY", Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At("ORDER  BY",cCount)-1) + SubStr(cCount,RAt(")",cCount))
	Endif	
	
	cCount := ChangeQuery( cCount )
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cCount),"SQLCOUNT",.F.,.T.)
	nCount := SQLCOUNT->nCOUNT
	SQLCOUNT->( DbCloseArea() )

	If nCount == 0
		MsgInfo('N�o foi poss�vel encontrar registros com os par�metros informados.', cCadastro)
		Return(.F.)
	Endif
	
	//--------------------------------
	// Tamanho de cada coluna de dado.
	//--------------------------------
	aSize := {10,30,11,7,10,8,6,45,6,6,15,20,14,14}
	//        |  |  |  | |  | | |  | | |  |  |  |
	//        |  |  |  | |  | | |  | | |  |  |  +-> TOTAL
	//        |  |  |  | |  | | |  | | |  |  +----> QUANT.
	//        |  |  |  | |  | | |  | | |  +-------> DESCRI��O
	//        |  |  |  | |  | | |  | | +----------> PRODUTO
	//        |  |  |  | |  | | |  | +------------> ITEM
	//        |  |  |  | |  | | |  +--------------> UF
	//        |  |  |  | |  | | +-----------------> NOME CLIENTE
	//        |  |  |  | |  | +-------------------> LOJA
	//        |  |  |  | |  +---------------------> CLIENTE
	//        |  |  |  | +------------------------> EMISSAO
	//        |  |  |  +--------------------------> SERIE
	//        |  |  +-----------------------------> DOCUMENTO
	//        |  +--------------------------------> NOME
	//        +-----------------------------------> VENDEDOR
	//--------------------------
	// Cabe�alho do faturamento.
	//--------------------------
	AAdd( aCab,{ 'VENDEDOR',;
	             'NOME',;
	             'DOCUMENTO',;
	             'S�RIE',;
	             'EMISS�O',;
	             'CLIENTE',;
	             'LOJA',;
	             'NOME CLIENTE',;
	             'UF',;
	             'ITEM',;
	             'PRODUTO',;
	             'DESCRI��O',;
	             'QUANT.',;
	             'TOTAL' } )
	
	//--------------------------------
	// Processar a query e ler a view.
	//--------------------------------
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	ProcRegua(nCount)

	//------------------------------
	// Processar cada linha da view.
	//------------------------------
	While ! (cTRB)->( EOF() )
		IncProc()
		
		AAdd( aDados, AClone( aCab[ 1 ] ) )
		
		//-----------------------------------
		// Ler somente o vendedor em quest�o.
		//-----------------------------------
		cKey := (cTRB)->(F2_VEND1)
		While ! (cTRB)->( EOF() ) .And. (cTRB)->(F2_VEND1) == cKey
			(cTRB)->(AAdd( aDados, { F2_VEND1,   RTrim(A3_NOME),; 
			                         D2_DOC,     D2_SERIE,;
			                         D2_EMISSAO, D2_CLIENTE,;
			                         D2_LOJA,    RTrim(A1_NOME),;
			                         D2_EST,     D2_ITEM,;
			                         D2_COD,     RTrim(B1_DESC),;
			                         D2_QUANT,   D2_TOTAL } ))
			
			//-------------------
			// Totalizar a venda.
			//-------------------
			nTOT_VEND += (cTRB)->(D2_TOTAL)
			nTGFAT += (cTRB)->(D2_TOTAL)
			(cTRB)->(dbSkip())
		End
		
		//------------------------------
		// Adicionar uma linha no array.
		//------------------------------
		AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
		nLin := Len( aDados )
		
		//-------------------------------
		// Gravar o total do faturamento.
		//-------------------------------
		aDados[ nLin, 11 ] := "TOTAL FATURADO"
		aDados[ nLin, 14 ] := nTOT_VEND
		
		//------------------------------
		// Adicionar uma linha no array.
		//------------------------------
		AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
		nLin := Len( aDados )
		
		//------------------------------
		// Localizar a meta por vendedor
		//------------------------------
		nP := AScan( aMETAS, {|p| p[nCT_VEND] == cKey } )
		If nP > 0
			//----------------------------------------------
			// Achando fazer a conta do quanto foi atingido.
			//----------------------------------------------
			aDados[ nLin, 11 ] := "META ESTIPULADA"
			aDados[ nLin, 12 ] := aCabMeta[ nCT_DOC ]
			aDados[ nLin, 13 ] := aCabMeta[ nCT_SEQUEN ]
			aDados[ nLin, 14 ] := aCabMeta[ nCT_VALOR ]
		
			For nI := nP To Len( aMETAS )
				If aMETAS[ nI, nCT_VEND ] == cKey
					AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
					nLin := Len( aDados )
					aDados[ nLin, 12 ] := aMETAS[ nI, nCT_DOC ]
					aDados[ nLin, 13 ] := aMETAS[ nI, nCT_SEQUENC ]
					aDados[ nLin, 14 ] := aMETAS[ nI, nCT_VALOR ]
					nTOT_META += aMETAS[ nI, nCT_VALOR ]
					nTGMET += aMETAS[ nI, nCT_VALOR ]
				Endif
			Next nI
			
			AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
			nLin := Len( aDados )
			
			aDados[ nLin, 11 ] := "TOTAL DA META"
			aDados[ nLin, 14 ] := nTOT_META
			
			AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
			nLin := Len( aDados )

			aDados[ nLin, 11 ] := "% DA META"
			aDados[ nLin, 14 ] := (nTOT_VEND / aMETAS[ nP, nCT_VALOR ])*100
			
			AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
		Else
			//-----------------------------
			// N�o achando apenas informar.
			//-----------------------------
			aDados[ nLin, 2 ] := 'VENDEDOR SEM METAS DE VENDAS'
		Endif
		
		nTOT_VEND := 0
		nTOT_META := 0
	End
	
	AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
	nLin := Len( aDados )
	
	aDados[ nLin, 11 ] := "TOTAL GERAL FATURADO"
	aDados[ nLin, 14 ] := nTGFAT
	
	AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
	nLin := Len( aDados )

	aDados[ nLin, 11 ] := "TOTAL GERAL META"
	aDados[ nLin, 14 ] := nTGMET
	
	AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
	nLin := Len( aDados )
	
	aDados[ nLin, 11 ] := "% META GERAL"
	aDados[ nLin, 14 ] := (nTGFAT/nTGMET)*100
	
	(cTRB)->(dbCloseArea())
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A130Regiao | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Processar a apura��o por vis�o de regi�o de vendas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130Regiao()
	Local cSQL := ''
	Local cTRB := ''
	Local cCount := ''
	Local cKey := ''

	Local nLin := 0
	Local nCount := 0

	Local nValLiq := 0
	Local nT_Fat := 0
	Local nT_Meta := 0
	
	Local aVendas := {}
	Local aDevol := {}
	
	AAdd( aCab,{ 'DOC.META',;
	             'SEQ',;
	             'REGI�O',;
	             'NOME REGI�O',;
	             'VLR.FATURADO)',;
	             'VALOR META',;
	             '% DA META' } )
	             
	cSQL := "SELECT CT_DOC, " + CRLF
	cSQL += "       CT_SEQUEN, " + CRLF
	cSQL += "       CT_REGIAO, " + CRLF
	cSQL += "       UPPER(X5_DESCRI) AS X5_DESCRI, " + CRLF
	cSQL += "       CT_VALOR " + CRLF
	cSQL += "FROM   "+RetSqlName("SCT")+" SCT " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SX5")+" SX5 " + CRLF
	cSQL += "               ON X5_FILIAL = "+ValToSql(xFilial("SX5"))+" " + CRLF
	cSQL += "                  AND SX5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND SX5.X5_TABELA = 'A2' " + CRLF
	cSQL += "                  AND RTRIM(X5_CHAVE) = CT_REGIAO " + CRLF
	cSQL += "WHERE  CT_FILIAL = "+ValToSql(xFilial("SCT"))+" " + CRLF
	cSQL += "       AND SCT.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND CT_DOC BETWEEN "+ValToSql(c130DocDe)+" AND "+ValToSql(c130DocAte)+" " + CRLF
	cSQL += "       AND CT_REGIAO BETWEEN "+ValToSql(c130VisDe)+" AND "+ValToSql(c130VisAte)+" " + CRLF
	cSQL += "       AND CT_DATA BETWEEN "+ValToSql(d130MetDe)+" AND "+ValToSql(d130MetAte)+" " + CRLF
	cSQL += "ORDER  BY CT_REGIAO " + CRLF

   If l130Query
		AutoGrLog( cSQL )
		MostraErro()   
   Endif
   
	cCount := " SELECT COUNT(*) nCOUNT FROM ( " + cSQL + " ) QUERY "
		
	If At("ORDER  BY", Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At("ORDER  BY",cCount)-1) + SubStr(cCount,RAt(")",cCount))
	Endif	
	
	cCount := ChangeQuery( cCount )
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cCount),"SQLCOUNT",.F.,.T.)
	nCount := SQLCOUNT->nCOUNT
	SQLCOUNT->( DbCloseArea() )

	If nCount == 0
		MsgInfo('N�o foi poss�vel encontrar registros com os par�metros informados.', cCadastro)
		Return(.F.)
	Endif
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	ProcRegua(nCount)
	
	AAdd( aDados, AClone( aCab[ 1 ] ) )

	While ! (cTRB)->( EOF() )
		IncProc()
		
		If cKey <> (cTRB)->( CT_DOC + CT_REGIAO )
			cKey := (cTRB)->( CT_DOC + CT_REGIAO )
			nT_Vlr := 0
		Endif
	
		//--------------------------------------
		// Chama a funcao de calculo das vendas.
		//--------------------------------------
		aVendas := FtNfVendas(4,;                    //Tipo de meta
										'',;                 //C�digo do vendedor
										d130FatDe,;          //Emiss�o faturamento de
										d130FatAte,;         //Emiss�o faturamento at�
										(cTRB)->CT_REGIAO,;  //Regi�o de vendas
										'',;                 //Tipo de produto
										'',;                 //Grupo de produto
										'',;                 //C�digo do produto
										1,;                  //Moeda
										'',;                 //C�digo do cliente
										'',;                 //Loja do cliente
										c130Sellers,;        //Expressao a ser adicionada na Query
										,;                   //Determina se devem ser consideradas Notas fiscais (1) Remitos (2) ou ambos tipos de documento (3)
										"'S'",;              //Movimento que gera financeiro
										"'S','N'")           //Movimenta estoque
		
		//---------------------------------------------------
		// Chama a funcao de calculo das devolucoes de venda.
		//---------------------------------------------------
		If n130Devol == 1
			aDevol := FtNfDevol(4,;                   //Tipo de meta
										'',;                 //C�digo do vendedor   
										d130FatDe,;          //Emiss�o devolu��o de
										d130FatDe,;          //Emiss�o devolu��o ate
										(cTRB)->CT_REGIAO,;  //Regi�o de devolu��o
										'',;                 //Tipo de produto
										'',;                 //Grupo de produto
										'',;                 //C�digo do produto
										1,;                  //Moeda
										'',;                 //C�digo do cliente
										'',;                 //Loja do cliente
										,;                   //Determina se devem ser consideradas Notas fiscais (1) Remitos (2) ou ambos tipos de documento (3)
										"'S'",;              //Movimento que gera financeiro
										"'S','N'")           //Movimenta estoque
		Else
			AAdd( aDevol, 0 )
			AAdd( aDevol, 0 )
		Endif
	 	nValLiq := aVendas[ 1 ]-aDevol[ 1 ]
		
	 	AAdd( aDados, { (cTRB)->CT_DOC,;           //Documento da meta
	 						 (cTRB)->CT_SEQUEN,;        //Sequencia do documeto da meta
	 						 (cTRB)->CT_REGIAO,;        //C�digo da regi�o
	 						 (cTRB)->X5_DESCRI,;        //Nome da regiao
	 						 nValLiq,;                  //Valor liquido (venda-devolu��o)
	 						 (cTRB)->CT_VALOR,;         //Valor da meta
	 						 (nValLiq / (cTRB)->CT_VALOR)*100 })//% atingida da meta
	 						 
	 	aVendas := {}
	 	aDevol := {}
	 	
	 	nT_Fat += nValLiq
	 	nT_Meta += (cTRB)->CT_VALOR
	 	
		(cTRB)->( dbSkip() )
	End	
	
	AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
	nLin := Len( aDados )
	
	aDados[ nLin, 4 ] := 'RESULTADO FINAL'
	aDados[ nLin, 5 ] := nT_Fat
	aDados[ nLin, 6 ] := nT_Meta
	aDados[ nLin, 7 ] := (nT_Fat / nT_Meta)*100
	
	AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
	
	(cTRB)->(dbCloseArea())	
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A130Catego | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Processar a apura��o por vis�o de categorias de produtos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130Catego()
	Local lFirst := .T.
	
	Local cSQL := ''
	Local cTRB := ''
	Local cCount := ''
	Local cKey := ''
	Local cALL := ''
	
	Local nPos := 0
	Local nLin := 0
	Local nCount := 0

	Local nQtdLiq := 0
	Local nValLiq := 0

	Local nT_Qtd := 0
	Local nT_Vlr := 0
	Local nT_QFinal := 0
	Local nT_VFinal := 0

	Local nQtd_Meta := 0
	Local nVlr_Meta := 0
	
	Local nT_QDiver := 0
	Local nT_VDiver := 0

	Local aVendas := {}
	Local aDevol := {}
	
	//-----------------------
	// Montagem do cabe�alho.
	//-----------------------
	AAdd( aCab,{ 'CAT.SUP.',;
	             'DESCRI.CAT.SUPER.',;
	             'CATEGORIA',;
	             'DESCRI��O DA CATEGORIA',;
	             'DOC.META',;
	             'SEQ',;
	             'PRODUTO',;
	             'DESCRI��O PRODUTO',;
	             'QTDE.FATURADA',;
	             'VLR.FATURADO' } )

	//----------------------------------------------------------------------------
	// Montagem da query baseada na meta de vendas na vis�o categoria de produtos.
	//----------------------------------------------------------------------------
	cSQL := "SELECT CT_DOC, " + CRLF
	cSQL += "       CT_SEQUEN, " + CRLF
	cSQL += "       CT_CATEGO, " + CRLF
	cSQL += "       ACU_DESC, " + CRLF
	cSQL += "       ACU_CODPAI, " + CRLF
	cSQL += "       CT_QUANT, " + CRLF
	cSQL += "       CT_VALOR, " + CRLF
	cSQL += "       ACV_CODPRO, " + CRLF
	cSQL += "       B1_DESC "
	cSQL += "FROM   "+RetSqlName("SCT")+" SCT " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("ACV")+" ACV " + CRLF
	cSQL += "               ON ACV_FILIAL = "+ValToSql(xFilial("ACV"))+" " + CRLF
	cSQL += "                  AND ACV.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND ACV_CATEGO = CT_CATEGO " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("ACU")+" ACU " + CRLF
	cSQL += "               ON ACU_FILIAL = "+ValToSql(xFilial("ACU"))+" " + CRLF
	cSQL += "                  AND ACU.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND ACU_COD = CT_CATEGO	" + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" SB1 " + CRLF
	cSQL += "               ON B1_FILIAL = "+ValToSql(xFilial("SB1"))+" " + CRLF
	cSQL += "                  AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND B1_COD = ACV_CODPRO " + CRLF
	cSQL += "WHERE  CT_FILIAL = "+ValToSql(xFilial("SCT"))+" " + CRLF
	cSQL += "       AND SCT.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND CT_DOC BETWEEN "+ValToSql(c130DocDe)+" AND "+ValToSql(c130DocAte)+" " + CRLF
	cSQL += "       AND CT_CATEGO BETWEEN "+ValToSql(c130VisDe)+" AND "+ValToSql(c130VisAte)+" " + CRLF
	cSQL += "       AND CT_DATA BETWEEN "+ValToSql(d130MetDe)+" AND "+ValToSql(d130MetAte)+" " + CRLF
	cSQL += "ORDER  BY CT_DOC, CT_CATEGO, ACV_CODPRO " + CRLF
	
   //-----------------------------------------
   // Se ligado exportar a instru��o da query.
   //-----------------------------------------
   If l130Query
		AutoGrLog( cSQL )
		MostraErro()   
   Endif
   
	//-------------------------------------------------------------------------
	// Montagem da query para apurar a quantidade de registro a ser processado.
	//-------------------------------------------------------------------------
	cCount := " SELECT COUNT(*) nCOUNT FROM ( " + cSQL + " ) QUERY "		
	If At("ORDER  BY", Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At("ORDER  BY",cCount)-1) + SubStr(cCount,RAt(")",cCount))
	Endif
	cCount := ChangeQuery( cCount )
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cCount),"SQLCOUNT",.F.,.T.)
	nCount := SQLCOUNT->nCOUNT
	SQLCOUNT->( DbCloseArea() )
	If nCount == 0
		MsgInfo('N�o foi poss�vel encontrar registros com os par�metros informados.', cCadastro)
		Return(.F.)
	Endif
	
	//--------------------------------------------------
	// Execu��o da instru��o da query no banco de dados.
	//--------------------------------------------------
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	ProcRegua(nCount)
	
	//------------------------------------------
	// Processar cada linha do retorno da query.
	//------------------------------------------
	While ! (cTRB)->( EOF() )
		IncProc()
		
		//--------------------------------------------------
		// Fazer o controle da quebra de grupo de registros.
		//--------------------------------------------------
		If cKey <> (cTRB)->( ACU_CODPAI + CT_CATEGO + CT_DOC + CT_SEQUEN )
			cKey := (cTRB)->( ACU_CODPAI + CT_CATEGO + CT_DOC + CT_SEQUEN )
			
			AAdd( aDados, AClone( aCab[ 1 ] ) )
			
			nQtd_Meta := (cTRB)->CT_QUANT
			nVlr_Meta := (cTRB)->CT_VALOR
			
			nT_Qtd := 0
			nT_Vlr := 0
		Endif
	
		//--------------------------------------
		// Chama a funcao de calculo das vendas.
		//--------------------------------------
		aVendas := FtNfVendas(4,;                    //Tipo de meta
										'',;                 //C�digo do vendedor
										d130FatDe,;          //Emiss�o faturamento de
										d130FatAte,;         //Emiss�o faturamento at�
										'',;                 //Regi�o de vendas
										'',;                 //Tipo de produto
										'',;                 //Grupo de produto
										(cTRB)->ACV_CODPRO,; //C�digo do produto
										1,;                  //Moeda
										'',;                 //C�digo do cliente
										'',;                 //Loja do cliente
										c130Sellers,;        //Expressao a ser adicionada na Query
										,;                   //Determina se devem ser consideradas Notas fiscais (1) Remitos (2) ou ambos tipos de documento (3)
										"'S'",;              //Movimento que gera financeiro
										"'S','N'")           //Movimenta estoque
		
		//---------------------------------------------------
		// Chama a funcao de calculo das devolucoes de venda.
		//---------------------------------------------------
		If n130Devol == 1
			aDevol := FtNfDevol(4,;                   //Tipo de meta
										'',;                 //C�digo do vendedor   
										d130FatDe,;          //Emiss�o devolu��o de
										d130FatDe,;          //Emiss�o devolu��o ate
										'',;                 //Regi�o de devolu��o
										'',;                 //Tipo de produto
										'',;                 //Grupo de produto
										(cTRB)->ACV_CODPRO,; //C�digo do produto
										1,;                  //Moeda
										'',;                 //C�digo do cliente
										'',;                 //Loja do cliente
										,;                   //Determina se devem ser consideradas Notas fiscais (1) Remitos (2) ou ambos tipos de documento (3)
										"'S'",;              //Movimento que gera financeiro
										"'S','N'")           //Movimenta estoque
		Else
			AAdd( aDevol, 0 )
			AAdd( aDevol, 0 )
		Endif
	 		 	
	 	//--------------------------------------------
	 	// Fazer a busca da categoria pai de produtos.
	 	//--------------------------------------------
	 	If ACU->ACU_COD <> (cTRB)->ACU_CODPAI
	 		ACU->(dbSetOrder(1))
	 		ACU->(dbSeek(xFilial("ACU")+(cTRB)->ACU_CODPAI))
	 	Endif
	 	
	 	//-------------------------------
	 	// Apurar vendas menos devolu��o.
	 	//-------------------------------
	 	nQtdLiq := aVendas[ 2 ]-aDevol[ 2 ]
	 	nValLiq := aVendas[ 1 ]-aDevol[ 1 ]
		
		//--------------------------------------
		// Totalizar por categorias de produtos.
		//--------------------------------------
		nT_Qtd += nQtdLiq
		nT_Vlr += nValLiq
		
		//----------------------------------
		// Totalizador para resultado final.
		//----------------------------------
		nT_QFinal += nQtdLiq
		nT_Vfinal += nValLiq
		
	 	//--------------------------------------------------------------
	 	// Acumular no vetor para descarregar no final do processamento.
	 	//--------------------------------------------------------------
	 	AAdd( aDados, { ACU->ACU_COD,;             //C�digo categoria superior
	 						 ACU->ACU_DESC,;            //Descri��o categoria superior
	 						 (cTRB)->CT_CATEGO,;        //C�digo categoria
	 						 (cTRB)->ACU_DESC,;         //Descri��o categoria
	 						 (cTRB)->CT_DOC,;           //Documento da meta
	 						 (cTRB)->CT_SEQUEN,;        //Sequencia do documeto da meta
	 						 (cTRB)->ACV_CODPRO,;       //C�digo do produto
	 						 (cTRB)->B1_DESC,;          //Descri��o do produto
	 						 nQtdLiq,;                  //Quantidade liquida (venda-devolu��o)
	 						 nValLiq })                 //Valor liquido (venda-devolu��o)
	 	
	 	//-------------------
	 	// Limpar os vetores.
	 	//-------------------
	 	aVendas := {}
	 	aDevol := {}
	 	
		//-----------------------------------
		// Pular para pr�xima linha da query.
		//-----------------------------------
		(cTRB)->( dbSkip() )
		
		//----------------------------------
		// Gravar totalizados por categoria.
		//----------------------------------
		If (cTRB)->( ACU_CODPAI + CT_CATEGO + CT_DOC + CT_SEQUEN ) <> cKey
					
			AAdd( aDados, Array( Len( aCab[1] ) ) )
			nLin := Len( aDados )
			aDados[ nLin,  8 ] := 'TOTAL REAL (VENDA-DEVOL.)'
			aDados[ nLin,  9 ] := nT_Qtd
			aDados[ nLin, 10 ] := nT_Vlr
			
			AAdd( aDados, Array( Len( aDados[1] ) ) )
			nLin := Len( aDados )
			aDados[ nLin,  8 ] := 'META'
			aDados[ nLin,  9 ] := nQtd_Meta
			aDados[ nLin, 10 ] := nVlr_Meta
			
			AAdd( aDados, Array( Len( aDados[1] ) ) )
			nLin := Len( aDados )
			aDados[ nLin,  8 ] := '% DA META'
			aDados[ nLin,  9 ] := (nT_Qtd / nQtd_Meta)*100
			aDados[ nLin, 10 ] := (nT_Vlr / nVlr_Meta)*100

			AAdd( aDados, Array( Len( aDados[1] ) ) )
		Endif
	End
	
	//-----------------------------------------------------
	// Gravar o totalizador da apura��o da meta processada.
	//-----------------------------------------------------
	If Len( aDados ) > 0
		AAdd( aDados, Array( Len( aCab[1] ) ) )
		nLin := Len( aDados )

		aDados[ nLin,  8 ] := 'RESULTADO FINAL APURADO'
		aDados[ nLin,  9 ] := nT_QFinal
		aDados[ nLin, 10 ] := nT_VFinal
	Endif
	
	//----------------------------------
	// Fechar a �rea da query principal.
	//----------------------------------
	(cTRB)->(dbCloseArea())
	
	//-----------------------------------------------------------------------------------------------------
	// Se for para apurar as vendas dos produtos do mesmo canal de vendas que n�o est�o na metal de vendas.
	//-----------------------------------------------------------------------------------------------------
	If n130Diver == 1 .And. Len( aDados ) > 0
		//-------------------------------------------------------
		// Elaborar a instru��o da query para estas diverg�ncias.
		//-------------------------------------------------------
		cALL := A130Diver(@nCount)
		ProcRegua(nCount)
		//------------------------------------------
		// Processar cada linha do retorno da query.
		//------------------------------------------
		While !(cALL)->(EOF())
			IncProc()
			//---------------------------------------------------------
			// O c�digo do produto em quest�o existe no vetor de dados?
			//---------------------------------------------------------
			nPos := AScan( aDados, {|p| p[7] == (cALL)->D2_COD })
			//--------------------------------
			// Se n�o existir interessa saber.
			//--------------------------------
			If nPos == 0				
				//--------------------------------------------------------------------
				// Se for a primeira vez, fazer o cabe�alho deste grupo de informa��o.
				//--------------------------------------------------------------------
				If lFirst 
					lFirst := .F.
					AAdd( aDados, Array( Len( aCab[1] ) ) )
					nLin := Len( aDados )
					aDados[ nLin, 1 ] := 'PRODUTOS DIVERGENTES DO PLANO DE METAS'
					AAdd( aDados, AClone( aCab[ 1 ] ) )
				Endif
				//--------------------------
				// Gravar os dados no vetor.
				//--------------------------
				AAdd( aDados, Array( Len( aCab[1] ) ) )
				nLin := Len( aDados )
				aDADOS[ nLin,  7 ] := (cALL)->D2_COD
				aDADOS[ nLin,  8 ] := (cALL)->B1_DESC
				aDADOS[ nLin,  9 ] := (cALL)->D2_QUANT
				aDADOS[ nLin, 10 ] := (cALL)->D2_TOTAL 
				//------------------------
				// Totalizar estas vendas.
				//------------------------
				nT_QDiver += (cALL)->D2_QUANT
				nT_VDiver += (cALL)->D2_TOTAL 
			Endif
			//--------------------------
			// Pular para pr�xima linha.
			//--------------------------
			(cALL)->(dbSkip())
		End
		//-----------------------------------
		// Fechar a �rea da query em quest�o.
		//-----------------------------------
		(cALL)->(dbCloseArea())
		//-------------------------------------
		// Se houver totais calculados, gravar.
		//-------------------------------------
		If nT_QDiver > 0 .And. nT_VDiver > 0
			AAdd( aDados, Array( Len( aCab[1] ) ) )
			AAdd( aDados, Array( Len( aCab[1] ) ) )
			nLin := Len( aDados )

			aDados[ nLin,  8 ] := 'RESULTADO DIVERGENTE DA META'
			aDados[ nLin,  9 ] := nT_QDiver
			aDados[ nLin, 10 ] := nT_VDiver
		
			AAdd( aDados, Array( Len( aCab[1] ) ) )
			AAdd( aDados, Array( Len( aCab[1] ) ) )
			nLin := Len( aDados )
		
			aDados[ nLin,  8 ] := 'RESULTADO APURADO + DIVERGENTE DA META'
			aDados[ nLin,  9 ] := nT_QFinal + nT_QDiver
			aDados[ nLin, 10 ] := nT_VFinal + nT_VDiver
		Endif
	Endif
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A130Grupo  | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Processar a apura��o por vis�o de grupo.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130Grupo()
	Local cSQL := ''
	Local cTRB := ''
	Local cCount := ''
	Local cKey := ''

	Local nLin := 0
	Local nCount := 0

	Local nValLiq := 0
	Local nT_Fat := 0
	Local nT_Meta := 0
	
	Local aVendas := {}
	Local aDevol := {}
	
	AAdd( aCab,{ 'DOC.META',;
	             'SEQ',;
	             'GRUPO',;
	             'NOME GRUPO',;
	             'VLR.FATURADO',;
	             'VALOR META',;
	             '% DA META' } )
	             
	cSQL := "SELECT CT_DOC, " + CRLF
	cSQL += "       CT_SEQUEN, " + CRLF
	cSQL += "       CT_GRUPO, " + CRLF
	cSQL += "       BM_DESC, " + CRLF
	cSQL += "       CT_VALOR " + CRLF
	cSQL += "FROM   "+RetSqlName("SCT")+" SCT " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SBM")+" SBM " + CRLF
	cSQL += "               ON BM_FILIAL = "+ValToSql(xFilial("SBM"))+" " + CRLF
	cSQL += "                  AND SBM.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND BM_GRUPO = CT_GRUPO " + CRLF
	cSQL += "                  AND BM_MSBLQL <> '1' " + CRLF
	cSQL += "WHERE  CT_FILIAL = "+ValToSql(xFilial("SCT"))+" " + CRLF
	cSQL += "       AND SCT.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND CT_DOC BETWEEN "+ValToSql(c130DocDe)+" AND "+ValToSql(c130DocAte)+" " + CRLF
	cSQL += "       AND CT_GRUPO BETWEEN "+ValToSql(c130VisDe)+" AND "+ValToSql(c130VisAte)+" " + CRLF
	cSQL += "       AND CT_DATA BETWEEN "+ValToSql(d130MetDe)+" AND "+ValToSql(d130MetAte)+" " + CRLF
	cSQL += "ORDER  BY CT_GRUPO " + CRLF

   If l130Query
		AutoGrLog( cSQL )
		MostraErro()   
   Endif
   
	cCount := " SELECT COUNT(*) nCOUNT FROM ( " + cSQL + " ) QUERY "
		
	If At("ORDER  BY", Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At("ORDER  BY",cCount)-1) + SubStr(cCount,RAt(")",cCount))
	Endif	
	
	cCount := ChangeQuery( cCount )
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cCount),"SQLCOUNT",.F.,.T.)
	nCount := SQLCOUNT->nCOUNT
	SQLCOUNT->( DbCloseArea() )

	If nCount == 0
		MsgInfo('N�o foi poss�vel encontrar registros com os par�metros informados.', cCadastro)
		Return(.F.)
	Endif
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	ProcRegua(nCount)
	
	AAdd( aDados, AClone( aCab[ 1 ] ) )

	While ! (cTRB)->( EOF() )
		IncProc()
		
		If cKey <> (cTRB)->( CT_DOC + CT_GRUPO )
			cKey := (cTRB)->( CT_DOC + CT_GRUPO )
			nT_Vlr := 0
		Endif
	
		//--------------------------------------
		// Chama a funcao de calculo das vendas.
		//--------------------------------------
		aVendas := FtNfVendas(4,;                    //Tipo de meta
										'',;    //C�digo do vendedor
										d130FatDe,;          //Emiss�o faturamento de
										d130FatAte,;         //Emiss�o faturamento at�
										'',;                 //Regi�o de vendas
										'',;                 //Tipo de produto
										(cTRB)->CT_GRUPO,;   //Grupo de produto
										'',;                 //C�digo do produto
										1,;                  //Moeda
										'',;                 //C�digo do cliente
										'',;                 //Loja do cliente
										c130Sellers,;        //Expressao a ser adicionada na Query
										,;                   //Determina se devem ser consideradas Notas fiscais (1) Remitos (2) ou ambos tipos de documento (3)
										"'S'",;              //Movimento que gera financeiro
										"'S','N'")           //Movimenta estoque
		
		//---------------------------------------------------
		// Chama a funcao de calculo das devolucoes de venda.
		//---------------------------------------------------
		If n130Devol == 1
			aDevol := FtNfDevol(4,;                   //Tipo de meta
										'',;                 //C�digo do vendedor   
										d130FatDe,;          //Emiss�o devolu��o de
										d130FatDe,;          //Emiss�o devolu��o ate
										'',;                 //Regi�o de devolu��o
										'',;                 //Tipo de produto
										(cTRB)->CT_GRUPO,;   //Grupo de produto
										'',;                 //C�digo do produto
										1,;                  //Moeda
										'',;                 //C�digo do cliente
										'',;                 //Loja do cliente
										,;                   //Determina se devem ser consideradas Notas fiscais (1) Remitos (2) ou ambos tipos de documento (3)
										"'S'",;              //Movimento que gera financeiro
										"'S','N'")           //Movimenta estoque
		Else
			AAdd( aDevol, 0 )
			AAdd( aDevol, 0 )
		Endif
	 	nValLiq := aVendas[ 1 ]-aDevol[ 1 ]
		
	 	AAdd( aDados, { (cTRB)->CT_DOC,;           //Documento da meta
	 						 (cTRB)->CT_SEQUEN,;        //Sequencia do documeto da meta
	 						 (cTRB)->CT_GRUPO,;         //C�digo do grupo do produto
	 						 (cTRB)->BM_DESC,;          //Nome do grupo do produto
	 						 nValLiq,;                  //Valor liquido (venda-devolu��o)
	 						 (cTRB)->CT_VALOR,;         //Valor da meta
	 						 (nValLiq / (cTRB)->CT_VALOR)*100 })//% atingida da meta
	 						 
	 	aVendas := {}
	 	aDevol := {}
	 	
	 	nT_Fat += nValLiq
	 	nT_Meta += (cTRB)->CT_VALOR
	 	
		(cTRB)->( dbSkip() )
	End	
	
	AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
	nLin := Len( aDados )
	
	aDados[ nLin, 4 ] := 'RESULTADO FINAL'
	aDados[ nLin, 5 ] := nT_Fat
	aDados[ nLin, 6 ] := nT_Meta
	aDados[ nLin, 7 ] := (nT_Fat / nT_Meta)*100
	
	AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
	
	(cTRB)->(dbCloseArea())	
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A130Prod   | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Processar a apura��o por vis�o de produto.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130Prod()
	Local cSQL := ''
	Local cTRB := ''
	Local cCount := ''
	Local cKey := ''

	Local nLin := 0
	Local nCount := 0

	Local nValLiq := 0
	Local nT_Fat := 0
	Local nT_Meta := 0
	
	Local aVendas := {}
	Local aDevol := {}
	
	AAdd( aCab,{ 'DOC.META',;
	             'SEQ',;
	             'PRODUTO',;
	             'DESCRI��O DO PRODUTO',;
	             'VLR.FATURADO',;
	             'VALOR META',;
	             '% DA META' } )
	             
	cSQL := "SELECT CT_DOC, " + CRLF
	cSQL += "       CT_SEQUEN, " + CRLF
	cSQL += "       CT_PRODUTO, " + CRLF
	cSQL += "       B1_DESC, " + CRLF
	cSQL += "       CT_VALOR " + CRLF
	cSQL += "FROM   "+RetSqlName("SCT")+" SCT " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" SB1 " + CRLF
	cSQL += "               ON B1_FILIAL = "+ValToSql(xFilial("SB1"))+" " + CRLF
	cSQL += "                  AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND B1_COD = CT_PRODUTO " + CRLF
	cSQL += "                  AND B1_MSBLQL <> '1' " + CRLF
	cSQL += "WHERE  CT_FILIAL = "+ValToSql(xFilial("SCT"))+" " + CRLF
	cSQL += "       AND SCT.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND CT_DOC BETWEEN "+ValToSql(c130DocDe)+" AND "+ValToSql(c130DocAte)+" " + CRLF
	cSQL += "       AND CT_PRODUTO BETWEEN "+ValToSql(c130VisDe)+" AND "+ValToSql(c130VisAte)+" " + CRLF
	cSQL += "       AND CT_DATA BETWEEN "+ValToSql(d130MetDe)+" AND "+ValToSql(d130MetAte)+" " + CRLF
	cSQL += "ORDER  BY CT_PRODUTO " + CRLF

   If l130Query
		AutoGrLog( cSQL )
		MostraErro()   
   Endif
   
	cCount := " SELECT COUNT(*) nCOUNT FROM ( " + cSQL + " ) QUERY "
		
	If At("ORDER  BY", Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At("ORDER  BY",cCount)-1) + SubStr(cCount,RAt(")",cCount))
	Endif	
	
	cCount := ChangeQuery( cCount )
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cCount),"SQLCOUNT",.F.,.T.)
	nCount := SQLCOUNT->nCOUNT
	SQLCOUNT->( DbCloseArea() )

	If nCount == 0
		MsgInfo('N�o foi poss�vel encontrar registros com os par�metros informados.', cCadastro)
		Return(.F.)
	Endif
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	ProcRegua(nCount)
	
	AAdd( aDados, AClone( aCab[ 1 ] ) )

	While ! (cTRB)->( EOF() )
		IncProc()
		
		If cKey <> (cTRB)->( CT_DOC + CT_PRODUTO )
			cKey := (cTRB)->( CT_DOC + CT_PRODUTO )
			nT_Vlr := 0
		Endif
	
		//--------------------------------------
		// Chama a funcao de calculo das vendas.
		//--------------------------------------
		aVendas := FtNfVendas(4,;                    //Tipo de meta
										'',;    //C�digo do vendedor
										d130FatDe,;          //Emiss�o faturamento de
										d130FatAte,;         //Emiss�o faturamento at�
										'',;                 //Regi�o de vendas
										'',;                 //Tipo de produto
										'',;                 //Grupo de produto
										(cTRB)->CT_PRODUTO,; //C�digo do produto
										1,;                  //Moeda
										'',;                 //C�digo do cliente
										'',;                 //Loja do cliente
										c130Sellers,;        //Expressao a ser adicionada na Query
										,;                   //Determina se devem ser consideradas Notas fiscais (1) Remitos (2) ou ambos tipos de documento (3)
										"'S'",;              //Movimento que gera financeiro
										"'S','N'")           //Movimenta estoque
		
		//---------------------------------------------------
		// Chama a funcao de calculo das devolucoes de venda.
		//---------------------------------------------------
		If n130Devol == 1
			aDevol := FtNfDevol(4,;                   //Tipo de meta
										'',;                 //C�digo do vendedor   
										d130FatDe,;          //Emiss�o devolu��o de
										d130FatDe,;          //Emiss�o devolu��o ate
										'',;                 //Regi�o de devolu��o
										'',;                 //Tipo de produto
										'',;                 //Grupo de produto
										(cTRB)->CT_PRODUTO,; //C�digo do produto
										1,;                  //Moeda
										'',;                 //C�digo do cliente
										'',;                 //Loja do cliente
										,;                   //Determina se devem ser consideradas Notas fiscais (1) Remitos (2) ou ambos tipos de documento (3)
										"'S'",;              //Movimento que gera financeiro
										"'S','N'")           //Movimenta estoque
	 	Else
	 		AAdd( aDevol, 0 )
	 		AAdd( aDevol, 0 )
	 	Endif
	 		 	
	 	nValLiq := aVendas[ 1 ]-aDevol[ 1 ]
		
	 	AAdd( aDados, { (cTRB)->CT_DOC,;           //Documento da meta
	 						 (cTRB)->CT_SEQUEN,;        //Sequencia do documeto da meta
	 						 (cTRB)->CT_PRODUTO,;       //C�digo do produto
	 						 (cTRB)->B1_DESC,;          //Descri��o do produto
	 						 nValLiq,;                  //Valor liquido (venda-devolu��o)
	 						 (cTRB)->CT_VALOR,;         //Valor da meta
	 						 (nValLiq / (cTRB)->CT_VALOR)*100 })//% atingida da meta
	 						 
	 	aVendas := {}
	 	aDevol := {}
	 	
	 	nT_Fat += nValLiq
	 	nT_Meta += (cTRB)->CT_VALOR
	 	
		(cTRB)->( dbSkip() )
	End	
	
	AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
	nLin := Len( aDados )
	
	aDados[ nLin, 4 ] := 'RESULTADO FINAL'
	aDados[ nLin, 5 ] := nT_Fat
	aDados[ nLin, 6 ] := nT_Meta
	aDados[ nLin, 7 ] := (nT_Fat / nT_Meta)*100
	
	AAdd( aDados, Array( Len( aCab[ 1 ] ) ) )
	
	(cTRB)->(dbCloseArea())	
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A130UnLoad | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para descarregar informa��es em planilha eletr�nica.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130UnLoad()
	Local nI := 0
	Local nJ := 0
	Local nLin := 0
	
	Local cDado := ''
	
	Local aVendas := {}
	Local aDevol := {}
	Local aExcel := {}
	
	ProcRegua(Len(aDados))
	For nI := 1 To Len( aDados )
		IncProc()
		AAdd( aExcel, Array( Len( aCab[ 1 ] ) ) )
		nLin := Len( aExcel )
		
		For nJ := 1 To Len( aExcel[ 1 ] )
			If ValType(aDados[ nI, nJ ])=='C'
				cDado := Chr(160) + aDados[ nI, nJ ]
			Elseif ValType(aDados[ nI, nJ ])=='D'
				cDado := Chr(160) + Dtoc(aDados[ nI, nJ ])
			Elseif ValType(aDados[ nI, nJ ])=='N'
				cDado := LTrim(TransForm( aDados[ nI, nJ ], '@E 9,999,999.99' ))
			Else
				cDado := aDados[ nI, nJ ]
			Endif
			
			aExcel[ nLin, nJ ] := cDado
		Next nJ
	Next nI
	
	For nI := 1 To Len( aParam )
		AAdd( aExcel, Array( Len( aCab[ 1 ] ) ) )
		nLin := Len( aExcel )
		aExcel[ nLin, 1 ] := Iif(nI<>1,LTrim(Str(nI-1))+'� Par�metro - ','') + aParam[ nI ]
	Next nI
	
	MsgRun('Gerando planilha com os dados processados, aguarde...',cCadastro,{|| ;
	DlgToExcel( { { 'ARRAY', 'Metas de Vendas X Realizado - ' + c130Visao + Iif(n130Visao==1,Iif(n130Result==1,' (Sint�tico)',' (Anal�tico)'),''), {}, aExcel } } ) } )
	
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A130Sellers| Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/ montar a express�o espec�fica a ser passada.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130Sellers()
	Local cSQL := ''
	Local cTRB := ''
	
	cSQL := "SELECT A3_COD " + CRLF
	cSQL += "FROM   "+RetSqlName("SA3")+" SA3 " + CRLF
	cSQL += "WHERE  A3_FILIAL = "+ValToSql(xFilial("SA3"))+" " + CRLF
	cSQL += "       AND D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND A3_XCANAL = "+ValToSql(c130Canal)+" " + CRLF
	cSQL += "       AND A3_MSBLQL <> '1' " + CRLF
	cSQL += "ORDER BY A3_COD " + CRLF
	
   If l130Query
		AutoGrLog( cSQL )
		MostraErro()   
   Endif
   
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	PLSQuery( cSQL, cTRB )
   
   c130Sellers := "("
	While ! (cTRB)->( EOF() )
		c130Sellers += " SF2.F2_VEND1='"+ (cTRB)->A3_COD + "' OR"
		(cTRB)->( dbSkip() )
	End	
	(cTRB)->(dbCloseArea())	
	c130Sellers := SubStr(c130Sellers,1,Len(c130Selleras)-2) + ")"
Return

//-----------------------------------------------------------------------
// Rotina | A130Diver  | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Rotina busca produtos vendido no per�odo para o canal vendas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130Diver(nCount)
	Local cTRB := ''
	Local cSQL := ''
	Local cCount := ''
	
	nCount := 0
	
	cSQL := "SELECT SD2.D2_COD, " + CRLF
	cSQL += "       SB1.B1_DESC, " + CRLF
	cSQL += "       SUM(SD2.D2_QUANT) D2_QUANT, " + CRLF
	cSQL += "       SUM(SD2.D2_TOTAL) D2_TOTAL " + CRLF
	cSQL += "FROM   "+RetSqlName("SD2")+" SD2 " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SF2")+" SF2 " + CRLF
	cSQL += "               ON SF2.F2_FILIAL = "+ValToSql(xFilial("SF2"))+" " + CRLF
	cSQL += "                  AND SF2.F2_DOC = SD2.D2_DOC " + CRLF
	cSQL += "                  AND SF2.F2_SERIE = SD2.D2_SERIE " + CRLF
	cSQL += "                  AND SF2.F2_CLIENTE = SD2.D2_CLIENTE " + CRLF
	cSQL += "                  AND SF2.F2_LOJA = SD2.D2_LOJA " + CRLF
	cSQL += "                  AND "+c130Sellers+" " + CRLF
	cSQL += "                  AND SF2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" SB1 " + CRLF
	cSQL += "               ON SB1.B1_FILIAL = "+ValToSql(xFilial("SB1"))+" " + CRLF
	cSQL += "                  AND SB1.B1_COD = SD2.D2_COD " + CRLF
	cSQL += "                  AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  D2_FILIAL = "+ValToSql(xFilial("SD2"))+" " + CRLF
	cSQL += "       AND SD2.D2_EMISSAO BETWEEN "+ValToSql(d130FatDe)+" AND "+ValToSql(d130FatAte)+" " + CRLF
	cSQL += "       AND SD2.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "GROUP  BY SD2.D2_COD, SB1.B1_DESC " + CRLF
	cSQL += "ORDER  BY SD2.D2_COD " + CRLF

	cSQL := ChangeQuery( cSQL )

   //-----------------------------------------
   // Se ligado exportar a instru��o da query.
   //-----------------------------------------
   If l130Query
		AutoGrLog( cSQL )
		MostraErro()   
   Endif
	
	//-------------------------------------------------------------------------
	// Montagem da query para apurar a quantidade de registro a ser processado.
	//-------------------------------------------------------------------------
	cCount := " SELECT COUNT(*) nCOUNT FROM ( " + cSQL + " ) QUERY "		
	If At("GROUP BY", Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At("GROUP BY",cCount)-1) + SubStr(cCount,RAt(")",cCount))
	Endif
	If At("ORDER BY", Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At("ORDER BY",cCount)-1) + SubStr(cCount,RAt(")",cCount))
	Endif
	
	cCount := ChangeQuery( cCount )
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cCount),"SQLCOUNT",.F.,.T.)
	nCount := SQLCOUNT->nCOUNT
	SQLCOUNT->( DbCloseArea() )

	//--------------------------------------------------
	// Execu��o da instru��o da query no banco de dados.
	//--------------------------------------------------
	cTRB := GetNextAlias()
	PLSQuery( cSQL, cTRB )
Return( cTRB )

//-----------------------------------------------------------------------
// Rotina | A130CriaXB | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para verificar se existe SXB da tabela SCT.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130CriaXB()
	Local aSXB := {}
	Local aCpoXB := {}

	Local nI := 0
	Local nJ := 0
	
	aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}

	AAdd(aSXB,{"SCT   ","1","01","DB","Metas de Vendas","Metas de Vendas","Metas de Vendas","SCT",""})
	AAdd(aSXB,{"SCT   ","2","01","01","Documento + Sequenci","Documento + Secuenci","Document + Sequence","",""})
	AAdd(aSXB,{"SCT   ","2","02","02","Data","Fecha","Date","",""})
	AAdd(aSXB,{"SCT   ","4","01","01","Documento","Documento","Document","CT_DOC",""})
	AAdd(aSXB,{"SCT   ","4","01","02","Sequencia","Secuencia","Sequence","CT_SEQUEN",""})
	AAdd(aSXB,{"SCT   ","4","01","03","Data","Fecha","Date","CT_DATA",""})
	AAdd(aSXB,{"SCT   ","4","01","04","Descri��o","Descripcion","Description","CT_DESCRI",""})
	AAdd(aSXB,{"SCT   ","4","02","01","Data","Fecha","Date","CT_DATA",""})
	AAdd(aSXB,{"SCT   ","4","02","02","Documento","Documento","Document","CT_DOC",""})
	AAdd(aSXB,{"SCT   ","4","02","03","Sequencia","Secuencia","Sequence","CT_SEQUEN",""})
	AAdd(aSXB,{"SCT   ","4","02","04","Descri��o","Descripcion","Description","CT_DESCRI",""})
	AAdd(aSXB,{"SCT   ","5","01","","","","","SCT->CT_DOC",""})
	
	SXB->(dbSetOrder(1))
	For nI := 1 To Len( aSXB )
		If !SXB->(dbSeek(aSXB[nI,1]+aSXB[nI,2]+aSXB[nI,3]+aSXB[nI,4]))
			SXB->(RecLock('SXB',.T.))
			For nJ := 1 To Len( aSXB[nI] )
				SXB->(FieldPut(FieldPos(aCpoXB[nJ]),aSXB[nI,nJ]))
			Next nJ
			SXB->(MsUnLock())
		Endif
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | A130Report | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de prepara��o para imprimir usando TReport.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130Report( aCOLS, aHeader )
	Local oReport
	Local oSection 
	Local nLen := Len(aHeader[1])
	Local nX := 0
	Local nCol := 0
	Local nSize := Len( aSize )
	
	oReport := TReport():New( FunName(), ;
	                          cCadastro+ ' - Vis�o ' + c130Visao + Iif(n130Visao==1,Iif(n130Result==1,' (Sint�tico)',' (Anal�tico)'),''), , ;
	                          {|oReport| A130Impr( oReport, aCOLS )}, ;
	                          cDescriRel + ' - Vis�o ' + c130Visao + Iif(n130Visao==1,Iif(n130Result==1,' (Sint�tico)',' (Anal�tico)'),'') )
	           
	oReport:SetLandscape()
	
	DEFINE SECTION oSection OF oReport TITLE cCadastro TOTAL IN COLUMN
	
	For nX := 1 To nLen
		If nSize > 0
			If nX <= nSize
				nLargura := aSize[ nX ]
			Else
				nLargura := 20
			Endif
		Else
			nLargura := 20
		Endif
		DEFINE CELL NAME "CEL"+Alltrim(Str(nX-1)) OF oSection SIZE nLargura TITLE aHeader[1,nX]
	Next nX

	oSection:SetColSpace(2)
	oSection:nLinesBefore := 2
	oSection:SetLineBreak(.T.)
Return( oReport )

//-----------------------------------------------------------------------
// Rotina | A130Impr   | Autor | Robson Gon�alves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de impress�o das c�lulas TReport.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A130Impr( oReport, aCOLS )
	Local oSection := oReport:Section(1)
	Local nX := 0
	Local nY := 0

	oReport:SetMsgPrint('Aguarde, imprimindo...')
	oReport:SetMeter( Len( aCOLS ) )	
	oSection:Init()
	
	For nX := 1 To Len( aCOLS )
		If oReport:Cancel()
			Exit
		EndIf
		For nY := 1 To Len(aCOLS[ nX ])
		   If ValType( aCOLS[ nX, nY ] ) == 'D'
		   	oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + Dtoc(aCOLS[ nX, nY ]) + "'}") )
		   Elseif ValType( aCOLS[ nX, nY ] ) == 'N'
		   	oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + TransForm(aCOLS[ nX, nY ],'@E 9,999,999.99') + "'}") )
		   Elseif ValType( aCOLS[ nX, nY ] ) == 'C'
		   	aCOLS[ nX, nY ] := StrTran( aCOLS[ nX, nY ], "'", "" )
		   	oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + aCOLS[ nX, nY ] + "'}") )
		   Else
		   	oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || ' '}") )
		   Endif
		Next
		oReport:IncMeter()
		oSection:PrintLine()
	Next
	oSection:Finish()
Return