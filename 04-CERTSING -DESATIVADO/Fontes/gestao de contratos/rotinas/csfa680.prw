#include 'totvs.ch'
#include 'protheus.ch'

#DEFINE MRK   'NGCHECKOK.PNG'
#DEFINE NOMRK 'NGCHECKNO.PNG'

#DEFINE cFONT   '<b><font size="4" color="red"><b><u>'
#DEFINE cNOFONT '</b></font></u></b> '

Static __nExec := 0
//-----------------------------------------------------------------------
// Rotina | CSFA680  | Autor | Robson Gonçalves    | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para gerar pedido de venda baseado em
//        | medições de contratos
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSFA680()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	Private cTitulo := 'Gerar P.V. Medição de Contratos'
	Private lShowQry := .F.
	
	AAdd( aSay, 'Rotina para gerar pedido de venda baseado em medições de contratos. O contrato precisa' )
	AAdd( aSay, 'estar aprovado e vigente. A medição do contrato precisa estar aprovada (encerrada).' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	//SetKey( VK_F12 , {|| lShowQry := MsgYesNo('Exportar a consulta SQL na pasta C:/TEMP?',cTitulo ) } )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpcao == 1
		A680Contr()
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A680Contr  | Autor | Robson Gonçalves    | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Monta a MBrowse para seleção do contrato
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680Contr()
	Local cFilSQL := ''
	Private aRotina := {}
	Private cCadastro := 'Selecione o contrato'
	
	AAdd( aRotina, { 'Pesquisar', 'AxPesqui()'  , 0, 1, 0, .F. } )
	AAdd( aRotina, { 'Visualizar','U_A680Visual', 0, 2, 0, NIL } )
	AAdd( aRotina, { 'Selecionar','U_A680Select', 0, 4, 0, NIL } )
	
	cFilSQL := "CN9_FILIAL = '"+xFilial("CN9")+"' "
	//Renato Ruy - 07/11/2017
	//Os campos não estão preenchidos no Protheus 12
	//cFilSQL += "AND CN9_CLIENT <> '"+Space(Len(SA1->A1_COD))+"' "
	//cFilSQL += "AND CN9_LOJACL <> '"+Space(Len(SA1->A1_LOJA))+"' "
	cFilSQL += "AND (Select Max(CN1_ESPCTR) from CN1010 Where CN1_FILIAL = '"+xFilial("CN1")+"' AND CN1_CODIGO = CN9_TPCTO AND D_E_l_e_t_ = ' ') = '2'
	cFilSQL += "AND CN9_SITUAC = '05' "                            // 05=Vigente
	//cFilSQL += "AND (CN9_OKAY = '0' OR CN9_OKAY = '2')"  // 0=Legado; 2=Aprovado
	
	SetKey( VK_F12 , {|| lShowQry := MsgYesNo('Exportar a consulta SQL na pasta C:/TEMP?',cTitulo ) } )
	
	MBrowse(,,,,'CN9',,,,,,/*aCores*/,,,,,,,,cFilSQL)
	
Return
//-----------------------------------------------------------------------
// Rotina | A680Visual | Autor | Robson Gonçalves    | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar as informações do contrato
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A680Visual( cAlias, nRecNo, nOpcX )
	CN100Manut( cAlias, nRecNo, nOpcX, .T. )
Return
//-----------------------------------------------------------------------
// Rotina | A680Select | Autor | Robson Gonçalves    | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Monta a Dialog com as medições para faturar
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A680Select( cAlias, nRecNo, nOpcX )
	Local cSQL := ''
	Local cTRB := ''
	Local cDataINI := ''
	Local cMvParQry := 'MV_680QRY'
	Local oDlg
	Local oPanel
	Local nI := 0
	Local nCol := 0
	Local nRow := 0
	Local oPesq
	Local oGera
	Local oSair
	Local oBar 
	Local oThb1, Thb2, Thb3, Thb4
	Local bPesq, bGera, bSair, bResumo 
	Local aCPO := {}
	Local cBkp := ''
	Local nCPO := 0
	Local nElem := 0
	Local oFnt := TFont():New('Arial',,,,.F.,,,8,.T.,,,,,,,)
	
	Private oGride 
	Private aLOG  := {}
	Private aCOLS := {}
	Private aHeader := {}
	Private lCSFA680 := .F.
	
	If .NOT. SX6->( ExisteSX6( cMvParQry ) )
		CriarSX6( cMvParQry, 'C', 'Data de corte de medição. CSFA680.prw', '20160710' )
	Endif
	
	cDataINI := GetMv( cMvParQry )
		
	If nRecNo <> CN9->( RecNo() )
		CN9->( dbGoTo( nRecNo ) )
	Endif
	
	aCPO := { 'CND_CONTRA','CND_REVISA','CND_NUMMED','CND_NUMERO','CND_COMPET','CND_DTINIC','CND_DTVENC','CND_DTFIM','CNE_ITEM','CNE_PRODUT','B1_DESC',;
	          'CNE_VLUNIT','CNE_QUANT','CNE_QTFAT','CNE_QTJENT'} //,'CNE_QTDSOL','CNE_QTAMED','CNE_PERC','CNE_VLUNIT','CNE_VLTOT' }

	AAdd( aHeader, { '  x','GD_MARK', '@BMP', 1, 0, '', '', '', '', ''} )

	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCPO )
		IF SX3->( dbSeek( aCPO[ nI ] ) )
			SX3->( AAdd( aHeader,{ X3_TITULO, X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT } ) )
		Else
			Alert( aCPO[nI] )
		EndIF
	Next nI
	
	AAdd( aHeader,{ 'Saldo Atual', 'CNE_SALDO', '@E 99,999,999.999999999', 18, 9, '', '€€€€€€€€€€€€€€', 'N', '', 'R' } )
	
	cSQL := "SELECT CND_CONTRA, " + CRLF
	cSQL += "       CND_REVISA, " + CRLF
	cSQL += "       CND_NUMMED, " + CRLF
	cSQL += "       CND_NUMERO, " + CRLF
	cSQL += "       CND_COMPET, " + CRLF
	cSQL += "       CND_DTINIC, " + CRLF
	cSQL += "       CND_DTVENC, " + CRLF
	cSQL += "       CND_DTFIM, "  + CRLF
	cSQL += "       CNE_ITEM, "   + CRLF
	cSQL += "       CNE_PRODUT, " + CRLF
	cSQL += "       B1_DESC, "    + CRLF
	cSQL += "       CNE_QUANT, "  + CRLF
	cSQL += "       CNE_QTFAT, "  + CRLF
	cSQL += "       CNE_QTJENT, " + CRLF
	cSQL += "       CNE_QTDSOL, " + CRLF
	cSQL += "       CNE_QTAMED, " + CRLF
	cSQL += "       CNE_PERC, "   + CRLF
	cSQL += "       CNE_VLUNIT, " + CRLF
	cSQL += "       CNE_VLTOT, "  + CRLF
	cSQL += "       CNE_QUANT - CNE_QTJENT AS CNE_SALDO " + CRLF
	cSQL += "FROM   "+RetSqlName("CND")+" CND "                            + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("CNE")+" CNE "                 + CRLF
	cSQL += "               ON CNE_FILIAL = "+ValToSql(xFilial("CNE"))+" " + CRLF
	cSQL += "              AND CNE_CONTRA = CND_CONTRA "                   + CRLF
	cSQL += "              AND CNE_REVISA = CND_REVISA "                   + CRLF
	cSQL += "              AND CNE_NUMERO = CND_NUMERO "                   + CRLF
	cSQL += "              AND CNE_NUMMED = CND_NUMMED "                   + CRLF
	cSQL += "              AND CNE.D_E_L_E_T_ = ' ' "                      + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SB1")+" SB1 "                 + CRLF
	cSQL += "               ON B1_FILIAL = "+ValToSql(xFilial("SB1"))+" "  + CRLF
	cSQL += "              AND B1_COD = CNE_PRODUT "                       + CRLF
	cSQL += "              AND SB1.D_E_L_E_T_ = ' ' "                      + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("CNA")+" CNA "                 + CRLF
	cSQL += "               ON CNA_FILIAL = "+ValToSql(xFilial("CNA"))+" " + CRLF
	cSQL += "             AND cna_contra = cnd_contra "                    + CRLF
	cSQL += "             AND cna_revisa = cnd_revisa "                    + CRLF
	cSQL += "             AND cna_numero = cnd_numero "                    + CRLF
	cSQL += "             AND CNA.d_e_l_e_t_ = ' ' "                       + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("CNL")+" CNL "                 + CRLF
	cSQL += "               ON CNL_FILIAL = "+ValToSql(xFilial("CNL"))+" " + CRLF
	cSQL += "             AND cnl_codigo = cna_tippla "                    + CRLF
	cSQL += "            AND CNL.d_e_l_e_t_ = ' ' "                        + CRLF
	cSQL += "WHERE  CND_FILIAL = "+ValToSql(xFilial("CND"))+" "            + CRLF
	cSQL += "       AND CND_CONTRA = "+ValToSQL(CN9->CN9_NUMERO)+" "       + CRLF
	cSQL += "       AND CND_CLIENT <> ' ' "                                + CRLF
	cSQL += "       AND CND_LOJACL <> ' ' "                                + CRLF
	cSQL += "       AND CND_DTFIM <> ' ' "                                 + CRLF
	IF .NOT. Empty( cDataINI )
	  cSQL += "       AND CND_DTINIC >= '" + cDataINI + "' "               + CRLF
	EndIF
	cSQL += "       AND CND.D_E_L_E_T_ = ' ' "                             + CRLF
	cSQL += "ORDER  BY CND_FILIAL, CND_CONTRA, CND_REVISA, CND_NUMERO, CND_NUMMED, CNE_ITEM "
	
	IF lShowQry
		MemoWrite("C:\TEMP\CSFA680.SQL",cSQL)
	EndIF
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
		
	nCPO := Len( aHeader )
	
	While .NOT. (cTRB)->( EOF() )
		IF 	(cTRB)->CNE_SALDO > 0
			AAdd( aCOLS, Array( nCPO + 1 ) )
			nElem := Len( aCOLS )
			For nI := 1 To nCPO
				If nI == 1
					aCOLS[ nElem, nI ] := NOMRK
				Else
					cCpo := cTRB+'->'+RTrim( aHeader[ nI, 2 ] )
					aCOLS[ nElem, nI ] := &(cCpo)
				Endif
			Next nI
			aCOLS[ nElem, nCPO+1 ] := .F.
		EndIF 
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
	
	If Len( aCOLS ) > 0
		lCSFA680 := .T.
		
		cBkp := cCadastro
		cCadastro := 'Selecione a medição para faturar'
		
		oMainWnd:ReadClientCoors()
		nCol := oMainWnd:nClientWidth
		nRow := oMainWnd:nClientHeight
		
		DEFINE MSDIALOG oDlg TITLE cCadastro FROM 00,00 TO nRow-34,nCol-8 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
			oDlg:lMaximized := .T.
			
			oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,13,.F.,.T.)
			oPanel:Align := CONTROL_ALIGN_BOTTOM
			
			oBar := TBar():New( oPanel, 10, 9, .T.,'BOTTOM')
			
			bPesq := {|| GdSeek( oGride, 'Pesquisar títulos', aHeader, aCOLS ) }
			
			bGera := {|| Iif( AScan( oGride:aCOLS, {|p| p[ 1 ]==MRK} ) > 0, ;
			             Iif( A680TudOK( oGride ), FwMsgRun(,{|| A680GeraPV( oGride ), oDlg:End() },cTitulo,'Aguarde, gerando pedido de vendas...'), NIL ),;
			             MsgAlert( cFONT+'ATENÇÃO'+cNOFONT+'<br>Não há medição selecionada para gerar pedido de vendas.' , cCadastro ) ) }
			
			bResumo := {|| Iif( AScan( oGride:aCOLS, {|p| p[ 1 ]==MRK} ) > 0, ;
			             Iif( A680TudOK( oGride ), FwMsgRun(,{|| A680Resumo( oGride ) },cTitulo,'Aguarde, gerando resumo de vendas...'), NIL ),;
			             MsgAlert( cFONT+'ATENÇÃO'+cNOFONT+'<br>Não há medição selecionada para gerar pedido de vendas.' , cCadastro ) ) }             
			             
			bSair := {|| Iif(MsgYesNo('Deseja realmente sair da rotina?',cCadastro),oDlg:End(),NIL)}
			
			oThb3 := THButton():New( 1, 1, '&Sair'                 , oBar, bSair  , 20, 12, oFnt ) ; oThb3:Align := CONTROL_ALIGN_RIGHT
			oThb2 := THButton():New( 1, 1, '&Gerar pedido de venda', oBar, bGera  , 70, 12, oFnt ) ; oThb2:Align := CONTROL_ALIGN_RIGHT
			oThb2 := THButton():New( 1, 1, '&Resumo'               , oBar, bResumo, 70, 12, oFnt ) ; oThb2:Align := CONTROL_ALIGN_RIGHT
			oThb1 := THButton():New( 1, 1, '&Pesquisar'            , oBar, bPesq  , 35, 12, oFnt ) ; oThb1:Align := CONTROL_ALIGN_RIGHT

			oGride := MsNewGetDados():New(1,1,1000,1000,GD_INSERT+GD_DELETE+GD_UPDATE,,,,{'CNE_QTFAT'},0,Len(aCOLS),,,,oDlg,aHeader,aCOLS)
			oGride:oBrowse:bHeaderClick := {|| A680MrkAll( @oGride )}
			oGride:oBrowse:bLDblClick := {|| Iif( oGride:oBrowse:nColPos == 1, A680Mark( @oGride ), oGride:EditCell() ), A680Qtde( @oGride ) }
			oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
			oGride:oBrowse:SetFocus()
			
		ACTIVATE MSDIALOG oDlg CENTERED
		cCadastro := cBkp
	
	Else
		MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br>Não foi localizado medição para o contrato: '+cFONT+CN9->CN9_NUMERO+cNOFONT,'Medição não localizada')
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A680Mark   | Autor | Robson Gonçalves    | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Funcao para marcar a medição a ser faturada
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680Mark( oGride )
	If oGride:aCOLS[ oGride:nAt, 1 ] == MRK
		oGride:aCOLS[ oGride:nAt, 1 ] := NOMRK
		If oGride:aCOLS[ oGride:nAt, GdFieldPos('CNE_QTFAT') ] > 0
			oGride:aCOLS[ oGride:nAt, GdFieldPos('CNE_QTFAT') ] := 0
		Endif		
	Else
		oGride:aCOLS[ oGride:nAt, 1 ] := MRK
	Endif	
