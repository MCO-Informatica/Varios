//-----------------------------------------------------------------------
// Rotina | CSFA420    | Autor | Robson Gon�alves     | Data | 05.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para extrair as informa��es de acesso do usu�rio.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include "Protheus.ch"

User Function CSFA420()
	Local aRadio := {}
	
	Local cGetFile := ''
	Local cSave := Space(150)
	
	Local nOpcao := 0
	Local nRadio := 1
	
	Local oBtnOK
	Local oBtnNo
	Local oDlg
	Local oFntSay := TFont():New('Arial',,14,,.T.,,,,,.F.,.F.)
	Local oRadio
	Local oSave
	
	Private aCCUsr := {}
	Private c422Path := ''
	Private cCadastro := 'Extra��o de acessos de usu�rios'
	
	cSave := A420Load()
	
	aRadio := {'por usu�rio',;
	           'por grupos de usu�rio',;
	           'por gestor do usu�rio',;
	           'por centro de custo',;
	           'para auditar v�nculo funcional'}

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 250,520 OF oMainWnd PIXEL
		@ 10,10 TO 104,253 OF oDlg PIXEL
		
		@ 15,15 SAY 'Esta rotina ir� ajudar a extrair as informa��es dos usu�rios Protheus.';
		        SIZE 230,10;
		        PIXEL OF oDlg; 
		        FONT oFntSay;
		        COLOR CLR_BLUE
		        
		@ 23,15 SAY 'Por favor, escolha uma das op��es e clique em [OK] para prosseguir.';
		        SIZE 230,10;
		        PIXEL OF oDlg; 
		        FONT oFntSay; 
		        COLOR CLR_BLUE
		
		@ 33,15 SAY 'Extrair acessos de usu�rio de qual forma?';
		        SIZE 230,10;
		        PIXEL OF oDlg;
		        COLOR CLR_BLUE
		
		oRadio := TRadMenu():New (40,15,aRadio,/*bSetGet*/,oDlg,/*uPar6*/,/*bChange*/,/*nClrText*/,/*nClrPane*/,/*cMsg*/,/*uPar11*/,/*bWhen*/,100,7,/*bValid*/,/*uPar16*/,/*uPar17*/,.T.,/*lHoriz*/,.F.)
		oRadio:bSetGet := {|u| Iif(PCount()==0,nRadio,nRadio:=u)}
		
		@ 90,15 SAY 'Salvar arquivo na pasta: ';
		        SIZE 80,10;
		        PIXEL OF oDlg;
		        COLOR CLR_BLUE
		        
		@ 89,78 MSGET oSave VAR cSave;
		        SIZE 160,9;
		        PIXEL OF oDlg
		
		cGetFile := "{|| cSave := cGetFile( '', 'Salvar na pasta', 0, '', .F.,  0+16+128 ) }"
		TButton():New( 89,238, '...', oDlg,&(cGetFile), 10, 11, , , ,.T.,.F.,,.T., ,, .F.)
		
		oBtnOK := SButton():New( 109, 195, 1,{|| Iif(ValidButton(nRadio,cSave,aRadio),(nOpcao:=1,oDlg:End()),NIL) }, oDlg, .T. )
		oBtnNo := SButton():New( 109, 227,22, {|| oDlg:End() }, oDlg, .T. )
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpcao == 1
		If nRadio==1
			A420Param()
		Elseif nRadio==2
			FwMsgRun(,{|oSay| A421Group() },,'Aguarde, processando grupos...')
		Else
			A420Save( cSave )
			
			c422Path := cSave
			
			// Abaixo os par�metro do SX1 por compatibilidade.
			MV_PAR01 := Space(150) // <branco> = todos os usu�rios.
			MV_PAR02 := Space(99)  // <branco> = todas as rotinas.
			MV_PAR03 := Space(99)  // <branco> = Todos os m�dulos.
			MV_PAR04 := 2          // 1=SIM; 2=N�O.
			
			If nRadio==3
				If A422ProcSRA()
					FwMsgRun(,{|oSay| A422Proc( oSay ) },,'Aguarde, processando por gestor...')
				Endif
			Elseif nRadio==4
				If A422ProcCTT()
					FwMsgRun(,{|oSay| A422Proc( oSay ) },,'Aguarde, processando por centro de custo...')
				Endif
			Elseif nRadio==5
				FwMsgRun(,{|oSay| A422ProcVF( oSay ) },,'Aguarde, processando...')
			Else
				MsgAlert('Op��o indispon�vel','Aten��o')
			Endif
		Endif
	Endif
Return

/******
 *
 * Rotina para carregar o par�metro.
 *
 */
