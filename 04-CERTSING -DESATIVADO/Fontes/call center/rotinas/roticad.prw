#INCLUDE "Protheus.ch"
//----------------------------------------------------------------------
// Rotina | RotiCad     | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina de cadastro de EMail x Estágio do Processo de Vendas.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
User Function RotiCad()
	Private cCadastro 	:= "EMail x Estágios do Processos de Vendas"
	Private aRotina := {}
	Private oFont 
	Private aAdvSize := {}
	Private aInfoAdvSize := {}
	Private aObjCoords := {}
	Private aObjSize := {}
	Private aAdv1Size := {}
	Private aInfo1AdvSize := {}
	Private aObj1Coords := {}
	Private aObj1Size := {}

	aAdvSize	:= MsAdvSize()
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 5 , 5 }
	aAdd( aObjCoords , { 000 , 028 , .T. , .F. } )
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
	aObjSize	:= MsObjSize( aInfoAdvSize , aObjCoords )
		
	aAdv1Size := aClone(aObjSize[1])
	aInfo1AdvSize := { aAdv1Size[2] , aAdv1Size[1] , aAdv1Size[4] , aAdv1Size[3] , 1 , 1 }
	aAdd( aObj1Coords , { 070 , 000 , .F. , .T. } )
	aAdd( aObj1Coords , { 000 , 000 , .T. , .T. } )
	aObj1Size := MsObjSize( aInfo1AdvSize , aObj1Coords,,.T. )
	
	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD   

	aRotina := {{"Pesquisar","AxPesqui",0,1} ,;
	{"Visualizar","U_A01Vis",0,2} ,;
	{"Incluir"   ,"U_A01Inc",0,3} ,;
	{"Alterar"   ,"U_A01Alt",0,4} ,;
	{"Excluir"   ,"U_A01Exc",0,5}}

	dbSelectArea("ZCE")
	dbSetOrder(1)
	MBrowse(,,,,'ZCE')