Return
//-----------------------------------------------------------------------
// Rotina | A680VLQF   | Autor | Robson Gonçalves    | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Função para validar se há saldo na medição
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A680VLQF()
	Local lRet := .T.
	Local nCNE_QUANT  := GdFieldPos('CNE_QUANT')
	Local nCNE_QTJENT := GdFieldPos('CNE_QTJENT')
	Local nCNE_SALDO  := GdFieldPos('CNE_SALDO')
	// A quantidade informada deve contemplar o quantidade disponível.
	If M->CNE_QTFAT > ( oGride:aCOLS[ oGride:nAt, nCNE_QUANT ] - oGride:aCOLS[ oGride:nAt, nCNE_QTJENT ] )
		MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br>Não há saldo suficiente para faturar este item.','Valida quantidade')
		lRet := .F.
	Else
		If M->CNE_QTFAT > 0
			If oGride:aCOLS[ oGride:nAt, 1 ] == NOMRK
				oGride:aCOLS[ oGride:nAt, 1 ] := MRK
			Endif
		Else
			If oGride:aCOLS[ oGride:nAt, 1 ] == MRK
				oGride:aCOLS[ oGride:nAt, 1 ] := NOMRK
			Endif
		Endif
	Endif
	oGride:Refresh()
Return(lRet)
//-----------------------------------------------------------------------
// Rotina | A680MrkAll  | Autor | Robson Gonçalves    | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Função para validar se há saldo na medição em todos os itens
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680MrkAll( oGride )
	Local lMrk := .T. 
	Local nCNE_QTFAT := 0
	Local nCNE_QUANT := 0
	Local nCNE_QTJENT := 0
	__nExec++
	If (__nExec%2) <> 0
		nCNE_QUANT := GdFieldPos('CNE_QUANT')
		nCNE_QTFAT := GdFieldPos( 'CNE_QTFAT' )
		nCNE_QTJENT := GdFieldPos('CNE_QTJENT')
		lMrk := ( AScan( oGride:aCOLS, {|e| e[ 1 ] == MRK } ) > 0 )
		For nI := 1 To Len( oGride:aCOLS )
			If lMrk 
				oGride:aCOLS[ nI, 1 ] := NOMRK
				oGride:aCOLS[ nI, nCNE_QTFAT ] := 0
			Else
				If oGride:aCOLS[ oGride:nAt, nCNE_QTFAT] <= (oGride:aCOLS[ oGride:nAt, nCNE_QUANT ] - oGride:aCOLS[ oGride:nAt, nCNE_QTJENT ])
					oGride:aCOLS[ nI, 1 ] := MRK
				Endif
			Endif
		Next nI
		oGride:Refresh()
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A680TudOK  | Autor | Robson Gonçalves    | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Valida todos os itens selecionados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680TudOK( oGride )
	Local nI := 0
	Local nOK := 0
	Local nMRK := 0
	Local nQTFat := 0
	Local lRet := .T.
	Local cMsg := ''
	Local nCNE_QTFAT := GdFieldPos( 'CNE_QTFAT' )
	
	For nI := 1 To Len( oGride:aCOLS )
		// Se está marcado, precisa ter quantidade.
		If oGride:aCOLS[ nI, 1 ] == MRK .AND. oGride:aCOLS[ nI, nCNE_QTFAT ] > 0
			nOK++
		Else
			// Se está marcado e não tem quantidade, está errado.
			If oGride:aCOLS[ nI, 1 ] == MRK .AND. oGride:aCOLS[ nI, nCNE_QTFAT ] == 0
				nMRK++
			Endif
			// Se não está marcado e tem quantidade, está errado.
			If oGride:aCOLS[ nI, 1 ] == NOMRK .AND. oGride:aCOLS[ nI, nCNE_QTFAT ] > 0
				nQTFat++
			Endif
		Endif
	Next nI
	
	If nMRK > 0
		cMsg := cFONT+'ATENÇÃO'+cNOFONT+'<br>Foi selecionado item(ns), porém não foi informado quantidade.'
	Endif
	
	If nQTFat > 0
		If .NOT. Empty( cMsg )
			cMsg := cMsg + '<br><br>'
		Endif
		cMsg += cFONT+'ATENÇÃO'+cNOFONT+'<br>Foi informado quantidade(s), porém não foi marcado o item.'
	Endif
	
	If .NOT. Empty( cMsg )
		lRet := .F.
		MsgAlert( cMsg, 'Validação para continuar' )
	Endif