Static Function A420Load()
	Local cBarra := Iif( IsSrvUnix(), "/", "\" )
	Local cFile := cBarra + "PROFILE" + cBarra + "a420" + __cUserId + ".txt"
	Local cLine := Space( 150 )
	If File( cFile )
		If FT_FUSE( cFile ) <> -1
			FT_FGOTOP()
			FT_FSKIP()
			cLine := FT_FREADLN()
			FT_FUSE()
		Endif
	Endif
Return( cLine )

/******
 *
 * Rotina para salvar o par�metro.
 *
 */
Static Function A420Save( cPar )
	Local cWrite := "Par�metro - Extra��o de acessos de usu�rios - CSFA420" + CRLF
	Local cBarra := Iif( IsSrvUnix(), "/", "\" )
	cWrite += cPar + CRLF
	MemoWrit( cBarra + "PROFILE" + cBarra + "a420" + __cUserId + ".txt", cWrite)
Return


/******
 *
 * Rotina para validar os par�metros.
 *
 */
Static Function ValidButton(nRadio,cSave,aRadio)
	If ((nRadio==1.OR.nRadio==2) .AND. Empty(cSave)) .OR. ((nRadio==3.OR.nRadio==4) .AND. .NOT.Empty(cSave)) .OR. (nRadio == 5)
		Return( .T. )
	Else
		MessageBox('Op��es ('+aRadio[3]+') e ('+aRadio[4]+') � obrigat�rio informar a pasta para salvar os arquivos.','Aten��o',0)
	Endif
Return( .F. )

/******
 *
 * Chamada da rotina obsoleta.
 *
 */
User Function xCSFA420()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	Private cCadastro := 'Extrair informa��es de acesso do usu�rio'
	AAdd( aSay, 'Esta rotina extrai as informa��es dos acessos dos usu�rios.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	AAdd( aButton, { 01, .T.,  } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	FormBatch( cCadastro, aSay, aButton )
	If nOpcao==1
		A420Param()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A420Param   | Autor | Robson Gon�alves     | Data | 05.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina de par�metros da rotina.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A420Param()
	Local cPerg := "CSFA420"
	Private aModulos := {}
	A420CriaX1( cPerg )
	aModulos := RetModName(.T.)
	SX1->( dbSetOrder( 1 ) )
	If SX1->( dbSeek( PadR( 'CSFA420', 10 ) + '02' ) )
		SX1->( MsRLock() )
		SX1->X1_CNT01 := ''
		SX1->( MsRUnlock() )
		SX1->( DbCommit() )
	Endif
	WriteProfDef( cEmpAnt + cUserName, 'CSFA420', 'PERGUNTE', 'MV_PAR', cEmpAnt + cUserName, 'CSFA420', 'PERGUNTE', 'MV_PAR', ' ' )
	If Pergunte( cPerg, .T. )
		MV_PAR02 := Upper( RTrim( MV_PAR02 ) )
		MV_PAR03 := Upper( RTrim( MV_PAR03 ) )
		MakeAdvplExpr( cPerg )
		FwMsgRun(,{|oSay| A420User( oSay ) },,'Aguarde, processando...')
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A420Mod    | Autor | Robson Gon�alves     | Data | 05.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina p/ apresentar o nome dos m�dulos a serem selecionados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A420Mod()
	Local oDlg
	Local oLbx
	Local oOrdem
	Local oPanelTop
	Local oPanelBot
	Local oPanelAll
	Local oCancel 
	Local oConfirm
	Local oSeek
	Local oPesq 
	
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	
	Local aOrdem := {}
	Local cOrd := ''
	Local cRet := ''
	Local cSeek := Space(100)
	Local cMV_PAR := ReadVar()
	Local cReadVar := RTrim(&(ReadVar()))

	Local aAmb := {}
	
	Local nI := 0
	Local nOrd := 1

	Local lOk := .F.
	Local lMark := .F.
	
	AAdd(aOrdem,'Nome do m�dulo') 
	AAdd(aOrdem,'Descri��o do m�dulo')

	For nI := 1 To Len( aModulos )
		lMark := StrZero( aModulos[ nI, 1 ], 2, 0 ) $ cReadVar
		AAdd( aAmb, { lMark, StrZero( aModulos[ nI, 1 ], 2, 0), aModulos[ nI, 2 ], aModulos[ nI, 3 ] } )
	Next nI
	
	lMark := .F.
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 350,777 TITLE 'Ambientes/M�dulos do Protheus' PIXEL
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
	   @ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (A420PsqMod(nOrd,cSeek,@oLbx))
		
		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		@ 40,05 LISTBOX oLbx FIELDS HEADER 'x','Sequencia','Nome do m�dulo','Descri��o do m�dulo' SIZE 350, 90 OF oPanelAll PIXEL ON ;
		dblClick(aAmb[oLbx:nAt,1]:=!aAmb[oLbx:nAt,1])
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray(aAmb)
		oLbx:bLine := { || {Iif(aAmb[oLbx:nAt,1],oOk,oNo),aAmb[oLbx:nAt,2],aAmb[oLbx:nAt,3],aAmb[oLbx:nAt,4]}}
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
		FWMsgRun(,{|| AEval(aAmb, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os m�dulos/ambientes...') }
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(A420VldMod(aAmb,@lOk),oDlg:End(),NIL)
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	
	If lOk
		For nI := 1 To Len( aAmb )
			If aAmb[ nI, 1 ]
				cRet += aAmb[ nI, 2 ] + '|'
			Endif
		Next nI
		cRet := SubStr( cRet, 1, Len( cRet )-1 )
		&(cMV_PAR) := cRet
	Endif
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A420PsqMod | Autor | Robson Gon�alves     | Data | 05.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina p/ pesquisar os m�dulos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A420PsqMod( nOrd, cSeek, oLbx )
	Local nP := 0
	Local nColPesq := 0
		
	If nOrd==1
		nColPesq := 3
	Elseif nOrd == 2
		nColPesq := 4
	Else
		MsgAlert('Op��o n�o dispon�vel para pesquisa.','Pesquisar')
	Endif
	
	If nColPesq > 0
		nP := AScan( oLbx:aArray, {|p| Upper( AllTrim( cSeek ) ) $ Upper( AllTrim( p[ nColPesq ] ) ) } )	
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo('Informa��o n�o localizada.','Pesquisar')
		Endif
	Endif
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A420VldMod | Autor | Robson Gon�alves     | Data | 05.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina p/ validar se foi selecionado algum m�dulo.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A420VldMod( aAmb, lOk )
	Local nP := 0
	Local lRet := .T.
	nP := AScan( aAmb, {|p| p[ 1 ] } )
	lOk := ( nP > 0 )
	If .NOT. lOk
		lRet := .F.
		MsgAlert( 'N�o foi selecionado nenhum m�dulo/ambiente para ser processado.', 'Valida��o da sele��o' )
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A420User   | Autor | Robson Gon�alves     | Data | 05.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para processar os usu�rios selecionados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A420User( oSay )
	Local aCabec := {}
	Local aUser := {}
	Local aPswRet := {}
	
	Local aSep := {"/","-","|","-","\","|"}
	Local cRegra := ""
	
	Local nCnt := 0
	Local nTp := 0
	
	Private aDados := {}
	Private cCodGrupo := ""
	Private cNomeGrp := ""
	Private c420CodUser := ""
	
	Private cCode := ""
	Private cUser := ""
	Private cName := ""
	Private cBlocked := ""
	Private cRetRegra := ""
	Private cLevelUser := ""
	Private cVincFunc := ""
	Private cSitFunc := ""
	Private cCodGestor := ""
	Private cNomGestor := ''
	Private cCodCCusto := ''
	Private cNomCCusto := ''
	
	aCabec := {"C�digo",;
	           "Nome do usu�rio",;
	           "Nome completo",;
	           "N�vel acesso usu�rio",;
	           "Vinculo funcional",;
	           "Situa��o funcion�rio",;
	           "UserId/Nome do gestor",;
	           "C�digo/Descri��o Centro de Custo",;
	           "Bloqueado",;
	           "Prioriza grupo",;
	           "C�digo do grupo",;
	           "Nome do grupo",;
	           "N�vel acesso grupo",;
	           "Nome do menu",;
	           "Endere�o da rotina no menu",;
	           "Nome da rotina",;
	           "Op��o 1","Op��o 2","Op��o 3","Op��o 4","Op��o 5","Op��o 6","Op��o 7","Op��o 8","Op��o 9","Op��o 10",;
	           "Op��o 11","Op��o 12","Op��o 13","Op��o 14","Op��o 15","Op��o 16","Op��o 17","Op��o 18","Op��o 19","Op��o 20" }
		
	If Empty( MV_PAR01 ) .OR. RTrim( MV_PAR01 ) == "*"
		MV_PAR01 := "((c420CodUser >= '      ' .AND. c420CodUser <= '999999'))"
	Else
		MV_PAR01 := StrTran( MV_PAR01, "A3_CODUSR", "c420CodUser" )
	Endif
	
	oSay:cCaption := ("Aguarde, buscando usu�rios...")
	ProcessMessages()
	aUser := FwSFAllUsers()
	
	PswOrder( 1 )
	
	For nI := 1 To Len( aUser )
		nCnt++
		nTp++ 
		
		If nTp == 7
			nTp := 1
		Endif
		
		oSay:cCaption := ("Aguarde, processando usu�rios [ " + aSep[ nTp ] + " ]" )
		ProcessMessages()
		
		c420CodUser := aUser[ nI, 2 ]
		
		If &( MV_PAR01 ) 

			cCode  := aUser[ nI, 2 ]
			cUser  := aUser[ nI, 3 ]
			cName  := aUser[ nI, 4 ]
			
			PswSeek( cCode )
			aPswRet := PswRet()
			
			// 1=N�o considerar usu�rios bloqueados.
			// 2=Sim considerar usu�rios bloqueados.
			If MV_PAR04==1
				// .T. = Est� bloqueado.
				// .F. = N�o est� bloqueado.
				If aPswRet[ 1, 17 ]
					Loop
				Endif
			Endif
			
			cBlocked := Iif(aPswRet[ 1, 17 ],"Sim","N�o")
			cVincFunc := Iif( Empty( aPswRet[ 1, 22 ] ), 'N�o h� vinvulo', aPswRet[ 1, 22 ] )
			If Len( cVincFunc ) == 10
				cSitFunc := A420SitFunc( cVincFunc )
			Else
				cSitFunc := "N�O H� V�NCULO"
			Endif
			 
			cLevelUser := aPswRet[ 1, 25 ]
			
			cRegra := FWUsrGrpRule( cCode )
			
			If cRegra=="0"     ; cRetRegra := "Usu�rio n�o encontrado"
			Elseif cRegra=="1" ; cRetRegra := "Prioriza regra do grupo"
			Elseif cRegra=="2" ; cRetRegra := "Desconsidera regra do grupo"
			Elseif cRegra=="3" ; cRetRegra := "Soma regra do grupo"
			Endif
			
			If cRegra <> "0"
				If cRegra $ "1|3"
					A420Grupo( aPswRet[ 1, 10 ] )
				Elseif cRegra == "2"
					A420LeMenu( aPswRet[ 3 ] )
				Endif
			Endif
		Endif
	Next nI
	
	If Len( aDados ) > 0
		MsgRun( 'Exportando os dados em Excel (CSV)', , {|| DlgToExcel( { { 'ARRAY', cCadastro, aCabec, aDados } } ) } )
	Else
		MsgInfo( "N�o foi poss�vel localizar dados", cCadastro )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A420SitFunc | Autor | Robson Gon�alves    | Data | 05.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para verificar a situa��o do funcion�rio.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A420SitFunc( cVincFunc )
	Local aArea := { SRA->( GetArea() ), GetArea() }
	Local cRA_FILIAL := SubStr( cVincFunc, 3, 2 )
	Local cRA_MAT    := SubStr( cVincFunc, 5, 6 )
	
	dbSelectArea( 'SRA' )
	dbSetOrder( 1 )
	
	If SRA->( dbSeek( cRA_FILIAL + cRA_MAT ) )
		If Empty( SRA->RA_DEMISSA )
			cSit := 'EM ATIVIDADE'
		Else
			cSit := 'DEMITIDO'
		Endif
		
		cCodGestor := SRA->RA_XCGEST
		cNomGestor := RTrim( SRA->( GetAdvFVal( 'SRA', 'RA_NOME', cRA_FILIAL + SRA->RA_XCGEST, 1 ) ) )

		cCodCCusto := SRA->RA_CC
		cNomCCusto := RTrim( CTT->( GetAdvFVal( 'CTT', 'CTT_DESC01', xFilial( 'CTT' ) + SRA->RA_CC, 1 ) ) )
	Else
		cSit := 'PROBLEMA AO TENTAR LOCALIZAR'
	Endif
	
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return( cSit )

//-----------------------------------------------------------------------
// Rotina | A420Grupo  | Autor | Robson Gon�alves     | Data | 05.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina que processa os menus dos grupos dos usu�rios.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A420Grupo( aMatrizGrp )
	Local nI := 0
	Local aMnuGrupo := {}
	For nI := 1 To Len( aMatrizGrp )
		cCodGrupo := aMatrizGrp[ nI ]
		cNomeGrp  := GrpRetName( aMatrizGrp[ nI ] )
		aMnuGrupo := FWGrpMenu( aMatrizGrp[ nI ] )
		A420LeMenu( aMnuGrupo )
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | A420LeMenu | Autor | Robson Gon�alves     | Data | 05.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina que efetua a leitura do menu grupo/usu�rio.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A420LeMenu( aMatrizMnu )
	Local nI := 0
	Local nJ := 0
	Local nPos := 0
	Local nElem := 0
	
	Local aArqMenu := {}
	
	Private cArqMnu := ""
	Private cModulo1 := ""
	Private cModulo2 := ""
	Private cNivel1 := ""
	Private cNivel2 := ""
	Private cLevelGrp := ""
		
	For nI := 1 To Len( aMatrizMnu )
		If SubStr( aMatrizMnu[ nI ], 3, 1 ) <> "X"
			nPos := AScan( aModulos, {|p| p[ 1 ] == Val( Left( aMatrizMnu[ nI ], 2 ) ) } )
			If nPos > 0			
				If StrZero( aModulos[ nPos, 1 ], 2, 0 ) $ MV_PAR02 .OR. Empty( MV_PAR02 )
					cModulo1 := aModulos[ nPos, 2 ] 
					cModulo2 := aModulos[ nPos, 3 ]
					nPos := At( "\", aMatrizMnu[ nI ] ) + 1
					cLevelGrp := SubStr( aMatrizMnu[ nI ], nPos-2, 1 )
					cArqMnu := SubStr( aMatrizMnu[ nI ], nPos )
					aArqMenu := XNULoad( cArqMnu )
					
					For nJ := 1 To Len( aArqMenu )
						If aArqMenu[ nJ, 2 ] == "H"
							Loop
						Endif
						cNivel1 := StrTran( aArqMenu[ nJ, 1, 1 ], "&", "" )
						If ( ValType( aArqMenu[ nJ, 3 ] ) == 'A' )
							A420UndoMnu( aArqMenu[ nJ, 3 ] )
						Endif
					Next nJ
				Endif
			Endif
		Endif
	Next nI
	
	If Len( aDados ) == 0
		AAdd( aDados, Array( 36 ) )
		nElem := Len( aDados )
		
		AFill( aDados[ nElem ], '')
		
		aDados[ nElem, 1 ] := cCode
		aDados[ nElem, 2 ] := cUser
		aDados[ nElem, 3 ] := cName
		aDados[ nElem, 4 ] := cLevelUser
		aDados[ nElem, 5 ] := cVincFunc
		aDados[ nElem, 6 ] := cSitFunc
		aDados[ nElem, 7 ] := cCodGestor + '-' + cNomGestor
		aDados[ nElem, 8 ] := cCodCCusto + '-' + cNomCCusto
		aDados[ nElem, 9 ] := cBlocked
		aDados[ nElem, 10] := cRetRegra
		aDados[ nElem, 11] := cCodGrupo
		aDados[ nElem, 12] := Iif( Empty( cNomeGrp ), "N�o possui grupo", cNomeGrp )
		aDados[ nElem, 13] := cLevelGrp
		aDados[ nElem, 14] := cArqMnu
		aDados[ nElem, 15] := ''
		aDados[ nElem, 16] := ''
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A420UndoMnu| Autor | Robson Gon�alves     | Data | 05.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina que desfaz a estrutura do menu do grupo/usu�rio.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A420UndoMnu( aMenu )
	Local nI := 0
	Local nL := 0
	Local nM := 0
	Local nElem := 0
	Local cOpcao := ""
	For nI := 1 To Len( aMenu )
		If aMenu [nI,2] == "H"
			Loop
		Endif
		If ValType( aMenu [nI, 3] ) == 'A'
			cNivel2 := StrTran( aMenu [ nI, 1, 1 ], "&", "" )
			A420UndoMnu( aMenu[ nI, 3 ] )
		Else
			If aMenu[ nI, 3 ] $ MV_PAR03 .OR. Empty( MV_PAR03 )
				AAdd( aDados, Array( 36 ) )
				nElem := Len( aDados )
				
				For nL := 1 To Len( aDados[ nElem ] ) // AFill( aDados[ nElem ], '')
					aDados[ nElem, nL ] := ''
				Next nL
				
				aDados[ nElem, 1 ] := cCode
				aDados[ nElem, 2 ] := cUser
				aDados[ nElem, 3 ] := cName
				aDados[ nElem, 4 ] := cLevelUser
				aDados[ nElem, 5 ] := cVincFunc
				aDados[ nElem, 6 ] := cSitFunc
				aDados[ nElem, 7 ] := cCodGestor + '-' + cNomGestor
				aDados[ nElem, 8 ] := cCodCCusto + '-' + cNomCCusto
				aDados[ nElem, 9 ] := cBlocked
				aDados[ nElem, 10] := cRetRegra
				aDados[ nElem, 11] := cCodGrupo
				aDados[ nElem, 12] := Iif( Empty( cNomeGrp ), "N�o possui grupo", cNomeGrp )
				aDados[ nElem, 13] := cLevelGrp
				aDados[ nElem, 14] := cArqMnu
				aDados[ nElem, 15] := cModulo1 + " > " + cModulo2 + " > " + cNivel1 + " > " + cNivel2 + " > " + aMenu[ nI, 1, 1 ]
				aDados[ nElem, 16] := aMenu[ nI, 3 ]

				cOpcao := aMenu[ nI, 5 ]
				
				For nM := 1 To Len( cOpcao )
					If SubStr( cOpcao, nM, 1 ) == "x"
						aDados[ nElem, nM+16 ] := "ACESSA"
					Else
						aDados[ nElem, nM+16 ] := "N�O ACESSA"
					Endif
				Next nM
			Endif
		Endif
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | A420CriaX1 | Autor | Robson Gon�alves     | Data | 05.08.2014
//-----------------------------------------------------------------------
// Descr. | Rotina que cria o grupo de perguntas caso necess�rio.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A420CriaX1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}
	
	AAdd( aP, { "Codigo de usuario(s)?"        ,"C",99,0,"R",""           ,"USR","","","","","","A3_CODUSR"}) //1
	AAdd( aP, { "Quais M�dulos?"               ,"C",99,0,"G","U_A420Mod()",""  ,"","","","","",""}) //2
	AAdd( aP, { "Quais Rotinas?"               ,"C",99,0,"G",""           ,""  ,"","","","","",""}) //3
	AAdd( aP, { "Considerar usu�rio bloqueado?","N",01,0,"C",""           ,""  ,"N�o","Sim","","","",""}) //4

	AAdd( aHelp, { "Informe os c�digos dos usu�rios,"  ,"asterisco ou branco para todos." } )
	AAdd( aHelp, { "Informe os m�dulos do Protheus que","deseja filtrar ou branco para todos." } )
	AAdd( aHelp, { "Informe as rotinas do Protheus que","deseja filtrar ou branco para todos." } )
	AAdd( aHelp, { "Extrair os dados de usu�rios do   ","Protheus que estejam bloqueados?    " } )
	
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

/******
 *
 * Rotina para extrair informa��es de grupos de usu�rios.
 * Esta rotina est� separada no Menu tamb�m, por�m utiliza as rotinas j� desenvolvidas aqui.
 * Autor: Robson Gon�alves.
 *
 */
 /******
 *
 * Chamada da rotina obsoleta.
 *
 */
User Function xCSFA421()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private cCadastro := 'Extrair informa��es dos grupos de usu�rios'
	
	AAdd( aSay, 'Esta rotina extrai as informa��es dos grupos de acessos dos usu�rios.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao==1
		FwMsgRun(,{|oSay| A421Group() },,'Aguarde, processando...')
	Endif
Return

/******
 *
 * Rotina para processar os grupos de usu�rios.
 * Autor: Robson Gon�alves.
 *
 */
Static Function A421Group()
	Local aGrp := {}
	Local aGrpMenu := {}
	Local aParam := {}
	Local aCabec := {}
	
	Private cCode := ''
	Private cName := ''
	Private cBloq := ''
	Private cDtBloq := ''
	Private cDtInc := ''
	Private cDtUltAlt := ''
	Private cNivel := ''
	
	Private aDados := {}
	Private aModulos := {}

	aModulos := RetModName( .T. )
	
	aGrp := AllGroups( .F. )
	
	aCabec := {'C�digo grupo',;
	'Nome grupo',;
	'Bloqueado',;
	'Data bloqueio',;
	'Data inclus�o',;
	'Data �ltima altera��o',;
	'N�vel global de campos',;
	'Nome do menu de acesso',;
	"Endere�o da rotina no menu",;
	"Nome da rotina",;
	"Op��o 1","Op��o 2","Op��o 3","Op��o 4","Op��o 5","Op��o 6","Op��o 7","Op��o 8","Op��o 9","Op��o 10",;
	"Op��o 11","Op��o 12","Op��o 13","Op��o 14","Op��o 15","Op��o 16","Op��o 17","Op��o 18","Op��o 19","Op��o 20"}
	
	For nI := 1 To Len( aGrp )
		cCode     := aGrp[ nI, 1, 1 ]
		cName     := aGrp[ nI, 1, 2 ]
		aGrpMenu  := FWGrpMenu( cCode )
		aParam    := FWGrpParam( cCode ) 
		cBloq     := Iif( aParam[ 1, 3 ] == "1", "Sim","N�o")
		cDtBloq   := Dtoc( aParam[ 1, 4 ] )
		cDtInc    := Dtoc( aParam[ 4, 1 ] )
		cDtUltAlt := Dtoc( aParam[ 4, 2 ] )
		cNivel    := aParam[ 3, 1 ]
		
		A421LeMenu( aGrpMenu )
 	Next nI
 	
 	If Len( aDados ) > 0
 		MsgRun( 'Exportando os dados em Excel (CSV)', , {|| DlgToExcel( { { 'ARRAY', 'Extra��o do acessos dos grupos de usu�srios', aCabec, aDados } } ) } )
 	Else
 		MsgInfo( "N�o foi poss�vel localizar dados", cCadastro )
 	Endif
Return

/******
 *
 * Rotina para processar os menus dos grupos de usu�rios.
 * Autor: Robson Gon�alves.
 *
 */
Static Function A421LeMenu( aMatrizMnu )
	Local nI := 0
	Local nJ := 0
	Local nPos := 0
	
	Local aArqMenu := {}
	
	Private cArqMnu := ""
	Private cModulo1 := ""
	Private cModulo2 := ""
	Private cNivel1 := ""
	Private cNivel2 := ""
	Private cLevelGrp := ""
	
	For nI := 1 To Len( aMatrizMnu )
		If SubStr( aMatrizMnu[ nI ], 3, 1 ) <> "X"
			nPos := AScan( aModulos, {|p| p[ 1 ] == Val( Left( aMatrizMnu[ nI ], 2 ) ) } )
			If nPos > 0			
				cModulo1 := aModulos[ nPos, 2 ] 
				cModulo2 := aModulos[ nPos, 3 ]
				nPos := At( "\", aMatrizMnu[ nI ] ) + 1
				cLevelGrp := SubStr( aMatrizMnu[ nI ], nPos-2, 1 )
				cArqMnu := SubStr( aMatrizMnu[ nI ], nPos )
				aArqMenu := XNULoad( cArqMnu )
				For nJ := 1 To Len( aArqMenu )
					If aArqMenu[ nJ, 2 ] == "H"
						Loop
					Endif
					cNivel1 := StrTran( aArqMenu[ nJ, 1, 1 ], "&", "" )
					If ( ValType( aArqMenu[ nJ, 3 ] ) == 'A' )
						A421UndoMnu( aArqMenu[ nJ, 3 ] )
					Endif
				Next nJ
			Endif
		Endif
	Next nI
Return

/******
 *
 * Rotina para ler o detalhe dos menus dos grupos de usu�rios.
 * Autor: Robson Gon�alves.
 *
 */
Static Function A421UndoMnu( aMenu )
	Local nI := 0
	Local nM := 0
	Local nElem := 0
	Local cOpcao := ""
	For nI := 1 To Len( aMenu )
		If aMenu [ nI, 2 ] == "H"
			Loop
		Endif
		If ValType( aMenu [ nI, 3 ] ) == 'A'
			cNivel2 := StrTran( aMenu [ nI, 1, 1 ], "&", "" )
			A421UndoMnu( aMenu[ nI, 3 ] )
		Else
			AAdd( aDados, Array( 30 ) )
			nElem := Len( aDados )
			AFill( aDados[ nElem ], '' )

			aDados[ nElem, 1 ] := cCode
			aDados[ nElem, 2 ] := cName
			aDados[ nElem, 3 ] := cBloq
			aDados[ nElem, 4 ] := cDtBloq
			aDados[ nElem, 5 ] := cDtInc
			aDados[ nElem, 6 ] := cDtUltAlt
			aDados[ nElem, 7 ] := cNivel
			aDados[ nElem, 8 ] := cArqMnu
			aDados[ nElem, 9 ] := cModulo1 + " > " + cModulo2 + " > " + cNivel1 + " > " + cNivel2 + " > " + aMenu[ nI, 1, 1 ]
			aDados[ nElem, 10] := aMenu[ nI, 3 ]
			
			cOpcao := aMenu[ nI, 5 ]
			
			For nM := 1 To Len( cOpcao )
				If SubStr( cOpcao, nM, 1 ) == "x"
					aDados[ nElem, nM+10 ] := "ACESSA"
				Else
					aDados[ nElem, nM+10 ] := "N�O ACESSA"
				Endif
			Next nM
		Endif
	Next nI
Return

/******
 *
 * Rotina para extrair informa��es dos usu�rios por centro de custo ou por gestor.
 * Esta rotina est� separada no Menu tamb�m, por�m utiliza as rotinas j� desenvolvidas aqui.
 * Autor: Robson Gon�alves.
 *
 */
 /******
 *
 * Chamada da rotina obsoleta.
 *
 */
User Function xCSFA422()
	Local aSay := {}
	Local aButton := {}
	
	Local nOpcao := 0
	
	Private aCCUsr := {}
	Private c422Path := ''
	Private cCadastro := 'Extrair informa��es dos usu�rios'
	
	AAdd( aSay, 'Esta rotina extrai as informa��es de acessos dos usu�rios por gestor ou' )
	AAdd( aSay, 'por centro de custo.' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao==1
		A422CriaX1('CSFA422b')
		If Pergunte( 'CSFA422b', .T. )
		
			// Abaixo os par�metro do SX1 por compatibilidade.
			c422Path := RTrim( MV_PAR02 )
			MV_PAR02 := Space(99)
			MV_PAR03 := Space(99) //<branco> = Todos os m�dulos.
			MV_PAR04 := 2 //1=SIM; 2=N�O.
			
			If MV_PAR01 == 1
				If .NOT. A422ProcSRA()
					Return
				Endif
			Elseif MV_PAR01 == 2
				If .NOT. A422ProcCTT()
					Return
				Endif
			Endif
			
			FwMsgRun(,{|oSay| A422Proc( oSay ) },,'Aguarde, processando...') 
			
		Endif
	Endif
Return

/******
 *
 * Rotina para apresentar quais gestores devem ser processados.
 * Autor: Robson Gon�alves.
 *
 */
Static Function A422ProcSRA( oSay )
	Local aDados := {}
	Local aOrdem := {'Gestor','Centro de Custo'}
	
	Local cOrd := ''
	Local cSeek := Space(100)
	Local cSQL := ""
	Local cTRB := GetNextAlias()
		
	Local nOpc := 0
	Local nOrd := 1
	
	Local oConfirm
	Local oDlg
	Local oLbx
	Local oMrk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNoMrk := LoadBitmap(,'NGCHECKNO.PNG')
	Local oOrdem
	Local oPanelAll
	Local oPanelBot
	Local oPanelTop
	Local oPesq 
	Local oSair
	Local oSeek
	
	cSQL := "SELECT RA_NOME, " 
	cSQL += "       RA_FILIAL,  "
	cSQL += "       RA_MAT, "
	cSQL += "       RA_CC, "
	cSQL += "       CTT_DESC01 " 
	cSQL += "FROM   "+RetSqlName("SRA")+" SRA "
	cSQL += "       INNER JOIN "+RetSqlName("CTT")+" CTT " 
	cSQL += "               ON CTT_CUSTO = RA_CC " 
	cSQL += "                  AND CTT.D_E_L_E_T_ = ' ' " 
	cSQL += "WHERE  (RA_FILIAL = '06' OR RA_FILIAL = '07') "
	cSQL += "       AND RA_XCGEST <> ' ' "
	cSQL += "       AND RA_DEMISSA = ' ' "
	cSQL += "       AND SRA.D_E_L_E_T_ = ' ' " 
	cSQL += "ORDER  BY RA_NOME "
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	
	While (cTRB)->( .NOT. EOF() )
		AAdd( aDados, { .F., (cTRB)->RA_NOME, (cTRB)->RA_FILIAL, (cTRB)->RA_MAT, (cTRB)->RA_CC, (cTRB)->CTT_DESC01 } )
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
	
	DEFINE MSDIALOG oDlg TITLE 'Selecione os gestores' FROM 0,0 TO 400,800 PIXEL
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,20,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
		@ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (Pesq1(nOrd,cSeek,@oLbx))
		
		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT
		
		oLbx := TwBrowse():New(0,0,0,0,,{'','Gestor','Filial','Matr�cula','C.Custo','Descri��o'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aDados )
		oLbx:bLine := {|| {Iif(aDados[oLbx:nAt,1],oMrk,oNoMrk),aDados[oLbx:nAt,2],aDados[oLbx:nAt,3],aDados[oLbx:nAt,4],aDados[oLbx:nAt,5],aDados[oLbx:nAt,6]}}
		oLbx:bLDblClick := {||  aDados[ oLbx:nAt, 1 ] := ! aDados[ oLbx:nAt, 1 ] }
	
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM
		
		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION (Iif(SelectSRA(oLbx),(nOpc:=1,oDlg:End()),NIL))
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
Return( nOpc == 1 )

/******
 *
 * Rotina para pesquisar os gestores.
 * Autor: Robson Gon�alves.
 *
 */
Static Function Pesq1(nOrd,cSeek,oLbx)
	Local nP := 0
	Local nColPesq := 0
		
	If nOrd==1       ; nColPesq := 2
	Elseif nOrd == 2 ; nColPesq := 5
	Else
		MsgAlert('ATEN��O<br><br>Op��o n�o dispon�vel para pesquisa.','Pesquisar')
	Endif
	
	If nColPesq > 0
		nP := AScan( oLbx:aArray, {|p| Upper( AllTrim( cSeek ) ) $ Upper( AllTrim( p[ nColPesq ] ) ) } )	
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo('ATEN��O<br><br>Informa��o n�o localizada.','Pesquisar')
		Endif
	Endif
Return( .T. )

/******
 *
 * Rotina para buscar os funcion�rios dos gestores selecionados.
 * Autor: Robson Gon�alves.
 *
 */
Static Function SelectSRA( oLbx )
	Local aGestor := {}
	Local cSQL := ''
	Local cTRB := ''
	Local nI := 0
	
	If AScan( oLbx:aArray, {|e| e[ 1 ] == .T. } ) == 0
		MsgInfo('ATEN��O<br><br>Selecione no m�nimo um gestor.','Verifique')
		Return( .F. )
	Endif
	
	cTRB := GetNextAlias()
	
	// Precisa localizar todos os funcion�rios do gestor selecionado.
	For nI := 1 To Len( oLbx:aArray )
		If oLbx:aArray[ nI, 1 ]
			nP := AScan( aGestor, oLbx:aArray[ nI, 2 ] )
			If nP == 0
				AAdd( aGestor, oLbx:aArray[ nI, 2 ] )
				
				cSQL := "SELECT RA_FILIAL, "
				cSQL += "       RA_MAT "
				cSQL += "FROM   " + RetSqlName("SRA") + " "
				cSQL += "WHERE RA_XCGEST = " + ValToSql( oLbx:aArray[ nI, 4 ] ) + " "
				cSQL += "      AND D_E_L_E_T_ = ' ' "
				cSQL += "ORDER BY RA_FILIAL, RA_MAT "
				 
				dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
				
				While (cTRB)->( .NOT. EOF() )
					AAdd( aCCUsr, { oLbx:aArray[ nI, 5 ], (cTRB)->RA_FILIAL + (cTRB)->RA_MAT } ) // Centro de custo, Filial + Matr�cula
					(cTRB)->( dbSkip() )
				End
				(cTRB)->( dbCloseArea() )
			Endif
		Endif
	Next nI
Return( .T. )

/******
 *
 * Rotina para buscar os centros de custos que ser�o processados.
 * Autor: Robson Gon�alves.
 *
 */
Static Function A422ProcCTT()
	Local aDados := {}
	Local aOrdem := {'Centro de Custo','Descri��o'}
	
	Local cOrd := ''
	Local cSeek := Space(100)
	Local cSQL := ""
	Local cTRB := GetNextAlias()
		
	Local nOpc := 0
	Local nOrd := 1
	
	Local oConfirm
	Local oDlg
	Local oLbx
	Local oMrk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNoMrk := LoadBitmap(,'NGCHECKNO.PNG')
	Local oOrdem
	Local oPanelAll
	Local oPanelBot
	Local oPanelTop
	Local oPesq 
	Local oSair
	Local oSeek
	
	cSQL := "SELECT CTT_CUSTO, " 
	cSQL += "       CTT_DESC01 "
	cSQL += "FROM   "+RetSqlName("CTT")+" "
	cSQL += "WHERE  CTT_FILIAL = " + ValToSql( xFilial( "CTT" ) ) + " " 
	cSQL += "       AND CTT_CLASSE = '2' "
	cSQL += "       AND CTT_MSBLQL = '2' " 
	cSQL += "       AND D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY CTT_CUSTO "
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	
	While (cTRB)->( .NOT. EOF() )
		AAdd( aDados, { .F., (cTRB)->CTT_CUSTO, (cTRB)->CTT_DESC01 } )
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
	
	DEFINE MSDIALOG oDlg TITLE 'Selecione os centros de custos' FROM 0,0 TO 400,800 PIXEL
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,20,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
		@ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (Pesq2(nOrd,cSeek,@oLbx))
		
		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT
		
		oLbx := TwBrowse():New(0,0,0,0,,{'','Centro de Custo','Descri��o'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aDados )
		oLbx:bLine := {|| {Iif(aDados[oLbx:nAt,1],oMrk,oNoMrk),aDados[oLbx:nAt,2],aDados[oLbx:nAt,3]}}
		oLbx:bLDblClick := {||  aDados[ oLbx:nAt, 1 ] := ! aDados[ oLbx:nAt, 1 ] }
	
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM
		
		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION (Iif(SelectCTT(oLbx),(nOpc:=1,oDlg:End()),NIL))
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
Return( nOpc == 1 )

/******
 *
 * Rotina para pesquisar centro de custo.
 * Autor: Robson Gon�alves.
 *
 */
Static Function Pesq2(nOrd,cSeek,oLbx)
	Local nP := 0
	Local nColPesq := 0
		
	If nOrd==1       ; nColPesq := 2
	Elseif nOrd == 2 ; nColPesq := 3
	Else
		MsgAlert('ATEN��O<br><br>Op��o n�o dispon�vel para pesquisa.','Pesquisar')
	Endif
	
	If nColPesq > 0
		nP := AScan( oLbx:aArray, {|p| Upper( AllTrim( cSeek ) ) $ Upper( AllTrim( p[ nColPesq ] ) ) } )	
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo('ATEN��O<br><br>Informa��o n�o localizada.','Pesquisar')
		Endif
	Endif
Return( .T. )

/******
 *
 * Rotina para buscar os funcion�rios do gestor do centro de custo selecionado.  
 * Autor: Robson Gon�alves.
 *
 */
Static Function SelectCTT( oLbx )
	Local aCC := {}
	Local cSQL := ''
	Local cTRB := ''
	Local nI := 0
	Local nP := 0
	
	If AScan( oLbx:aArray, {|e| e[ 1 ] == .T. } ) == 0
		MsgInfo('ATEN��O<br><br>Selecione no m�nimo um centro de custo.','Verifique')
		Return( .F. )
	Endif
	
	cTRB := GetNextAlias()
	
	For nI := 1 To Len( oLbx:aArray )
		If oLbx:aArray[ nI, 1 ]
			nP := AScan( aCC, oLbx:aArray[ nI, 2 ] )
			If nP == 0
				AAdd( aCC, oLbx:aArray[ nI, 2 ] )
				
				cSQL := "SELECT RA_FILIAL, "
				cSQL += "       RA_MAT "
				cSQL += "FROM   " + RetSqlName("SRA") + " "
				cSQL += "WHERE RA_CC = " + ValToSql( oLbx:aArray[ nI, 2 ] ) + " "
				cSQL += "      AND RA_DEMISSA = ' ' "
				cSQL += "      AND D_E_L_E_T_ = ' ' "
				cSQL += "ORDER BY RA_FILIAL, RA_MAT "
				 
				dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
				
				While (cTRB)->( .NOT. EOF() )
					AAdd( aCCUsr, { oLbx:aArray[ nI, 2 ], (cTRB)->RA_FILIAL + (cTRB)->RA_MAT } ) // Centro de custo, Filial + Matr�cula
					(cTRB)->( dbSkip() )
				End
				(cTRB)->( dbCloseArea() )
			Endif
		Endif
	Next nI
Return( .T. )

/******
 *
 * Rotina para processar os funcion�rios conforme a sele��o feita por gestor ou por centro de custo.  
 * Autor: Robson Gon�alves.
 *
 */
Static Function A422Proc( oSay )
	Local aAux := {}
	Local aCabec := {}
	Local aUser := {}
	Local aPswRet := {}
	Local aPlan := {}
	Local aFwMsEx := {}
	Local aFound := {}
	Local aNotFound := {}
	
	Local cWorkSheet := ''
	Local cTable := ''
	Local cFile := ''
	Local aSep := {"/","-","|","-","\","|"}
	Local cRegra := ""
	Local cCCusto := ""
	Local cMat := ''
	Local cFil := ''
	Local cFilUsr := ''
	Local nCnt := 0
	Local nTp := 0
	Local nElem := 0
	Local nI := 0
	Local nJ := 0
	Local nL := 0
	Local nFound := 0
	
	Private aDados := {}
	Private cCodGrupo := ""
	Private cNomeGrp := ""
	Private c422CodUser := ""
	Private c422CCusto := ""
	
	Private cCode := ""
	Private cUser := ""
	Private cName := ""
	Private cBlocked := ""
	Private cRetRegra := ""
	Private cLevelUser := ""
	Private cVincFunc := ""
	Private cSitFunc := ""
	Private cCodGestor := ""
	Private cNomGestor := ''
	Private cCodCCusto := ''
	Private cNomCCusto := ''
	
	aCabec := {"Id User",;
	           "Nome do usu�rio",;
	           "Nome completo",;
	           "N�vel acesso usu�rio",;
	           "Vinculo funcional",;
	           "Situa��o funcion�rio",;
	           "UserId/Nome do gestor",;
	           "C�digo/Descri��o Centro de Custo",;
	           "Bloqueado",;
	           "Prioriza grupo",;
	           "C�digo do grupo",;
	           "Nome do grupo",;
	           "N�vel acesso grupo",;
	           "Nome do menu",;
	           "Endere�o da rotina no menu",;
	           "Nome da rotina",;
	           "Op��o 1","Op��o 2","Op��o 3","Op��o 4","Op��o 5","Op��o 6","Op��o 7","Op��o 8","Op��o 9","Op��o 10",;
	           "Op��o 11","Op��o 12","Op��o 13","Op��o 14","Op��o 15","Op��o 16","Op��o 17","Op��o 18","Op��o 19","Op��o 20" }
	
	oSay:cCaption := ("Aguarde, buscando usu�rios...")
	ProcessMessages()
	aUser := FwSFAllUsers()
	
	// Colocar em ordem de centro de custo + filial + matr�cula.
	aAux := aSort( aCCUsr, /*nStart*/, /*nCount*/, {|a,b| a[ 1 ] + a[ 2 ]  < b[ 1 ] + b[ 2 ] } )
	aCCUsr := {}
	aCCUsr := AClone( aAux  ) 
	
	PswOrder( 1 )
	
	For nI := 1 To Len( aUser )
		nCnt++
		nTp++ 
		
		If nTp == 7
			nTp := 1
		Endif
		
		oSay:cCaption := ("Aguarde, processando informa��es [ " + aSep[ nTp ] + " ]" )
		ProcessMessages()
		
		c422CodUser := aUser[ nI, 2 ]
		cCodGestor := ''
		cNomGestor := ''
		
		cCode  := aUser[ nI, 2 ]
		cUser  := aUser[ nI, 3 ]
		cName  := aUser[ nI, 4 ]
		
		PswSeek( cCode )
		aPswRet := PswRet()
		
		cBlocked := Iif(aPswRet[ 1, 17 ],"Sim","N�o")
		
		If Empty( aPswRet[ 1, 22 ] )
			Loop
		Else
			cVincFunc := aPswRet[ 1, 22 ]
		Endif
		
		cFilUsr := SubStr( cVincFunc, 3 )
		
		// Se a filial + matr�cula estiver no vetor do centro de custo, ok processar este usu�rio, do contr�rio loop.
		nFound := AScan( aCCUsr, {|e| cFilUsr == e[ 2 ] } )
		If nFound == 0
			Loop
		Endif
		
		// Armazenar o funcion�rio que foi localizado com usu�rio.
		AAdd( aFound, { aCCUsr[ nFound, 1 ], aCCUsr[ nFound, 2 ] } )
		
		If Len( cVincFunc ) == 10
			cSitFunc := A420SitFunc( cVincFunc )
		Else
			cSitFunc := "N�O H� V�NCULO"
			Loop
		Endif
		
		cLevelUser := aPswRet[ 1, 25 ]
		
		cRegra := FWUsrGrpRule( cCode )
		
		If cRegra=="0"     ; cRetRegra := "Usu�rio n�o encontrado"
		Elseif cRegra=="1" ; cRetRegra := "Prioriza regra do grupo"
		Elseif cRegra=="2" ; cRetRegra := "Desconsidera regra do grupo"
		Elseif cRegra=="3" ; cRetRegra := "Soma regra do grupo"
		Endif
		
		If cRegra <> "0"
			If cRegra $ "1|3"
				A420Grupo( aPswRet[ 1, 10 ] )
			Elseif cRegra == "2"
				A420LeMenu( aPswRet[ 3 ] )
			Endif
		Endif
		
		// Fim do processamento do usu�rio.
		// O centro de custo em quest�o j� tem elemento, 
		// 		sim, ent�o localize e adicione este aDados.
		//		n�o, ent�o adicione um novo elemento deste a Dados.
		cCCusto := SubStr( aDados[ 1, 8 ], 1, 9 )
		nP := AScan( aPlan, {|e| e[ 1 ] == cCCusto } )
		If nP == 0
			AAdd( aPlan, '' )
			nElem := Len( aPlan )
			aPlan[ nElem ] := {}
			aPlan[ nElem ] := Array( 2 )
			
			aPlan[ nElem, 1 ] := cCCusto
			aPlan[ nElem, 2 ] := {}
			aPlan[ nElem, 2 ] := Array( 1 )
			aPlan[ nElem, 2 ] := AClone( aDados )
		Else
			AAdd( aPlan[ nP ], AClone( aDados ) )
		Endif
		aDados := {}
	Next nI
	
	// Ordernar por centro de custo.
	aAux := ASort( aPlan,,,{|a,b| a[1] < b[1] } )
	aPlan := {}
	aPlan := AClone( aAux )
	nI := 0
	
	// ANALISAR QUAIS FUNCION�RIO N�O FORAM LOCALIZADOS COMO USU�RIOS.
	For nI := 1 To Len( aCCUsr )
		// Se n�o achou o usu�rio, registre seus dados.
		If AScan( aFound, {|e| e[ 1 ] == aCCUsr[ nI, 1 ] .AND. e[ 2 ] == aCCUsr[ nI, 2 ] } ) == 0
			aAux := SRA->( GetAdvFVal( 'SRA', { 'RA_NOME', 'RA_FILIAL', 'RA_MAT', 'RA_CC' } , aCCUsr[ nI, 2 ], 1 ) )
			AAdd( aNotFound, { aAux[ 1 ], aAux[ 2 ], aAux[ 3 ], aAux[ 4 ] } )
			aAux := {}
		Endif
	Next nI
	
	// Ordenar por nome do funcion�rio.
	ASort( aNotFound,,, {|a,b| a[ 1 ] < b[ 1 ] } )
	
	// Gerar o excel.
	// Um arquivo para cada centro de custo.
	// Uma pasta (sheet) para cada funcion�rio.
	For nI := 1 To Len( aPlan )
		cFile := c422Path + 'ccusto_' + RTrim( aPlan[ nI, 1 ] ) + '_mod.xml'
		
		AAdd( aFwMsEx, Array( 1 ) )
		nElem := Len( aFwMsEx )
		aFwMsEx[ nElem ] := FWMsExcel():New()
		
		For nJ := 2 To Len( aPlan[ nI ] )
			cFil := SubStr(aPlan[nI,nJ,1,5],3,2)
			cFil := Iif(cFil=='06','RJ','SP' )
			cMat := SubStr(aPlan[nI,nJ,1,5],5,6)
			
			cWorkSheet := "MAT_"+cMat+"_USER_"+aPlan[nI,nJ,1,1]
			
			cTable := "[Usu�rio: "+aPlan[nI,nJ,1,3]+"] "
			cTable += "[C�digo do usu�rio: "+aPlan[nI,nJ,1,1]+"] "
			cTable += "[Matr�cula: "+cFil+"_"+cMat+"]"
			
			aFwMsEx[nElem]:AddWorkSheet( cWorkSheet )
			aFwMsEx[nElem]:AddTable( cWorkSheet, cTable )
			
			AEval( aCabec, {|value,index|  aFwMsEx[ nElem ]:AddColumn( cWorkSheet, cTable, value, 1, 1, .F. ) } )
			// value = conte�do de cada elemento.
			// index = n�mero do elemento.
			
			For nL := 1 To Len( aPlan[ nI, nJ ] )
				aFwMsEx[ nElem ]:AddRow( cWorkSheet, cTable, AClone( aPlan[ nI, nJ, nL ] ) )
			Next nL
		Next nJ
		
		// Salvar o arquivo.
		aFwMsEx[ nElem ]:Activate()
		LjMsgRun( "Gerando o arquivo...","", {|| aFwMsEx[ nElem ]:GetXMLFile( cFile ), Sleep( 500 ) } )
	Next nI
	
	If Len( aNotFound ) > 0
		AAdd( aFwMsEx, Array( 1 ) )
		nElem := Len( aFwMsEx )
		aFwMsEx[ nElem ] := FWMsExcel():New()
		
		cFile := c422Path + 'funcionarios_sem_usuario_protheus_9' + StrZero( Seconds(), 5, 0 ) + '.xml'
		aCabec := { 'Nome funcion�rio', 'Filial', 'Matr�cula', 'Centro de custo' } 
				
		cWorkSheet := 'Exce��o'
		cTable := 'FUNCION�RIO(S) QUE N�O POSSUI(EM) USU�RIO NO SISTEMA PROTHEUS'
		
		aFwMsEx[nElem]:AddWorkSheet( cWorkSheet )
		aFwMsEx[nElem]:AddTable( cWorkSheet, cTable )
		
		AEval( aCabec, {|value,index|  aFwMsEx[ nElem ]:AddColumn( cWorkSheet, cTable, value, 1, 1, .F. ) } )
		
		For nL := 1 To Len( aNotFound )
			aFwMsEx[ nElem ]:AddRow( cWorkSheet, cTable, AClone( aNotFound[ nL ] ) )
		Next nL

		aFwMsEx[ nElem ]:Activate()
		LjMsgRun( "Gerando o arquivo...","", {|| aFwMsEx[ nElem ]:GetXMLFile( cFile ), Sleep( 500 ) } )
	Endif
	
	If nI > 0
		MessageBox('Opera��o finalizada com sucesso. Os arquivos foram gerados na pasta [' + c422Path + '].','Fim do processo',0)
	Else
		MsgInfo( "N�o foi poss�vel localizar dados", 'Problema' )
	Endif	
Return

/******
 *
 * Rotina para processar todos os usu�rio com o objetivo de apontar quem est� sem v�nculo funcional.
 *
 ***/
 Static Function A422ProcVF( oSay )
	Local aCabec := {}
	Local aDados := {}
	Local aPswRet := {}
	Local aSep := {"/","-","|","-","\","|"}
	Local aUser := {}
	
	Local cBlocked := ""
	Local cCode := ""
	Local cName := ""
	Local cUser := ""
	Local cVincFunc := ""

	Local nCnt := 0
	Local nElem := 0
	Local nI := 0
	Local nTp := 0
	
	aCabec := {"C�digo",;
	           "Nome do usu�rio",;
	           "Nome completo",;
	           "Vinculo funcional",;
	           "Bloqueado" }
	
	oSay:cCaption := ("Aguarde, buscando usu�rios...")
	ProcessMessages()
	aUser := FwSFAllUsers()
	
	PswOrder( 1 )
	For nI := 1 To Len( aUser )
		nCnt++
		nTp++ 
		
		If nTp == 7
			nTp := 1
		Endif
		
		oSay:cCaption := ("Aguarde, processando informa��es [ " + aSep[ nTp ] + " ]" )
		ProcessMessages()
		
		cCode  := aUser[ nI, 2 ]
		cUser  := aUser[ nI, 3 ]
		cName  := aUser[ nI, 4 ]
		
		PswSeek( cCode )
		aPswRet := PswRet()
		
		cBlocked := Iif(aPswRet[ 1, 17 ],"Sim","N�o")
		
		cVincFunc := aPswRet[ 1, 22 ]

		If Empty( cVincFunc )
			cVincFunc := 'N�O H� V�NCULO'
		Endif
		
		AAdd( aDados, Array( 5 ) )
		nElem := Len( aDados )
		
		AFill( aDados[ nElem ], '')
		
		aDados[ nElem, 1 ] := cCode
		aDados[ nElem, 2 ] := cUser
		aDados[ nElem, 3 ] := cName
		aDados[ nElem, 4 ] := cVincFunc
		aDados[ nElem, 5 ] := cBlocked
	Next nI

	If Len( aDados ) > 0
		MsgRun( 'Exportando os dados em Excel (CSV)', , {|| DlgToExcel( { { 'ARRAY', cCadastro, aCabec, aDados } } ) } )
	Else
		MsgInfo( "N�o foi poss�vel localizar dados", cCadastro )
	Endif
Return

/******
 *
 * Rotina para criar o grupo de perguntas no SX1.  
 * Autor: Robson Gon�alves.
 *
 */Static Function A422CriaX1( cPerg )
	Local aP := {}
	Local cMvCh
	Local cMvPar
	Local cSeq
	Local i := 0
	Local nTam := Len( SX1->X1_GRUPO )
	
	/*
	[n,1] --> texto da pergunta
	[n,2] --> tipo do dado
	[n,3] --> tamanho
	[n,4] --> decimal
	[n,5] --> objeto G=get ou C=choice
	[n,6] --> validacao
	[n,7] --> F3
	[n,8] --> definicao 1
	[n,9] --> definicao 2
	[n,10] -> definicao 3
	[n,11] -> definicao 4
	[n,12] -> definicao 5
	[n,13] -> Conte�do
	*/
	
	AAdd( aP, { "Salvar na pasta?","C",60,0,"F","","","56"    ,""               ,"","","",""}) //2
	
	dbSelectArea( 'SX1' )
	dbSetOrder( 1 )
	
	For i := 1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		
		If .NOT. SX1->( dbSeek( PadR( cPerg, nTam ) + cSeq ) )
			SX1->( RecLock( 'SX1', .T. ) )
			SX1->X1_GRUPO   := cPerg 
			SX1->X1_ORDEM   := cSeq
			SX1->X1_PERGUNT := aP[ i, 1 ]  
			SX1->X1_PERSPA  := aP[ i, 1 ]
			SX1->X1_PERENG  := aP[ i, 1 ]
			SX1->X1_VARIAVL := cMvCh
			SX1->X1_TIPO    := aP[ i, 2 ]
			SX1->X1_TAMANHO := aP[ i, 3 ]
			SX1->X1_DECIMAL := aP[ i, 4 ]
			SX1->X1_GSC     := aP[ i, 5 ]
			SX1->X1_VALID   := aP[ i, 6 ] 
			SX1->X1_F3      := aP[ i, 7 ] 
			SX1->X1_VAR01   := cMvPar 
			SX1->X1_DEF01   := aP[ i, 8 ] 
			SX1->X1_DEF02   := aP[ i, 9 ]
			SX1->X1_DEF03   := aP[ i, 10 ]
			SX1->X1_DEF04   := aP[ i, 11 ]
			SX1->X1_DEF05   := aP[ i, 12 ]
			SX1->X1_CNT01   := aP[ i, 13 ] 
			SX1->( MsUnLock() )
		Endif
	Next i
Return