Return
//----------------------------------------------------------------------
// Rotina | A01Vis      | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina de visualização dos dados.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
User Function A01Vis( cAlias, nReg, nOpcX )
	Local oDlg
	Local oGride
	Local oGroup1
	Local oGroup2
	Local cCodigo := ZCE->ZCE_PROCESS
	Local cDescri := Posicione('AC1',1,xFilial('AC1')+ZCE->ZCE_PROCESS,'AC1_DESCRI')
	
	Private aCOLS := {}
	Private aHeader := {}	
	
	aHeader := APBuildHeader('ZCE',{'ZCE_PROCES'})
	FWMsgRun(, {|oSay| A01ACOLS( ZCE->ZCE_PROCES ) },, 'Aguarde, lendo dados...' )	
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL 
		oDlg:lEscClose := .F.
		
		@ aObj1Size[1,1] , aObj1Size[1,2] GROUP oGroup1 TO aObj1Size[1,3] ,aObj1Size[1,4] LABEL 'Código do Processo' OF oDlg PIXEL
		oGroup1:oFont:= oFont
		
		@ aObj1Size[2,1] , aObj1Size[2,2] GROUP oGroup2 TO aObj1Size[2,3] ,aObj1Size[2,4] LABEL 'Descrição do Processo' OF oDlg PIXEL
		oGroup2:oFont:= oFont
		
		@ aObj1Size[1,1]+12 , aObj1Size[1,2]+10 SAY cCodigo SIZE 050,10 OF oDlg PIXEL FONT oFont
	 	@ aObj1Size[2,1]+12 , aObj1Size[2,2]+10 SAY cDescri SIZE 120,10 OF oDlg PIXEL FONT oFont 

		oGride := MsNewGetDados():New(aObjSize[2,1],aObjSize[2,2],aObjSize[2,3],aObjSize[2,4],0,,,,,,999,,,,oDlg,aHeader,aCOLS)
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() })
Return
//----------------------------------------------------------------------
// Rotina | A01Inc      | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina de Inclusão dos dados.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
User Function A01Inc( cAlias, nReg, nOpcX )
	Local nI := 0
	Local lOk := .F.
	Local aRet := {}
	Local aPar := {}
	Local oDlg
	Local oGroup1
	Local oGroup2
	Local cDescri := Space( Len( AC1->AC1_DESCRI ) )
	
	Private oGride
	Private aCOLS := {}
	Private aHeader := {}	
	Private cZCE_PROCES := Space( Len( ZCE->ZCE_PROCESS ) )
	
	AAdd( aPar, { 1, 'Processo de Venda' , Space( Len( AC1->AC1_PROVEN ) ), '', 'U_RCVldProc( mv_par01 )', 'AC1', '', 50, .T. } )
	If ParamBox( aPar, 'Parâmetro', @aRet,,,,,,,,.F.,.F.)
		cZCE_PROCES := aRet[ 1 ]
		cDescri := Posicione('AC1',1,xFilial('AC1')+cZCE_PROCES,'AC1_DESCRI')
	
		aHeader := APBuildHeader('ZCE',{'ZCE_PROCES'})
	
		AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader )
			aCOLS[ 1, nI ] := CriaVar( aHeader[ nI, 2 ], .T. )
		Next nI
		aCOLS[ 1, Len( aHeader ) + 1 ] := .F.

		DEFINE MSDIALOG oDlg TITLE cCadastro FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL 
			oDlg:lEscClose := .F.
		
			@ aObj1Size[1,1] , aObj1Size[1,2] GROUP oGroup1 TO aObj1Size[1,3] ,aObj1Size[1,4] LABEL 'Código do Processo' OF oDlg PIXEL
			oGroup1:oFont:= oFont
		
			@ aObj1Size[2,1] , aObj1Size[2,2] GROUP oGroup2 TO aObj1Size[2,3] ,aObj1Size[2,4] LABEL 'Descrição do Processo' OF oDlg PIXEL
			oGroup2:oFont:= oFont
		
			@ aObj1Size[1,1]+12 , aObj1Size[1,2]+10 SAY cZCE_PROCESS SIZE 050,10 OF oDlg PIXEL FONT oFont
	 		@ aObj1Size[2,1]+12 , aObj1Size[2,2]+10 SAY cDescri SIZE 120,10 OF oDlg PIXEL FONT oFont 

			oGride := MsNewGetDados():New(aObjSize[2,1],aObjSize[2,2],aObjSize[2,3],aObjSize[2,4],GD_INSERT+GD_UPDATE+GD_DELETE,'U_RCValid()',,,,,999,,,,oDlg,aHeader,aCOLS)
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT ;
		EnchoiceBar(oDlg, {|| lOK := Iif(RCTudOK(),Iif(MsgYesNo('Confirma a inclusão dos registros?',cCadastro),(.T.,oDlg:End()),NIL),NIL) }, {|| oDlg:End() })
		If lOK
			FWMsgRun(, {|oSay| A01Incluir( cZCE_PROCES ) },, 'Aguarde, gravando...' )	
		Endif
	Endif
Return
//----------------------------------------------------------------------
// Rotina | A01Alt      | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina de alteração dos dados.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
User Function A01Alt( cAlias, nReg, nOpcX )
	Local lOK := .F.
	Local oDlg
	Local aRecNo := {}
	Local oGroup1
	Local oGroup2
	Local cDescri := Posicione('AC1',1,xFilial('AC1')+ZCE->ZCE_PROCESS,'AC1_DESCRI')

	Private cZCE_PROCES := ZCE->ZCE_PROCESS
	Private oGride
	Private aCOLS := {}
	Private aHeader := {}	
	
	aHeader := APBuildHeader('ZCE',{'ZCE_PROCESS'})
	FWMsgRun(, {|oSay| A01ACOLS( ZCE->ZCE_PROCES, @aRecNo ) },, 'Aguarde, lendo dados...' )	
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL 
		oDlg:lEscClose := .F.
		
		@ aObj1Size[1,1] , aObj1Size[1,2] GROUP oGroup1 TO aObj1Size[1,3] ,aObj1Size[1,4] LABEL 'Código do Processo' OF oDlg PIXEL
		oGroup1:oFont:= oFont
		
		@ aObj1Size[2,1] , aObj1Size[2,2] GROUP oGroup2 TO aObj1Size[2,3] ,aObj1Size[2,4] LABEL 'Descrição do Processo' OF oDlg PIXEL
		oGroup2:oFont:= oFont
		
		@ aObj1Size[1,1]+12 , aObj1Size[1,2]+10 SAY cZCE_PROCESS SIZE 050,10 OF oDlg PIXEL FONT oFont
	 	@ aObj1Size[2,1]+12 , aObj1Size[2,2]+10 SAY cDescri SIZE 120,10 OF oDlg PIXEL FONT oFont 
		oGride := MsNewGetDados():New(aObjSize[2,1],aObjSize[2,2],aObjSize[2,3],aObjSize[2,4],GD_INSERT+GD_UPDATE+GD_DELETE,'U_RCValid()',,,,,999,,,,oDlg,aHeader,aCOLS)
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT ;
	EnchoiceBar(oDlg, {|| lOk:=Iif(MsgYesNo('Confirma a alteção dos registros?',cCadastro),(Iif(RCTudOk(),(oDlg:End(),.T.),NIL)),NIL) }, {|| oDlg:End() })
	If lOK
		FWMsgRun(, {|oSay| A01Alterar( cZCE_PROCES, aRecNo ) },, 'Aguarde, gravando...' )	
	Endif