Return( lRet )
//-----------------------------------------------------------------------
// Rotina | A680GeraPV  | Autor | Rafael Beghini   | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Gera o pedido de venda conforme a medição selecionada.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680GeraPV( oGride )
	
	Local cNumMed   := ''
	Local cPEDIDO   := ''
	Local nX        := 0
	Local nY        := 0
	Local nLin      := 0
	Local nPos      := 0
	Local nSaldo    := 0
	Local aItem     := {}
	Local aVend     := {}
	Local aNUMMED   := {}
	Local aLOGErro  := {}
	
	Local lCabec := .F.
	Local lItem  := .F.
	
	Private nCND_CONTRA  := GdFieldPos('CND_CONTRA')
	Private nCND_REVISA  := GdFieldPos('CND_REVISA')
	Private nCND_NUMERO  := GdFieldPos('CND_NUMERO')
	Private nCND_NUMMED  := GdFieldPos('CND_NUMMED')
	Private nCNE_ITEM    := GdFieldPos('CNE_ITEM')
	Private nCNE_PRODUT  := GdFieldPos('CNE_PRODUT')
	Private nB1_DESC     := GdFieldPos('B1_DESC')
	Private nCNE_QTJENT  := GdFieldPos('CNE_QTJENT')
	Private nCNE_QTFAT   := GdFieldPos('CNE_QTFAT')
	Private nCNE_VLUNIT  := GdFieldPos('CNE_VLUNIT')
	Private nCNE_VLTOT   := GdFieldPos('CNE_VLTOT')
	
	Private lMsErroAuto    := .F.
	Private lMsHelpAuto    := .T.
	Private lAutoErrNoFile := .T.
	
	Private aCabec    := {}
	
	CNE->( dbSetOrder(1) )
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	For nY := 1 To Len( oGride:aCOLS )
		if oGride:aCOLS[ nY, 1 ] == MRK .and. oGride:aCOLS[ nY, 15 ] > 0 .And. (ascan( aNUMMED, {|e| e == oGride:aCOLS[nY,4]})==0 )
			aAdd( aNUMMED, oGride:aCOLS[ nY,4 ] )	
		endif	
	Next nY
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	For nLin := 1 To Len( aNUMMED )
		cNumMed := aNUMMED[nLin]
		
		lCabec := A680Cabec( oGride, cNumMed, @aCabec, @cPEDIDO, @aVend )
		lItem  := A680Item ( oGride, cNumMed, @aItem,  @cPEDIDO, @aVend )
		
		IF lCabec .And. lItem
			lMsErroAuto := .F.    	
			lCopy       := .F.	
			aLOGErro    := {}
			
			MSExecAuto({|x,y,z,w| Mata410(x,y,z,,,,,w)},aCabec,aItem,3)
			aCabec := {}
			aItem  := {}
			
			If lMsErroAuto
				RollBAckSx8()
				aLOGErro := GetAutoGRLog()	 //função que retorna as informações de erro ocorridos durante o processo da rotina automática
				A680Log( cNumMed, @aLOGErro )
			Else
				nPos := AScan( oGride:aCOLS, {|X| X[4] == cNumMed .And. X[1] == MRK } )
				For nX := nPos To Len( oGride:aCOLS ) 
					IF .NOT. ( cNumMed == oGride:aCOLS[ nX, nCND_NUMMED ] )
						Exit
					EndIF
					CNE->( dbSeek( xFilial("CNE") + oGride:aCOLS[ nX, nCND_CONTRA ] + oGride:aCOLS[ nX, nCND_REVISA ] + oGride:aCOLS[ nX, nCND_NUMERO ] + oGride:aCOLS[ nX, nCND_NUMMED ] + oGride:aCOLS[ nX, nCNE_ITEM ] ) )
						nSaldo  := CNE->CNE_QTJENT
						
						CNE->( RecLock( 'CNE', .F. ) )
						CNE->CNE_QTJENT := nSaldo + oGride:aCOLS[ nX, nCNE_QTFAT ]
						CNE->CNE_PEDIDO := cPEDIDO
						CNE->( MsUnLock() )
						nSaldo := 0
				Next nX
				
				aAdd( aLOG, { cNumMed, cPEDIDO } )
				
				SC5->( dbSetOrder(1) )
				SC5->( dbSeek( xFilial('SC5') + SC5->C5_NUM ) )
				IF Empty( SC5->C5_MDCONTR )
					SC5->( RecLock('SC5',.F.) )
					SC5->C5_MDCONTR := oGride:aCOLS[ nX, nCND_CONTRA ]
					SC5->( MsUnlock() )
				EndIF
			EndIF
		EndIF
	Next nLIn

	IF .NOT. Empty( aLOG )
		MsgInfo('Processo executado, verifique os pedidos gerados.', 'Gerar P.V. Medição de Contratos')
		A680ShowLg( aLOG )
		A680SendMail( CN9->CN9_NUMERO, rTrim(CN9->CN9_DESCRI), aLOG )
	EndIF		
