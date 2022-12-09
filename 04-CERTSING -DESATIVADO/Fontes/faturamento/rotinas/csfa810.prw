//--------------------------------------------------------------------------
// Rotina | CSFA810    | Autor | Robson Gonçalves        | Data | 27.03.2017
//--------------------------------------------------------------------------
// Descr. | Rotina para rastrear o processo que o PV gerou.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------

#Include 'Protheus.ch'

User Function CSFA810()
	Local oButton1
	Local oButton2
	Local oDlg
	Local oFont := TFont():New('Consolas',NIL,14,NIL,.T.,NIL,NIL,NIL,NIL,.F.,.F.)
	Local oPnl
	Local oPnlBot
	Local oTree
	
	Private cTitulo := '® System Tracker de Pedido de Vendas'
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 350,650 OF oDlg PIXEL
		oPnl := TPanel():New(0,0,,oDlg,,.T.,,,,1000,18,.F.,.F.)
		oPnl:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlBot:Align := CONTROL_ALIGN_BOTTOM

		@ 1,1  BUTTON oButton1 PROMPT 'Visualizar' SIZE 40,11 PIXEL OF oPnlBot ACTION (View( oTree:GetCargo() ))
		@ 1,44 BUTTON oButton2 PROMPT 'Sair'       SIZE 40,11 PIXEL OF oPnlBot ACTION (oDlg:End())
	
		// Estância a classe dbTree.
		oTree := dbTree():New(1,1,700,700,oPnl,,,.T.,,oFont)
		oTree:Align := CONTROL_ALIGN_ALLCLIENT
		oTree:lShowHint:= .F.
		
		// Monta tree na primeira vez.
		oTree:BeginUpdate()
		oTree:Reset()
		oTree:EndUpdate()
		
		MsAguarde( {|| LoadSC6( @oTree ) }, cTitulo,'Carregando dados, aguarde...', .F. )		
	ACTIVATE MSDIALOG oDlg CENTER
Return