Return
//----------------------------------------------------------------------
// Rotina | A01Exc      | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina de exclusão dos dados.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
User Function A01Exc( cAlias, nReg, nOpcX )
	Local oDlg
	Local oGride
	Local oGroup1
	Local oGroup2
	Local lExclui := .F.
	Local aRecNo := {}
	Local cCodigo := ZCE->ZCE_PROCESS
	Local cDescri := Posicione('AC1',1,xFilial('AC1')+ZCE->ZCE_PROCESS,'AC1_DESCRI')

	Private aCOLS := {}
	Private aHeader := {}	
	
	aHeader := APBuildHeader('ZCE',{'ZCE_PROCES'})
	FWMsgRun(, {|oSay| A01ACOLS( ZCE->ZCE_PROCES, @aRecNo ) },, 'Aguarde, lendo dados...' )	
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL 
		oDlg:lEscClose := .F.
		
		@ aObj1Size[1,1] , aObj1Size[1,2] GROUP oGroup1 TO aObj1Size[1,3] ,aObj1Size[1,4] LABEL 'Código do Processo' OF oDlg PIXEL
		oGroup1:oFont:= oFont
		
		@ aObj1Size[2,1] , aObj1Size[2,2] GROUP oGroup2 TO aObj1Size[2,3] ,aObj1Size[2,4] LABEL 'Descrição do Processo' OF oDlg PIXEL
		oGroup2:oFont:= oFont
		
		@ aObj1Size[1,1]+12 , aObj1Size[1,2]+10 SAY cCodigo SIZE 050,10 OF oDlg PIXEL FONT oFont
	 	@ aObj1Size[2,1]+12 , aObj1Size[2,2]+10 SAY cDescri SIZE 120,10 OF oDlg PIXEL FONT oFont 

		oGride := MsNewGetDados():New(aObjSize[2,1],aObjSize[2,2],aObjSize[2,3],aObjSize[2,4],GD_INSERT+GD_UPDATE+GD_DELETE,,,,,,999,,,,oDlg,aHeader,aCOLS)
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT ;
	EnchoiceBar(oDlg, {|| lExclui:=MsgYesNo('Confirma a exclusão dos registros?',cCadastro),Iif(lExclui,oDlg:End(),NIL) }, {|| oDlg:End() })
	If lExclui
		If MsgYesNo('Todos os registros serão excluídos sem a possíbilidade de estorno, confirma mesmo assim?',cCadastro)
			FWMsgRun(, {|oSay| A01Excluir( aRecNo ) },, 'Aguarde, excluíndo...' )	
		Endif
	Endif