Return
//-----------------------------------------------------------------------
// Rotina | A680Cabec  | Autor | Robson Gonçalves    | Data | 06.04.2016
//-----------------------------------------------------------------------
// Descr. | Resumo das informações a serem faturadas
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680Cabec( oGride, cNumMed, aCabec, cPEDIDO, aVend )
	Local nI        := 0
	Local nX        := 0
	Local nPos      := 0
	Local nTaxa     := 1
	Local nParcelas := SuperGetMv("MV_NUMPARC")
	Local cNATUREZA := SuperGetMv("MV_XNATCLI")
	Local cVend     := '1'
	Local cParcela  := "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0"
	Local lRet      := .F.
		
	Local nCND_CONTRA  := GdFieldPos('CND_CONTRA')
	Local nCND_REVISA  := GdFieldPos('CND_REVISA')
	Local nCND_NUMERO  := GdFieldPos('CND_NUMERO')
	Local nCND_NUMMED  := GdFieldPos('CND_NUMMED')
	Local nCNE_ITEM    := GdFieldPos('CNE_ITEM')
	Local nCNE_QTFAT   := GdFieldPos('CNE_QTFAT')
	
	//Local MRK   := 'NGCHECKOK.PNG'
	//Local NOMRK := 'NGCHECKNO.PNG'
	
	CNE->( dbSetOrder(1) )
	CNE->( dbGotop() )
	nPos := AScan( oGride:aCOLS, {|X| X[4] == cNumMed .And. X[1] == MRK } )
	IF oGride:aCOLS[ nPos, 1 ] == MRK .AND. oGride:aCOLS[ nPos, nCNE_QTFAT ] > 0
		IF CNE->( dbSeek( xFilial("CNE") + oGride:aCOLS[ nPos, nCND_CONTRA ] + oGride:aCOLS[ nPos, nCND_REVISA ] + oGride:aCOLS[ nPos, nCND_NUMERO ] + oGride:aCOLS[ nPos, nCND_NUMMED ] + oGride:aCOLS[ nPos, nCNE_ITEM ] ) )
			//Carrega vendedores do contrato
			aVend := CtaVend(oGride:aCOLS[ nPos, nCND_CONTRA ])
			
			//Gera numero do pedido de venda
			cPEDIDO := GetSXENum("SC5","C5_NUM")
			
			ConfirmSX8()
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gera pedido de venda                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aCabec:={	{"C5_NUM"    , cPEDIDO        , Nil},; // Numero do pedido
						{"C5_TIPO"   , "N"            , Nil},; // Tipo de pedido
						{"C5_XORIGPV", "6"            , Nil},; // Origem do Pedido 6-Contratos
						{"C5_CLIENTE", CN9->CN9_CLIENT, Nil},; // Codigo do cliente
						{"C5_LOJAENT", CN9->CN9_LOJACL, Nil},; // Loja para entrada
						{"C5_LOJACLI", CN9->CN9_LOJACL, Nil},; // Loja do cliente
						{"C5_EMISSAO", dDatabase      , Nil},; // Data de emissao
						{"C5_XNATURE", cNATUREZA      , Nil},; // Natureza
						{"C5_CONDPAG", CN9->CN9_CONDPG, Nil},; // Codigo da condicao de pagamanto*
						{"C5_MOEDA"  , CN9->CN9_MOEDA , Nil},; // Moeda
						{"C5_MDCONTR", oGride:aCOLS[ nPos, nCND_CONTRA ], Nil},; // Cod. do Contrato
						{"C5_MDNUMED", oGride:aCOLS[ nPos, nCND_NUMMED ], Nil},; // Codigo da Medicao
						{"C5_MDPLANI", oGride:aCOLS[ nPos, nCND_NUMERO ], Nil},;  // Numero da Planilha
						{"C5_LIBEROK", " "            , Nil}}  // Liberado
	
			aAdd(aCabec,{"C5_TXMOEDA",If(CN9->CN9_MOEDA!=1,xMoeda(1,CN9->CN9_MOEDA,1,dDataBase,TamSx3("C5_TXMOEDA")[2],,nTaxa),1),NIL}) // Taxa de Conversao
		
			//Preenche os vendedores de acordo com o contrato
			cVend := "1"
			For nI := 1 to Len(aVend)
				aAdd(aCabec,{"C5_VEND"+cVend,aVend[nI,1],NIL})
				aAdd(aCabec,{"C5_COMIS"+cVend,aVend[nI,2],NIL})
				cVend:=Soma1(cVend)
			Next nI             
	
			//Preenche as Parcelas e Vencimentos  se condição de pagamento for do tipo 9
			dbSelectArea("SE4")
			dbSetOrder(1)   
			MsSeek(xFilial("SE4")+CN9->CN9_CONDPG)
			If SE4->E4_TIPO=='9'   				
				For nX := 1 to nParcelas    
					If !Empty(CND->(FieldPos("CND_PARC"+Substr(cParcela,nX,1)))) .And. !Empty(CND->(FieldPos("CND_DATA"+Substr(cParcela,nX,1))))
						aAdd(aCabec,{"C5_PARC"+Substr(cParcela,nX,1),&("CND->CND_PARC"+Substr(cParcela,nX,1)),NIL})
						aAdd(aCabec,{"C5_DATA"+Substr(cParcela,nX,1),&("CND->CND_DATA"+Substr(cParcela,nX,1)),NIL}) 
					EndIf
				Next nX   
			EndIf
			
			//Busca Codigo do Empenho da Planilha (CNA)
			CNA->( dbSetOrder(1) )
			IF CNA->( dbSeek( xFilial('CNA') + oGride:aCOLS[ nPos, nCND_CONTRA ] + oGride:aCOLS[ nPos, nCND_REVISA ] + oGride:aCOLS[ nPos, nCND_NUMERO ] ) )
				aAdd(aCabec,{"C5_MDEMPE" ,CNA->CNA_MDEMPE,NIL})
				aAdd(aCabec,{"C5_MDPROJE",CNA->CNA_MDPROJ,NIL})
				aAdd(aCabec,{"C5_ITEMCT" ,CNA->CNA_ITEMCT,NIL})
				aAdd(aCabec,{"C5_CLVL"   ,CNA->CNA_CLVL  ,NIL})
			EndIF
		lRet := .T.	
		EndIF
	EndIF	