//--------------------------------------------------------------------------
// Rotina | LoadSC6    | Autor | Robson Gonçalves        | Data | 27.03.2017
//--------------------------------------------------------------------------
// Descr. | Rotina para carregar dados do pedido de vendas.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function LoadSC6( oTree )
	Local aPoint := {'|','/','-','\'}
	
	Local cBmpSC5 := 'PMSEDT3'
	Local cCargo := ''
	Local cKey := ''
	Local cPrompt := ''
	
	Local lFirst := .T.
	
	Local nLoop := 0
	Local nPoint := 0
	Local nPosItem := GdFieldPos('C6_ITEM')
	
	SC6->( dbSetOrder( 1 ) )
	For nLoop := 1 To Len( aCOLS )		
		nPoint++
		
		If nPoint == 5
			nPoint := 1
		Endif
		
		MsProcTxt( 'Aguarde, processando ' + aPoint[ nPoint ] + ' '  )
		ProcessMessage()	

		If SC6->( dbSeek( xFilial( 'SC6' ) + M->C5_NUM + aCOLS[ nLoop, nPosItem ] ) )
			If lFirst 
				lFirst := .F.
				
				cPrompt   := Pad( 'Pedido de venda - ' + SC6->C6_NUM, 100 )
				cKey      := xFilial('SC5')+SC6->C6_NUM
				cCargo    := Pad( 'SC5#1#'+cKey, 100 )
			 	cCargoIni := cCargo
			 	
				oTree:AddTree( cPrompt, .T., cBmpSC5, cBmpSC5,,,cCargo)
				oTree:TreeSeek( cCargo )
				oTree:Refresh()
				
				LoadSF2( @oTree )
				oTree:EndTree()
			Endif
			
			cPrompt := Pad( 'Item pedido de venda - Número/Item - ' + SC6->C6_NUM + '/' + SC6->C6_ITEM, 100 )
			cKey    := xFilial('SC6')+SC6->( C6_NUM + C6_ITEM )
			cCargo  := Pad( 'SC6#1#'+cKey, 100 )
			
			oTree:AddTree( cPrompt, .F., cBmpSC5, cBmpSC5,,, cCargo )
			
			LoadSC9( @oTree )
			LoadSD2( @oTree )
			
			oTree:EndTree()
		Endif
	Next nLoop
	
	oTree:EndUpdate()
	
	oTree:TreeSeek( Pad( 'SC5#1#' + xFilial( 'SC6' ) + M->C5_NUM, 100 ) )
	oTree:Refresh()
Return

//--------------------------------------------------------------------------
// Rotina | LoadSF2    | Autor | Robson Gonçalves        | Data | 27.03.2017
//--------------------------------------------------------------------------
// Descr. | Rotina para carregar dados do documento fiscal de saída.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function LoadSF2( oTree )
	Local cBmpSF2 := 'PMSEDT4'
	Local cCargo := ''
	Local cKey := ''
	Local cPrompt := ''
	Local cSQL := ''
	Local cTRB := ''
		
	If .NOT. Empty( SC6->C6_LOJDED )
		cSQL := "SELECT D2_FILIAL, " 
		cSQL += "       D2_DOC, "
		cSQL += "       D2_SERIE, "
		cSQL += "       D2_CLIENTE, "
		cSQL += "       D2_LOJA, "
		cSQL += "       D2_PEDIDO "
		cSQL += "FROM   SD2010 D2 " 
		cSQL += "WHERE  D2_PEDIDO = "+ValToSql(SC6->C6_NUM)+" " 
		cSQL += "       AND D2.D_E_L_E_T_ = ' ' "
		cSQL += "GROUP  BY D2_FILIAL, "
		cSQL += "          D2_DOC, "
		cSQL += "          D2_SERIE, "
		cSQL += "          D2_CLIENTE, "
		cSQL += "          D2_LOJA, "
		cSQL += "          D2_PEDIDO "
		cSQL += "ORDER  BY D2_FILIAL, "
		cSQL += "          D2_DOC, "
		cSQL += "          D2_SERIE "
		
		cSQL := ChangeQuery( cSQL )
		cTRB := GetNextAlias()
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
		
		If (cTRB)->(.NOT. BOF() ) .AND. (cTRB)->(.NOT. EOF() )
			While (cTRB)->( .NOT. EOF() )
				cPrompt := Pad( 'Nota fiscal de saída - Filial/Documento/Série - ' + (cTRB)->D2_FILIAL + '/' + (cTRB)->D2_DOC + '/' + (cTRB)->D2_SERIE, 100 )
				cKey    := (cTRB)->( D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA )
				cCargo  := Pad( 'SD2#3#'+cKey, 100 )
				
				oTree:AddTree( cPrompt, .T., cBmpSF2, cBmpSF2,,, cCargo )
				oTree:TreeSeek( cCargo )
				oTree:Refresh()
				
				SD2->( dbSetOrder( 3 ) )
				SD2->( dbSeek( cKey ) )
				
				LoadSE1( @oTree )
				
				oTree:EndTree()
				
				(cTRB)->( dbSkip() )
			End
		Endif
		
		(cTRB)->( dbCloseArea() )
	Endif	
Return

//--------------------------------------------------------------------------
// Rotina | LoadSE1    | Autor | Robson Gonçalves        | Data | 27.03.2017
//--------------------------------------------------------------------------
// Descr. | Rotina para carregar dados do título a receber.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function LoadSE1( oTree )
	Local cAliasQry := GetNextAlias()
	Local cBmpSE1 := 'PMSEDT2'
	Local cKey := ''
	Local cPrefixo := ''
	Local cPrompt := ''
	Local cQuery := ''
	Local cTitulo := ''
	
	SF2->( dbSetOrder( 1 ) )
	SF2->( dbSeek( SD2->( D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA ) ) )
	 
	cPrefixo := Iif( Empty( SF2->F2_PREFIXO ), &( SuperGetMv( "MV_1DUPREF" ) ), SF2->F2_PREFIXO )
	 
	cQuery += "SELECT E1_FILIAL, "
	cQuery += "       E1_PREFIXO, "
	cQuery += "       E1_NUM, "
	cQuery += "       E1_PARCELA, "
	cQuery += "       E1_CLIENTE, "
	cQuery += "       E1_LOJA, "
	cQuery += "       E1_TIPO "
	cQuery += "FROM   " + RetSqlName( "SE1" ) + " "
	cQuery += "WHERE  E1_FILIAL = '" + xFilial( "SE1" ) + "' AND "
	cQuery += "       E1_NUM = '"    + SD2->D2_DOC      + "' AND "
	cQuery += "       E1_PREFIXO = '"+ cPrefixo         + "' AND "
	cQuery += "       E1_CLIENTE = '"+ SD2->D2_CLIENTE  + "' AND "
	cQuery += "       E1_LOJA = '"   + SD2->D2_LOJA     + "' AND "
	cQuery += "       D_E_L_E_T_ = ' ' "
	
	cQuery := ChangeQuery( cQuery )					
	
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. )
	dbSelectArea( cAliasQry )
	
	While .NOT. EOF()
		cTitulo := E1_CLIENTE + "/" + E1_LOJA + "/" + E1_PREFIXO + "/" + E1_NUM + "/" + E1_PARCELA + "/" + E1_TIPO
		cPrompt := Pad( 'Título - Cliente/Loja/Prefixo/Número/Parcela/Tipo - ' + cTitulo, 100 )
		cKey    := E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
		cCargo  := Pad( 'SE1#2#'+cKey, 100 )
		
		oTree:AddTreeItem( cPrompt, cBmpSE1,, cCargo )
		
		(cAliasQry )->( dbSkip() )
	End
	(cAliasQry )->( dbCloseArea() )