Return
//----------------------------------------------------------------------
// Rotina | RCValid     | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina para criticar a mudança de linha.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
User Function RCValid( nLine )
	Local lRet := .T.
	Local nI := 0
	Local nLin := 0
	
	Local nP_DELETE := Len( oGride:aHeader )+1
	Local nZCE_ESTATU := 0
	Local nZCE_ESTNOV := 0

	Local cZCE_ESTATU := ''
	Local cZCE_ESTNOV := ''
		
	If nLine==NIL
		nLin := oGride:nAt
	Else
		nLin := nLine
	Endif

	nZCE_ESTATU := GdFieldPos( 'ZCE_ESTATU', oGride:aHeader )
	nZCE_ESTNOV := GdFieldPos( 'ZCE_ESTNOV', oGride:aHeader )
	
	cZCE_ESTATU := oGride:aCOLS[ nLin, nZCE_ESTATU ]
	cZCE_ESTNOV := oGride:aCOLS[ nLin, nZCE_ESTNOV ]
   	
	If Len( oGride:aCOLS ) > 1
		For nI := 1 To Len( oGride:aCOLS )
			If nLin <> nI
				If .NOT. oGride:aCOLS[ nI, nP_DELETE ]
					If Empty( oGride:aCOLS[ nI, nZCE_ESTATU ] ) .And. Empty( oGride:aCOLS[ nI, nZCE_ESTNOV ] )
						MsgAlert('É preciso haver códigos para o estágio atual ou para o estágio novo. Linha: '+LTrim(Str(nI,3,0)), cCadastro )
						lRet := .F.
					Endif
					If oGride:aCOLS[ nI, nZCE_ESTATU ] + oGride:aCOLS[ nI, nZCE_ESTNOV ] == cZCE_ESTATU + cZCE_ESTNOV
						MsgAlert('Os códigos estágio atual e estágio novo está duplicado. Nesta linha e na Linha: '+LTrim(Str(nI,3,0)), cCadastro )
						lRet := .F.
					Endif
				Endif
			Endif
			If .NOT. lRet
				Exit
			Endif
		Next nI
	Else
		If .NOT. oGride:aCOLS[ 1, nP_DELETE ]
			If Empty( oGride:aCOLS[ 1, nZCE_ESTATU ] ) .And. Empty( oGride:aCOLS[ 1, nZCE_ESTNOV ] )
				MsgAlert('É preciso haver códigos para o estágio atual ou para o estágio novo. Linha: '+LTrim(Str(1,3,0)), cCadastro )
				lRet := .F.
			Endif
		Else
			MsgAlert('A 1ª linha está excluída.', cCadastro)
			lRet := .F.
		Endif
	Endif
Return( lRet )
//----------------------------------------------------------------------
// Rotina | RCTudOK     | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina para validar todas as linhas quando clicar no OK.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
Static Function RCTudOK()
	Local nI := 0
	Local lRet := .T.
	Local nP_DELETE := Len( oGride:aHeader )+1
	For nI := 1 To Len( oGride:aCOLS )
		If .NOT. oGride:aCOLS[ nI, nP_DELETE ]
			lRet := U_RCValid( nI )
			If .NOT. lRet
				Exit
			Endif
		Endif
	Next nI
Return( lRet )
//----------------------------------------------------------------------
// Rotina | RCVldProc   | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina para validar o número do processo na inclusão.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
User Function RCVldProc( cPROCES )
	Local lRet := .T.
	Local aArea := {}
	If ExistCpo( 'AC1', cPROCES, 1 )
		aArea := ZCE->( GetArea() )
		ZCE->( dbSetOrder( 1 ) )
		If ZCE->( dbSeek( xFilial( 'ZCE' ) + cPROCES ) )
			MsgAlert('Já existe o cadastro de EMail x Estágios para este Processo de Venda '+cPROCES, cCadastro )
			lRet := .F.
		Endif
		ZCE->( RestArea( aArea ) )
	Endif
Return( lRet )
//----------------------------------------------------------------------
// Rotina | A01ACOLS    | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina para montar o aCOLS.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
Static Function A01ACOLS( cPROCES, aRecNo )
	Local nI := 0
	Local nElem := 0
	Local cX3_RELACAO := ''
	ZCE->( dbSetOrder( 1 ) )
	ZCE->( dbSeek( xFilial( 'ZCE' ) + cPROCES ) )
	While .NOT. ZCE->( EOF() ) .And. ZCE->ZCE_PROCES == cPROCES
		AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		nElem := Len( aCOLS )
		For nI := 1 To Len( aHeader )
			If aHeader[ nI, 10 ] == 'V'
				cX3_RELACAO := Posicione('SX3',2,aHeader[nI,2],'X3_RELACAO')
				If .NOT. Empty(cX3_RELACAO)
					aCOLS[ nElem, nI ] := &(cX3_RELACAO)
				Endif
			Else
				aCOLS[ nElem, nI ] := ZCE->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) )
			Endif
		Next nI
		If aRecNo <> NIL
			AAdd( aRecNo, ZCE->( RecNo() ) )
		Endif
		aCOLS[ nElem, Len( aHeader ) + 1 ] := .F.
		ZCE->( dbSkip() )
	End