Return( lRet )
//-----------------------------------------------------------------------
// Rotina | A680Item   | Autor | Robson Gonçalves    | Data | 06.04.2016
//-----------------------------------------------------------------------
// Descr. | Resumo das informações a serem faturadas
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680Item( oGride, cNumMed, aItem, cPEDIDO, aVend )
	Local nI         := 0
	Local nX         := 0
	Local nPos       := 0
	Local nValorC6   := 0
	Local nTOTPED    := 0
	Local cITEM      := ''
	Local cTES       := ''
	Local cVend      := '1'
	Local cXOPER     := ''
	Local lRet       := .F.
	Local cCategoHRD := GetNewPar("MV_GARHRD" ,"1")
	Local cCategoSFW	:= GetNewPar("MV_GARSFT" ,"2")
	Local cOperVenS  := GetNewPar("MV_XOPEVDS","61")
	Local cOperVenH  := GetNewPar("MV_XOPEVDH","62")

	//Local MRK   := 'NGCHECKOK.PNG'
	//Local NOMRK := 'NGCHECKNO.PNG'
	
	CNE->( dbGotop() )
	CNE->( dbSetOrder(1) )
	
	SB1->( dbGotop() )
	SB1->( dbSetOrder(1) )
	
	nPos := AScan( oGride:aCOLS, {|X| X[4] == cNumMed } )
	For nI := nPos To Len( oGride:aCOLS ) 
		IF .NOT. ( cNumMed == oGride:aCOLS[ nI, nCND_NUMMED ] )
			Exit
		EndIF
		
		IF oGride:aCOLS[ nI, 1 ] == MRK .AND. oGride:aCOLS[ nI, nCNE_QTFAT ] > 0
			IF CNE->( dbSeek( xFilial("CNE") + oGride:aCOLS[ nI, nCND_CONTRA ] + oGride:aCOLS[ nI, nCND_REVISA ] + oGride:aCOLS[ nI, nCND_NUMERO ] + oGride:aCOLS[ nI, nCND_NUMMED ] + oGride:aCOLS[ nI, nCNE_ITEM ] ) )
		
				//Atualiza sequencia do item
				cITEM := StrZero(Val(oGride:aCOLS[ nI, nCNE_ITEM ]),2)	
				
				SB1->(MSSeek(xFilial("SB1")+oGride:aCOLS[ nI, nCNE_PRODUT ]))
				IF SB1->B1_CATEGO $ cCategoHRD
					cXOPER := cOperVenH
				ElseIF SB1->B1_CATEGO $ cCategoSFW
					cXOPER := cOperVenS
				EndIF
				
				//Atualiza o campo TS dos itens da medição
				If CNE->(FieldPos("CNE_TS")) > 0 .And. !Empty(CNE->CNE_TS)    
					cTES := CNE->CNE_TS
				Else
				   	cTES := SB1->B1_TS
				EndIf
				
				nValorC6 := oGride:aCOLS[ nI, nCNE_QTFAT  ] * oGride:aCOLS[ nI, nCNE_VLUNIT ]
				nTOTPED  += nValorC6
				
				aAdd(aItem,{})
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gera item do pedido de venda          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aAdd(aTail(aItem),{"C6_NUM"    , cPEDIDO                        , Nil}) //Numero do Pedido
				aAdd(aTail(aItem),{"C6_ITEM"   , cITEM                          , Nil}) //Numero do Item no Pedido
				aAdd(aTail(aItem),{"C6_PRODUTO", oGride:aCOLS[ nI, nCNE_PRODUT ], Nil}) //Codigo do Produto
				aAdd(aTail(aItem),{"C6_DESCRI" , SB1->B1_DESC                   , Nil}) //Descricao
				aAdd(aTail(aItem),{"C6_QTDVEN" , oGride:aCOLS[ nI, nCNE_QTFAT  ], Nil}) //Quantidade Vendida
				aAdd(aTail(aItem),{"C6_PRUNIT" , oGride:aCOLS[ nI, nCNE_VLUNIT ], Nil}) //PRECO DE LISTA
				aAdd(aTail(aItem),{"C6_PRCVEN" , oGride:aCOLS[ nI, nCNE_VLUNIT ], Nil}) //Preco Unitario Liquido
				aAdd(aTail(aItem),{"C6_VALOR"  , Round(nValorC6,2)              , Nil}) //Valor Total do Item
				aAdd(aTail(aItem),{"C6_ENTREG" , CNE->CNE_DTENT                 , Nil}) //Data da Entrega
				aAdd(aTail(aItem),{"C6_UM"     , SB1->B1_UM                     , Nil}) //Unidade de Medida Primar.
				aAdd(aTail(aItem),{"C6_CLI"    , CN9->CN9_CLIENT                , Nil}) //Cliente
				aAdd(aTail(aItem),{"C6_LOJA"   , CN9->CN9_LOJACL                , Nil}) //Loja do Cliente
				aAdd(aTail(aItem),{"C6_TES"    , cTES                           , Nil}) //TES
				aAdd(aTail(aItem),{"C6_LOCAL"  , SB1->B1_LOCPAD                 , Nil}) //Local
				aAdd(aTail(aItem),{"C6_ITEMED" , oGride:aCOLS[ nI, nCNE_ITEM ]  , Nil}) //Item da Medicao
				aAdd(aTail(aItem),{"C6_VALDESC", CNE->CNE_VLDESC                , Nil}) //Desconto Item
				//aAdd(aTail(aItem),{"C6_XOPER"  , cXOPER                         , Nil}) //Desconto Item
				aAdd(aTail(aItem),{"C6_MSBLQL" , '2'                            , Nil}) //Bloqueado
			
				//Verifica se o item e comissionado
				IF FieldPos("CNE_FLGCMS") > 0 .And. CNE->CNE_FLGCMS == "1"
					//Complementa as comissoes de acordo com os contratos
					cVend:="1"
					For nX := 1 to len(aVend)
						aAdd(aItem[len(aItem)],{"C6_COMIS"+cVend,aVend[nX,2],NIL})
						cVend:=Soma1(cVend)
					Next nX
				EndIf
				
				//Busca Nº de Oportunidade da Planilha (CNA)
				CNA->( dbSetOrder(1) )
				IF CNA->( dbSeek( xFilial('CNA') + oGride:aCOLS[ nPos, nCND_CONTRA ] + oGride:aCOLS[ nPos, nCND_REVISA ] + oGride:aCOLS[ nPos, nCND_NUMERO ] ) )
					aAdd(aItem[len(aItem)],{"C6_NROPOR",CNA->CNA_UOPORT,NIL})
				EndIF
				lRet := .T.
			Else
				lRet := .F.
			EndIF
		EndIF
	Next nI
	
	aAdd(aCabec,{"C5_TOTPED", Round(nTOTPED,2), NIL})
	
Return( lRet )
//-----------------------------------------------------------------------
// Rotina | A680Log   | Autor | Rafael Beghini    | Data | 06.04.2016
//-----------------------------------------------------------------------
// Descr. | Resumo das informações do erro no ExecAuto
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680Log( cNumMed, aLOGErro )
	Local cPath    := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp% 
	Local cLogFile := cPath + "Pedidos_medicao" + cNumMed + ".LOG"
	Local nX       := 0
	Local nHandle  := 0
	Local lCopy    := .F.

	MsgAlert( cFONT+'Atenção,'+cNOFONT+;
	          '<br><br>Erro na geração do pedido referente á medição ' + cNumMed +; 
	          '. Não será possível incluir o pedido, verifique.' , 'A680GeraPV' )
			
	If File( cLogFile )
		Ferase( cLogFile )
	EndIF
				
	If ( nHandle := MSFCreate(cLogFile,0) ) <> -1				
		lCopy := .T.			
	EndIf		
			
	If	lCopy  //grava as informações de log no arquivo especificado			
		For nX := 1 To Len( aLOGErro )				
			FWrite( nHandle, aLOGErro[nX] + CRLF )			
		Next nX			
		
		FClose(nHandle)
		ShellExecute( "Open", cLogFile , '', '', 1 ) //Abre o arquivo na tela após salvar	
	EndIf