Return

//--------------------------------------------------------------------------
// Rotina | LoadSC9    | Autor | Robson Gonçalves        | Data | 27.03.2017
//--------------------------------------------------------------------------
// Descr. | Rotina para carregar dados da liberação do pedido de vendas.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function LoadSC9( oTree )
	Local cBmpSC9 := 'PMSEDT3'
	Local cCargo := ''
	Local cKey := ''
	
	SC9->( dbSetOrder( 1 ) )
	SC9->( dbSeek( SC6->( C6_LOJDED + C6_NUM + C6_ITEM ) ) )
	While SC9->( .NOT. EOF() ) ;
		.AND.SC9->C9_FILIAL == SC6->C6_LOJDED ;
		.AND.SC9->C9_PEDIDO == SC6->C6_NUM ;
		.AND.SC9->C9_ITEM == SC6->C6_ITEM ;
		.AND.SC9->C9_PRODUTO == SC6->C6_PRODUTO
	   
		cPrompt := Pad( 'Liberação - Filial/Item pedido/Sequência - ' + SC9->(C9_FILIAL + '/' + C9_ITEM + '/' + C9_SEQUEN), 100 )
		cKey    := SC9->( C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN ) 
		cCargo  := Pad( 'SC9#1#'+cKey, 100 )
		
		oTree:AddTreeItem( cPrompt, cBmpSC9,, cCargo )
		
		SC9->( dbSkip() )
	End
Return

//--------------------------------------------------------------------------
// Rotina | LoadSD2    | Autor | Robson Gonçalves        | Data | 27.03.2017
//--------------------------------------------------------------------------
// Descr. | Rotina para carregar dados do item do documento fiscal de venda.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function LoadSD2( oTree )
	Local cBmpSD2 := 'PMSEDT4'
	Local cCargo := ''
	Local cKey := ''
	Local cPrompt := ''
	
	If .NOT. Empty( SC6->C6_LOJDED )
		SD2->( dbSetOrder( 8 ) )
		If SD2->( dbSeek( SC6->( C6_LOJDED + C6_NUM + C6_ITEM ) ) )
			While SD2->( .NOT. EOF() ) .AND. SD2->D2_FILIAL == SC6->C6_LOJDED .AND. SD2->D2_PEDIDO == SC6->C6_NUM .AND. SD2->D2_ITEMPV == SC6->C6_ITEM
				cPrompt := Pad( 'Item nota fiscal - Filial/Documento/Série/Item - ' + SD2->D2_FILIAL + '/' + SD2->D2_DOC + '/' + SD2->D2_SERIE + '/' + SD2->D2_ITEM, 100 )
				cKey    := SD2->( D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA )
				cCargo  := Pad( 'SD2#3#'+cKey, 100 )
				
				oTree:AddTreeItem( cPrompt, cBmpSD2,, cCargo )
				
				SD2->( dbSkip() )
			End
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | View       | Autor | Robson Gonçalves        | Data | 27.03.2017
//--------------------------------------------------------------------------
// Descr. | Rotina para visualizar dados conforme necessidade do usuário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function View( cCargo )
	Local aArea := {}
	Local aRotBack := {}
	
	Local cCadBack := ''
	Local cFilBack := ''
	Local cFil := ''
	Local cKey := ''
	Local cTab := ''
	Local nInd := ''
	
	Local nBack := 0
	
	cTab := SubStr( cCargo, 1, 3 )
	nInd := Val( SubStr( cCargo, 5, 1 ) )
	cKey := RTrim( SubStr( cCargo, 7 ) )
	
	(cTab)->( dbSetOrder( nInd ) )
	If (cTab)->( dbSeek( cKey ) )
		aArea := GetArea()
		
		If Type( "N" ) == "N"
			nBack := N
			N := 1
		Endif		
	
		If Type( "aRotina" ) == "A"
			aRotBack := AClone( aRotina )
		Endif
	
		If Type( "cCadastro" ) == "C"
			cCadBack := cCadastro
		Endif
		
		cFil := SubStr( cKey, 1, Len( SC5->C5_FILIAL ) )
		
		If .NOT. Empty( cFil )
			If cFil <> cFilAnt
				cFilBack := cFilAnt
				cFilAnt  := cFil
			Endif
		Endif
		
		Do Case
			Case cTab $ "SC5|SC6"				

				cCadastro := "Atualização de Pedidos de Venda"
				aRotina := { {  "Visualizar","A410Visual", 0, 2 } }
				A410Visual("SC5", SC5->( Recno() ), 1 )

			Case cTab == "SC9"
				
				cCadastro := "Liberação de Pedidos de Venda"
				AxVisual( "SC9", SC9->( Recno() ), 1 )

			Case cTab == "SD2"
				
				cCadastro := "Documento Fiscal de Saída"
				aRotina := {{ "", "AxPesqui", 2 },{ "" ,"A920NFSAI", 0, 2}}
				A920NFSAI( "SD2", SD2->( Recno() ), 2 )

			Case cTab == "SE1"
				
				cCadastro := "Título a Receber"
				FINA040(NIL,2) 

		EndCase
	
		If Len( aRotBack ) > 0
			aRotina := AClone( aRotBack )
		Endif
		
		If cCadBack <> ''
			cCadastro := cCadBack
		Endif
	
		If nBack  > 0
			N := nBack
		Endif
		
		If cFilBack <> ''
			cFilAnt := cFilBack
		Endif
		
		RestArea( aArea )
	Else
		MsgAlert('Informação não localizada.', cTitulo )
	Endif	