Return
//----------------------------------------------------------------------
// Rotina | A01Incluir  | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina para gravar a inclusão dos dados.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
Static Function A01Incluir( cPROCES )
	Local nI := 0
	Local nJ := 0
	Local nDEL := Len( aHeader ) + 1
	For nI := 1 To Len( oGride:aCOLS )
		If .NOT. oGride:aCOLS[ nI, nDEL ] 
			ZCE->( RecLock( 'ZCE', .T. ) )
			ZCE->ZCE_FILIAL := xFilial( 'ZCE' )
			ZCE->ZCE_PROCES := cPROCES
			For nJ := 1 To Len( oGride:aHeader )
				If oGride:aHeader[ nJ, 10 ] <> 'V'
					ZCE->( FieldPut( FieldPos( oGride:aHeader[ nJ, 2 ] ), oGride:aCOLs[ nI, nJ ] ) )
				Endif
			Next nJ
			ZCE->( MsUnLock() )
		Endif
	Next nI
	MsgAlert('Gravação realizada com sucesso.',cCadastro)
Return
//----------------------------------------------------------------------
// Rotina | A01Alterar  | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina para gravar a alteração dos dados.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
Static Function A01Alterar( cPROCES, aRecNo )
	Local nI := 0
	Local nJ := 0
	Local nDEL := Len( aHeader ) + 1	
	For nI := 1 To Len( oGride:aCOLS )
		If nI <= Len( aCOLS )
			ZCE->( dbGoTo( aRecNo[ nI ] ) )
			ZCE->( RecLock( 'ZCE', .F. ) )
			If oGride:aCOLS[ nI, nDEL ]
				ZCE->( dbDelete() )
			Else
				For nJ := 1 To Len( oGride:aHeader )
					If oGride:aHeader[ nJ, 10 ] <> 'V'
						ZCE->( FieldPut( FieldPos( oGride:aHeader[ nJ, 2 ] ), oGride:aCOLs[ nI, nJ ] ) )
					Endif
				Next nJ 
			Endif
			ZCE->( MsUnLock() )
		Else
			If .NOT. oGride:aCOLS[ nI, nDEL ]
				ZCE->( RecLock( 'ZCE', .T. ) )
				ZCE->ZCE_FILIAL := xFilial('ZCE')
				ZCE->ZCE_PROCES := cPROCES
				For nJ := 1 To Len( oGride:aHeader )
					If oGride:aHeader[ nJ, 10 ] <> 'V'
						ZCE->( FieldPut( FieldPos( oGride:aHeader[nJ,2]), oGride:aCOLs[ nI, nJ ] ) )
					Endif
				Next nJ 
				ZCE->( MsUnLock() )
			Endif
		Endif
	Next nI
	MsgAlert('Gravação realizada com sucesso.',cCadastro)
Return
//----------------------------------------------------------------------
// Rotina | A01Excluir  | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina para fazer a exclusão dos dados.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
Static Function A01Excluir( aRecNo )
	Local nI := 0
	For nI := 1 To Len( aRecNo )
		ZCE->( dbGoTo( aRecNo[ nI ] ) )
		ZCE->( RecLock( 'ZCE', .F. ) )
		ZCE->( dbDelete() )
		ZCE->( MsUnLock() )
	Next nI
	MsgAlert('Todos os estágios do processo foram excluídos.',cCadastro)