Return NIL
//-----------------------------------------------------------------------
// Rotina | A680Resumo  | Autor | Robson Gonçalves    | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Resumo das informações a serem faturadas
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680Resumo( oGride )
	Local oDlg
	Local oBar
	Local oThb1, oThb2
	Local oPnlAll, oPnl
	Local oTLbx
	Local bSair := {|| }
	Local bExcel := {|| }
	Local nList := 0
	Local oFntBox := TFont():New( "Courier New",,-11)
	Local aDADOS := {}
	Local nI := 0
	Local cPict := '@E 9,999.99'
	Local nTOTAL := 0
	Local aExcel := {}
	Local nCND_NUMMED  := GdFieldPos('CND_NUMMED')
	Local nCNE_ITEM    := GdFieldPos('CNE_ITEM')
	Local nCNE_PRODUT  := GdFieldPos('CNE_PRODUT')
	Local nB1_DESC     := GdFieldPos('B1_DESC')
	Local nCNE_QUANT   := GdFieldPos('CNE_QUANT')
	Local nCNE_QTJENT  := GdFieldPos('CNE_QTJENT')
	Local nCNE_QTFAT   := GdFieldPos('CNE_QTFAT')
	Local oFnt := TFont():New('Arial',,,,.F.,,,8,.T.,,,,,,,)
	
	AAdd( aDADOS, Replicate( '-', 101 ) )
	AAdd( aDADOS, 'Contrato: ' + CN9->CN9_NUMERO + ' - ' + RTrim( CN9->CN9_DESCRI ) )
	AAdd( aDADOS, Replicate( '-', 101 ) )
	AAdd( aDADOS, 'Medição Item Produto         Descrição                      Qt.Medida Qt.Faturada Qt.Faturar    Saldo' )
	//             999999  999  999999999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  9.999,99    9.999,99   9.999,99 9.999,99
	AAdd( aDADOS, Replicate( '-', 101 ) )
	
	For nI := 1 To Len( oGride:aCOLS )
		IF oGride:aCOLS[ nI, 1 ] == MRK
			nTOTAL += oGride:aCOLS[ oGride:nAt, nCNE_QTFAT ]
			
			AAdd( aDADOS, oGride:aCOLS[ nI, nCND_NUMMED ]+'  '+;
			              oGride:aCOLS[ nI, nCNE_ITEM ]+'  '+;
			              oGride:aCOLS[ nI, nCNE_PRODUT ]+' '+;
			              SubStr( oGride:aCOLS[ nI, nB1_DESC ], 1, 30 )+'  '+;
			              TransForm( oGride:aCOLS[ nI, nCNE_QUANT ], cPict )+'    '+;
			              TransForm( oGride:aCOLS[ nI, nCNE_QTJENT ], cPict )+'   '+;
			              TransForm( oGride:aCOLS[ nI, nCNE_QTFAT ], cPict )+' '+;
			              TransForm( oGride:aCOLS[ nI, nCNE_QUANT ]-oGride:aCOLS[ nI, nCNE_QTJENT ]-oGride:aCOLS[ nI, nCNE_QTFAT ], cPict ) )
	
			AAdd( aExcel, { oGride:aCOLS[ nI, nCND_NUMMED ],;
			              oGride:aCOLS[ nI, nCNE_ITEM ],;
			              oGride:aCOLS[ nI, nCNE_PRODUT ],;
			              SubStr( oGride:aCOLS[ nI, nB1_DESC ], 1, 30 ),;
			              oGride:aCOLS[ nI, nCNE_QUANT ],;
			              oGride:aCOLS[ nI, nCNE_QTJENT ],;
			              oGride:aCOLS[ nI, nCNE_QTFAT ],;
			              oGride:aCOLS[ nI, nCNE_QUANT ]-oGride:aCOLS[ nI, nCNE_QTJENT ]-oGride:aCOLS[ nI, nCNE_QTFAT ] } )
		EndIF	         
	Next nI
	
	AAdd( aDADOS, Replicate( '-', 101 ) )
	AAdd( aDADOS, '----------------------------------------------------> QUANTIDADE TOTAL A FATURAR:   '+TransForm( nTOTAL, cPict ) )
	AAdd( aDADOS, Replicate( '-', 101 ) )
	
	DEFINE MSDIALOG oDlg TITLE 'Resumo da(s) quantidade(s) a faturar' FROM 0,0 TO 360,750 PIXEL
		
		oPnlAll := TPanel():New(0,0,,oDlg,,,,,,13,0,.F.,.F.)
		oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnl := TPanel():New(0,0,,oDlg,,,,,,13,13,.F.,.F.)
		oPnl:Align := CONTROL_ALIGN_BOTTOM
		
		oBar := TBar():New( oPnl, 10, 9, .T.,'BOTTOM')

		bSair := {|| oDlg:End() }
		bExcel := {|| FwMsgRun(,{|| DlgToExcel( { { "ARRAY", "", {'Medição','Item','Produto','Descrição','Qt.Medida','Qt.Faturada','Qt.Faturar','Saldo'}, aExcel } } ) },,;
		'Aguarde, exportando os dados...') }
		
		oThb2 := THButton():New( 1, 1, '&Sair'          , oBar, bSair , 20, 12, oFnt ) ; oThb2:Align := CONTROL_ALIGN_RIGHT
		oThb1 := THButton():New( 1, 1, '&Exportar Excel', oBar, bExcel, 70, 12, oFnt ) ; oThb1:Align := CONTROL_ALIGN_RIGHT

		oTLbx := TListBox():New(0,0,{|u| Iif(PCount()>0,nList:=u,nList)},{},100,46,,oPnlAll,,,,.T.,,,oFntBox)
		oTLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oTLbx:SetArray( aDADOS )
		oTLbx:SetFocus()
		
	ACTIVATE MSDIALOG oDlg CENTERED