Return
*
//--------------------------------------------------------------------------
// Rotina | Cursor810  | Autor | Robson Gonçalves        | Data | 27.03.2017
//--------------------------------------------------------------------------
// Descr. | Rotina para atualizar o campo do C6_LOJDED.    
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function Cursor810()
	Local cMsg := ''
	Local cSQL := ''
	
	If .NOT. MsgYesNo('Confirma a execução do Cursor para atualizar o C6_LOJDED?')
		MsgInfo('Rotina abandonada.')
		Return
	Endif

	cSQL := "DECLARE "
	cSQL += "	CURSOR my_cursor IS"
	cSQL += "		SELECT C6.R_E_C_N_O_,"
	cSQL += "		       D2.D2_FILIAL"
	cSQL += "		FROM   SC6010 C6"
	cSQL += "		       INNER JOIN SD2010 D2"
	cSQL += "		               ON D2_FILIAL >= '01'"
	cSQL += "		                  AND D2_FILIAL <= '02'"
	cSQL += "		                  AND D2_PEDIDO = C6_NUM"
	cSQL += "		                  AND D2_ITEMPV = C6_ITEM"
	cSQL += "		                  AND D2_COD = C6_PRODUTO"
	cSQL += "		                  AND D2.D_E_L_E_T_ = ' '  "
	cSQL += "		WHERE  C6_FILIAL = '  '"
	cSQL += "		       AND C6_LOJDED = '  '"
	cSQL += "		       AND C6.D_E_L_E_T_ = ' ';"
	cSQL += "BEGIN"
	cSQL += "	FOR my_loop IN my_cursor LOOP"
	cSQL += "		UPDATE SC6010 SC6"
	cSQL += "		   SET C6_LOJDED = my_loop.D2_FILIAL"
	cSQL += "		 WHERE SC6.R_E_C_N_O_ = my_loop.R_E_C_N_O_;"
	cSQL += "		 COMMIT;  "
	cSQL += "	END LOOP; "
	cSQL += "END;"

	If TCSQLExec( cSQL ) < 0
		cMsg := "ROTINA CURSOR810 - TCSQLError() " + TCSQLError()
		CONOUT(cMsg)
		MsgAlert(cMsg)
	Else
		cMsg := "ROTINA CURSOR810 EXECUTADA COM SUCESSO - DATA " + Dtoc( MsDate() ) + "HORA " + Time() 
		CONOUT(cMsg)
		MsgAlert(cMsg)
	Endif
Return