Return
//----------------------------------------------------------------------
// Rotina | UpdRotCad   | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina de ajuste do dicionário de dados.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
User Function UpdRotCad()
	Local nI := 0
	Local cXB_ALIAS := 'AC5ROT'
	Local aDados := {}
	Local aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}
	If MsgYesNo('Confirma a manutenção no dicionário de dados?','ROTICAD | UpdRotCad')
		SX3->( dbSetOrder( 2 ) )
		If SX3->( dbSeek( 'ZCE_PROCES' ) )
			If .NOT. Empty( SX3->X3_OBRIGAT )
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_OBRIGAT := ''
				SX3->( MsUnLock() )
			Endif
		Endif
		If SX3->( dbSeek( 'ZCE_EMAIL' ) )
			If .NOT. Empty( SX3->X3_OBRIGAT )
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_OBRIGAT := ''
				SX3->( MsUnLock() )
			Endif
			If .NOT. ( 'E-Mail' $ RTrim( SX3->X3_TITULO ) )
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_TITULO := 'E-Mail'
				SX3->X3_TITSPA := 'E-Mail'
				SX3->X3_TITENG := 'E-Mail'
				SX3->( MsUnLock() )
			Endif
		Endif
		If SX3->( dbSeek( 'ZCE_RESAPT' ) )
			If .NOT. Empty( SX3->X3_OBRIGAT )
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_OBRIGAT := ''
				SX3->( MsUnLock() )
			Endif
		Endif
		If SX3->( dbSeek( 'ZCE_RESOPT' ) )
			If .NOT. Empty( SX3->X3_OBRIGAT )
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_OBRIGAT := ''
				SX3->( MsUnLock() )
			Endif
		Endif
		If SX3->( dbSeek( 'ZCE_ESTATU' ) )
			If SX3->X3_F3 <> cXB_ALIAS
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_F3 := cXB_ALIAS
				SX3->( MsUnLock() )
			Endif
			If .NOT. ('U_RCTEMAC5' $ Upper( RTrim( SX3->X3_VLDUSER ) ) )
				cX3_VLDUSER := RTrim( SX3->X3_VLDUSER )
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_VLDUSER := cX3_VLDUSER + Iif( Empty( cX3_VLDUSER ), '', cOperador ) + 'U_RCTEMAC5()'
				SX3->( MsUnLock() )
			Endif
		Endif
		If SX3->( dbSeek( 'ZCE_ESTNOV' ) )
			If SX3->X3_F3 <> cXB_ALIAS
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_F3 := cXB_ALIAS
				SX3->( MsUnLock() )
			Endif
			If .NOT. ('U_RCTEMAC5' $ Upper( RTrim( SX3->X3_VLDUSER ) ) )
				cX3_VLDUSER := RTrim( SX3->X3_VLDUSER )
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_VLDUSER := cX3_VLDUSER + Iif( Empty( cX3_VLDUSER ), '', cOperador ) + 'U_RCTEMAC5()'
				SX3->( MsUnLock() )
			Endif
		Endif
		AAdd( aDados,{ cXB_ALIAS,'1','01','DB','Eventos','Eventos','Eventos','AC5',''})
		AAdd( aDados,{ cXB_ALIAS,'2','01','01','Eventos','Eventos','Evemtos','',''})
		AAdd( aDados,{ cXB_ALIAS,'4','01','01','Eventos','Eventos','Eventos','AC5_EVENTO',''})
		AAdd( aDados,{ cXB_ALIAS,'4','01','02','Descricao','Descricao','Descricao','AC5_DESCRI',''})
		AAdd( aDados,{ cXB_ALIAS,'5','01','','','','','AC5->AC5_EVENTO',''})
		AAdd( aDados,{ cXB_ALIAS,'6','01','','','','','@#U_RCSXBAC5()',''})
		SXB->(dbSetOrder(1))
		For nI := 1 To Len( aDados )
			If .NOT. SXB->(dbSeek(aDados[nI,1]+aDados[nI,2]+aDados[nI,3]+aDados[nI,4]))
				SXB->(RecLock('SXB',.T.))
				For nJ := 1 To Len( aDados[nI] )
					SXB->(FieldPut(FieldPos(aCpoXB[nJ]),aDados[nI,nJ]))
				Next nJ
				SXB->(MsUnLock())
			Endif
		Next nI
	Endif
Return
//----------------------------------------------------------------------
// Rotina | RCSXBAC5    | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina para fazer filtro na consulta SXB.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
User Function RCSXBAC5()
	Local cRet := "@#.T.@#"
	If ReadVar() $ "M->ZCE_ESTATU|M->ZCE_ESTNOV"
		If .NOT. Empty( cZCE_PROCES )
			cRet := "@#AC5_FILIAL == '"+xFilial("AC5")+"' .And. AC5_PROCES == '"+cZCE_PROCES+"'@#"
		Endif
	Endif
Return( cRet )
//----------------------------------------------------------------------
// Rotina | RCTEMAC5    | Autor | Robson Gonçalves | Data | 15.05.2014
//----------------------------------------------------------------------
// Descr. | Rotina para criticar o estágio do processo no cadastro.
//----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------
User Function RCTEMAC5()
	Local lRet := .T.
	Local cEstagio := ''
	cEstagio := oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|p| p[ 2 ] == Iif(ReadVar()=='M->ZCE_ESTATU','ZCE_ESTATU','ZCE_ESTNOV') } ) ]
	If Empty( cEstagio )
		cEstagio := &( ReadVar() )
	Endif
	AC2->( dbSetOrder( 1 ) )
	If .NOT. AC2->( dbSeek( xFilial( 'AC2' ) + cZCE_PROCES + cEstagio ) )
		lRet := .F.
		MsgALert('Não existe estágio para este processo, verifique.','RCTEMAC5 | ROTICAD')
	Endif
Return( lRet )