Return
//-----------------------------------------------------------------------
// Rotina | A680NFDev  | Autor | Rafael Beghini    | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Atualiza o saldo de medição na inclusão de NF de devolução.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A680NFDev( cNumDoc, cNumSer, cFornece, nOpcao, cNumSeq )
	Local cSQL     := ''
	Local cTRB     := ''
	Local cNfOri   := ''
	Local cSeriOri := ''
	Local cProduto := ''
	Local cItemPv  := ''
	Local cItemD1  := ''
	Local nQtde    := 0
	Local nSaldo   := 0
	Local nValor   := 0
	Local nD1RECNO := 0
	Local aArea    := {}
	
	Default cNumSeq := ''
	
	aArea := { SF1->( GetArea() ), SD1->( GetArea() )  }
	
	SF1->( dbSetOrder(1) )
	SD1->( dbSetOrder(1) )
	
	IF SF1->( dbSeek( xFilial( 'SF1' ) + cNumDoc + cNumSer + cFornece ) )
		SD1->( dbSeek( xFilial( 'SD1' ) + cNumDoc + cNumSer + cFornece ) )
		cNfOri   := SD1->D1_NFORI
		cSeriOri := SD1->D1_SERIORI
		 
		cSQL += "SELECT d2_filial,	d2_item, d2_itempv,	d2_cod, d2_quant, d2_doc, d2_serie, d2_cliente,	d2_pedido, "
		cSQL += "       c6_num, c6_nota, c6_serie, c5_mdcontr, cn9_revisa, c5_mdnumed, c5_mdplani, d1_numseq "
		
		cSQL += "FROM  "+RetSqlName("SD2")+" SD2 "
		
		cSQL += "       INNER JOIN "+RetSqlName("SC6")+" SC6   "
		cSQL += "               ON c6_filial = '"+xFilial("SC6")+"'       "
		cSQL += "                  AND c6_nota = d2_doc        "
		cSQL += "                  AND c6_serie = d2_serie     "
		cSQL += "                  AND c6_num = d2_pedido      "
		cSQL += "                  AND c6_item = d2_itempv     "
		cSQL += "                  AND SC6.d_e_l_e_t_ = ' '    "
		
		cSQL += "       INNER JOIN "+RetSqlName("SC5")+" SC5   " 
		cSQL += "               ON c6_filial = c5_filial       "
		cSQL += "                  AND c6_num = c5_num         "
		cSQL += "                  AND SC5.d_e_l_e_t_ = ' '    "
		
		cSQL += "       INNER JOIN "+RetSqlName("CN9")+" CN9   " 
		cSQL += "               ON cn9_filial = '"+xFilial("CN9")+"'      "
		cSQL += "                  AND c5_mdcontr = cn9_numero "
		cSQL += "                  AND cn9_situac = '05'       "
		cSQL += "                  AND SC5.d_e_l_e_t_ = ' '    "
		
		cSQL += "       INNER JOIN "+RetSqlName("SD1")+" SD1   "		 
		cSQL += "               ON d1_filial = d2_filial       "
		cSQL += "                  AND d1_nfori = d2_doc       "
		cSQL += "                  AND d1_seriori = d2_serie   "
		cSQL += "                  AND d1_itemori = d2_item    "
		cSQL += "                  AND SD1.d_e_l_e_t_ = ' '    "
		cSQL += IIF( .NOT. Empty(cNumSeq), "AND D1_NUMSEQ = '"+ cNumSeq +"'"," ")
		
		cSQL += "WHERE  SD2.d_e_l_e_t_ = ' ' "
		cSQL += "       AND d2_filial = " + ValToSql( xFilial("SD2") ) + " "
		cSQL += "       AND d2_doc    = '" + cNfOri   + "' "
		cSQL += "       AND d2_serie  = '" + cSeriOri + "' "
		cSQL += "       AND d2_pedido = c5_num  "
		cSQL += "       AND d2_cliente||d2_loja = '" + cFornece + "' "
		
		cSQL += "ORDER BY d2_doc,d2_item"
	
		cTRB := GetNextAlias()
		cSQL := ChangeQuery( cSQL )
		PLSQuery( cSQL, cTRB )
		
		CNE->( dbSetOrder(1) )
		
		While .NOT. (cTRB)->( EOF() )
			cItemPv := PADL((cTRB)->D2_ITEMPV,3,'0')

			SD1->( dbSetOrder(4) )
			IF SD1->( dbSeek( xFilial( 'SD1' ) + (cTRB)->D1_NUMSEQ ) )
				IF CNE->( dbSeek( xFilial("CNE") + (cTRB)->C5_MDCONTR + (cTRB)->CN9_REVISA + (cTRB)->C5_MDPLANI + (cTRB)->C5_MDNUMED + cItemPv ) )
						nQtde  := (cTRB)->D2_QUANT
						nSaldo := CNE->CNE_QTJENT
						nValor := IIF( nOpcao==3, nSaldo - nQtde, nSaldo + nQtde )

						CNE->( RecLock( 'CNE', .F. ) )
						CNE->CNE_QTJENT := nValor
						CNE->( MsUnLock() )
				EndIF
			EndIF
			(cTRB)->( dbSkip() )
		End
		(cTRB)->( dbCloseArea() )
	EndIF
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return
//-----------------------------------------------------------------------
// Rotina | A680Qtde  | Autor | Rafael Beghini    | Data | 07.03.2016
//-----------------------------------------------------------------------
// Descr. | Atualiza o saldo na tela conforme a digitação
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680Qtde( oGride )
	Local nCNE_QUANT  := GdFieldPos('CNE_QUANT')
	Local nCNE_QTJENT := GdFieldPos('CNE_QTJENT')
	Local nCNE_QTFAT  := GdFieldPos('CNE_QTFAT')
	Local nCNE_SALDO  := GdFieldPos('CNE_SALDO')
	
	IF oGride:aCOLS[ oGride:nAt, nCNE_QTFAT ] > 0
		oGride:aCOLS[ oGride:nAt, nCNE_SALDO ] := oGride:aCOLS[ oGride:nAt, nCNE_SALDO ] - oGride:aCOLS[ oGride:nAt, nCNE_QTFAT ]
	ElseIF oGride:aCOLS[ oGride:nAt, nCNE_QTFAT ] == 0
		oGride:aCOLS[ oGride:nAt, nCNE_SALDO ] := oGride:aCOLS[ oGride:nAt, nCNE_QUANT ] - oGride:aCOLS[ oGride:nAt, nCNE_QTJENT ]
	EndIF
	
	oGride:Refresh()
Return
//-----------------------------------------------------------------------
// Rotina | A680ShowLg | Autor | Rafael Beghini    | Data | 08.03.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar os pedidos de venda gerados
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680ShowLg( aLOG )
	Local oDlg
	Local oLst
	
	IF .NOT. Empty( aLOG ) 
		//Montagem da Tela
		Define MsDialog oDlg Title "Pedidos de venda gerados" From 0,0 To 300, 600 Of oMainWnd Pixel
			@ 010,005 LISTBOX oLst Fields HEADER "Nº Medição", "Nº Pedido Venda" SIZE 295,110 OF oDlg PIXEL
			oLst:SetArray(aLOG)
			oLst:nAt := 1
			oLst:bLine := { || { aLOG[oLst:nAt,1], aLOG[oLst:nAt,2] } }
		
			DEFINE SBUTTON FROM 130,005 TYPE 1  ACTION oDlg:End()      ENABLE OF oDlg  
			DEFINE SBUTTON FROM 130,040 TYPE 13 ACTION CSFSExcel(aLOG) ENABLE OF oDlg  
		Activate MSDialog oDlg Centered
	EndIF
Return(.T.)
//-----------------------------------------------------------------------
// Rotina | CSFSExcel  | Autor | Rafael Beghini    | Data | 08.03.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para gerar os dados em planilha
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function CSFSExcel(aLOG)
	Local cTitulo := 'Geração P.V. Medição de Contratos'
	Local cCabec  := "Pedidos de venda gerados em " + dToC(ddatabase) + ' referente ao contrato: ' + CN9->CN9_NUMERO
	cCadastro := cTitulo
	FwMsgRun(,{|| DlgToExcel( { { "ARRAY", cCabec, {'Nº Medição','Nº Pedido Venda'}, aLOG } } ) },cTitulo,'Aguarde, exportando os dados...') 
Return
//-----------------------------------------------------------------------
// Rotina | A680SendMail  | Autor | Rafael Beghini    | Data | 08.04.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para enviar por e-mail os dados faturados
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A680SendMail( cNumCN9, cDescCN9, aLOG )
	Local cHTML     := ''
	Local cBody     := ''
	Local cEmail    := ''
	Local cSubject  := ''
	Local cSaudacao := ''
	Local cTime     := ''
	Local cMvPar680 := 'MV_CSFA680'
	Local nL        := 0
	
	If .NOT. SX6->( ExisteSX6( cMvPar680 ) )
		CriarSX6( cMvPar680, 'C', 'Email de aviso sobre faturamento da medicao. CSFA680.prw', 'sav@certisign.com.br;licit@certisign.com.br' )
	Endif
	
	cTime := Time()
	
	IF cTime >= '00:00:00' .And. cTime <= '11:59:59'
		cSaudacao := 'bom dia.'
	ElseIF cTime >= '12:00:00' .And. cTime <= '17:59:59'
		cSaudacao := 'boa tarde.'
	Else
		cSaudacao := 'boa noite.'
	EndIF
	
	cHTML += '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
	cHTML += '<html>'
	cHTML += '	<head>'
	cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
	cHTML += '		<title>Aprova&ccedil;&atilde;o de solicita&ccedil;&atilde;o de compras</title>'
	cHTML += '	</head>'
	cHTML += '	<body>'
	cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" style="width: 600px">'
	cHTML += '			<tbody>'
	cHTML += '				<tr>'
	cHTML += '					<td>'
	cHTML += '						<em><span style="font-size:18px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>Medi&ccedil;&atilde;o de Contratos - Pedido de Venda</strong></font></span><br />'
	cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em></td>'
	cHTML += '					<td>'
	cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" style="float: right;" width="209" /><br />'
	cHTML += '						&nbsp;</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2">'
	cHTML += '						<hr style="width: 100%; height:5px; text-align:center; border:0px; color:rgb(244, 129, 29); background:rgb(244, 129, 29);" />'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2">'
	cHTML += '						<p>'
	cHTML += '							<span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Prezado(s), '+ cSaudacao +'<br />'
	cHTML += '							<br />'
	cHTML += '							Foi gerado o pedido de venda do contrato em quest&atilde;o nesta data. O pr&oacute;ximo passo &eacute; gerar o faturamento.</span></p>'
	cHTML += '						<p>'
	cHTML += '							<span style="font-size: 14px;"><span style="font-family:arial,helvetica,sans-serif;"><span style="color:#696969;"><strong>N&ordm; Contrato:&nbsp;</strong></span></span></span><span style="color: rgb(105, 105, 105); font-family: arial, helvetica, sans-serif; font-size: 14px;">'+ cNumCN9 +'</span><br />'
	cHTML += '							<strong style="color: rgb(105, 105, 105); font-family: arial, helvetica, sans-serif; font-size: 14px;">Descri&ccedil;&atilde;o: &nbsp;&nbsp;</strong><span style="color: rgb(105, 105, 105); font-family: arial, helvetica, sans-serif; font-size: 14px;">'+ cDescCN9 +'</span></p>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '			</tbody>'
	cHTML += '		</table>'
	cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" style="width: 600px">'
	cHTML += '			<tbody>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="3" style="text-align: center; height: 30px; background-color: rgb(244, 129, 29);">'
	cHTML += '						<font color="#ffffff" face="arial, helvetica, sans-serif">MEDI&Ccedil;&Atilde;O DE CONTRATOS</font></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td style="text-align: left; vertical-align: middle; height: 20px; background-color: rgb(254, 219, 171);">'
	cHTML += '						<font color="#696969" face="arial, helvetica, sans-serif"><span style="font-size: 12px;"><b>&nbsp;N&uacute;mero da Medi&ccedil;&atilde;o</b></span></font></td>'
	cHTML += '					<td colspan="2" style="text-align: left; vertical-align: middle; height: 20px; width: 40px; background-color: rgb(254, 219, 171);">'
	cHTML += '						<font color="#696969" face="arial, helvetica, sans-serif"><span style="font-size: 12px;"><b>N&uacute;mero do Pedido de Venda</b></span></font></td>'
	cHTML += '				</tr>'
	For nL := 1 To Len( aLOG )
		cHTML += '				<tr>'
		cHTML += '					<td style="text-align: left; vertical-align: middle; height: 20px;">'
		cHTML += '						<span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">&nbsp;'+ aLOG[nL,1] +' &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</span></span></td>'
		cHTML += '					<td style="text-align: left; vertical-align: middle; height: 20px;">'
		cHTML += '						<span style="font-family: arial, helvetica, sans-serif; font-size: 12px;">'+ aLOG[nL,2] +' &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</span></td>'
		cHTML += '					<td style="text-align: left; vertical-align: middle; height: 20px;">'
		cHTML += '						&nbsp;</td>'
		cHTML += '				</tr>'
	Next nL
	cHTML += '			</tbody>'
	cHTML += '		</table>'
	cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" style="width: 600px">'
	cHTML += '			<tbody>'
	cHTML += '				<tr>'
	cHTML += '					<td style="text-align: center;">'
	cHTML += '						&nbsp;</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td>'
	cHTML += '						<hr style="width: 100%; height:5px; text-align:center; border:0px; color:rgb(31,73,125); background:rgb(31,73,125);" />'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td style="text-align: center;">'
	cHTML += '						<em style="color: rgb(102, 102, 102); font-family: Arial, Helvetica, sans-serif; font-size: small;">Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></td>'
	cHTML += '				</tr>'
	cHTML += '			</tbody>'
	cHTML += '		</table>'
	cHTML += '		<p>'
	cHTML += '			&nbsp;</p>'
	cHTML += '	</body>'
	
	cEmail   := GetMv( cMvPar680 )
	cAssunto := 'Medição de Contratos - Pedido de Venda'
	cBody    := cHTML
	IF .NOT. Empty( cEmail )
		FSSendMail( cEmail, cAssunto, cBody, /*cAnexo*/ )
	EndIF
Return
//-----------------------------------------------------------------------
// Rotina | A680BXCan  | Autor | Rafael Beghini    | Data | 08.07.2016
//-----------------------------------------------------------------------
// Descr. | Atualiza o saldo de medição na baixa por cancelamento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A680BXCan( cNumDoc, cNumSer, cFornece, nOpcao, cNumSeq )
	Local cSQL     := ''
	Local cTRB     := ''
	Local cNfOri   := ''
	Local cSeriOri := ''
	Local cProduto := ''
	Local cItemPv  := ''
	Local cItemD1  := ''
	Local nQtde    := 0
	Local nSaldo   := 0
	Local nValor   := 0
	Local nD1RECNO := 0
	Local aArea    := {}
	
	Default cNumSeq := ''
	
	aArea := { SE1->( GetArea() ) }
	
	cSQL += "SELECT d2_filial,	d2_item, d2_itempv,	d2_cod, d2_quant, d2_doc, d2_serie, d2_cliente,	d2_pedido, "
	cSQL += "       c6_num, c6_nota, c6_serie, c5_mdcontr, cn9_revisa, c5_mdnumed, c5_mdplani "
	
	cSQL += "FROM  "+RetSqlName("SD2")+" SD2 "
	
	cSQL += "       INNER JOIN "+RetSqlName("SC6")+" SC6   "
	cSQL += "               ON c6_filial = '"+xFilial("SC6")+"'       "
	cSQL += "                  AND c6_nota = d2_doc        "
	cSQL += "                  AND c6_serie = d2_serie     "
	cSQL += "                  AND c6_num = d2_pedido      "
	cSQL += "                  AND c6_item = d2_itempv     "
	cSQL += "                  AND SC6.d_e_l_e_t_ = ' '    "
	
	cSQL += "       INNER JOIN "+RetSqlName("SC5")+" SC5   " 
	cSQL += "               ON c6_filial = c5_filial       "
	cSQL += "                  AND c6_num = c5_num         "
	cSQL += "                  AND SC5.d_e_l_e_t_ = ' '    "
	
	cSQL += "       INNER JOIN "+RetSqlName("CN9")+" CN9   " 
	cSQL += "               ON cn9_filial = '"+xFilial("SC5")+"'      "
	cSQL += "                  AND c5_mdcontr = cn9_numero "
	cSQL += "                  AND cn9_situac = '05'       "
	cSQL += "                  AND SC5.d_e_l_e_t_ = ' '    "
	
	cSQL += "WHERE  SD2.d_e_l_e_t_ = ' ' "
	cSQL += "       AND d2_filial = " + ValToSql( xFilial("SD2") ) + " "
	cSQL += "       AND d2_doc    = '" + cNumDoc   + "' "
	cSQL += "       AND d2_serie  = '" + cNumSer + "' "
	cSQL += "       AND d2_pedido = c5_num  "
	cSQL += "       AND d2_cliente||d2_loja = '" + cFornece + "' "
	
	cSQL += "ORDER BY d2_doc,d2_item"

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	
	CNE->( dbSetOrder(1) )
	
	While .NOT. (cTRB)->( EOF() )
		cItemPv := PADL((cTRB)->D2_ITEMPV,3,'0')
		IF CNE->( dbSeek( xFilial("CNE") + (cTRB)->C5_MDCONTR + (cTRB)->CN9_REVISA + (cTRB)->C5_MDPLANI + (cTRB)->C5_MDNUMED + cItemPv ) )
				nQtde  := (cTRB)->D2_QUANT
				nSaldo := CNE->CNE_QTJENT
				nValor := IIF( nOpcao==3, nSaldo - nQtde, nSaldo + nQtde )

				CNE->( RecLock( 'CNE', .F. ) )
				CNE->CNE_QTJENT := nValor
				CNE->( MsUnLock() )
		EndIF
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
	
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return