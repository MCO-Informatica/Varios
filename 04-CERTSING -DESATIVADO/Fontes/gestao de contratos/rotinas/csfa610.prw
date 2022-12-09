//--------------------------------------------------------------------------
// Rotina | CSFA610    | Autor | Robson Gonçalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina para preparar a capa de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
#Include 'Protheus.ch'
#Include 'Ap5Mail.ch'
#Include 'TbiConn.ch'

#DEFINE cTP_DOC           '#2' // Tipo de documento em SCR da capa de despesa.
#DEFINE cFONT             '<b><font size="4" color="blue"><b>'
#DEFINE cALERT            '<b><font size="4" color="red"><b>'
#DEFINE cFNTALERT         '<b><font size="4" color="red"><b>'
#DEFINE cNOFONT           '</b></font></b></u>'
#DEFINE SEMREVISAO        'Não há revisão.'
#DEFINE cMSG_PRAZO_VENCTO '( *** Condição de pagamento inferior ao que foi estabelecido pela companhia *** )'
#DEFINE cFNT_PRZ_VENC     "<b><font color='red'><b>"

STATIC _cXREFERE_  := ''
STATIC _cAPBUDGE_  := ''
STATIC _cCONTA_    := Space( 20 )
STATIC _cXRECORR_  := ''
STATIC _cCCAPROV_  := ''
STATIC _cDESCCCA_  := Space( 40 )
STATIC _cCC_       := ''
STATIC _cDESCCC_   := ''
STATIC _cITEMCTA_  := ''
STATIC _cDEITCTA_  := ''
STATIC _cCTAORC_   := ''
STATIC _cDESCCOR_  := Space( 40 )
STATIC _cCLVL_     := ''
STATIC _cDESCLVL_  := ''
STATIC _cRATCC_    := ''
STATIC _cXCONTRA_  := ''
STATIC _cDESCRCP_  := ''
STATIC _cXJUST_    := ''
STATIC _cXOBJ_     := ''
STATIC _cXADICON_  := Space( 256 )
STATIC _cFORMPG_   := ''
STATIC _cDOCFIS_   := ''
STATIC _cCOND_     := ''
STATIC _cXVENCTO_  := Ctod( Space( 8 ) )
STATIC _cFILENT_   := ''
STATIC _cDDORC_    := ''
STATIC _cCNPJ_     := Space( 14 )

STATIC lReplEntid  := .T.

STATIC __cCodEmp__  := ''
STATIC __cCodPrj__  := ''
STATIC __cItConta__ := ''
STATIC __cClaVal__  := ''
STATIC __cOportu__  := ''

STATIC lNewCP610 := IIf( FindFunction( 'U_NewCP610' ) , U_NewCP610() , .F. )

STATIC aFormaPg     := {}
STATIC aCTA_ORCADA  := {}
STATIC a610CNPJ     := {}

STATIC cNUM_CONTRAT := ''
STATIC cREV_CONTRAT := ''
STATIC cNUM_MEDICAO := ''
STATIC cNUM_PED_COM := ''
STATIC cNUM_COTACAO := ''
STATIC cNUM_SOL_COM := ''

STATIC lCNTA120 := IsInCallStack( 'CNTA120' )

STATIC lMSG_PRAZO_VENCTO := .F.

STATIC l610OnMsg := IIf( FindFunction( 'U_A610OnMsg' ) , U_A610OnMsg() , .T. )

User Function CSFA610( cGestao, cAmb, cFunc )
	Local nI := 0
	Local lRet := .T.
	Local aMvPar[60]
	
	//------------------------------------------------------------------
	// Se for gestão de contrato e a medição já estiver encerrada, sair.
	If lCNTA120
		If .NOT. Empty( CND->CND_DTFIM )
			Return(.T.)
		Endif
	Endif

	If cGestao == 'COM'
		If ( cAmb == 'CNTA120' .AND. Empty( cFunc ) ) .OR. ;
			( cAmb == 'MATA120' .AND. cFunc $ 'INC|ALT' ) .OR. ;
			( cAmb == 'MATA161' .AND. Empty( cFunc ) )
			//------------------
			// Salvar variáveis.
			AEval( aMvPar, {|cValue,nIndex| aMvPar[ nIndex ] := &('MV_PAR' + StrZero( nIndex, 2, 0 ) ) } )
			//-------------------
			// Executar a rotina.
			lRet := A610Com( cAmb, cFunc )
			//---------------------
			// Restaurar variáveis.
			AEval( aMvPar, {|cValue,nIndex| &('MV_PAR' + StrZero( nIndex, 2, 0 )) := aMvPar[ nIndex ] } )
		Endif
	Elseif cGestao == 'VEN'
		If GetMv('MV_PVCONTR') == 'S'
			lRet := A610Ven()
		Endif
	Else
		MsgAlert('Gestão indefinido para o processo do módulo Gestão de Contratos.','CSFA610 | Definição da gestão de necessidade')
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A610OnMsg  | Autor | Robson Gonçalves        | Data | 02.08.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para ligar ou desligar o envio de e-mails das ações dos
//        | PC conforme cada operação de aprovação e manutenção no pedido.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610OnMsg()
	Local cMV610_004 := 'MV_610_004'
	Local lAuto := ( Select( 'SX6' ) == 0 )
	Local lReturn := .T.
	If .NOT. lAuto
		If .NOT. GetMv( cMV610_004, .T. )
			CriarSX6( cMV610_004, 'N', 'HABILITAR MENSAGENS PLANEJAMENTO FINC. 0=DESABILITADO E 1=HABILITADO - ROTINA CSFA610.prw', '1' )
		Endif
		lReturn := ( GetMv( cMV610_004, .F. ) == 1 )
	Endif
Return( lReturn )

//--------------------------------------------------------------------------
// Rotina | NewCP610    | Autor | Robson Gonçalves       | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar qual funcionalidade deve ser utilizada.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function NewCP610()
	Local lReturn := .T.
	Local cMV_610NEW := 'MV_610NEW'
	Local lA610BAuto := ( Select( 'SX6' ) == 0 )
	If .NOT. lA610BAuto
		If .NOT. GetMv( cMV_610NEW, .T. )
			CriarSX6( cMV_610NEW, 'N', 'HABILITAR NOVA CAPA DE DESPESA COM CONTROLE DE APROVACAO E GERACAO DO DOCUMENTO EM PDF. 0=DESABILITADO E 1=HABILITADO - ROTINA CSFA610.prw', '1' )
		Endif
		lReturn := ( GetMv( cMV_610NEW, .F. ) == 1 )
	Endif
Return( lReturn )

//--------------------------------------------------------------------------
// Rotina | A610Ven    | Autor | Robson Gonçalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina de interface para a capa de despesa de vendas.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Ven()
	Local oDlg
	Local lOpc := .F.
	
	__cCodEmp__  := CNA->CNA_MDEMPE
	__cCodPrj__  := CNA->CNA_MDPROJ
	__cItConta__ := CNA->CNA_ITEMCT
	__cClaVal__	 := CNA->CNA_CLVL
	__cOportu__  := CNA->CNA_UOPORT
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 230,250 TITLE 'Capa de despesa - Vendas' PIXEL STYLE DS_MODALFRAME STATUS
	oDlg:lEscClose := .F.
		
	@ 08,05 Say 'Cód. Empenho'  PIXEL SIZE 40,07 OF oDlg COLOR CLR_HBLUE
	@ 07,45 MsGet __cCodEmp__   PIXEL VALID NaoVazio(__cCodEmp__) SIZE 65,09 OF oDlg
		
	@ 23,05 Say 'Cód. Projeto'  PIXEL SIZE 40,07 OF oDlg
	@ 22,45 MsGet __cCodPrj__   PIXEL SIZE 65,09 F3 'SZ3_05' OF oDlg
		
	@ 38,05 Say 'Item Contábil' PIXEL SIZE 40,07 OF oDlg
	@ 37,45 MsGet __cItConta__  PIXEL SIZE 65,09 F3 'CTD' VALID Vazio(__cItConta__) .OR. CTB105Item(__cItConta__) OF oDlg
		
	@ 53,05 Say 'Classe Valor'  PIXEL SIZE 40,07 OF oDlg
	@ 52,45 MsGet __cClaVal__   PIXEL SIZE 65,09 F3 'CTH' VALID Vazio(__cClaVal__) .OR. CTB105ClVl(__cClaVal__) OF oDlg
		
	@ 68,05 Say 'Oportunidade'  PIXEL SIZE 40,07 OF oDlg
	@ 67,45 MsGet __cOportu__   PIXEL SIZE 65,09 F3 'AD1' VALID Vazio(__cOportu__) .OR. ExistCpo( 'AD1', __cOportu__ ) OF oDlg
		
	DEFINE SBUTTON FROM 100,40 TYPE 1 ENABLE OF oDlg ACTION (lOpc := A610VldVen(), Iif(lOpc,(oDlg:End()),NIL) )
	DEFINE SBUTTON FROM 100,70 TYPE 2 ENABLE OF oDlg ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTERED
	If .NOT. lOpc
		__cCodEmp__  := ''
		__cCodPrj__  := ''
		__cItConta__ := ''
		__cClaVal__	 := ''
		__cOportu__  := ''
		MsgAlert('Operação abandonada, o encerramento da medição não será concluído.','Abandono de operação')
	Endif
Return( lOpc )

//--------------------------------------------------------------------------
// Rotina | A610VldVen | Autor | Robson Gonçalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina de validação dos campos de capa de despesa de vendas.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610VldVen()
	Local cTitulo := 'Validação de campos'
	If Empty( __cCodEmp__ )
		MsgAlert('Preencher o campo código do empenho.',cTitulo)
		Return( .F. )
	Endif
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | A610Grv410 | Autor | Robson Gonçalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina de gravação da capa de despesa no pedido de vendas.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Grv410()
	Local aArea := {}
	Local cAD1_XNATUR := ''
	
	aArea := { GetArea(), SC5->( GetArea() ), AD1->( GetArea() ), SZW->( GetArea() ) }
	
	If .NOT. Empty( __cOportu__ )
		AD1->( dbSetOrder( 1 ) )
		AD1->( MsSeek( xFilial( 'AD1' ) + __cOportu__ ) )
		cAD1_XNATUR := AD1->AD1_XNATUR
	Endif
		
	SC5->( RecLock( 'SC5', .F. ) )
	SC5->C5_MDPROJE := __cCodPrj__
	SC5->C5_MDEMPE	 := __cCodEmp__
	SC5->C5_ITEMCT  := __cItConta__
	SC5->C5_CLVL    := __cClaVal__
	SC5->C5_XNATURE := cAD1_XNATUR
	SC5->C5_XORIGPV := '6'
	SC5->( MsUnlock() )

	//Envia Workflow de encerramento.
	U_CSGCT004()
	
	SZW->( dbSetOrder( 1 ) )
	If .NOT. SZW->( dbSeek( xFilial( 'SZW' ) + CND->CND_CONTRA + CND->CND_NUMERO + CND->CND_REVISA + __cCodEmp__ ) )
		SZW->( RecLock( 'SZW', .T. ) )
		SZW->ZW_FILIAL := xFilial( 'SZW' )
		SZW->ZW_NRCONT := CND->CND_CONTRA
		SZW->ZW_NRPLAN := CND->CND_NUMERO
		SZW->ZW_REVISA := CND->CND_REVISA
		SZW->ZW_NUMMED := CND->CND_NUMMED
		SZW->ZW_NOTA   := __cCodEmp__
		SZW->ZW_CLIENT := CND->CND_CLIENT
		SZW->ZW_LOJA   := CND->CND_LOJACL
		SZW->( MsUnlock() )
	EndIf

	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return

//--------------------------------------------------------------------------
// Rotina | A610Com    | Autor | Robson Gonçalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina de interface da capa de despesa para compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Com( cAmb, cFunc )
	Local lRet := .F.
	If lNewCP610
		lRet := C610Com( cAmb, cFunc )
	Else
		lRet := B610Com( cAmb, cFunc )
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | B610Com     | Autor | Robson Gonçalves       | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de capa de despesa - primeira versão.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function B610Com( cAmb, cFunc )
	Local cCpox := GetNewPar('MV_XCPOCPR','C7_CC,C7_ITEMCTA,C7_XRECORR,C7_XREFERE,C7_CLVL,C7_XJUST,C7_XOBJ,C7_XCONTRA,C7_XADICON,C7_XVENCTO')
	Local aCpoComp	:= StrTokArr(cCpox, ',')
	Local aPar := {}
	Local aRet := {}
	Local lObri := .F.
	Local aCbx := {}
	Local bF4
	Local nI := 0
	Local cConteudo := ''
	Local cLeaveMsg := ''
	Local cBkp := ''
	Local aArea := { SX3->( GetArea() ) }
	Local aRecor := {}
	Local aContr := {}
	Local lRet := .F.
	
	If Type('cCadastro') <> 'U'
		cBkp := cCadastro
	Else
		Private cCadastro := ''
	Endif
	
	cCadastro := 'Capa de despesa'
	
	bF4 := SetKey( VK_F4 )
	SetKey( VK_F4, NIL )

	SX3->( DbSetOrder( 2 ) )
	For nI := 1 To Len( aCpoComp )
		If SX3->( DbSeek( aCpoComp[ nI ] ) )
	
			If cFunc == 'INC' .OR. Empty( cFunc )
				cConteudo := CriaVar( aCpoComp[ nI ] )
			ElseIf cFunc == 'ALT'
				cConteudo := &( 'SC7->' + aCpoComp[ nI ] )
			Endif
	
			lObri := SX3->X3_CAMPO <> 'C7_XADICON'
			
			If SX3->X3_TIPO == 'C' .AND. Empty( SX3->X3_CBOX )
				AAdd( aPar,{ 1, RTrim( SX3->X3_DESCRIC ), cConteudo, SX3->X3_PICTURE, SX3->X3_VALID, SX3->X3_F3, '', 50, lObri } )
			
			Elseif SX3->X3_TIPO == 'D'
				Set( 4, 'dd/mm/yyyy' )
				AAdd( aPar,{ 1, RTrim(SX3->X3_DESCRIC), cConteudo, '99/99/9999', '', '', '', 50, lObri } )
			
			Elseif SX3->X3_TIPO == 'C' .AND. .NOT. Empty( SX3->X3_CBOX )
				aCbx := StrTokArr(SX3->X3_CBOX, ';')
				AAdd( aPar,{ 2, RTrim( SX3->X3_DESCRIC ), Val( cConteudo ), aCbx, 50, '' , lObri } )
			
			Elseif SX3->X3_TIPO == 'M'
				AAdd( aPar,{ 11 ,RTrim( SX3->X3_DESCRIC ), cConteudo, '', '',  lObri } )
			
			Endif
		Endif
	Next nI
	
	AEval( aArea, {|xArea| RestArea( xArea ) } )
	
	If cAmb == 'CNTA120'
		AAdd( aPar, { 1, 'Qual a filial de entrega', xFilial( 'SC7' ), '', 'A120FilEnt( MV_PAR11 )', 'SM0_01', '', 50, .T. } )
	Endif
	
	lRet := ParamBox( aPar, 'Compras', @aRet,,,,,,,,.F.,.F.)
	
	If lRet
		aRecor := StrTokArr( SX3->( Posicione( 'SX3', 2, 'C7_XRECORR', 'X3CBox()' ) ), ';' )
		If ValType( aRet[ 3 ] ) == 'N'
			aRet[ 3 ] := SubStr( aRecor[ aRet[ 3 ] ], 1, 1 )
		Else
			aRet[ 3 ] := SubStr( aRet[ 3 ], 1, 1 )
		Endif
	
		aContr := StrTokArr( SX3->( Posicione( 'SX3', 2, 'C7_XCONTRA', 'X3CBox()' ) ), ';' )
		If ValType( aRet[ 8 ] ) == 'N'
			aRet[ 8 ] := SubStr( aRecor[ aRet[ 8 ] ], 1, 1 )
		Else
			aRet[ 8 ] := SubStr( aRet[ 8 ], 1, 1 )
		Endif
		
		_cCC_      := aRet[ 1 ]
		_cITEMCTA_ := aRet[ 2 ]
		_cXRECORR_ := aRet[ 3 ]
		_cXREFERE_ := aRet[ 4 ]
		_cCLVL_    := aRet[ 5 ]
		_cXJUST_   := aRet[ 6 ]
		_cXOBJ_    := aRet[ 7 ]
		_cXCONTRA_ := aRet[ 8 ]
		_cXADICON_ := aRet[ 9 ]
		_cXVENCTO_ := aRet[ 10 ]
		If cAmb == 'CNTA120'
			_cFILENT_  := aRet[ 11 ]
		Endif
		
		If cAmb == 'MATA120'
			U_A610COLS()
		Endif
	Else
		_cCC_      := ''
		_cITEMCTA_ := ''
		_cXRECORR_ := ''
		_cXREFERE_ := ''
		_cCLVL_    := ''
		_cXJUST_   := ''
		_cXOBJ_    := ''
		_cXCONTRA_ := ''
		_cXADICON_ := ''
		_cXVENCTO_ := Ctod( Space( 8 ) )
		_cFILENT_  := ''
		
		If cAmb == 'CNTA120
			cLeaveMsg := 'o encerramento da medição não será concluído'
		Elseif cAmb $ 'MATA120|MATA161'
			cLeaveMsg := 'a gravação do pedido de compras não será concluída'
		Endif
		
		MsgAlert('Operação abandonada, '+cLeaveMsg+', pois não foi informado a capa de despesa.','Abandono de operação pelo usuário')
	Endif
	If .NOT. Empty( cBkp )
		cCadastro := cBkp
	Endif
	SetKey( VK_F4, bF4 )
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | C610Com     | Autor | Robson Gonçalves       | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de capa de despesa - Segunda versão.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function C610Com( cAmb, cFunc )
	Local oDlgCP
	Local oPanel
	Local oScroll
	Local oFont := TFont():New('Calibri',,-15,,.F.)
	Local oEnch
	Local oSay
	
	Local bOk := {|| .T. }
		
	Local nI := 0
	Local nJ := 0
	Local nP := 0
	Local nOpc := 0
	Local nElem := 0
	Local nCH_ITEM := 0
	Local nCH_PERC := 0
	Local nCH_VLRAT := 0
	Local nCH_CC := 0
	Local nCH_CONTA := 0
	Local nCH_ITEMCTA := 0
	Local nCH_CLVL := 0
	Local nDISTINTO := 0

	Local cPanel := ''
	Local cTitulo := ''
	Local cF3 := ''
	Local cValid := ''
	Local cPicture := ''
	Local cWhen := ''
	Local cLeaveMsg := ''
	Local cRelacao := ''
	Local cRateio := ''
	Local cCH_ITEMPD := ''
	Local cC7_COND := ''
	
	Local cNumSC := ''
	
	Local lObrigat := .F.
	Local lMemoria := .F.
	Local lConfirm := .F.
	Local lTemRateio := .F.
	
	Local aCPOS := {}
	Local aField := {}
	Local aX3_CAMPO := {}
	Local aButton := {}
	Local bF4 := SetKey( VK_F4 )
	
	Local aRateio := {}
	Local cVldCondPg := 'U_A610DPAG(0)'
	
	Local lItemProd := .F.
	Local lItemRate := .F.
	
	Local cMV610_006 := 'MV_610_006'
	
	Local aVen := {}
	Local aAreaSC8 := {}
	Local aDadosSC := {}
	Local aSC1 := {}
	Local aBkpFun := { INCLUI, ALTERA }
	Local cKeySC1 := ''
	Local lFirst := .T.
	Local cC8_NUMPED := ''
	Local cC8_ITEMPED := ''
	
	Private cTituloDlg := 'Capa de Despesa'
	Private cDadosBanc := ''
	
	_cFILENT_  := Space( Len( SC7->C7_FILIAL ) )
	_cCNPJ_    := Space( Len( SA2->A2_CGC ) )
	_cCOND_    := Space( Len( SC7->C7_COND ) )
	_cXVENCTO_ := Ctod( Space( 8 ) )
	
	lMSG_PRAZO_VENCTO := .F.
	
	SetKey( VK_F4, NIL )

	//---------------------------------------------------------
	// Verificar se é pedido de compras ou medição de contrato.
	If cAmb $ 'MATA120|CNTA120'
		// -------------------------------------------------------------------------
		// Verificar se o centro de custo não é relativo a remuneração de parceiros.
		If .NOT. ( ;
				Iif( cAmb == 'MATA120',;
				aCOLS[ 1, GdFieldPos( 'C7_CC', aHeader ) ],;
				CNE->( Posicione( 'CNE', 4, xFilial( 'CNE' ) + CND->CND_NUMMED, 'CNE_CC' ) );
				) $ A610RPar() )
			//---------------------------------------------------
			// Atribuir a função a validação do campo C7_XVENCTO.
			cVldCondPg := 'U_A610DPAG(1)'
		Endif
	Endif
	
	If '(1)' $ cVldCondPg
		bOk := {|| Iif( C610Obrig( aCPOS ), Iif( U_A610DPAG( 1, .T. ),( lConfirm := .T., oDlgCP:End() ), NIL ), NIL ) }
	Else
		bOk := {|| Iif( C610Obrig( aCPOS ),( lConfirm := .T., oDlgCP:End() ), NIL ) }
	Endif
	
	If cAmb == 'CNTA120'
		nOpc := 3
		INCLUI := .T.
		ALTERA := .F.
		cNUM_MEDICAO := CND->CND_NUMMED
		cNUM_CONTRAT := CND->CND_CONTRA
		cREV_CONTRAT := CND->CND_REVISA
	Elseif cAmb == 'MATA120'
		nOpc := 4
		INCLUI := .F.
		ALTERA := .T.
		cNUM_PED_COM := cA120Num
	Elseif cAmb == 'MATA161'
		nOpc := 2
		INCLUI := .F.
		ALTERA := .T.
		
		cC8_NUMPED  := Replicate('X',Len(SC8->C8_NUMPED)) 
		cC8_ITEMPED := Replicate('X',Len(SC8->C8_ITEMPED))
		
		cNUM_COTACAO := cA161Num
		
		aAreaSC8 := SC8->( GetArea() )
		SC8->( dbSetOrder( 1 ) )
		SC8->( dbSeek( xFilial( 'SC8' ) + cNUM_COTACAO ) )
		While SC8->( .NOT. EOF() ) .AND. SC8->C8_FILIAL == xFilial( 'SC7' ) .AND. SC8->C8_NUM == cNUM_COTACAO
			If SC8->C8_NUMPED <> cC8_NUMPED .AND. SC8->C8_ITEMPED <> cC8_ITEMPED
				If AScan( aDadosSC, {|e| e[ 4 ] + e[ 5 ] == SC8->( C8_NUMSC + C8_ITEMSC ) } ) == 0 
					aSC1 := SC1->(GetAdvFVal('SC1',{'C1_CC','C1_CONTA','C1_ITEMCTA','C1_CLVL','C1_EMISSAO'},xFilial('SC1')+SC8->(C8_NUMSC+C8_ITEMSC),1))
					AAdd( aDadosSC, {SC8->C8_NUM,SC8->C8_EMISSAO,SC8->C8_COND,SC8->C8_NUMSC,SC8->C8_ITEMSC,aSC1[1],aSC1[2],aSC1[3],aSC1[4],aSC1[5]})
				Endif
			Endif
			SC8->( dbSkip() )
		End
		SC8->( RestArea( aAreaSC8 ) )
	Endif
		
	SXB->( dbSetOrder( 1 ) )
	If .NOT. SXB->( dbSeek( 'FPG610' ) )
		C610FPG( 'FPG610' )
	Endif
	If .NOT. SXB->( dbSeek( 'C7CNPJ' ) )
		C610CNPJ( 'C7CNPJ' )
	Endif
	
	//-----------------------------------------------------------------------------
	// Verificar se existe rateio para os produto ou se há rateio no PC ou medição.
	If cAmb == 'CNTA120'
		A610TemRateio( cAmb, 'CNZ', { xFilial( 'CNZ' ), cNUM_CONTRAT, cREV_CONTRAT, cNUM_MEDICAO }, .T., @aRateio, @lItemRate, @lItemProd )
		If .NOT. lItemRate
			A610TemRateio( cAmb, 'CNE', {xFilial('CNE'),CND->CND_CONTRA,CND->CND_REVISA,CND->CND_NUMERO,CND->CND_NUMMED}, .T., @aRateio, @lItemRate, @lItemProd )
		Endif
	Elseif cAmb == 'MATA120'
		// Há rateio no vetor aCPISCH ou SCH - sim ou não.
		// A conta contábil está rateada no vetor aCPISCH ou SCH.
		A610TemRateio( cAmb, 'ARRAY', {}, .T., @aRateio, @lItemRate, @lItemProd )
		If .NOT. lItemRate
			A610TemRateio( cAmb, 'SCH', { xFilial( 'SCH' ), cNUM_PED_COM }, .T., @aRateio, @lItemRate, @lItemProd )
			If .NOT. lItemProd
				A610TemRateio( cAmb, 'SC7-MEMO', { xFilial( 'SC7' ), cNUM_PED_COM }, .T., @aRateio, @lItemRate, @lItemProd )
			Endif
		Endif
	Elseif cAmb == 'MATA161'
		If Len(aDadosSC) > 0
			For nI := 1 To Len( aDadosSC )
				If .NOT. lItemRate
					A610TemRateio( cAmb, 'SCX', { xFilial( 'SCX' ), aDadosSC[nI,4], aDadosSC[nI,5] }, .T., @aRateio, @lItemRate, @lItemProd )
				Endif
			Next nI
			If .NOT. lItemRate
				For nI := 1 To Len( aDadosSC )
					cNumSC += "( C1_NUM = '" + aDadosSC[ nI, 4 ] + "' AND C1_ITEM = '" + aDadosSC[ nI, 5 ] + "') OR "
				Next nI
				cNumSC := "(" + SubStr( cNumSC, 1, Len( cNumSc )-3 ) + ")"
				A610TemRateio( cAmb, 'SC1', { xFilial( 'SC1' ), cNumSC }, .T., @aRateio, @lItemRate, @lItemProd )
			Endif
		Endif
	Endif
	
	nDISTINTO  := Iif( lItemProd, 2, 0 )
	lTemRateio := ( lItemRate .OR. lItemProd )
	lReplEntid := ( .NOT. lItemRate .AND. .NOT. lItemProd )
	
	cPanel := 'Informe os dados necessários e anexe os documentos relacionados a esta despesa, inclusive a NF '
	cPanel += 'quando existir. Atenção, este processo será auditado pela equipe do planejamento financeiro.'

	//Estrutura do vetor
	//[1] - Campo
	//[2] - Título
	//[3] - F3
	//[4] - Valid
	//[5] - Obrigatório => .T. sim, .F. considerar o que está no SX3.
	//[6] - Picture
	//[7] - When
	//[8] - Uso
	If cAmb == 'CNTA120'
		AAdd( aCPOS,{ 'CND_CONTRA' ,'Nº do Contrato'            ,'', '', .F., '', '.F.', '' } )
		AAdd( aCPOS,{ 'CND_NUMMED' ,'Nº da Medição'             ,'', '', .F., '', '.F.', '' } )
	Elseif cAmb == 'MATA120'
		AAdd( aCPOS,{ 'C7_NUM'    ,'Número do Pedido de Compras','', '', .F., '', '.F.', '' } )
		AAdd( aCPOS,{ 'C7_EMISSAO','Data de emissão'            ,'', '', .F., '', '.F.', '' } )
	Elseif cAmb == 'MATA161'
		AAdd( aCPOS,{ 'C7_NUM'    ,'Número da Cotação de Compras','', '', .F., '', '.F.', '' } )
		AAdd( aCPOS,{ 'C7_EMISSAO','Data de emissão'             ,'', '', .F., '', '.F.', '' } )
	Endif
	
	AAdd( aCPOS,{ 'C7_XREFERE' ,'Mês/Ano Ref.'                     ,'', '', .T., '', '', '' } )
	AAdd( aCPOS,{ 'C7_APBUDGE' ,'Aprovado em budget?'              ,'', '', .T., '', '', '' } )
	AAdd( aCPOS,{ 'C7_XRECORR' ,'Tipo de compra?'                  ,'', '', .T., '', '', '' } )
	AAdd( aCPOS,{ 'C7_CCAPROV' ,'Centro Custo Aprovação'           ,'', '', .T., '', '', '' } )
	AAdd( aCPOS,{ 'C7_DESCCCA' ,'Descric.C.Custo Aprovação'        ,'', '', .F., '', '', '' } )
	AAdd( aCPOS,{ 'C7_CC'      ,'Centro custo da despesa'          ,'', '', .T., '', '', '' } )
	AAdd( aCPOS,{ 'C7_DESCCC'  ,'Descric. C. C. da despesa'        ,'', '', .F., '', '', '' } )
	AAdd( aCPOS,{ 'C7_ITEMCTA' ,'Centro de resultado'              ,'', '', .T., '', '', '' } )
	AAdd( aCPOS,{ 'C7_DEITCTA' ,'Descrição C. Resultado'           ,'', '', .F., '', '', '' } )
	AAdd( aCPOS,{ 'C7_CLVL'    ,'Código do projeto'                ,'', '', .T., '', '', '' } )
	AAdd( aCPOS,{ 'C7_DESCLVL' ,'Descrição do projeto'             ,'', '', .F., '', '', '' } )
	AAdd( aCPOS,{ 'C7_CTAORC'  ,'Conta contábil orçada'            ,'', '', .F., '', '', '' } )
	AAdd( aCPOS,{ 'C7_DESCCOR' ,'Descricao conta orçada'           ,'', '', .F., '', '', '' } )
	AAdd( aCPOS,{ 'C7_DDORC'   ,'Descrição da despesa no Orçamento','', '', .F., '', '', '' } )
	AAdd( aCPOS,{ 'C7_DESCRCP' ,'Descrição'                        ,'', '', .T., '', '', '' } )
	AAdd( aCPOS,{ 'C7_XJUST'   ,'Justificativa'                    ,'', '', .T., '', '', '' } )
	AAdd( aCPOS,{ 'C7_XOBJ'    ,'Objetivo'                         ,'', '', .T., '', '', '' } )
	AAdd( aCPOS,{ 'C7_XADICON' ,'Informação adicional'             ,'', '', .F., '', '', '' } )
	AAdd( aCPOS,{ 'C7_FORMPG'  ,'Forma de pagamento'               ,'', '', .T., '', '', '' } )
	AAdd( aCPOS,{ 'C7_XVENCTO' ,'Vencimento'                       ,'', cVldCondPg, .F., '', '', 'N' } )
	AAdd( aCPOS,{ 'C7_COND'    ,'Cond.de Pagto.'            ,'', '', .F., '', '.F.', '' } )
	AAdd( aCPOS,{ 'C7_DOCFIS'  ,'Nr.Docto. Fiscal'                 ,'', '', .F., '', '', '' } )

	If cAmb == 'CNTA120'
		AAdd( aCPOS,{ 'C7_CNPJ'    ,'CNPJ de entrega?'          ,'', '', .F., '', '', '' } )
		AAdd( aCPOS,{ 'C7_FILENT'  ,'Filial de entrega?'        ,'', '', .F., '', '.F.', '' } )
	Endif
	
	AAdd( aCPOS,{ 'C7_RATCC'   ,'Rateio por centro custo'          ,'', '', .F., '', '.F.', '' } )
	AAdd( aCPOS,{ 'C7_XCONTRA' ,'Contrato'                         ,'', '', .F., '', '.F.', '' } )

	AEval( aCPOS, {|e| AAdd( aX3_CAMPO, e[ 1 ] ) } )
	
	C610ToMemory( aX3_CAMPO, nOpc==3 )
	
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCPOS )
		If SX3->( dbSeek( aCPOS[ nI, 1 ] ) ) .AND. aCPOS[ nI, 8 ] <> 'N'
			cTitulo  := RTrim( Iif( Empty( aCPOS[ nI, 2 ] ), SX3->X3_TITULO, aCPOS[ nI, 2 ] ) )
			cF3      := RTrim( Iif( Empty( aCPOS[ nI, 3 ] ), SX3->X3_F3    , aCPOS[ nI, 3 ] ) )
			cValid   := RTrim( Iif( Empty( aCPOS[ nI, 4 ] ), SX3->X3_VALID , aCPOS[ nI, 4 ] ) )
			If .NOT. Empty( SX3->X3_VLDUSER )
				If .NOT. Empty( cValid )
					cValid := cValid + ' .AND. '
				Endif
				cValid := cValid + RTrim( SX3->X3_VLDUSER )
			Endif
			lObrigat := Iif( aCPOS[ nI, 5 ], aCPOS[ nI, 5 ], X3Obrigat( SX3->X3_CAMPO ) )
			cPicture := RTrim( Iif( Empty( aCPOS[ nI,6]), SX3->X3_PICTURE, aCPOS[ nI, 6 ] ) )
			cWhen    := RTrim( Iif( Empty( aCPOS[ nI,7]), SX3->X3_WHEN, aCPOS[ nI, 7 ] ) )
			
			If SX3->(ExistTrigger( X3_CAMPO ))
				If .NOT. Empty( cValid )
					cValid := RTrim( cValid ) + ' .AND. '
				Endif
				cValid := cValid + 'U_C610Trigger()'
			Endif
			
			AAdd( aField, {cTitulo,;
			SX3->X3_CAMPO,;
			SX3->X3_TIPO,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			cPicture,;
			&('{||' + AllTrim(cValid)+ '}'),;
			lObrigat,;
			SX3->X3_NIVEL,;
			cRelacao,;
			cF3,;
			&('{||' + RTrim(cWhen) + '}'),;
			SX3->X3_VISUAL=='V',;
			.F.,;
			SX3->X3_CBOX,;
			VAL(SX3->X3_FOLDER),;
			.F.,;
			''} )
			
			If RTrim( SX3->X3_CAMPO ) == 'CND_CONTRA'
				M->CND_CONTRA := CND->CND_CONTRA
			Endif
			
			If RTrim( SX3->X3_CAMPO ) == 'CND_NUMMED'
				M->CND_NUMMED := CND->CND_NUMMED
			Endif
			
			If RTrim( SX3->X3_CAMPO ) == 'C7_COND'
				aField[ Len( aField ), 8 ] := .F.
			Endif
			
			// Para o campo rateio informar o conteúdo no campo automaticamente.
			If RTrim( SX3->X3_CAMPO ) == 'C7_RATCC'
				If cAmb $ 'CNTA120|MATA120|MATA161'
					M->C7_RATCC := Iif( lTemRateio, '1', '2' )
				Else
					M->C7_RATCC := '2'
				Endif
			Endif
         
         // Se tem rateio, retirar a obrigatoriedade de preenchimento dos campos da capa de despesa.
			If lTemRateio
				If RTrim( SX3->X3_CAMPO ) $ 'C7_CC|C7_ITEMCTA|C7_CLVL'
					aField[ Len( aField ), 8 ] := .F.
					aField[ Len( aField ), 12 ] := &('{|| .F. }')
					aCPOS[ nI, 5 ] := .F.
				Endif
			Endif
         
         // Para o campo contrato informar automaticamente conforme a origem e não permitir a edição do campo.
			If RTrim( SX3->X3_CAMPO ) == 'C7_XCONTRA'
				M->C7_XCONTRA := Iif( cAmb == 'CNTA120','1','3')
				aField[ Len( aField ), 8 ] := .F.
			Endif
		Endif
	Next nI
	
	//-----------------------------------------------
	// REGRA PARA EDIÇÃO DO CAMPO TIPO DE COMPRA NA 
	// CAPA DE DESPESA CONFORME O CONTRATO.
	//-----------------------------------------------
	// CONTRATO   | CAPA DESPESA | CENTRO DE CUSTO
	//-----------------------------------------------
	// 1=FIXO     | 1=FIXO       | 1=FIXO
	// 2=VARIAVEL | 2=VARIAVEL   | 2=RECORRENTE
	// 3=AMBOS    | 2=VARIAVEL   | 2=RECORRENTE
	// 3=AMBOS    | 3=PONTUAL    | 3=PONTUAL
	//-----------------------------------------------
	If cAmb == 'CNTA120'
		If CN9->CN9_RECORR == '1'     // 1=Fixo
			M->C7_XRECORR := '1'
		Elseif CN9->CN9_RECORR == '2' // 2=Variável
			M->C7_XRECORR := '2'
		Elseif CN9->CN9_RECORR == '3' // 3=Ambos
			M->C7_XRECORR := '2'
		Endif
		If CN9->CN9_RECORR $ '1|2'
			nP := AScan( aField, {|p| p[ 2 ] == 'C7_XRECORR' } )
			// Não permitir a edição do campo.
			If nP > 0
				aField[ nP, 12 ] := &('{|| .F. }')
			Endif
		Endif
	Endif
	
	//------------------------
	// Alimentar as variáveis.
	//------------------------
	If cAmb == 'MATA120'
		M->C7_NUM     := cA120Num
		M->C7_EMISSAO := dA120Emis
		M->C7_COND    := cCondicao
	Endif
	
	If cAmb == 'CNTA120'
		cC7_COND := CN9->( Posicione( 'CN9', 1, xFilial( 'CN9' ) + CND->( CND_CONTRA + CND_REVISA ), 'CN9_CONDPG' ) )
		M->C7_COND := cC7_COND
	Endif

	If cAmb == 'MATA161'
		If Len(aDadosSC)>0
			M->C7_NUM     := aDadosSC[ 1, 4 ]
			M->C7_EMISSAO := aDadosSC[ 1,10 ]
			M->C7_COND    := aDadosSC[ 1, 3 ]
			
			cNUM_SOL_COM := aDadosSC[ 1, 4 ]
		Endif
	Endif

	//-------------------------------------------------------
	// Se não houver rateio, carregar as entidades contábeis.
	//-------------------------------------------------------
	If .NOT. lTemRateio
		//---------------------------------------------------------------------
		// Carregar os campos automaticamente caso haja a informação na origem.
		//---------------------------------------------------------------------
		If cAmb == 'CNTA120'
			CNE->( dbSetOrder( 1 ) )
			If CNE->( MsSeek( xFilial( 'CNE' ) + CND->CND_CONTRA + CND->CND_REVISA + CND->CND_NUMERO + CND->CND_NUMMED ) )
				M->C7_CC := CNE->CNE_CC
				If .NOT. Empty( M->C7_CC )
					M->C7_DESCCC := CTT->( Posicione('CTT',1,xFilial('CTT')+M->C7_CC,'CTT_DESC01') )
				Endif
				M->C7_ITEMCTA := CNE->CNE_ITEMCT
				If .NOT. Empty( M->C7_ITEMCTA )
					M->C7_DEITCTA := CTD->( Posicione('CTD',1,xFilial('CTD')+M->C7_ITEMCTA,'CTD_DESC01') )
				Endif
				M->C7_CLVL := CNE->CNE_CLVL
				If .NOT. Empty( M->C7_CLVL )
					M->C7_DESCLVL := CTH->( Posicione('CTH',1,xFilial('CTH')+M->C7_CLVL,'CTH_DESC01') )
				Endif
			Endif
		Endif
		
		If cAmb == 'MATA120'
			M->C7_CC := aCOLS[ 1, GdFieldPos( 'C7_CC' ) ]
			If .NOT. Empty( M->C7_CC )
				M->C7_DESCCC := CTT->( Posicione('CTT',1,xFilial('CTT')+M->C7_CC,'CTT_DESC01') )
			Endif
			M->C7_ITEMCTA := aCOLS[ 1, GdFieldPos( 'C7_ITEMCTA' ) ]
			If .NOT. Empty( M->C7_ITEMCTA )
				M->C7_DEITCTA := CTD->( Posicione('CTD',1,xFilial('CTD')+M->C7_ITEMCTA,'CTD_DESC01') )
			Endif
			M->C7_CLVL := aCOLS[ 1, GdFieldPos( 'C7_CLVL' ) ]
			If .NOT. Empty( M->C7_CLVL )
				M->C7_DESCLVL := CTH->( Posicione('CTH',1,xFilial('CTH')+M->C7_CLVL,'CTH_DESC01') )
			Endif
			If .NOT. Empty( M->C7_XREFERE )
				M->C7_XREFERE := aCOLS[ 1, GdFieldPos( 'C7_XREFERE' ) ]
			Endif
			If .NOT. Empty( M->C7_XRECORR )
				M->C7_XRECORR := aCOLS[ 1, GdFieldPos( 'C7_XRECORR' ) ]
			Endif
			If .NOT. Empty( M->C7_CCAPROV )
				M->C7_CCAPROV := aCOLS[ 1, GdFieldPos( 'C7_CCAPROV' ) ]
				M->C7_DESCCCA := CTT->( Posicione('CTT',1,xFilial('CTT')+M->C7_CCAPROV,'CTT_DESC01') )
			Endif
			If .NOT. Empty( M->C7_FORMPG )
				M->C7_FORMPG := aCOLS[ 1, GdFieldPos( 'C7_FORMPG' ) ]
			Endif
			If Type('M->C7_DOCFIS') <> 'U'
				If .NOT. Empty( M->C7_DOCFIS )
					M->C7_DOCFIS := aCOLS[ 1, GdFieldPos( 'C7_DOCFIS' ) ]
				Endif
			Endif
			If Type('M->C7_XVENCTO') <> 'U'
				If .NOT. Empty( M->C7_XVENCTO )
					M->C7_XVENCTO := aCOLS[ 1, GdFieldPos( 'C7_XVENCTO' ) ]
					If .NOT. Empty( M->C7_XVENCTO )
						M->C7_XVENCTO := Ctod('')
					Endif
				Endif
			Endif
		Endif
		
		If cAmb == 'MATA161'
			If Len( aDadosSC ) > 0
				For nI := 1 To Len( aDadosSC )
					If .NOT. Empty( aDadosSC[ nI, 6 ] ) //.AND. Empty( M->C7_CC )
						M->C7_CC := aDadosSC[ nI, 6 ]
						M->C7_DESCCC := CTT->( Posicione('CTT',1,xFilial('CTT')+M->C7_CC,'CTT_DESC01') )
					Endif
					If .NOT. Empty( aDadosSC[ nI, 8 ] ) //.AND. Empty( M->C7_ITEMCTA )
						M->C7_ITEMCTA := aDadosSC[ nI, 8 ]
						M->C7_DEITCTA := CTD->( Posicione('CTD',1,xFilial('CTD')+M->C7_ITEMCTA,'CTD_DESC01') )
					Endif
					If .NOT. Empty( aDadosSC[ nI, 9 ] ) //.AND. Empty( M->C7_CLVL )
						M->C7_CLVL := aDadosSC[ nI, 9 ]
						M->C7_DESCLVL := CTH->( Posicione('CTH',1,xFilial('CTH')+M->C7_CLVL,'CTH_DESC01') )
					Endif
				Next nI
			Endif
		Endif
	Endif
	
	// Caso seja integração com o MATA161 - (Análise de Cotação), fazer a atribuição das variáveis.
	If cAmb == 'MATA161
		SC1->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aDadosSC )
			If	cKeySC1 <> aDadosSC[ nI, 4 ] + aDadosSC[ nI, 5 ]
				cKeySC1 := aDadosSC[ nI, 4 ] + aDadosSC[ nI, 5 ]
				If SC1->( dbSeek( xFilial( 'SC1' ) + cKeySC1 ) )
					If	lFirst
						lFirst := .F.
						M->C7_APBUDGE := SC1->C1_BUDGET
						M->C7_CTAORC  := SubStr( SC1->C1_CTAORC, 1, At('-',SC1->C1_CTAORC)-1 )
						M->C7_DESCCOR := SubStr( SC1->C1_CTAORC, At('-',SC1->C1_CTAORC)+1 )
					Endif
					M->C7_DDORC += Iif(Empty(M->C7_DDORC),'',CRLF) + AllTrim(SC1->C1_DESCRDP)
					M->C7_XJUST += Iif(Empty(M->C7_XJUST),'',CRLF) + AllTrim(SC1->C1_JUSTIF) + Iif(Empty(SC1->C1_PQ_ESEM),'', CRLF + AllTrim(SC1->C1_PQ_ESEM)) 
				Endif
			Endif
		Next nI
	Endif
	
	//-------------------------------------------------------------------------------------
	// Se a origem for Gestão de Contratos, verificar se houve pedido de compras 
	// excluído, se houver capturar os dados para a capa de despesa do PC que foi excluído.
	If cAmb == 'CNTA120'
		A610LoadDel()
	Endif
	
	//----------------------------------------------------------------------------------
	// Verificar o parâmetro se é para alimentar o campo Vencimento conforme a condição.
	If .NOT. GetMv( cMV610_006, .T. )
		CriarSX6( cMV610_006, 'N', 'HABILITAR PREENCHIMENTO DO VENCIMENTO AUTOMATICO. 0=DESABILITADO E 1=HABILITADO - ROTINA CSFA610.prw', '0' )
	Endif
	If GetMv( cMV610_006, .F. ) == 1
		M->C7_XVENCTO := A610SCond()
	Endif
	
	DEFINE MSDIALOG oDlgCP TITLE cTituloDlg FROM 0,0 TO 400,640 PIXEL STYLE DS_MODALFRAME STATUS
	oDlgCP:lEscClose := .F.
		
	oPanel := TPanel():New(0,0,,oDlgCP,oFont,.T.,,,RGB(249,176,116),1000,18,.F.,.F.)
	oPanel:Align := CONTROL_ALIGN_TOP
		
	oSay := TSay():New(0,0,{|| cPanel},oPanel,,oFont,.T.,.F.,.F.,.T.,CLR_BLUE,,GetTextWidth(0,cPanel),17,.F.,.F.,.F.,.F.,.F.)
	oSay:Align := CONTROL_ALIGN_TOP
		
	oScroll := TScrollBox():New(oDlgCP,1,1,1000,1000,.T.,.F.,.F.)
	oScroll:Align := CONTROL_ALIGN_ALLCLIENT
		
	oEnch := MsMGet():New(	/*cAlias*/,;
										/*nRecNo*/,;
										nOpc,;
										/*aCRA*/,;
										/*cLetras*/,;
										/*cTexto*/,;
										aCPOS,;
										/*aPos*/,;
										/*aAlterEnch*/,;
										/*nModelo*/,;
										/*nColMens*/,;
										/*cMensagem*/,;
										/*cTudoOk*/,;
										oDlgCP,;
										/*lF3*/,;
										lMemoria,;
										/*lColumn*/,;
		        						/*caTela*/,;
		        						/*lNoFolder*/,;
		        						/*lProperty*/,;
		        						aField,;
		        						/*aFolder*/,;
		        						/*lCreate*/,;          
		        						/*lNoMDIStretch*/,;
		        						/*cTela*/)   
		oEnch:oBox:Align := CONTROL_ALIGN_ALLCLIENT
		
		If     cAmb == 'CNTA120' ; AAdd( aButton,{ 'CLIPS'  ,{|| MsDocument('CND',CND->(RecNo()),1) }, 'Anexar documentos', 'Anexar doctos.' } )
		Elseif cAmb == 'MATA120' ; AAdd( aButton,{ 'CLIPS'  ,{|| MsDocument('SC7',CN7->(RecNo()),1) }, 'Anexar documentos', 'Anexar doctos.' } )
		Endif
	ACTIVATE MSDIALOG oDlgCP CENTER ON INIT EnchoiceBar( oDlgCP, bOK,{|| oDlgCP:End()}, ,aButton )
	
	If lConfirm
		_cXREFERE_  := M->C7_XREFERE
		_cAPBUDGE_  := M->C7_APBUDGE
		_cXRECORR_  := M->C7_XRECORR
		_cCCAPROV_  := M->C7_CCAPROV
		_cDESCCCA_  := M->C7_DESCCCA
		_cCC_       := M->C7_CC
		_cDESCCC_   := M->C7_DESCCC
		_cITEMCTA_  := M->C7_ITEMCTA
		_cDEITCTA_  := M->C7_DEITCTA
		_cCTAORC_   := M->C7_CTAORC
		_cDESCCOR_  := M->C7_DESCCOR
		_cDDORC_    := M->C7_DDORC
		_cCLVL_     := M->C7_CLVL
		_cDESCLVL_  := M->C7_DESCLVL
		_cRATCC_    := M->C7_RATCC
		_cXCONTRA_  := M->C7_XCONTRA
		_cDESCRCP_  := M->C7_DESCRCP
		_cXJUST_    := M->C7_XJUST
		_cXOBJ_     := M->C7_XOBJ
		_cXADICON_  := RTrim( M->C7_XADICON ) + Iif( Empty( cDadosBanc ), '', CRLF + cDadosBanc )
		
		If Type( '_cCOND_' ) <> 'U' .AND. Empty( _cCOND_ )
			_cCOND_ := M->C7_COND
		Endif
		
		If Type( 'cC7_COND' ) <> 'U' .AND. Empty( cC7_COND )
			cC7_COND := _cCOND_ 
		Endif

		If Type( 'cCondicao' ) <> 'U' .AND. Empty( cCondicao )
			cCondicao := _cCOND_ 
		Endif
				
		U_A610Save( nDISTINTO, M->C7_APBUDGE, lItemProd, lItemRate, M->C7_CTAORC )
		
	   	If cAmb $ 'CNTA120|MATA120|MATA161'
	   		If cAmb == 'CNTA120'
	   			_cXADICON_ := AllTrim( _cXADICON_ ) + CRLF + 'Contrato: ' +  CND->CND_CONTRA + ' - Medição: ' + CND->CND_NUMMED
	   		Elseif cAmb == 'MATA161'
	   			_cXADICON_ := AllTrim( _cXADICON_ ) + CRLF + 'Cotação: ' + SC8->C8_NUM + CRLF + 'Solicitação de compras: ' + SC8->C8_NUMSC
	   		Endif
	   	Endif		
   	
	   	_cFORMPG_ := M->C7_FORMPG
		_cDOCFIS_ := M->C7_DOCFIS
      
		If cAmb == 'CNTA120'
			// Está vazio a STATIC e não está vazio a MEMVAR
			If Empty( _cCNPJ_ ) .AND. .NOT. Empty( M->C7_CNPJ ) 
				_cCNPJ_ := M->C7_CNPJ
			Endif
			If Empty( _cCOND_ ) .AND. .NOT. Empty( M->C7_COND )
				_cCOND_ := M->C7_COND
			Endif
			If Empty( _cXVENCTO_ ) .AND. .NOT. Empty( M->C7_XVENCTO )
				_cXVENCTO_ := M->C7_XVENCTO
			Endif
			If Empty( _cFILENT_ ) .AND. .NOT. Empty( M->C7_FILENT )
				_cFILENT_ := M->C7_FILENT
			Endif
		Endif
		
		cNUM_CONTRAT := CND->CND_CONTRA
		cREV_CONTRAT := CND->CND_REVISA
		cNUM_MEDICAO := CND->CND_NUMMED
		
		// É preciso calcular a data de vencimento de alguma forma.
		If .NOT. Empty( _cCOND_ ) .AND. Empty( _cXVENCTO_ )
			aVen := Condicao( 1000, _cCOND_, , MsDate() )
			_cXVENCTO_ := aVen[ 1, 1 ] 
		Endif
		
		If Type( 'cCondicao' ) <> 'U' .AND. .NOT. Empty( cCondicao ) .AND. Empty( _cXVENCTO_ )
			aVen := Condicao( 1000, cCondicao, , MsDate() )
			_cXVENCTO_ := aVen[ 1, 1 ] 
		Endif
		
		If .NOT. Empty( cC7_COND ) .AND. Empty( _cXVENCTO_ )
			aVen := Condicao( 1000, cC7_COND, , MsDate() )
			_cXVENCTO_ := aVen[ 1, 1 ] 
		Endif
		
		If Type( 'M->C7_COND' ) <> 'U' .AND. .NOT. Empty( M->C7_COND ) .AND. Empty( _cXVENCTO_ )
			aVen := Condicao( 1000, M->C7_COND, , MsDate() )
			_cXVENCTO_ := aVen[ 1, 1 ] 
		Endif

		If cAmb == 'MATA120'
			U_A610COLS()
		Endif
	Else
		_cXREFERE_  := ''
		_cAPBUDGE_  := ''
		_cCONTA_    := ''
		_cXRECORR_  := ''
		_cCCAPROV_  := ''
		_cDESCCCA_  := ''
		_cCC_       := ''
		_cDESCCC_   := ''
		_cITEMCTA_  := ''
		_cDEITCTA_  := ''
		_cCTAORC_   := ''
		_cDESCCOR_  := ''
		_cDDORC_    := ''
		_cCLVL_     := ''
		_cDESCLVL_  := ''
		_cRATCC_    := ''
		_cXCONTRA_  := ''
		_cXJUST_    := ''
		_cDESCRCP_  := ''
		_cXOBJ_     := ''
		_cXADICON_  := ''
		_cFORMPG_   := ''
		_cDOCFIS_   := ''
		_cCOND_     := ''
		_cXVENCTO_  := Ctod( Space( 8 ) )
		_cFILENT_   := ''
		_cCNPJ_     := ''
		
		If cAmb == 'CNTA120'
			cLeaveMsg := 'o encerramento da medição não será concluído'
		Elseif cAmb $ 'MATA120|MATA161'
			cLeaveMsg := 'a gravação do pedido de compras não será concluída'
		Endif
		
		MsgAlert('Operação abandonada, '+cLeaveMsg+', pois não foi informado a capa de despesa.','Abandono de operação pelo usuário')
	Endif	
	
	INCLUI := aBkpFun[ 1 ]
	ALTERA := aBkpFun[ 2 ]
	
	SetKey( VK_F4, bF4 )	
Return( lConfirm )

//--------------------------------------------------------------------------
// Rotina | A610LoadDel  | Autor | Robson Gonçalves      | Data | 11/01/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar se a medição em questão já houve PC 
//        | excluído, se houver capturar os dados para capa de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610LoadDel()
	Local cSQL := ''
	Local cAux1 := ''
	Local cAux2 := ''
	Local cTRB := GetNextAlias()
	Local aArea := SC7->( GetArea() )
	
	cSQL := "SELECT MAX( R_E_C_N_O_ ) AS SC7_RECNO "
	cSQL += "FROM   "+RETSQLNAME('SC7')+"  "
	cSQL += "WHERE  C7_FILIAL = "+ValToSQL( CND->CND_FILIAL )+" "
	cSQL += "       AND C7_CONTRA = "+ValToSQL( CND->CND_CONTRA )+" "
	cSQL += "       AND C7_CONTREV = "+ValToSQL( CND->CND_REVISA )+" "
	cSQL += "       AND C7_MEDICAO = "+ValToSQL( CND->CND_NUMMED )+" "
	cSQL += "       AND C7_PLANILH = "+ValToSQL( CND->CND_NUMERO )+" "
	//----------------------------------------------------------------------------------------------------------------------------------------
	cSQL += "       AND D_E_L_E_T_ = '*' "  // <------------ TRAZER SOMENTE REGISTRO EXCLUÍDO PARA EFETUAR CÓPIA DOS DADOS DA CAPA DE DESPESA.
	//----------------------------------------------------------------------------------------------------------------------------------------
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	
	If (cTRB)->(.NOT. BOF() ) .AND. (cTRB)->(.NOT. EOF() )
		SC7->( dbGoTo( (cTRB)->SC7_RECNO ) )
		If SC7->( RecNo() ) == (cTRB)->SC7_RECNO
			M->C7_XREFERE := SC7->C7_XREFERE
			M->C7_APBUDGE := SC7->C7_APBUDGE
			M->C7_XRECORR := SC7->C7_XRECORR
			M->C7_CCAPROV := SC7->C7_CCAPROV
			M->C7_DESCCCA := CTT->( Posicione( 'CTT', 1, xFilial( 'CTT' ) + M->C7_CCAPROV, 'CTT_DESC01' ) )
			M->C7_CC      := SC7->C7_CC
			M->C7_DESCCC  := CTT->( Posicione( 'CTT', 1, xFilial( 'CTT' ) + M->C7_CC     , 'CTT_DESC01' ) )
			M->C7_ITEMCTA := SC7->C7_ITEMCTA
			M->C7_DEITCTA := CTD->( Posicione( 'CTD', 1, xFilial( 'CTD' ) + M->C7_ITEMCTA, 'CTD_DESC01' ) )
			M->C7_CLVL    := SC7->C7_CLVL
			M->C7_DESCLVL := CTH->( Posicione( 'CTH', 1, xFilial( 'CTH' ) + M->C7_CLVL,    'CTH_DESC01' ) )
			M->C7_CTAORC  := SC7->C7_CTAORC
			M->C7_DESCCOR := CT1->( Posicione( 'CT1', 1, xFilial( 'CT1' ) + M->C7_CTAORC,  'CT1_DESC01' ) )
			M->C7_DDORC   := SC7->C7_DDORC
			M->C7_RATCC   := SC7->C7_RATCC
			M->C7_XCONTRA := SC7->C7_XCONTRA
			M->C7_DESCRCP := SC7->C7_DESCRCP
			M->C7_XJUST   := SC7->C7_XJUST
			M->C7_XOBJ    := SC7->C7_XOBJ
			M->C7_FORMPG  := SC7->C7_FORMPG
			M->C7_DOCFIS  := SC7->C7_DOCFIS
			M->C7_COND    := SC7->C7_COND
			M->C7_CNPJ    := SC7->C7_CNPJ
			M->C7_FILENT  := SC7->C7_FILENT
		      
			cAux1 := 'Contrato: ' +  AllTrim( SC7->C7_CONTRA ) + ' - Medição: ' + AllTrim( SC7->C7_MEDICAO )
			If cAux1 $ SC7->C7_XADICON
				cAux2 := StrTran( SC7->C7_XADICON, cAux1, '' )
				M->C7_XADICON := cAux2
			Endif
		Endif
	Endif
	(cTRB)->(dbCloseArea())
	RestArea( aArea )
Return

//--------------------------------------------------------------------------
// Rotina | A610SCond    | Autor | Robson Gonçalves      | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para retornar a data do vencimento conforme a condição de
//        | pagamento do pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610SCond()
	Local aVenc := {}
	Local dVenc := Ctod('')
	Local nVlrPC := 0	
	// Existe o vetor?
	If Type( 'aValores' ) == 'A'
		// O vetor possui mais de 5 elementos?
		If Len( aValores ) >= 6
			// Elemento seis é onde está armazenado o valor total do PC.
			nVlrPC := aValores[ 6 ]
		Endif
	Endif
	// nPar1 = nValorTotal - coloquei um valor fixo apenas para chamar a rotina.
	// cPar2 = cCodigoCondicaoPagamento
	// nPar3 = nValorIpi
	// dPar4 = dDataEmissao
	// nPar5 = nValorSolidario
	aVenc := Condicao( Iif( nVlrPC<>0, nVlrPC, 1000 ), M->C7_COND, 0.00, Iif( Type( 'dA120Emis' )=='U', MsDate(), dA120Emis ), 0.00 )
	If ValType( aVenc[ 1, 1 ] ) == 'D' .AND. .NOT. Empty( aVenc[ 1, 1 ] )
		dVenc := aVenc[ 1, 1 ]
	Else
		dVenc := MsDate() + 30
	Endif
Return( dVenc )

//--------------------------------------------------------------------------
// Rotina | A610Cond     | Autor | Robson Gonçalves      | Data | 26/10/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para tentar determinar o código da condição de pagamento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Cond()
	Local lRet := .T.
	Local cSQL := ''
	Local cTRB := 'WORK_AREA'
	If .NOT. Empty( M->C7_EMISDOC ) .AND. .NOT. Empty( M->C7_XVENCTO )
		cSQL := "SELECT E4_CODIGO "
		cSQL += "FROM   "+RetSqlName( 'SE4' ) + " SE4 "
		cSQL += "WHERE  E4_FILIAL = "+ValToSql( xFilial( 'SE4' ) ) + " "
		cSQL += "       AND E4_COND = " + ValToSql( LTrim( Str( M->C7_XVENCTO - M->C7_EMISDOC ) ) ) + " "
		cSQL += "       AND ( E4_DDD = ' ' OR E4_DDD = 'L' ) "
		cSQL += "       AND E4_MSBLQL <> '1' "
		cSQL += "       AND SE4.D_E_L_E_T_ = ' ' "
		cSQL := ChangeQuery( cSQL )
		If Select( cTRB ) > 0
			(cTRB)->( dbCloseArea() )
		Endif
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), cTRB, .T., .T.)
		If (cTRB)->(.NOT. BOF() ) .AND. (cTRB)->(.NOT. EOF() )
			M->C7_COND := (cTRB)->E4_CODIGO
		Else
			lRet := .F.
			MsgInfo(cFONT+'Conforme a data de emissão e vencimento informados,<br>'+;
			'não foi possível localizar um código de condição de pagamento.<br>Não será possível seguir.'+cNOFONT,'Localizar condição de pagamento')
		Endif
		(cTRB)->( dbCloseArea() )
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | C610ToMemory | Autor | Robson Gonçalves      | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para carregar as MEMVAR.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function C610ToMemory( aFields, lInsert )
	Local nI := 0
	Local cCpo := ''
	Local lInitPad := .T.
	
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aFields )
		SX3->( dbSeek( aFields[ nI ] ) )
		If lInsert
			_SetOwnerPrvt( Trim( SX3->X3_CAMPO ), CriaVar( Trim( SX3->X3_CAMPO ), lInitPad ) )
		Else
			If SX3->X3_CONTEXT == 'V'
				_SetOwnerPrvt( Trim( SX3->X3_CAMPO ), CriaVar( Trim( SX3->X3_CAMPO ), lInitPad ) )
			Else
				cCpo := ( SX3->X3_ARQUIVO + '->' + Trim( SX3->X3_CAMPO ) )
				_SetOwnerPrvt(Trim(SX3->X3_CAMPO),&cCpo)
			Endif
		Endif
	Next nI
Return

//--------------------------------------------------------------------------
// Rotina | C610When    | Autor | Robson Gonçalves       | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para avaliar a edição do campo.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function C610When( cField )
	Local lRet := .T.
	Local lMATA120 := ( FunName() == 'MATA120' )
	
	If cField == 'C7_CTAORC'
		// Atribuir falso para o retorno do When quando atender a condição.
		If lMATA120
			lRet := ( aCOLS[ n, GdFieldPos( 'C7_APBUDGE' ) ] == '1' )
		Else
			lRet := ( M->C7_APBUDGE == '1' )
		Endif
		
		// Limpar o campo caso o usuário modifique a opção do campo.
		If .NOT. lRet
			If lMATA120
				aCOLS[ n, GdFieldPos( 'C7_CTAORC' ) ]  :=  Space( Len( SC7->C7_CTAORC ) )
				aCOLS[ n, GdFieldPos( 'C7_DESCCOR' ) ] :=  CriaVar('C7_DESCCOR',.F.)
			Else
				M->C7_CTAORC  := Space( Len( SC7->C7_CTAORC ) )
				M->C7_DESCCOR :=  CriaVar('C7_DESCCOR',.F.)
			Endif
		Endif
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | C610Trigger | Autor | Robson Gonçalves       | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para executar os gatilhos dos campos.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function C610Trigger()
	Local aArea := GetArea()
	Local cMemVar := ''
	Local cCampo := ''
	Local cResult := ''
	Local cMacro := ''
	Local nSavOrd := 0
	Local lRet := .T.
	
	cMemVar := ReadVar()
	cCampo := RTrim( SubStr( cMemVar, 4 ) )
	
	BEGIN SEQUENCE
		SX7->( dbSetOrder( 1 ) )
		SX7->( dbSeek( cCampo ) )
		While RTrim( SX7->X7_CAMPO ) == cCampo
			If SX7->X7_SEEK == 'S'
				DbSelectArea(SX7->X7_ALIAS)
				nSavOrd := IndexOrd()
				DbSetOrder(SX7->X7_ORDEM)
				DbSeek(&(SX7->X7_CHAVE))
				DbSetOrder(nSavOrd)
				DbSelectArea('SX7')
				cResult := &(SX7->X7_REGRA)
				cMacro := 'M->'+SX7->X7_CDOMIN
				If ValType(cResult) == 'C'
					cResult	:= TriggerSize(SX7->X7_CDOMIN,cResult)
					&cMacro := cResult
				Else
					&cMacro := cResult
					cResult := TriggerPict(SX7->X7_CDOMIN,cResult)
				EndIf			
			Endif
			SX7->(DbSkip())
		End
	END SEQUENCE
	RestArea( aArea )
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | C610Obrig   | Autor | Robson Gonçalves       | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina p/ verificar se os campos obrigatórios foram preenchidos.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function C610Obrig( aCPOS )
	Local lRet := .T.
	Local nI := 0
	Local cCpo := ''
	Local cTitulo := 'Validação de campos'
	For nI := 1 To Len( aCPOS )
		If aCPOS[nI,5]
			cCpo := 'M->'+aCPOS[nI,1]
			If Empty( &(cCpo) )
				MsgInfo('O campo ' + cFONT + Upper( aCPOS[ nI, 2 ] ) + cNOFONT + ' é de preenchimento obrigatório.',cTitulo)
				lRet := .F.
				Exit
			Endif
		Endif
	Next nI
	
	If lRet
		If M->C7_APBUDGE == '1'
			If Empty( M->C7_CTAORC )
				MsgAlert(cFONT+'Atenção'+cNOFONT+;
				'<br><br>Despesa aprovada em budget é obrigatório informar o código da Conta Contábil Orçada,<br> por favor, preencher esta informação.',;
				cTitulo)
				lRet := .F.
		   Endif
		Endif
	Endif
Return(lRet)

//--------------------------------------------------------------------------
// Rotina | A610VFPg    | Autor | Robson Gonçalves       | Data | 15/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina p/criticar forma de pagto. Acionada pelo campo C7_FORMPG.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610VFPg()
	Local aPar := {}
	Local aRet := {}
	Local aSA2 := {}
	Local cAgenc := Space(6)
	Local cBanco := Space(3)
	Local cConta := Space(15)
	Local cMV610_013 := 'MV_610_013'
	Local cXB_ALIAS := 'C1V610'
	Local cFunName := ''
	Local cKeySA2 := ''
	
	//----------------------------------------------
	// Se for automático não executar as instruções.
	If IsBlind()
		Return( .T. )
	Endif
	
	cFunName := FunName()
	
	SX5->( dbSetOrder( 2 ) )
	
	If .NOT. SX5->( dbSeek( xFilial( 'SX5' ) + '24' + M->C7_FORMPG ) )
		MsgInfo('A informação para o campo ' + cFONT + 'FORMA DE PAGAMENTO' + cNOFONT + ' não está consistente.','Validação de campo')
		Return(.F.)
	Endif
	
	If .NOT. GetMv( cMV610_013, .T. )
		CriarSX6( cMV610_013, 'C', 'FORMA DE PAGTO QUE EXIGE DADOS BANCARIOS. ROTINA CSFA610.PRW', 'CR' )
	Endif
	
	cMV610_013 := GetMv( cMV610_013, .F. )
	
	If RTrim( SX5->X5_CHAVE ) $ cMV610_013
		A610C1V( cXB_ALIAS )
		
		If (cFunName $ 'MATA120/MATA121')
			cKeySA2 := cA120Forn + cA120Loj
		Elseif cFunName == 'CNTA120'
			cKeySA2 := CND->CND_FORNEC + CND->CND_LJFORN
		Elseif cFunName == 'CRPA031' .Or. cFunName == "CRPA079"
			cKeySA2 := cA120Forn + cA120Loj
		Endif
		
		aSA2 := SA2->( GetAdvFVal( 'SA2', { 'A2_BANCO', 'A2_AGENCIA', 'A2_DVAGEN', 'A2_NUMCON', 'A2_DGCTAC' }, xFilial( 'SA2' ) + cKeySA2 , 1 ) )
		
		If .NOT. Empty( aSA2[ 1 ] )
			cBanco := aSA2[ 1 ]
		Endif
		
		If .NOT. Empty( aSA2[ 2 ] )
			cAgenc := RTrim( aSA2[ 2 ] ) + Iif( Empty( aSA2[ 3 ] ), '', '-' + aSA2[ 3 ] )
		Endif
		
		If .NOT. Empty( aSA2[ 4 ] )
			cConta := RTrim( aSA2[ 4 ] ) + Iif( Empty( aSA2[ 5 ] ), '', '-' + aSA2[ 5 ] )
		Endif
		
		AAdd( aPar, { 9, 'Informe abaixo os dados bancários', 150  , 7,.T.})
		AAdd( aPar, { 1, 'Banco'         ,cBanco,'','',cXB_ALIAS,'',50,.T.})
		AAdd( aPar, { 1, 'Agência'       ,cAgenc,'','',''       ,'',50,.T.})
		AAdd( aPar, { 1, 'Conta corrente',cConta,'','',''       ,'',80,.T.})
		
		If ParamBox( aPar, 'Parâmetros', @aRet,,,,,,,, .F., .F. )
			cDadosBanc := 'Crédito em C/C'+CRLF+'Banco: '+aRet[2]+CRLF+'Agência: '+RTrim(aRet[3])+CRLF+'Conta corrente: '+RTrim(aRet[4])
 		Endif
	Endif 
Return(.T.)

//--------------------------------------------------------------------------
// Rotina | C610FPG     | Autor | Robson Gonçalves       | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina ausiliar para criar consulta padrão no dicionário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function C610FPG( cXB_ALIAS )
	Local aDados := {}
	AAdd(aDados,{cXB_ALIAS,'1','01','RE','Forma Pagto.','Forma Pagto.','Forma Pagto.','SX5'           ,''})
	AAdd(aDados,{cXB_ALIAS,'2','01','01','Forma Pagto.','Forma Pagto.','Forma Pagto.','U_C610FPgto()' ,''})
	AAdd(aDados,{cXB_ALIAS,'5','01',''  ,''            ,''            ,''            ,'SX5->X5_DESCRI',''})
	CriaSXB( aDados )
Return

//--------------------------------------------------------------------------
// Rotina | C610CNPJ | Autor | Robson Gonçalves          | Data | 28.03.2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para criar consulta padrão no dicionário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function C610CNPJ( cXB_ALIAS )
	Local aDados := {}
	AAdd(aDados,{cXB_ALIAS,'1','01','RE','CNPJ Filial','CNPJ Filial','CNPJ Filial','SX5'            ,''})
	AAdd(aDados,{cXB_ALIAS,'2','01','01','CNPJ Filial','CNPJ Filial','CNPJ Filial','U_A610Company()',''})
	AAdd(aDados,{cXB_ALIAS,'5','01',''  ,''            ,''            ,''         ,'U_A610RetComp()',''})
	CriaSXB( aDados )
Return

//--------------------------------------------------------------------------
// Rotina | A610C1V  | Autor | Robson Gonçalves          | Data | 18.01.2017
//--------------------------------------------------------------------------
// Descr. | Rotina para atribuir ao vetor dados para criar SX1 da C1V.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610C1V( cXB_ALIAS )
	Local aDADOS := {}
	AAdd( aDADOS, { cXB_ALIAS,"1","01","DB","Inst. Financeira","Inst. Financeira","Inst. Financeira","C1V","" } )
	AAdd( aDADOS, { cXB_ALIAS,"2","01","01","Bancos","Bancos","Banks","","" } )
	AAdd( aDADOS, { cXB_ALIAS,"2","02","02","Descrição","Descripcion","Description","","" } )
	AAdd( aDADOS, { cXB_ALIAS,"4","01","01","Bancos","Bancos","Banks","C1V_CODIGO","" } )
	AAdd( aDADOS, { cXB_ALIAS,"4","01","02","Descrição","Descripcion","Description","C1V_DESCRI","" } )
	AAdd( aDADOS, { cXB_ALIAS,"4","02","01","Descrição","Descripcion","Description","C1V_DESCRI","" } )
	AAdd( aDADOS, { cXB_ALIAS,"4","02","02","Bancos","Bancos","Banks","C1V_CODIGO","" } )
	AAdd( aDADOS, { cXB_ALIAS,"5","01","","","","","C1V->C1V_CODIGO","" } )
	CriaSXB( aDADOS )
Return

//--------------------------------------------------------------------------
// Rotina | CriaSXB     | Autor | Robson Gonçalves       | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para criar consulta padrão no dicionário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function CriaSXB(aDados)
	Local aCpoXB := {}
	Local nI := 0
	Local nJ := 0
	aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}
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
Return

//--------------------------------------------------------------------------
// Rotina | C610FPagto  | Autor | Robson Gonçalves       | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de consulta padrão específica.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function C610FPgto()
	Local cSQL := ''
	Local cTRB := ''
	Local nAchou := 0
	Local oPanelAll
	Local oPanelBot
	Local oDlg
	Local oLbx
	Local oConfirm 
	Local oCancel
	Local nPos := 0
	Local lRet := .F.
	
	If Len( aFormaPg ) == 0
		cSQL := "SELECT X5_DESCRI, X5_TABELA, X5_CHAVE "
		cSQL += "FROM   "+RetSqlName("SX5")+" SX5 "
		cSQL += "WHERE  X5_FILIAL = "+ValToSql(xFilial("SX5"))+" "
		cSQL += "       AND X5_TABELA = '24' "
		cSQL += "       AND SX5.D_E_L_E_T_ = ' '"
		cSQL += "ORDER  BY X5_DESCRI "
	
		cTRB := GetNextAlias()
		cSQL := ChangeQuery( cSQL )
		PLSQuery( cSQL, cTRB )
	
		While .NOT. (cTRB)->( EOF() )
			(cTRB)->( AAdd( aFormaPg, { X5_DESCRI, X5_TABELA, X5_CHAVE } ) )
			(cTRB)->( dbSkip() )
		End
		(cTRB)->( dbCloseArea() )
		
		If Len( aFormaPg ) == 0
		   Help(' ',1,'REGNOIS')
		   Return( .F. )
		Endif	
	Endif
	
	nAchou := AScan( aFormaPg, {|fp| RTrim( fp[ 1 ] )==RTrim( M->C7_FORMPG ) } )
	If nAchou == 0
		nAchou := 1
	Endif
	
	DEFINE MSDIALOG oDlg TITLE 'Selecione a Forma de Pagamento' FROM 0,0 TO 270,570 PIXEL
		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		@ 3,4 LISTBOX oLbx VAR nPos FIELDS HEADER 'Forma de pagamento' SIZE 355,80 OF oPanelAll PIXEL NOSCROLL
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aFormaPg )
	   oLbx:bLine:={||{ aFormaPg[ oLbx:nAt, 1 ] } } 
	   oLbx:BlDblClick := {|| ( lRet:= .T., nPos := oLbx:nAt, oDlg:End() ) }
		
		If nAchou > 0
			oLbx:nAt := nAchou
		Endif
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM
		
		@ 1,202 BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION (lRet := .T., nPos := oLbx:nAt, oDlg:End())
		@ 1,245 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTERED
	If lRet
 		M->C7_FORMPG := aFormaPg[ nPos, 1 ]
 		SX5->( dbSetOrder( 1 ) )
 		SX5->( dbSeek( xFilial( 'SX5' ) + '24' + aFormaPg[ nPos, 3 ] ) )
	Endif	
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | C610MesAno   | Autor | Robson Gonçalves       | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para validar o mês e ano informado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function C610MesAno()
	Local lRet := .F.
	Local aAnos := Array(3)
	Local nPos	:= 0
	Local cAno	:= rTrim( cValTochar( Year(dDatabase) - 1 ) )

	aAnos[ 1 ] := Year(dDatabase) - 1
	aAnos[ 2 ] := Year(dDatabase)
	aAnos[ 3 ] := Year(dDatabase) + 1

	If .NOT. Empty( M->C7_XREFERE )
		nPos := aScan( aAnos, { |x| x == Val( SubStr( M->C7_XREFERE, 3, 4 ) ) } )
		lRet := (SubStr( M->C7_XREFERE, 1, 2 ) >= '01' .AND. SubStr( M->C7_XREFERE, 1, 2 ) <= '12' .AND. SubStr( M->C7_XREFERE, 3, 4 ) >= '2015' .And.	nPos > 0 ) .Or. IsInCallStack("U_CRPA031")
		If .NOT. lRet
			MsgAlert(cFONT+'Atenção'+cNOFONT+'<br><br>Mês e ano de referência deverá estar no formato MM/AAAA<br>MM é o número de mês, sendo de 01 a 12<br>AAAA deve ser o número do ano, exemplo a partir de ' + cAno,'Validação Mês/Ano referência')
		Endif
	Else
		lRet := .T.
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A610COLS   | Autor | Robson Gonçalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina para alimentar o aCOLS do pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610COLS()
	If lNewCP610
		C610COLS()
	Else
		B610COLS()
	Endif
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | B610COLS   | Autor | Robson Gonçalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para alimentar o aCOLS do pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function B610COLS()
	Local nI := 0
	For nI := 1 To Len( aCOLS )
		If .NOT. GdDeleted( nI )
			aCOLS[ nI, GdFieldPos('C7_CC') ]      := _cCC_
			aCOLS[ nI, GdFieldPos('C7_ITEMCTA') ] := _cITEMCTA_
			aCOLS[ nI, GdFieldPos('C7_XRECORR') ] := _cXRECORR_
			aCOLS[ nI, GdFieldPos('C7_XREFERE') ] := _cXREFERE_
			aCOLS[ nI, GdFieldPos('C7_CLVL') ]    := _cCLVL_
			aCOLS[ nI, GdFieldPos('C7_XJUST') ]   := _cXJUST_
			aCOLS[ nI, GdFieldPos('C7_XOBJ') ]    := _cXOBJ_
			aCOLS[ nI, GdFieldPos('C7_XCONTRA') ] := _cXCONTRA_
			aCOLS[ nI, GdFieldPos('C7_XADICON') ] := _cXADICON_
			aCOLS[ nI, GdFieldPos('C7_XVENCTO') ] := _cXVENCTO_
			aCOLS[ nI, GdFieldPos('C7_APROV') ]   := CTT->( Posicione( 'CTT', 1, xFilial( 'CTT' ) + _cCC_, 'CTT_XAPROV') )
		Endif
	Next nI
Return

//--------------------------------------------------------------------------
// Rotina | C610COLS   | Autor | Robson Gonçalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para alimentar o aCOLS do pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function C610COLS()
	Local nI := 0
	For nI := 1 To Len(	 aCOLS )
		If .NOT. GdDeleted( nI )
			
			If Empty( _cCNPJ_ )
				If Type('cFilialEnt') <> 'U' .AND. .NOT. Empty( cFilialEnt )  
					_cCNPJ_ := StrTran( StrTran( StrTran( A610NomFil( cFilialEnt, .T. ), '.', '' ), '/', '' ), '-', '' ) 
				Endif
			Endif
			
			aCOLS[ nI, GdFieldPos('C7_XREFERE') ]  := _cXREFERE_
			aCOLS[ nI, GdFieldPos('C7_APBUDGE') ]  := _cAPBUDGE_
			aCOLS[ nI, GdFieldPos('C7_XRECORR') ]  := _cXRECORR_
			aCOLS[ nI, GdFieldPos('C7_CCAPROV') ]  := _cCCAPROV_
			aCOLS[ nI, GdFieldPos('C7_DESCCCA') ]  := _cDESCCCA_
			aCOLS[ nI, GdFieldPos('C7_CTAORC') ]   := _cCTAORC_
			aCOLS[ nI, GdFieldPos('C7_DESCCOR') ]  := _cDESCCOR_
			aCOLS[ nI, GdFieldPos('C7_DDORC') ]    := _cDDORC_
			aCOLS[ nI, GdFieldPos('C7_RATCC') ]    := _cRATCC_
			aCOLS[ nI, GdFieldPos('C7_XCONTRA') ]  := _cXCONTRA_
			aCOLS[ nI, GdFieldPos('C7_DESCRCP') ]  := _cDESCRCP_
			aCOLS[ nI, GdFieldPos('C7_XJUST') ]    := _cXJUST_
			aCOLS[ nI, GdFieldPos('C7_XOBJ') ]     := _cXOBJ_
			aCOLS[ nI, GdFieldPos('C7_XADICON') ]  := _cXADICON_
			aCOLS[ nI, GdFieldPos('C7_FORMPG') ]   := _cFORMPG_
			aCOLS[ nI, GdFieldPos('C7_DOCFIS') ]   := _cDOCFIS_
			aCOLS[ nI, GdFieldPos('C7_XVENCTO') ]  := _cXVENCTO_
			aCOLS[ nI, GdFieldPos('C7_CNPJ') ]     := _cCNPJ_
			
			If lReplEntid
				aCOLS[ nI, GdFieldPos('C7_CC') ]       := _cCC_
				aCOLS[ nI, GdFieldPos('C7_DESCCC') ]   := _cDESCCC_
				aCOLS[ nI, GdFieldPos('C7_ITEMCTA') ]  := _cITEMCTA_
				aCOLS[ nI, GdFieldPos('C7_DEITCTA') ]  := _cDEITCTA_
				aCOLS[ nI, GdFieldPos('C7_CLVL') ]     := _cCLVL_
				aCOLS[ nI, GdFieldPos('C7_DESCLVL') ]  := _cDESCLVL_
			Endif
		Endif
	Next nI
Return

//--------------------------------------------------------------------------
// Rotina | A610Grav   | Autor | Robson Gonçalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina que determinar a rotina que irá gravar os dados da capa
//        | de despesa de compras, vendas e cotação.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Grav( cGestao )
	
	If FunName() == 'CRPA031'
		U_CRPA035()
	ElseIf FunName() == "CRPA079"
		ConsolidadoRemuneracao():gravaCapaDespesa()
	// Pedido de compras.
	Elseif cGestao == 'COM'
		A610Grv120()
	// Pedido de vendas.
	Elseif cGestao == 'VEN'
		A610Grv410()
	// Cotação que gera pedido de compras.
	Elseif cGestao == 'COT'
		A610Grv160()
	Else
		MsgAlert('Tipo de gestão indefinido para o processo do Gstão de Contratos.','CSFA610 | Definição da gestão de necessidade')
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610Grv120 | Autor | Robson Gonçalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina para gravar os dados da capa de despesa no P.Compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Grv120()
	Local cC7_NUM := SC7->C7_NUM
	Local aAreaSC7 := SC7->( GetArea() )
	
	SC7->( dbSetOrder( 1 ) )
	SC7->( MsSeek( xFilial( 'SC7' ) + SC7->C7_NUM ) )
	
	If Empty( _cCNPJ_ ) .AND. .NOT. Empty( SC7->C7_FILENT )
		_cCNPJ_ := _cCNPJ_ := StrTran( StrTran( StrTran( A610NomFil( SC7->C7_FILENT, .T. ), '.', '' ), '/', '' ), '-', '' )
	Endif
	
	While SC7->( .NOT. EOF() ) .AND. SC7->C7_FILIAL == xFilial( 'SC7' ) .AND. SC7->C7_NUM == cC7_NUM
		cNUM_PED_COM := SC7->C7_NUM
		
		SC7->( RecLock( 'SC7', .F. ) )
			If lNewCP610
				SC7->C7_XREFERE  := _cXREFERE_
				SC7->C7_APBUDGE  := _cAPBUDGE_
				SC7->C7_XRECORR  := _cXRECORR_
				SC7->C7_CCAPROV  := _cCCAPROV_
				SC7->C7_CTAORC   := _cCTAORC_
				SC7->C7_DDORC    := _cDDORC_
				SC7->C7_RATCC    := _cRATCC_
				SC7->C7_XCONTRA  := _cXCONTRA_
				SC7->C7_DESCRCP  := _cDESCRCP_
				SC7->C7_XJUST    := _cXJUST_
				SC7->C7_XOBJ     := _cXOBJ_
				SC7->C7_XADICON  := _cXADICON_
				SC7->C7_FORMPG   := _cFORMPG_
				SC7->C7_DOCFIS   := _cDOCFIS_
				SC7->C7_COND     := _cCOND_
				SC7->C7_XVENCTO  := _cXVENCTO_
				SC7->C7_FILENT   := _cFILENT_
				SC7->C7_CNPJ     := _cCNPJ_
				
				If lReplEntid
					SC7->C7_CC       := _cCC_
					SC7->C7_ITEMCTA  := _cITEMCTA_
					SC7->C7_CLVL     := _cCLVL_				
				Endif
			Else
				SC7->C7_CC      := _cCC_
				SC7->C7_ITEMCTA := _cITEMCTA_
				SC7->C7_XRECORR := _cXRECORR_
				SC7->C7_XREFERE := _cXREFERE_
				SC7->C7_CLVL    := _cCLVL_
				SC7->C7_XJUST   := _cXJUST_
				SC7->C7_XOBJ    := _cXOBJ_
				SC7->C7_XCONTRA := _cXCONTRA_
				SC7->C7_XADICON := _cXADICON_
				SC7->C7_XVENCTO := _cXVENCTO_
				SC7->C7_FILENT  := _cFILENT_
				SC7->C7_APROV   := CTT->( Posicione( 'CTT', 1, xFilial( 'CTT' ) + _cCC_, 'CTT_XAPROV') )
			Endif
		SC7->( MsUnLock() )
		SC7->( dbSkip() )
	End
	RestArea( aAreaSC7 )
Return

//--------------------------------------------------------------------------
// Rotina | A610Grv160 | Autor | Robson Gonçalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina de gravação da capa de despesa no pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Grv160()
	Local cMV_610COT := 'MV_610COT'
	
	If .NOT. GetMv( cMV_610COT, .T. )
		CriarSX6( cMV_610COT, 'N', 'HABILITAR O PROCESSO DA CAPA DE DESPESA NO PROCESSO DE COTACAO GERA PEDIDO DE COMPRAS. 0=DESABILITADO E 1=HABILITADO - ROTINA MT160WF.prw', '0' )
	Endif

	cNUM_COTACAO := SC7->C7_NUMCOT
	
	If GetMv( cMV_610COT, .F. ) == 1 // Se o processo estiver habilitado.
		If lNewCP610

			If Empty( _cCNPJ_ ) .AND. .NOT. Empty( SC7->C7_FILENT )
				_cCNPJ_ := _cCNPJ_ := StrTran( StrTran( StrTran( A610NomFil( SC7->C7_FILENT, .T. ), '.', '' ), '/', '' ), '-', '' )
			Endif

			SC7->C7_XREFERE  := _cXREFERE_
			SC7->C7_APBUDGE  := _cAPBUDGE_
			SC7->C7_XRECORR  := _cXRECORR_
			SC7->C7_CCAPROV  := _cCCAPROV_
			SC7->C7_CTAORC   := _cCTAORC_
			SC7->C7_DDORC    := _cDDORC_
			SC7->C7_RATCC    := _cRATCC_
			SC7->C7_XCONTRA  := _cXCONTRA_
			SC7->C7_DESCRCP  := _cDESCRCP_
			SC7->C7_XJUST    := _cXJUST_
			SC7->C7_XOBJ     := _cXOBJ_
			SC7->C7_XADICON  := _cXADICON_
			SC7->C7_FORMPG   := _cFORMPG_
			SC7->C7_DOCFIS   := _cDOCFIS_
			SC7->C7_XVENCTO  := _cXVENCTO_
			SC7->C7_CNPJ     := _cCNPJ_
			
			If lReplEntid
				SC7->C7_CC       := _cCC_
				SC7->C7_ITEMCTA  := _cITEMCTA_
				SC7->C7_CLVL     := _cCLVL_			
			Endif
		Else
			SC7->C7_CC      := _cCC_
			SC7->C7_ITEMCTA := _cITEMCTA_
			SC7->C7_XRECORR := _cXRECORR_
			SC7->C7_XREFERE := _cXREFERE_
			SC7->C7_CLVL    := _cCLVL_
			SC7->C7_XJUST   := _cXJUST_
			SC7->C7_XOBJ    := _cXOBJ_
			SC7->C7_XCONTRA := _cXCONTRA_
			SC7->C7_XADICON := _cXADICON_
			SC7->C7_XVENCTO := _cXVENCTO_
			SC7->C7_APROV   := CTT->( Posicione( 'CTT', 1, xFilial( 'CTT' ) + _cCC_, 'CTT_XAPROV') )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610CapDesp | Autor | Robson Gonçalves       | Data | 13.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina para preparar a visualização da capa de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610CapDesp( cOrigem )
	Local c := ''
	If cOrigem=='MATA097'
		If SCR->CR_TIPO == 'PC'
			A610View( cOrigem )
		Else
			MsgAlert('Somente alçada para pedido de compra é que será possível visualizar a capa de despesa.','MTA097Mnu | Visualizar Capa de Despesa')
		Endif
	Elseif cOrigem=='MATA120'
		A610View( cOrigem )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610View    | Autor | Robson Gonçalves       | Data | 13.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina de visualização da capa de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610View( cOrigem )
	If lNewCP610
		C610View( cOrigem )
	Else
		B610View( cOrigem )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | B610View    | Autor | Robson Gonçalves       | Data | 13.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar de visualização da capa de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function B610View( cOrigem )
	Local cCpox := GetNewPar('MV_XCPOCPR','C7_CC,C7_ITEMCTA,C7_XRECORR,C7_XREFERE,C7_CLVL,C7_XJUST,C7_XOBJ,C7_XCONTRA,C7_XADICON,C7_XVENCTO')
	Local aCpoComp	:= StrTokArr(cCpox, ',')
	Local aPar := {}
	Local aRet := {}
	Local aCbx := {}
	Local nI := 0
	Local cConteudo := ''
	Local cBkp := ''
	Local aArea := { SX3->( GetArea() ) }	
	Local aRecor := {}
	Local aContr := {}
	Local cC7_NUM := ''
	Local nC7_RECNO := 0
	
	nC7_RECNO := SC7->( RecNo() )
	
	If cOrigem == 'MATA097'
		cC7_NUM := RTrim( SCR->CR_NUM )		
	Elseif cOrigem == 'MATA120'
		cC7_NUM := cA120Num
	Endif
	
	SC7->( dbSetOrder( 1 ) )
	If SC7->( MsSeek( xFilial( 'SC7' ) + cC7_NUM ) )
		If Type('cCadastro') <> 'U'
			cBkp := cCadastro
		Else
			Private cCadastro := ''
		Endif
		
		cCadastro := 'Visualizar Capa de despesa'
		
		SX3->( DbSetOrder( 2 ) )
		For nI := 1 To Len( aCpoComp )
			If SX3->( DbSeek( aCpoComp[ nI ] ) )
		
				cConteudo := &( 'SC7->' + aCpoComp[ nI ] )
				
				If SX3->X3_TIPO == 'C' .AND. Empty( SX3->X3_CBOX ) 
					AAdd( aPar,{ 1, RTrim( SX3->X3_DESCRIC ), cConteudo, SX3->X3_PICTURE, SX3->X3_VALID, SX3->X3_F3, '.F.', 50, .F. } )	
				
				Elseif SX3->X3_TIPO == 'D'
					Set( 4, 'dd/mm/yyyy' )
					AAdd( aPar,{ 1, RTrim(SX3->X3_DESCRIC), cConteudo, '99/99/9999', '', '', '.F.', 50, .F. } )
				
				Elseif SX3->X3_TIPO == 'C' .AND. .NOT. Empty( SX3->X3_CBOX )
					aCbx := StrTokArr(SX3->X3_CBOX, ';')
					AAdd( aPar,{ 2, RTrim( SX3->X3_DESCRIC ), Val( cConteudo ), aCbx, 50, '', .F., '.F.' } )
				
				Elseif SX3->X3_TIPO == 'M'
					AAdd( aPar,{ 11 ,RTrim( SX3->X3_DESCRIC ), cConteudo, '', '.F.',  .F. } )
				
				Endif
			Endif
		Next nI
		
		AAdd( aPar, { 1, 'Filial de entrega', xFilial( 'SC7' ), '', 'A120FilEnt( MV_PAR11 )', 'SM0_01', '.F.', 50, .F. } )
		
		AEval( aArea, {|xArea| RestArea( xArea ) } )
		
		ParamBox( aPar, 'Compras', @aRet,,,,,,,,.F.,.F.)
		
		If .NOT. Empty( cBkp )
			cCadastro := cBkp
		Endif
		
		SC7->( dbGoTo( nC7_RECNO ) )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | C610View    | Autor | Robson Gonçalves       | Data | 27/10/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para consultar a capa de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function C610View( cOrigem )
	Local aCPOS := {}
	Local aX3_CAMPO := {}
	Local nI := 0
	Local cTitulo := ''
	Local cF3 := ''
	Local cValid := ''
	Local lObrigat := .F.
	Local lMemoria := .F.
	Local cPicture := ''
	Local cWhen := ''
	Local aField := {}
	Local oDlgCP
	Local cTituloDlg := 'Consultar Capa de Despesa'
	Local oScroll
	Local oEnch 
	Local nOpc := 2
	Local cCR_NUM := ''
	
	If cOrigem == 'MATA097'
		cCR_NUM := RTrim( SCR->CR_NUM )		
	Elseif cOrigem == 'MATA120'
		cCR_NUM := cA120Num
	Endif

	SC7->( dbSetOrder( 1 ) )
	SC7->( dbSeek( xFilial( 'SC7' ) + cCR_NUM ) )
	
	//Estrutura do vetor
	//[1] - Campo
	//[2] - Título
	//[3] - F3
	//[4] - Valid
	//[5] - Obrigatório => .T. sim, .F. considerar o que está no SX3.
	//[6] - Picture
	//[7] - When
	
	AAdd( aCPOS,{ 'C7_NUM'    ,'Número do Pedido de Compras'       ,'', '', .F., '', '.F.','' } )
	AAdd( aCPOS,{ 'C7_EMISSAO','Data de emissão'                   ,'', '', .F., '', '.F.','' } )
	AAdd( aCPOS,{ 'C7_XREFERE' ,'Mês/Ano Ref.'                     ,'', '', .T., '', '','' } )
	AAdd( aCPOS,{ 'C7_APBUDGE' ,'Aprovado em budget?'              ,'', '', .T., '', '','' } )
	AAdd( aCPOS,{ 'C7_XRECORR' ,'Tipo de compra?'                  ,'', '', .T., '', '','' } )
	AAdd( aCPOS,{ 'C7_CCAPROV' ,'Centro Custo Aprovação'           ,'', '', .T., '', '','' } )
	AAdd( aCPOS,{ 'C7_DESCCCA' ,'Descric.C.Custo Aprovação'        ,'', '', .F., '', '','' } )
	AAdd( aCPOS,{ 'C7_CC'      ,'Centro custo da despesa'          ,'', '', .T., '', '','' } )
	AAdd( aCPOS,{ 'C7_DESCCC'  ,'Descric. C. C. da despesa'        ,'', '', .F., '', '','' } )
	AAdd( aCPOS,{ 'C7_ITEMCTA' ,'Centro de resultado'              ,'', '', .T., '', '','' } )
	AAdd( aCPOS,{ 'C7_DEITCTA' ,'Descrição C. Resultado'           ,'', '', .F., '', '','' } )
	AAdd( aCPOS,{ 'C7_CLVL'    ,'Código do projeto'                ,'', '', .T., '', '','' } )
	AAdd( aCPOS,{ 'C7_DESCLVL' ,'Descrição do projeto'             ,'', '', .F., '', '','' } )
	AAdd( aCPOS,{ 'C7_CTAORC'  ,'Conta contábil orçada'            ,'', '', .F., '', '','' } )
	AAdd( aCPOS,{ 'C7_DESCCOR' ,'Descricao conta orçada'           ,'', '', .F., '', '','' } )
	AAdd( aCPOS,{ 'C7_DDORC'   ,'Descrição da despesa no Orçamento','', '', .F., '', '','' } )
	AAdd( aCPOS,{ 'C7_DESCRCP' ,'Descrição'                        ,'', '', .T., '', '','' } )
	AAdd( aCPOS,{ 'C7_XJUST'   ,'Justificativa'                    ,'', '', .T., '', '','' } )
	AAdd( aCPOS,{ 'C7_XOBJ'    ,'Objetivo'                         ,'', '', .T., '', '','' } )
	AAdd( aCPOS,{ 'C7_XADICON' ,'Informação adicional'             ,'', '', .F., '', '','' } )
	AAdd( aCPOS,{ 'C7_FORMPG'  ,'Forma de pagamento'               ,'', '', .T., '', '','' } )
	AAdd( aCPOS,{ 'C7_XVENCTO' ,'Vencimento'                       ,'', '', .T., '', '','N' } )
	AAdd( aCPOS,{ 'C7_DOCFIS'  ,'Nr.Docto. Fiscal'                 ,'', '', .F., '', '','' } )
	AAdd( aCPOS,{ 'C7_COND'    ,'Cond.de Pagto.'                   ,'', '', .F., '', '.F.','' } )
	AAdd( aCPOS,{ 'C7_FILENT'  ,'Filial de entrega?'               ,'', '', .F., '', '','' } )
	AAdd( aCPOS,{ 'C7_RATCC'   ,'Rateio por centro custo'          ,'', '', .F., '', '.F.','' } )
	AAdd( aCPOS,{ 'C7_XCONTRA' ,'Contrato'                         ,'', '', .F., '', '.F.','' } )	
	AEval( aCPOS, {|e| AAdd( aX3_CAMPO, e[ 1 ] ) } )
	
	C610ToMemory( aX3_CAMPO, .F. )

	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCPOS )
		If SX3->( dbSeek( aCPOS[ nI, 1 ] ) )  .AND. aCPOS[ nI, 8 ] <> 'N'
			cTitulo  := RTrim( Iif( Empty( aCPOS[ nI, 2 ] ), SX3->X3_TITULO, aCPOS[ nI, 2 ] ) )
			cF3      := RTrim( Iif( Empty( aCPOS[ nI, 3 ] ), SX3->X3_F3    , aCPOS[ nI, 3 ] ) )
			cValid   := RTrim( Iif( Empty( aCPOS[ nI, 4 ] ), SX3->X3_VALID , aCPOS[ nI, 4 ] ) )
			lObrigat := Iif( aCPOS[ nI, 5 ], aCPOS[ nI, 5 ], X3Obrigat( SX3->X3_CAMPO ) )
			cPicture := RTrim( Iif( Empty( aCPOS[ nI,6]), SX3->X3_PICTURE, aCPOS[ nI, 6 ] ) )
			cWhen    := RTrim( Iif( Empty( aCPOS[ nI,7]), SX3->X3_WHEN, aCPOS[ nI, 7 ] ) )
			
	   	AAdd( aField, {cTitulo,;
								SX3->X3_CAMPO,;
								SX3->X3_TIPO,;
								SX3->X3_TAMANHO,;
								SX3->X3_DECIMAL,;
								cPicture,;
								&('{||' + AllTrim(cValid)+ '}'),;
								.T.,;
								SX3->X3_NIVEL,;
								SX3->X3_RELACAO,;
								cF3,;
								&('{||' + RTrim(cWhen) + '}'),;
								SX3->X3_VISUAL=='V',;
								.F.,; 
								SX3->X3_CBOX,;
								VAL(SX3->X3_FOLDER),;
								.F.,;
								''} )
		Endif
	Next nI
	
	DEFINE MSDIALOG oDlgCP TITLE cTituloDlg FROM 0,0 TO 400,640 PIXEL STYLE DS_MODALFRAME STATUS
		oDlgCP:lEscClose := .F.
		
		oScroll := TScrollBox():New(oDlgCP,1,1,1000,1000,.T.,.F.,.F.)
		oScroll:Align := CONTROL_ALIGN_ALLCLIENT
			
		oEnch := MsMGet():New(	/*cAlias*/,;
										/*nRecNo*/,;
										nOpc,;
										/*aCRA*/,;
										/*cLetras*/,;
										/*cTexto*/,;
										aCPOS,;
										/*aPos*/,;
										/*aAlterEnch*/,;
										/*nModelo*/,;
										/*nColMens*/,;
										/*cMensagem*/,;
										/*cTudoOk*/,;
										oDlgCP,;
										/*lF3*/,;
										lMemoria,;
										/*lColumn*/,;
		        						/*caTela*/,;
		        						/*lNoFolder*/,;
		        						/*lProperty*/,;
		        						aField,;
		        						/*aFolder*/,;
		        						/*lCreate*/,;          
		        						/*lNoMDIStretch*/,;
		        						/*cTela*/)
		
		oEnch:oBox:Align := CONTROL_ALIGN_ALLCLIENT		
	ACTIVATE MSDIALOG oDlgCP CENTER ON INIT EnchoiceBar(oDlgCP,{|| oDlgCP:End()},{|| oDlgCP:End()} )
Return

//--------------------------------------------------------------------------
// Rotina | A610PDF | Autor | Robson Gonçalves           | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para preparar os dados para gerar o arquivo capa de 
//        | despesas no formato PDF.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610PDF( cC7_NUM, lReenviar, l_PDF_WF )
	Local aArea := {}
	Local aDADOS := {}
	Local aSA2 := {}
	Local aCTT := {}
	Local aSAL := {}
	Local aHeader := {}
	Local cAL_COD := ''
	Local cC7_XRECORR := {}
	Local cC7_XADICON := ''
	Local cC7_XCONTRA := ''
	Local cRateio := ''
	Local cC7_CC := ''
	Local cC7_ITEMCTA := ''
	Local cC7_CLVL := ''
	Local cC7_PLANILH := ''
	Local nI := 0
	Local aRateio := {}
	Local cCND_COMPET := ''
	Local lC1_C8_CN9 := .F.
	Local cAPROVADORES := ''
	Local lItemRate := .F.
	Local lItemProd := .F.
	Local aInfAdic := {}
	Local nRec := 0
	Local aRecNoSC1 := {}
	Local cRecNoSC1 := ''
	Local lInfAdic := .F.
	
	Private nC7_TOTAL := 0
	Private nP_VLR_TOT := 13
	Private nC7_XADICON := 21

	Private cUSER_COD := RetCodUsr()
	Private cUSER_LOG := AllTrim( UsrRetName( cUSER_COD ) )
	Private cUSER_NAM := RTrim( UsrFullName( cUSER_COD ) )
	
	DEFAULT lReenviar := .F.
	DEFAULT l_PDF_WF := .F.
	
	Conout('A610PDF - Iniciando a rotina do processo de gerar PDF e enviar WF da capa de despesa.')
	
	//------------------------------------------------------------------------------------------------
	// Parâmetro com centro de custo de remuneração de parceiros. Quanto existir este centro de custo
	// não é necessário a capa de despesa física e nem o WF para a equipe do planejamento financeiro.
   SC7->( dbSetOrder( 1 ) )
   If SC7->( dbSeek( xFilial( 'SC7' ) + cC7_NUM ) )
   	If A610IsRPar( SC7->C7_FILIAL, SC7->C7_NUM )
   		Conout('A610PDF - O PC em questão é de remuneração de parceiros, por isso não será gerado o PDF e nem WF da capa de despesa.')
   		Private cPedCompras := SC7->C7_FILIAL + '-' + SC7->C7_NUM
   		U_A610WFPC()
   		Return
   	Endif
	Endif
	
	Conout('A610PDF - O processo é (não é) de reenvio de WF de capa de despesa.')
	
	If .NOT. lReenviar 
		cUSER_COD := RetCodUsr()
		cUSER_LOG := AllTrim( UsrRetName( cUSER_COD ) )
		cUSER_NAM := RTrim( UsrFullName( cUSER_COD ) )
	Endif
	
	/*****
	 *
	 * todos os processo tem pedido de compras.
	 * pedido de compras pode ter medição e medição tem contrato.
	 * pedido de compras pode ter cotação e cotação tem solicitação de compras.
	 * pedido de compras pode ter solicitação de compras.
	 *
    ***/
   
	aArea := { SC7->(GetArea()), CN9->(GetArea()), CND->(GetArea()), CNE->(GetArea()), SC8->(GetArea()) }
   
	SC7->( dbSetOrder( 1 ) )
	If SC7->( MsSeek( xFilial( 'SC7' ) + cC7_NUM ) )
		cNUM_PED_COM := SC7->C7_NUM
		If FunName() == 'CNTA120'
			cNUM_MEDICAO := CND->CND_NUMMED
			cC7_PLANILH  := CND->CND_NUMERO
			cNUM_CONTRAT := CND->CND_CONTRA
			cREV_CONTRAT := CND->CND_REVISA
			cCND_COMPET  := CND->CND_COMPET
		Else
			cNUM_COTACAO := SC7->C7_NUMCOT
			cNUM_MEDICAO := SC7->C7_MEDICAO
			cC7_PLANILH  := SC7->C7_PLANILH
			cNUM_CONTRAT := SC7->C7_CONTRA
			cREV_CONTRAT := SC7->C7_CONTREV
		Endif
		
		cAPROVADORES := A610GetApr( SC7->C7_NUM )
		
		//---------------------------------------------------------------------------
		// Os 25 primeiros elementos são os campos da capa de despesa.
		AAdd( aHeader, { 'CP_C7_CC'           , 'Centro de custo' } )
		AAdd( aHeader, { 'CP_C7_ITEMCTA'      , 'Centro de resultado' } )
		AAdd( aHeader, { 'CP_C7_XRECORR'      , 'Recorrência' } )
		AAdd( aHeader, { 'CP_C7_MES_XREFERE'  , 'Mês referência' } )
		AAdd( aHeader, { 'CP_C7_ANO_XREFERE'  , 'Ano referência' } )
		AAdd( aHeader, { 'CP_C7_CLVL'         , 'Código do projeto' } )
		AAdd( aHeader, { 'CP_C7_DESCRCP'      , 'Descrição' } )
		AAdd( aHeader, { 'CP_C7_XOBJ'         , 'Objetivo' } )
		AAdd( aHeader, { 'CP_C7_XJUST'        , 'Justificativa' } )
		AAdd( aHeader, { 'CP_A2_NOME'         , 'Razão social' } )
		AAdd( aHeader, { 'CP_A2_NREDUZ'       , 'Nome fantasia' } )
		AAdd( aHeader, { 'CP_A2_CGC'          , 'CNPJ' } )
		AAdd( aHeader, { 'CP_VALOR'           , 'Valor bruto'} )
		AAdd( aHeader, { 'CP_C7_DOCFIS'       , 'Nº Nota fiscal' } )
		AAdd( aHeader, { 'CP_C7_APBUDGE'      , 'Aprovado em budget' } )
		AAdd( aHeader, { 'CP_C7_CTAORC'       , 'Cta.Contáb.Orçada'} )
		AAdd( aHeader, { 'CP_C7_DDORC'        , 'Descr. Desp. no Orçamento' } )
		AAdd( aHeader, { 'CP_C7_FORMPG'       , 'Forma de pagto.' } )
		AAdd( aHeader, { 'CP_CONDICOES'       , 'Condição de pagto.' } )
		//AAdd( aHeader, { 'CP_C7_XVENCTO'      , 'Vencimento' } )
		AAdd( aHeader, { 'CP_C7_XADICON'      , 'Comentários adicionais' } )
		AAdd( aHeader, { 'CP_C7_NOME_CCAPROV' , 'Nome do resp. contratação' } )
		AAdd( aHeader, { 'CP_C7_DEPTO_CCAPROV', 'Centro Custo de contratação' } )//22
		AAdd( aHeader, { 'CP_C7_COD_APROV'    , 'Código do aprovador contratação' } )
		AAdd( aHeader, { 'CP_C7_GRPAPDE'      , 'Cód. do resp. contratação' } )
		//---------------------------------------------------------------------------
		// Os demais elementos são dados para controle e informativo.
		AAdd( aHeader, { 'cCodElab'      , 'Código do elaborador' } )
		AAdd( aHeader, { 'cLogElab'      , 'Login do elaborador' } )
		AAdd( aHeader, { 'cNomElab'      , 'Nome do elaborador' } )
		AAdd( aHeader, { 'cPedCompras'   , 'Filial + Nº Ped. Compras' } )
		AAdd( aHeader, { 'cMedicao'      , 'Filial + Nº da medição' } )
		AAdd( aHeader, { 'cContrato'     , 'Filial + Nº do contrato' } )
		AAdd( aHeader, { 'cCotacao'      , 'Filial + Nº da cotação' } )
		AAdd( aHeader, { 'CP_C7_XCONTRA' , 'Contrato' } )
		AAdd( aHeader, { 'CP_C7_APROVADORES', 'Aprovadores' } )
		
		While SC7->( .NOT. EOF() ) .AND. SC7->C7_FILIAL == xFilial( 'SC7' ) .AND. SC7->C7_NUM == cC7_NUM
			If Len( aSA2 ) == 0
				aSA2 := SA2->( GetAdvFVal( 'SA2', { 'A2_NOME', 'A2_NREDUZ', 'A2_TIPO', 'A2_CGC' }, xFilial( 'SA2' ) + SC7->( C7_FORNECE + C7_LOJA ), 1 ) )
			Endif
	   	
			If .NOT. Empty( SC7->C7_XRECORR )
				cC7_XRECORR := StrTokArr( SX3->( Posicione( 'SX3', 2, 'C7_XRECORR', 'X3CBox()' ) ), ';' )[ Val( SC7->C7_XRECORR ) ]
			Endif
	   	
			If .NOT. Empty( SC7->C7_XCONTRA )
				cC7_XCONTRA := StrTokArr( SX3->( Posicione( 'SX3', 2, 'C7_XCONTRA', 'X3CBox()' ) ), ';' )[ Val( SC7->C7_XCONTRA ) ]
			Endif

			If Len( aCTT ) == 0
				aCTT := CTT->( GetAdvFVal( 'CTT', { 'CTT_GARFIX', 'CTT_GARVAR', 'CTT_GAPONT', 'CTT_DESC01' }, xFilial( 'CTT' ) + SC7->C7_CCAPROV, 1 ) )
				If Len( aCTT ) > 0
					If Empty( aCTT[ 1 ] )
						aCTT[ 1 ] := 'sem código de grupo de aprovação recorrente fixo.'
					Endif
				Endif
				If Len( aCTT ) > 1
					If Empty( aCTT[ 2 ] )
						aCTT[ 2 ] := 'sem código de grupo de aprovação recorrente variável.'
					Endif
				Endif
				If Len( aCTT ) > 2
					If Empty( aCTT[ 3 ] )
						aCTT[ 3 ] := 'sem código de grupo de aprovação pontual.'
					Endif
				Endif
			Endif
	   	
			If Len( aSAL ) == 0
				If SubStr( aCTT[ Val( SubStr( cC7_XRECORR, 1, 1 ) ) ], 1, 3 ) == 'sem'
					cAL_COD := 'sem referência.'
					aSAL := { 'sem nome do aprovador.','sem nome do grupo de aprovação.', 'sem código de aprovador' }
				Else
					cAL_COD := aCTT[ Val( SubStr( cC7_XRECORR, 1, 1 ) ) ]
					aSAL := SAL->( GetAdvFVal( 'SAL', { 'AL_NOME', 'AL_DESC', 'AL_APROV' }, xFilial( 'SAL' ) + cAL_COD + '01', 2 ) )
					if cAL_COD $ "8000  |80000 |800000"
				       aSAL[1] := GetNewPar('MV_XRESPCT', 'Bruno Portnoi')
				    elseIf aSAL[1]==NIL
						aSAL[1] := A610NAprov(aSAL[3])
					Endif
				Endif
			Endif
	   	
			nC7_TOTAL += ( SC7->( C7_TOTAL + C7_DESPESA + C7_VALFRE + C7_VALIPI + C7_SEGURO ) - SC7->C7_VLDESC )
	   	
			lInfAdic := ( Len( aInfAdic ) == 0 )
			
			If lInfAdic
				AAdd( aInfAdic, AllTrim( SC7->C7_XADICON ) )
				
				If .NOT. ( 'Pedido de compras:' $ SC7->C7_XADICON )
					AAdd( aInfAdic, 'Pedido de compras: ' + cC7_NUM )
				Endif
				
				If cCND_COMPET <> ''
					AAdd( aInfAdic, 'Mês/Ano da competência: ' + cCND_COMPET )
				Endif
				
				If .NOT. Empty( SC7->C7_CNPJ )
					AAdd(aInfAdic,'CNPJ/Filial de entrega: '+TransForm(SC7->C7_CNPJ,'@R 99.999.999/9999-99')+' / ('+_cFILENT_+') '+A610NomFil( _cFILENT_ ))
				Else
					If SC7->C7_FILENT <> SM0->M0_CODFIL
						nRec := SM0->( RecNo() )
						SM0->( dbSeek( cEmpAnt + SC7->C7_FILENT ) )
					Endif
					AAdd(aInfAdic,'CNPJ/Filial de entrega: '+TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99')+' / ('+SC7->C7_FILENT+') '+RTrim( SM0->M0_FILIAL ))
					If nRec > 0
						SM0->( dbGoTo( nRec ) )
					Endif
				Endif
				
				AEval( aInfAdic, {|cValue,nIndex| cC7_XADICON += cValue + Iif( nIndex == Len( aInfAdic ), '', CRLF ) } )
			Endif
			
			Set( 4, 'dd/mm/yyyy' )
	   	
			If lReenviar .AND. Empty( cUSER_COD )
				cUSER_COD := SC7->C7_USER
				cUSER_LOG := AllTrim( UsrRetName( cUSER_COD ) )
				cUSER_NAM := RTrim( UsrFullName( cUSER_COD ) )
			Endif
			
			If .NOT. Empty( SC7->C7_CC )
				cC7_CC := RTrim( SC7->C7_CC ) + ' - ' + RTrim( CTT->( Posicione( 'CTT', 1, xFilial( 'CTT' ) + SC7->C7_CC , 'CTT_DESC01' ) ) )
			Endif
			
			If .NOT. Empty( SC7->C7_ITEMCTA )
				cC7_ITEMCTA := RTrim( SC7->C7_ITEMCTA )+ ' - ' + RTrim( CTD->( Posicione( 'CTD' ,1 , xFilial( 'CTD' ) + SC7->C7_ITEMCTA, 'CTD_DESC01' ) ) )
			Endif
			
			If .NOT. Empty( SC7->C7_CLVL )
				cC7_CLVL := RTrim( SC7->C7_CLVL ) + ' - ' + RTrim( CTH->( Posicione( 'CTH', 1, xFilial( 'CTH' ) + SC7->C7_CLVL, 'CTH_DESC01' ) ) )
			Endif
			
			If Empty( _cCOND_ )
				_cCOND_ := SC7->C7_COND
			Endif
						
			/******
			 * 
			 * Se houver uma destas duas condições não precisa enviar aprovação da capa de despesa para o planejamento financeiro.
			 * a) o pedido de compras tem solicitação de compras (SC1)?
			 * b) o pedido de compras tem cotação de compras (SC8)?
			 * 
			 */
			If .NOT. lC1_C8_CN9
				If .NOT. Empty( SC7->C7_NUMSC ) .OR. .NOT. Empty( SC7->C7_NUMCOT )
					lC1_C8_CN9 := .T.
				Endif
			Endif
			
			//---------------------------------------------------------------------------
			// Os 25 elementos são os campos da capa de despesa.
			//---------------------------------------------------------------------------
			// Os demais elementos são dados para controle e informativo.
			AAdd( aDADOS, {cC7_CC,;
			cC7_ITEMCTA,;
			SubStr( cC7_XRECORR, 1, 1 ) + '-' + SubStr( cC7_XRECORR, 3 ) ,;
			SubStr( SC7->C7_XREFERE, 1, 2) + ' (' + MesExtenso( SubStr( SC7->C7_XREFERE, 1, 2) ) + ')',;
			SubStr( SC7->C7_XREFERE, 3, 4),;
			cC7_CLVL,;
			RTrim( SC7->C7_DESCRCP ),;
			RTrim( SC7->C7_XOBJ ),;
			RTrim( SC7->C7_XJUST ),;
			SC7->C7_FORNECE + ' - ' + RTrim( aSA2[ 1 ] ),;
			RTrim( aSA2[ 2 ] ),;
			TransForm( aSA2[ 4 ], Iif( aSA2[ 3 ] == 'J', '@R 99.999.999/9999-99', '@R 999.999.999-99' ) ),;
			'',;
			SC7->C7_DOCFIS,;
			StrTran( StrTokArr( SX3->( Posicione( 'SX3', 2, 'C7_APBUDGE', 'X3CBox()' ) ), ';' )[ Val( SC7->C7_APBUDGE ) ], '=', '-' ),;
			RTrim( SC7->C7_CTAORC ) + ' - ' + RTrim( CT1->( Posicione( 'CT1', 1, xFilial( 'CT1' ) + SC7->C7_CTAORC, 'CT1_DESC01' ) ) ),;
			SC7->C7_DDORC,;
			RTrim( SC7->C7_FORMPG ),;
			_cCOND_  + ' (' + RTrim( SE4->( Posicione( 'SE4', 1, xFilial( 'SE4' ) + _cCOND_ , 'E4_DESCRI' ) ) ) + ')',;
			cC7_XADICON,;
			aSAL[ 1 ],;
			aSAL[ 2 ],;
			aSAL[ 3 ],;
			SC7->C7_CCAPROV + ' - ' + CTT->( Posicione('CTT',1,xFilial('CTT')+SC7->C7_CCAPROV,'CTT_DESC01') ),;
			cUSER_COD,;
			cUSER_LOG,;
			cUSER_NAM,;
			Iif(Empty(cNUM_PED_COM),'Não há pedido.'  ,xFilial('SC7')+'-'+cNUM_PED_COM),;
			Iif(Empty(cNUM_MEDICAO),'Não há medição.' ,xFilial('CND')+'-'+cNUM_MEDICAO),;
			Iif(Empty(cNUM_CONTRAT),'Não há contrato.',xFilial('CN9')+'-'+cNUM_CONTRAT),;
			Iif(Empty(cNUM_COTACAO),'Não há cotação.' ,xFilial('SC8')+'-'+cNUM_COTACAO),;
			cC7_XCONTRA,;
			cAPROVADORES } )
   		
			If .NOT. Empty( SC7->C7_NUMSC )
				SC1->( dbSetOrder( 1 ) )
				If SC1->( dbSeek( SC7->( C7_FILIAL + C7_NUMSC + C7_ITEMSC ) ) )
					If AScan( aRecNoSC1, {|e| e[ 2 ] == SC1->C1_NUM .AND. e[ 3 ] == SC1->C1_ITEM } ) == 0
						AAdd( aRecNoSC1, { SC1->( RecNo() ), SC1->C1_NUM, SC1->C1_ITEM } )
					Endif
				Endif
			Endif
			SC7->( dbSkip() )
		End
	   
		If .NOT. Empty( cNUM_MEDICAO )
			A610TemRateio( 'CNTA120', 'CNZ', { xFilial( 'CNZ' ), cNUM_CONTRAT, cREV_CONTRAT, cNUM_MEDICAO }, .F., @aRateio, @lItemRate, @lItemProd )
			If Len( aRateio ) == 0
				A610TemRateio( 'CNTA120', 'CNE', {xFilial('CNE'),cNUM_CONTRAT,cREV_CONTRAT,cC7_PLANILH,cNUM_MEDICAO}, .F., @aRateio, @lItemRate, @lItemProd )
			Endif
		Endif
		
		If .NOT. Empty( cC7_NUM ) .AND. Empty( cNUM_COTACAO ) .AND. Empty( cNUM_SOL_COM )
			A610TemRateio( 'MATA120', 'SCH', { xFilial( 'SCH' ), cC7_NUM }, .F., @aRateio, @lItemRate, @lItemProd )
			If Len( aRateio ) == 0
				A610TemRateio( 'MATA120', 'SC7-MEMO', { xFilial( 'SC7' ), cC7_NUM }, .F., @aRateio, @lItemRate, @lItemProd )
			Endif
		Endif
		
		If Len( aRecNoSC1 ) > 0
			For nI := 1 To Len( aRecNoSC1 )
				SC1->( MsGoTo( aRecNoSC1[ nI, 1 ] ) )
				cRecNoSC1 += " R_E_C_N_O_ = " + LTrim( Str( aRecNoSC1[ nI, 1 ] ) ) + " OR "
				A610TemRateio( 'MATA161', 'SCX', { SC1->C1_FILIAL, SC1->C1_NUM, SC1->C1_ITEM }, .F., @aRateio, @lItemRate, @lItemProd )
			Next nI
			cRecNoSC1 := " (" + SubStr( cRecNoSC1, 1, Len( cRecNoSC1 )-3 ) + ") "
			A610TemRateio( 'MATA161', 'SC1-A', { cRecNoSC1 }, .T., @aRateio, @lItemRate, @lItemProd )
		Endif
	   
		If Len( aRateio ) > 1
			/*IF Empty(cNUM_CONTRAT)			
				cRateio := Replicate('-',70) + CRLF
				cRateio += '*** RATEIO ***' + CRLF
				cRateio += Iif(Len(aRecNoSC1)>0,'ITSC','ITPC')+' - IT - PERC. - VALOR - C.CUSTO - C.CONTAB - C.RESULT - PROJETO' + CRLF
				For nI := 1 To Len( aRateio )
					cRateio += aRateio[ nI, 1 ] +'-'+;
						aRateio[ nI, 2 ] +'-'+;
						aRateio[ nI, 3 ] +'%' + '-'+;
						aRateio[ nI, 4 ] +'-'+;
						aRateio[ nI, 5 ] +'-'+;
						aRateio[ nI, 6 ] +'-'+;
						aRateio[ nI, 7 ] +'-'+;
						aRateio[ nI, 8 ] + CRLF
				Next nI			
			Else
				cRateio := '*** Informações de rateio vide planilha no banco de conhecimento ***'
			EndIF
			*/
			cRateio := '*** Informações de rateio vide planilha no banco de conhecimento ***'

			AEval( aDADOS, { |cVal,nInd,cText| cText := '*** Rateio ***',;
			aDADOS[ nInd, 1 ] := cText,;
			aDADOS[ nInd, 2 ] := cText,;
			aDADOS[ nInd, 6 ] := cText } )
			
			//aDADOS[ 1, nC7_XADICON ] := aDADOS[ 1, nC7_XADICON  ] + CRLF + cRateio			
			aDADOS[ 1, 20 ] := aDADOS[ 1, 20  ] + CRLF + cRateio			
		Endif
	   	
		aDADOS[ 1, nP_VLR_TOTAL ] := LTrim( TransForm( nC7_TOTAL, '@E 999,999,999.99' ) ) + ' (' + Lower( Extenso( nC7_TOTAL, ,1 ) ) + ')'
	   
		If Len( aDADOS ) > 1
			Conout('A610PDF - Consegui montar o aDADOS.')
		Else
			Conout('A610PDF - Não consegui montar o aDADOS.')
		Endif
	   
		A610GerPDF( aHeader, aDADOS, lReenviar, l_PDF_WF, lC1_C8_CN9, aRateio )
	Endif
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return

//--------------------------------------------------------------------------
// Rotina | A610GerPDF | Autor | Robson Gonçalves        | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para gerar o arquivo capa de despesas no formato PDF.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610GerPDF( aHeader, aDADOS, lReenviar, l_PDF_WF, lC1_C8_CN9, aRateio )
	Local cAux := ''
	Local cDOCUMENTO := ''
	Local cExtArq := ''
	Local cFormat := '17'
	Local cKey := ''
	Local cMV_610DOT := 'MV_610DOT'
	Local cMV_DIRDOC := GetMv('MV_DIRDOC')
	Local cNomArqDOC := ''
	Local cNomArqPDF := ''
	
	Local cNomeArq := ''
	Local cOrigem := ''
	Local cTempPath := GetTempPath()
	Local cVersaoPDF := ''
	
	Local lCopy := .F.
	Local lReadOnly := .F.
	
	Local nCheck := 0
	Local nI := 0
	Local nP := 0

	Local cNomArqXML := ''
	Local cVersaoXML := ''
	Local cFileXML   := ''
	
	DEFAULT l_PDF_WF := .F.
	DEFAULT aRateio	 := {}
	
	Conout('A610PDF - A610GerPDF - lReenviar = '+Iif(lReenviar,'.T.','.F.'))
	Conout('A610PDF - A610GerPDF - l_PDF_WF = '+Iif(l_PDF_WF,'.T.','.F.'))
	
	If lReenviar .AND. .NOT. l_PDF_WF
		A610GrvSCR( aHeader, aDADOS, lReenviar, l_PDF_WF )
	Else
		If lCNTA120
			If .NOT. Empty( CND->CND_DTFIM )
				Return
			Endif
		Endif
	
		If lCNTA120
			cDOCUMENTO := 'ctr' + A610TiraZero( cNUM_CONTRAT ) + '_' + 'med' + A610TiraZero( cNUM_MEDICAO ) + '_' + 'pc' + A610TiraZero( cNUM_PED_COM )
		Else
			If Empty( cNUM_COTACAO )
				cDOCUMENTO := 'pc' + A610TiraZero( cNUM_PED_COM )
			Else
				cDOCUMENTO := 'cot' + A610TiraZero( cNUM_COTACAO ) + '-' + 'pc' + A610TiraZero( cNUM_PED_COM )
			Endif
		Endif

		// Verificar se existe o parâmetro.
		If .NOT. GetMv( cMV_610DOT, .T. )
			// Caso o parâmetro não exista, criar.
			CriarSX6( cMV_610DOT, 'C', 'ARQUIVO TEMPLATE CAPA DE DESPESA. CSFA610.prw', 'capadespesa.dot' )
		Endif
		
		// Capturar o nome do arquivo template.
		cMV_610DOT := GetMv( cMV_610DOT, .F. )
		
		// Verificar se o arquivo template existe no diretório indicado.
		cOrigem := cMV_DIRDOC + '\' + cMV_610DOT
		If File( cOrigem )
			// Copiar o arquivo do servidor para o temporário do usuário do windows.
			CpyS2T( cOrigem, cTempPath, .T.)
			Sleep( Randomize( 1, 499 ) )
			
			// Formar o endereço para onde foi copiado template word no temporário do usuário.
			cTemplate := cTempPath + SubStr( cOrigem, RAt( '\',cOrigem )+1 )
			
			// Verifcar até cinco vezes se o template foi copiado.
			While ((.NOT. lCopy) .And. (nCheck <= 5))
				If File( cTemplate )
					lCopy := .T.
				Else
					nCheck++
					CpyS2T( cOrigem, cTempPath, .T. )
					Sleep( Randomize( 1, 499 ) )
				Endif
			End
			
			If lCopy
				// Dividir o nome do arquivo e a extensão do arquivo.
				SplitPath( cTemplate, , , @cNomeArq, @cExtArq )
				
				// Pesquisar no banco de conhecimento a próxima versão PDF.
				cVersaoPDF := A610Knowledge( cNomeArq + '_' + cDOCUMENTO, '.pdf' )
				
				IF Len( aRateio ) > 1
					cVersaoXML := A610Knowledge( cDOCUMENTO, '.xml' )
					cNomArqXML := cDOCUMENTO + '_v' + cVersaoXML + '.xml'
				EndIF
	
				// Elaborar o nome completo do arquivo compatível com o registro no banco de conhecimento.
				cNomArqPDF := SubStr( cTemplate, 1, RAt( '.', cTemplate )-1 ) + '_' + cDOCUMENTO + '_v' + cVersaoPDF + '.pdf'
				cNomArqDOC := StrTran( cNomArqPDF, '.pdf', '.doc' )
				
				// Criar o link com o apliativo.
				oWord	:= OLE_CreateLink()
				
		      // Inibir o aplicativo em execução.
				OLE_SetProperty( oWord, '206', .F. )
	
				// Abrir um novo arquivo.
				OLE_NewFile( oWord , cTemplate )
				
				// Descarregar os dados dos campos do Protheus no Word.
				For nI := 1 To Len( aHeader )
					// Somente para campos do vetor.
					OLE_SetDocumentVar( oWord, aHeader[ nI, 1 ], aDados[ 1, nI ] )
				Next nI
			   
				OLE_SetDocumentVar( oWord, 'CP_MSG_PRAZO_VENCTO', Iif( lMSG_PRAZO_VENCTO, cMSG_PRAZO_VENCTO, '' ) )
			   
		   	// Atualizar campos.
				OLE_UpDateFields( oWord )
		      
		      // Inibir o aplicativo Ms-Word em execução.
				OLE_SetProperty( oWord, '206', .F. )
				
				// Salvar o arquivo no formato DOC.
				OLE_SaveAsFile( oWord, cNomArqDOC )
				Sleep( Randomize( 1, 499 ) )
	
				// Abrir o arquivo no formato DOC.
				OLE_OpenFile( oWord, cNomArqDOC )
				Sleep( Randomize( 1, 499 ) )
				
				// Salvar o arquivo no formato PDF.
				OLE_SaveAsFile( oWord, cNomArqPDF, /*cPassword*/, /*cWritePassword*/, lReadOnly, cFormat)
				Sleep( Randomize( 1, 499 ) )
				
				// Fechar o arquivo.
				OLE_CloseFile( oWord )
				
				// Desfazer o link.
				OLE_CloseLink( oWord )
	
				// Apagar o arquivo template.
				FErase( cTemplate )
				
				Conout('A610PDF - A610GerPDF - Gerei o arquivo: '+cNomArqPDF)
				
				// Anexar os arquivos no banco de conhecimento conforme os registros.
				If Empty( cNUM_CONTRAT )
					// Somente para pedido de compras.
					cKey := cNUM_PED_COM + StrZero( 1, Len( SC7->C7_ITEM ) )
					A610Anexar( cNomArqPDF, cKey, cDOCUMENTO, 'SC7', .T. )
					
					IF Len( aRateio ) > 1
						cFileXML := A610XmlRateio( aRateio, cNomArqXML )

						A610Anexar( cFileXML, cKey, 'Xml Rateio ' + cDOCUMENTO, 'SC7', .T. )
					EndIF

					If .NOT. Empty( cNUM_COTACAO )
						cKey := cNUM_COTACAO +  StrZero( 1, Len( SC8->C8_ITEM ) )
						A610Anexar( cNomArqPDF, cKey, cDOCUMENTO, 'SC8', .F. )
					Endif
					
					If .NOT. Empty( cNUM_SOL_COM )
						cKey := cNUM_SOL_COM + StrZero( 1, Len( SC1->C1_ITEM ) )
						A610Anexar( cNomArqPDF, cKey, cDOCUMENTO, 'SC1', .F. )
					Endif

					Conout('A610PDF - A610GerPDF - Anexei o arquivo '+cNomArqPDF+' no PC '+cNUM_PED_COM)
				Else
					// Para a medição e para o pedido de compras.
					cKey := cNUM_CONTRAT+cREV_CONTRAT+cNUM_MEDICAO
					A610Anexar( cNomArqPDF, cKey, cDOCUMENTO, 'CND', .T. )
					
					cKey := cNUM_PED_COM + StrZero( 1, Len( SC7->C7_ITEM ) )
					A610Anexar( cNomArqPDF, cKey, cDOCUMENTO, 'SC7', .F. )
					Conout('A610PDF - A610GerPDF - Anexei o arquivo '+cNomArqPDF+' na medição '+cNUM_MEDICAO)

					IF Len( aRateio ) > 1
						cFileXML := A610XmlRateio( aRateio, cNomArqXML )

						cKey := cNUM_CONTRAT+cREV_CONTRAT+cNUM_MEDICAO
						A610Anexar( cFileXML, cKey, 'Xml Rateio ' + cDOCUMENTO, 'CND', .T. )
					EndIF
				Endif

				// Apagar o arquivo DOC criado como base para o arquivo PDF.
				FErase( cNomArqDOC )
				Sleep( Randomize( 1, 499 ) )
				
				ShellExecute( 'Open', cNomArqPDF, '', cTempPath, 1 )				
				
		   	/******
		   	 *
		   	 * Se o PC possuir SC, ou COT, ou não for de contrato não é preciso aprovação do planejamento
		   	 * financeiro, portanto pode inicia o processo de aprovação do pedido de compras direto.
		   	 *
		   	 */
				If lC1_C8_CN9
					Private cPedCompras := aDADOS[ 1, AScan( aHeader, {|e| e[ 1 ] == 'cPedCompras' } ) ]
					Conout('A610PDF - A610GerPDF - A610WFPC - Vou iniciar o processo envio de WF da capa de despesa.')
					U_A610WFPC()
				Else
					Conout('A610PDF - A610GerPDF - Vou gerar SCR.')
					A610GrvSCR( aHeader, aDADOS, lReenviar, l_PDF_WF )
				Endif
			Else
				MsgAlert('Não foi possível copiar o arquivo template do servidor para a estação, por isso não será possível gerar a capa de despesa.','Inconsistência')
			Endif
		Else
			MsgAlert('Arquivo template para gerar a capa de despesa no formato PDF não localizado. A capa de despesa não será gerado.','Inconsistência')
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610GrvSCR | Autor | Robson Gonçalves        | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para gerar os registros para o controle de alçada.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610GrvSCR( aHeader, aDADOS, lReenviar, l_PDF_WF )
	Local aUser := {}
	Local cUserEmail := ''
	Local cMV_610PFIN := 'MV_610PFIN'
	Local cMV610_005 := 'MV_610_005'
	
	If .NOT. GetMv( cMV610_005, .T. )
		CriarSX6( cMV610_005, 'N', 'LIGAR/DESLIGAR APROVACAO DA CAPA DE DESPESA. 0=DESLIGADO, 1=LIGADO. ROTINA CSFA610.PRW', '1' )
	Endif
	
	cMV610_005 := GetMv( cMV610_005, .F. )
	
	// Workflow da capa de despesa desligado.
	If cMV610_005 == 0
		Conout('A610GrvSCR - Aprovação da capa de despesa DESLIGADO conforme parâmetro MV_610_005.')
		Private cPedCompras := aDADOS[ 1, AScan( aHeader, {|e| e[ 1 ] == 'cPedCompras' } ) ]
		Conout('A610GrvSCR - Início do processo envio de WF do pedido de compras.')
		U_A610WFPC()
	
	// Workflow da capa de despesa ligado.
	Else
		If .NOT. GetMv( cMV_610PFIN, .T. )
			// Código 000075 do grupo de aprovação da produção criado por Danielle Toledo conforme e-mail 17/09/15.
			CriarSX6( cMV_610PFIN, 'C', 'CODIGO DO GRUPO DE APROVACAO DO PLANEJAMENTO FINANCEIRO - ROTINA CSFA610.prw', '000075' )
		Endif
		
		cMV_610PFIN := GetMv( cMV_610PFIN, .F. )
		
		SAL->( dbSetOrder( 1 ) )
		SAL->( dbSeek( xFilial( 'SAL' ) + cMV_610PFIN ) )
		
		While SAL->( .NOT. EOF() ) .AND. SAL->AL_FILIAL == xFilial( 'SAL' ) .AND. SAL->AL_COD == cMV_610PFIN
			If SAL->AL_MSBLQL <> '1'
				
				cUserEmail := UsrRetMail( SAL->AL_USER )
				
				If .NOT. Empty( cUserEmail )
					AAdd( aUser, { SAL->AL_USER, cUserEmail } )
				Endif
				
				If .NOT. lReenviar .AND. .NOT. l_PDF_WF
					SCR->( RecLock( 'SCR', .T. ) )
					SCR->CR_FILIAL  := xFilial( 'SCR' )
					SCR->CR_NUM     := cNUM_PED_COM
					SCR->CR_TIPO    := cTP_DOC //Aprovação automática da capa de despesas (CSFA610).
					SCR->CR_USER    := SAL->AL_USER
					SCR->CR_APROV   := SAL->AL_APROV
					SCR->CR_NIVEL   := SAL->AL_NIVEL
					SCR->CR_STATUS  := '02' //Aguardando liberação do usuário.
					SCR->CR_OBS     := 'APROV. CAPA DE DESPESA CSFA610'
					SCR->CR_TOTAL   := nC7_TOTAL
					SCR->CR_EMISSAO := dDataBase
					SCR->CR_MOEDA   := 1
					SCR->CR_TXMOEDA := 1
					SCR->( MsUnLock() )
					
					Conout('A610PDF - A610GerPDF - A610GrvSCR - Gerado registro na SCR: '+ cNUM_PED_COM + ' ' + cTP_DOC + ' ' + SAL->AL_USER + ' ' + SAL->AL_APROV)
				Endif
			Endif
			SAL->( dbSkip() )
		End
		
		Conout('A610PDF - A610GerPDF - A610GrvSCR - Vou chamar a rotina A610WfCpDp')
		A610WfCpDp( aHeader, aDADOS, aUser )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610WfCpDp | Autor | Robson Gonçalves        | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para gerar o arquivo HTML de aprovação/rejeição do 
//        | workflow da capa de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610WfCpDp( aHeader, aDADOS, aUser )
	Local nI := 0
	Local oWFEnv
	Local oHTML
	Local cTitulo := ''
	Local cCampo := ''
	Local cIdMail := ''
	
	Private cMV_610WF1 := GetNewPar('MV_610WF1', '\WORKFLOW\EVENTO\CSFA610a.HTM')
	Private cMV_610WF2 := GetNewPar('MV_610WF2', '\WORKFLOW\EVENTO\CSFA610b.HTM')
	Private cMV_610WF3 := GetNewPar('MV_610WF3', '\WORKFLOW\EVENTO\CSFA610c.HTM')
	
	// Substituir o chr(13)+chr(10) por <br>
	aDADOS[ 1, 21 ] := StrTran( aDADOS[ 1, 21 ], CRLF, '<br>' )
	
	oWFEnv := TWFProcess():New( 'CAPDESPWF', 'Aprovar capa de despesa')
	oWFEnv:NewTask( 'CAPDESPWF', cMV_610WF1 )
	oWFEnv:cSubject := 'Aprovação de Capa de Despesa'
	oWFEnv:bReturn := 'U_CSFA610A(1)'
	
	// Carrega modelo HTML
	oHTML := oWFEnv:oHTML
	
	//---------------------------------------------------------------------------------
	// Verificar se é preciso emitir o alerta de vencimento fora do prazo estabelecido.
	/*
	If lMSG_PRAZO_VENCTO
		nI := AScan( aHeader, {|e| e[ 1 ] == 'CP_C7_XVENCTO' } )
		If nI > 0
			aDADOS[ 1, nI ] := cFNT_PRZ_VENC + aDADOS[ 1, nI ] + '<br>' + cMSG_PRAZO_VENCTO + cNOFONT
		Endif
		oHTML:ValByName( 'cCP_MSG_PRAZO_VENCTO', cMSG_PRAZO_VENCTO )
	Else
		oHTML:ValByName( 'cCP_MSG_PRAZO_VENCTO', '' )
	Endif
	*/
	
	For nI := 1 To Len( aHeader )
		cCpo := 'cTitulo' + LTrim( Str( nI ) )
		cInf := 'cCampo' + LTrim( Str( nI ) )
		
		oHTML:ValByName( cCpo, aHeader[ nI, 2 ] )
		oHTML:ValByName( cInf, aDADOS[ 1, nI ] )
	Next nI
	
	oWFEnv:cTo := StrTran( StrTran( cUSER_LOG, ".", "" ), "\", "" )
		
	oWFEnv:FDesc := 'Aprovar Capa de Despesa nº '+ cNUM_PED_COM
	
	oWFEnv:ClientName( cUSER_LOG )
	
	cIdMail := oWFEnv:Start()
	
	Conout('A610PDF - A610GerPDF - A610GrvSCR - A610WfCpDp - Consegui montar a página WF '+cIdMail+' para aprovar a capa de despes: ' + cNUM_PED_COM)
	
	A610WFLink( aHeader, aDADOS, aUser, @oWFEnv, cIdMail )
	
	oWFEnv:Free()
Return

//--------------------------------------------------------------------------
// Rotina | A610WFLink | Autor | Robson Gonçalves        | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para gerar o arquivo HTML de aviso do workflow da capa 
//        | de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610WFLink( aHeader, aDADOS, aUser, oWFEnv, cIdMail )
	Local nI := 0
	Local cTitulo := ''
	Local cCampo := ''
	Local oHTML
	Local cEMail := ''
	Local cLink	:= GetNewPar('MV_XLINKWF', 'http://192.168.16.10:1804/wf/')
	Local aC7_ANEXOS := {}
	Local cLinkUser := StrTran( StrTran( cUSER_LOG, ".", "" ), "\", "" )
	
	For nI := 1 To Len( aUser )
		cEMail += aUser[ nI, 2 ] + ';'
	Next nI
	cEMail := SubStr( cEMail, 1, Len( cEMail )-1 )

	cLink += 'emp' + cEmpAnt + '/'

	oWFEnv:NewTask( 'CAPDESPWF', cMV_610WF2 )
	oWFEnv:cSubject := 'Solicitação de aprovação da capa de despesa ' + xFilial('SC7')+ '-' + cNUM_PED_COM
	oWFEnv:cTo := cEMail
	
	oHTML := oWFEnv:oHTML
	
	A610GetAnexo( @aC7_ANEXOS, NIL, NIL )
	
	For nI := 1 To Len( aC7_ANEXOS )
		If .NOT. Empty( aC7_ANEXOS )
			oWFEnv:AttachFile( aC7_ANEXOS[ nI ] )
		Endif
	Next nI
	
	If lMSG_PRAZO_VENCTO
		oHTML:ValByName( 'cCP_MSG_PRAZO_VENCTO', cMSG_PRAZO_VENCTO )
	Else
		oHTML:ValByName( 'cCP_MSG_PRAZO_VENCTO', '' )
	Endif

	For nI := 1 To Len( aHeader )
		cCpo := 'cTitulo' + LTrim( Str( nI ) )
		cInf := 'cCampo' + LTrim( Str( nI ) )
		
		oHTML:ValByName( cCpo, aHeader[ nI, 2 ] )
		oHTML:ValByName( cInf, aDADOS[ 1, nI ] )
	Next nI

	oHTML:ValByName( 'proc_link', cLink + cLinkUser + '/' + cIdMail + '.htm' )
	oHTML:ValByName( 'titulo', cIdMail )
	
	Conout('A610PDF - A610GerPDF - A610GrvSCR - A610WfCpDp - A610WFLink - Estou enviando e-mail para: ' + cEMail)
	
	oWFEnv:Start()
	oWFEnv:Free()
Return
		
//--------------------------------------------------------------------------
// Rotina | CSFA610A | Autor | Robson Gonçalves          | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina principal que é executada pelo PROCESS do workflow para 
//        | a chamada do retorno de aprovação/rejeição da capa de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA610A( nOPC, o610Proc )
	If nOPC == 1
		A610RetWF( o610Proc )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610RetWF | Autor | Robson Gonçalves         | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de retorno do workflow da capa de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610RetWF( o610Proc )
	Local aCab := {}
	Local aItem := {}
	
	Local cAprovacao  := ''
	Local cCR_FILIAL  := ''
	Local cCR_NUM     := ''
	Local cCR_STATUS  := ''
	Local cMotivo     := ''
	Local cMV_610SINC := 'MV_610SINC'
	Local cQuebra     := ''
	Local cSituacao   := ''
	Local cUserAprov  := ''
	Local cWFMailID   := ''
	Local cWFMailID   := ''
	
	Local nHashTag := 0
	
	Private aDADOS_PC   := {}
	
	Private cCodElab    := ''
	Private cContrato   := ''
	Private cCotacao    := ''
	Private cLogElab    := ''
	Private cMedicao    := ''
	Private cNomElab    := ''
	Private cPedCompras := ''
	
	cCodElab    := o610Proc:oHTML:RetByName('cCampo26')
	cLogElab    := o610Proc:oHTML:RetByName('cCampo27')
	cNomElab    := o610Proc:oHTML:RetByName('cCampo28')
	cPedCompras := o610Proc:oHTML:RetByName('cCampo29')
	cMedicao    := o610Proc:oHTML:RetByName('cCampo30')
	cContrato   := o610Proc:oHTML:RetByName('cCampo31')
	cCotacao    := o610Proc:oHTML:RetByName('cCampo32')
	cMotivo     := AllTrim( o610Proc:oHTML:RetByName('cMotivo') )
	cAprovacao  := AllTrim( o610Proc:oHTML:RetByName('cAprovacao') )
	cWFMailID   := SubStr( RTrim( o610Proc:oHTML:RetByName('WFMailID') ), 3 )
	
	If .NOT. Empty( cMotivo )
		nHashtag := At( '#', cMotivo )
		If nHashTag > 0
			cUserAprov := AllTrim( SubStr( cMotivo, nHashtag + 1 ) )
		Endif
	Else
		cUserAprov := 'Usuário não assinou.'
	Endif
	
	aDADOS_PC := { cCodElab, cLogElab, cNomElab, cPedCompras, cMedicao, cContrato, cCotacao }

	// Salvar o ID do WF.
	U_A603Save( cWFMailID, 'CSFA610cp' )
	
	// Agir na liberação e/ou rejeição.
	If cAprovacao $ 'S|N'
		cCR_STATUS := Iif( cAprovacao == 'S', '03', Iif( cAprovacao == 'N', '04', '' ) )
		cSituacao  := Iif( cAprovacao == 'S', 'aprovada', Iif( cAprovacao == 'N', 'rejeitada', '' ) )
		cUserAprov += Iif( cAprovacao == 'S', ' aprovou.', ' rejeitou ' ) + Time() + '.'
		If .NOT. Empty( cCR_STATUS ) .AND. .NOT. Empty( cSituacao )
			cCR_FILIAL := SubStr( cPedCompras, 1, 2 )
			cCR_NUM    := PadR( SubStr( cPedCompras, 4 ), Len( SCR->CR_NUM ), ' ' )
			Conout('A610RetWF - Status: '+cCR_STATUS+' Situação: '+cSituacao+' Filial: '+cCR_FILIAL+' Número PC: '+cCR_NUM)
			SCR->( dbSetOrder( 2 ) )
			If SCR->( dbSeek( cCR_FILIAL + cTP_DOC + cCR_NUM ) )
				While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == cCR_FILIAL .AND. SCR->CR_NUM == cCR_NUM
					SCR->( RecLock( 'SCR', .F. ) )
					SCR->CR_STATUS  := cCR_STATUS // 03-Liberado pelo usuario ou 04-Bloqueado pelo usuario.
					SCR->CR_DATALIB := dDataBase
					If .NOT. Empty( SCR->CR_LOG ) .AND. Empty( cQuebra )
						cQuebra := CRLF
					Endif
					SCR->CR_LOG := RTrim( SCR->CR_LOG ) + ;
						cQuebra +;
						cUserAprov +;
						Iif( cAprovacao == 'S', ' aprovou', ' rejeitou' ) +;
						' a capa de despesa em ' +;
						Dtoc( MsDate() ) +;
						' ' +;
						Time() +;
						' via WorkFlow.'
					SCR->( MsUnLock() )
					SCR->( dbSkip() )
				End
				
				// Rotina para avisar usuários do planejamento financeiro que a capa de despesa foi aprovada/rejaitada.
				A610MPlanF( cPedCompras, cSituacao, cMotivo )
				
				// Se rejeitou, estornar a medição e logo avisar o usuário que iniciou o processo que a capa de despesa foi rejeitada.
				If cAprovacao == 'N'
					// Pedido de compras e/ou cotação.
					If Empty( cContrato ) .AND. Empty( cMedicao )
						// Avisar o usuário que iniciou o processo que a capa de despesa foi rejeitada e o pedido de compras ficará congelado.
						A610MsgUser( cAprovacao, cSituacao, cMotivo )
						
					// Estornar a medição
					Else
						If .NOT. GetMv( cMV_610SINC, .T. )
							CriarSX6( cMV_610SINC, 'C', 'ESTABECELER SE A REJEICAO DA CAPA DE DESPESA SERA A=ASSINCRONO OU S=SINCRONO - ROTINA CSFA610.prw', 'A' )
						Endif
						If GetMv( cMV_610SINC, .F. ) == 'S'
							If A610EstMed( cMedicao )
								// Avisar o usuário que iniciou o processo que a capa de despesa foi rejeitada e a medição foi estornada.
								A610MsgUser( cAprovacao, cSituacao, cMotivo )
							Endif
						Else
							A610DicPB6()
							A610LogRej( { cCodElab, cPedCompras, cMedicao, cMotivo, cWFMailID } )
							A610MsgUser( cAprovacao, cSituacao, cMotivo )
						Endif
					Endif
				// Se aprovou, apenas avisar o usuário que iniciou o processo que a capa de despesa foi aprovada.
				Else
					If Empty( cMotivo )
						cMotivo := 'Não foi declarado nenhum motivo.'
					Endif
					A610MsgUser( cAprovacao, cSituacao, cMotivo )
					
					U_A610WFPC()
				Endif
			Endif
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610LogRej  | Autor | Robson Gonçalves       | Data | 15.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para gravar log de rejeição da capa de despesa.
//        | //Conteúdo do vetor { cCodElab, cPedCompras, cMEdicao, cMotivo, cWFMailID }
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610LogRej( aPROC )
	Local nHifen2 := At( '-', aPROC[ 2 ] )
	Local nHifen3 := At( '-', aPROC[ 3 ] )
	PB6->( RecLock( 'PB6', .T. ) )
	PB6->PB6_FILIAL := SubStr( aPROC[ 2 ], 1, nHifen2-1 )
	PB6->PB6_STATUS := '0' //Aguradando.
	PB6->PB6_MODO   := '1' //Automático.
	PB6->PB6_NUMMED := SubStr( aPROC[ 3 ], nHifen3+1 )
	PB6->PB6_NUM_PC := SubStr( aPROC[ 2 ], nHifen2+1 )
	PB6->PB6_ELABOR := aPROC[ 1 ]
	PB6->PB6_MAILID := aPROC[ 5 ]
	PB6->PB6_MOTIVO := aPROC[ 4 ]
	PB6->PB6_DTGRAV := MsDate()
	PB6->PB6_HRGRAV := Time()
	PB6->PB6_RETORN := '0' //Aguardando
	PB6->( MsUnLock() )
Return

//--------------------------------------------------------------------------
// Rotina | CSFA610B    | Autor | Robson Gonçalves       | Data | 15.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina executada por JOB ou via MENU de usuário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA610B( aParam )
	Local lA610BAuto := ( Select( 'SX6' ) == 0 )
	Private cCadastro := 'Controle da Rejeição da Capa de Despesa'
	
	DEFAULT aParam := { '01', '02' }
	
	Conout('CSFA610B - Iniciando a rotina do processo de rejeição da capa de despesa.')
	If lA610BAuto
		A610Job( aParam )
	Else
		A610Browse()
	Endif
	Conout('CSFA610B - Finalizadno a rotina do processo de rejeição da capa de despesa.')
Return

//--------------------------------------------------------------------------
// Rotina | A610Job     | Autor | Robson Gonçalves       | Data | 15.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para preparar a iniciação do processo do JOB.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Job( aParam )
	Local cEmp := ''
	Local cFil := ''
	Private aMsgLog := {}
	
	Conout('CSFA610B - A610Job - Operação sendo efetuada no modo JOB.')
		
	cEmp := Iif( aParam == NIL, '01', aParam[ 1 ] )
	cFil := Iif( aParam == NIL, '02', aParam[ 2 ] )
	
	Conout('CSFA610B - A610PrcJob - Operação processando registros da empresa '+cEmp+' e filial '+cFil)
	
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'GCT' TABLES 'CND','CNE','SC7'
	Conout('CSFA610B - A610Job - Executar A610PrcJob.')
	A610PrcJob()
	Conout('CSFA610B - A610Job - Fim da execução A610PrcJob.')
	RESET ENVIRONMENT
Return

//--------------------------------------------------------------------------
// Rotina | A610Browse  | Autor | Robson Gonçalves       | Data | 15.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina executada via interface de usuário. Ele determina a 
//        | execução do processamento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Browse()
	Local cMV_610SINC := 'MV_610SINC'
	Local aLeg := {}
	Private aRotina := {}
	
	Conout('CSFA610B - Operação sendo efetuada no modo manual.')
	
	A610DicPB6()
	
	If .NOT. GetMv( cMV_610SINC, .T. )
		CriarSX6( cMV_610SINC, 'C', 'ESTABECELER SE A REJEICAO DA CAPA DE DESPESA SERA A=ASSINCRONO OU S=SINCRONO - ROTINA CSFA610.prw', 'A' )
	Endif
	If GetMv( cMV_610SINC, .F. ) == 'A'
		
		SetKey( VK_F11 , {|| A610VisLog() } )
		
		AAdd( aLeg, { 'PB6_STATUS=="0"', 'BR_VERMELHO' } )
		AAdd( aLeg, { 'PB6_STATUS=="1"', 'BR_AMARELO' } )
		AAdd( aLeg, { 'PB6_STATUS=="2"', 'BR_VERDE' } )
		AAdd( aLeg, { 'PB6_STATUS=="3"', 'BR_AZUL' } )
		
		AAdd( aRotina, { 'Pesquisar' , 'AxPesqui'  , 0, 1, 0, .F. } )
		AAdd( aRotina, { 'Visualizar', 'AxVisual'  , 0, 4, 0, NIL } )
		AAdd( aRotina, { 'Processar' , 'U_A610Proc', 0, 4, 0, NIL } )
		AAdd( aRotina, { 'Legenda'   , 'U_A610Leg' , 0, 6, 0, NIL } )
		
		dbSelectArea( 'PB6' )
		dbSetORder( 1 )
		mBrowse(,,,,'PB6',,,,,,aLeg)
		
		SetKey( VK_F1, NIL )
	Else
		Help('',1,'MV_610SINC',,'O parâmetro "MV_610SINC" está configurador para processar ASSINCRONO o retorno do WF da aprovação da Capa de Despesa.',1,1)
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610Leg | Autor | Robson Gonçalves           | Data | 24.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para apresentar a explicação da legenda dos registros.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Leg()
	Local aLeg := {}
	AAdd( aLeg, { 'BR_VERMELHO', '0 = Aguardando ser processado.' } )
	AAdd( aLeg, { 'BR_AMARELO' , '1 = Processando o registro.' } )
	AAdd( aLeg, { 'BR_VERDE'   , '2 = Sucesso - processado e finalizado.' } )
	AAdd( aLeg, { 'BR_AZUL'    , '3 = Indeferido - precisa de análise.' } )
	BrwLegenda( cCadastro, 'Legenda dos registros', aLeg )
Return

//--------------------------------------------------------------------------
// Rotina | A610VisLog  | Autor | Robson Gonçalves       | Data | 23.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para visualizar o texto da ocorrência na íntegra.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610VisLog()
	Local oDlg
	Local oBar
	Local oThb
	Local oFnt := TFont():New('Arial',,,,.F.,,,8,.T.,,,,,,,)
	Local oHis
	Local oMot
	Local oPnlButton
	Local oSplitter
	Local oPnl1
	Local oPnl2
	Local cHis := 'Não houve processamento, pois não há histórico de log registrado.'
	Local cMot := ''
	
	If .NOT. Empty( PB6->PB6_MOTIVO )
		cMot := 'M O T I V O  D A  R E J E I Ç Ã O  D O  P L A N E J A M E N T O  F I N A N C E I R O: ' + CRLF + PB6->PB6_MOTIVO
	Endif

	If .NOT. Empty( PB6->PB6_HISTOR )
		cHis := 'H I S T Ó R I C O  D E  P R O C E S S A M E N T O  D O  JOB: ' + CRLF + PB6->PB6_HISTOR
	Endif
	
	DEFINE MSDIALOG oDlg TITLE 'Visualizar ocorrências processadas pelo JOB relativo a rejeição da capa de despesa' FROM 0,0 TO 400,800 PIXEL
	oSplitter := TSplitter():New( 1, 1, oDlg, 1000, 1000, 1 )
	oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
	
	oPnl1:= TPanel():New(1,1,'',oSplitter,,,,,,60,60)
	oPnl1:Align := CONTROL_ALIGN_ALLCLIENT
				
	oPnl2:= TPanel():New(1,1,'',oSplitter,,,,,,60,60)
	oPnl2:Align := CONTROL_ALIGN_TOP
		
	oPnlButton := TPanel():New(0,0,,oDlg,,,,,,13,13,.F.,.F.)
	oPnlButton:Align := CONTROL_ALIGN_BOTTOM
		
	oBar := TBar():New( oPnlButton, 10, 9, .T.,'BOTTOM')
		
	oThb := THButton():New( 1, 1, '&Sair', oBar, {|| oDlg:End() } , 20, 12, oFnt )
	oThb:Align := CONTROL_ALIGN_RIGHT
		
	@ 5,5 GET oMot VAR cMot MEMO SIZE 200,145 OF oPnl1 PIXEL
	oMot:Align := CONTROL_ALIGN_ALLCLIENT
	oMot:bRClicked := {|| AllwaysTrue() }
	oMot:oFont:=oFnt

	@ 5,5 GET oHis VAR cHis MEMO SIZE 200,145 OF oPnl2 PIXEL
	oHis:Align := CONTROL_ALIGN_ALLCLIENT
	oHis:bRClicked := {|| AllwaysTrue() }
	oHis:oFont:=oFnt
	ACTIVATE MSDIALOG oDlg CENTERED
Return

//--------------------------------------------------------------------------
// Rotina | A610Proc    | Autor | Robson Gonçalves       | Data | 15.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar se o registro pode ser processado via
//        | usuário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Proc( cAlias, nRecNo, nOpcX )
	If PB6->PB6_STATUS == '0'
		A610PrcJob( .T. )
	Else
		Help('',1,'A610Proc',,'Somente processo pendente no status aguardando que será possível processar.',1,1)
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610PrcJob  | Autor | Robson Gonçalves       | Data | 15.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento por JOB
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610PrcJob( lManual )
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	Local cTRB_UPD := GetNextAlias()
	Local cUPD := ''
	Local cReturn := ''
	Local cToBreak := ''
	Local cPerg := 'A610PB6'
	
	Local dPB6_DTPROC := MsDate()
	Local cPB6_HIPROC := Time()
	
	Local lCND_Lock := .F.
	Local lCNE_Lock := .F.
	Local lSC7_Lock := .F.
	
	Private cPedCompras := ''
	Private cMedicao := ''
	Private cContrato := ''
	
	DEFAULT lManual := .F.
	
	If lManual
		A610SX1PB6( cPerg )
		If .NOT. Pergunte( cPerg, .T. )
			Help('',1,'A610PrcJob',,'Rotina abandonada pelo usuário.',1,1)
			Return
		Endif
	Endif
	
	cSQL := "SELECT PB6_FILIAL, "
	cSQL += "       PB6_STATUS, "
	cSQL += "       PB6_MODO, "
	cSQL += "       PB6_NUMMED, "
	cSQL += "       PB6_NUM_PC, "
	cSQL += "       PB6_ELABOR, "
	cSQL += "       PB6_MOTIVO, "
	cSQL += "       PB6_RETORN, "
	cSQL += "       R_E_C_N_O_ AS PB6RECNO "
	cSQL += "FROM   "+RetSqlName( 'PB6' )+" PB6 "
	
	If lManual
		cSQL += "WHERE  PB6_FILIAL >= '"+mv_par01+"' "
		cSQL += "       AND PB6_FILIAL <= '"+mv_par02+"' "
		cSQL += "       AND PB6_NUMMED >= '"+mv_par03+"'"
		cSQL += "       AND PB6_NUMMED <= '"+mv_par04+"'"
		cSQL += "       AND PB6_NUM_PC >= '"+mv_par05+"'"
		cSQL += "       AND PB6_NUM_PC <= '"+mv_par06+"'"
		cSQL += "       AND PB6_STATUS = '0' "
		cSQL += "       AND ( PB6_RETORN = '0' "
		cSQL += "        OR PB6_RETORN = '1' ) "
		cSQL += "       AND PB6.D_E_L_E_T_ = ' ' "
	Else
		cSQL += "WHERE  PB6_FILIAL >= '"+Space( Len( PB6->PB6_FILIAL ) )+"' "
		cSQL += "       AND PB6_FILIAL <= '"+Replicate( 'z', Len( PB6->PB6_FILIAL ) )+"' "
		cSQL += "       AND PB6_STATUS = '0' "
		cSQL += "       AND ( PB6_RETORN = '0' "
		cSQL += "        OR PB6_RETORN = '1' ) "
		cSQL += "       AND PB6.D_E_L_E_T_ = ' ' "
	Endif
	//------------------------
	// Efetuar parse da query.
	cSQL := ChangeQuery( cSQL )
	Conout('CSFA610B - A610PrcJob - String de query select a ser processada: '+cSQL)
	//--------------------------------------------------------------
	// Alias para update e reservar os registros para processamento.
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL ), cTRB_UPD, .F., .T. )
	//--------------------------------------------------------------
	// Se não localizar dados, sair imediatamente..
	If (cTRB_UPD)->( BOF() ) .AND. (cTRB_UPD)->( EOF() )
		Help('',1,'A610PrcJob',,'Não foi possível localizar registros com os parâmetros informados.',1,1)
		Return
	Endif
	//----------------------------
	// Alias para o processamento.
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL ), cTRB, .F., .T. )
	//------------------------------------------------------
	// Reservar os registros disponíveis para este processo.
	While (cTRB_UPD)->( .NOT. EOF() )
		cUPD := "UPDATE "+RetSqlName('PB6')+" SET PB6_STATUS = '1' WHERE R_E_C_N_O_ = "+LTrim( Str( (cTRB_UPD)->( PB6RECNO ) ) )+" "
		Conout('CSFA610B - A610PrcJob - String de query update a ser processada: '+cUPD)
		TcSqlExec( cUPD )
		(cTRB_UPD)->( dbSkip() )
	End
	(cTRB_UPD)->( dbCloseArea() )
	//------------------------
	// Processar os registros.
	While (cTRB)->( .NOT. EOF() )
		//---------------------------------
		// Posicionar no registro original.
		PB6->( dbGoTo( (cTRB)->( PB6RECNO ) ) )
		//-------------------------------------------------------------------------------------
		// Alimentar as variáveis para as próximas funções e compatibilização do aviso e do WF.
		cPedCompras := PB6->( PB6_FILIAL + PB6_NUM_PC )
		cMedicao    := PB6->( PB6_FILIAL + PB6_NUMMED )
		cContrato   := CND->( Posicione( 'CND', 4, PB6->( PB6_FILIAL + PB6_NUMMED ), 'CND_CONTRA' ) )
		
		Conout('CSFA610B - A610PrcJob - Processando registro de filial + medição: '+(cTRB)->PB6_FILIAL+(cTRB)->PB6_NUMMED)
		Conout('CSFA610B - A610PrcJob - Processando registro de filial + pedido: '+(cTRB)->PB6_FILIAL + (cTRB)->PB6_NUM_PC)
		
		//---------------------------------------------
		// Verificar se o registro já possiu histórico.
		If .NOT. Empty( PB6->PB6_HISTOR )
			cToBreak := CRLF
		Endif
		//------------------------------------------------------------
		// Verificar se os registros estão desbloqueado para gravação.
		lCND_Lock := A610LckRec( 'CND', 4, (cTRB)->PB6_FILIAL + (cTRB)->PB6_NUMMED )
		lCNE_Lock := A610LckRec( 'CNE', 4, (cTRB)->PB6_FILIAL + (cTRB)->PB6_NUMMED )
		lSC7_Lock := A610LckRec( 'SC7', 1, (cTRB)->PB6_FILIAL + (cTRB)->PB6_NUM_PC )
		
		Conout('CSFA610B - A610PrcJob - Resultado dos testes dos bloqueios nos registros: '+'CND['+Iif(lCND_Lock,'S','N') + ']-CNE['+Iif(lCNE_Lock,'S','N') + ']-SC7['+Iif(lSC7_Lock,'S','N')+']')
		
		//---------------------
		// Estão desbloqueados?
		If ( lCND_Lock .AND. lCNE_Lock .AND. lSC7_Lock )
			A610EstMed( (cTRB)->PB6_FILIAL + '-' + (cTRB)->PB6_NUMMED )
			cReturn  := A610ChkEstorno()
			If SubStr( cReturn, 1, 2 ) == 'OK'
				PB6->( RecLock( 'PB6', .F. ) )
				PB6->PB6_MODO   := Iif( lManual, '2', '1' )
				PB6->PB6_STATUS := '2' //SUCESSO
				PB6->PB6_DTPROC := dPB6_DTPROC
				PB6->PB6_HIPROC := cPB6_HIPROC
				PB6->PB6_HFPROC := Time()
				PB6->PB6_RETORN := '2' //SUCESSO
				PB6->PB6_HISTOR := AllTrim( PB6->PB6_HISTOR ) + cToBreak + 'DT ' + Dtoc( dPB6_DTPROC ) + ' HR '+Time() + ' ' + cReturn
				PB6->( MsUnLock() )
				U_A610WFPC()
			Else
				PB6->( RecLock( 'PB6', .F. ) )
				PB6->PB6_STATUS := '0' //AGUARDANDO
				PB6->PB6_RETORN := '1' //FALHOU
				PB6->PB6_HISTOR := AllTrim( PB6->PB6_HISTOR ) + cToBreak + 'DT ' + Dtoc( dPB6_DTPROC ) + ' HR '+Time() + ' ' + cReturn
				PB6->( MsUnLock() )
			Endif
		Else
			//------------------------------------------------------------------------------------------------------
			// Problema na integridade entre a medição e o pedido e fim do processamento para o registro em questão.
			If PB6->( PB6_FILIAL + PB6_NUM_PC ) <> CND->( CND_FILIAL + CND_PEDIDO )
				PB6->( RecLock( 'PB6', .F. ) )
				PB6->PB6_MODO   := Iif( lManual, '2', '1' )
				PB6->PB6_STATUS := '3' //INDEFERIDO
				PB6->PB6_DTPROC := dPB6_DTPROC
				PB6->PB6_HIPROC := cPB6_HIPROC
				PB6->PB6_HFPROC := Time()
				PB6->PB6_RETORN := '1' //FALHOU
				PB6->PB6_HISTOR := AllTrim(PB6->PB6_HISTOR)+cToBreak+'O BLOQUEIO FALHOU NA ['+Iif(lCND_Lock,'','CND')+' '+Iif(lCNE_Lock,'','CNE')+' '+Iif(lSC7_Lock,'','SC7')+'] E ESTÁ INCOMPATÍVEL O Nº DO PC NA SC7 COM O Nº DO PC NA CND. DT: '+Dtoc(MsDate())+' HR: '+cPB6_HIPROC+'.'
				PB6->( MsUnLock() )
			Else
				//---------------------------------------------------------
				// Não estão desbloqueados, portanto registrar a tentativa.
				PB6->( RecLock( 'PB6', .F. ) )
				PB6->PB6_STATUS := '0' //AGUARDANDO
				PB6->PB6_RETORN := '1' //FALHOU
				PB6->PB6_HISTOR := AllTrim(PB6->PB6_HISTOR)+cToBreak+'BLOQUEIO FALHOU NA ['+Iif(lCND_Lock,'','CND')+' '+Iif(lCNE_Lock,'','CNE')+' '+Iif(lSC7_Lock,'','SC7')+'] DT: '+Dtoc(MsDate())+' HR: '+cPB6_HIPROC+'.'
				PB6->( MsUnLock() )
			Endif
		Endif
		
		Conout('CSFA610B - A610PrcJob - Resultado do processamento: '+cReturn)
		
		cToBreak := ''
		//----------------------------
		// Ir para o próximo registro.
		(cTRB)->( dbSkip() )
	End
	//---------------
	// Fechar a view.
	(cTRB)->( dbCloseArea() )
Return

//--------------------------------------------------------------------------
// Rotina | A610LckRec | Autor | Robson Gonçalves        | Data | 15.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar se o registro pode ser bloqueado para upd.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610LckRec( cAlias, nOrder, cSeek )
	Local lLock := .F.
	(cAlias)->( dbSetOrder( nOrder ) )
	(cAlias)->( dbSeek( cSeek ) )
	lLock := (cAlias)->( MsRLock( RecNo() ) )
	If lLock
		(cAlias)->( MsRUnLock( RecNo() ) )
	Endif
Return( lLock )

//--------------------------------------------------------------------------
// Rotina | A610ChkEstorno | Autor | Robson Gonçalves    | Data | 15.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina p/ verificar se os processos realmente foram estornados.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610ChkEstorno()
	Local lNumPC := .F.
	Local lSeekSC7 := .F.
	Local cReturn := ''
	Local cNomAutLog := ''
	Local cConteuLog := ''
	//--------------------------------------
	// Possui número de pedido em CND e CNE?
	lNumPC := .NOT. Empty( CND->CND_PEDIDO ) .AND.  .NOT. Empty( CNE->CNE_PEDIDO )
	//--------------------------------------------------------
	// Tenta localizar o pedido de compras relativo a medição.
	lSeekSC7 := SC7->( dbSeek( PB6->PB6_FILIAL + PB6->PB6_NUM_PC ) )
	//----------------------------------------------
	// Possui número de PC na medição e existe o PC.
	If lNumPC .AND. lSeekSC7
		//-------------------------
		// Capturar o log caso haja.
		cNomAutLog := NomeAutoLog()
		If .NOT. Empty( cNomAutLog )
			cConteuLog := MemoRead( cNomAutLog )
		Else
			cConteuLog := 'NÃO FOI POSSÍVEL CAPTURAR O CONTEÚDO DO ERROR.LOG DO MSEXECAUTO.'
		Endif
		cReturn := 'NÃO CONSEGUIU ESTORNAR CONFORME LOG: ' + cConteuLog + '.'
	Endif
	//------------------------------------------------------
	// Não possui número de PC na medição e não existe o PC.	
	If .NOT. lNumPC .AND. .NOT. lSeekSC7
		cReturn := 'OK - CONSEGUIU ESTORNAR A MEDIÇÃO E EXCLUIU O PC.'
	Endif
	//--------------------------------------------------
	// Possui número de PC na medição e não existe o PC.	
	If lNumPC .AND. .NOT. lSeekSC7
		cReturn := 'PROBLEMA AO ESTORNAR. EXCLUIU O PC E NÃO ESTORNOU A MEDIÇÃO, PORÉM REESTABELECI O PC.'
		SET DELETED OFF
		SC7->( dbSetOrder( 1 ) )
		SC7->( dbSeek( PB6->PB6_FILIAL + PB6->PB6_NUM_PC ) )
		While SC7->( .NOT. EOF() ) .AND. SC7->C7_FILIAL == PB6->PB6_FILIAL .AND. SC7->C7_NUM == PB6->PB6_NUM_PC
			If SC7->( Deleted() )
				SC7->( dbRecall() )
			Endif
			SC7->( dbSkip() )
		End
	Endif
	SET DELETED ON
	//--------------------------------------------------
	// Não possui número de PC na medição e existe o PC.	
	If .NOT. lNumPC .AND. lSeekSC7
		cReturn := 'PROBLEMA AO ESTORNAR. ESTORNOU A MEDIÇÃO E NÃO EXCLUIU O PC, PORÉM O JOB EXCLUIU O PC.'
		SC7->( dbSetOrder( 1 ) )
		SC7->( dbSeek( PB6->PB6_FILIAL + PB6->PB6_NUM_PC ) )
		While SC7->( .NOT. EOF() ) .AND. SC7->C7_FILIAL == PB6->PB6_FILIAL .AND. SC7->C7_NUM == PB6->PB6_NUM_PC
			SC7->( RecLock( 'SC7', .F. ) )
			SC7->( dbDelete() )
			SC7->( MsUnLock() )
			SC7->( dbSkip() )
		End
	Endif
Return( cReturn )

//--------------------------------------------------------------------------
// Rotina | A610DicPB6  | Autor | Robson Gonçalves       | Data | 15.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para criar o dicionário de dados.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610DicPB6()
	Local nI := 0
	Local aSX3 := {}
	Local aSIX := {}
	Local lDbSelect := .F.
	Local aArea := GetArea()
	Begin Transaction
		SX2->( dbSetOrder( 1 ) )
		If .NOT. SX2->( dbSeek( 'PB6' ) )
			SX2->( RecLock( 'SX2', .T. ) )
			SX2->X2_CHAVE   := 'PB6'
			SX2->X2_ARQUIVO := 'PB6' + cEmpAnt + '0'
			SX2->X2_NOME    := 'Controle da rejeicao capa desp'
			SX2->X2_NOMESPA := 'Controle da rejeicao capa desp'
			SX2->X2_NOMEENG := 'Controle da rejeicao capa desp'
			SX2->X2_MODO    := 'E'
			SX2->X2_MODOUN  := 'E'
			SX2->X2_MODOEMP := 'E'
			SX2->X2_PYME    := 'N'
			SX2->( MsUnLock() )
			lDbSelect := .T.
		Endif
		AAdd( aSX3, { 'PB6', '01', 'PB6_FILIAL', 'C', 2, 0, 'Filial'      , 'Filial do sistema'     , '@!', '' } )
		AAdd( aSX3, { 'PB6', '02', 'PB6_STATUS', 'C', 1, 0, 'Status'      , 'Status do registro'    , '@!', '0=AGUARDANDO; 1=PROCESSANDO; 2=SUCESSO; 3=INDEFERIDO' } )
		AAdd( aSX3, { 'PB6', '03', 'PB6_MODO'  , 'C', 1, 0, 'Modo Oper.'  , 'Modo de operacao'      , '@!', '1=AUTOMATICO; 2=MANUAL' } )
		AAdd( aSX3, { 'PB6', '04', 'PB6_NUMMED', 'C', 6, 0, 'Medicao'     , 'Numero da medicao'     , '@!', '' } )
		AAdd( aSX3, { 'PB6', '05', 'PB6_NUM_PC', 'C', 6, 0, 'Ped.Compras' , 'Num.pedido de compras' , '@!', '' } )
		AAdd( aSX3, { 'PB6', '06', 'PB6_ELABOR', 'C', 6, 0, 'Elaborador'  , 'Codigo do elaborador'  , '@!', '' } )
		AAdd( aSX3, { 'PB6', '07', 'PB6_MAILID', 'C',20, 0, 'Mail ID WF'  , 'Codigo MailID WF'      , '@!', '' } )
		AAdd( aSX3, { 'PB6', '08', 'PB6_MOTIVO', 'M',10, 0, 'Motivo'      , 'Motivo'                , '@!', '' } )
		AAdd( aSX3, { 'PB6', '09', 'PB6_DTGRAV', 'D', 8, 0, 'Dt.Gravacao' , 'Data de gravacao'      , ''  , '' } )
		AAdd( aSX3, { 'PB6', '10', 'PB6_HRGRAV', 'C', 8, 0, 'Hr.Gravacao' , 'Hora de gravacao'      , ''  , '' } )
		AAdd( aSX3, { 'PB6', '11', 'PB6_DTPROC', 'D', 8, 0, 'Dt.Process.' , 'Data do processamento' , ''  , '' } )
		AAdd( aSX3, { 'PB6', '12', 'PB6_HIPROC', 'C', 8, 0, 'Hr.Ini.Proc.', 'Hr.Inicial do process.', ''  , '' } )
		AAdd( aSX3, { 'PB6', '13', 'PB6_HFPROC', 'C', 8, 0, 'Hr.Fim Proc.', 'Hr.Final do process.'  , ''  , '' } )
		AAdd( aSX3, { 'PB6', '14', 'PB6_RETORN', 'C', 1, 0, 'Retorno'     , 'Codigo de retorno'     , '@!', '0=AGUARDANDO; 1=FALHOU; 2=SUCESSO' } )
		AAdd( aSX3, { 'PB6', '15', 'PB6_HISTOR', 'M',10, 0, 'Historico'   , 'Historico'             , '@!', '' } )
		SX3->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aSX3 )
			If .NOT. SX3->( dbSeek( aSX3[ nI, 1 ] + aSX3[ nI, 2 ] ) )
				SX3->( RecLock( 'SX3', .T. ) )
				SX3->X3_ARQUIVO := aSX3[ nI, 1 ]
				SX3->X3_ORDEM   := aSX3[ nI, 2 ]
				SX3->X3_CAMPO   := aSX3[ nI, 3 ]
				SX3->X3_TIPO    := aSX3[ nI, 4 ]
				SX3->X3_TAMANHO := aSX3[ nI, 5 ]
				SX3->X3_DECIMAL := aSX3[ nI, 6 ]
				SX3->X3_TITULO  := aSX3[ nI, 7 ]
				SX3->X3_TITSPA  := aSX3[ nI, 7 ]
				SX3->X3_TITENG  := aSX3[ nI, 7 ]
				SX3->X3_DESCRIC := aSX3[ nI, 8 ]
				SX3->X3_DESCSPA := aSX3[ nI, 8 ]
				SX3->X3_DESCENG := aSX3[ nI, 8 ]
				SX3->X3_PICTURE := aSX3[ nI, 9 ]
				SX3->X3_USADO   := '€€€€€€€€€€€€€€'
				SX3->X3_NIVEL   := 0
				SX3->X3_RESERV  := 'þA'
				SX3->X3_PROPRI  := 'U'
				SX3->X3_BROWSE  := 'S'
				SX3->X3_VISUAL  := 'V'
				SX3->X3_CONTEXT := 'R'
				SX3->X3_CBOX    := aSX3[ nI, 10]
				SX3->X3_CBOXSPA := aSX3[ nI, 10]
				SX3->X3_CBOXENG := aSX3[ nI, 10]
				SX3->X3_PYME    := 'N'
				SX3->X3_IDXSRV  := 'N'
				SX3->X3_ORTOGRA := 'N'
				SX3->X3_IDXFLD  := 'N'
				SX3->( MsUnLock() )
				lDbSelect := .T.
			Endif
		Next nI
		SIX->( dbSetOrder( 1 ) )
		AAdd( aSIX, { 'PB6', '1', 'PB6_FILIAL+PB6_STATUS+PB6_NUMMED+PB6_RETORN', 'Filial + Status + Medicao + Retorno' } )
		AAdd( aSIX, { 'PB6', '2', 'PB6_FILIAL+PB6_NUMMED', 'Filial + Medicao' } )
		For nI := 1 To Len( aSIX )
			If .NOT. SIX->( dbSeek( aSIX[ nI, 1 ] + aSIX[ nI, 2 ] ) )
				SIX->( RecLock( 'SIX', .T. ) )
				SIX->INDICE    := aSIX[ nI, 1 ]
				SIX->ORDEM     := aSIX[ nI, 2 ]
				SIX->CHAVE     := aSIX[ nI, 3 ]
				SIX->DESCRICAO := aSIX[ nI, 4 ]
				SIX->DESCSPA   := aSIX[ nI, 4 ]
				SIX->DESCENG   := aSIX[ nI, 4 ]
				SIX->PROPRI    := 'U'
				SIX->SHOWPESQ  := 'S'
				SIX->( MsUnLock() )
				lDbSelect := .T.
			Endif
		Next nI
		If lDbSelect
			dbSelectArea( 'PB6' )
			dbSetOrder( 1 )
		Endif
	End Transaction
	RestArea( aArea )
Return

//--------------------------------------------------------------------------
// Rotina | A610SX1PB6  | Autor | Robson Gonçalves       | Data | 17.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para criar o dicionário do grupo de perguntas para os
//        | parâmetros de processamento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610SX1PB6( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}
	/*
	---------------------------------------------------
	Característica do vetor p/ utilização da função SX1
	---------------------------------------------------
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
	[n,13] -> Cnt01
	*/
	AAdd(aP,{"A partir da filial?"           ,"C",2,0,"G",""                    ,"SM0_01","","","","","",""})
	AAdd(aP,{"Ate a filial?"                 ,"C",2,0,"G","(mv_par02>=mv_par01)","SM0_01","","","","","",""})
	AAdd(aP,{"A partir da medicao?"          ,"C",6,0,"G",""                    ,"CND","","","","","",""})
	AAdd(aP,{"Ate a medicao?"                ,"C",6,0,"G","(mv_par04>=mv_par03)","CND","","","","","",""})
	AAdd(aP,{"A partir de pedido de compra?" ,"C",6,0,"G",""                    ,"SC7","","","","","",""})
	AAdd(aP,{"Ate o pedido de compra?"       ,"C",6,0,"G","(mv_par06>=mv_par05)","SC7","","","","","",""})

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
			NIL,;
			NIL,;
			NIL,;
			"")
	Next i
Return

//--------------------------------------------------------------------------
// Rotina | A610MPlanF  | Autor | Robson Gonçalves       | Data | 08.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para avisar usuários do planejamento financeiro que a 
//        | capa de despesa foi aprovada/rejaitada.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610MPlanF( cPedCompras, cSituacao, cMotivo )
	Local cAux1 := ''
	Local cAux2 := ''
	Local cHTML := ''
	Local cUserAprov := '.'
	Local cMV_610PFIN := 'MV_610PFIN'
	Local cEMail := ''
	
	Local nI := 0
	Local nCount := 0
	Local nHashTag := 0
	
	nHashtag := At( '#', cMotivo )

	If nHashTag > 0
		cUserAprov := AllTrim( SubStr( cMotivo, nHashtag + 1 ) )
		For nI := 1 To Len( cUserAprov )
			nCount++
			If SubStr( cUserAprov, nI, 1 ) == ' '
				Exit
			Endif
		Next nI
		cAux1 := ' pelo usu&aacute;rio <strong>' +SubStr( cUserAprov, 1, nCount-1 ) + '.'
		cAux2 := StrTran( cMotivo, '#'+cUserAprov, ' ' )
		
		cUserAprov := cAux1
		cMotivo    := cAux2
	Endif

	cHTML += '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
	cHTML += '<html>'
	cHTML += '	<head>'
	cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
	cHTML += '		<title>Status de Aprova&ccedil;&atilde;o da capa de despesa</title>'
	cHTML += '	</head>'
	cHTML += '	<body>'
	cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
	cHTML += '			<tbody>'
	cHTML += '				<tr>'
	cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle">'
	cHTML += '						<em><span style="font-size:20px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>Status de Aprova&ccedil;&atilde;o da Capa de Despesa</strong></font></span><br />'
	cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em>'
	cHTML += '						<p>'
	cHTML += '							&nbsp;</p>'
	cHTML += '					</td>'
	cHTML += '					<td align="right" width="210">'
	cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
	cHTML += '						&nbsp;</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#F4811D" colspan="2" height="4" width="0">'
	cHTML += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding:5px;" width="0">'
	cHTML += '						<p>'
	cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Prezado(s),</font></span></span></p>'
	cHTML += '						<p>'
	cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">A Capa de Despesa relativa ao pedido de compras n&ordm;&nbsp;<strong>'+cPedCompras+'</strong> foi <strong>'+cSituacao+'</strong>'+cUserAprov+'</font></span></span></p>'
	cHTML += '						<p>'
	cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Motivo: '+cMotivo+'</font></span></span></p>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#02519B" colspan="2" height="2" width="0">'
	cHTML += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding:5px" width="0">'
	cHTML += '						<p align="left">'
	cHTML += '							<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '			</tbody>'
	cHTML += '		</table>'
	cHTML += '		<p>'
	cHTML += '			&nbsp;</p>'
	cHTML += '	</body>'
	cHTML += '</html>'
	
	cMV_610PFIN := GetMv( cMV_610PFIN, .F. )
	
	cEMail := A610UsrPF( cMV_610PFIN )
	
	Conout('A610MPlanF - Envio de e-mail de aviso p/ o planejamento financeiro - PC:'+cPedCompras+' Situação:'+cSituacao+' Motivo:'+cMotivo+' e-mail:'+cEMail)
	
	If .NOT. Empty( cEMail )
		If l610OnMsg
			FSSendMail( cEMail, 'Status - Aprov. Capa de Despesa - PC nº '+cPedCompras, cHTML, /*cAnexo*/ )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610UsrPF   | Autor | Robson Gonçalves       | Data | 12.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para buscar os e-mail dos usuários do planejamento 
//        | financeiro.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610UsrPF( cMV_610PFIN )
	Local cEMail := ''
	Local aArea := {}
	aArea := { SAL->( GetArea() ), GetArea() }
	SAL->( dbSetOrder( 1 ) )
	SAL->( dbSeek( xFilial( 'SAL' ) + cMV_610PFIN ) )
	While SAL->( .NOT. EOF() ) .AND. SAL->AL_FILIAL == xFilial( 'SAL' ) .AND. SAL->AL_COD == cMV_610PFIN
		If SAL->AL_MSBLQL <> '1'
			cEMail += RTrim( UsrRetMail( SAL->AL_USER ) ) + ';'
		Endif
		SAL->( dbSkip() )
	End
	cEMail := SubStr( cEMail, 1, Len( cEMail )-1 )
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return( cEMail )

//--------------------------------------------------------------------------
// Rotina | A610EstMed  | Autor | Robson Gonçalves       | Data | 03.11.2015
//--------------------------------------------------------------------------
// Descr. | Rotina para estornar a medição do contrato.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610EstMed( cMedicao )
	Local aArea := {}
	
	Local aCab := {}
	Local aItem := {}
	Local aItens := {}
	
	Local lRet := .T.
	Local lFixo := .F.
	Local lDebug := .F.
	
	Local cCN9_FILIAL := ''
	Local cNomAutLog := ''
	Local cConteuLog := ''
	Local lMV_RESTPED := .F.
	
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	
	aArea:= { CND->( GetArea() ), CNE->( GetArea() ) }
	
	If Len( cMedicao ) == Len( CND->CND_NUMMED )
		cMedicao := xFilial( 'CND' ) + cMedicao
	Else
		If '-' $ cMedicao
			cMedicao := StrTran( cMedicao, '-', '' )
		Endif
	Endif
	
	CND->( dbSetOrder( 4 ) )
	If CND->( dbSeek( cMedicao ) )
		
		CN9->( dbSetOrder( 1 ) )
		CN9->( dbSeek( xFilial( 'CN9' ) + CND->CND_CONTRA + CND->CND_REVISA ) )
		
		CN1->( dbSetOrder( 1 ) )
		CN1->( dbSeek( xFilial( 'CN1' ) + CN9->CN9_TPCTO ) )
		
		lFixo  := ( Empty( CN1->CN1_CTRFIX ) .OR. ( CN1->CN1_CTRFIX == "1" ) )
		
		AAdd( aCab, { 'CND_FILIAL', CND->CND_FILIAL, NIL } )
		AAdd( aCab, { 'CND_NUMMED', CND->CND_NUMMED, NIL } )
		AAdd( aCab, { 'CND_CONTRA', CND->CND_CONTRA, NIL } )
		AAdd( aCab, { 'CND_REVISA', CND->CND_REVISA, NIL } )
		AAdd( aCab, { 'CND_NUMERO', CND->CND_NUMERO, NIL } )
		
		CNE->( dbSetOrder( 1 ) )
		CNE->( dbSeek( CND->( CND_FILIAL + CND_CONTRA + CND_REVISA + CND_NUMERO + CND_NUMMED ) ) )
			
		While CNE->( .NOT. EOF() ) .AND. ;
				CNE->CNE_FILIAL == CND->CND_FILIAL .AND. ;
				CNE->CNE_CONTRA == CND->CND_CONTRA .AND. ;
				CNE->CNE_REVISA == CND->CND_REVISA .AND. ;
				CNE->CNE_NUMERO == CND->CND_NUMERO .AND. ;
				CNE->CNE_NUMMED == CND->CND_NUMMED
				
			AAdd( aItem, { 'CNE_ITEM', CNE->CNE_ITEM  , NIL } )
				
			AAdd( aItens, aItem )
			aItem := {}
				
			CNE->( dbSkip() )
		End
		
		// Este parâmetro indica se a manutencao dos Pedidos de Compras eh restrito ao seu grupo de compras/compradores.
		lMV_RESTPED := (GetMv("MV_RESTPED")=="S")
		
		// Como eh o SERVER que processa o retorno do WF e não há usuário logado, sou obrigado a tirar a 
		// restrição e depois do processamento eu retorno o conteúdo.
		If lMV_RESTPED
			PutMV("MV_RESTPED","N")
		Endif
		
		// Estornar a medição.
		lDebug := .F.
		If lDebug
			CNTA120( aCab, aItens, 7 )
		Else
			MsExecAuto( {|a,b,c|, CNTA120( a, b, c ) }, aCab, aItens, 7 )
		Endif
		
		If lMV_RESTPED
			PutMV("MV_RESTPED","S")
		Endif
		
		If lMsErroAuto
			lRet := .F.
			cNomAutLog := NomeAutoLog()
			If .NOT. Empty( cNomAutLog )
				cConteuLog := MemoRead( cNomAutLog )
			Else
				cConteuLog := 'Não foi possível capturar o erro reportado pelo Prothues.'
			Endif
			If Empty( cNomAutLog ) .OR. Empty( cConteuLog )
				FSSendMail( ;
					'sistemascorporativos@certisign.com.br', ;
					'CSFA610 - Não estornou a medição.', ;
					'Não foi possível estornar a medição do contrato por conta da rejeição da capa de despesa, medição Nº '+CND->CND_NUMMED + Chr( 13 ) + Chr( 10 ) + cConteuLog, ;
					cNomAutLog )
				
			Else
				MostraErro()
			Endif
		Endif
	Else
		lRet := .F.
	Endif
	
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A610WFPC | Autor | Robson Gonçalves          | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de preparação de workflow do pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610WFPC( __nOpWF, oProcess )
	Local cCodPC := ''
	Local cEnableWF := GetNewPar('MV_XWFCENB', '1')
   
	Default __nOpWF := 0
   
	If ValType(__nOpWF) == 'A'
		__nOpWF := __nOpWF[1]
	Endif
	
	If Type( 'cPedCompras' ) <> 'U'
		cCodPC := StrTran( cPedCompras, '-', '' )
	Endif
	
	// Inicia Processo de WF
	If .NOT. Empty( cCodPC )
		If cEnableWF = '1'
			Begin Sequence
				Conout('[WF]['+DtoC(dDatabase)+']['+Time()+'] I - Envio de email ')
				A610WF_Env( cCodPC )
				Conout('[WF]['+DtoC(dDatabase)+']['+Time()+'] F - Envio de email ')
			End Sequence
		Else
			Conout('[WF]['+DtoC(dDatabase)+']['+Time()+'] I - Envio de email desativado através do parâmetro MV_XWFCENB')
		EndIf
	
	// Processa Retorno de WF
	ElseIf __nOpWF == 1
		Begin Sequence
			Conout('[WF]['+DtoC(dDatabase)+']['+Time()+'] I - Processa Retorno ')
			A610WF_Ret( oProcess )
			Conout('[WF]['+DtoC(dDatabase)+']['+Time()+'] F - Processa Retorno ')
		End Sequence
		
	// Verifica Time Wait
	ElseIf __nOpWF == 2
		/*
		+----------------------------------------+
		| Funcionalidade retirada no dia 26/8/16 |
		+----------------------------------------+
		Begin Sequence
			Conout('[WF]['+DtoC(dDatabase)+']['+Time()+'] I - Processa TimeWait ')
			A610WF_Tim( oProcess )
			Conout('[WF]['+DtoC(dDatabase)+']['+Time()+'] F - Processa TimeWait ')
		End Sequence
		*/
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610WF_Env | Autor | Robson Gonçalves        | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para gerar o arquivo HTML de aprovação/rejeição do 
//        | workflow do pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610WF_Env( cCodPC )
	Local oHTML    := NIL
	Local oWFenv   := NIL
	Local cAprov   := ''
	Local aAprov   := {}
	Local aGrpAprov:= {}
	Local nDiasTW	:= GetNewPar('MV_XTIWWFD', 5)
	Local nHoraTW	:= GetNewPar('MV_XTIWWFH', 0)
	Local nMinuTW	:= GetNewPar('MV_XTIWWFM', 0)
	Local cModWF1  := GetNewPar('MV_610PC1', '\WORKFLOW\EVENTO\CSFA610PC1.HTM')
	Local cModWF2 := ''
	Local _cUser   := ''
	Local nTotal 	:= 0
	Local cMailId  := ''
	Local lItemRate := .F.
	Local lItemProd := .F.
		
	Local cUSER_COD := ''
	Local cUSER_LOG := ''
	Local cUSER_NAM := ''
	Local cRateio := ''
	Local cC7_CC := ''
	Local cC7_ITEMCTA := ''
	Local cC7_CLVL := ''
	Local cSQL := ''
	Local cTRB := ''
	Local cC7_XADICON := ''
	
	Local aSA2 := {}
	Local aSAL := {}
	Local aCTT := {}
	Local aRateio := {}
	Local aInfAdic := {}
	Local aRecNoSC1 := {}
	
	Local i := 0
	Local nI := 0
	Local nLoop := 0
	
	Local cStack := ''
	Local cProcName := ''
	Local cCpo := ''
	Local cInf := ''
	Local cAL_COD := ''
	Local cC7_XRECORR := ''
	Local cQuemJaLib := ''
	Local cCND_COMPET := ''
	
	Local lCR_LOG := .F.
	Local dHoje := MsDate()
	Local dC7_XVENCTO := Ctod('')
	Local cMV610_014 := 'MV_610_014'
	Local aC7_ANEXOS := {}
	Local cSaveFile := ''
	Local cBody := ''
	Local cAnexo := ''
	Local cAssunto := ''
	Local lServerTst := .F.
	Local cMV_IPSRV   := 'MV_610_IP'
	Local nQTDAlt := 0
	Local cInfoAlt := '<strong>Observação.:<font color="red"> Este pedido sofreu alteração, sendo necessário uma nova aprovação.</font></strong>'
	Local cMV610_015 := 'MV_610_015'
	Local lAnexo := .F.
	
	Private nP_VLR_TOTAL	:= 14
	Private aNOM_CPO := {}
	Private aDAD_CPO := {}
	
	lMSG_PRAZO_VENCTO := .F.
	
	If .NOT. GetMv( cMV610_014, .T. )
		CriarSX6( cMV610_014, 'C', 'ENDERECO PARA O LINK NO E-MAIL DE AVISO DE APROVACAO DE PC - ROTINA CSFA610.prw', 'https://gestao.certisign.com.br/aprovacao-pedido' )
	Endif
	
	cMV610_014 := GetMv( cMV610_014, .F. )
	
	If .NOT. GetMv( cMV_IPSRV, .T. )
		CriarSX6( cMV_IPSRV, 'C', 'IP dos servidores Teste/Homolog para identificar e sair a informação no assunto do e-mail. Rotina: CSFA610.prw', '10.130.0.117' )
	Endif
	cMV_IPSRV := GetMv( cMV_IPSRV, .F. )
	
	lServerTst := GetServerIP() $ cMV_IPSRV
	cAssunto   := IIF( lServerTst, "[TESTE] ", "" )
	
	If .NOT. GetMv( cMV610_015, .T. )
		CriarSX6( cMV610_015, 'N', 'HABILITAR ANEXO DA CAPA NO EMAIL. 0=DESABILITADO E 1=HABILITADO - ROTINA CSFA610.prw', '0' )
	Endif
	lAnexo := ( GetMv( cMV610_015, .F. ) == 1 )
	
	// Foi necessário criar esta verificação com Type() para 
	// compatibilização entre a diversas chamadas desta 
	// função A610WF_Env, podendo ser de sequencia de 
	// processo, JOB e menu de usuário.
	If Type('cNUM_PED_COM')=='U'
		cNUM_PED_COM := ''
	Endif
	If Type('cNUM_MEDICAO')=='U'
		cNUM_MEDICAO := ''
	Endif
	If Type('cNUM_CONTRAT')=='U'
		cNUM_CONTRAT := ''
	Endif
	If Type('cNUM_COTACAO')=='U'
		cNUM_COTACAO := ''
	Endif
	
	AAdd( aNOM_CPO, 'C.Custo da despesa' )
	AAdd( aNOM_CPO, 'Centro de resultado' )
	AAdd( aNOM_CPO, 'Recorrência' )
	AAdd( aNOM_CPO, 'Mês referência' )
	AAdd( aNOM_CPO, 'Ano referência' )
	AAdd( aNOM_CPO, 'Código do projeto' )
	AAdd( aNOM_CPO, 'Descr. do projeto' )
	AAdd( aNOM_CPO, 'Descrição capa de desp.' )
	AAdd( aNOM_CPO, 'Objetivo' )
	AAdd( aNOM_CPO, 'Justificativa' )
	AAdd( aNOM_CPO, 'Razão social' )
	AAdd( aNOM_CPO, 'Nome fantasia' )
	AAdd( aNOM_CPO, 'CNPJ' )
	AAdd( aNOM_CPO, 'Valor bruto' )
	AAdd( aNOM_CPO, 'Nº Nota fiscal' )
	AAdd( aNOM_CPO, 'Aprovado em budget' )
	AAdd( aNOM_CPO, 'Cta.Contáb.Orçada' )
	AAdd( aNOM_CPO, 'Descr. Cta. Contáb. Orçada' )
	AAdd( aNOM_CPO, 'Forma de pagto.' )
	AAdd( aNOM_CPO, 'Condição de pagto.' )
	//AAdd( aNOM_CPO, 'Vencimento' )
	AAdd( aNOM_CPO, 'Comentários adicionais' )
	AAdd( aNOM_CPO, 'Nome do resp. contratação' )
	AAdd( aNOM_CPO, 'Depto. do resp. contratação' )
	AAdd( aNOM_CPO, 'Cód. do resp. contratação' )
	AAdd( aNOM_CPO, 'Código do elaborador' )
	AAdd( aNOM_CPO, 'Login do elaborador' )
	AAdd( aNOM_CPO, 'Nome do elaborador' )
	AAdd( aNOM_CPO, 'Filial + Nº Ped. Compras' )
	AAdd( aNOM_CPO, 'Filial + Nº da medição' )
	AAdd( aNOM_CPO, 'Filial + Nº do contrato' )
	AAdd( aNOM_CPO, 'Filial + Nº da cotação' )
	AAdd( aNOM_CPO, 'Pedido de compra aprovado por' )
	
	If Len( cCodPC ) == Len( SC7->C7_NUM )
		cCodPC := xFilial( 'SC7' ) + cCodPC
	Endif
		
	dbSelectArea( 'SC7' )
	SC7->( dbSetOrder( 1 ) )
	SC7->( MsSeek( cCodPC ) )
		
	A610QJaLib( cCodPC, @cQuemJaLib )
		
	// O array aDADOS_PC é para saber quem foi o usuário elaborador.
	// Este array é montado no final a aprovação da capa de despesa e
	// no final da aprovação do pedido de compras. Em ambos momentos
	// eles são do escopo PRIVATE.
	If Type('aDADOS_PC')=='U'
		If Type('cCodElab')=='C'    .AND. ;
				Type('cNomElab')=='C'    .AND. ;
				Type('cPedCompras')=='C' .AND. ;
				Type('cContrato')=='C'   .AND. ;
				Type('cMedicao')=='C'    .AND. ;
				Type('cCotacao')=='C'
			cNUM_PED_COM := Iif( Empty( SC7->C7_NUM )    ,'Não há pedido'  ,SC7->( C7_FILIAL + '-' + C7_NUM ) )
			cNUM_MEDICAO := Iif( Empty( SC7->C7_MEDICAO ),'Não há medição' ,SC7->( C7_FILIAL + '-' + C7_MEDICAO ) )
			cNUM_CONTRAT := Iif( Empty( SC7->C7_CONTRA ) ,'Não há contrato',SC7->( C7_FILIAL + '-' + C7_CONTRA ) )
			cNUM_COTACAO := Iif( Empty( SC7->C7_NUMCOT ) ,'Não há cotação' ,SC7->( C7_FILIAL + '-' + C7_NUMCOT ) )
		Else
			cNUM_PED_COM := Iif( Empty( SC7->C7_NUM )    ,'Não há pedido'  ,SC7->( C7_FILIAL + '-' + C7_NUM ) )
			cNUM_MEDICAO := Iif( Empty( SC7->C7_MEDICAO ),'Não há medição' ,SC7->( C7_FILIAL + '-' + C7_MEDICAO ) )
			cNUM_CONTRAT := Iif( Empty( SC7->C7_CONTRA ) ,'Não há contrato',SC7->( C7_FILIAL + '-' + C7_CONTRA ) )
			cNUM_COTACAO := Iif( Empty( SC7->C7_NUMCOT ) ,'Não há cotação' ,SC7->( C7_FILIAL + '-' + C7_NUMCOT ) )
		Endif
	Else
		cNUM_PED_COM := aDADOS_PC[ 4 ]
		cNUM_MEDICAO := aDADOS_PC[ 5 ]
		cNUM_CONTRAT := aDADOS_PC[ 6 ]
		cNUM_COTACAO := aDADOS_PC[ 7 ]
	Endif
		
	If cNUM_MEDICAO <> ''
		cCND_COMPET := CND->( GetAdvFVal( 'CND', 'CND_COMPET', xFilial( 'CND' ) + cNUM_MEDICAO, 1 ) )
	Endif
		
	// Dados do elaborador do PC.
	cUSER_COD := SC7->C7_USER
	cUSER_LOG := RTrim( UsrRetName( cUSER_COD ) )
	cUSER_NAM := RTrim( UsrFullName( cUSER_COD ) )
	
	If Len( aSA2 ) == 0
		aSA2 := SA2->( GetAdvFVal( 'SA2', { 'A2_NOME', 'A2_NREDUZ', 'A2_TIPO', 'A2_CGC' }, xFilial( 'SA2' ) + SC7->( C7_FORNECE + C7_LOJA ), 1 ) )
	Endif
   	
	If .NOT. Empty( SC7->C7_XRECORR )
		cC7_XRECORR := StrTokArr( SX3->( Posicione( 'SX3', 2, 'C7_XRECORR', 'X3CBox()' ) ), ';' )[ Val( SC7->C7_XRECORR ) ]
	Endif
	
	If Len( aCTT ) == 0
		aCTT := CTT->( GetAdvFVal( 'CTT', { 'CTT_GARFIX', 'CTT_GARVAR', 'CTT_GAPONT' }, xFilial( 'CTT' ) + SC7->C7_CCAPROV, 1 ) )
		If Len( aCTT ) > 0
			If Empty( aCTT[ 1 ] )
				aCTT[ 1 ] := 'sem código de grupo de aprovação recorrente fixo.'
			Endif
		Endif
		If Len( aCTT ) > 1
			If Empty( aCTT[ 2 ] )
				aCTT[ 2 ] := 'sem código de grupo de aprovação recorrente variável.'
			Endif
		Endif
		If Len( aCTT ) > 2
			If Empty( aCTT[ 3 ] )
				aCTT[ 3 ] := 'sem código de grupo de aprovação pontual.'
			Endif
		Endif
	Endif
   
	If Len( aSAL ) == 0
		If .NOT. Empty( cC7_XRECORR )
			If SubStr( aCTT[ Val( SubStr( cC7_XRECORR, 1, 1 ) ) ], 1, 3 ) == 'sem'
				cAL_COD := 'sem referência.'
				aSAL := { 'sem nome do aprovador.','sem nome do grupo de aprovação.' }
			Else
				cAL_COD := aCTT[ Val( SubStr( cC7_XRECORR, 1, 1 ) ) ]
				aSAL := SAL->( GetAdvFVal( 'SAL', { 'AL_NOME', 'AL_DESC','AL_APROV' }, xFilial( 'SAL' ) + cAL_COD + '01', 2 ) )
				if cAL_COD $ "8000  |80000 |800000"
				   aSAL[1] := GetNewPar('MV_XRESPCT', 'Bruno Portnoi')
				elseIf aSAL[1]==NIL
					aSAL[1] := A610NAprov(aSAL[3])
				Endif
			Endif
		Endif
	Endif
	
	If .NOT. Empty( SC7->C7_CC )
		cC7_CC := RTrim( SC7->C7_CC ) + ' - ' + RTrim( CTT->( Posicione( 'CTT', 1, xFilial( 'CTT' ) + SC7->C7_CC , 'CTT_DESC01' ) ) )
	Endif
	
	If .NOT. Empty( SC7->C7_ITEMCTA )
		cC7_ITEMCTA := RTrim( SC7->C7_ITEMCTA )+ ' - ' + RTrim( CTD->( Posicione( 'CTD' ,1 , xFilial( 'CTD' ) + SC7->C7_ITEMCTA, 'CTD_DESC01' ) ) )
	Endif
	
	If .NOT. Empty( SC7->C7_CLVL )
		cC7_CLVL := RTrim( SC7->C7_CLVL ) + ' - ' + RTrim( CTH->( Posicione( 'CTH', 1, xFilial( 'CTH' ) + SC7->C7_CLVL, 'CTH_DESC01' ) ) )
	Endif
	
	AAdd( aInfAdic, AllTrim( SC7->C7_XADICON ) )
	If .NOT. ( 'Pedido de compras:' $ SC7->C7_XADICON )
		AAdd( aInfAdic, 'Pedido de compras: ' + SC7->C7_NUM )
	Endif
	
	If cCND_COMPET <> ''
		AAdd( aInfAdic, 'Mês/Ano da competência: ' + cCND_COMPET )
	Endif
	If .NOT. Empty( SC7->C7_CNPJ )
		AAdd(aInfAdic,'CNPJ/Filial de entrega: '+TransForm(SC7->C7_CNPJ,'@R 99.999.999/9999-99')+' / ('+SC7->C7_FILENT+') '+A610NomFil(SC7->C7_FILENT))
	Endif
	
	AEval( aInfAdic, {|cValue,nIndex| cC7_XADICON += cValue + Iif( nIndex == Len( aInfAdic ), '', CRLF ) } )
	
	aDAD_CPO := {  cC7_CC,;
		cC7_ITEMCTA,;
		SubStr( cC7_XRECORR, 1, 1 ) + '-' + SubStr( cC7_XRECORR, 3 ) ,;
		SubStr( SC7->C7_XREFERE, 1, 2) + ' (' + MesExtenso( SubStr( SC7->C7_XREFERE, 1, 2) ) + ')',;
		SubStr( SC7->C7_XREFERE, 3, 4),;
		cC7_CLVL,;
		RTrim( CTH->( Posicione( 'CTH', 1, xFilial( 'CTH' ) + SC7->C7_CLVL, 'CTH_DESC01' ) ) ),;
		RTrim( SC7->C7_DESCRCP ),;
		RTrim( SC7->C7_XOBJ ),;
		RTrim( SC7->C7_XJUST ),;
		SC7->C7_FORNECE + ' - ' + RTrim( aSA2[ 1 ] ),;
		RTrim( aSA2[ 2 ] ),;
		TransForm( aSA2[ 4 ], Iif( aSA2[ 3 ] == 'J', '@R 99.999.999/9999-99', '@R 999.999.999-99' ) ),;
		'',;
		SC7->C7_DOCFIS,;
		StrTran( StrTokArr( SX3->( Posicione( 'SX3', 2, 'C7_APBUDGE', 'X3CBox()' ) ), ';' )[ Val( SC7->C7_APBUDGE ) ], '=', '-' ),;
		RTrim( SC7->C7_CTAORC ) + ' - ' + RTrim( CT1->( Posicione( 'CT1', 1, xFilial( 'CT1' ) + SC7->C7_CTAORC, 'CT1_DESC01' ) ) ),;
		SC7->C7_DDORC,;
		RTrim( SC7->C7_FORMPG ),;
		SC7->C7_COND + ' (' + RTrim( SE4->( Posicione( 'SE4', 1, xFilial( 'SE4' ) + SC7->C7_COND, 'E4_DESCRI' ) ) ) + ')',; ////Dtoc( SC7->C7_XVENCTO ),;
		cC7_XADICON,;
		aSAL[ 1 ],;
		aSAL[ 2 ],;
		SC7->C7_CCAPROV + ' - ' + CTT->( Posicione('CTT',1,xFilial('CTT')+SC7->C7_CCAPROV,'CTT_DESC01') ),;
		cUSER_COD,;
		cUSER_LOG,;
		cUSER_NAM,;
		Iif(Empty(cNUM_PED_COM),'Não há pedido.'  ,cNUM_PED_COM),;
		Iif(Empty(cNUM_MEDICAO),'Não há medição.' ,cNUM_MEDICAO),;
		Iif(Empty(cNUM_CONTRAT),'Não há contrato.',cNUM_CONTRAT),;
		Iif(Empty(cNUM_COTACAO),'Não há cotação'  ,cNUM_COTACAO),;
		cQuemJaLib }
	
	A610TemRateio( 'MATA120', 'SCH', { xFilial( 'SCH' ), SC7->C7_NUM }, .F., @aRateio, @lItemRate, @lItemProd )
		
	If Len( aRateio ) == 0
		If FunName() == 'MATA120' .AND. ValType( aHeader ) == 'A' .AND. ValType( aCOLS ) == 'A'
			A610TemRateio( 'MATA120', 'SC7-MEMO', { xFilial( 'SC7' ), SC7->C7_NUM }, .F., @aRateio, @lItemRate, @lItemProd )
		Else
			A610TemRateio( 'MATA120', 'SC7', { xFilial( 'SC7' ), SC7->C7_NUM }, .F., @aRateio, @lItemRate, @lItemProd )
		Endif
	Endif
   
	If Len( aRateio ) > 0
		cRateio := 'Informações de rateio vide planilha no banco de conhecimento'
		/*cRateio := Replicate('-',70) + CRLF
		cRateio += '*** RATEIO ***' + CRLF
		cRateio += 'ITPC - IT - PERC. - VALOR - C.CUSTO - C.CONTAB - C.RESULT - PROJETO' + CRLF
		For nI := 1 To Len( aRateio )
			cRateio += aRateio[ nI, 1 ] +'-'+;
				aRateio[ nI, 2 ] +'-'+;
				aRateio[ nI, 3 ] +'%' + '-'+;
				aRateio[ nI, 4 ] +'-'+;
				aRateio[ nI, 5 ] +'-'+;
				aRateio[ nI, 6 ] +'-'+;
				aRateio[ nI, 7 ] +'-'+;
				aRateio[ nI, 8 ] + CRLF
		Next nI
		*/
		aDAD_CPO[ 1 ] := '*** Rateio ***' //Centro de custo de apropriação.
		aDAD_CPO[ 2 ] := '*** Rateio ***' //Item da conta contábil.
		aDAD_CPO[ 6 ] := '*** Rateio ***' //Classe de valor.
		
		aDAD_CPO[ 21 ] := aDAD_CPO[ 21 ] + CRLF + cRateio
	Endif
   
	//---------------------------------------------------------------------------------
	// Verificar se é preciso emitir o alerta de vencimento fora do prazo estabelecido.
	dC7_XVENCTO := SC7->C7_XVENCTO
	//If dC7_XVENCTO >= dHoje
		//If ( dC7_XVENCTO - dHoje ) < A610PrzPag()
			//lMSG_PRAZO_VENCTO := .T.
			//nI := AScan( aNOM_CPO, 'Vencimento' )
			//If nI > 0
				//aDAD_CPO[ nI ] := cFNT_PRZ_VENC + aDAD_CPO[ nI ] + '<br>' + cMSG_PRAZO_VENCTO + cNOFONT
			//Endif
		//Endif
	//Endif
	
	dbSelectArea('SC7')
	_cUser := StrTran( StrTran( Alltrim( UsrRetName( SC7->C7_USER ) ), '.', ''), '\', '' )
	
	aAprov := A610WF_Apv( cCodPC )
	
	For nLoop := 1 To Len( aAprov )
		If SC7->( C7_FILIAL + C7_NUM ) <> cCodPC
			dbSelectArea( 'SC7' )
			dbSetOrder( 1 )
			dbSeek( cCodPC )
		Endif
		  
		cAprov := aAprov[ nLoop, 2 ]
		
		If Empty( cMV610_014 )
			// Cria processo de workflow
			Sleep( Randomize( 1 ,2999 ) )
			oWFEnv := TWFProcess():New( 'PC610E', 'Pedido de Compras')
			oWFEnv:NewTask( 'PC610E', cModWF1 )
			oWFEnv:cSubject := cAssunto + 'Solicitação de Liberação do Pedido de Compra Nº ' + SubStr( cCodPC, 1, 2 ) + '-' + SubStr( cCodPC, 3 )
			oWFEnv:bReturn := 'U_A610WFPC(1)'
			//---------------------------------------------------------------------
			// Funcionalidade retirada no dia 26/8/16
			//---------------------------------------
			//oWFEnv:bTimeOut := {{'U_A610WFPC(2)', nDiasTW ,nHoraTW ,nMinuTW }}
			//---------------------------------------------------------------------
			
			oWFEnv:cTo := _cUser
			
			// Carrega modelo HTML
			oHTML := oWFEnv:oHTML
		Else
			cModWF2 := GetNewPar('MV_XMODWF2', '\WORKFLOW\EVENTO\CSFA610PC2NEW.HTM')
			oHTML := TWFHTML():New( cModWF2 )
		Endif
		
		// Preenche os dados do cabecalho.
		oHTML:ValByName( 'cAprovador', aAprov[ nLoop, 1 ] )
		oHTML:ValByName( 'cCod_Aprov', aAprov[ nLoop, 3 ] )
		oHTML:ValByName( 'cNUM_PEDIDO', SubStr( cCodPC, 1, 2 ) + '-' + SubStr( cCodPC, 3 ) )
		
		nTotal := 0
		
		While SC7->( .NOT. EOF() ) .AND. SC7->( C7_FILIAL + C7_NUM ) == cCodPC
			SB1->( dbSetOrder( 1 ) )
			SB1->( dbSeek( xFilial('SB1') + SC7->C7_PRODUTO ) )

			nTotal += ( SC7->( C7_TOTAL + C7_DESPESA + C7_VALFRE + C7_VALIPI + C7_SEGURO ) - SC7->C7_VLDESC )
			 
			AAdd( ( oHTML:ValByName( 'IT.PRODUTO' )) ,RTrim( SC7->C7_PRODUTO ) + '-' + RTrim( SB1->B1_DESC ) )
			AAdd( ( oHTML:ValByName( 'IT.QUANT' ))   ,TransForm( SC7->C7_QUANT, '@E 999,999,999.99' ) )
			AAdd( ( oHTML:ValByName( 'IT.UNIT' ))    ,TransForm( SC7->C7_PRECO, '@E 999,999,999.99' ) )
			AAdd( ( oHTML:ValByName( 'IT.TOT_ITEM' )),TransForm( SC7->C7_TOTAL, '@E 999,999,999.99' ) )
			
			SC7->(dbSkip())
		End
		
		aDAD_CPO[ nP_VLR_TOTAL ] := LTrim( TransForm( nTotal, '@E 999,999,999.99' ) ) + ' (' + Lower( Extenso( nTotal, ,1 ) ) + ')'
		
		// Substituir o cher(13)+chr(10) por <br>
		aDAD_CPO[ 21 ] := StrTran( aDAD_CPO[ 21 ], CRLF, '<br>' )
		
		// Grava as informações do Rodapé	
		oHTML:ValByName( 'TOTAL_PC' ,TransForm( nTotal,'@E 999,999,999.99' ) )
		
		For nI := 1 To Len( aNOM_CPO )
			cCpo := 'cTitulo' + LTrim( Str( nI ) )
			cInf := 'cCampo' + LTrim( Str( nI ) )
			
			oHTML:ValByName( cCpo, aNOM_CPO[ nI ] )
			oHTML:ValByName( cInf, aDAD_CPO[ nI ] )
		Next nI
		
		If lMSG_PRAZO_VENCTO
			oHTML:ValByName( 'cCP_MSG_PRAZO_VENCTO', cMSG_PRAZO_VENCTO )
		Else
			oHTML:ValByName( 'cCP_MSG_PRAZO_VENCTO', '' )
		Endif
		
		/*****
		 *
		 * O parâmetro MV_610_014 possui o link de acesso a aplicação web.
		 * Sem conteúdo será gerado workflow, do contrário o usuário será direcionado para a aplicação.
		 *
		 */
		If Empty( cMV610_014 )
			oWFEnv:ClientName( aAprov[ nLoop, 3 ] )
			
			// Envia o email
			cMailId := oWFEnv:Start()
			
			A610WF_Lin( _cUser, cAprov, @oWFEnv, cCodPC, cMailId, aAprov, aNOM_CPO, aDAD_CPO, nLoop, lAnexo )
			
			oWFEnv:Free()
		Else
			If oHTML:ExistField( 1, 'proc_link' )
				oHTML:ValByName( 'proc_link', cMV610_014 )
			Endif
			
			A610GetAnexo( @aC7_ANEXOS, cCodPC, @nQTDAlt )
			
			For nI := 1 To Len( aC7_ANEXOS )
				cAnexo += aC7_ANEXOS[ nI ] + ', '
			Next nI
			
			If cAnexo <> ''
				//Não deve enviar no e-mail a Capa. 21.05.2018 - Ngiardino
				IF lAnexo
					cAnexo := SubStr( cAnexo, 1, Len( cAnexo )-2 )
				Else
					cAnexo := ''
				EndIF
			Endif
			
			If oHTML:ExistField( 1, 'cLINK' )
				oHTML:ValByName( 'cLINK', cMV610_014 )
			Endif
			
			//Quando o pedido tiver mais de 01 alteração, deve informar o aprovador.
			If oHTML:ExistField( 1, 'cInfoAlt' )
				IF nQTDAlt > 1
					oHTML:ValByName( 'cInfoAlt', cInfoAlt )
				Else
					oHTML:ValByName( 'cInfoAlt', '' )
				EndIF
			Endif
			
			cSaveFile := CriaTrab( NIL , .F. )
			oHTML:SaveFile( cSaveFile + '.htm' )
			
			Sleep( Randomize( 1, 1500 ) )
			
			cBody := A610LoadFile( cSaveFile + '.htm' )
			//cBody := StrTran( cBody, 'systemaccesslink', cMV610_014 )
						
			FSSendMail( cAprov, cAssunto + 'Solicitação de Liberação do Pedido de Compra Nº '+ SubStr( cCodPC, 1, 2 ) + '-' + SubStr( cCodPC, 3 ), cBody, cAnexo )
			
			oHTML:Free()
			oHTML := NIL
			
			cMailId := '#' + Dtos( MsDate() ) + StrTran( Time(), ':', '' ) + '@'
		Endif
		
		cInf := ''

		If Type( 'cCSFA610D' ) <> 'U'
			cInf := ' LOG GERADO PELO JOB CSFA610D.'
		Endif
		
		cSQL := "SELECT R_E_C_N_O_ AS SCR_RECNO "
		cSQL += "FROM   "+RETSQLNAME("SCR")+" SCR "
		cSQL += "WHERE  CR_FILIAL = '"+SubStr( cCodPC, 1, 2 )+"' "
		cSQL += "       AND CR_NUM = '"+PadR( SubStr( cCodPC, 3 ), Len( SCR->CR_NUM ), ' ' )+"' "
		cSQL += "       AND CR_USER ='"+aAprov[ nLoop, 3 ]+"' "
		cSQL += "       AND CR_APROV ='"+aAprov[ nLoop, 5 ]+"' "
		cSQL += "       AND CR_STATUS = '02' "
		cSQL += "       AND CR_TIPO = 'PC' "
		cSQL += "       AND D_E_L_E_T_ = ' ' "
		
		cSQL := ChangeQuery( cSQL )
		cTRB := GetNextAlias()
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
		
		If (cTRB)->( SCR_RECNO ) > 0
			// Qual rotinal iniciou o processo de workflow?
			i := 0
			While ( i < 19 )
				cProcName := ProcName( i )
				If .NOT. Empty( cProcName )
					If .NOT. ( ( 'EVAL' $ Upper( cProcName ) ) .OR. ( '{' $ cProcName ) )
						cStack += RTrim( cProcName ) + ', '
					Endif
				Endif
				i++
			End
			cStack := SubStr( cStack, 1, Len( cStack )-2 ) + '.'
			cStack := ' Executado por ' + Iif( IsBlind(), 'Automático', SubStr( UsrFullName( RetCodUsr() ), 1, 10 ) ) + ' a partir das rotinas ' + cStack
			
			SCR->( dbGoTo( (cTRB)->SCR_RECNO ) )
			SCR->( RecLock( 'SCR', .F. ) )
			SCR->CR_MAIL_ID := cMailId
			SCR->CR_LOG     :=  Iif(.NOT.Empty( SCR->CR_LOG ),(AllTrim(SCR->CR_LOG)+CRLF),'')+'DT '+Dtoc(MsDate())+' HR '+Time()+' GERADO MAILID.' + cMailId + ' ' + cInf + ' ' + cStack
			SCR->( MsUnLock() )
		Endif
		(cTRB)->( dbCloseArea() )
	Next nLoop
Return

//--------------------------------------------------------------------------
// Rotina | A610WF_Lin | Autor | Robson Gonçalves        | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para gerar o arquivo HTML de aviso do workflow do pedido 
//        | de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610WF_Lin( _cUser, cAprov, oWFLin, cNumPC, cMailId, aAprov, aNOM_CPO, aDAD_CPO, nLoop, lAnexo )
	Local cLink := GetNewPar('MV_XLINKWF', 'http://192.168.16.10:1804/wf/')
	Local cModWF2 := GetNewPar('MV_XMODWF2', '\WORKFLOW\EVENTO\CSFA610PC2.HTM')
	Local oHTML
	Local nTotal := 0
	Local nI := 0
	Local cCpo := ''
	Local cInf := ''
	Local aC7_ANEXOS := {}
	Local nQTDAlt := 0
	Local cInfoAlt := 'Obs.: Este pedido sofreu alteração. Qualquer dúvida, procure o elaborador para maiores informações'
	
	cLink += 'emp'+ cEmpAnt +'/'
	
	oWFLin:NewTask( 'PC610L', cModWF2 )
	oWFLin:cSubject := 'Solicitação de Liberação do Pedido de Compra Nº '+ SubStr( cNumPC, 1, 2 ) + '-' + SubStr( cNumPC, 3 )
	oWFLin:cTo := cAprov
	
	// Cria objeto Html de acordo modelo
	oHTML := oWFLin:oHTML
	
	// Preenche os dados do cabecalho.
	oHTML:ValByName( 'cAprovador', aAprov[ nLoop, 1 ] )
	oHTML:ValByName( 'cNUM_PEDIDO', SubStr( cNumPC, 3 ) )
	oHTML:ValByName( 'proc_link', cLink + _cUser + '/' + cMailId + '.htm' )
	
	nTotal := 0
			
	SC7->( dbSetOrder( 1 ) )
	SC7->( MsSeek( cNumPC ) )
	While SC7->( .NOT. EOF() ) .AND. SC7->( C7_FILIAL + C7_NUM ) == cNumPC
		SB1->( dbSetOrder( 1 ) )
		SB1->( dbSeek( xFilial('SB1') + SC7->C7_PRODUTO ) )
		
		nTotal += SC7->C7_TOTAL
		
		AAdd( ( oHTML:ValByName( 'IT.PRODUTO' )) ,RTrim( SC7->C7_PRODUTO ) + '-' + RTrim( SB1->B1_DESC ) )
		AAdd( ( oHTML:ValByName( 'IT.QUANT' ))   ,TransForm( SC7->C7_QUANT, '@E 999,999,999.99' ) )
		AAdd( ( oHTML:ValByName( 'IT.UNIT' ))    ,TransForm( SC7->C7_PRECO, '@E 999,999,999.99' ) )
		AAdd( ( oHTML:ValByName( 'IT.TOT_ITEM' )),TransForm( SC7->C7_TOTAL, '@E 999,999,999.99' ) )
		
		SC7->(dbSkip())
	End
		
	// Grava as informações do rodapé
	oHTML:ValByName( 'TOTAL_PC' ,TransForm( nTotal,'@E 999,999,999.99' ) )
	
	For nI := 1 To Len( aNOM_CPO )
		cCpo := 'cTitulo' + LTrim( Str( nI ) )
		cInf := 'cCampo' + LTrim( Str( nI ) )
		
		oHTML:ValByName( cCpo, aNOM_CPO[ nI ] )
		oHTML:ValByName( cInf, aDAD_CPO[ nI ] )
	Next nI
	
	If lMSG_PRAZO_VENCTO
		oHTML:ValByName( 'cCP_MSG_PRAZO_VENCTO', cMSG_PRAZO_VENCTO )
	Else
		oHTML:ValByName( 'cCP_MSG_PRAZO_VENCTO', '' )
	Endif

	A610GetAnexo( @aC7_ANEXOS, cNumPC, @nQTDAlt )
	
	//Quando o pedido tiver mais de 01 alteração, deve informar o aprovador.
	If oHTML:ExistField( 1, 'cInfoAlt' )
		IF nQTDAlt > 1
			oHTML:ValByName( 'cInfoAlt', cInfoAlt )
		Else
			oHTML:ValByName( 'cInfoAlt', '' )
		EndIF
	Endif
	
	//Não deve enviar no e-mail a Capa. 21.05.2018 - Ngiardino
	IF lAnexo
		For nI := 1 To Len( aC7_ANEXOS )
			If .NOT. Empty( aC7_ANEXOS )
				oWFLin:AttachFile( aC7_ANEXOS[ nI ] )
			Endif
		Next nI
	EndIF
	
	oWFLin:Start()
	oWFLin:Free()
Return

//--------------------------------------------------------------------------
// Rotina | A610WF_Ret | Autor | Robson Gonçalves        | Data | 05.07.2016
//--------------------------------------------------------------------------
// Descr. | Rotina de retorno de workflow do pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
/*
+---------------------------------------------------------------------------+
|************ REGRA DO GRUPO DE APROVADOR QUANDO NO MESMO NÍVEL ************|
+---------------------------------------------------------------------------+
|TIPO DE   |TIPO DE        |NÍVEL |RESULTADO                                |
|APROVAÇÃO |LIBERAÇÃO      |      |                                         |
+---------------------------------------------------------------------------+
|APROVADOR |PEDIDO         |IGUAL |UM OU OUTRO QUE APROVAR LIBERA O PC      |
+---------------------------------------------------------------------------+
|APROVADOR |NÍVEl          |IGUAL |UM OU OUTRO QUE APROVAR LIBERA O PC      |
+---------------------------------------------------------------------------+
|APROVADOR |USUÁRIO        |IGUAL |NECESSIDADE DE APROVAÇÃO CONJUNTA        |
+---------------------------------------------------------------------------+
|APROVADOR |NÍVEL E USUÁRIO|IGUAL |SE O NÍVEL APROVAR 1º SERÁ NECESSÁRIO O  |
|          |               |      |USUÁRIO, NO ENTANTO SE O USUÁRIO APROVAR |
|          |               |      | PRIMEIRO NÃO PRECISA DO NÍVEL.          |
+---------------------------------------------------------------------------+
*/
Static Function A610WF_Ret( oWFRet )
	Local aAprov := {}
	Local aBkpUsrSys := { NIL, NIL }
	Local aMsg := {}
	Local aPsw := {}
	Local aRetSaldo := {}
	Local aSAL  := {}
	
	Local cAL_LIBAPR := ''
	Local cAL_TPLIBER := ''
	Local cAprov := ''
	Local cAssunto := ''
	Local cCodElab := ''
	Local cCodLiber := ''
	Local cFilPC := ''
	Local cGrupo := ''
	Local cMailElab := ''
	Local cMotivo := ''
	Local cNomElab := ''
	Local cNumPC := ''
	Local cArqHTML := 'CSFA610pc'
	Local cStatApv := ''
	Local cTRB := ''
	Local cWFMailID := ''
	
	Local lIsRemPar := .F.
	Local lFoundSCR := .F.
	Local lLiberado := .F.
	Local lPlanFin := .F.
	Local lSC7Lock := .F.
	
	Local nRecSC7 := 0
	Local nRecSCR := 0
	Local nTotal := 0
	
	Private aDADOS_PC := {}
	
	Conout('******************************************************************************')
	Conout('* [A610WF_RET] Início do processo do retorno de workflow do pedido de compras.')
	
	// Capturar os dados iniciais.
	cFilPC    := SubStr( oWFRet:oHTML:RetByName('cCampo29'), 1, 2 )
	cNumPC    := AllTrim( oWFRet:oHTML:RetByName( 'cNUM_PEDIDO' ) )
	cAprov    := PadR( oWFRet:oHTML:RetByName('cCod_Aprov'),6)
	cStatApv  := oWFRet:oHTML:RetByName('cAprovacao')
	cMotivo   := oWFRet:oHTML:RetByName('cMotivo')
	cWFMailID := SubStr( RTrim( oWFRet:oHTML:RetByName('WFMailID') ), 3 )
	
	Conout('* Filial: '+cFilPC)
	Conout('* Nº Pedido: '+cNumPC)
	Conout('* Código do usuário aprovador: '+cAprov)
	Conout('* Status de aprovação: '+cStatApv)
	Conout('* Motivo: '+cMotivo)
	Conout('* E-Mail ID: '+cWFMailID)
	
	// Posicionar no PC.
	dbSelectArea('SC7')
	SC7->( dbSetOrder( 1 ) )
	SC7->( dbSeek( cFilPC + cNumPC ) )
	
	If .NOT. SC7->( Found() )
		Conout('* Pedido de compra não localizado: ' + cFilPC + '-' + cNumPC + '.')
		Conout('* Usuário aprovador será informado diretamente no navegador.')
		Conout('* Rotina [A610WF_RET] será finalizada.')
		U_A603Save( cWFMailID, 'CSFA610NoPC' )
		oWFRet:Finish()
		oWFRet:Free()
		Return
	Endif
	
	nRecSC7 := SC7->( RecNo() )
	cGrupo  := SC7->C7_APROV
	
	lSC7Lock := SC7->( MsRLock( nRecSC7 ) )
	If lSC7Lock
		SC7->( MsRUnLock( nRecSC7 ) )
	Endif
	
	// Posicionar na alçada e localizar o registro disponível.
	SCR->( dbsetorder( 2 ) ) // FILIAL + TIPO + NUM_PC + USER
	If SCR->( dbSeek( cFilPC + 'PC' + PadR( cNumPC ,Len( SCR->CR_NUM ), ' ' ) + cAprov ) )
		While SCR->( .NOT. EOF() ) .AND. ;
				SCR->CR_FILIAL == cFilPC .AND. ;
				SCR->CR_TIPO == 'PC' .AND. ;
				SCR->CR_NUM == PadR( cNumPC, Len( SCR->CR_NUM ), ' ' ) .AND. ;
				SCR->CR_USER == cAprov
			If SCR->CR_STATUS == '02'
				lFoundSCR := .T.
				Exit
			Endif
			SCR->( dbSkip() )
		End
	Else
		Conout('* Não localizei o registro com a chave: ' + cFilPC + 'PC' + PadR( cNumPC , Len( SCR->CR_NUM ), ' ' ) + cAprov)
	Endif
	
	If .NOT. lFoundSCR
		Conout('* Aprovação não localizada: ' + cFilPC + '-' + cNumPC + '.')
		Conout('* Rotina [A610WF_RET] será finalizada.')
		U_A603Save( cWFMailID, 'CSFA610NoPC' )
		oWFRet:Finish()
		oWFRet:Free()
		Return
	Endif

	nRecSCR   := SCR->( RecNo() )
	cCodLiber := SCR->CR_APROV
	aRetSaldo := MaSalAlc( cCodLiber, MsDate() )
	nTotal    := xMoeda( SCR->CR_TOTAL, SCR->CR_MOEDA, aRetSaldo[ 2 ], SCR->CR_EMISSAO,, SCR->CR_TXMOEDA )
	
	Conout('* Achou SC7: '+ Iif(SC7->(Found()),'True','False'))
	Conout('* RECNO SC7: '+ LTrim(Str(SC7->(RecNo()))))
	
	Conout('* Achou SCR: '+ Iif(SCR->(Found()),'True','False'))
	Conout('* RECNO SCR: '+ LTrim(Str(SCR->(RecNo()))))

	// Salvar o conteúdo das variáveis do Protheus.
	If Type( '__cUserID' ) == 'C'
		aBkpUsrSys[ 1 ] := __cUserID
	Endif
	If Type( 'cUserName' ) == 'C'
		aBkpUsrSys[ 2 ] := cUserName
	Endif
	
	// Posicionar no usuário do aprovador e capturar seus dados.
	PswOrder( 1 )
	PswSeek( SCR->CR_USER )
	aPsw := PswRet()
	
	// Atribuir as variáveis do Protheus.
	__cUserID := SCR->CR_USER
	cUserName := aPsw[ 1, 2 ]
	
	Conout('* User ID: '+__cUserID)
	Conout('* User Name: '+cUserName)
	Conout('* Será iniciado a execução da rotina A097ProcLib')
	
	// Vai conseguir travar o registro...
	// Executar a rotina padrão de aprovação de pedido de compras.
	If lSC7Lock
		A097ProcLib( nRecSCR, Iif( cStatApv == 'S', 2, 3 ), nTotal, cCodLiber, cGrupo, cMotivo, MsDate() )
	Endif
	
	// Reposicionar os registros do pedido de compras.
	SC7->( MsGoTo( nRecSC7 ) )

	// Reposicionar os registros da alçada.
	SCR->( MsGoTo( nRecSCR ) )
	
	// Restaurar as variáveis do Protheus.
	__cUserID := aBkpUsrSys[ 1 ]
	cUserName := aBkpUsrSys[ 2 ]
		
	Conout('* CR_STATUS: '+SCR->CR_STATUS)
	
	// Se foi aprovado ou rejeitado, gravar o motivo.
	If lSC7Lock
		If SCR->CR_STATUS $ '03|04|05'
			SCR->( RecLock( 'SCR', .F. ) )
			SCR->CR_LOG := Iif( .NOT. Empty( SCR->CR_LOG ), AllTrim( SCR->CR_LOG ) + CRLF, '' ) + cMotivo
			SCR->( MsUnLock() )
		Endif
	Else
		SCR->( RecLock( 'SCR', .F. ) )
		SCR->CR_LOG := Iif( .NOT. Empty( SCR->CR_LOG ), AllTrim( SCR->CR_LOG ) + CRLF, '' ) + 'Tentativa de '+Iif(cStatApv=='S','aprovar','rejeitar')+', porém o PC está em uso '+Dtoc(MsDate())+' '+Time()+'.'
		SCR->( MsUnLock() )
	Endif
	
	//-------------------------------------
	// Posicionar no cadastro do aprovador.
	SAK->( dbSetOrder( 1 ) )
	SAK->( dbSeek( xFilial( 'SAK' ) + SCR->CR_APROV ) )
	
	//-----------------------------------------------------------
	// Posicionar no registro do aprovador no grupo de aprovação.
	SAL->( dbSetOrder( 3 ) )
	SAL->( dbSeek( xFilial( 'SAL' ) + SC7->C7_APROV + SCR->CR_APROV ) )
	
	//-------------------------------------------------------------------------
	// Verificar se o próximo nível é igual ao atual, se há aprovação conjunta.
	//A610PrxNiv( SCR->CR_FILIAL, SCR->CR_NUM, SCR->CR_TIPO, SCR->CR_NIVEL )
	
	// Tem mais alçada para avaliar/aprovar.
	cTRB := GetNextAlias()
	BEGINSQL ALIAS cTRB
		SELECT COUNT(*) AS SCR_COUNT
		FROM   %Table:SCR% SCR
		WHERE  CR_FILIAL = %Exp:cFilPC%
		AND CR_NUM = %Exp:cNumPC%
		AND CR_TIPO = 'PC'
		AND CR_STATUS = '02'
		AND CR_DATALIB = ' '
		AND CR_MAIL_ID = ' '
		AND SCR.%NotDel%
	ENDSQL
	lLiberado := ((cTRB)->SCR_COUNT == 0)
	Conout( '* ' + RTrim( GetLastQuery()[2] ) )
	(cTRB)->( dbCloseArea())
	
	Conout('* PC está lLiberado: ' + Iif(lLiberado,'True','False'))
	
	// Capturar o tipo de liberação e se libera ou aprova do aprovador.
	aSAL := SAL->( GetAdvFVal( 'SAL', { 'AL_TPLIBER', 'AL_LIBAPR' }, xFilial( 'SAL' ) + SC7->C7_APROV + SCR->CR_APROV, 3 ) )
	cAL_TPLIBER := aSAL[ 1 ] // U=Usuário, N=Nível ou P=Pedido.
	cAL_LIBAPR  := aSAL[ 2 ] // V=Visto ou A=Aprovador.
	
	Conout('* cAL_TPLIBER: '+cAL_TPLIBER)
	Conout('* cAL_LIBAPR: '+cAL_LIBAPR)
	
	// Elaborar a mensagem de retorno para os envolvidos.
	AAdd(aMsg,SC7->C7_FILIAL+'-'+SC7->C7_NUM+Iif(.NOT.Empty(SC7->C7_NUMCOT),' | Cotação: '+SC7->C7_NUMCOT,Iif(.NOT.Empty(SC7->C7_MEDICAO),' | Medição: '+SC7->C7_MEDICAO,'')))
	
	// Reposicionar os registros do pedido de compras.
	SC7->( MsGoTo( nRecSC7 ) )

	// Reposicionar os registros da alçada.
	SCR->( MsGoTo( nRecSCR ) )
	
	Conout('CR_STATUS ' + SCR->CR_STATUS )
	Conout('lSC7Lock  ' + Iif( lSC7Lock, '.T.', '.F.' ) )
	Conout('lLiberado ' + Iif( lLiberado, '.T.', '.F.' ) )
	Conout('AL_LIBAPR ' + cAL_LIBAPR )
	
	If ( SCR->CR_STATUS == '02') .AND. ( .NOT. lSC7Lock )
		cArqHTML := 'CSFA610Err'
		cAssunto :=  'Pedido de Compra nº ' + SC7->C7_FILIAL + '-' + SC7->C7_NUM + ' ESTÁ BLOQUEADO/EM USO.'
		AAdd( aMsg, 'Não foi possível avaliar o pedido de compra, pois o mesmo está bloqueado por outro usuário, solicite aos usuários para deixarem este pedido de compra fora de uso.' )
		AAdd( aMsg, 'bloqueado/em uso.' )
		AAdd( aMsg, 'Será reenviado e-mail de aviso de workflow automaticamente.' )
		SCR->( RecLock( 'SCR', .F. ) )
		SCR->CR_LOG := SCR->CR_LOG := Iif(.NOT.Empty(SCR->CR_LOG),AllTrim(SCR->CR_LOG)+CRLF,'')+'DT '+ Dtoc(MsDate())+' HR '+ Time()+' '+aMsg[2]+' '+aMsg[4]
		SCR->( MsUnLock() )
	Elseif SCR->CR_STATUS == '03'
		If lLiberado
			lPlanFin := .T.
			cAssunto :=  'Pedido de Compra nº ' + SC7->C7_FILIAL + '-' + SC7->C7_NUM + ' APROVADO.'
			AAdd( aMsg, 'O pedido de compra está liberado.' )
			AAdd( aMsg, 'liberou' )
			AAdd( aMsg, 'O pedido de compra está liberado.' )
		Else
			If cAL_LIBAPR == 'V'
				cAssunto :=  'Pedido de Compra nº ' + SC7->C7_FILIAL + '-' + SC7->C7_NUM + ' VISTADO.'
				AAdd( aMsg, 'vistou' )
			Else
				cAssunto :=  'Pedido de Compra nº ' + SC7->C7_FILIAL + '-' + SC7->C7_NUM + ' APROVADO.'
				AAdd( aMsg, 'aprovou' )
			Endif
			AAdd( aMsg, 'O pedido de compra possui pendência de aprovação.')
		Endif
	Elseif SCR->CR_STATUS == '04'
		cAssunto := 'Pedido de Compra nº ' + SC7->C7_FILIAL + '-' + SC7->C7_NUM + ' REPROVADO.'
		AAdd( aMsg, 'reprovou' )
	Endif

	If Len( aMsg ) < 3
		AAdd( aMsg, '' )
	Endif

	If aMsg[ 2 ] $ 'aprovou|vistou|reprovou'
		aMsg[ 2 ] := RTrim( UsrFullName( SCR->CR_USER ) ) + ' ' + aMsg[ 2 ] + ' o PC. ' + aMsg[ 3 ]
	Else
		If aMsg[ 2 ] == 'bloqueou'
			aMsg[ 2 ] := RTrim( UsrFullName( SCR->CR_USER ) ) + aMsg[ 2 ] + ' o PC. ' + aMsg[ 3 ]
		Elseif aMsg[ 2 ] == 'sem saldo'
			aMsg[ 2 ] := RTrim( UsrFullName( SCR->CR_USER ) ) + ' está ' + aMsg[ 2 ] + ' para aprovar o PC. ' + aMsg[ 3 ]
		Endif
	Endif

	// Desfazer o elemento do vetor com o complemento.
	ADel( aMsg, 3 )
	ASize( aMsg, Len( aMsg )-1 )

	AAdd( aMsg, Dtoc( MsDate() ) )
	AAdd( aMsg, Time() )
	AAdd( aMsg, RTrim( cMotivo ) )
	
	AEval( aMsg, {|e| Conout('* '+e) })
	
	// Capturar o restante dos dados do retorno do WF.
	cCodElab  := oWFRet:oHTML:RetByName('cCampo26')
	cNomElab  := RTrim( UsrFullName( cCodElab ) )
	cMailElab := RTrim( UsrRetMail( cCodElab ) )

	aDADOS_PC :={oWFRet:oHTML:RetByName('cCampo26'),; //Código do usuário elaborador.
	oWFRet:oHTML:RetByName('cCampo27'),; //Login do usuário elaborador.
	oWFRet:oHTML:RetByName('cCampo28'),; //Nome do usuário elaborador.
	oWFRet:oHTML:RetByName('cCampo29'),; //Número do pedido de compras.
	oWFRet:oHTML:RetByName('cCampo30'),; //Número da medição.
	oWFRet:oHTML:RetByName('cCampo31'),; //Número do contrato.
	oWFRet:oHTML:RetByName('cCampo32')}  //Número da cotação.
	
	// Verificar se é remuneração de parceiros.
	lIsRemPar := RTrim( SC7->C7_CC ) $ A610RPar()
	
	Conout('* lIsRemPar: '+ Iif(lIsRemPar,'True','False'))
		
	// Salvar o ID do WF.
	U_A603Save( cWFMailID, cArqHTML )
	
	Conout('* cArqHTML: '+ cArqHTML )

	// Enviar mensagem para usuário elaborador e planejamento financeiro
	A610WFAvUs( aMsg, {cNomElab, cMailElab}, cAssunto, lPlanFin, lIsRemPar, 'A610WF_Ret' )
	
	// Finalizar a seção atual do workflow.
	oWFRet:Finish()
	oWFRet:Free()
	
	// Se o pedido de compras não foi liberado, enviar WF para as demais alçadas ou reenviar o WF não conseguiu aprovar.
	If .NOT. lLiberado
		aAprov := A610WF_Apv( SC7->( C7_FILIAL + C7_NUM ) )
		If Len( aAprov ) > 0
			A610WF_Env( SC7->( C7_FILIAL + C7_NUM ) )
		Endif
	Endif

	Conout('* [A610WF_RET] Final do processo do retorno de workflow do pedido de compras.')
	Conout('******************************************************************************')
Return

//--------------------------------------------------------------------------
// Rotina | A610WFAvUs | Autor | Robson Gonçalves        | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de aviso ao usuário elaborador.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610WFAvUs( aMsg, aDados, cAssunto, lPlanFin, lIsRemPar, cChamada )
	Local cHTML := ''
	Local cMotivo := 'Não há motivo descrito.'
	Local cNumPedCom := ''
	Local cAcao := ''
	Local cData := ''
	Local cHora := ''
	Local cEMail := ''
	Local cSubject := ''
	Local cMV_IPSRV := 'MV_610_IP'
	Local lServerTst := .F.
	Local cModWF := ''
	Local cSaveFile := ''
	Local oHTML
	
	lServerTst := GetServerIP() $ GetMv( cMV_IPSRV, .F. )
	cSubject   := IIF( lServerTst, "[TESTE] ", "" )
	
	cEMail     := aDados[ 2 ]
	cNumPedCom := aMsg[ 1 ]
	cAcao      := aMsg[ 2 ]
	cData      := aMsg[ 3 ]
	cHora      := aMsg[ 4 ]
	cMotivo    := Iif( Len( aMsg )>4, Iif( Empty( aMsg[ 5 ] ), cMotivo, aMsg[ 5 ] ),cMotivo )
	
	Conout('* Executando a função A610WFAvUs - Rotina de aviso ao usuário elaborador.')
	Conout('* cEmail ' + cEmail )
	Conout('* cNumPedCom ' + cNumPedCom )
	Conout('* cAcao ' + cAcao )
	Conout('* cData ' + cData )
	Conout('* cHora ' + cHora )
	Conout('* cMotivo ' + Iif(Empty(cMotivo),'MOTIVO NÃO DECLARADO PELO APROVADOR.',cMotivo) )
	
	cModWF := '\WORKFLOW\EVENTO\csfa610Notif.HTM'
	oHTML := TWFHTML():New( cModWF )
	
	// Preenche os dados do cabecalho.
	oHTML:ValByName( 'cElaborador'	, aDados[ 1 ]	)
	oHTML:ValByName( 'cNUMPEDCOM'	, cNumPedCom	)
	oHTML:ValByName( 'cAcao'		, cAcao			)
	oHTML:ValByName( 'cData'		, cData			)
	oHTML:ValByName( 'cHora'		, cHora			)
	oHTML:ValByName( 'cMotivo'		, cMotivo		)
	oHTML:ValByName( 'cPilha'		, cChamada		)
	
	cSaveFile := CriaTrab( NIL , .F. )
	oHTML:SaveFile( cSaveFile + '.htm' )
	
	Sleep( Randomize( 1, 1500 ) )
	
	cHTML := A610LoadFile( cSaveFile + '.htm' )
	
	Conout('* A610WFAvUs - Aviso ao usuário elaborador - EMail:'+cEMail+' PC '+cNumPedCom+' cAção '+cAcao+' Motivo '+cMotivo)
	
	FSSendMail( cEMail, cSubject + cAssunto, cHTML, /*cAnexo*/ )
	
	Ferase( cSaveFile + '.htm' )
	
	oHTML:Free()
	oHTML := NIL
	//-------------------------------------------------------------------
	// Se PC liberado, avisar também a equipe do planejamento financeiro.
	If lPlanFin
		//------------------------------------------------------------------------------
		// Avisar o planejamento financeiro somente se não for remuneração de parceiros.
		If .NOT. lIsRemPar
			//----------------------------------------------------------
			// Capturar os e-mails da equipe do planejamento financeiro.
			cEMail := A610UsrPF( GetMv( 'MV_610PFIN', .F. ) )
			Conout('A610WFAvUs - Aviso ao usuário elaborador/Plan.Financ. - EMail:'+cEMail+' PC'+cNumPedCom+' cAção'+cAcao+' Motivo'+cMotivo)

			//-----------------------
			// Se conseguiu capturar.
			If .NOT. Empty( cEMail )
				//---------------
				// Enviar e-mail.
				If l610OnMsg
					FSSendMail( cEMail, cSubject + cAssunto, cHTML, /*cAnexo*/ )
				Endif
			Endif
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610AcaoApr | Autor | Robson Gonçalves       | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de aviso ao usuário aprovador o que ele fez.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610AcaoApr( aMsg, cAprov )
	Local cHTML := ''
	Local cAcao := ''
	Local cEMail := ''
	Local cAssunto := ''
	Local cPedCompras := ''
	
	cPrezado    := RTrim( UsrFullName( cAprov ) )
	cPedCompras := aMsg[ 1 ]
	cAcao       := aMsg[ 2 ]
	cEMail      := RTrim( UsrRetMail( cAprov ) )
	cAssunto    := 'Resultado da análise do PC nº ' + cPedCompras
	
	cHTML := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
	cHTML += '<html>'
	cHTML += '	<head>'
	cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
	cHTML += '		<title>An&aacute;lise do Pedido de Compras - Resultado</title>'
	cHTML += '	</head>'
	cHTML += '	<body>'
	cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
	cHTML += '			<tbody>'
	cHTML += '				<tr>'
	cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle">'
	cHTML += '						<em><span style="font-size:20px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>An&aacute;lise do Pedido de Compras - Resultado</strong></font></span><br />'
	cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em>'
	cHTML += '						<p>'
	cHTML += '							&nbsp;</p>'
	cHTML += '					</td>'
	cHTML += '					<td align="right" width="210">'
	cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
	cHTML += '						&nbsp;</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#F4811D" colspan="2" height="4" width="0">'
	cHTML += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding:5px;" width="0">'
	cHTML += '						<p>'
	cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Prezado '+cPrezado+',</font></span></span></p>'
	cHTML += '						<p>'
	cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Informamos que o pedido de compras n&ordm;&nbsp;<strong>'+cPedCompras+'</strong> foi <strong>'+cAcao+'</strong> por voc&ecirc;.</font></span></span></p>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#02519B" colspan="2" height="2" width="0">'
	cHTML += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding:5px" width="0">'
	cHTML += '						<p align="left">'
	cHTML += '							<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '			</tbody>'
	cHTML += '		</table>'
	cHTML += '		<p>'
	cHTML += '			&nbsp;</p>'
	cHTML += '	</body>'
	cHTML += '</html>'
		
	FSSendMail( cEMail, cAssunto, cHTML, /*cAnexo*/ )
Return
//--------------------------------------------------------------------------
// Rotina | A610WF_Tim | Autor | Robson Gonçalves        | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de Time-Out p/reenvio do WF de compras sem modificar nada
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610WF_Tim( oWFTim )
	/*
	+----------------------------------------+
	| Funcionalidade retirada no dia 26/8/16 |
	+----------------------------------------+
	Local cFilPC := ''
	Local cNumPC := ''
	
	cFilPC := SubStr( oWFTim:oHTML:RetByName('cCampo29'), 1, 2 )
	cNumPC := SubStr( oWFTim:oHTML:RetByName('cCampo29'), 4, 6 )

	oWFTim:Finish()
	oWFTim:Free()
	
	SC7->( dbSetOrder( 1 ) )
	SC7->( dbSeek( cFilPC + cNumPC ) )
	A610WF_Env( cFilPC + cNumPC )
	*/
Return

//--------------------------------------------------------------------------
// Rotina | A610WF_Apv | Autor | Robson Gonçalves        | Data | 07/07/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para localizar e-mail dos aprovadores do pedido de 
//        | compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610WF_Apv( cNumPC )
	Local aAprov := {}
	
	Local cCR_FILIAL := ''
	Local cCR_NUM := ''
	Local cTRB := ''
	
	SC7->( dbSetOrder( 1 ) )
	SC7->( dbSeek( cNumPC ) )

	cCR_FILIAL := SubStr( cNumPC, 1, 2 )
	cCR_NUM := PadR( SubStr( cNumPC, 3 ), Len( SCR->CR_NUM ), ' ' )
	
	cTRB := GetNextAlias()
	
	BEGINSQL ALIAS cTRB
		SELECT SCR.CR_USER,
		SCR.CR_APROV,
		SAK.AK_NOME
		FROM   %Table:SCR% SCR
		INNER JOIN %Table:SAK% SAK
		ON AK_FILIAL = %xFilial:SAK%
		AND SAK.AK_COD = SCR.CR_APROV
		AND SAK.AK_USER = SCR.CR_USER
		AND SAK.%NotDel%
		WHERE  SCR.CR_FILIAL = %Exp:cCR_FILIAL%
		AND SCR.CR_NUM = %Exp:cCR_NUM%
		AND SCR.CR_TIPO = 'PC'
		AND SCR.CR_STATUS = '02'
		AND SCR.%NotDel%
	ENDSQL
	
	While (cTRB)->( .NOT. EOF() )
		AAdd( aAprov, { RTrim( (cTRB)->AK_NOME ), RTrim( UsrRetMail( (cTRB)->CR_USER ) ), (cTRB)->CR_USER, SC7->C7_APROV, (cTRB)->CR_APROV } )
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea())
Return( aAprov )


//--------------------------------------------------------------------------
// Rotina | A610MsgUser | Autor | Robson Gonçalves       | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para informar usuário quanto a aprovação ou rejeição do
//        | processo.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610MsgUser( cAprovacao, cSituacao, cMotivo )
	Local cObs := ''
	Local cHTML := ''
	Local cEmail := UsrRetMail( cCodElab )
	
	If cAprovacao == 'N'
		// Mensagem de objervação para somente Pedido
		If .NOT. Empty( cPedCompras ) .AND. Empty( cCotacao ) .AND. Empty( cMedicao ) .AND. Empty( cContrato )
			cObs := 'O pedido de compras ficar&aacute; congelado sem solicita&ccedil;&atilde;o de aprova&ccedil;&atilde;o do mesmo, por favor, altere o pedido de compras e refa&ccedil;a a capa de despesa.'
	
		// Mensagem de objervação para Cotação + Pedido
		Elseif .NOT. Empty( cPedCompras ) .AND. .NOT. Empty( cCotacao ) .AND. Empty( cMedicao ) .AND. Empty( cContrato )
			cObs := 'O pedido de compras ficar&aacute; congelado sem solicita&ccedil;&atilde;o de aprova&ccedil;&atilde;o do mesmo, o cota&ccedil;&atilde;o j&aacute; foi analisada, por favor, altere o pedido de compras e refa&ccedil;a a capa de despesa.'
	
		// Mensagem de objervação para Contrato + Medição + Pedido
		Elseif .NOT. Empty( cPedCompras ) .AND. Empty( cCotacao ) .AND. .NOT. Empty( cMedicao ) .AND. .NOT. Empty( cContrato )
			cObs := 'O pedido de compras foi excluído e a medição foi estornada, por favor, refazer o encerramento da medição.'
	
		Endif
	Else
		cObs := 'Aprova&ccedil;&atilde;o da capa de despesa finalizada, in&iacute;cio do workflow de aprova&ccedil;&atilde;o do pedido de compras.'
	Endif
	
	If Empty( cPedCompras )
		cPedCompras := 'Não há pedido de compras.'
	Endif
	
	If Empty( cMedicao )
		cMedicao := 'Não há medição.'
	Endif
	
	If Empty( cContrato )
		cContrato := 'Não há contrato.'
	Endif
	
	If Empty( cCotacao )
		cCotacao := 'Não há cotação.'
	Endif
	
	cHTML := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
	cHTML += '<html>'
	cHTML += '	<head>'
	cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
	cHTML += '		<title>Aprova&ccedil;&atilde;o de capa de despesa</title>'
	cHTML += '	</head>'
	cHTML += '	<body>'
	cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
	cHTML += '			<tbody>'
	cHTML += '				<tr>'
	cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle">'
	cHTML += '						<em><font color="#F4811D" face="Arial, Helvetica, sans-serif" size="5"><strong>Aprova&ccedil;&atilde;o de Capa de Despesa</strong></font><br />'
	cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em>'
	cHTML += '						<p>'
	cHTML += '							&nbsp;</p>'
	cHTML += '					</td>'
	cHTML += '					<td align="right" width="210">'
	cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
	cHTML += '						&nbsp;</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#F4811D" colspan="2" height="4" width="0">'
	cHTML += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding:5px;" width="0">'
	cHTML += '						<p>'
	cHTML += '							<font color="#333333" face="Arial, Helvetica, sans-serif" size="2">Sr(a). '+cNomElab+',<br />'
	cHTML += '							<br />'
	cHTML += '							A Capa de Despesa preenchida por voc&ecirc; foi '+cSituacao+'.</font></p><br />'
	cHTML += '						<table align="center" border="1" bordercolor="#F4811D" cellpadding="5" cellspacing="0" style="border: 1px solid #F4811D;" width="90%">'
	cHTML += '							<tbody>'
	cHTML += '								<tr style="border: 1px solid #F4811D;">'
	cHTML += '									<td align="center" bgcolor="#F4811D" colspan="2" style="background-color:#F4811D; color:#FFF; font-family:Arial, Helvetica, sans-serif; font-size:14px;" valign="top">'
	cHTML += '										<font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="3">INFORMA&Ccedil;&Otilde;ES B&Aacute;SICAS DO DOCUMENTO</font></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td valign="top">'
	cHTML += '										<font color="#333333" face="Arial, Helvetica, sans-serif"><span style="font-size: 12px;"><b>Pedido</b></span></font></td>'
	cHTML += '									<td valign="top">'
	cHTML += '										<span style="font-size:12px;"><font color="#333333" face="Arial, Helvetica, sans-serif">'+cPedCompras+'</font></span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr style="border: 1px solid #F4811D;">'
	cHTML += '									<td bgcolor="#FEDBAB" valign="top">'
	cHTML += '										<font color="#333333" face="Arial, Helvetica, sans-serif"><span style="font-size: 12px;"><b>Medi&ccedil;&atilde;o</b></span></font></td>'
	cHTML += '									<td bgcolor="#FEDBAB" valign="top">'
	cHTML += '										<span style="font-size:12px;"><span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif;">'+cMedicao+'</span></span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td style="vertical-align: top;">'
	cHTML += '										<font color="#333333" face="Arial, Helvetica, sans-serif"><span style="font-size: 12px;"><b>Contrato</b></span></font></td>'
	cHTML += '									<td style="vertical-align: top;">'
	cHTML += '										<span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+cContrato+'</span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td bgcolor="#FEDBAB" valign="top">'
	cHTML += '										<font color="#333333" face="Arial, Helvetica, sans-serif"><span style="font-size: 12px;"><b>Cota&ccedil;&atilde;o</b></span></font></td>'
	cHTML += '									<td bgcolor="#FEDBAB" valign="top">'
	cHTML += '										<span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+cCotacao+'</span></td>'
	cHTML += '								</tr>'
	cHTML += '								<tr>'
	cHTML += '									<td style="vertical-align: top;">'
	cHTML += '										<b style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Motivo</b></td>'
	cHTML += '									<td style="vertical-align: top;">'
	cHTML += '										<span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+cMotivo+'</span></td>'
	cHTML += '								</tr>'
	cHTML += '							</tbody>'
	cHTML += '						</table>'
	cHTML += '						<br />'
	cHTML += '					<span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">Observa&ccedil;&atilde;o: '+cObs+'</span><br />'
	cHTML += '					&nbsp;</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#02519B" colspan="2" height="2" width="0">'
	cHTML += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding:5px" width="0">'
	cHTML += '						<p align="left">'
	cHTML += '							<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '			</tbody>'
	cHTML += '		</table>'
	cHTML += '		<p>'
	cHTML += '			&nbsp;</p>'
	cHTML += '	</body>'
	
	FSSendMail( cEmail, 'Capa de Despesa - Retorno da análise.', cHTML, /*cAnexo*/ )
Return

//--------------------------------------------------------------------------
// Rotina | A610TiraZero | Autor | Robson Gonçalves      | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para retirar os zeros a esquerda dos códigos dos doctos.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610TiraZero( cDado )
	While .T.
		If SubStr( cDado, 1, 1 ) == '0'
			cDado := SubStr( cDado, 2 )
		Else
			Exit
		Endif
	End
Return( cDado )

//--------------------------------------------------------------------------
// Rotina | A610Knowledge | Autor | Robson Gonçalves     | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar quantas versões do mesmo documento existe
//        | no banco de conhecimento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Knowledge( cArq, cExt )
	Local cSQL := ''
	Local cTRB := ''
	Local cSeek := ''
	Local nCount := 0
	Local nP := 0
	
	//----------------------------
	// Possíveis nomes do arquivo.
	// CAPADESPESA_CTR123_MED123_PC123
	// ou
	// CAPADESPESA_PC123
	// ou
	// CAPADESPESA_COT123_PC568
	
	//---------------------------------------------
	// Padronizar o nome do documento em maiúsculo.
	cSeek := Upper( cArq )
	//----------------------------------------------------------
	// Capturar o tamanho do nome para buscar no banco de dados.
	nP := Len( cSeek )

	cSQL := "SELECT COUNT(*) QTD_DOCS "
	cSQL += "FROM   "+RetSqlName( "ACB" )+" ACB "
	cSQL += "WHERE  ACB_FILIAL = "+ValToSql( xFilial( "ACB" ) )+" "
	cSQL += "       AND SUBSTRING( ACB_OBJETO, 1, "+LTrim(Str(nP,2,0))+" ) = "+ValToSql( cSeek )+" "
	cSQL += "       AND ACB.D_E_L_E_T_ = ' ' "

	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	PLSQuery( cSQL, cTRB )
	nCount := (cTRB)->QTD_DOCS
	(cTRB)->( dbCloseArea() )

	If nCount == 0
		nCount := 1
	Else
		nCount := nCount + 1
	Endif
	
Return( cValToChar( nCount ) )

//--------------------------------------------------------------------------
// Rotina | A610Anexar | Autor | Robson Gonçalves        | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para anexar o documento capa de despesa no formato pdf
//        | aos registros do pedido de compras e medição.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Anexar( cArquivo, cNUM_DOC, cDocumento, cEntidade, lFirst )
	Local lRet := .T.
	Local cFile := ''
	Local cExten := ''
	Local cObjeto := ''
	Local cACB_CODOBJ := ''
	
	// Função do padrão que copia o objeto para o diretório do banco de conhecimentos.
	If lFirst
		lRet := FT340CpyObj( cArquivo )
	Endif
	
	If lRet
		SplitPath( cArquivo,,,@cFile, @cExten )
		cObjeto := Left( Upper( cFile + cExten ),Len( cArquivo ) )
		
		cACB_CODOBJ := GetSXENum('ACB','ACB_CODOBJ')
	
		ACB->( RecLock( 'ACB', .T. ) )
		ACB->ACB_FILIAL	:= xFilial( 'ACB' )
		ACB->ACB_CODOBJ	:= cACB_CODOBJ
		ACB->ACB_OBJETO	:= cObjeto
		ACB->ACB_DESCRI	:= cDocumento
		If FindFunction( 'MsMultDir' ) .And. MsMultDir()
			ACB->ACB_PATH	:= MsDocPath( .T. )
		Endif
		ACB->( MsUnLock() )
		ACB->( ConfirmSX8() )
		
		AC9->( RecLock( 'AC9', .T. ) )
		AC9->AC9_FILIAL	:= xFilial( 'AC9' )
		AC9->AC9_FILENT	:= xFilial( cEntidade )
		AC9->AC9_ENTIDA	:= cEntidade
		AC9->AC9_CODENT	:= xFilial( cEntidade ) + cNUM_DOC
		AC9->AC9_CODOBJ	:= cACB_CODOBJ
		AC9->AC9_DTGER    := dDataBase
		AC9->( MsUnLock() )
		
		ACC->( RecLock( 'ACC', .T. ) )
		ACC->ACC_FILIAL := xFilial( 'ACC' )
		ACC->ACC_CODOBJ := cACB_CODOBJ
		ACC->ACC_KEYWRD := cNUM_DOC + ' ' + cDocumento
		ACC->( MsUnLock() )
	Else
		MsgAlert('Não foi possível anexar o documento no banco de conhecimento, problemas com o FT340CPYOBJ.','Inconsistência')
	Endif
Return(cObjeto)

//--------------------------------------------------------------------------
// Rotina | A610GetAnexo | Autor | Robson Gonçalves      | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para capturar os arquivos anexos.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610GetAnexo( aC7_ANEXOS, cC7_NUM, nQTDAlt )
	Local cSQL := ''
	Local cTRB := ''
	Local cRoot := '/'
	Local cKey := ''
	Local cKeyDe := ''
	Local cKeyAte := ''
	Local nTam := Len( SC7->C7_ITEM )
	Local cFilPC := xFilial( 'SC7' )
	
	Default nQTDAlt := 0
	
	If ValType( cC7_NUM ) == 'C'
		cFilPC := SubStr( cC7_NUM, 1, Len( SC7->C7_FILIAL ) )
		cKey := cC7_NUM
	Else
		cKey := xFilial( 'SC7' ) + cNUM_PED_COM
	Endif
	
	cKeyDe  := cKey + Replicate( ' ', nTam )
	cKeyAte := cKey + Replicate( 'z', nTam )
	
	cSQL := "SELECT Max(ACB_OBJETO) AS ACB_OBJETO, Count(*) AS nCount "
	cSQL += "FROM   "+RetSqlName("AC9")+" AC9 "
	cSQL += "       INNER JOIN "+RetSqlName("ACB")+" ACB "
	cSQL += "               ON ACB_FILIAL = "+ValToSql(xFilial("ACB"))+" "
	cSQL += "                  AND ACB_CODOBJ = AC9_CODOBJ "
	cSQL += "                  AND ACB.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  AC9_FILIAL = "+ValToSql(xFilial("AC9"))+" "
	cSQL += "       AND AC9_FILENT = "+ValToSql(cFilPC)+" "
	cSQL += "       AND AC9_ENTIDA = 'SC7' "
	cSQL += "       AND AC9_CODENT >= "+ValToSql(cKeyDe)+" "
	cSQL += "       AND AC9_CODENT <= "+ValToSql(cKeyAte)+" "
	cSQL += "       AND AC9.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	
	While (cTRB)->( .NOT. EOF() )
		AAdd( aC7_ANEXOS, cRoot + RTrim( (cTRB)->ACB_OBJETO ) )
		nQTDAlt := (cTRB)->nCount
		(cTRB)->( dbSkip() )
	End
	
	(cTRB)->( dbCloseArea() )
Return

//--------------------------------------------------------------------------
// Rotina | A610QJaLib  | Autor | Robson Gonçalves       | Data | 26/11/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para analisar quem já liberou o pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610QJaLib( cCodPC, cQuemJaLib )
	Local cFIL := SubStr( cCodPC, 1, 2 )
	Local cPED := SubStr( cCodPC, 3 )
	Local cUsuAprov := ''
	
	cPED := PadR( cPED, Len( SCR->CR_NUM ), ' ' )
	
	SCR->( dbSetOrder( 1 ) )
	SCR->( dbSeek( cFIL + 'PC' + cPED ) )
	While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == cFIL .AND. SCR->CR_TIPO == 'PC' .AND. SCR->CR_NUM == cPED
		If SCR->CR_STATUS $ '03|05'
			cUsuAprov += RTrim( UsrFullName( SCR->CR_USER ) ) + ', '
		Endif
		SCR->( dbSkip() )
	End
	cUsuAprov := SubStr( cUsuAprov, 1, Len( cUsuAprov )-2 )
	If Empty( cUsuAprov )
		cQuemJaLib := 'Até o momento nenhum aprovador analisou o pedido de compra.'
	Else
		cQuemJaLib := cUsuAprov
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610SCR     | Autor | Robson Gonçalves       | Data | 27/10/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para aprovar/rejeitar a capa de sistema via Protheus.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610SCR()
	Local aButton := {}
	Local aCores := {}
	Local aPar := {}
	Local aRet := {}
	Local aSay := {}
	
	Local cFilSCR := ''
	Local cFilSQL := ''
	Local cMV_610FUSU := 'MV_610FUSU'
	
	Local lChange := .T.
	
	Local nOpcao := 0
	
	Private aExibir := {}
	Private aIndexSCR := {}
	Private aRotina := {}
	
	Private bFilBrowse := {|| NIL }
	Private cCadastro := 'Aprov/Rej Capa de Despesa'
	Private nExibir := 0
	
	// Executa a rotina para habilitar o parâmetro.
	A610SCRPar( @cMV_610FUSU )
	
	// Armazenar na tecla de atalho a chamada da rotina com possibilidade de mudar.
	SetKey( VK_F12 , {|| A610SCRPar( @cMV_610FUSU, lChange ) } )
	
	AAdd( aSay, 'Rotina para consultar, aprovar ou rejeitar os dados da capa de despesas em nível de' )
	AAdd( aSay, 'análise do planejamento financeiro.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	// Desabilitar a tecla de atalho.
	SetKey( VK_F12 , {|| NIL } )

	If nOpcao == 1
		
		aCores := { { 'CR_STATUS== "01"', 'BR_AZUL' },; //Bloqueado (aguardando outros niveis)
		{ 'CR_STATUS== "02"', 'DISABLE' },; //Aguardando Liberacao do usuario
		{ 'CR_STATUS== "03"', 'ENABLE'  },; //Documento Liberado pelo usuario
		{ 'CR_STATUS== "04"', 'BR_PRETO'},; //Documento Bloqueado pelo usuario
		{ 'CR_STATUS== "05"', 'BR_CINZA'} } //Documento Liberado por outro usuario
	
		AAdd( aRotina, { 'Pesquisar' , 'AxPesqui()'   , 0, 1, 0, .F. } )
		AAdd( aRotina, { 'Consultar' , 'U_A610SCRC(1)', 0, 2, 0, NIL } )
		AAdd( aRotina, { 'Aprovar'   , 'U_A610SCRA(1)', 0, 4, 0, NIL } )
		AAdd( aRotina, { 'Rejeitar'  , 'U_A610SCRA(2)', 0, 2, 0, NIL } )
		AAdd( aRotina, { 'Imprimir'  , 'U_A610SCRC(2)', 0, 2, 0, NIL } )
		AAdd( aRotina, { 'Pedido'    , 'U_A610SCRP'   , 0, 2, 0, NIL } )
		AAdd( aRotina, { 'Visualizar', 'AxVisual'     , 0, 2, 0, NIL } )
		AAdd( aRotina, { 'Legenda'   , 'U_A610SCRL'   , 0, 2, 0, .F. } )
		
		aExibir := {'Pendentes','Aprovados','Rejeitados','Todos'}
		
		AAdd( aPar, { 2, 'Exibir documentos', 1, aExibir, 90, '', .T. } )
		
		If ParamBox( aPar, 'Parâmetros de filtro',@aRet,,,,,,,,.F.,.F.)
			nExibir := Iif( ValType( aRet[ 1 ] ) == 'N', aRet[ 1 ], AScan( aExibir, {|e| e==aRet[ 1 ] } ) )
			
			// Expressão SQL
			cFilSQL := "CR_FILIAL = '"+xFilial("SCR")+"' "
			
			// Verificar se está habilitado o filtro de usuário conforme o parâmetro.
			If cMV_610FUSU == 1
				cFilSQL += "AND CR_USER = '" + __cUserID + "' "
			Endif
			
			cFilSQL += "AND CR_TIPO = '"+cTP_DOC+"' "
			
			If nExibir == 1 // Pendentes
				cFilSQL += "AND CR_STATUS = '02' "
			Elseif nExibir == 2 // Aprovados
				cFilSQL += "AND (CR_STATUS = '03' OR CR_STATUS = '05') "
			Elseif nExibir == 3 // Rejeitados
				cFilSQL += "AND (CR_STATUS = '01' OR CR_STATUS = '04') "
			Endif
			
			MBrowse(,,,,'SCR',,,,,,aCores,,,,,,,,cFilSQL)
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610SCRPar  | Autor | Robson Gonçalves       | Data | 08.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina p/criar o parâmetro ou mudar caso esteja desabilidado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610SCRPar( cMV_610FUSU, lChange )
	Local cX6_VAR := 'MV_610FUSU'
	Local nX6_CONTEUD := 0
	
	DEFAULT lChange := .F.
	
	If lChange
		nX6_CONTEUD := cMV_610FUSU
		// Se o conteúdo do parâmetro é 1 e é para desabilitar o filtro?
		If nX6_CONTEUD == 1 .AND. lChange
			If MsgYesNo('Desabilitar o parâmtero '+cX6_VAR+' que é relativo ao filtro do usuário nesta rotina?', cCadastro )
				// Então desabilitar o parâmetro para uso momentâneo.
				PutMV( cX6_VAR, '0' )
				cMV_610FUSU := 0
				MsgInfo('Parâmetro '+cX6_VAR+' desabilitado com sucesso.',cCadastro)
			Endif
		Else
			// Se o conteúdo do parâmetro é 0 é para habilitar o filtro! Ou seja, ação automática.
			If GetMv( cX6_VAR, .F. ) == 0
				// Então habilitar o parâmetro para utilizar com filtro.
				PutMV( cX6_VAR, '1' )
				cMV_610FUSU := 1
			Endif
		Endif
	Else
		// Se não existir o parâmetro.
		If .NOT. GetMv( cMV_610FUSU, .T. )
			// Criar o parâmetro.
			CriarSX6( cMV_610FUSU, 'N', 'HABILITAR O FILTRO DE USUARIO NA ROTINA DE APROVAR/REJEITAR CAPA DE DESPESA. Rotina CSFA610.prw', '1' )
		Endif
		// Capturar o conteúdo do parâmetro.
		cMV_610FUSU := GetMv( cMV_610FUSU, .F. )
		If cMV_610FUSU == 0
			PutMV( cX6_VAR, '1' )
			cMV_610FUSU := 1
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610SCRC    | Autor | Robson Gonçalves       | Data | 27/10/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para consultar os registros de aprovação da capa de desp.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610SCRC( nAcao )
	Local oDlg
	Local oLbx
	Local oBold

	Local cSQL := ''
	Local cTRB := ''
	Local cCR_NUM := SCR->CR_NUM
	Local nCR_RECNO := SCR->( RecNo() )
	Local aStruSCR := {}
	Local cNameUser := ''
	Local nPos := 0
	Local nOk := 0
	Local nNo := 0
	Local nWait := 0
	Local cSituacao := ''
	Local aDADOS := {}
	Local cStatus := ''
	Local cVinculo := ''
	Local aPar := {}
	Local aRet := {}
	Local nDisplay := 0
	Local nOrdem := 0
	Local aOrdem := {'Usuário', 'Documento', 'Data de emissão'}
	Local nRecSC7 := 0
	
	// Capturar dados dos vínculos do registro.
	SC7->( dbSetOrder( 1 ) )
	If SC7->( dbSeek( xFilial( 'SC7' ) + RTrim( cCR_NUM ) ) )
		nRecSC7 := SC7->( RecNo() )
		cVinculo := 'Pedido: ' + SC7->C7_NUM
		If .NOT. Empty( SC7->C7_NUMSC )
			cVinculo += ' - Solicitação: ' + SC7->C7_NUMSC + '/' + SC7->C7_ITEMSC
		Endif
		If .NOT. Empty( SC7->C7_NUMCOT )
			cVinculo += ' - Cotação: ' + SC7->C7_NUMCOT
		Endif
		If .NOT. Empty( SC7->C7_CONTRA )
			cVinculo += ' - Contrato: ' + SC7->C7_CONTRA + ' - Medição: ' + SC7->C7_MEDICAO
		Endif
	Endif
	
	If nAcao == 1
		cSQL := "SELECT CR_USER, "
		cSQL += "       CR_NIVEL, "
		cSQL += "       CR_STATUS, "
		cSQL += "       CR_DATALIB "
		cSQL += "FROM   "+RetSqlName("SCR")+" SCR "
		cSQL += "WHERE  CR_FILIAL = "+ValToSql( xFilial( "SCR" ) )+" "
		cSQL += "       AND CR_NUM = "+ValToSql( cCR_NUM ) + " "
		cSQL += "       AND CR_TIPO = "+ValToSql( cTP_DOC )+" "
		cSQL += "       AND SCR.D_E_L_E_T_ = ' ' "
		cSQL += "ORDER  BY CR_USER "
	Else
		AAdd( aPar, { 2, 'Exibir documentos'   ,nExibir,aExibir,90,'',.T.})
		AAdd( aPar, { 1, 'Data de emissão de ' ,Ctod(Space(8)),'','','','',50,.F.})
		AAdd( aPar, { 1, 'Data de emissão até ',Ctod(Space(8)),'','(MV_PAR03>=MV_PAR02)','','',50,.T.})
		AAdd( aPar, { 1, 'Nº Documento de'     ,Space(6),'','','SC7','',30,.F.})
		AAdd( aPar, { 1, 'Nº Documento até'    ,Space(6),'','(MV_PAR05>=MV_PAR04)','SC7','',30,.T.})
		AAdd( aPar, { 2, 'Listar em ordem'     ,1,aOrdem,90,'',.T.})
		
		If .NOT. ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.F.,.F.)
			Return
		Endif
		
		nDisplay := Iif( ValType( aRet[ 1 ] ) == 'N', aRet[ 1 ], AScan( aExibir, {|e| e==aRet[ 1 ] } ) )
		nOrdem   := Iif( ValType( aRet[ 6 ] ) == 'N', aRet[ 6 ], AScan( aOrdem, {|e| e==aRet[ 6 ] } ) )

		cSQL := "SELECT CR_USER, "
		cSQL += "       CR_NIVEL, "
		cSQL += "       CR_STATUS, "
		cSQL += "       CR_DATALIB, "
		cSQL += "       CR_NUM, "
		cSQL += "       CR_TIPO "
		cSQL += "FROM   "+RetSqlName("SCR")+" SCR "
		cSQL += "WHERE  CR_FILIAL = "+ValToSql(xFilial("SCR"))+" "
		cSQL += "       AND CR_EMISSAO >= "+ValToSql(aRet[2]) + " AND CR_EMISSAO <= "+ValToSql(aRet[3])+" "
		cSQL += "       AND RTrim(CR_NUM) >= "+ValToSql(aRet[4]) + " AND RTrim(CR_NUM) <= "+ValToSql(aRet[5])+" "
		cSQL += "       AND CR_TIPO = "+ValToSql(cTP_DOC)+" "
	   
		If nDisplay == 1 // Pendentes
			cSQL += "AND CR_STATUS = '02' "
		Elseif nDisplay == 2 // Aprovados
			cSQL += "AND (CR_STATUS = '03' OR CR_STATUS = '05') "
		Elseif nDisplay == 2 // Rejeitados
			cSQL += "AND (CR_STATUS = '01' OR CR_STATUS = '04') "
		Endif
		
		cSQL += "       AND SCR.D_E_L_E_T_ = ' ' "
	   
		If nOrdem == 1
			cSQL += "ORDER  BY CR_USER "
		Elseif nOrdem == 2
			cSQL += "ORDER  BY CR_NUM "
		Elseif nOrdem == 3
			cSQL += "ORDER  BY CR_EMISSAO "
		Endif
	Endif

	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	
	If (cTRB)->(.NOT. BOF()) .AND. (cTRB)->(.NOT.EOF())
		aStruSCR  := SCR->( dbStruct() )
		AEval( aStruSCR, {|e| Iif( e[ 2 ] <> 'C', TCSetField( cTRB, e[ 1 ], e[ 2 ], e[ 3 ], e[ 4 ] ), NIL ) } )
		While (cTRB)->(.NOT. EOF() )
			cNameUser := RTrim( UsrFullName( (cTRB)->CR_USER ) )
			nPos := At(' ',cNameUser)
			cNameUser := SubStr(cNameUser,1,nPos-1)
			If (cTRB)->CR_STATUS == '02'
				cSituacao := 'Aguardando...'
				nWait++
			Elseif (cTRB)->CR_STATUS == '03'
				cSituacao := 'Aprovada.'
				nOk++
			Elseif (cTRB)->CR_STATUS == '04'
				cSituacao := 'Rejeitada.'
				nNo++
			Endif
			
			If nAcao == 1
				(cTRB)->( AAdd( aDADOS, { CR_NIVEL, CR_USER, cSituacao, cNameUser, Iif( nAcao == 1, Dtoc( CR_DATALIB ), Dtoc( CR_DATALIB ) ), ' ' } ) )
			Else
				(cTRB)->( AAdd( aDADOS, { CR_NUM, 'Capa de Despesa', CR_NIVEL, CR_USER, cSituacao, cNameUser, Iif( nAcao == 1, Dtoc( CR_DATALIB ), Dtoc( CR_DATALIB ) ), ' ' } ) )
			Endif
			
			(cTRB)->( dbSkip() )
		End
	   
	   // Avaliar o status.
		If nWait > nOk
			If nWait > nNo
				cStatus := 'Capa de despesas aguardando análise...'
			Else
				cStatus := 'Capa de despesas rejeitada.'
			Endif
		Else
			If nOk > nNo
				cStatus := 'Capa de despesas aprovada.'
			Else
				cStatus := 'Capa de despesas rejeitada.'
			Endif
		Endif
	   
		If nAcao == 1
			DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
			DEFINE MSDIALOG oDlg TITLE cCadastro From 109,095 To 400,600 OF oMainWnd PIXEL
			@ 5,3 TO 32,250 LABEL "" OF oDlg PIXEL
				
			@ 15,07 SAY 'Documentos:' OF oDlg FONT oBold PIXEL SIZE 46,9
			@ 14,47 MSGET cVinculo PICTURE "" WHEN .F. PIXEL SIZE 200,9 OF oDlg FONT oBold
				
			oLbx := TwBrowse():New(38,3,250,80,,{'Nível','Usuário','Situação','Aprovado por','Data liberação',''},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oLbx:SetArray( aDADOS )
			oLbx:bLine := {|| AEval( aDADOS[oLbx:nAt],{|z,w| aDADOS[oLbx:nAt,w]})}
				
			@ 120,3 TO 132,253 LABEL '' OF oDlg PIXEL
				
			@ 122,008 SAY 'Situação:' OF oDlg PIXEL SIZE 52,9
			@ 122,038 SAY cStatus OF oDlg PIXEL SIZE 120,9 FONT oBold

			@ 134,129 BUTTON 'Pedido'       SIZE 40 ,10 FONT oDlg:oFont ACTION (U_A610SCRP('SCR',nCR_RECNO,2)) OF oDlg PIXEL
			@ 134,171 BUTTON 'Conhecimento' SIZE 40 ,10 FONT oDlg:oFont ACTION (MsDocument('SC7',nRecSC7,2)) OF oDlg PIXEL
			@ 134,213 BUTTON 'Fechar'       SIZE 40 ,10 FONT oDlg:oFont ACTION (oDlg:End()) OF oDlg PIXEL
			ACTIVATE MSDIALOG oDlg CENTERED
		Else
			FWMsgRun( , {|| DlgToExcel( { { "ARRAY", cCadastro, {'Nº Documento','Tipo de controle','Nível','Usuário','Situação','Aprovado por','Data liberação',''}, aDADOS } } ) }, ,'Imprimindo, aguarde...' )
		Endif
	Else
		MsgInfo('Não localizado movimento para Capa de Despesa',cCadastro)
	Endif
	(cTRB)->( dbCloseArea() )
Return

//--------------------------------------------------------------------------
// Rotina | A610SCRP    | Autor | Robson Gonçalves       | Data | 24/11/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para consultar o pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610SCRP( cAlias, nRecNo, nOpcX )
	Local cC7_NUM := ''
	Local aArea := {}
	Private nTipoPed  := 1
	Private l120Auto  := .F.
	Private INCLUI    := .F.
	Private ALTERA    := .F.
	Private aBackSC7  := {}
	aArea := { SC7->( GetArea() ), SCR->( GetArea() ) }
	SCR->( dbGoTo( nRecNo ) )
	cC7_NUM := RTrim( SCR->CR_NUM )
	SC7->( dbSetOrder( 1 ) )
	If SC7->( dbSeek( xFilial( 'SC7' ) + cC7_NUM ) )
		A120Pedido( 'SC7', SC7->( RecNo() ), 2 )
	Else
		MsgInfo(cFONT+'Não foi possível localizar o pedido de compras desta alçada. Por favor, verifique o pedido de compras.'+cNOFONT,cCadastro)
	Endif
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return

//--------------------------------------------------------------------------
// Rotina | A610SCRA    | Autor | Robson Gonçalves       | Data | 27/10/2015
//--------------------------------------------------------------------------
// Descr. | Rotina para aprovar ou rejeitar a capa de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610SCRA( nAcao )
	Local aCPOS := {}
	Local aX3_CAMPO := {}
	Local aC7_DADOS := {}
	Local nI := 0
	Local cTitulo := ''
	Local cF3 := ''
	Local cValid := ''
	Local lObrigat := .F.
	Local lMemoria := .F.
	Local lOk := .F.
	Local cPicture := ''
	Local cWhen := ''
	Local aField := {}
	Local oDlgCP
	Local cTituloDlg := 'Aprovar/Rejeitar Capa de Despesa'
	Local oScroll
	Local oEnch
	Local bOk := {|| NIL }
	Local nOpc := 2
	Local cCR_NUM := RTrim( SCR->CR_NUM )
	Local cCR_STATUS := ''
	Local cAprovacao := ''
	Local cSituacao := ''
	Local cMotivo := ''
	Local aPar := {}
	Local aRet := {}
	Local lMedicao := .F.
	Local cNameUser := ''
	Local nP := 0
	Local cQuebra := ''
	
	Private cCodElab := ''
	Private cNomElab := ''
	Private cPedCompras := ''
	Private cMedicao := ''
	Private cContrato := ''
	Private cCotacao := ''
	
	If nAcao == 1
		bOk := {|| lOk := MsgYesNo('Confirma a aprovação da capa de despesa?',cTituloDlg), Iif(lOk,oDlgCP:End(),NIL) }
	Else
		bOk := {|| lOk := MsgYesNo('Confirma a rejeição da capa de despesa?',cTituloDlg), Iif(lOk,oDlgCP:End(),NIL) }
	Endif
	
	SC7->( dbSetOrder( 1 ) )
	SC7->( dbSeek( xFilial( 'SC7' ) + cCR_NUM ) )
	
	//Estrutura do vetor
	//[1] - Campo
	//[2] - Título
	//[3] - F3
	//[4] - Valid
	//[5] - Obrigatório => .T. sim, .F. considerar o que está no SX3.
	//[6] - Picture
	//[7] - When
	AAdd( aCPOS,{ 'C7_NUM'    ,'Número do Pedido de Compras'       ,'', '', .F., '', '.F.' } )
	AAdd( aCPOS,{ 'C7_EMISSAO','Data de emissão'                   ,'', '', .F., '', '.F.' } )
	AAdd( aCPOS,{ 'C7_XREFERE' ,'Mês/Ano Ref.'                     ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_APBUDGE' ,'Aprovado em budget?'              ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_XRECORR' ,'Tipo de compra?'                  ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_CCAPROV' ,'Centro Custo Aprovação'           ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_DESCCCA' ,'Descric.C.Custo Aprovação'        ,'', '', .F., '', '' } )
	AAdd( aCPOS,{ 'C7_CC'      ,'Centro custo da despesa'          ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_DESCCC'  ,'Descric. C. C. da despesa'        ,'', '', .F., '', '' } )
	AAdd( aCPOS,{ 'C7_ITEMCTA' ,'Centro de resultado'              ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_DEITCTA' ,'Descrição C. Resultado'           ,'', '', .F., '', '' } )
	AAdd( aCPOS,{ 'C7_CLVL'    ,'Código do projeto'                ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_DESCLVL' ,'Descrição do projeto'             ,'', '', .F., '', '' } )
	AAdd( aCPOS,{ 'C7_CTAORC'  ,'Conta contábil orçada'            ,'', '', .F., '', '' } )
	AAdd( aCPOS,{ 'C7_DESCCOR' ,'Descricao conta orçada'           ,'', '', .F., '', '' } )
	AAdd( aCPOS,{ 'C7_DDORC'   ,'Descrição da despesa no Orçamento','', '', .F., '', '' } )
	AAdd( aCPOS,{ 'C7_DESCRCP' ,'Descrição'                        ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_XJUST'   ,'Justificativa'                    ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_XOBJ'    ,'Objetivo'                         ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_XADICON' ,'Informação adicional'             ,'', '', .F., '', '' } )
	AAdd( aCPOS,{ 'C7_FORMPG'  ,'Forma de pagamento'               ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_XVENCTO' ,'Vencimento'                       ,'', '', .T., '', '' } )
	AAdd( aCPOS,{ 'C7_DOCFIS'  ,'Nr.Docto. Fiscal'                 ,'', '', .F., '', '' } )
	AAdd( aCPOS,{ 'C7_COND'    ,'Cond.de Pagto.'                   ,'', '', .F., '', '.F.' } )
	AAdd( aCPOS,{ 'C7_FILENT'  ,'Filial de entrega?'               ,'', '', .F., '', '' } )
	AAdd( aCPOS,{ 'C7_RATCC'   ,'Rateio por centro custo'          ,'', '', .F., '', '.F.' } )
	AAdd( aCPOS,{ 'C7_XCONTRA' ,'Contrato'                         ,'', '', .F., '', '.F.' } )
		
	AEval( aCPOS, {|e| AAdd( aX3_CAMPO, e[ 1 ] ) } )
	
	C610ToMemory( aX3_CAMPO, .F. )

	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCPOS )
		If SX3->( dbSeek( aCPOS[ nI, 1 ] ) )
			cTitulo  := RTrim( Iif( Empty( aCPOS[ nI, 2 ] ), SX3->X3_TITULO, aCPOS[ nI, 2 ] ) )
			cF3      := RTrim( Iif( Empty( aCPOS[ nI, 3 ] ), SX3->X3_F3    , aCPOS[ nI, 3 ] ) )
			cValid   := RTrim( Iif( Empty( aCPOS[ nI, 4 ] ), SX3->X3_VALID , aCPOS[ nI, 4 ] ) )
			lObrigat := Iif( aCPOS[ nI, 5 ], aCPOS[ nI, 5 ], X3Obrigat( SX3->X3_CAMPO ) )
			cPicture := RTrim( Iif( Empty( aCPOS[ nI,6]), SX3->X3_PICTURE, aCPOS[ nI, 6 ] ) )
			cWhen    := RTrim( Iif( Empty( aCPOS[ nI,7]), SX3->X3_WHEN, aCPOS[ nI, 7 ] ) )
			
			AAdd( aField, {cTitulo,;
				SX3->X3_CAMPO,;
				SX3->X3_TIPO,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				cPicture,;
				&('{||' + AllTrim(cValid)+ '}'),;
				.T.,;
				SX3->X3_NIVEL,;
				SX3->X3_RELACAO,;
				cF3,;
				&('{||' + RTrim(cWhen) + '}'),;
				SX3->X3_VISUAL=='V',;
				.F.,;
				SX3->X3_CBOX,;
				VAL(SX3->X3_FOLDER),;
				.F.,;
				''} )
		Endif
	Next nI
	
	DEFINE MSDIALOG oDlgCP TITLE cTituloDlg FROM 0,0 TO 400,640 PIXEL STYLE DS_MODALFRAME STATUS
	oDlgCP:lEscClose := .F.
		
	oScroll := TScrollBox():New(oDlgCP,1,1,1000,1000,.T.,.F.,.F.)
	oScroll:Align := CONTROL_ALIGN_ALLCLIENT
			
	oEnch := MsMGet():New(	/*cAlias*/,;
										/*nRecNo*/,;
										nOpc,;
										/*aCRA*/,;
										/*cLetras*/,;
										/*cTexto*/,;
										aCPOS,;
										/*aPos*/,;
										/*aAlterEnch*/,;
										/*nModelo*/,;
										/*nColMens*/,;
										/*cMensagem*/,;
										/*cTudoOk*/,;
										oDlgCP,;
										/*lF3*/,;
										lMemoria,;
										/*lColumn*/,;
		        						/*caTela*/,;
		        						/*lNoFolder*/,;
		        						/*lProperty*/,;
		        						aField,;
		        						/*aFolder*/,;
		        						/*lCreate*/,;          
		        						/*lNoMDIStretch*/,;
		        						/*cTela*/)
		
		oEnch:oBox:Align := CONTROL_ALIGN_ALLCLIENT		
	ACTIVATE MSDIALOG oDlgCP CENTER ON INIT EnchoiceBar(oDlgCP,bOK,{|| oDlgCP:End()} )
	
	If lOk
		If MsgYesNo('Prosseguir com a ação selecionada?', cTituloDlg )
			cCR_STATUS := Iif( nAcao == 1, '03', '04' )
			cAprovacao := Iif( nAcao == 1, 'S', 'N' )
			cSituacao  := Iif( nAcao == 1, 'aprovada', 'rejeitada' )
			
			// É rejeição, solicitar o motivo.
			If nAcao == 2
				AAdd(aPar,{11,"Motivo da rejeição","",".T.",".T.",.T.})
				While .T.
					If ParamBox(aPar,'',@aRet,,,,,,,,.F.,.F.)
						cMotivo := AllTrim( aRet[ 1 ] )
						Exit
					Else
						MsgAlert('É obrigatório informar o motivo da rejeição.',cTituloDlg)
					Endif
				End
			Endif
			
			cMotivo := AllTrim( cMotivo ) + CRLF + '#' + UsrFullName( RetCodUsr() )

			SCR->( dbSetOrder( 2 ) )
			If SCR->( dbSeek( xFilial( 'SCR' ) + cTP_DOC + cCR_NUM ) )
				cNameUser := RTrim( UsrFullName( RetCodUsr() ) )
				nP := At( ' ', cNameUser )
				If nP == 0
					nP := 16
				Endif
				cNameUser := SubStr( cNameUser, 1, nP-1 )
				While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == xFilial( 'SCR') .AND. RTrim( SCR->CR_NUM ) == cCR_NUM .AND. SCR->CR_TIPO == cTP_DOC
					SCR->( RecLock( 'SCR', .F. ) )
					SCR->CR_STATUS  := cCR_STATUS // 03-Liberado pelo usuario ou 04-Bloqueado pelo usuario.
					SCR->CR_DATALIB := dDataBase
					If .NOT. Empty( SCR->CR_LOG ) .AND. Empty( cQuebra )
						cQuebra := CRLF
					Endif
					SCR->CR_LOG     := RTrim( SCR->CR_LOG ) +;
					                   cQuebra +;
					                   'Usuário ' + cNameUser + ' ' +;
					                   Iif( cAprovacao == 'S', ' aprovou', ' rejeitou' ) +;
					                   ' via sistema ' +;
					                   ' a capa de despesa em ' +;
					                   Dtoc( MsDate() ) +;
					                   ' ' +;
					                   Time()
					SCR->( MsUnLock() )
					SCR->( dbSkip() )
				End
								
				aC7_DADOS := SX3->( GetAdvFVal( 'SC7', { 'C7_USER', 'C7_NUM', 'C7_CONTRA', 'C7_MEDICAO', 'C7_NUMCOT' }, xFilial( 'SC7' ) + RTrim( cCR_NUM ), 1 ) )
				
				// Avisar o Planejamento Financeiro que foi aprovado/rejeitado a Capa de Despesa
				A610MPlanF( xFilial('SCR') + '-' + aC7_DADOS[ 2 ], cSituacao, cMotivo )

				cCodElab    := aC7_DADOS[ 1 ]
				cNomElab    := UsrFullName( cCodElab )
				cPedCompras := aC7_DADOS[ 2 ]
				cContrato   := aC7_DADOS[ 3 ]
				cMedicao    := aC7_DADOS[ 4 ]
				cCotacao    := aC7_DADOS[ 5 ]
				
				If nAcao == 1
					FWMsgRun( , {|| U_A610WFPC() }, ,'Capa de despesa aprovada, enviando WF...' )
					MsgInfo(cFONT+'Iniciado o processo de aprovação do pedido de compras por causa da aprovação na Capa de Despesa.'+cNOFONT,cCadastro)
				Elseif nAcao == 2
					If .NOT. Empty( cMedicao )
						FWMsgRun( , {|| lMedicao := A610EstMed( cMedicao ) }, ,'Capa de despesa reprovada, aguarde...' )
						If lMedicao 
							A610MsgUser( cAprovacao, cSituacao, cMotivo )
							MsgInfo(cFONT+'A medição foi estornada com sucesso por causa da rejeição na Capa de Despesa.'+cNOFONT,cCadastro)
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610EAlc    | Autor | Robson Gonçalves       | Data | 04.11.2015
//--------------------------------------------------------------------------
// Descr. | Rotina para excluir os registros de aprovação/rejeição da capa 
//        | de despesa. Rotina está sendo acionada pelo ponto de entrada
//        |	CN120EsMed.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610EAlc( cCR_NUM )
	Local aArea := {}
	aArea := SCR->( GetArea() )
	SCR->( dbSetOrder( 2 ) )
	If SCR->( dbSeek( xFilial( 'SCR' ) + cTP_DOC + cCR_NUM ) )
		While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == xFilial( 'SCR') .AND. SCR->CR_NUM == cCR_NUM
			SCR->( RecLock( 'SCR', .F. ) )
			SCR->( dbDelete() )
			SCR->( MsUnLock() )
			SCR->( dbSkip() )
		End
	Endif
	//----------------------------------------------
	// Somente se for rotina executada pelo usuário.
	If .NOT. IsBlind()
		PB6->( dbSetOrder( 2 ) )
		If PB6->( dbSeek( CND->CND_FILIAL + CND->CND_NUMMED ) )
			PB6->( RecLock( 'PB6', .F. ) ) 
			PB6->( dbDelete() )
			PB6->( MsUnLock() )
		Endif
	Endif
	SCR->( RestArea( aArea ) )
Return

//--------------------------------------------------------------------------
// Rotina | A610SCRL    | Autor | Robson Gonçalves       | Data | 14.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina para apresentar a legenda para o usuário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610SCRL()
	Local aCor := {}
	
	AAdd( aCor, { 'BR_AZUL'     , 'Bloqueado (aguardando outros níveis)' } )
	AAdd( aCor, { 'BR_VERMELHO' , 'Aguardando liberação do usuário' } )
	AAdd( aCor, { 'BR_VERDE'    , 'Documento liberado pelo usuário' } )
	AAdd( aCor, { 'BR_PRETO'    , 'Documento bloqueado pelo usuário' } )
	AAdd( aCor, { 'BR_CINZA'    , 'Documento liberado por outro usuário' } )
	
	BrwLegenda( cCadastro, 'Legenda dos registros', aCor )
Return

//--------------------------------------------------------------------------
// Rotina | A610Re0     | Autor | Robson Gonçalves       | Data | 13.11.2015
//--------------------------------------------------------------------------
// Descr. | Rotina p/ reenviar WF da capa de despesas e/ou pedido de compras
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Re0()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	Private cCadastro := 'Reenviar WF Capa de Despesas e/ou PC'
	
	AAdd( aSay, 'Rotina para reenviar o workflow da capa de despesa e/ou pedido de compra.' )
	AAdd( aSay, 'O objetivo é o usuário informar o número do pedido de compras em questão e a rotina irá' )
	AAdd( aSay, 'analisar em qual passo está parado o processo. Caso o processo esteja parado na Capa' )
	AAdd( aSay, 'de Despesa a rotina irá reenviar o workflow e logo que aprovada o retorno irá enviar' )
	AAdd( aSay, 'o workflow do pedido de compras. Agora se o processo estiver parado no pedido de ' )
	AAdd( aSay, 'compras, a rotina irá reevniar o workflow do pedido de compras no passo que está ' )
	AAdd( aSay, 'parado para análise e aprovação. Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		A610Re1()
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610Re1     | Autor | Robson Gonçalves       | Data | 13.11.2015
//--------------------------------------------------------------------------
// Descr. | Parâmetro solicitado ao usuário para processamento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Re1()
	Local aPar := {}
	Local aRet := {}

	AAdd( aPar, { 1, 'Nº Pedido de Compras',Space(Len(SC7->C7_NUM)),'','','SC7','',30,.T.})
	
	If ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.F.,.F.)
		MsAguarde( {|| A610Re2( aRet[ 1 ] ) }, cCadastro ,'Avaliando o estágio do processo, aguarde...', .F. )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610RE3     | Autor | Robson Gonçalves       | Data | 13.11.2015
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento do reenvio do WF.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Re2( cNUM_PED )
	Local lPedido := .F.
	Local lCapaDesp := .F.
	Local cCR_TIPO := cTP_DOC
	Private cPedCompras := 0
	MsProcTxt('Avaliando aprovação da capa de despesa.')
	ProcessMessage()
	SCR->( dbSetOrder( 1 ) )              
	SCR->( dbSeek( xFilial( 'SCR' ) + cCR_TIPO + cNUM_PED ) )
	While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == xFilial( 'SCR' ) .AND. SCR->CR_TIPO == cCR_TIPO .AND. RTrim( SCR->CR_NUM ) == RTrim( cNUM_PED )
		If SCR->CR_STATUS == '02'
			lCapaDesp := .T.
			Exit
		Endif
		SCR->( dbSkip() )
	End
	If .NOT. lCapaDesp
		cCR_TIPO := 'PC'
		MsProcTxt('Avaliando aprovação do pedido de compras.')
		ProcessMessage()		
		SCR->( dbSetOrder( 1 ) )              
		SCR->( dbSeek( xFilial( 'SCR' ) + cCR_TIPO + cNUM_PED ) )
		While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == xFilial( 'SCR' ) .AND. SCR->CR_TIPO == cCR_TIPO .AND. RTrim( SCR->CR_NUM ) == RTrim( cNUM_PED )
			If SCR->CR_STATUS == '02'
				lPedido := .T.
				Exit
			Endif
			SCR->( dbSkip() )
		End
	Endif
	If lCapaDesp
		MsProcTxt('Reenviando o workflow da capa de despesa.')
		ProcessMessage()	
		U_A610PDF( cNUM_PED, .T. )
		MsgInfo('Reenviado o workflow a partir da aprovação da capa de despesas.', cCadastro)
	Elseif lPedido
		MsProcTxt('Reenviando o workflow do pedido de compras.')
		ProcessMessage()	
		cPedCompras := cNUM_PED
		U_A610WFPC()
		MsgInfo('Reenviado o workflow a partir da aprovação do pedido de compras.', cCadastro)
	Else
		MsgAlert('Não foi identificado pendência de aprovação para o pedido informado.', cCadastro)
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610MCta    | Autor | Robson Gonçalves       | Data | 06.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para efetuar manutenção no campo conta contábil do PC.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610MCta()
	Local aSay := {}
	Local aButton := {}
	Local nMV610_002 := 0
	Local nOpcao := 0
	
	Private cCadastro := 'Manutenção Capa de Despesa'
	
	AAdd( aSay, 'Esta rotina permite que o usuário efetue manutenção nos campos da Capa de Despesa.' )
	AAdd( aSay, 'Somente itens do pedido de compra em aberto é que poderão receber esta manutenção.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		If .NOT. GetMv( 'MV_610_002', .T. )
			CriarSX6( 'MV_610_002', 'N', ;
			'HABILITAR A MANUTENCAO EM DEMAIS CAMPOS ALEM DOS DEFINIDOS NA VERSAO 1. 0=DESABILITADO E 1=HABILITADO - ROT CSFA610.prw','1' )
		Endif
		nMV610_002 := GetMv( 'MV_610_002', .F., 0 )
		If nMV610_002 == 0
			A610MCta1()
		Elseif nMV610_002 == 1
			A610MCta4()
		Else
			MsgAlert('Parâmetro MV_610_002 com conteúdo não programado, portanto não será possível executar a rotina.',cCadastro)
		Endif
	Endif	
Return

//--------------------------------------------------------------------------
// Rotina | A610MCta1   | Autor | Robson Gonçalves       | Data | 06.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para solicitar o número do PC e permitir a alteração.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610MCta1()
	Local nI := 0
	Local nOpc := 0
	
	Local oDlg
	
	Local cValid := ''
	
	Local aPar := {}
	Local aRet := {}
	Local aCpos := {}
	Local aCOLS := {}
	Local aHeader := {}
	Local aAlter := {}
	Local aButtons := {}
	
	Private o610Gride
	
	aAlter := { 'C7_CONTA' }
	aCpos := { 'C7_ITEM', 'C7_PRODUTO', 'C7_CONTA', 'CT1_DESC01' }

	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCpos )
		SX3->( dbSeek( aCpos[ nI ] ) )
		SX3->( AAdd( aHeader, { RTrim( X3_TITULO ), RTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT } ) )
		
		If RTrim( SX3->X3_CAMPO ) == 'C7_CONTA'
			If .NOT. Empty( aHeader[ nI, 6 ] )
				cValid := ' .AND. '
			Endif
			cValid := cValid + 'U_A610DCta( @o610Gride )'
			aHeader[ nI, 6 ] := RTrim( aHeader[ nI, 6 ] ) + cValid 
		Endif
	Next nI
	
	SC7->( dbSetOrder( 1 ) )
	
	AAdd( aPar, { 1, 'Nº Pedido de compra', Space( Len( SC7->C7_NUM ) ), '', '', 'SC7', '', 30, .T. } )

	While .T.
		If ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.F.,.F.)
			SC7->( dbSeek( xFilial( 'SC7' ) + aRet[ 1 ] ) )
			While SC7->( .NOT. EOF() ) .AND. SC7->C7_FILIAL == xFilial( 'SC7' ) .AND. SC7->C7_NUM == aRet[ 1 ]
				If ( SC7->C7_QUJE == 0 .AND. SC7->C7_QTDACLA == 0 ) .OR. ( SC7->C7_QUJE <> 0 .AND. SC7->C7_QUJE < SC7->C7_QUANT )
					AAdd( aCOLS, Array( Len( aCpos )+1 ) )
					nElem := Len( aCOLS )
					aCOLS[ nElem, 1 ] := SC7->C7_ITEM
					aCOLS[ nElem, 2 ] := SC7->C7_PRODUTO
					aCOLS[ nElem, 3 ] := SC7->C7_CONTA
					aCOLS[ nElem, 4 ] := CT1->( Posicione( 'CT1', 1, xFilial( 'CT1' ) + SC7->C7_CONTA, 'CT1_DESC01' ) )
					aCOLS[ nElem, 5 ] := .F.
				Endif
				SC7->( dbSkip() )
			End
			
			If Len( aCOLS ) > 0
				SetKey( VK_F5, {|| A610MCta3( o610Gride:aCOLS, @o610Gride ), o610Gride:Refresh() } )
				AAdd( aButtons, { 'RELOAD.PNG',{|| A610MCta3( o610Gride:aCOLS, o610Gride ), o610Gride:Refresh() }, 'Replicar a conta para todos os itens - <F5>', 'Replicar <F5>'})
				DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 237,600 PIXEL
				o610Gride := MsNewGetDados():New(1,1,1000,1000,GD_UPDATE,,,,aAlter,,Len(aCOLS),,,,oDlg,aHeader,aCOLS)
				o610Gride:lDelete := .F.
				o610Gride:oBrowse:bHeaderClick := {|| NIL }
				o610Gride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
				ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| Iif(MsgYesNo('Confirma a manutenção?',cCadastro),(oDlg:End(),nOpc:=1),NIL) }, {|| oDlg:End() },,aButtons)
				If nOpc == 1
					FWMsgRun( , {|| A610MCta2( aRet[ 1 ], o610Gride:aCOLS ) }, ,'Aguarde, gravando os dados...' )
				Endif
			Else
				MsgAlert( 'Não localizado o pedido de compras informado.', cCadastro )
			Endif
		Else
			If MsgYesNo( 'Quer realmente abandonar a rotina?', cCadastro )
				Exit
			Endif
		Endif
		aRet[ 1 ] := Space( Len( SC7->C7_NUM ) )
		aCOLS := {}
		nElem := 0
		nOpc := 0
	End
	SetKey( VK_F5, NIL )
Return

//--------------------------------------------------------------------------
// Rotina | A610DCta    | Autor | Robson Gonçalves       | Data | 12.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para retornar a descrição da conta 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610DCta( oGride )
	oGride:aCOLS[ oGride:nAt, AScan( oGride:aHeader, {|e| e[ 2 ] == RTrim( 'CT1_DESC01' ) } ) ] := CT1->( Posicione( 'CT1', 1, xFilial( 'CT1' ) + M->C7_CONTA, 'CT1_DESC01' ) )
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | A610MCta2   | Autor | Robson Gonçalves       | Data | 06.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina de gravação da alteração.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610MCta2( cPedido, aCOLS )
	Local nI := 0
	For nI := 1 To Len( aCOLS )
		If SC7->( dbSeek( xFilial( 'SC7' ) + cPedido + aCOLS[ nI, 1 ] ) )
			If SC7->C7_CONTA <> aCOLS[ nI, 3 ]
				SC7->( RecLock( 'SC7', .F. ) )
				SC7->C7_CONTA := aCOLS[ nI, 3 ]
				SC7->( MsUnLock() )
			Endif
		Endif
	Next nI
Return

//--------------------------------------------------------------------------
// Rotina | A610MCta3   | Autor | Robson Gonçalves       | Data | 06.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para facilitar a digitação do usuário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610MCta3( aCOLS )
	Local nI := ''
	Local aPar := {}
	Local aRet := {}
	
	AAdd( aPar, { 1, 'Conta Contábil', Space( Len( SC7->C7_CONTA ) ), '', '', 'CT1', '', 60, .T. } )
	
	If ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.F.,.F.)	
		For nI := 1 To Len( aCOLS )
			aCOLS[ nI, 3 ] := aRet[ 1 ] 
		Next nI
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610MCta4   | Autor | Robson Gonçalves       | Data | 19/05/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para efetuar manutenção nos campos da Capa de Despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610MCta4()
	Local aCpoEnch := {}
	Local aCpoGetD := {}
	Local aPar :={}
	Local aRet := {}
	
	Local bCampo   := {|nField| FieldName( nField ) }
	
	Local cSeek := ''
	Local cWhile := ''
		
	Local lEnchBar := .T.

	Local nC_LinIni := 0
	Local nC_ColIni := 0
	Local nC_LinEnd := 0
	Local nC_ColEnd := 0

	Local nC7_RECNO := 0
	
	Local nG_LinIni := 0
	Local nG_ColIni := 0
	Local nG_LinEnd := 0
	Local nG_ColEnd := 0

	Local nHoriz := 100
	Local nOpcA := 0
	Local nVertCabec := 40
	Local nVertGride := 60
	Local nI := 0

	Local oSize 
	Local oDlg 
	Local oMsMGet
	
	Private aCOLS := {}
	Private aHeader := {}
	Private oGride

	AAdd( aPar, { 1, 'Nº Pedido de compra', Space( Len( SC7->C7_NUM ) ), '', '', 'SC7', '', 30, .T. } )

	If .NOT. ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.F.,.F.)
		Return
	Endif
	
	oSize := FWDefSize():New( lEnchBar )
	 
	oSize:AddObject( "CABEC", nHoriz, nVertCabec, .T., .T. )
	oSize:AddObject( "GRIDE", nHoriz, nVertGride, .T., .T. )
	 
	oSize:lProp := .T.
	oSize:aMargins := { 3, 3, 3, 3 }
	oSize:Process()
	
	nC_LinIni := oSize:GetDimension("CABEC","LININI")
	nC_ColIni := oSize:GetDimension("CABEC","COLINI")
	nC_LinEnd := oSize:GetDimension("CABEC","LINEND")
	nC_ColEnd := oSize:GetDimension("CABEC","COLEND")

	nG_LinIni := oSize:GetDimension("GRIDE","LININI")
	nG_ColIni := oSize:GetDimension("GRIDE","COLINI")
	nG_LinEnd := oSize:GetDimension("GRIDE","LINEND")
	nG_ColEnd := oSize:GetDimension("GRIDE","COLEND")
	
	aCpoEnch := { 'NOUSER', 'C7_XREFERE', 'C7_FORMPG', 'C7_XVENCTO', 'C7_DOCFIS', 'C7_DDORC' }
	
	aCpoGetD := { 'C7_ITEM', 'C7_CONTA', 'C7_ITEMCTA', 'C7_CLVL' }
	
	SC7->( dbSeek( xFilial( 'SC7' ) + aRet[ 1 ] ) )	
	nC7_RECNO := SC7->( RecNo() )
	
	RegToMemory( 'SC7', .F., .F. )

 	cSeek  := xFilial( 'SC7' ) + aRet[ 1 ]
 	cWhile := 'SC7->C7_FILIAL + SC7->C7_NUM'

	FillGetDados(	4 , 'SC7', 1, cSeek,; 
					{||&(cWhile)}, /*{|| bCond,bAct1,bAct2}*/, /*aNoFields*/,; 
			   		aCpoGetD, /*lOnlyYes*/,/* cQuery*/, /*bMontAcols*/, .F.,; 
					/*aHeaderAux*/, /*aColsAux*/,/*bAfterCols*/ , /*bBeforeCols*/,;
					/*bAfterHeader*/, /*cAliasQry*/)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd ;
		FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oMsMGet := MsMGet():New('SC7',SC7->(RecNo()),4,,,,aCpoEnch,{nC_LinIni,nC_ColIni,nC_LinEnd,nC_ColEnd},,,,,,oDlg,,,,,,,,,,,)
		
		oGride := MsNewGetDados():New(nG_LinIni,nG_ColIni,nG_LinEnd,nG_ColEnd,GD_UPDATE,,,,,,Len(aCOLS),,,,oDlg,aHeader,aCOLS)
		
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| Iif(oGride:TudoOK(),Iif(MsgYesNo('Confirma a operação?',cCadastro),(nOpcA:=1,oDlg:End()),NIL),NIL) },{||oDlg:End()})
	
	If nOpcA==1
		For nI := 1 To Len( oGride:aCOLS )
			SC7->( dbSeek( xFilial( 'SC7' ) + aRet[ 1 ] + oGride:aCOLS[ nI, GdFieldPos('C7_ITEM') ] ) )
			SC7->( RecLock( 'SC7', .F. ) )
			SC7->C7_XREFERE := M->C7_XREFERE
			SC7->C7_FORMPG  := M->C7_FORMPG
			SC7->C7_XVENCTO := M->C7_XVENCTO
			SC7->C7_DOCFIS  := M->C7_DOCFIS
			SC7->C7_DDORC   := M->C7_DDORC
			SC7->C7_CONTA   := oGride:aCOLS[ nI, GdFieldPos('C7_CONTA') ]
			SC7->C7_ITEMCTA := oGride:aCOLS[ nI, GdFieldPos('C7_ITEMCTA') ]
			SC7->C7_CLVL    := oGride:aCOLS[ nI, GdFieldPos('C7_CLVL') ]
			SC7->( MsUnLock() )
		Next nI
		MsgInfo( 'Processo realizado com sucesso.', cCadastro )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610DelPC   | Autor | Robson Gonçalves       | Data | 12.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para avisar os usuários de plan. financ. e compras que 
//        | o pedido de compras foi excluído.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610DelPC( cC7_NUM, lEnvMail )
	Local cHTML := ''
	Local cEMail := ''
	Local cCR_NUM := PadR( cC7_NUM, Len( SCR->CR_NUM ), ' ' )
	Local cMV_610PFIN := 'MV_610PFIN' // GRUPO DE APROV. DO PLANEJ. FINANC.
	Local cMV_710SUPR := 'MV_710SUPR' // EMAIL (ALIAS) DA AREA DE COMPRAS.
	Local aArea := GetArea()
	
	DEFAULT lEnvMail := .T.
	
	SCR->( dbSetOrder( 1 ) )
	SCR->( dbSeek( xFilial( 'SCR' ) + cTP_DOC + cCR_NUM ) )
	While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == xFilial( 'SCR' ) .AND. SCR->CR_TIPO == cTP_DOC .AND. SCR->CR_NUM == cCR_NUM
		SCR->( RecLock( 'SCR', .F. ) )
		SCR->( dbDelete() )
		SCR->( MsUnLock() )
		SCR->( dbSkip() )
	End
	
	If lEnvMail 
		cMV_610PFIN := GetMv( cMV_610PFIN, .F. )
		cMV_710SUPR := GetMv( cMV_710SUPR, .F. )
			
		cHTML += '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
		cHTML += '<html>'
		cHTML += '	<head>'
		cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
		cHTML += '		<title>Exclus&atilde;o do PC</title>'
		cHTML += '	</head>'
		cHTML += '	<body>'
		cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
		cHTML += '			<tbody>'
		cHTML += '				<tr>'
		cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle">'
		cHTML += '						<em><span style="font-size:20px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>Exclus&atilde;o do PC</strong></font></span><br />'
		cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em>'
		cHTML += '						<p>'
		cHTML += '							&nbsp;</p>'
		cHTML += '					</td>'
		cHTML += '					<td align="right" width="210">'
		cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
		cHTML += '						&nbsp;</td>'
		cHTML += '				</tr>'
		cHTML += '				<tr>'
		cHTML += '					<td bgcolor="#F4811D" colspan="2" height="4" width="0">'
		cHTML += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
		cHTML += '				</tr>'
		cHTML += '				<tr>'
		cHTML += '					<td colspan="2" style="padding:5px;" width="0">'
		cHTML += '						<p>'
		cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Prezado(s),</font></span></span></p>'
		cHTML += '						<p>'
		cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">O pedido de compras n&ordm;&nbsp;<strong>'+xFilial('SC7')+'-'+cA120Num+'</strong> foi exclu&iacute;do.</font></span></span></p>'
		cHTML += '					</td>'
		cHTML += '				</tr>'
		cHTML += '				<tr>'
		cHTML += '					<td bgcolor="#02519B" colspan="2" height="2" width="0">'
		cHTML += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
		cHTML += '				</tr>'
		cHTML += '				<tr>'
		cHTML += '					<td colspan="2" style="padding:5px" width="0">'
		cHTML += '						<p align="left">'
		cHTML += '							<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
		cHTML += '					</td>'
		cHTML += '				</tr>'
		cHTML += '			</tbody>'
		cHTML += '		</table>'
		cHTML += '		<p>'
		cHTML += '			&nbsp;</p>'
		cHTML += '	</body>'
		cHTML += '</html>'
		
		//---------------------------------------------------------------------------------------------------
		// A610UsrPF - Buscar os e-mails dos usuários do planejamento financeiro e mais o e-mail do compras.
		If l610OnMsg
			cEMail := A610UsrPF( cMV_610PFIN ) + ';'
		Endif
		 
		cEMail += cMV_710SUPR
		
		If .NOT. Empty( cEMail )
			FSSendMail( cEMail, 'Exclusão do PC nº '+xFilial('SC7') + '-' + cA120Num, cHTML, /*cAnexo*/ )
		Endif
	Endif
	RestArea( aArea )
Return

//--------------------------------------------------------------------------
// Rotina | A610VFun    | Autor | Robson Gonçalves       | Data | 12.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para analisar o vínculo funcional do aprovador.
//        | Se necessário será modificado o aprovador para seu superior.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610VFun()
	Local aArea := {}
	
	Local cAK_VINCULO := ''
	Local cAprov := ''
	Local cBKP_SITFOLH := ''
	Local cCR_USERORI := SCR->CR_USER
	Local cCR_APRORI  := SCR->CR_APROV
	Local cCR_USER := SCR->CR_USER
	Local cRA_SITFOLH := ''
	Local cSend := ''
	Local cUpdate := ''
	
	Local lTrocou := .F.
	Local lAK_MSBLQL := .F.
	Local lAfastPeriod := .F.
	Local lSuperior := .F.
	
	aArea := { SCR->( GetArea() ), SAL->( GetArea() ), SAK->( GetArea() ), SRA->( GetArea() ) }

	cAprov := SCR->CR_APROV
	
	SAK->( dbSetOrder( 1 ) )
	While .T.
		SAK->( dbSeek( xFilial( 'SAK' ) + cAprov ) )
		lAK_MSBLQL := ( SAK->AK_MSBLQL == '1' ) //1=SIM; 2=NÃO
		
		If Empty( SAK->AK_VINCULO )
			PswOrder( 1 )
			PswSeek( cCR_USER )
			cAK_VINCULO := PswRet()[ 1, 22 ]  // 10 digitos, sendo 1122333333 => 11-empresa; 22-filial; 333333-matricula.
			cAK_VINCULO := SubStr( cAK_VINCULO, 3 ) // Retirar o número da empresa.
			
			If Len( cAK_VINCULO ) < 8
				cAK_VINCULO := ''
			Endif
			
			If .NOT. Empty( cAK_VINCULO )
				//--------------------------
				// Tentar travar o registro.
				If SAK->( MsRLock( RecNo() ) )
					SAK->( RecLock( 'SAK', .F. ) )
					SAK->AK_VINCULO := cAK_VINCULO
					SAK->( MsUnLock() )
				Endif
			Endif
		Else
			cAK_VINCULO := SAK->AK_VINCULO // Contém a Filial + Matrícula.
		Endif
		
		If Empty( cAK_VINCULO )
			If cSend <> ''
				cSend := cSend + '<br>'
			Endif
			cSend += 'Não foi possível localizar vínculo funcional para o aprovador ' + SAK->AK_COD + '-' + RTrim( SAK->AK_NOME )
			Exit
		Endif
		
		cRA_SITFOLH := SRA->( GetAdvFVal( 'SRA', 'RA_SITFOLH', cAK_VINCULO, 1 ) )
		
		lAfastPeriod := A610SR8( cAK_VINCULO )

		/* 
		---------------------------------------------------------
		teste de mesa e prova de conceito da lógica de avaliação.
		---------------------------------------------------------
		está F?	está no período?	está bloquado?	o que fazer?
		---------------------------------------------------------
		sim		sim					sim				* ir para superior
		sim		sim					não				* ir para superior
		sim		não					sim				* ir para superior
		sim		não					não				continuar
		não		não					não				continuar
		não		não					sim				* ir para superior
		---------------------------------------------------------
		(    (.NOT. Empty( cRA_SITFOLH ) .AND.       lAfastPeriod .AND.       lAK_MSBLQL)      ;
		.OR. (.NOT. Empty( cRA_SITFOLH ) .AND.       lAfastPeriod .AND. .NOT. lAK_MSBLQL);
		.OR. (.NOT. Empty( cRA_SITFOLH ) .AND. .NOT. lAfastPeriod .AND.       lAK_MSBLQL);
		.OR. (      Empty( cRA_SITFOLH ) .AND. .NOT. lAfastPeriod .AND.       lAK_MSBLQL)      )
		*/
		
		lSuperior := ( (.NOT. Empty( cRA_SITFOLH ) .AND. lAfastPeriod .AND. lAK_MSBLQL) ;
		.OR. (.NOT. Empty( cRA_SITFOLH ) .AND. lAfastPeriod .AND. .NOT. lAK_MSBLQL)		;
		.OR. (.NOT. Empty( cRA_SITFOLH ) .AND. .NOT. lAfastPeriod .AND. lAK_MSBLQL)		;
		.OR. (Empty( cRA_SITFOLH ) .AND. .NOT. lAfastPeriod .AND. lAK_MSBLQL)      		;
		.OR. ( Empty( cRA_SITFOLH ) .AND. lAfastPeriod )		   						)
		
		If lSuperior
			If Empty( SAK->AK_APROSUP )
				If cSend <> ''
					cSend := cSend + '<br>'
				Endif
				lTrocou := .F.
				cSend += 'O aprovador ' + SAK->AK_COD + '-' + RTrim( SAK->AK_NOME ) + ' está sem aprovador superior.'
				Exit
			Else
				lTrocou := .T.
				cAprov := SAK->AK_APROSUP
					
				If Empty( cBKP_SITFOLH )
					cBKP_SITFOLH := cRA_SITFOLH
				Endif
							
				If cSend <> ''
					cSend := cSend + '<br>'
				Endif
							
				cSend += 'O aprovador ' + SAK->AK_COD + '-' + RTrim( SAK->AK_NOME )+ ' não está ativo, conforme o RH, portanto vou analisar o seu superior. ' + ;
					SAK->AK_APROSUP + '-' + RTrim( SAK->( GetAdvFVal( 'SAK', 'AK_NOME', xFilial( 'SAK' ) + SAK->AK_APROSUP, 1 ) ) ) + '.'
					
				cCR_USER := SAK->( GetAdvFVal( 'SAK', 'AK_USER', xFilial( 'SAK' ) + cAprov, 1 ) )
			Endif
		Else
			Exit
		Endif
	End
	
	If lTrocou
		SCR->( RecLock( 'SCR', .F. ) )
		SCR->CR_OBS     := "AUSENTE-ALT.SUPERIOR "+cAprov
		SCR->CR_USERORI := cCR_USERORI
		SCR->CR_APRORI  := cCR_APRORI
		SCR->CR_USER    := SAK->AK_USER
		SCR->CR_APROV   := SAK->AK_COD
		SCR->( MsUnLock() )
			
		If cSend <> ''
			cSend := cSend + '<br>'
		Endif
			
		cSend += 'O aprovador: '+cCR_APRORI+;
			' foi alterador para o aprovador: '+SAK->AK_COD+;
			' conforme status: '+SX5->( Tabela( '31', cBKP_SITFOLH, .F. ) ) +;
			' do vínculo funcional e indicação superior no cadastro de aprovadores.'
	Endif
		
	If .NOT. Empty( cSend )
		A610VFunEMail( cSend )
	Endif
	
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return

//--------------------------------------------------------------------------
// Rotina | A610SR8       | Autor | Robson Gonçalves     | Data | 04.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar na tabela de controle de ausências a 
//        | situação do superior.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610SR8( cAK_VINCULO )
	Local cSQL := ''
	Local cTRB := ''
	Local cR8_FILIAL := ''
	Local cR8_MAT := ''
	Local lAfastado := .F.
	Local dDataHoje := MsDate()
	Local cMV610_016 := 'MV_610_016'

	If .NOT. GetMv( cMV610_016, .T. )
		CriarSX6( cMV610_016, 'N', 'HABILITAR VERIFICACAO DE AFASTAMENTO NA GERAÇÃO DE ALÇADA (PEDIDO). 0=DESABILITADO E 1=HABILITADO - ROTINA CSFA610.prw', '0' )
	Endif
	
	IF GetMv( cMV610_016, .F. ) == 0
		//--O retorno deve ser falso para o sistema permitir gerar a alçada mesmo que possui afastamento;
		Return( .F. )
	EndIF

	cR8_FILIAL := SubStr( cAK_VINCULO, 1, 2 )
	cR8_MAT    := SubStr( cAK_VINCULO, 3, 6 )
	
	cSQL := "SELECT COUNT(*) AS SR8RECNO "
	cSQL += "FROM "+RetSqlName("SR8")+" SR8 "
	cSQL += "WHERE R8_FILIAL = "+ValToSql( cR8_FILIAL )+" "
	cSQL += "      AND R8_MAT = "+ValToSql( cR8_MAT )+" "
	cSQL += "      AND D_E_L_E_T_ = ' ' "
	cSQL += "      AND ( "+ValToSql( dDataHoje )+" >= R8_DATAINI "
	cSQL += "      AND "+ValToSql( dDataHoje )+" <= R8_DATAFIM ) "
	cSQL += "       OR ( R8_DATAINI >= "+ValToSql( dDataHoje )+" "
	cSQL += "          AND R8_DATAFIM <= "+ValToSql( dDataHoje )+" ) "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTRB,.F.,.T.)
	lAfastado := ((cTRB)->( SR8RECNO ) > 0 )
	(cTRB)->( dbCloseArea() )
Return( lAfastado )

//--------------------------------------------------------------------------
// Rotina | A610VFunEMail | Autor | Robson Gonçalves     | Data | 21.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para enviar e-mail conforme vinculo do RH e aprovador 
//        | superior.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610VFunEMail( cSend )
	Local cHTML := ''
	Local cMV_610PFIN := GetMv( 'MV_610PFIN', .F. )
	Local cEMail := A610UsrPF( cMV_610PFIN )
	
	cHTML := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
	cHTML += '<html>'
	cHTML += '	<head>'
	cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
	cHTML += '		<title>Al&ccedil;ada do pedido de compra</title>'
	cHTML += '	</head>'
	cHTML += '	<body>'
	cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
	cHTML += '			<tbody>'
	cHTML += '				<tr>'
	cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle">'
	cHTML += '						<em><span style="font-size:20px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>Al&ccedil;ada do pedido de compra</strong></font></span><br />'
	cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em>'
	cHTML += '						<p>'
	cHTML += '							&nbsp;</p>'
	cHTML += '					</td>'
	cHTML += '					<td align="right" width="210">'
	cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
	cHTML += '						&nbsp;</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#F4811D" colspan="2" height="4" width="0">'
	cHTML += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding:5px;" width="0">'
	cHTML += '						<p>'
	cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Prezado(s),</font></span></span></p>'
	cHTML += '						<p>'
	cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">'+cSend+'</font></span></span></p>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td bgcolor="#02519B" colspan="2" height="2" width="0">'
	cHTML += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td colspan="2" style="padding:5px" width="0">'
	cHTML += '						<p align="left">'
	cHTML += '							<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '			</tbody>'
	cHTML += '		</table>'
	cHTML += '		<p>'
	cHTML += '			&nbsp;</p>'
	cHTML += '	</body>'
	cHTML += '</html>'
	
	If l610OnMsg .AND. .NOT. Empty( cEMail )
		FSSendMail( cEMail, 'Substituição de aprov. na alçada do PC nº ' + SCR->CR_FILIAL + '-' + RTrim( SCR->CR_NUM ), cHTML, /*cAnexo*/ )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610Rateio  | Autor | Robson Gonçalves       | Data | 20.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para calcular o valor ou o percentual do rateio.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Rateio( cRATEIO )
	Local cFIELD := ReadVar()
	Local lPERC := .F.
	Local nDECIMAL := 0, nRETURN := 0, nTOT_IT := 0, nFATOR := 0
	//------------------------------------------------------------
	// Rateio do pedido de compras.
	If cRATEIO == 'SCH'
		lPERC    := ( cFIELD == 'M->CH_PERC' )
		nTOT_IT  := aOrigAcols[ nOrigN, GdFieldPos( 'C7_TOTAL', aOrigHeader ) ]
		nDECIMAL := SX3->( Posicione( 'SX3', 2, Iif( lPERC, 'CH_VLRAT', 'CH_PERC' ), 'X3_DECIMAL' ) )
		nFATOR   := Iif( lPERC, M->CH_PERC, M->CH_VLRAT )
	//------------------------------------------------------------
	// Rateio da nota fiscal de entrada.
	Elseif cRATEIO == 'SDE'
		lPERC    := ( cFIELD == 'M->DE_PERC' )
		nTOT_IT  := aCOLSD1[ oGetDados:oBrowse:nAt, GdFieldPos( 'D1_TOTAL', aHeadD1 ) ]
		nDECIMAL := SX3->( Posicione( 'SX3', 2, Iif( lPERC, 'DE_VLRAT', 'DE_PERC' ), 'X3_DECIMAL' ) )
		nFATOR   := Iif( lPERC, M->DE_PERC, M->DE_VLRAT)
	//------------------------------------------------------------
	// Rateio na medição do contrato.
	Elseif cRATEIO == 'CNZ'
		lPERC    := ( cFIELD == 'M->CNZ_PERC' )
		nTOT_IT  := oGetDados:aCOLS[ oGetDados:nAt, GdFieldPos( 'CNE_VLTOT', oGetDados:aHeader ) ]
		nDECIMAL := SX3->( Posicione( 'SX3', 2, Iif( lPERC, 'CNZ_VLRAT', 'CNZ_PERC' ), 'X3_DECIMAL' ) )
		nFATOR   := Iif( lPERC, M->CNZ_PERC, M->CNZ_VLRAT )
	Endif
	//------------------------------------------------------------
	// Efetuar o cálculo conforme a coleta dos dados.
	nRETURN := Iif( lPERC, Round( ( nTOT_IT * nFATOR ) / 100, nDECIMAL ), Round( ( nFATOR / nTOT_IT ) * 100, nDECIMAL ) )
Return( nRETURN )

//--------------------------------------------------------------------------
// Rotina | A610RRPC    | Autor | Robson Gonçalves       | Data | 10.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para alimentar os campos das entidades contábeis na 
//        | interface do rareio do pedido de compras.
//        | [R]éplica do [R]ateio [P]edido de [C]ompras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610RRPC( cField )
	Local nP := 0
	Local cReturn := ''
	Local aConsist := {}
	If IsBlind()
		AAdd( aConsist, { 'CC'        , 'SCH->CH_CC'      } )
		AAdd( aConsist, { 'DESCC'     , 'SCH->CH_DESCTT'  } )
		AAdd( aConsist, { 'CONTA'     , 'SCH->CH_CONTA'   } )
		AAdd( aConsist, { 'DESCONTA'  , 'SCH->CH_DESCT1'  } )
		AAdd( aConsist, { 'ITEMCTA'   , 'SCH->CH_ITEMCTA' } )
		AAdd( aConsist, { 'DESITEMCTA', 'SCH->CH_DESCTD'  } )
		AAdd( aConsist, { 'CLVL'      , 'SCH->CH_CLVL'    } )
		AAdd( aConsist, { 'DESCLVL'   , 'SCH->CH_DESCTH'  } )
		nP := AScan( aConsist, {|e| e[ 1 ] == cField } )
		cReturn := Space( Len( &( aConsist[ nP, 2 ] ) ) )
	Else
		If     cField == 'CC'        ; cReturn := aOrigAcols[ nOrigN, GdFieldPos( 'C7_CC', aOrigHeader ) ]
		Elseif cField == 'DESCC'     ; cReturn := CTT->( Posicione( 'CTT', 1, xFilial( 'CTT' ) + aOrigAcols[ nOrigN, GdFieldPos( 'C7_CC', aOrigHeader ) ], 'CTT_DESC01' ) )
		
		Elseif cField == 'CONTA'     ; cReturn := aOrigAcols[ nOrigN, GdFieldPos( 'C7_CONTA', aOrigHeader ) ]
		Elseif cField == 'DESCONTA'  ; cReturn := CT1->( Posicione( 'CT1', 1, xFilial( 'CT1' ) + aOrigAcols[ nOrigN, GdFieldPos( 'C7_CONTA', aOrigHeader ) ], 'CT1_DESC01' ) )
		
		Elseif cField == 'ITEMCTA'   ; cReturn := aOrigAcols[ nOrigN, GdFieldPos( 'C7_ITEMCTA', aOrigHeader ) ]
		Elseif cField == 'DESITEMCTA'; cReturn := CTD->( Posicione( 'CTD', 1, xFilial( 'CTD' ) + aOrigAcols[ nOrigN, GdFieldPos( 'C7_ITEMCTA', aOrigHeader ) ], 'CTD_DESC01' ) )
		
		Elseif cField == 'CLVL'      ; cReturn := aOrigAcols[ nOrigN, GdFieldPos( 'C7_CLVL', aOrigHeader ) ]
		Elseif cField == 'DESCLVL'   ; cReturn := CTH->( Posicione( 'CTH', 1, xFilial( 'CTH' ) + aOrigAcols[ nOrigN, GdFieldPos( 'C7_CLVL', aOrigHeader ) ], 'CTH_DESC01' ) )
		Endif
	Endif
Return( cReturn )

//--------------------------------------------------------------------------
// Rotina | A610RRME    | Autor | Robson Gonçalves       | Data | 22.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para alimentar os campos das entidades contábeis na 
//        | interface do rareio da medição
//        | [R]éplica do [R]ateio da [ME]dição.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610RRME( cField )
	Local nP := 0
	Local cReturn := ''
	Local cCCUSTO := ''
	Local cCONTAB := ''
	Local cITEMCT := ''
	Local cCLVL   := ''
	Local cFunc   := FunName()
	Local aConsist := {}
	Local oObjeto
	//-----------------------------------------------------------------------------
	// Em caso de acionamento via MsExecAuto, apenas contemplar o campo como ele é.
	If IsBlind()
		AAdd( aConsist, { 'CC'        , 'CNZ->CNZ_CC'     } )
		AAdd( aConsist, { 'DESCC'     , 'CNZ->CNZ_DESCTT' } )
		AAdd( aConsist, { 'CONTA'     , 'CNZ->CNZ_CONTA'  } )
		AAdd( aConsist, { 'DESCONTA'  , 'CNZ->CNZ_DESCT1' } )
		AAdd( aConsist, { 'ITEMCTA'   , 'CNZ->CNZ_ITEMCT' } )
		AAdd( aConsist, { 'DESITEMCTA', 'CNZ->CNZ_DESCTD' } )
		AAdd( aConsist, { 'CLVL'      , 'CNZ->CNZ_CLVL'   } )
		AAdd( aConsist, { 'DESCLVL'   , 'CNZ->CNZ_DESCTH' } )
		nP := AScan( aConsist, {|e| e[ 1 ] == cField } )
		cReturn := Space( Len( &( aConsist[ nP, 2 ] ) ) )
	Else
		//---------------------------
		// Se uma das rotinas abaixo.
		If cFunc $ 'CNTA200|CNTA120|MATA120'
			oObjeto := oGetDados
			cCCUSTO := Iif( cFunc == 'CNTA200', 'CNB_CC'    , 'CNE_CC' )
			cCONTAB := Iif( cFunc == 'CNTA200', 'CNB_CONTA' , 'CNE_CONTA' )
			cITEMCT := Iif( cFunc == 'CNTA200', 'CNB_ITEMCT', 'CNE_ITEMCT' )
			cCLVL   := Iif( cFunc == 'CNTA200', 'CNB_CLVL'  , 'CNE_CLVL' )
		Endif
		//---------------------------------------------------------------------------------------
		// Havendo conteúdo no objeto, buscar o código da entidade e buscar a descrição da mesma.
		If ValType( oObjeto ) <> "U"
			If     cField == 'CC'         ; cReturn := oObjeto:aCOLS[ oObjeto:nAt, GdFieldPos( cCCUSTO, oObjeto:aHeader ) ]
			Elseif cField == 'DESCC'      ; cReturn := CTT->( Posicione( 'CTT', 1, xFilial( 'CTT' ) + oObjeto:aCOLS[ oObjeto:nAt, GdFieldPos( cCCUSTO, oObjeto:aHeader ) ], 'CTT_DESC01' ) )
			
			Elseif cField == 'CONTA'      ; cReturn := oObjeto:aCOLS[ oObjeto:nAt, GdFieldPos( cCONTAB, oObjeto:aHeader ) ]
			Elseif cField == 'DESCONTA'   ; cReturn := CT1->( Posicione( 'CT1', 1, xFilial( 'CT1' ) + oObjeto:aCOLS[ oObjeto:nAt, GdFieldPos( cCONTAB, oObjeto:aHeader ) ], 'CT1_DESC01' ) )
			
			Elseif cField == 'ITEMCTA'    ; cReturn := oObjeto:aCOLS[ oObjeto:nAt, GdFieldPos( cITEMCT, oObjeto:aHeader ) ]
			Elseif cField == 'DESITEMCTA' ; cReturn := CTD->( Posicione( 'CTD', 1, xFilial( 'CTD' ) + oObjeto:aCOLS[ oObjeto:nAt, GdFieldPos( cITEMCT, oObjeto:aHeader ) ], 'CTD_DESC01' ) )
			
			Elseif cField == 'CLVL'       ; cReturn := oObjeto:aCOLS[ oObjeto:nAt, GdFieldPos( cCLVL, oObjeto:aHeader ) ]
			Elseif cField == 'DESCLVL'    ; cReturn := CTH->( Posicione( 'CTH', 1, xFilial( 'CTH' ) + oObjeto:aCOLS[ oObjeto:nAt, GdFieldPos( cCLVL, oObjeto:aHeader ) ], 'CTH_DESC01' ) )
			Endif
		Endif
	Endif
Return( cReturn )

//--------------------------------------------------------------------------
// Rotina | A610IPCH    | Autor | Robson Gonçalves       | Data | 10.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina responsável por inserir as instruções nos inicializadores
//        | do campos das entidades contáb.do rateio do PC e MED (SCH/CNZ).
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610IPCH( cTabela )
	Local nI := 0
	Local aCpos := {}
	Local cAnd := ''
	Local cFunc := Iif( cTabela == 'SCH', 'U_A610RRPC', Iif( cTabela == 'CNZ', 'U_A610RRME', '' ) )
	DEFAULT cTabela := ''
	If cTabela == 'SCH'
		AAdd( aCpos, { 'CH_CC'     , cFunc+'("CC")'         } )
		AAdd( aCpos, {	'CH_DESCTT' , cFunc+'("DESCC")'      } )
		AAdd( aCpos, {	'CH_CONTA'  , cFunc+'("CONTA")'      } )
		AAdd( aCpos, {	'CH_DESCT1' , cFunc+'("DESCONTA")'   } )
		AAdd( aCpos, {	'CH_ITEMCTA', cFunc+'("ITEMCTA")'    } )
		AAdd( aCpos, {	'CH_DESCTD' , cFunc+'("DESITEMCTA")' } )
		AAdd( aCpos, {	'CH_CLVL'   , cFunc+'("CLVL")'       } )
		AAdd( aCpos, {	'CH_DESCTH' , cFunc+'("DESCLVL")'    } )
	Elseif cTabela == 'CNZ'
		AAdd( aCpos, { 'CNZ_CC'     , cFunc+'("CC")'         } )
		AAdd( aCpos, {	'CNZ_DESCTT' , cFunc+'("DESCC")'      } )
		AAdd( aCpos, {	'CNZ_CONTA'  , cFunc+'("CONTA")'      } )
		AAdd( aCpos, {	'CNZ_DESCT1' , cFunc+'("DESCONTA")'   } )
		AAdd( aCpos, {	'CNZ_ITEMCT' , cFunc+'("ITEMCTA")'    } )
		AAdd( aCpos, {	'CNZ_DESCTD' , cFunc+'("DESITEMCTA")' } )
		AAdd( aCpos, {	'CNZ_CLVL'   , cFunc+'("CLVL")'       } )
		AAdd( aCpos, {	'CNZ_DESCTH' , cFunc+'("DESCLVL")'    } )
	Endif
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCpos )
		If SX3->( dbSeek( aCpos[ nI, 1 ] ) )
			If .NOT. ( cFunc $ Upper( AllTrim( SX3->X3_RELACAO ) ) )
				If .NOT. Empty( SX3->X3_RELACAO )
					cAnd := '.AND.'
				Endif
				SX3->( RecLock( 'SX3', .F. ) )
				SX3->X3_RELACAO := cAnd + aCpos[ nI, 2 ]
				SX3->( MsUnLock() )
				cAnd := ''
			Endif
		Endif
	Next nI
Return

//--------------------------------------------------------------------------
// Rotina | A610TAlc    | Autor | Robson Gonçalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para efetuar manutenção nas alçadas, ou seja, transferir.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610TAlc()
	Local nOpc := 0
	
	Local aSay := {}
	Local aButton := {}
	Local lMV_610PALC := .F.
	Local cMV610_007 := 'MV_610_007'
	
	Private lMV610_007 := .F.
	Private __nExec := 0
	Private cUserAlc := RetCodUsr()
	Private cMV_610PALC := 'MV_610PALC'
	Private cCadastro := 'Alçada de pedido de compra'
	
	If .NOT. GetMv( cMV_610PALC, .T. )
		CriarSX6( cMV_610PALC, 'C', 'USUARIOS COM PERMISSAO PARA TRANSFERIR ALCADAS DE/PARA QUALQUER APROVADOR - ROTINA CSFA610.prw', '000301|000394|000759|001102|002420' )
	Endif
	
	cMV_610PALC := GetMv( cMV_610PALC, .F. )
	
	lMV_610PALC := ( cUserAlc $ cMV_610PALC )
	
	If lMV_610PALC
		SetKey( VK_F12 , {|| A610AudTrf() } )
	Endif
	
	If .NOT. GetMv( cMV610_007, .T. )
		CriarSX6( cMV610_007, 'N', 'HABILITAR TRANSFERENCIA DE ALCADA DO APROVADOR PARA SOMENTE PARA O SUPERIOR. 0=DESABILITADO E 1=HABILITADO - ROTINA CSFA610.prw', '0' )
	Endif

	lMV610_007 := ( GetMv( cMV610_007, .F. ) == 1 )

	AAdd( aSay, 'Rotina para transferir a alçada do pedido de compra.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	
	If lMV_610PALC
		AAdd( aSay, 'Você possui permissão para transferir a alçada de qualquer aprovador. MV_610PALC' )
	Else
		AAdd( aSay, 'Você somente pode transferir sua alçada para qualquer outro aprovador.' )
	Endif
	
	If lMV610_007
		AAdd( aSay, 'Habilitado o parâmetro de transferência de alçada somente para o superior do aprovador. MV_610_007' )
	Else
		AAdd( aSay, '' )
	Endif
	
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpc == 1
		A610TAPar()
	Endif
	
	SetKey( VK_F12 , {|| NIL } )
Return

//--------------------------------------------------------------------------
// Rotina | A610TAPar   | Autor | Robson Gonçalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para solicitar parâmetros ao usuário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610TAPar()
	Local aPar := {}
	Local aRet := {}
	
	AAdd( aPar, { 1, 'Qual aprovador'  ,Space(Len(SAK->AK_COD)),'@!','U_A610VlAK( mv_par01 )','SAK','',50,.T.})
	AAdd( aPar, { 1, 'Nº Pedido de'    ,Space(Len(SC7->C7_NUM)),'','','SC7','',50,.F.})
	AAdd( aPar, { 1, 'Nº Pedido até'   ,Space(Len(SC7->C7_NUM)),'','(MV_PAR03>=MV_PAR02)','SC7','',50,.T.})
	AAdd( aPar, { 1, 'Informe a filial',xFilial('SC7'), '', '', 'SM0_01', '', 50, .T. } )
	While .T.
		If ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.F.,.F.)
			A610TAProc( aRet[ 1 ], aRet[ 2 ], aRet[ 3 ], aRet[ 4 ] )
		Else
			Exit
		Endif
		aRet[ 1 ] := Space( Len( SAK->AK_COD ) )
		aRet[ 2 ] := Space( Len( SC7->C7_NUM ) )
		aRet[ 3 ] := Space( Len( SC7->C7_NUM ) )
		aRet[ 4 ] := Space( Len( SC7->C7_FILIAL ) )
	End
Return

//--------------------------------------------------------------------------
// Rotina | A610VlAK    | Autor | Robson Gonçalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para validar o usuário restrito.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610VlAK( cUsuario )
	Local lRet := .F.
	If cUserAlc <> SAK->( Posicione( 'SAK', 1, xFilial( 'SAK' ) + cUsuario, 'AK_USER' ) ) .AND. ( .NOT. ( cUserAlc $ cMV_610PALC ) )
		MsgAlert( 'Você não tem permissão para efetuar manutenção em alçada de outro aprovador.', cCadastro )
	Else
		lRet := .T.
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A610TAProc  | Autor | Robson Gonçalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para processar os registros a serem transferidos.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610TAProc( cAK_COD, cC7_NUM_DE, cC7_NUM_ATE, cC7_FILIAL )
	Local oSize
	
	Local lEnchBar := .T.
	Local lContinua := .T.
	Local nHoriz := 100
	Local nArea1 := 8
	Local nArea2 := 79
	Local nArea3 := 13
	
	Local nA1_LinIni := 0
	Local nA1_ColIni := 0
	Local nA1_LinEnd := 0
	Local nA1_ColEnd := 0

	Local nA2_LinIni := 0
	Local nA2_ColIni := 0
	Local nA2_LinEnd := 0
	Local nA2_ColEnd := 0
	
	Local nA3_LinIni := 0
	Local nA3_ColIni := 0
	Local nA3_LinEnd := 0
	Local nA3_ColEnd := 0

	Local aHeader := {}
	Local aCOLS := {}
	Local aStruSCR := {}
	Local cAliasSCR := ''
	Local cQuery := ''
	Local nX := 0
	Local nY := 0
	Local cSituaca := ''
	Local cDadosAprov := ''
	
	Local oDlg
	Local oGride
	Local oFont
	
	Local cCOD_APROV := Space( Len( SAK->AK_COD ) )
	Local cNOM_APROV := Space( Len( SAK->AK_NOME ) )
	
	Local aButton := {}
	
	AAdd( aButton, { 'RELOAD', {|| FWMsgRun( , {|| A610ImpAlc( aHeader, aCOLS ) }, ,'Aguarde, processando os dados para impressão...' ) },'Imprimir','Imprimir'} )
	
	SAK->( dbSetOrder( 1 ) )
	SAK->( dbSeek( xFilial( 'SAK' ) + cAK_COD ) )
	cDadosAprov := 'Código de aprovador: ' + SAK->AK_COD + ' | Código de usuário: ' + SAK->AK_USER + ' | Nome do aprovador/usuário: ' + SAK->AK_NOME
	
	oSize := FWDefSize():New( lEnchBar )
	
	oSize:AddObject( 'AREA1', nHoriz, nArea1, .T., .T. )
	oSize:AddObject( 'AREA2', nHoriz, nArea2, .T., .T. )
	oSize:AddObject( 'AREA3', nHoriz, nArea3, .T., .T. )
	
	oSize:lProp := .T.
	oSize:aMargins := { 3, 3, 3, 3 }
	oSize:Process()
	
	nA1_LinIni := oSize:GetDimension('AREA1','LININI')
	nA1_ColIni := oSize:GetDimension('AREA1','COLINI')
	nA1_LinEnd := oSize:GetDimension('AREA1','LINEND')
	nA1_ColEnd := oSize:GetDimension('AREA1','COLEND')

	nA2_LinIni := oSize:GetDimension('AREA2','LININI')
	nA2_ColIni := oSize:GetDimension('AREA2','COLINI')
	nA2_LinEnd := oSize:GetDimension('AREA2','LINEND')
	nA2_ColEnd := oSize:GetDimension('AREA2','COLEND')
	
	nA3_LinIni := oSize:GetDimension('AREA3','LININI')
	nA3_ColIni := oSize:GetDimension('AREA3','COLINI')
	nA3_LinEnd := oSize:GetDimension('AREA3','LINEND')
	nA3_ColEnd := oSize:GetDimension('AREA3','COLEND')

	AAdd( aHeader, { '   x', 'GD_MARK' , '@BMP', 10, 0, '', '', '', '', '' } )
		
	SX3->( dbSetOrder( 1 ) )
	SX3->( MsSeek( 'SCR' ) )
	While SX3->( .NOT. EOF() ) .AND. ( SX3->X3_ARQUIVO == 'SCR' )
		If RTrim( SX3->X3_CAMPO ) $ 'CR_FILIAL|CR_NUM|CR_NIVEL|CR_OBS'
			AAdd( aHeader,{ RTrim( X3Titulo() ),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT } )
			If RTrim( SX3->X3_CAMPO ) == 'CR_NIVEL'
				AAdd( aHeader,{ 'Usuário'      ,'bCR_NOME',   '', 15,0,'','','C','','' } )
				AAdd( aHeader,{ 'Situação'     ,'bCR_SITUACA','', 20,0,'','','C','','' } )
			Endif
		Endif
		SX3->( dbSkip() )
	End
	AAdd( aHeader, { 'Nº Registro', 'GD_RECNO', '@!', 10, 0, '', '', 'N', '', 'V' } )

	aStruSCR  := SCR->( dbStruct() )
	cAliasSCR := GetNextAlias()
	
	cQuery := "SELECT SCR.*, "
	cQuery += "       SCR.R_E_C_N_O_ SCRRECNO "
	cQuery += "FROM "+RetSqlName("SCR")+" SCR "
	cQuery += "WHERE  SCR.CR_FILIAL = '"+cC7_FILIAL+"' "
	cQuery += "       AND SCR.CR_NUM >= '"+PadR( cC7_NUM_DE, Len( SCR->CR_NUM ) ) + "' "
	cQuery += "       AND SCR.CR_NUM <= '"+PadR( cC7_NUM_ATE, Len( SCR->CR_NUM ) ) + "' "
	cQuery += "       AND SCR.CR_TIPO = 'PC' "
	cQuery += "       AND SCR.CR_APROV = '"+cAK_COD+"' "
	cQuery += "       AND ( SCR.CR_STATUS = '01' "
	cQuery += "           OR SCR.CR_STATUS = '02' ) "
	cQuery += "       AND SCR.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER  BY SCR.CR_NUM "
	
	cQuery := ChangeQuery( cQuery )
	
	FWMsgRun( , {|| A610LoadCR( cQuery, aHeader, aStruSCR, cAliasSCR, @aCOLS ) }, ,'Carregando dados, aguarde...' )

	(cAliasSCR)->( dbClosearea() )
   
	If Len( aCOLS ) > 0
		DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
		DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
			
		@ nA1_LinIni, nA1_ColIni GROUP oGroup TO nA1_LinEnd, nA1_ColEnd LABEL ' Dados do aprovador informado no parâmetro ' OF oDlg PIXEL
		oGroup:oFont := oFont
			
		@ nA1_LinIni+10, nA1_ColIni+6 MSGET cDadosAprov SIZE 400,7 PIXEL OF oDlg FONT oFont WHEN .F.
						
		oGride := MsNewGetDados():New( nA2_LinIni,nA2_ColIni,nA2_LinEnd,nA2_ColEnd, 0, 'AllWaysTrue', 'AllWaysTrue', '', {}, 0, Len(aCOLS), '', '', '', oDlg, aHeader, aCOLS )
		oGride:oBrowse:bLDblClick := {||  A610Mrk( oGride ), oGride:Refresh() }
		oGride:oBrowse:bHeaderClick := {|oObj,nColumn| A610Head( nColumn, @oGride ) }

		@ nA3_LinIni, nA3_ColIni GROUP oGroup TO nA3_LinEnd, nA3_ColEnd LABEL ' Após efetuar a seleção informe o código do aprovador para transferir a alçada ' OF oDlg PIXEL
		oGroup:oFont := oFont
			
		@ nA3_LinIni+10, nA3_ColIni+6 SAY "Aprovador" SIZE 45,8 PIXEL OF oDlg FONT oFont
			
		@ nA3_LinIni+18, nA3_ColIni+6 MSGET cCOD_APROV ;
		PICTURE "@!"     ;
		SIZE 40,7        ;
		F3 'SAK'         ;
		VALID Iif( cCOD_APROV == cAK_COD,;
		(MsgAlert('Não é possível transferir para o mesmo aprovador.',cCadastro),.F.),;
		(ExistCpo('SAK',cCOD_APROV).AND.;
		(.NOT.Empty((cNOM_APROV:=SAK->(Posicione('SAK',1,xFilial('SAK')+cCOD_APROV,'AK_NOME'))))).AND.;
		(lContinua := A610VldSup(cAK_COD,cCOD_APROV))));
		PIXEL OF oDlg FONT oFont
			
		@ nA3_LinIni+10, nA3_ColIni+60 SAY "Nome do aprovador" SIZE 90,8 PIXEL OF oDlg FONT oFont
		@ nA3_LinIni+18, nA3_ColIni+60 MSGET cNOM_APROV PICTURE "@!" SIZE 150,7 WHEN .F. PIXEL OF oDlg FONT oFont

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg, {||;
		Iif( AScan( oGride:aCOLS, {|e| e[ 1 ] == 'LBOK' } ) > 0, ;
		Iif(.NOT. Empty( cCOD_APROV ),;
		Iif(lContinua,;
		Iif(MsgYesNo( 'Confirma a transferência de alçada?', cCadastro ),;
		(FWMsgRun( , {|| A610Transf( cCOD_APROV, oGride:aHeader, oGride:aCOLS ) }, ,'Transferindo alçadas, aguarde...' ), oDlg:End() ), NIL ),;
		MsgAlert( 'A transferência somente poderá ser efetuada para o superior do aprovador em questão.', cCadastro ) ),;
		MsgAlert( 'Informe o código do aprovador a transferir.', cCadastro ) ),;
		MsgAlert( 'Selecione alçada para transferir.', cCadastro ) ) },;
		{|| oDlg:End() },,aButton )
	Else
		MsgInfo('Não foi possível localizar registros com os parâmetros informados.', cCadastro )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610VldSup  | Autor | Robson Gonçalves       | Data | 11.08.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para validar/criticar o aprovador superior.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610VldSup( cAK_COD, cCOD_APROV )
	Local aArea := SAK->( GetArea() )
	Local cNomeAprov := ''
	Local cNomeSuper := ''
	Local lRet := .T.
	If lMV610_007
		SAK->( dbSetOrder( 1 ) )
		SAK->( dbSeek( xFilial( 'SAK' ) + cAK_COD ) )
		If cCOD_APROV <> SAK->AK_APROSUP
			lRet := .F.
			cNomeAprov := Upper( RTrim( SAK->AK_NOME ) )
			SAK->( dbSeek( xFilial( 'SAK' ) + SAK->AK_APROSUP ) )
			cNomeSuper := Upper( RTrim( SAK->AK_NOME ) )
			MsgAlert(cFONT+'A transferência de alçada do aprovador [';
				+cAK_COD+'-'+cNomeAprov+']<br>somente poderá ser feita para o seu aprovador superior ['+;
				cCOD_APROV+' '+cNomeSuper+'].'+cNOFONT,'Transferência de alçada')
		Endif
	Endif
	RestArea( aArea )
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A610Mrk     | Autor | Robson Gonçalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para marcar ou desmarcar o registro na posição que está.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Mrk( oGride )
	If oGride:aCOLS[ oGride:nAt, 1 ] == 'LBOK'
		oGride:aCOLS[ oGride:nAt, 1 ] := 'LBNO'
	Else
		oGride:aCOLS[ oGride:nAt, 1 ] := 'LBOK'
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610Head    | Autor | Robson Gonçalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para marcar/desmarcar todos por meio do Head da coluna 1.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Head( nColumn, oGride )
	Local lMrk := .T.
	// Controle para processar somente uma vez.
	// Não sei porque, mas o protheus chama a função sempre duas vezes.
	__nExec++
	If (__nExec%2) == 0
		Return
	Endif
	// Foi clicado na coluna 1.
	If nColumn == 1
		// Há registro marcado?
		lMrk := AScan( oGride:aCOLS, {|e| e[ 1 ] == 'LBOK' } ) > 0
		// Se sim, desmarcar todos, se não marcar todos.
		AEval( oGride:aCOLS, {|e| e[ nColumn ] := Iif(lMrk,'LBNO','LBOK') } )
		// Atualizar o objeto.
		oGride:Refresh()
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610LoadCR  | Autor | Robson Gonçalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para carregar os dados conforme busca no banco de dados.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610LoadCR( cQuery, aHeader, aStruSCR, cAliasSCR, aCOLS )
	Local nX := 0
	Local nY := 0
	Local cSituaca := ''
	Local aUser := {}
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSCR)
	
	For nX := 1 To Len( aStruSCR )
		If aStruSCR[ nX, 2 ] <> 'C'
			TcSetField( cAliasSCR, aStruSCR[ nX, 1 ], aStruSCR[ nX, 2 ], aStruSCR[ nX, 3 ], aStruSCR[ nX, 4 ] )
		EndIf
	Next nX
	
	While (cAliasSCR)->( .NOT. EOF() )
		AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		nY++
		For nX := 1 To Len( aHeader )
			nP := AScan( aUser, {|e| e[ 1 ] == (cAliasSCR)->CR_USER } )
			If nP == 0
				AAdd( aUser, { (cAliasSCR)->CR_USER, RTrim( UsrFullName( (cAliasSCR)->CR_USER ) ) } )
				nP := Len( aUser )
			Endif
		
			If aHeader[ nX, 2] == 'bCR_NOME'
				aCOLS[ nY, nX ] := (cAliasSCR)->CR_USER + '-' + aUser[ nP, 2 ]
			Elseif aHeader[ nX, 2 ] == 'bCR_ITEM'
				aCOLS[ nY, nX ] := Replicate( '-', 8 )
			Elseif aHeader[ nX, 2 ] == 'bCR_SITUACA'
				Do Case
				Case (cAliasSCR)->CR_STATUS == '01' ; cSituaca := 'Nível Bloqueado'
				Case (cAliasSCR)->CR_STATUS == '02' ; cSituaca := 'Aguardando Liberação'
				Case (cAliasSCR)->CR_STATUS == '03' ; cSituaca := 'Pedido Aprovado'
				Case (cAliasSCR)->CR_STATUS == '04' ; cSituaca := 'Pedido Bloqueado' ; lBloq := .T.
				Case (cAliasSCR)->CR_STATUS == '05' ; cSituaca := 'Nível Liberado'
				EndCase
				aCOLS[ nY, nX ] := (cAliasSCR)->CR_STATUS + '-' + cSituaca
			Elseif  aHeader[ nX, 2 ] == 'GD_MARK'
				aCOLS[ nY, nX ] := 'LBNO'
				
			Elseif  aHeader[ nX, 2 ] == 'GD_RECNO'
				aCOLS[ nY, nX ] := (cAliasSCR)->SCRRECNO
				
			Elseif  ( aHeader[ nX, 10 ] <> 'V' )
				aCOLS[ nY, nX ] := FieldGet( FieldPos( aHeader[ nX, 2 ] ) )
			EndIf
		Next nX
		aCOLS[ nY, Len( aHeader )+1 ] := .F.
		(cAliasSCR)->( dbSkip() )
	End
Return

//--------------------------------------------------------------------------
// Rotina | A610Transf  | Autor | Robson Gonçalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para efetuar a transferência.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Transf( cCOD_APROV, aHeader, aCOLS )
	Local aLog := {}
	
	Local cAK_FILIAL := ''
	Local cCR_STATUS := ''
	Local cDest := ''
	Local cFez := ''
	Local cOrig := ''
	Local cUser := RetCodUsr()
	
	Local lFez := .F.
	
	Local nI := 0
	Local nHdl := 0
	Local nP_RECNO := 0
	Local nTam := 115
	
	Local dData := Date()
	
	nHdl := A610Create( 'al', '.ini', dData )
	
	AAdd( aLog, Replicate( '-', nTam ) )
	AAdd( aLog, '| ****** TRANSFERÊNCIA DE ALÇADA EFETUADA PELO USUÁRIO '+cUser+' '+Upper(SubStr(UsrFullName(cUser),1,20))+'  EM '+Dtoc(dData)+' AS '+Time()+' ****** |')
	AAdd( aLog, Replicate( '-', nTam ) )
	AAdd( aLog, '|FILIAL|DOCUMENTO|TIPO|APROVADOR             |SUBSTITUTO            |STATUS               |RETORNO DO PROCESSO    |' )
	AAdd( aLog, Replicate( '-', nTam ) )
	//           |99    |999999   |PC  |000000-XXXXXXXXXXXXXXX|000000-XXXXXXXXXXXXXXX|XXXXXXXXXXXXXXXXXXXXX|XXXXXXXXXXXXXXXXXXXXXXX|
	
	/*
	| **** TRANSFERÊNCIA DE ALÇADA EFETUADA PELO USUÁRIO 999999 AAAAAAAAAABBBBBBBBBB EM 05/02/16 AS 14:00:00 **** |
	123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	0        1         2         3         4         5         6         7         8         9         10        11
	*/
	
	nP_RECNO := AScan( aHeader, {|e| RTrim( e[ 2 ] )=='GD_RECNO' } )
	
	For nI := 1 To Len( aCOLS )
		If aCOLS[ nI, 1 ] == 'LBOK'
			SCR->( dbGoTo( aCOLS[ nI, nP_RECNO ] ) )
			cAK_FILIAL := xFilial( 'SAK' )
			lFez := MaAlcDoc( { SCR->CR_NUM, SCR->CR_TIPO,, cCOD_APROV,,,,,,, 'Transf. Alçada [' + cUser + '] A610TALC' }, dDataBase, 2 )
			
			If lFez
				cFez := 'EFETUADO COM SUCESSO   '
				cOrig := SCR->CR_APROV  + '-' + Upper( PadR( SAK->( Posicione( 'SAK', 1, cAK_FILIAL + SCR->CR_APROV , 'AK_NOME' ) ), 15, ' ' ) )
				cDest := SCR->CR_APRORI + '-' + Upper( PadR( SAK->( Posicione( 'SAK', 1, cAK_FILIAL + SCR->CR_APRORI, 'AK_NOME' ) ), 15, ' ' ) )
				MsAguarde( {|| A610Re2( AllTrim( SCR->CR_NUM ) ) }, cCadastro ,'Reenviado WF no estágio em que está o PC ' + AllTrim( SCR->CR_NUM ), .F. )
			Else
				cFez := 'NÃO CONSEGUI TRANSFERIR'
				cOrig := SCR->CR_APROV  + '-' + Upper( PadR( SAK->( Posicione( 'SAK', 1, cAK_FILIAL + SCR->CR_APROV , 'AK_NOME' ) ), 15, ' ' ) )
				cDest := Space(6+15)
				MsgAlert( cFez + 'PEDIDO DE COMPRAS ' + AllTrim( SCR->CR_NUM ) )
			Endif
			
			cCR_STATUS :=  Iif(SCR->CR_STATUS=='01','01-AGUARDANDO        ',;
				Iif(SCR->CR_STATUS=='02','02-AGUARD.LIBERAÇÃO  ',;
				Iif(SCR->CR_STATUS=='03','03-LIBERADO          ',;
				Iif(SCR->CR_STATUS=='04','04-BLOQUEADO         ',;
				Iif(SCR->CR_STATUS=='05','05-LIB.P/OUTRO USUAR.','STATUS NÃO LOCALIZADO')))))
			
			AAdd( aLog, '|' + SCR->CR_FILIAL + '    ' + ;
				'|' + PadR( RTrim( SCR->CR_NUM ), 9, ' ' ) + ;
				'|' + SCR->CR_TIPO + '  ' +  ;
				'|' + cOrig + ;
				'|' + cDest + ;
				'|' + PadR( cCR_STATUS, 21, ' ' ) + ;
				'|' + cFez + '|' )
		Endif
	Next nI
	
	AAdd( aLog, Replicate( '-', nTam ) )
	AEval( aLog, {|e| FWrite( nHdl, e + CRLF ) } )
	Sleep( Randomize( 1, 999 ) )
	FClose( nHdl )
Return

//--------------------------------------------------------------------------
// Rotina | A610AudTrf  | Autor | Robson Gonçalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para auditar os logs de transferência.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610AudTrf()
	Local oDlg
	Local oBar
	Local oThb
	Local oTLbx
	Local oPnlArq
	Local oPnlMaior
	Local oPnlButton
	Local bSair := {|| oDlg:End() }
	Local oFnt := TFont():New('Arial',,,,.F.,,,8,.T.,,,,,,,)
	Local oFntBox := TFont():New( "Courier New",,-11)
	Local aDADOS := {'Selecione um arquivo para visualizar seu conteúdo...'}
	Local nList := 0
	Local cArq := ''
	Local cExt := 'Auditoria alçada | al*.ini'
	
	DEFINE MSDIALOG oDlg TITLE 'Auditoria de transferências de alçadas' FROM 0,0 TO 360,810 PIXEL
		
	oPnlArq := TPanel():New(0,0,,oDlg,,,,,,16,16,.F.,.F.)
	oPnlArq:Align := CONTROL_ALIGN_TOP
		
	@ 04,003 SAY 'Informe o arquivo' SIZE  65,07 PIXEL OF oPnlArq
	@ 03,050 MSGET cArq PICTURE '@!' SIZE 190,07 PIXEL OF oPnlArq
	@ 04,228 BUTTON '...'            SIZE  10,08 PIXEL OF oPnlArq ACTION cArq := cGetFile(cExt,'Selecione o arquivo',,'SERVIDOR\system',.T.,1)
	@ 03,250 BUTTON 'Abrir'          SIZE  40,10 PIXEL OF oPnlArq ACTION A610OpnF( cArq, @oTLbx, @aDADOS )
		
	oPnlMaior := TPanel():New(0,0,,oDlg,,,,,,13,0,.F.,.F.)
	oPnlMaior:Align := CONTROL_ALIGN_ALLCLIENT
		
	oPnlButton := TPanel():New(0,0,,oDlg,,,,,,13,13,.F.,.F.)
	oPnlButton:Align := CONTROL_ALIGN_BOTTOM
		
	oBar := TBar():New( oPnlButton, 10, 9, .T.,'BOTTOM')
		
	oThb := THButton():New( 1, 1, '&Sair', oBar, bSair , 20, 12, oFnt )
	oThb:Align := CONTROL_ALIGN_RIGHT
		
	oTLbx := TListBox():New(0,0,{|u| Iif(PCount()>0,nList:=u,nList)},{},100,46,,oPnlMaior,,,,.T.,,,oFntBox)
	oTLbx:Align := CONTROL_ALIGN_ALLCLIENT
	oTLbx:SetArray( aDADOS )
	oTLbx:SetFocus()
		
	ACTIVATE MSDIALOG oDlg CENTERED
Return

//--------------------------------------------------------------------------
// Rotina | A610OpnF    | Autor | Robson Gonçalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para abrir e ler o arquivo de log selecionado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610OpnF( cArq, oTLbx, aDADOS )
	If File( cArq )
		aDADOS := {}
		FT_FUSE( cArq )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			AAdd( aDADOS, FT_FREADLN() )
			FT_FSKIP()
		End
		FT_FUSE()
		oTLbx:SetArray( aDADOS )
		oTLbx:Refresh()
	Else
		MsgAlert( 'Arquivo informado não localizado, verifique...', 'Auditoria de transf. de alçadas' )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610ImpAlc  | Autor | Robson Gonçalves       | Data | 05.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para imprimir os dados apresentados na interface para a 
//        | transferência de alçada.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610ImpAlc( aHeader, aCOLS )
	Local oFwMsEx
	Local oExcelApp
	
	Local aDADOS := {}
	
	Local cDir := ''
	Local cDirTmp := ''
	Local cFile := CriaTrab(NIL,.F.)+'.xml'
		
	Local cWorkSheet := 'Alçadas_Pedido_Compras'
	Local cTable := cCadastro
	Local nI := 0
	Local nJ := 0
	oFwMsEx := FWMsExcel():New()
		
	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )
   
	For nI := 2 To Len( aHeader )-1
		oFwMsEx:AddColumn( cWorkSheet, cTable, aHeader[ nI, 1 ], 1, 1 )
	Next nI
	
	For nI := 1 To Len( aCOLS )
		aDADOS := Array( Len( aHeader )-2 )
		For nJ := 1 To Len( aHeader )
			If nJ > 1 .AND. nJ < Len( aHeader )
				aDADOS[ nJ-1 ] := aCOLS[ nI, nJ ]
			Endif
		Next nJ
		oFwMsEx:AddRow( cWorkSheet, cTable, aDADOS )
		aDADOS := {}
	Next nI
	
	oFwMsEx:Activate()
	cDirTmp := GetTempPath()
	cDir := GetSrvProfString('Startpath','')
	
	LjMsgRun( 'Gerando arquivo para impressão, aguarde...', cCadastro, {|| oFwMsEx:GetXMLFile( cFile ), Sleep( Randomize( 1, 499 ) ) } )
	
	If __CopyFile( cFile, cDirTmp + cFile )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cFile )
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
		Sleep( Randomize( 1, 499 ) )
	Else
		MsgInfo( 'Não foi possível copiar o arquivo para o diretório temporário do usuário.' )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610ICRC7   | Autor | Robson Gonçalves       | Data | 11.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para analisar a integração dos registros da SCR capa de despesa
//        | com o pedido de compras. Se não existir, apagar.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610ICRC7()
	Local aSay := {}
	Local aButton := {}
	Local nOpc := 0
	Local cCadastro := 'Análise da integridade Capa de Despesa X PC'
	
	AAdd( aSay, 'Rotina para analisar a integridade dos registros da alçada de aprovação da capa de' )
	AAdd( aSay, 'despesa com o pedido de compras.' )
	AAdd( aSay, 'O processo irá excluir os registros de alçadas que não possuem mais o seu respectivo' )
	AAdd( aSay, 'relacionamento com pedido de compras porque ele foi excluído.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || Iif( MsgYesNo( 'Confirma a execução do processamento de análise?', cCadastro ),( nOpc := 1, FechaBatch() ), NIL ) } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	SetKey( VK_F12 , {|| NIL } )
	
	If nOpc == 1
		FWMsgRun( , {|oSay| A610CRC7( oSay ) }, ,'Analisando os documentos...' )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610CRC7    | Autor | Robson Gonçalves       | Data | 11.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610CRC7( oSay )
	Local cSQL := ''
	Local cTRB := ''
	Local cTexto := ''
	Local aLog := {}
	Local nI := 0
	Local cCR_NUM := ''
	
	/*
		SELECT DISTINCT CR_FILIAL,
		                TRIM(CR_NUM) AS CR_NUM
		FROM   PROTHEUS.SCR010 SCR
		WHERE  CR_TIPO = '#2'
		       AND SCR.D_E_L_E_T_ = ' ' AND NOT EXISTS ( SELECT C7_NUM
		                                                 FROM   PROTHEUS.SC7010 SC7
		                                                 WHERE  C7_FILIAL = CR_FILIAL
		                                                        AND C7_NUM = CR_NUM 
		                                                        AND SC7.D_E_L_E_T_ = ' ')
		ORDER BY CR_FILIAL, CR_NUM
	*/
	
	cSQL := "SELECT DISTINCT CR_FILIAL, "
	cSQL += "                TRIM(CR_NUM) AS CR_NUM "
	cSQL += "FROM   "+RetSqlName("SCR")+" SCR "
	cSQL += "WHERE  CR_TIPO = '#2' "
	cSQL += "       AND SCR.D_E_L_E_T_ = ' ' AND NOT EXISTS ( SELECT C7_NUM "
	cSQL += "                                                 FROM   "+RetSqlName("SC7")+" SC7 "
	cSQL += "                                                 WHERE  C7_FILIAL = CR_FILIAL "
	cSQL += "                                                        AND C7_NUM = CR_NUM "
	cSQL += "                                                        AND SC7.D_E_L_E_T_ = ' ') "
	cSQL += "ORDER BY CR_FILIAL, CR_NUM "
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	SCR->( dbSetOrder( 1 ) )
	SC7->( dbSetOrder( 1 ) )
	While (cTRB)->( .NOT. EOF() )
		cCR_NUM := RTrim( (cTRB)->CR_NUM )
		oSay:cCaption := ('Documento (filial+número): ' + (cTRB)->CR_FILIAL + '-' + cCR_NUM )
		ProcessMessages()
		//------------------------------
		// Verificar se o pedido existe.
		If .NOT. SC7->( dbSeek( (cTRB)->CR_FILIAL + cCR_NUM ) )
			SCR->( dbSeek( (cTRB)->CR_FILIAL + cTP_DOC + (cTRB)->CR_NUM ) )
			While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == (cTRB)->CR_FILIAL	.AND. SCR->CR_TIPO == cTP_DOC .AND. SCR->CR_NUM == (cTRB)->CR_NUM
				cTexto := 'PROCESSAR FILIAL: '+(cTRB)->CR_FILIAL+' ALÇADA: '+cCR_NUM+' APROVADOR: '+SCR->CR_APROV
				If SCR->( MsRLock( RecNo() ) )
					cTexto += ' | BLOQUEOU'
					SCR->( RecLock( 'SCR', .F. ) )
					cTexto += ' | TRAVOU'
					SCR->( dbDelete() )
					cTexto += ' | APAGOU'
					SCR->( MsUnLock() )
					cTexto += ' | DESBLOQUEOU'
				Else
					cTexto += ' | NÃO CONSEGUI BLOQUEAR'
				Endif
				SCR->( dbSkip() )
				AAdd( aLog, cTexto )
			End
		Endif
		(cTRB)->( dbSkip() )
	End
	nHdl := A610Create( 'bl', '.ini', Date() )
	AEval( aLog, {|e| FWrite( nHdl, e + CRLF ) } )
	Sleep( Randomize( 1, 999 ) )
	FClose( nHdl )
Return

//--------------------------------------------------------------------------
// Rotina | A610CSU     | Autor | Robson Gonçalves       | Data | 18.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para consultar a situação do aprovador.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610CSU()
	Local aDADOS := {}
	
	Local nSR8RECNO := 0
	Local nList := 0
	
	Local cAK_VINCULO := ''
	Local cRA_SITFOLH := ''
	Local cR8_FILIAL := ''
	Local cR8_MAT := ''
	Local cSQL := ''
	Local cTRB := ''
	Local cPeriodo := ''
	Local cTitulo := ''
	
	Local dDataHoje := Ctod('')
	
	Local oDlg
	Local oPnlArq
	Local oPnlMaior
	Local oPnlButton
	Local oBar
	Local oThb1, oThb2
	Local oTLbx
	Local oObj
	Local oWork := LoadBitmap(,'BR_VERDE')
	Local oNoWork := LoadBitmap(,'BR_VERMELHO')
	Local oNoLink := LoadBitmap(,'BR_PRETO')
	
	Local aCor := {{'BR_VERDE','Trabalhando'},{'BR_VERMELHO','Afastamento programado'},{'BR_PRETO','Trabalhando e sem programação'}}
	
	Local bLegenda := {|| BrwLegenda('Situação do aprovador na empresa','Trabalhando/férias/afastado',aCor) }
	Local bSair := {|| oDlg:End() }
	Local oFnt := TFont():New('Arial',,,,.F.,,,8,.T.,,,,,,,)
	Local oFntBox := TFont():New( 'Courier New',,-11)
	Local aArea := SAL->( GetArea() )
	Local lAL_MSBLQL := .T.
	Local lAK_MSBLQL := .T.
	
	dDataHoje := MsDate()
	cTitulo := 'Situação formal dos aprovadores - Data referência em ' + Dtoc( dDataHoje )
	
	SAK->( dbSetOrder( 1 ) )
	
	// Processar todos os aprovadores do grupo.
	SAL->( dbSetOrder( 1 ) )
	SAL->( dbSeek( xFilial( 'SAL' ) + c096Num ) )
	While SAL->( .NOT. EOF() ) .AND. SAL->AL_FILIAL == xFilial( 'SAL' ) .AND. SAL->AL_COD == c096Num
		// Verificar se registro está bloqueado (MSBLQL).
		lAL_MSBLQL := RegistroOK('SAL',.F.)
		// Verificar se já processou o aprovador em questão.
		If AScan( aDADOS, {|aprov| SubStr( aprov[ 2 ], 1, 6 ) == SAL->AL_APROV } ) == 0
			// Posicionar no registro do aprovador.
			SAK->( dbSeek( xFilial( 'SAK' ) + SAL->AL_APROV ) )
			// Verificar se registro está bloqueado (MSBLQL).
			lAK_MSBLQL := RegistroOK('SAK',.F.)
			// Se não houver vinculo funcional capturar os dados.
			If Empty( SAK->AK_VINCULO )
				PswOrder( 1 )
				PswSeek( SAK->AK_USER )
				cAK_VINCULO := PswRet()[ 1, 22 ]  // 10 digitos, sendo 1122333333 => 11-empresa; 22-filial; 333333-matricula.
				cAK_VINCULO := SubStr( cAK_VINCULO, 3 )
			Else
				cAK_VINCULO := SAK->AK_VINCULO
			Endif
			// Se não houver vinculo funcional no cadastro de funcionários, gerar a mensagem.
			If Empty( cAK_VINCULO ) .OR. Len( cAK_VINCULO ) < 8
				AAdd( aDADOS, { oNoLink, SAL->AL_APROV + ' - ' + PadR( RTrim(SAK->AK_NOME), 30, ' ' ), 'SEM VINCULO FUNCIONAL.', 'NÃO HÁ CONDIÇÕES DE ANÁLISE' } )
			Else
				// Havendo vinculo funcional, capturar a filial e a matrícula.
				cR8_FILIAL := SubStr( cAK_VINCULO, 1, 2 )
				cR8_MAT    := SubStr( cAK_VINCULO, 3, 6 )
				// Elaborar a query para buscar o perído de afastamento/licença/férias.
				cSQL := "SELECT R8_MAT, "
				cSQL += "       R8_DATAINI, "
				cSQL += "       R8_DATAFIM, "
				cSQL += "       R8_TIPO "
				cSQL += "FROM "+RetSqlName("SR8")+" SR8 "
				cSQL += "WHERE R8_FILIAL = "+ValToSql( cR8_FILIAL )+" "
				cSQL += "      AND R8_MAT = "+ValToSql( cR8_MAT )+" "
				cSQL += "      AND D_E_L_E_T_ = ' ' "
				cSQL += "      AND ( "+ValToSql( dDataHoje )+" >= R8_DATAINI "
				cSQL += "      AND "+ValToSql( dDataHoje )+" <= R8_DATAFIM ) "
				cSQL += "       OR ( R8_DATAINI >= "+ValToSql( dDataHoje )+" "
				cSQL += "          AND R8_DATAFIM <= "+ValToSql( dDataHoje )+" ) "
				
				cTRB := GetNextAlias()
				cSQL := ChangeQuery( cSQL )
				PLSQuery( cSQL, cTRB )
				
				// Capturar o período de afastamento/licença/férias.
				If (cTRB)->(.NOT. BOF() ) .AND. (cTRB)->(.NOT. EOF() )
					While (cTRB)->( .NOT. EOF() )
						If dDataHoje >= (cTRB)->R8_DATAINI .AND. dDataHoje <= (cTRB)->R8_DATAFIM
							cPeriodo := 'De '+Dtoc( (cTRB)->R8_DATAINI )+;
								' até '+ Dtoc( (cTRB)->R8_DATAFIM ) + ;
								' - ' + RTrim( SX5->( Tabela( '30', (cTRB)->R8_TIPO, .F. ) ) )
							Exit
						Endif
						(cTRB)->( dbSkip() )
					End
				Endif
				(cTRB)->( dbCloseArea() )
				
				// Capturar a situação do cadastro do funcionário, lembrando que somente este dado não é válido.
				cRA_SITFOLH := SRA->( Posicione( 'SRA', 1, cAK_VINCULO, 'RA_SITFOLH' ) )
				
				// Tem período programado e há SITFOLH ou Tem Período e não há SITFOLH.
				If ( .NOT. Empty( cPeriodo ) .AND. .NOT. Empty( cRA_SITFOLH ) ) .OR. ( .NOT. Empty( cPeriodo ) .AND. Empty( cRA_SITFOLH ) )
					oObj := oNoWork
					cRA_SITFOLH := 'Afastamento programado.           '
					
				// Não tem período e há SITFOLH ou Não tem período e não há SITFOLH.
				Elseif ( Empty( cPeriodo ) .AND. .NOT. Empty( cRA_SITFOLH ) ) .OR. ( Empty( cPeriodo ) .AND. Empty( cRA_SITFOLH ) )
					oObj := oWork
					cRA_SITFOLH := 'Trabalhando.                      '
					cPeriodo := 'Sem programação'
				
				// Não atendeu nenhuma das condiçõs acima.
				Else
					oObj := oNoWork
					cRA_SITFOLH := 'Trabalhando e sem programação...  '
					cPeriodo := 'Sem programação'
					
				Endif
				
				// Armazenar no vetor a situação identificada.
				AAdd( aDADOS, { oObj, SAL->AL_APROV + ' - ' + PadR( RTrim(SAK->AK_NOME), 30, ' ' ), cRA_SITFOLH, cPeriodo + ;
					Iif(.NOT.lAL_MSBLQL,' - Aprovador bloq. no grupo.',Iif(.NOT.lAK_MSBLQL,' - Aprovador bloquado.','') ), '', SAK->AK_NOME } )
				
				cPeriodo := ''
			Endif
		Endif
		SAL->( dbSkip() )
	End
	// Há dados para consultar?
	If Len( aDADOS ) > 0
		// Ordenar o vetor por código de aprovador.
		ASort( aDADOS,,,{|a,b| a[6] < b[6] } )
		// Apresentar os dados na tela.
		DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 232,800 PIXEL
		oPnlMaior := TPanel():New(0,0,,oDlg,,,,,,13,0,.F.,.F.)
		oPnlMaior:Align := CONTROL_ALIGN_ALLCLIENT
			
		oPnlButton := TPanel():New(0,0,,oDlg,,,,,,13,13,.F.,.F.)
		oPnlButton:Align := CONTROL_ALIGN_BOTTOM
			
		oBar := TBar():New( oPnlButton, 10, 9, .T.,'BOTTOM')
			
		oThb1 := THButton():New( 1, 1, '&Sair', oBar, bSair , 20, 12, oFnt )
		oThb1:Align := CONTROL_ALIGN_RIGHT

		oThb2 := THButton():New( 1, 1, '&Legenda', oBar, bLegenda , 30, 12, oFnt )
		oThb2:Align := CONTROL_ALIGN_RIGHT
			
		oTLbx := TwBrowse():New(1,1,1000,1000,,{'','Aprovador','Situação','Programação',''},,oDlg,,,,,,,oFntBox,,,,,.F.,,.T.,,.F.,,,)
		oTLbx:lUseDefaultColors := .F.
		oTLbx:SetArray( aDADOS )
		oTLbx:bLine := {|| AEval( aDADOS[oTLbx:nAt],{|z,w| aDADOS[oTLbx:nAt,w]})}
		oTLbx:Align := CONTROL_ALIGN_ALLCLIENT
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		MsgAlert( 'Não consegui localizar os dados', cTitulo )
	Endif
	RestArea( aArea )
Return

//--------------------------------------------------------------------------
// Rotina | A610RPar    | Autor | Robson Gonçalves       | Data | 25.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar se o parâmetro com o centro de custo de 
//        | remuneração de parceiros existe e logo capturar seu conteúdo.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610RPar()
	Local cMV_610RPAR := 'MV_610RPAR'
	If .NOT. GetMv( cMV_610RPAR, .T. )
		CriarSX6( cMV_610RPAR, 'C', 'C.CUSTO NO PC P/ REM.DE PARCEIROS, ESTE NÃO PRECISA DE CAPA DESPESA. (;) PARA SEPARAR MAIS DE UM CÓDIGO. CSFA610.prw', '80000000' )
	Endif
Return( GetMv( cMV_610RPAR, .F. ) )

//--------------------------------------------------------------------------
// Rotina | A610IsRPar  | Autor | Robson Gonçalves       | Data | 03.08.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar se o pedido de compras em questão é 
//        | relativo a remuneração de parceiro. Para ser esta condição os 
//        | campos C7_CC e C7_CCAPROV devem ser igual ao centro de custo do
//        | parâmetro MV_610RPAR (80000000).
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610IsRPar( cC7_FILIAL, cC7_NUM )
	Local cCCusto := A610RPar()
	Local cExp1 := ''
	Local cExp2 := ''
	Local cTRB := GetNextAlias()
	Local lReturn := .F.
	Local aArea := GetArea()
	
	If Len( cCCusto ) > Len( CTT->CTT_CUSTO )
		cExp1 := '%' + A610Range( cCCusto, 'C7_CC' )      + '%'
		cExp2 := '%' + A610Range( cCCusto, 'C7_CCAPROV' ) + '%'
	Else
		cExp1 := "%(C7_CC = '" + cCCusto      + "')%"
		cExp2 := "%(C7_CCAPROV = '" + cCCusto + "')%"
	Endif
	
	BEGINSQL ALIAS cTRB
		SELECT COUNT(*) REMUN_PARC
		FROM   %Table:SC7% SC7
		WHERE  C7_FILIAL = %Exp:cC7_FILIAL%
		AND C7_NUM = %Exp:cC7_NUM%
		AND %Exp:cExp1%
		AND %Exp:cExp2%
		AND SC7.%NotDel%
	ENDSQL
	lReturn := ( (cTRB)->REMUN_PARC > 0 )
	(cTRB)->( dbCloseArea() )
	
	RestArea( aArea )
Return( lReturn )

//--------------------------------------------------------------------------
// Rotina | A610Range | Autor | Robson Gonçalves         | Data | 04.08.2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para elaborar a expressão para claussula Where.  
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Range( cRange, cCpo )
	Local aRange := StrTokArr( cRange, ';' )
	Local cExp := ''
	Local nI := 0
	For nI := 1 To Len( aRange )
		cExp += cCpo + "='" + aRange[ nI ] + "' OR "
	Next nI
	If cExp <> ''
		cExp := '(' + SubStr( cExp, 1, Len( cExp )-4 ) + ')'
	Endif
Return( cExp )

//--------------------------------------------------------------------------
// Rotina | A610DPAG    | Autor | Robson Gonçalves       | Data | 25.02.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para criticar a data de vencimento digitado pelo usuário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610DPAG( nON, lVaiInsistir )
	//Local dHoje := MsDate()
	//Local dC7_XVENCTO := Ctod('')
	//Local cTitulo := 'Criticar vencimento'
	//Local cReadVar := ReadVar()
	//Local aMsg := {}
	//Local lRet := .T.
	
	//DEFAULT lVaiInsistir := .F.
	
	//dC7_XVENCTO := A610SCond()
	
	//If nON == 1
		//AAdd( aMsg, 'Condição de pagamento inferior ao que foi estabelecido pela companhia.')
		//AAdd( aMsg, 'Condição de pagamento é inferior a data de hoje, não será possível seguir.')
		//If dC7_XVENCTO >= dHoje
			//If ( dC7_XVENCTO - dHoje ) < A610PrzPag()
				//lMSG_PRAZO_VENCTO := .T.
				//MsgAlert( cFNTALERT + 'Atenção!' + '<br>' + aMsg[ 1 ] + cNOFONT, cTitulo )
				//If lVaiInsistir
					//lRet := MsgYesNo( cALERT + 'Você foi alertado da condição de pagamento inferior, seguir mesmo assim?' + cNOFONT,'Condição de pagamento inferior')
				//Endif
			//Else
				//lMSG_PRAZO_VENCTO := .F.
			//Endif
		//Else
			//lRet := .F.
			//MsgAlert( cALERT + 'Atenção!' + cNOFONT + cFNTALERT + '<br>' + aMsg[ 2 ] + cNOFONT, cTitulo )
		//Endif
	//Endif
//Return( lRet )
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | A610PrzPag  | Autor | Robson Gonçalves       | Data | 29/02/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar se o parâmetro existe, se não existir cria
//        | e logo retorna seu conteúdo.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610PrzPag()
	Local cMV_610DPAG := 'MV_610DPAG'
	If .NOT. GetMv( cMV_610DPAG, .T. )
		CriarSX6( cMV_610DPAG, 'N', 'QTDE DE DIAS PARA O PRAZO DE PAGAMENTO PERMITIDO NA CAPA DE DESPESA, NO MINIMO DEVE SER ZERO. CSFA610.prw', '7' )
	Endif
Return( GetMv( cMV_610DPAG, .F. ) )

//--------------------------------------------------------------------------
// Rotina | CSFA610C | Autor | Robson Gonçalves          | Data | 03/03/2016
//--------------------------------------------------------------------------
// Descr. | Rotina JOB para verificar afastamento dos aprovadores.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA610C( aParam )
	DEFAULT aParam := { '01', '02' }
	cEmp := aParam[ 1 ]
	cFil := aParam[ 2 ]
	Conout('CSFA610B - Iniciando a rotina do processo de verificação de férias dos aprovadores.')
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'GCT' TABLES 'SAK','SAL', 'SRA', 'SR8'
	Conout('CSFA610B - A610ChkApv - Início da execução da rotina.')
	A610ChkApv( cEmp, cFil )
	Conout('CSFA610C - A610ChkApv - Fim da execução da rotina.')
	RESET ENVIRONMENT
	Conout('CSFA610C - Finalizadno a rotina do processo de verificação de férias dos aprovadores.')
Return

//--------------------------------------------------------------------------
// Rotina | A610ChkApv | Autor | Robson Gonçalves        | Data | 03/03/2016
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento p/ verificar afastamento de aprovadores.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610ChkApv( cEmp, cFil )
	Local cAK_VINCULO := ''
	
	SAK->( dbSetOrder( 2 ) )
	SAK->( dbSeek( xFilial( 'SAK' ) ) )
	
	While SAK->( .NOT. EOF() ) .AND. SAK->AK_FILIAL == xFilial( 'SAK' )
		
		If Empty( SAK->AK_VINCULO )
			PswOrder( 1 )
			PswSeek( SAK->AK_USER )
			cAK_VINCULO := PswRet()[ 1, 22 ] // 10 digitos, sendo 1122333333 => 11-empresa; 22-filial; 333333-matricula.
			cAK_VINCULO := SubStr( cAK_VINCULO, 3 ) // retirar os digitos da empresa.
			
			If Empty( cAK_VINCULO )
				Conout( 'CSFA610B - A610ChkApv - Usuário ' + SAK->AK_USER + ' como aprovador ' + SAK->AK_COD + ' está sem vínculo no cadastro de usuários.' )
				SAK->( dbSkip() )
				Loop
			Endif
			
			//Renato Ruy - 18/09/2018
			//Quando não existir lock, entra para efetuar gravacao.
			If SAK->(RLock())
				SAK->( RecLock( 'SAK', .F. ) )
				SAK->AK_VINCULO := cAK_VINCULO
				SAK->( MsUnLock() )
			//Se nao pula registro
			Else
				SAK->( dbSkip() )
				Loop
			Endif
		Endif
		
		cRA_SITFOLH := SRA->( Posicione( 'SRA', 1, SAK->AK_VINCULO, 'RA_SITFOLH' ) )
		lAfastado := A610SR8( SAK->AK_VINCULO )
		
		Conout( 'CSFA610B - A610ChkApv - AK_VINCULO: ' + cAK_VINCULO )
		Conout( 'CSFA610B - A610ChkApv - RA_SITFOLH: ' + Iif( Empty( cRA_SITFOLH ), 'Vazio', cRA_SITFOLH ) )
		Conout( 'CSFA610B - A610ChkApv - lAfastado.: ' + Iif( lAfastado, 'True', 'False' ) )
		Conout( 'CSFA610B - A610ChkApv - AL_MSBLQL.: ' + Iif( SAK->AK_MSBLQL == '1', '1=Sim', Iif( SAK->AK_MSBLQL == '2', '2=Não', 'Vazio=Não' ) ) )

		// Avaliar: cRA_SITFOLH = preenchido
		//          lAfastado = .T.
		//          SAK->AK_MSBLQL = 2Não
		// Resultado: Mudar para 1Sim
		If .NOT. Empty( cRA_SITFOLH ) .AND. lAfastado .AND. SAK->AK_MSBLQL <> '1'
			Conout( 'CSFA610B - A610ChkApv - Gravar AK_MSBLQL para 1Sim' )
			//Renato Ruy - 18/09/2018
			//Quando não existir lock, entra para efetuar gravacao.
			If SAK->(RLock())
				SAK->( RecLock( 'SAK', .F. ) )
				SAK->AK_MSBLQL := '1'
				SAK->( MsUnLock() )
			//Se nao pula registro
			Else
				SAK->( dbSkip() )
				Loop
			Endif
		
		// Avaliar: cRA_SITFOLH = não preenchido
		//          lAfastado = .F.
		//          SAK->AK_MSBLQL = 1Sim
		// Resultado: Mudar para 2Não
		Elseif Empty( cRA_SITFOLH ) .AND. .NOT. lAfastado .AND. (SAK->AK_MSBLQL == '2' .OR. Empty( SAK->AK_MSBLQL ) )
			Conout( 'CSFA610B - A610ChkApv - Gravar AK_MSBLQL para 2Não' )
			//Renato Ruy - 18/09/2018
			//Quando não existir lock, entra para efetuar gravacao.
			If SAK->(RLock())
				SAK->( RecLock( 'SAK', .F. ) )
				SAK->AK_MSBLQL := '2'
				SAK->( MsUnLock() )
			//Se nao pula registro
			Else
				SAK->( dbSkip() )
				Loop
			Endif
		ElseIF .NOT. lAfastado .AND. SAK->AK_MSBLQL == '1'
			Conout( 'CSFA610B - A610ChkApv - Gravar AK_MSBLQL para 2Não' )
			//Renato Ruy - 18/09/2018
			//Quando não existir lock, entra para efetuar gravacao.
			If SAK->(RLock())
				SAK->( RecLock( 'SAK', .F. ) )
				SAK->AK_MSBLQL := '2'
				SAK->( MsUnLock() )
			//Se nao pula registro
			Else
				SAK->( dbSkip() )
				Loop
			Endif
		Else
			Conout( 'CSFA610B - A610ChkApv - Não consegui condicionar para gravar o AK_MSBLQL.' )
		Endif
		SAK->( dbSkip() )
	End
Return

//--------------------------------------------------------------------------
// Rotina | A610Save | Autor | Robson Gonçalves          | Data | 04/03/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para salvar as variáveis definidas na capa de despesa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Save( nDISTINTO, cBUDGET, lItProd, lItemRat, cCTA_ORCADA )
	aCTA_ORCADA := { nDISTINTO, cBUDGET, lItProd, lItemRat, cCTA_ORCADA }
Return

//--------------------------------------------------------------------------
// Rotina | A610Restore | Autor | Robson Gonçalves       | Data | 04/03/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para restaurar as variáveis que foram definidas na capa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Restore()
Return( aCTA_ORCADA )

//--------------------------------------------------------------------------
// Rotina | A610Clear | Autor | Robson Gonçalves         | Data | 04/03/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para limpar o vetor que armazena os dados que foram 
//        | definidos na capa de despesa
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Clear()
	aCTA_ORCADA := {}
Return

//--------------------------------------------------------------------------
// Rotina | A610Create | Autor | Robson Gonçalves        | Data | 04/03/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para tentar criar o arquivo texto que armazenará o log de
//        | processamento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Create( cPrefix, cExtens, dData )
	Local nHdl := 0
	Local nPar1 := 0
	Local nPar2 := 0
	Local cArqIni := ''
	nPar1 := SubStr( Str( Year( dData ), 4, 0 ), 4 ) + StrZero( Month( dData ), 2, 0 ) + StrZero( Day( dData ), 2, 0 )
	nPar2 := Int( Seconds() )
	cArqIni := cPrefix + Str( Val( nPar1 ) + nPar2, 6, 0 ) + cExtens
	While .T.
		If File( cArqIni )
			Sleep( Randomize( 1, 999 ) )
			nPar1 := Str( Year( dData ), 4, 0 ) + Month( dData, 2, 0 ) + Day( dData, 2, 0 )
			nPar2 := Int( Seconds() )
			cArqIni := cPrefix + Str( nPar1 + nPar2, 5, 0 ) + cExtens
		Else
			nHdl := FCreate( cArqIni )
			Exit
		Endif
	End
Return( nHdl )

//--------------------------------------------------------------------------
// Rotina | A610Vinc    | Autor | Robson Gonçalves       | Data | 11.03.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para atualizar o vinculo funcional do aprovador em seu
//        | registro.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Vinc( aParam )
	Local cSQL := ''
	Local cTxtIni := '* [A610VINC] Início do processo preencher campo AK_VINCULO conforme cadastro de usuários.'
	Local cTRB := ''
	Local cVINCULO := ''
	Local lAuto := ( Select( 'SX6' ) == 0 )
	DEFAULT aParam := { '01', '02' }
	If lAuto
		RpcSetType( 3 )
		RpcSetEnv( aParam[ 1 ], aParam[ 2 ] )
		Conout( cTxtIni )
		Conout( '* [A610VINC] Processo executado via JOB.' )
	Else
		Conout( cTxtIni )
		Conout( '* [A610VINC]Processo executado via SISTEMA.' )
		If .NOT. MsgYesNo( 'Início do processo de análise do campo AK_VINCULO conforme o cadastro de aprovador X usuário. Clique em SIM para prosseguir.', 'Análise do vínculo funcional do aprovador X usuário' )
			Conout( '* [A610VINC]Processo abandonado pelo usuário.' )
			Return
		Endif
	Endif
	dbSelectArea( 'SAK' )
	cSQL := "SELECT R_E_C_N_O_ AS AK_RECNO "
	cSQL += "FROM   "+RETSQLNAME("SAK")+" SAK "
	cSQL += "WHERE  ( AK_VINCULO = ' ' "
	cSQL += "         OR LENGTH( TRIM( AK_VINCULO ) ) < 8 ) "
	cSQL += "         AND AK_MSBLQL <> '1' "
	cSQL += "         AND SAK.D_E_L_E_T_ = ' ' "
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	If (cTRB)->(.NOT. BOF() ) .AND. (cTRB)->(.NOT. EOF() )
		PswOrder( 1 )
		While (cTRB)->( .NOT. EOF() )
			SAK->( dbGoTo( (cTRB)->AK_RECNO ) )
			PswSeek( SAK->AK_USER )
			cVINCULO := PswRet()[ 1, 22 ]
			If .NOT. Empty( cVINCULO )
				cVINCULO := SubStr( cVINCULO, 3 )
				Conout( '* [A610VINC] Atualizei aprovador/matrícula/nome: ' + SAK->AK_COD + ' - ' + cVINCULO + ' ' + SAK->AK_NOME )
				SAK->( RecLock( 'SAK', .F. ) )
				SAK->AK_VINCULO := cVINCULO
				SAK->( MsUnLock() )
			Endif
			(cTRB)->( dbSkip() )
		End
	Else
		Conout( '* [A610VINC] Não há atualização para AK_VINCULO.' )
	Endif
	(cTRB)->( dbCloseArea() )
	Conout( '* [A610VINC] Fim do processo.' )
	If lAuto
		RpcClearEnv()
	Else
		MsgInfo('Processo finalizado.')
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610TemRateio | Autor | Robson Gonçalves     | Data | 18.03.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar se há rateio capturar os dados do rateio.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610TemRateio( cAmb, cTab, aKey, lCount, aRateio, lItemRate, lItemProd )
	Local aVar[4]
	Local aVlrItPC := {}
	Local lRet:=.F.
	Local cSQL:='', cTRB:='', cCH_ITEMPD:=''
	Local nC7_ITEM:=0, nC7_TOTAL:=0, nC7_CC:=0, nC7_CONTA:=0, nC7_ITEMCTA:=0, nC7_CLVL:=0
	Local cSqlCount1:=0, cSqlCount2:=0, cSqlGroup1:=0, cSqlGroup2:=0, cSqlAll:=0, cSqlWhere:=0
	Local nI:=0, nJ:=0, nElem:=0, nQtdeReg:=0, nCH_ITEM:=0, nCH_PERC:=0, nCH_VLRAT:=0, nCH_CC:=0, nCH_CONTA:=0, nCH_ITEMCTA:=0, nCH_CLVL:=0
	Local nItemPC := 0
	
	If cAmb == 'MATA161'
		If cTab == 'SCX'
			cSQL := "SELECT CX_ITEMSOL, CX_ITEM, CX_PERC, CX_CC, CX_CONTA, CX_ITEMCTA, CX_CLVL "
			cSQL += "FROM "+RETSQLNAME("SCX")+" SCX "
			cSQL += "WHERE CX_FILIAL = "+ValToSql( aKey[ 1 ] ) + " "
			cSQL += "AND CX_SOLICIT = "+ValToSql( aKey[ 2 ] ) + " "
			cSQL += "AND CX_ITEMSOL = "+ValToSql( aKey[ 3 ] ) + " "
			cSQL += "AND CX_PERC > 0 "
			cSQL += "AND SCX.D_E_L_E_T_ = ' ' "
			cSQL := ChangeQuery( cSQL )
			cTRB := GetNextAlias()
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
			While .NOT. (cTRB)->( EOF() )
				lItemRate := .T.
				If aVar[ 1 ] <> (cTRB)->CX_CC .OR. ;
					aVar[ 2 ] <> (cTRB)->CX_CONTA .OR. ;
					aVar[ 3 ] <> (cTRB)->CX_ITEMCTA .OR. ;
					aVar[ 4 ] <> (cTRB)->CX_CLVL
				   
					aVar[ 1 ] := (cTRB)->CX_CC
					aVar[ 2 ] := (cTRB)->CX_CONTA
					aVar[ 3 ] := (cTRB)->CX_ITEMCTA
					aVar[ 4 ] := (cTRB)->CX_CLVL
					
					nQtdeReg++
				Endif
				If .NOT. lCount
					(cTRB)->(AAdd(aRateio,{CX_ITEMSOL,CX_ITEM,LTrim(Str(CX_PERC,10,6)),'0,00',RTRim(CX_CC),RTRim(CX_CONTA),RTRim(CX_ITEMCTA),RTRim(CX_CLVL)}))
				Endif
				(cTRB)->( dbSkip() )
			End
			lRet := ( nQtdeReg > 1 )
			If lRet
				lItemProd := lRet
			Endif
			(cTRB)->( dbCloseArea() )
		Elseif cTab == 'SC1'
			lItemRate := Iif(lItemRate,lItemRate,.F.)
			//----------------------------------------------------------------------------------------------------
			cSqlAll := "SELECT C1_ITEM,C1_CC,C1_CONTA,C1_ITEMCTA,C1_CLVL  "
			//----------------------------------------------------------------------------------------------------
			cSqlCount1 := "SELECT COUNT(*) AS QTDE_REG FROM ( "
			cSqlCount2 := ") TAB_COUNT_CP "
			//----------------------------------------------------------------------------------------------------
			cSqlGroup1 := "SELECT C1_CC, C1_CONTA, C1_ITEMCTA, C1_CLVL "
			cSqlGroup2 := "GROUP BY C1_CC, C1_CONTA, C1_ITEMCTA, C1_CLVL "
			//----------------------------------------------------------------------------------------------------
			cSqlWhere := "FROM "+RETSQLNAME("SC1")+" SC1 "
			cSqlWhere += "WHERE C1_FILIAL = "+ValToSql( aKey[ 1 ] )+" "
			cSqlWhere += "AND "+aKey[ 2 ]
			cSqlWhere += "AND C1_CC <> ' ' "
			cSqlWhere += "AND C1_CONTA <> ' ' "
			cSqlWhere += "AND SC1.D_E_L_E_T_ = ' ' "
			//----------------------------------------------------------------------------------------------------
			cSQL := cSqlCount1 + cSqlGroup1 + cSqlWhere + cSqlGroup2 + cSqlCount2
			cSQL := ChangeQuery( cSQL )
			cTRB := "TAB_COUNT_CP"
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
			If (cTRB)->QTDE_REG > 1
				If lCount
					lRet := .T.
				Else
					(cTRB)->( dbCloseArea() )
					cSQL := cSqlAll + cSqlWhere
					cSQL := ChangeQuery( cSQL )
					cTRB := GetNextAlias()
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
					While .NOT. (cTRB)->( EOF() )
						(cTRB)->(AAdd(aRateio,{C1_ITEM,'    ','0.00','0.00',RTRim(C1_CC),RTRim(C1_CONTA),RTRim(C1_ITEMCTA),RTRim(C1_CLVL)}))
						(cTRB)->( dbSkip() )
					End
				Endif
			Endif
			If lRet
				lItemProd := lRet
			Endif
			(cTRB)->( dbCloseArea() )
		Elseif cTab == 'SC1-A'
		///////////////////////////////////////////////////////////////////////////////////////////////////
			lItemRate := Iif(lItemRate,lItemRate,.F.)
			//----------------------------------------------------------------------------------------------------
			cSqlAll := "SELECT C1_FILIAL,C1_PEDIDO,C1_ITEMPED,C1_ITEM,C1_CC,C1_CONTA,C1_ITEMCTA,C1_CLVL "
			//----------------------------------------------------------------------------------------------------
			cSqlCount1 := "SELECT COUNT(*) AS QTDE_REG FROM ( "
			cSqlCount2 := ") TAB_COUNT_CP "
			//----------------------------------------------------------------------------------------------------
			cSqlGroup1 := "SELECT C1_CC, C1_CONTA, C1_ITEMCTA, C1_CLVL "
			cSqlGroup2 := "GROUP BY C1_CC, C1_CONTA, C1_ITEMCTA, C1_CLVL "
			//----------------------------------------------------------------------------------------------------
			cSqlWhere := "FROM "+RETSQLNAME("SC1")+" SC1 "
			cSqlWhere += "WHERE "+aKey[ 1 ]+" "
			cSqlWhere += "AND C1_CC <> ' ' "
			cSqlWhere += "AND C1_CONTA <> ' ' "
			cSqlWhere += "AND SC1.D_E_L_E_T_ = ' ' "
			//----------------------------------------------------------------------------------------------------
			cSQL := cSqlCount1 + cSqlGroup1 + cSqlWhere + cSqlGroup2 + cSqlCount2
			cSQL := ChangeQuery( cSQL )
			cTRB := "TAB_COUNT_CP"
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
			If (cTRB)->QTDE_REG > 1
				If lCount
					lRet := .T.
				Else
					(cTRB)->( dbCloseArea() )
					cSQL := cSqlAll + cSqlWhere
					cSQL := ChangeQuery( cSQL )
					cTRB := GetNextAlias()
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
					While .NOT. (cTRB)->( EOF() )
						aVlrItPC := SC7->(GetAdvFVal('SC7',{'C7_TOTAL','C7_DESPESA','C7_VALFRE','C7_VALIPI','C7_SEGURO','C7_VLDESC'},(cTRB)->(C1_FILIAL+C1_PEDIDO+C1_ITEMPED),1))
						nItemPC := ( aVlrItPC[ 1 ] + aVlrItPC[ 2 ] + aVlrItPC[ 3 ] + aVlrItPC[ 4 ] + aVlrItPC[ 5 ] ) - aVlrItPC[ 6 ]
						(cTRB)->(AAdd(aRateio,{C1_ITEM,'    ','0.00',LTrim(Str(nItemPC,12,2)),RTRim(C1_CC),RTRim(C1_CONTA),RTRim(C1_ITEMCTA),RTRim(C1_CLVL)}))
						(cTRB)->( dbSkip() )
					End
				Endif
			Endif
			If lRet
				lItemProd := lRet
			Endif
			(cTRB)->( dbCloseArea() )
		///////////////////////////////////////////////////////////////////////////////////////////////////
		Endif
	Elseif cAmb == 'CNTA120'
		If cTab == 'CNZ'
			cSQL := "SELECT CNZ_ITCONT,CNZ_ITEM,CNZ_PERC,CNZ_VALOR1,CNZ_CC,CNZ_CONTA,CNZ_ITEMCT,CNZ_CLVL "
			cSQL += "FROM "+RETSQLNAME("CNZ")+" CNZ "
			cSQL += "WHERE CNZ_FILIAL = "+ValToSql( aKey[ 1 ] ) + " "
			cSQL += "AND CNZ_CONTRA = "+ValToSql( aKey[ 2 ] ) + " "
			cSQL += "AND CNZ_REVISA = "+ValToSql( aKey[ 3 ] ) + " "
			cSQL += "AND CNZ_NUMMED = "+ValToSql( aKey[ 4 ] ) + " "
			cSQL += "AND CNZ_PERC > 0 "
			cSQL += "AND CNZ_VALOR1 > 0 "
			cSQL += "AND CNZ.D_E_L_E_T_ = ' ' "
			cSQL := ChangeQuery( cSQL )
			cTRB := GetNextAlias()
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
			While .NOT. (cTRB)->( EOF() )
				lItemRate := .T.
				If aVar[ 1 ] <> (cTRB)->CNZ_CC .OR. ;
					aVar[ 2 ] <> (cTRB)->CNZ_CONTA .OR. ;
					aVar[ 3 ] <> (cTRB)->CNZ_ITEMCT .OR. ;
					aVar[ 4 ] <> (cTRB)->CNZ_CLVL
				   
				   aVar[ 1 ] := (cTRB)->CNZ_CC
					aVar[ 2 ] := (cTRB)->CNZ_CONTA
					aVar[ 3 ] := (cTRB)->CNZ_ITEMCT
					aVar[ 4 ] := (cTRB)->CNZ_CLVL
					
					nQtdeReg++
				Endif
				If .NOT. lCount
					//(cTRB)->(AAdd(aRateio,{CNZ_ITCONT,CNZ_ITEM,LTrim(Str(CNZ_PERC,10,6)),LTrim(Str(CNZ_VLRAT,9,2)),RTRim(CNZ_CC),RTRim(CNZ_CONTA),RTRim(CNZ_ITEMCT),RTRim(CNZ_CLVL)}))
					(cTRB)->(AAdd(aRateio,{CNZ_ITCONT,CNZ_ITEM,CNZ_PERC,CNZ_VALOR1,RTRim(CNZ_CC),RTRim(CNZ_CONTA),RTRim(CNZ_ITEMCT),RTRim(CNZ_CLVL)}))
				Endif
				(cTRB)->( dbSkip() )
			End
			lRet := ( nQtdeReg > 1 )
			If lRet
				lItemProd := lRet
			Endif
			(cTRB)->( dbCloseArea() )
		Elseif cTab == 'CNE'
			lItemRate := Iif(lItemRate,lItemRate,.F.)
			//----------------------------------------------------------------------------------------------------
			cSqlAll := "SELECT CNE_ITEM,CNE_VLTOT,CNE_CC,CNE_CONTA,CNE_ITEMCT,CNE_CLVL  "
			//----------------------------------------------------------------------------------------------------
			cSqlCount1 := "SELECT COUNT(*) AS QTDE_REG FROM ( "
			cSqlCount2 := ") TAB_COUNT_CP "
			//----------------------------------------------------------------------------------------------------
			cSqlGroup1 := "SELECT CNE_CC,CNE_CONTA,CNE_ITEMCT,CNE_CLVL "
			cSqlGroup2 := "GROUP BY CNE_CC,CNE_CONTA,CNE_ITEMCT,CNE_CLVL  "
			//----------------------------------------------------------------------------------------------------
			cSqlWhere := "FROM "+RETSQLNAME("CNE")+" CNE "
			cSqlWhere += "WHERE CNE_FILIAL = "+ValToSql( aKey[ 1 ] )+" "
			cSqlWhere += "AND CNE_CONTRA = "+ValToSql( aKey[ 2 ] )+" "
			cSqlWhere += "AND CNE_REVISA = "+ValToSql( aKey[ 3 ] )+" "
			cSqlWhere += "AND CNE_NUMERO = "+ValToSql( aKey[ 4 ] )+" "
			cSqlWhere += "AND CNE_NUMMED = "+ValToSql( aKey[ 5 ] )+" "
			cSqlWhere += "AND CNE_CC <> ' ' "
			cSqlWhere += "AND CNE_CONTA <> ' ' "
			cSqlWhere += "AND CNE.D_E_L_E_T_ = ' ' "
			//----------------------------------------------------------------------------------------------------
			cSQL := cSqlCount1 + cSqlGroup1 + cSqlWhere + cSqlGroup2 + cSqlCount2
			cSQL := ChangeQuery( cSQL )
			cTRB := "TAB_COUNT_CP"
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
			If (cTRB)->QTDE_REG > 1
				If lCount
					lRet := .T.
				Else
					(cTRB)->( dbCloseArea() )
					cSQL := cSqlAll + cSqlWhere
					cSQL := ChangeQuery( cSQL )
					cTRB := GetNextAlias()
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
					While .NOT. (cTRB)->( EOF() )
						(cTRB)->(AAdd(aRateio,{CNE_ITEM,'    ','0.00',LTrim(Str(CNE_VLTOT,12,2)),RTRim(CNE_CC),RTRim(CNE_CONTA),RTRim(CNE_ITEMCT),RTRim(CNE_CLVL)}))
						(cTRB)->( dbSkip() )
					End
				Endif
			Endif
			If lRet
				lItemProd := lRet
			Endif
			(cTRB)->( dbCloseArea() )
		Endif
	Elseif cAmb == 'MATA120'
		If cTab == 'ARRAY'
			If Len( aCPISCH ) > 0
				AFill( aVar, '' )
				nCH_ITEM    := AScan( aCPHSCH, {|e| RTrim( e[ 2 ] ) == 'CH_ITEM' } )
				nCH_PERC    := AScan( aCPHSCH, {|e| RTrim( e[ 2 ] ) == 'CH_PERC' } )
				nCH_VLRAT   := AScan( aCPHSCH, {|e| RTrim( e[ 2 ] ) == 'CH_VLRAT' } )
				nCH_CC      := AScan( aCPHSCH, {|e| RTrim( e[ 2 ] ) == 'CH_CC' } )
				nCH_CONTA   := AScan( aCPHSCH, {|e| RTrim( e[ 2 ] ) == 'CH_CONTA' } )
				nCH_ITEMCTA := AScan( aCPHSCH, {|e| RTrim( e[ 2 ] ) == 'CH_ITEMCTA' } )
				nCH_CLVL    := AScan( aCPHSCH, {|e| RTrim( e[ 2 ] ) == 'CH_CLVL' } )
				For nI := 1 To Len( aCPISCH )
					cCH_ITEMPD := aCPISCH[ nI, 1 ]
					For nJ := 1 To Len( aCPISCH[ nI, 2 ] )
						If aCPISCH[ nI, 2, nJ, nCH_PERC ] > 0
							lItemRate := .T.
							If lCount
								If aVar[ 1 ] <> aCPISCH[ nI, 2, nJ, nCH_CC ] .OR. ;
									aVar[ 2 ] <> aCPISCH[ nI, 2, nJ, nCH_CONTA ] .OR. ;
									aVar[ 3 ] <> aCPISCH[ nI, 2, nJ, nCH_ITEMCTA ] .OR. ;
									aVar[ 4 ] <> aCPISCH[ nI, 2, nJ, nCH_CLVL ]
								   
									aVar[ 1 ] := aCPISCH[ nI, 2, nJ, nCH_CC ]
									aVar[ 2 ] := aCPISCH[ nI, 2, nJ, nCH_CONTA ]
									aVar[ 3 ] := aCPISCH[ nI, 2, nJ, nCH_ITEMCTA ]
									aVar[ 4 ] := aCPISCH[ nI, 2, nJ, nCH_CLVL ]
									nQtdeReg++
								Endif
							Else
								AAdd( aRateio, Array( 8 ) )
								nElem := Len( aRateio )
								aRateio[ nElem, 1 ] := cCH_ITEMPD
								aRateio[ nElem, 2 ] := aCPISCH[ nI, 2, nJ, nCH_ITEM ]
								aRateio[ nElem, 3 ] := LTrim( Str( aCPISCH[ nI, 2, nJ, nCH_PERC ], 10, 6 ) )
								aRateio[ nElem, 4 ] := LTrim( Str( aCPISCH[ nI, 2, nJ, nCH_VLRAT ], 9, 2 ) )
								aRateio[ nElem, 5 ] := RTRim(aCPISCH[ nI, 2, nJ, nCH_CC ])
								aRateio[ nElem, 6 ] := RTRim(aCPISCH[ nI, 2, nJ, nCH_CONTA ])
								aRateio[ nElem, 7 ] := RTRim(aCPISCH[ nI, 2, nJ, nCH_ITEMCTA ])
								aRateio[ nElem, 8 ] := RTRim(aCPISCH[ nI, 2, nJ, nCH_CLVL ])
							Endif
						Endif
					Next nJ
				Next nI
				If lCount
					lRet := (nQtdeReg > 0)
					If lRet
						lItemProd := lRet
					Endif
				Endif
			Endif
		Elseif cTab == 'SCH'
			cSQL := "SELECT CH_ITEMPD,CH_ITEM,CH_PERC,CH_VLRAT,CH_CC,CH_CONTA,CH_ITEMCTA,CH_CLVL "
			cSQL += "FROM "+RETSQLNAME("SCH")+" SCH "
			cSQL += "WHERE CH_FILIAL = "+ValToSql( aKey[ 1 ] ) + " "
			cSQL += "AND CH_PEDIDO = "+ValToSql( aKey[ 2 ] ) + " "
			cSQL += "AND CH_PERC > 0 "
			cSQL += "AND SCH.D_E_L_E_T_ = ' ' "
			cSQL := ChangeQuery( cSQL )
			cTRB := GetNextAlias()
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
			If lCount
				While .NOT. (cTRB)->( EOF() )
					lItemRate := .T.
					If aVar[ 1 ] <> (cTRB)->CH_CONTA .OR. ;
						aVar[ 2 ] <> (cTRB)->CH_CC .OR. ;
						aVar[ 3 ] <> (cTRB)->CH_ITEMCTA .OR. ;
						aVar[ 4 ] <> (cTRB)->CH_CLVL
						
						aVar[ 1 ] := (cTRB)->CH_CONTA
						aVar[ 2 ] := (cTRB)->CH_CC
						aVar[ 3 ] := (cTRB)->CH_ITEMCTA
						aVar[ 4 ] := (cTRB)->CH_CLVL
						
						nQtdeReg++
					Endif
					(cTRB)->( dbSkip() )
				End
				lRet := ( nQtdeReg > 1 )
				If lRet
					lItemProd := lRet
				Endif
			Else
				While .NOT. (cTRB)->( EOF() )
					lItemRate := .T.
					//(cTRB)->(AAdd(aRateio,{CH_ITEMPD,CH_ITEM,LTrim(Str(CH_PERC,10,6)),LTrim(Str(CH_VLRAT,9,2)),RTRim(CH_CC),RTRim(CH_CONTA),RTRim(CH_ITEMCTA),RTRim(CH_CLVL)}))
					(cTRB)->(AAdd(aRateio,{CH_ITEMPD,CH_ITEM,CH_PERC,CH_VLRAT,RTRim(CH_CC),RTRim(CH_CONTA),RTRim(CH_ITEMCTA),RTRim(CH_CLVL)}))
					(cTRB)->( dbSkip() )
				End
			Endif
			(cTRB)->( dbCloseArea() )
		Elseif cTab == 'SC7-MEMO' .AND. Type( 'aHeader' ) <> 'U' .AND. Type( 'aCOLS' ) <> 'U'
			If ValType( aHeader ) == 'A' .AND. ValType( aCOLS ) == 'A'
				lItemRate := Iif(lItemRate,lItemRate,.F.)
				AFill( aVar, '' )
				nC7_ITEM    := GdFieldPos('C7_ITEM')
				nC7_TOTAL   := GdFieldPos('C7_TOTAL')
				nC7_CC      := GdFieldPos('C7_CC')
				nC7_CONTA   := GdFieldPos('C7_CONTA')
				nC7_ITEMCTA := GdFieldPos('C7_ITEMCTA')
				nC7_CLVL    := GdFieldPos('C7_CLVL')
				If nC7_ITEM > 0 .AND. nC7_TOTAL > 0 .AND. nC7_CC > 0 .AND. nC7_CONTA > 0 .AND. nC7_ITEMCTA > 0 .AND. nC7_CLVL > 0
					For nI := 1 To Len( aCOLS )
						If .NOT. aCOLS[ nI, Len( aCOLS[ nI ] ) ]
							If aCOLS[ nI, nC7_CC ] <> aVar[ 1 ] .OR. ;
								aCOLS[ nI, nC7_CONTA ] <> aVar[ 2 ] .OR. ;
								aCOLS[ nI, GdFieldPos('C7_ITEMCTA') ] <> aVar[ 3 ] .OR. ;
								aCOLS[ nI, GdFieldPos('C7_CLVL') ] <> aVar[ 4 ]
								
								aVar[ 1 ] := aCOLS[ nI, nC7_CC ]
								aVar[ 2 ] := aCOLS[ nI, nC7_CONTA ]
								aVar[ 3 ] := aCOLS[ nI, nC7_ITEMCTA ]
								aVar[ 4 ] := aCOLS[ nI, nC7_CLVL ]
								
								nQtdeReg++
								
								AAdd(aRateio,{aCOLS[nI,nC7_ITEM],'    ','0.00',LTrim(Str(aCOLS[nI,nC7_TOTAL],12,2)),RTRim(aCOLS[nI,nC7_CC]),;
								RTRim(aCOLS[nI,nC7_CONTA]),RTRim(aCOLS[nI,nC7_ITEMCTA]),RTRim(aCOLS[nI,nC7_CLVL])})
							Endif
						Endif
					Next nI
				Endif
				If lCount
					lRet := ( nQtdeReg > 1 )
					aRateio := {}
				Endif
				If lRet
					lItemProd := lRet
				Endif
			Endif
		Elseif cTab == 'SC7'
			lItemRate := Iif(lItemRate,lItemRate,.F.)
			//----------------------------------------------------------------------------------------------------
			cSqlAll := "SELECT C7_ITEM,C7_TOTAL,C7_CC,C7_CONTA,C7_ITEMCTA,C7_CLVL  "
			//----------------------------------------------------------------------------------------------------
			cSqlCount1 := "SELECT COUNT(*) AS QTDE_REG FROM ( "
			cSqlCount2 := ") TAB_COUNT_CP "
			//----------------------------------------------------------------------------------------------------
			cSqlGroup1 := "SELECT C7_CC, C7_CONTA, C7_ITEMCTA, C7_CLVL "
			cSqlGroup2 := "GROUP BY C7_CC, C7_CONTA, C7_ITEMCTA, C7_CLVL "
			//----------------------------------------------------------------------------------------------------
			cSqlWhere := "FROM "+RETSQLNAME("SC7")+" SC7 "
			cSqlWhere += "WHERE C7_FILIAL = "+ValToSql( aKey[ 1 ] )+" "
			cSqlWhere += "AND C7_NUM = "+ValToSql( aKey[ 2 ] )+" "
			cSqlWhere += "AND C7_CC <> ' ' "
			cSqlWhere += "AND C7_CONTA <> ' ' "
			cSqlWhere += "AND SC7.D_E_L_E_T_ = ' ' "
			//----------------------------------------------------------------------------------------------------
			cSQL := cSqlCount1 + cSqlGroup1 + cSqlWhere + cSqlGroup2 + cSqlCount2
			cSQL := ChangeQuery( cSQL )
			cTRB := "TAB_COUNT_CP"
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
			If (cTRB)->QTDE_REG > 1
				If lCount
					lRet := .T.
				Else
					(cTRB)->( dbCloseArea() )
					cSQL := cSqlAll + cSqlWhere
					cSQL := ChangeQuery( cSQL )
					cTRB := GetNextAlias()
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
					While .NOT. (cTRB)->( EOF() )
						(cTRB)->(AAdd(aRateio,{C7_ITEM,'    ','0.00',LTrim(Str(C7_TOTAL,12,2)),RTRim(C7_CC),RTRim(C7_CONTA),RTRim(C7_ITEMCTA),RTRim(C7_CLVL)}))
						(cTRB)->( dbSkip() )
					End
				Endif
			Endif
			If lRet
				lItemProd := lRet
			Endif
			(cTRB)->( dbCloseArea() )
		Endif
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A610GetApr | Autor | Robson Gonçalves        | Data | 22.03.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para buscar os aprovadores do PC em questão.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610GetApr( cCR_NUM )
	Local cSQL := ''
	Local cAPROV := ''
	Local cTRB := GetNextAlias()
	
	cSQL := "SELECT Upper( AK_NOME ) AS AK_NOME "
	cSQL += "FROM   " + RetSqlName( "SCR" ) + " SCR "
	cSQL += "       INNER JOIN " + RetSqlName( "SAK" ) + " SAK "
	cSQL += "               ON AK_FILIAL = " + ValToSql( xFilial( "SAK" ) ) + " "
	cSQL += "                  AND AK_COD = CR_APROV "
	cSQL += "                  AND SAK.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  CR_FILIAL = " + ValToSql( xFilial( 'SCR' ) ) + " "
	cSQL += "       AND CR_NUM = " + ValToSql( cCR_NUM ) + " "
	cSQL += "       AND CR_TIPO = 'PC' "
	cSQL += "       AND SCR.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY CR_NIVEL "
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
   
	While (cTRB)->( .NOT. EOF() )
		cAPROV += RTrim( (cTRB)->AK_NOME ) + ' - '
		(cTRB)->( dbSkip() )
	End
	cAPROV := SubStr( cAPROV, 1, Len( cAPROV )-3 )
	
	(cTRB)->( dbCloseArea() )
Return( cAPROV )

//--------------------------------------------------------------------------
// Rotina | A610GLTr   | Autor | Robson Gonçalves       | Data | 24.03.2016
//--------------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada MTALCFIM, seu objetivo
//        | é gravar no log a ocorrência de transferência. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610GLTr( cCR_NUM, cTipoDoc )
	If SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == xFilial( 'SCR' ) .AND. RTrim( SCR->CR_NUM ) <> RTrim( cCR_NUM )
		If cTipoDoc == 'PC'
			SCR->( RecLock( 'SCR', .F. ) )
			SCR->CR_LOG := AllTrim( SCR->CR_LOG ) + CRLF + ;
				'Registro gerado pela rotina padrão MaAlcDoc na transferência da alçada para o superior.'
			SCR->( MsUnLock() )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | CSFA610D   | Autor | Robson Gonçalves       | Data | 24.03.2016
//--------------------------------------------------------------------------
// Descr. | Rotina JOB para capturar todas as alçadas sem MailID e reenviar
//        | o WF e logo registrar.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA610D( aParam )
	DEFAULT aParam := { '01', '02' }
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2] MODULO 'COM' TABLES 'SCR', 'SC7', 'SA2', 'SAL', 'SAK', 'CND', 'CNE', 'WF6'
	A610DExec()
	RESET ENVIRONMENT
Return

//--------------------------------------------------------------------------
// Rotina | A610DExec | Autor | Robson Gonçalves         | Data | 24.03.2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar do JOB que captura todas as alçadas sem MailID 
//        | e reenvia o WF e logo registra na SCR.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610DExec()
	Local cTRB := GetNextAlias()
	Local cQuery := ''
	Private cPedCompras := ''
	Private cCSFA610D := 'CSFA610D'
	
	cQuery := " SELECT SCR.CR_FILIAL, "
	cQuery += "        SCR.CR_NUM "
	cQuery += " FROM   " + RetSqlName("SCR")+" SCR"

	//Inner join utilizado para pegar somente itens com capa de despesa aprovado

	cQuery += "        INNER JOIN "+RetSqlName("SCR")+" SCRCD "
	cQuery += "                ON SCR.CR_FILIAL = SCRCD.CR_FILIAL "
	cQuery += "               AND SCR.CR_NUM = SCRCD.CR_NUM "
	cQuery += "               AND SCRCD.CR_TIPO = '#2' "
	cQuery += "               AND SCRCD.CR_STATUS = '03'"
	cQuery += "               AND SCRCD.D_E_L_E_T_ = ' '"
	cQuery += "               AND SCRCD.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE  SCR.D_E_L_E_T_ = ' ' "
	cQuery += "        AND SCR.CR_STATUS = '02' "
	cQuery += "        AND SCR.CR_TIPO = 'PC' "
	cQuery += "        AND SCR.CR_DATALIB = ' ' "
	cQuery += "        AND SCR.CR_MAIL_ID = ' ' "
	cQuery += " GROUP  BY SCR.CR_FILIAL, "
	cQuery += "           SCR.CR_NUM, "
	cQuery += "           SCR.CR_TIPO, "
	cQuery += "           SCR.CR_USER, "
	cQuery += "           SCR.CR_NIVEL, "
	cQuery += "           SCR.CR_APROV, "
	cQuery += "           SCR.CR_STATUS, "
	cQuery += "           SCR.CR_TOTAL, "
	cQuery += "           SCR.CR_EMISSAO, "
	cQuery += "           SCR.CR_MAIL_ID "
	cQuery += " ORDER  BY SCR.CR_USER, SCR.CR_NUM "

	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery ), cTRB, .F., .T. )
   
	While (cTRB)->( .NOT. EOF() )
		cPedCompras := (cTRB)->CR_FILIAL + '-' + RTrim( (cTRB)->CR_NUM )
		U_A610WFPC()
		(cTRB)->( dbSkip() )
	End
	
	(cTRB)->( dbCloseArea() )
Return

//--------------------------------------------------------------------------
// Rotina | A610Company | Autor | Robson Gonçalves       | Data | 04.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina de consulta padrão SXB conforme as filiais no SIGAMAT.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
STATIC _CGCFILENT_
User Function A610Company()
	Local oDlg
	Local oLbx
	Local oPanel
	Local oCancel
	Local oConfirm
	
	Local lRet := .F.
	
	Local nI := 0
	Local nCol := 0
	Local nPos := 0
	Local bRet := {|| lRet := .T., nPos := oLbx:nAt, oDlg:End() }
	
	Local aFil := {}
	Local aArea := { GetArea(), SM0->( GetArea() ) }
	
	Local cMV_610FILI := 'MV_610FILI'
	
	If Len( a610CNPJ ) == 0
		If .NOT. GetMv( cMV_610FILI, .T. )
			CriarSX6( cMV_610FILI, 'C', 'FILIAIS QUE PARTICIPAM DA CAPA DE DESPESA PARA INFORMAR O CNPJ DE ENTREGA - ROTINA CSFA610.prw', '01|02|03|04|05|09|11|12|13|14' )
		Endif
		
		aFil := StrToKarr( GetMv( cMV_610FILI, .F. ), '|' )
		aSort( aFil,,,{|a,b| a < b } )
		
		SM0->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aFil )
			SM0->( dbSeek( '01' + aFil[ nI ] ) )
			SM0->( AAdd( a610CNPJ, { TransForm( M0_CGC, '@R 99.999.999/9999-99' ), M0_FILIAL, M0_CODFIL, M0_CGC } ) )
		Next nI
		AEval( aArea, {|xArea| RestArea( xArea ) } )
	Endif
	
	If Len( a610CNPJ ) > 0
		DEFINE MSDIALOG oDlg TITLE 'Selecione a Filial Certisign' FROM 0,0 TO 240,570 OF oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
			
		oLbx := TwBrowse():New(38,3,250,80,,{'CNPJ','Nome Filial','Nº Filial'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oLbx:SetArray( a610CNPJ )
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:bLine := {|| AEval( a610CNPJ[ oLbx:nAt ],{|cValue,nIndex| a610CNPJ[ oLbx:nAt,nIndex ] } ) }
		oLbx:BlDblClick := bRet

		oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanel:Align := CONTROL_ALIGN_BOTTOM
		nCol := ((oPanel:oParent:nWidth/2)-4)-(40+3+40)
			//       |                          |  |  | |
			//       +-------------+------------+  |  | +---> tamanho do botão 1.
			//                     |               |  +-----> espaço entre os botões 1 e 2.
			//                     |               +--------> tamanho do botão 2.
			//                     +------------------------> área onde será colocado o botão
			
		If .NOT. Empty( M->C7_CNPJ )
			nI := AScan( a610CNPJ, {|e| e[ 3 ] == M->C7_FILENT } )
			If nI > 0
				oLbx:nAt := nI
				oLbx:Refresh()
			Endif
		Endif

		@ 1,nCol    BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanel ACTION Eval( bRet )
		@ 1,nCol+43 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanel ACTION ( lRet := .F. , oDlg:End())
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If lRet
			M->C7_FILENT := a610CNPJ[ nPos, 3 ]
			_CGCFILENT_  := a610CNPJ[ nPos, 4 ]
			M->C7_CNPJ   := _CGCFILENT_
		Else
			M->C7_FILENT := SM0->M0_CODFIL
			_CGCFILENT_  := Space( Len( SC7->C7_CNPJ ) )
			M->C7_CNPJ   := _CGCFILENT_
		Endif
	Else
		MsgInfo( cALERT + 'Não localizei as filiais para apresentar.' + cNOFONT, 'Filiais Certisign' )
	Endif
Return(.T.)

//--------------------------------------------------------------------------
// Rotina | A610RetComp | Autor | Robson Gonçalves       | Data | 04.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para retornar a variável encapsulada para o SXB.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610RetComp()
Return( _CGCFILENT_ )

//--------------------------------------------------------------------------
// Rotina | A610NomFil | Autor | Robson Gonçalves        | Data | 05.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para trazer o nome da filial de entrega.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610NomFil( cSucursal, lCNPJ )
	Local cRet := ''
	Local nRec := 0
	DEFAULT lCNPJ := .F.
	If SM0->M0_CODIGO == cEmpAnt .AND. SM0->M0_CODFIL == cSucursal
		If lCNPJ
			cRet := TransForm( SM0->M0_CGC, '@R 99.999.999/9999-99' )
		Else
			cRet := RTrim( SM0->M0_FILIAL )
		Endif
	Else
		nRec := SM0->( RecNo() )
		SM0->( dbSeek( cEmpAnt + cSucursal ) )
		If lCNPJ
			cRet := TransForm( SM0->M0_CGC, '@R 99.999.999/9999-99' )
		Else
			cRet := RTrim( SM0->M0_FILIAL )
		Endif
		SM0->( dbGoTo( nRec ) )
	Endif
Return( cRet )

//--------------------------------------------------------------------------
// Rotina | CSFA610E | Autor | Bruno Nunes               | Data | 05.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina JOB para buscar os pedido de compras em aberto, não apro-
//        | vados e com vencimento próximo, conforme parâmetro.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA610E( aParam )
	Local cMV610_011 := 'MV_610_011'
	
	DEFAULT aParam := {'01','02'}

	// Configura parametros se estiver vazio.
	If Len( aParam ) == 0
		AAdd( aParam, '01')
		AAdd( aParam, '02')
	Endif

	// Configurar ambiente.
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2] MODULO 'COM' TABLES 'SCR', 'SC7'
	Conout('* Início do processo JOB para buscar PC em aberto e a vencer.')
	Conout('* Data: ' + Dtoc(MsDate()) + ' Hora: ' + Time() + '.')

	If .NOT. GetMv( cMV610_011, .T. )
		CriarSX6( cMV610_011, 'N','HABILITAR O USO DA ROTINA PC EM ABERTO E A VENCER 1=CAPA DE DESPESA OU 2=SEM CAPA DE DESPESA. ROTINA CSFA610.prw.', '1' )
	Endif
		
	cMV610_011 := GetMv( cMV610_011, .F. )
	Conout('* Parâmetro MV_610_011 = ' + LTrim( Str( cMV610_011 ) ) + '.' )
		
	If     cMV610_011 == 1 ; A610EProc()	// Rotina antiga que considera aprovação da capa de despesa.
	Elseif cMV610_011 == 2 ; A610EProc2()	// Rotina nova não considera a aprovação da capa de despesa - out/2016.
	Endif
		
	Conout('* Data: ' + Dtoc(MsDate()) + ' Hora: ' + Time() + '.')
	Conout('* Fim do processo JOB para buscar PC em aberto e a vencer.')
	RESET ENVIRONMENT
Return

//--------------------------------------------------------------------------
// Rotina | A610EProc | Autor | Bruno Nunes              | Data | 05.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para buscar os pedido de compras em aberto, não aprovados
//        | e com vencimento próximo, conforme parâmetro.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610EProc()
	Local aNomeAprov := {}
	Local cBgCol := ''
	Local cC7_FORNEC := ''
	Local cC7_NUM := ''
	Local cC7_TOTAL := ''
	Local cC7_XVENCTO := ''
	Local cCR_USER := ''
	Local cDtFim := ''
	Local cDtIni := ''
	Local cHTML := ''
	Local cMV_DIAS := 'MV_610MPFD'
	Local cMV_MAIL_ENV := 'MV_610MPFF'
	Local cNomeAprov := ''
	Local cOsAprovad := ''
	Local cQuery := ''
	Local cTRB := ''
	
	Local nP := 0
	Local nPos := ''
	Local nRec := 0

	dbSelectArea( 'SCR' )
	
	If .NOT. GetMv( cMV_MAIL_ENV, .T. )
		CriarSX6( cMV_MAIL_ENV, 'C', 'EMAIL PARA ENVIO DE AVISO DE VENCIMENTO DE PEDIDO DE COMPRA. Rotina: CSFA610.prw', 'ctapag@certisign.com.br; plan.financeiro@certisign.com.br; sistemascorporativos@certisign.com.br' )
	Endif
	
	cMV_MAIL_ENV := GetMv( cMV_MAIL_ENV, .F. )

	If .NOT. GetMv( cMV_DIAS, .T. )
		CriarSX6( cMV_DIAS, 'N', 'QUANTIDADE DE DIAS QUE O SISTEMA VERIFICARA O VENCIMENTO COM ANTECEDENCIA CSFA610.prw', '3' )
	Endif
	
	cMV_DIAS := GetMv( cMV_DIAS, .F. )

	//Define periodo de vencimento
	cDtIni := DtoS(MsDate())
	cDtFim := DtoS(MsDate()+cMV_DIAS)

	cQuery := " SELECT * FROM ( "
	cQuery += " SELECT "
	cQuery += " SCR.CR_FILIAL  "
	cQuery += " , SCR.CR_NUM  "
	cQuery += " , SCR.CR_USER  "
	cQuery += " , SC7.C7_XVENCTO "
	cQuery += " , SCR.CR_TOTAL "
	cQuery += " , SA2.A2_NOME "
	cQuery += " FROM  "+RetSqlName("SCR")+" SCR "
	cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 ON "
	cQuery += " SC7.D_E_L_E_T_ = ' '  "
	cQuery += " AND SC7.C7_FILIAL = SCR.CR_FILIAL "
	cQuery += " AND SC7.C7_NUM =  SCR.CR_NUM "
	cQuery += " AND SC7.C7_XVENCTO BETWEEN  '"+cDtIni+"' AND '"+cDtFim+"' "
	cQuery += " LEFT JOIN "+RetSqlName("SA2")+" SA2 ON "
	cQuery += " SA2.D_E_L_E_T_ = ' '  "
	cQuery += " AND SC7.C7_LOJA=  SA2.A2_LOJA "
	cQuery += " AND SC7.C7_FORNECE =SA2.A2_COD "
	cQuery += " WHERE  "
	cQuery += " SCR.D_E_L_E_T_ = ' '  "
	cQuery += " AND SCR.CR_TIPO = 'PC'  "
	cQuery += " AND SCR.CR_STATUS = '02'  "
	cQuery += " AND SCR.CR_DATALIB = ' '  "
	cQuery += " GROUP BY  "
	cQuery += " SCR.CR_FILIAL  "
	cQuery += " , SCR.CR_NUM  "
	cQuery += " , SCR.CR_USER  "
	cQuery += " , SC7.C7_XVENCTO "
	cQuery += " , SCR.CR_TOTAL "
	cQuery += " , SA2.A2_NOME "
	cQuery += " UNION "

	//Segunda condicao
	cQuery += " SELECT  "
	cQuery += " SCR.CR_FILIAL  "
	cQuery += " , SCR.CR_NUM  "
	cQuery += " , SCR.CR_USER  "
	cQuery += " , SC7.C7_XVENCTO "
	cQuery += " , SCR.CR_TOTAL "
	cQuery += " , SA2.A2_NOME "
	cQuery += " FROM  "+RetSqlName("SCR")+" SCR "
	cQuery += " INNER JOIN "+RetSqlName("SCR")+" SCRCD ON "
	cQuery += " SCR.CR_FILIAL = SCRCD.CR_FILIAL  "
	cQuery += " AND SCR.CR_NUM = SCRCD.CR_NUM  "
	cQuery += " AND SCRCD.CR_TIPO = '#2'  "
	cQuery += " AND SCRCD.CR_STATUS = '03' "
	cQuery += " AND SCRCD.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 ON "
	cQuery += " SC7.D_E_L_E_T_ = ' '  "
	cQuery += " AND SC7.C7_FILIAL = SCR.CR_FILIAL "
	cQuery += " AND SC7.C7_NUM =  SCR.CR_NUM "
	cQuery += " AND SC7.C7_XVENCTO BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
	cQuery += " LEFT JOIN "+RetSqlName("SA2")+" SA2 ON "
	cQuery += " SA2.D_E_L_E_T_ = ' '  "
	cQuery += " AND SC7.C7_LOJA =  SA2.A2_LOJA "
	cQuery += " AND SC7.C7_FORNECE = SA2.A2_COD "
	cQuery += " WHERE  "
	cQuery += " SCR.D_E_L_E_T_ = ' '  "
	cQuery += " AND SCR.CR_TIPO = 'PC'  "
	cQuery += " AND SCR.CR_STATUS = '02'  "
	cQuery += " AND SCR.CR_DATALIB = ' '  "
	cQuery += " GROUP BY  "
	cQuery += " SCR.CR_FILIAL  "
	cQuery += " , SCR.CR_NUM  "
	cQuery += " , SCR.CR_USER  "
	cQuery += " , SC7.C7_XVENCTO "
	cQuery += " , SCR.CR_TOTAL "
	cQuery += " , SA2.A2_NOME "
	cQuery += " ) RESULT "
	cQuery += " ORDER BY 1, 2 "

	//Executa consulta SQL
	cTRB := GetNextAlias()
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cTRB, .F., .T.)
	Count To nRec
	(cTRB)->( dbGoTop() )
	
	If nRec > 0
		cHTML := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
		cHTML += '<html>'
		cHTML += '	<head>'
		cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
		cHTML += '		<title>Status de Aprova&ccedil;&atilde;o da capa de despesa</title>'
		cHTML += '	</head>'
		cHTML += '	<body>'
		cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
		cHTML += '			<tbody>'
		cHTML += '				<tr>'
		cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle">'
		cHTML += '						<em><span style="font-size:20px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>Aviso de vencimento PC</strong></font></span><br />'
		cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em>'
		cHTML += '						<p>'
		cHTML += '							&nbsp;</p>'
		cHTML += '					</td>'
		cHTML += '					<td align="right" width="210">'
		cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
		cHTML += '						&nbsp;</td>'
		cHTML += '				</tr>'
		cHTML += '				<tr>'
		cHTML += '					<td bgcolor="#F4811D" colspan="2" height="4" width="0">'
		cHTML += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
		cHTML += '				</tr>'
		cHTML += '				<tr>'
		cHTML += '					<td colspan="2" style="padding:5px;" width="0">'
		cHTML += '						<p>'
		cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Prezado(s),</font></span></span></p>'
		cHTML += '						<p>'

		If nRec == 1
			cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Foi identificado o pedido de compras abaixo com data de vencimento próximo de vencer, logo este pedido não está com sua devida aprovação na respectiva alçada. Por favor, verifique os pedidos de compras.</font></span></span></p>'
		Else
			cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Foram identificados os pedidos de compras abaixo com data de vencimento pr&oacute;ximo de vencer, logo estes pedidos não estão com suas devidas aprova&ccedil;&otilde;es nas respectivas al&ccedil;adas. Por favor, verifique os pedidos de compras.</font></span></span></p>'
		Endif

		cHTML += '						<p>'
		cHTML += '<table style="width:100%"  border="0" cellpadding="0" cellspacing="0">'
		cHTML += '	<thead>'
		cHTML += '		<tr>'
		cHTML += '			<th bgcolor="#F4811D" align="left" style="padding-left:5px" >'
		cHTML += '				<font color="#ffffff face="Arial, Helvetica, sans-serif" size="2">Nº PC</font>'
		cHTML += '			</th>'
		cHTML += '			<th bgcolor="#F4811D" align="center" style="padding-left:5px" >'
		cHTML += '				<font color="#ffffff face="Arial, Helvetica, sans-serif" size="2">Vencimento</font>'
		cHTML += '			</th>'
		cHTML += '			<th bgcolor="#F4811D" align="right" style="padding-left:5px" >'
		cHTML += '				<font color="#ffffff face="Arial, Helvetica, sans-serif" size="2">Valor</font>'
		cHTML += '			</th>'
		cHTML += '			<th bgcolor="#F4811D" align="left" style="padding-left:10px" >'
		cHTML += '				<font color="#ffffff face="Arial, Helvetica, sans-serif" size="2">Fonercedor</font>'
		cHTML += '			</th>'
		cHTML += '			<th bgcolor="#F4811D" align="left" style="padding-left:10px" >'
		cHTML += '				<font color="#ffffff face="Arial, Helvetica, sans-serif" size="2">Aprovador</font>'
		cHTML += '			</th>'
		cHTML += '		</tr>'
		cHTML += '	</thead>'
		
		While (cTRB)->( .NOT. EOF() )
			If cC7_NUM <> ''
				If cC7_NUM <> (cTRB)->CR_FILIAL + '-' + RTrim( (cTRB)->CR_NUM )
					cBgCol := Iif( cBgCol == 'bgcolor="#DCDCDC"', 'bgcolor="#FFFFFF"', 'bgcolor="#DCDCDC"')
					cHTML += A610MontLin( cBgCol, cC7_NUM, cC7_XVENCTO, cC7_TOTAL, cOsAprovad, cC7_FORNEC )
					cOsAprovad := ''
				Endif
			Endif
			
			nP := AScan( aNomeAprov, {|e| e[ 1 ] == (cTRB)->CR_USER } )
			
			If nP == 0
				AAdd( aNomeAprov ,{ (cTRB)->CR_USER, RTrim( UsrFullName( (cTRB)->CR_USER ) ) } )
				nP := Len( aNomeAprov )
			Endif
			
			cNomeAprov  := aNomeAprov[ nP, 2 ]
			
			cC7_NUM     := (cTRB)->CR_FILIAL + '-' + RTrim( (cTRB)->CR_NUM )
			cC7_XVENCTO := Dtoc( Stod( (cTRB)->C7_XVENCTO ) )
			cC7_TOTAL   := Transform((cTRB)->CR_TOTAL, '@E 999,999,999.99')
			cC7_FORNEC  := PadR( (cTRB)->A2_NOME, 40 )
						
			If .NOT. Empty( cOsAprovad )
				cOsAprovad += ', '
			Endif
			
			nPos := At( ' ', cNomeAprov )
			
			If nPos > 0
				cOsAprovad += Capital( SubStr( cNomeAprov, 1, nPos-1 ) )
			Else
				cOsAprovad += Capital( cNomeAprov )
			Endif
			
			(cTRB)->( dbSkip() )
		End
		
		If cC7_NUM <> ''
			cBgCol := Iif( cBgCol == 'bgcolor="#DCDCDC"', 'bgcolor="#FFFFFF"', 'bgcolor="#DCDCDC"')
			cHTML += A610MontLin( cBgCol, cC7_NUM, cC7_XVENCTO, cC7_TOTAL, cOsAprovad, cC7_FORNEC )
		Endif
		
		(cTRB)->( dbCloseArea() )
		
		cHTML += '	</table>'
		cHTML += '					</td>'
		cHTML += '				</tr>'
		cHTML += '				<tr>'
		cHTML += '					<td bgcolor="#02519B" colspan="2" height="2" width="0">'
		cHTML += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
		cHTML += '				</tr>'
		cHTML += '				<tr>'
		cHTML += '					<td colspan="2" style="padding:5px" width="0">'
		cHTML += '						<p align="left">'
		cHTML += '							<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
		cHTML += '					</td>'
		cHTML += '				</tr>'
		cHTML += '			</tbody>'
		cHTML += '		</table>'
		cHTML += '		<p>'
		cHTML += '			&nbsp;</p>'
		cHTML += '	</body>'
		cHTML += '</html>'

		FsSendMail( cMV_MAIL_ENV, 'Aviso de vencimento de PC', cHTML )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610MontLin | Autor | Bruno Nunes            | Data | 05.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para montar as linhas com os dados do pedido encontrado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610MontLin( cBgCol, cC7_NUM, cC7_XVENCTO, cC7_TOTAL, cNome, cC7_FORNEC)
	Local cHTML := ''
	cHTML := '<tr>'
	cHTML += '<td '+cBgCol+' align="left"  style="padding-left:5px">'
	cHTML += '	<font color="#333333 face="Arial, Helvetica, sans-serif" size="2">' + cC7_NUM + '</font>'
	cHTML += '</td>'
	cHTML += '<td '+cBgCol+'  align="center"  style="padding-left:5px">'
	cHTML += '	<font color="#333333 face="Arial, Helvetica, sans-serif" size="2">' + cC7_XVENCTO + '</font>'
	cHTML += '</td>'
	cHTML += '<td '+cBgCol+'  align="right"  style="padding-left:5px">'
	cHTML += '	<font color="#333333 face="Arial, Helvetica, sans-serif" size="2">' + cC7_TOTAL + '</font>'
	cHTML += '</td>'
	cHTML += '<td '+cBgCol+'  align="left"  style="padding-left:10px">'
	cHTML += '	<font color="#333333 face="Arial, Helvetica, sans-serif" size="2">' + cC7_FORNEC + '</font>'
	cHTML += '</td>'
	cHTML += '<td '+cBgCol+'  align="left"  style="padding-left:10px">'
	cHTML += '	<font color="#333333 face="Arial, Helvetica, sans-serif" size="2">' + cNome + '</font>'
	cHTML += '</td>'
	cHTML += '</tr>'
Return( cHTML )

//--------------------------------------------------------------------------
// Rotina | CSFA610F | Autor | Bruno Nunes               | Data | 24/05/2016
//--------------------------------------------------------------------------
// Descr. | Rotina JOB para ajustar registro do voucher F.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA610F( aParam )
	Default aParam := {'01', '02'}

	//configura parametros se estiver vazio
	If Len( aParam ) == 0
		AAdd( aParam, '01')
		AAdd( aParam, '02')
	Endif

	//configurar ambiente
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2] MODULO 'FIN' TABLES 'SC5', 'SE1', 'SZG'
	U_A610OnMsg()
	A610FProc()
	RESET ENVIRONMENT
Return

//--------------------------------------------------------------------------
// Rotina | A610FProc | Autor | Robson Gonçalves         | Data | 24/05/2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar do JOB que ajusta os registros de voucher F.
//        | Ressaltasse que o nome da tabela está fixo e a filial também, 
//        | pois o faturamento sempre é pela filial 02 na empresa 01, logo
//        | o financeiro é compartilhado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610FProc()
	Local cSQL := ''
	Local nXnumVou := TamSX3("E1_XNUMVOU")[1]

	cSQL := "DECLARE "
	cSQL += "	CURSOR MY_CURSOR1 IS "
	cSQL += "		SELECT 	ZG_NUMVOUC, "
	cSQL += "					ZG_CODFLU, "
	cSQL += "					C5.R_E_C_N_O_ "
	cSQL += "		FROM 		PROTHEUS.SZG010 ZG "
	cSQL += "					LEFT JOIN PROTHEUS.SC5010 C5 "
	cSQL += "							 ON ZG_FILIAL = '  ' "
	cSQL += "							AND C5_FILIAL = "+ValToSql(xFilial("SC5"))+" "
	cSQL += "							AND ((ZG_NUMPED > ' ' AND ZG_NUMPED = C5_CHVBPAG) "
	cSQL += "							 OR (ZG_PEDSITE > ' ' AND (ZG_PEDSITE = C5_XNPSITE OR ZG_PEDSITE = C5_NUM)) ) "
	cSQL += "							AND ZG.D_E_L_E_T_ = ' ' "
	cSQL += "							AND C5.D_E_L_E_T_ = ' ' "
	cSQL += "							AND (ZG_CODFLU <> C5_XFLUVOU OR ZG_NUMVOUC <> C5_XNUMVOU) "
	cSQL += "		WHERE ZG_CODFLU <> '0000001' "
	cSQL += "				AND ZG_ROTINA <> 'M460FIM' "
	cSQL += "				AND C5_EMISSAO >= '20150101'; "
	cSQL += "BEGIN "
	cSQL += "	FOR REG_MY_CURSOR IN MY_CURSOR1 LOOP "
	cSQL += "		UPDATE SC5010 SC5 "
	cSQL += "		SET    C5_XNUMVOU = REG_MY_CURSOR.ZG_NUMVOUC, "
	cSQL += "		       C5_XFLUVOU =  REG_MY_CURSOR.ZG_CODFLU "
	cSQL += "		WHERE  SC5.R_E_C_N_O_ = REG_MY_CURSOR.R_E_C_N_O_; "
	cSQL += "		COMMIT; "
	cSQL += "	END LOOP; "
	cSQL += "END; "
	
	If TCSQLExec( cSQL ) < 0
		CONOUT("ROTINA CSFA610F - 1º TCSQLError() " + TCSQLError())
	Else
		CONOUT("1º ROTINA CSFA610F EXECUTADA COM SUCESSO - DATA " + Dtoc( MsDate() ) + "HORA " + Time() )
	Endif
	
	cSQL := "DECLARE "
	cSQL += "   CURSOR MY_CURSOR2 IS "
	cSQL += "      SELECT C5_XNUMVOU, "
	cSQL += "             C5_XFLUVOU, "
	cSQL += "             E1.R_E_C_N_O_ "
	cSQL += "        FROM PROTHEUS.SC5010 C5 "
	cSQL += "        INNER JOIN PROTHEUS.SE1010 E1 "
	cSQL += "                ON C5_FILIAL = "+ValToSql(xFilial("SC5"))+" "
	cSQL += "                   AND E1_FILIAL = '  ' "
	cSQL += "                   AND C5_EMISSAO >= '20150101' "
	cSQL += "                   AND C5_TIPMOV = '6' "
	cSQL += "                   AND E1_PEDIDO = C5_NUM "
	cSQL += "                   AND E1.D_E_L_E_T_ = ' ' "
	cSQL += "                   AND C5.D_E_L_E_T_ = ' ' "
	cSQL += "                   AND ( E1_XFLUVOU <> C5.C5_XFLUVOU "
	cSQL += "                          OR E1_XNUMVOU <> C5.C5_XNUMVOU ); "
	cSQL += "BEGIN "
	cSQL += "   FOR REG_MY_CURSOR IN MY_CURSOR2 LOOP "
	cSQL += "      UPDATE PROTHEUS.SE1010 SE1 "
	cSQL += "      SET    SE1.E1_XNUMVOU = SUBSTR(REG_MY_CURSOR.C5_XNUMVOU,1,"+cValTochar(nXnumVou)+"),"
	cSQL += "             SE1.E1_XFLUVOU = REG_MY_CURSOR.C5_XFLUVOU "
	cSQL += "      WHERE  SE1.R_E_C_N_O_ = REG_MY_CURSOR.R_E_C_N_O_; "
	cSQL += "      COMMIT; "
	cSQL += "   END LOOP; "
	cSQL += "END; "
	
	If TCSQLExec( cSQL ) < 0
		CONOUT("ROTINA CSFA610F - 2º TCSQLError() " + TCSQLError())
	Else
		CONOUT("2º ROTINA CSFA610F EXECUTADA COM SUCESSO - DATA " + Dtoc( MsDate() ) + "HORA " + Time() )
	Endif

	cSQL := "DECLARE "
	cSQL += "   CURSOR my_cursor3 IS "
	cSQL += "      SELECT SE1.R_E_C_N_O_, "
	cSQL += "             SC5.C5_XFLUVOU "
	cSQL += "      FROM   SE1010 SE1 "
	cSQL += "             INNER JOIN SC5010 SC5 "
	cSQL += "                     ON C5_XNUMVOU = E1_XNUMVOU "
	cSQL += "                        AND C5_XFLUVOU <> ' ' "
	cSQL += "                        AND SC5.D_E_L_E_T_ = ' ' "
	cSQL += "      WHERE  E1_XNUMVOU <> ' ' "
	cSQL += "             AND E1_XFLUVOU = ' ' "
	cSQL += "             AND SE1.D_E_L_E_T_ = ' '; "
	cSQL += "BEGIN "
	cSQL += "   FOR reg_my_cursor IN my_cursor3 LOOP "
	cSQL += "      UPDATE SE1010 E1 "
	cSQL += "      SET    E1.E1_XFLUVOU = reg_my_cursor.C5_XFLUVOU "
	cSQL += "      WHERE  E1.R_E_C_N_O_ = reg_my_cursor.R_E_C_N_O_; "
	cSQL += "      COMMIT; "
	cSQL += "   END LOOP; "
	cSQL += "END; "

	If TCSQLExec( cSQL ) < 0
		CONOUT("ROTINA CSFA610F - 3º TCSQLError() " + TCSQLError())
	Else
		CONOUT("3º ROTINA CSFA610F EXECUTADA COM SUCESSO - DATA " + Dtoc( MsDate() ) + "HORA " + Time() )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610Lib | Autor | Robson Gonçalves           | Data | 17.05.2016
//--------------------------------------------------------------------------
// Descr. | Rotina executada pelos pontos de entradas MT097LOK e MT097SOK,
//        | o objetivo é permitir o usuário aprovar/rejeitar o documento da
//        | alçada dele depois da aprovação do Planejamento Financeiro.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Lib()
	Local aArea := {}
	Local cAK_NOME := ''
	Local cCR_FILIAL := SCR->CR_FILIAL
	Local cCR_LOG := ''
	Local cCR_NUM := SCR->CR_NUM
	Local cEMail := ''
	Local cMsg := ''
	Local cMV610_001 := 'MV_610_001'
	Local cMV610_003 := 'MV_610_003'
	Local cMV_610PFIN := ''
	Local cSQL := ''
	Local cTRB := ''
	Local cUser := RTrim(UsrFullName(RetCodUsr()))
	Local lRet := .T.
	
	If SCR->CR_TIPO <> 'PC'
		Return( lRet )
	Endif
	
	aArea := SCR->( GetArea() )

	cMV610_001 := 'MV_610_001'
	cMV_610PFIN := 'MV_610PFIN'

	cSQL := "SELECT COUNT(*) AS nCOUNT "
	cSQL += "FROM   "+RetSqlName("SCR")+" SCR "
	cSQL += "WHERE  CR_FILIAL = "+ValToSql( cCR_FILIAL )+" "
	cSQL += "       AND CR_NUM = "+ValToSql( cCR_NUM )+" "
	cSQL += "       AND CR_TIPO = "+ValToSql( cTP_DOC )+" "
	cSQL += "       AND CR_STATUS <> '03' "
	cSQL += "       AND SCR.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	
	If (cTRB)->nCOUNT > 0
		MsgAlert(cALERT+'Atenção'+cFONT+;
			'<br><br>É necessário aprovação primeiro pela equipe do Planejamento Financeiro,<br>'+;
			'em seguida você poderá agir sobre este documento.'+cNOFONT,'Aprovação de documentos')
		
		If .NOT. GetMv( cMV610_001, .T. )
			CriarSX6( cMV610_001, 'C', ;
				'HABILITAR AVISO AO PLANEJ.FINANC.QUE HA PENDENCIA DE APROV.DA C.DE DESPESA. 0=DESABILITADO E 1=HABILITADO - ROT CSFA610.prw',;
				'0' )
		Endif
		
		If GetMv( cMV610_001, .F. ) == '1'
			cMsg := 'Equipe Planejamento Financeiro, '+CRLF+CRLF
			cMsg += 'O aprovador '+cUser+' tentou aprovar o pedido de compras nº '+cCR_FILIAL+'-'+RTrim(cCR_NUM)+'. '
			cMsg += 'Não foi possível ele concluir porque este documento está pendente de aprovação por vocês. '+CRLF+CRLF
			cMsg += 'Atenciosamente,'+CRLF+CRLF
			cMsg += 'Sistemas Corporativos.'
			cMV_610PFIN := GetMv( cMV_610PFIN, .F. )
			cEMail := A610UsrPF( cMV_610PFIN )
			FSSendMail( cEMail, 'Pendência - Aprovar Capa de Despesa nº '+cCR_FILIAL + '-' + cCR_NUM, cMsg, /*cAnexo*/ )
		Endif
		
		lRet := .F.
	Endif
	
	(cTRB)->( dbCloseArea() )
	SCR->( RestArea( aArea ) )
		
	// Avaliar se o usuário pode fazer aprovação, 
	// póis dependendo da configuração dele no grupo ele pode ignorar as alçadas dos demais aprovadores.
	If 'NÃO_ENTRAR_AQUI' == '...NAOENTRARAQUI...'
		cSQL := "SELECT CR_APROV, "
		cSQL += "       CR_USER, "
		cSQL += "       AK_NOME, "
		cSQL += "       COUNT(*) AS nCOUNT "
		cSQL += "FROM   "+RetSqlName("SCR")+" SCR "
		cSQL += "       INNER JOIN "+RetSqlName('SAK')+" SAK "
		cSQL += "               ON AK_FILIAL = "+ValToSql(xFilial('SAK'))+" "
		cSQL += "                  AND AK_COD = CR_APROV "
		cSQL += "                  AND SAK.D_E_L_E_T_ = ' ' "
		cSQL += "WHERE  CR_FILIAL = "+ValToSql( cCR_FILIAL )+" "
		cSQL += "       AND CR_NUM = "+ValToSql( cCR_NUM )+" "
		cSQL += "       AND CR_TIPO = 'PC' "
		cSQL += "       AND CR_STATUS = '02' "
		cSQL += "       AND SCR.D_E_L_E_T_ = ' ' "
		cSQL += "GROUP  BY  CR_APROV, "
		cSQL += "           CR_USER, "
		cSQL += "           AK_NOME "
		
		cSQL := ChangeQuery( cSQL )
		cTRB := GetNextAlias()
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
		
		If (cTRB)->nCOUNT > 0 .AND. (cTRB)->CR_USER <> RetCodUsr()
			cAK_NOME := RTrim((cTRB)->AK_NOME)
			
			cMsg := cALERT + 'Atenção' + cFONT
			cMsg += '<br><br>Este pedido de compra está pendente de liberação pelo usuário '+cAK_NOME+'.<br> '
			cMsg += 'Se você aprovar este pedido de compra, estará ignorando o fluxo de aprovação dos níveis abaixo de sua alçada.<br><br>'
			cMsg += 'Deseja continuar com esta ação?'+cNOFONT
			
			If .NOT. MsgYesNo( cMsg, 'Aprovação de documentos' )
				lRet := .F.
			Else
				If .NOT. GetMv( cMV610_003, .T. )
					CriarSX6( cMV610_003, 'C', ;
						'HABILITAR AVISO AO PLANEJ.FINANC.QUE APROVADOR IGNOROU O FLUXO DE APROVACAO. 0=DESABILITADO E 1=HABILITADO - ROT CSFA610.prw',;
						'1' )
				Endif
				
				If GetMv( cMV610_003, .F. ) == '1'
					cMsg := 'Equipe Planejamento Financeiro, '+CRLF+CRLF
					cMsg += 'O aprovador '+cUser+' aprovou o pedido de compras nº '+cCR_FILIAL+'-'+RTrim(cCR_NUM)+'. '+CRLF
					cMsg += 'Pode ser que esta ação ignore o fluxo de aprovação dos níveis abaixo de sua alçada.'+CRLF
					cMsg += 'Ressalta-se ainda que esta ação foi registrado no log de aprovação.'+CRLF+CRLF
					cMsg += 'Atenciosamente,'+CRLF+CRLF
					cMsg += 'Sistemas Corporativos.'
					
					cMV_610PFIN := GetMv( cMV_610PFIN, .F. )
					cEMail := A610UsrPF( cMV_610PFIN )
					
					FSSendMail( cEMail, 'Fluxo de aprovação ignorado do Pedido de Compras nº '+cCR_FILIAL + '-' + RTrim(cCR_NUM), cMsg, /*cAnexo*/ )
				Endif
			Endif
		Endif
		(cTRB)->( dbCloseArea() )
		SCR->( RestArea( aArea ) )
		If SCR->( MsRLock( RecNo() ) )
			SCR->( RecLock( 'SCR', .F. ) )
			If .NOT. Empty( SCR->CR_LOG )
				cCR_LOG := RTrim( SCR->CR_LOG ) + CRLF
			Endif
			SCR->CR_LOG := cCR_LOG + 'Esta alçada estava pendende de liberação pelo usuário ' +cAK_NOME + ;
				', logo o aprovador ' + cUser + ' aprovou e isto pode ter ignorado o fluxo de aprovação dos níveis abaixo da sua alçada. Data '+;
				Dtoc( MsDate() ) + ' ' + Time() + '.'
			SCR->( MsUnLock() )
		Endif
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A610AvUs | Autor | Robson Gonçalves          | Data | 18.05.2016
//--------------------------------------------------------------------------
// Descr. | Rotina executada pelo ponto de entrada MT097END o objetivo é 
//        | informar o planejamento financeiro que o aprovador agiu no PC
//        | por meio do sistema e não por meio de WF.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610AvUs( aParam, cAcao, cAssunto )
	Local aDados := {}
	Local aMsg := {}
	Local cMV610_001 := 'MV_610_001'
	//aParam[ 1 ] - CR_NUM
	//aParam[ 2 ] - CR_TIPO
	//aParam[ 3 ] - nOpc
	//aParam[ 4 ] - CR_FILIAL
	If .NOT. GetMv( cMV610_001, .T. )
		CriarSX6( cMV610_001, 'C', ;
			'HABILITAR AVISO AO PLANEJ.FINANC.QUE HA PENDENCIA DE APROV.DA C.DE DESPESA. 0=DESABILITADO E 1=HABILITADO - ROT CSFA610.prw',;
			'0' )
	Endif
	If GetMv( cMV610_001, .F. ) == '1'
		aMsg := { aParam[ 4 ] + '-' + RTrim( aParam[ 1 ] ), cAcao, Dtoc( MsDate() ), Time(), 'Ação efetuada manualmente via Protheus.' }
		aDados := { 'Senhores,', A610UsrPF( GetMv( 'MV_610PFIN', .F. ) ) }
		cAssunto := 'Pedido de compras nº ' + aParam[ 4 ] + '-' + RTrim( aParam[ 1 ] ) + ' ' + cAssunto
		A610WFAvUs( aMsg, aDados, cAssunto, .F., .F., 'A610AvUs' )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610ImCP | Autor | Robson Gonçalves          | Data | 01.06.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que exporta os dados da capa de despesas para planilha
//        | excel.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610ImCP()
	Local aButton := {}
	Local aPar := {}
	Local aRet := {}
	Local aSay := {}
	
	Local nOpcao := 0
	
	Private cCadastro := 'Exportar dados da Capa de Despesa'
	
	AAdd( aSay, 'Rotina exporta os dados da capa de despesa para uma planilha excel conforme os' )
	AAdd( aSay, 'parâmetros informados pelo usuário.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		AAdd( aPar, { 1, 'Filial de'            , xFilial( 'SC7' ), '', 'A120FilEnt( MV_PAR01 ).OR.Vazio()', 'SM0_01', '', 20, .F. } )
		AAdd( aPar, { 1, 'Filial até'           , xFilial( 'SC7' ), '', 'A120FilEnt( MV_PAR02 )', 'SM0_01', '', 20, .T. } )
		
		AAdd( aPar, { 1, 'Emissão do PC de'     ,Ctod(Space(8)),'','','','',50,.F.})
		AAdd( aPar, { 1, 'Emissão do PC até'    ,Ctod(Space(8)),'','(MV_PAR04>=MV_PAR03)','','',50,.T.})

		AAdd( aPar, { 1, 'Nº Pedido de'         ,Space(Len(SC7->C7_NUM)),'','','SC7','',30,.F.})
		AAdd( aPar, { 1, 'Nº Pedido até'        ,Space(Len(SC7->C7_NUM)),'','(MV_PAR06>=MV_PAR05)','SC7','',30,.T.})
	                                       
		AAdd( aPar, { 1, 'C.Custo despesa de'   ,Space(Len(SC7->C7_CC)),'','','CTT','',60,.F.})
		AAdd( aPar, { 1, 'C.Custo despesa até'  ,Space(Len(SC7->C7_CC)),'','(MV_PAR08>=MV_PAR07)','CTT','',60,.T.})

		AAdd( aPar, { 1, 'C.Custo aprovação de' ,Space(Len(SC7->C7_CC)),'','','CTT','',60,.F.})
		AAdd( aPar, { 1, 'C.Custo aprovação até',Space(Len(SC7->C7_CC)),'','(MV_PAR10>=MV_PAR09)','CTT','',60,.T.})
		
		If ParamBox( aPar, 'Exportar dados', @aRet )
			MsAguarde( {|| A610PrcImp( aRet ) }, cCadastro, '', .F. )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610PrcImp | Autor | Robson Gonçalves        | Data | 01.06.2016
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento para gerar os dados da capa de despesa
//        | em planilha excel.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610PrcImp( aRet )
	Local aCabec := {}
	Local aCC := {}
	Local aCCAPROV := {}
	Local aCLVL := {}
	Local aCOND := {}
	Local aCTAORC := {}
	Local aFILENT := {}
	Local aFORNEC := {}
	Local aITEMCTA := {}
	Local aDADOS := {}
	Local aSA2 := {}
	
	Local cCotacao := ''
	Local cSQL := ''
	Local cTRB := ''
	
	Local nC := 1
	Local nE := 0
	
	Local nVlrBruto := 0
	
	Local nP1 := 0, nP2 := 0, nP3 := 0, nP4 := 0, nP5 := 0, nP6 := 0, nP7 := 0, nP8 := 0
	
	aCabec := {	'Filial',;
		'Nº PC',;
		'Emissão',;
		'Nº Contrato',;
		'Nº Medição',;
		'Mês/Ano Ref.',;
		'Aprovado em budget?',;
		'Tipo de compra?',;
		'Centro Custo Aprovação',;
		'Descric.C.Custo Aprovação',;
		'Centro custo da despesa',;
		'Descric. C. C. da despesa',;
		'Centro de resultado',;
		'Descrição C. Resultado',;
		'Código do projeto',;
		'Descrição do projeto',;
		'Conta contábil orçada',;
		'Descricao conta orçada',;
		'Descr.despesa no Orçamento',;
		'Descrição',;
		'Justificativa',;
		'Objetivo',;
		'Informação adicional',;
		'Forma de pagamento',;
		'Vencimento',;
		'Nr.Docto. Fiscal',;
		'Cond.de Pagto.',;
		'CNPJ de entrega?',;
		'Filial de entrega?',;
		'Rateio por centro custo',;
		'Código/Loja Forn.',;
		'Razão Social',;
		'Nome Fantasia',;
		'CNPJ Forn.',;
		'Valor Bruto PC',;
		'Nº Cotação';
	}
	
	cSQL := "SELECT DISTINCT C7_FILIAL, C7_NUM"
	cSQL += "FROM "+RetSqlName("SC7")+" SC7 "
	cSQL += "WHERE C7_FILIAL >= "+ValToSql(aRet[1])+" "
	cSQL += "      AND C7_FILIAL <= "+ValToSql(aRet[2])+" "
	cSQL += "      AND C7_EMISSAO >= "+ValToSql(aRet[3])+" "
	cSQL += "      AND C7_EMISSAO <= "+ValToSql(aRet[4])+" "
	cSQL += "      AND C7_NUM >= "+ValToSql(aRet[5])+" "
	cSQL += "      AND C7_NUM <= "+ValToSql(aRet[6])+" "
	cSQL += "      AND C7_CC >= "+ValToSql(aRet[7])+" "
	cSQL += "      AND C7_CC <= "+ValToSql(aRet[8])+" "
	cSQL += "      AND C7_CCAPROV >= "+ValToSql(aRet[9])+" "
	cSQL += "      AND C7_CCAPROV <= "+ValToSql(aRet[10])+" "
	cSQL += "      AND SC7.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER BY C7_FILIAL, C7_NUM "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	
	SC7->( dbSetOrder( 1 ) )
	While (cTRB)->( .NOT. EOF() )
		MsProcTxt( 'Lendo pedido Nº ' + SC7->C7_FILIAL + '-' + SC7->C7_NUM )
		ProcessMessage()
	   
		SC7->( dbSeek( (cTRB)->( C7_FILIAL + C7_NUM ) ) )
		AAdd( aDADOS, Array( Len( aCabec ) ) )
		nE := Len( aDADOS )
		
		If .NOT. Empty( SC7->C7_CCAPROV )
			nP1 := AScan( aCCAPROV, {|e| e[1] == SC7->C7_CCAPROV } )
			If nP1 == 0
				AAdd( aCCAPROV, { SC7->C7_CCAPROV, CTT->( GetAdvFVal( 'CTT', 'CTT_DESC01', xFilial('CTT')+SC7->C7_CCAPROV, 1 ) ) } )
				nP1 := Len( aCCAPROV )
			Endif
		Endif
		
		If .NOT. Empty( SC7->C7_CC )
			nP2 := AScan( aCC, {|e| e[1] == SC7->C7_CC } )
			If nP2 == 0
				AAdd( aCC, { SC7->C7_CC, CTT->( GetAdvFVal( 'CTT', 'CTT_DESC01', xFilial('CTT')+SC7->C7_CC, 1 ) ) } )
				nP2 := Len( aCC )
			Endif
		Endif
		
		If .NOT. Empty( SC7->C7_ITEMCTA )
			nP3 := AScan( aITEMCTA, {|e| e[1] == SC7->C7_ITEMCTA } )
			If nP3 == 0
				AAdd( aITEMCTA, { SC7->C7_ITEMCTA, CTD->( GetAdvFVal( 'CTD', 'CTD_DESC01', xFilial('CTD')+SC7->C7_ITEMCTA, 1 ) ) } )
				nP3 := Len( aITEMCTA )
			Endif
		Endif
		
		If .NOT. Empty( SC7->C7_CLVL )
			nP4 := AScan( aCLVL, {|e| e[1] == SC7->C7_CLVL } )
			If nP4 == 0
				AAdd( aCLVL, { SC7->C7_CLVL, CTH->( GetAdvFVal( 'CTH', 'CTH_DESC01', xFilial('CTH')+SC7->C7_CLVL, 1 ) ) } )
				nP4 := Len( aCLVL )
			Endif
		Endif
		
		If .NOT. Empty( SC7->C7_CTAORC )
			nP5 := AScan( aCTAORC, {|e| e[1] == SC7->C7_CTAORC } )
			If nP5 == 0
				AAdd( aCTAORC, { SC7->C7_CTAORC, CT1->( GetAdvFVal( 'CT1', 'CT1_DESC01', xFilial('CT1')+SC7->C7_CTAORC, 1 ) ) } )
				nP5 := Len( aCTAORC )
			Endif
		Endif
		
		If .NOT. Empty( SC7->C7_COND )
			nP6 := AScan( aCOND, {|e| e[1] == SC7->C7_COND } )
			If nP6 == 0
				AAdd( aCOND, { SC7->C7_COND, SE4->( GetAdvFVal( 'SE4', 'E4_DESCRI', xFilial('SE4')+SC7->C7_COND, 1 ) ) } )
				nP6 := Len( aCOND )
			Endif
		Endif

		If .NOT. Empty( SC7->C7_FILENT )
			nP7 := AScan( aFILENT, {|e| e[1] == SC7->C7_FILENT } )
			If nP7 == 0
				AAdd( aFILENT, { SC7->C7_FILENT, SM0->( GetAdvFVal( 'SM0', 'M0_FILIAL', cEmpAnt + SC7->C7_FILENT, 1 ) ) } )
				nP7 := Len( aFILENT )
			Endif
		Endif

		nP8 := AScan( aFORNEC, {|e| e[1] == SC7->( C7_FORNECE + C7_LOJA ) } )
		If nP8 == 0
			aSA2 := SA2->( GetAdvFVal( 'SA2', { 'A2_NOME', 'A2_NREDUZ', 'A2_CGC'}, xFilial('SA2') + SC7->( C7_FORNECE + C7_LOJA ), 1 ) )
			AAdd( aFORNEC, { SC7->( C7_FORNECE + C7_LOJA ), aSA2[ 1 ], aSA2[ 2 ], aSA2[ 3 ] } )
			nP8 := Len( aFORNEC )
		Endif
		
		A610VBC( SC7->C7_FILIAL, SC7->C7_NUM, @nVlrBruto, @cCotacao )
		
		aDADOS[ nE, nC ] := SC7->C7_FILIAL
		aDADOS[ nE, ++nC ] := SC7->C7_NUM
		aDADOS[ nE, ++nC ] := SC7->C7_EMISSAO
		aDADOS[ nE, ++nC ] := Iif(Empty(SC7->C7_CONTRA),'Sem contrato',SC7->C7_CONTRA)
		aDADOS[ nE, ++nC ] := Iif(Empty(SC7->C7_MEDICAO),'Sem medição',SC7->C7_MEDICAO)
		aDADOS[ nE, ++nC ] := SC7->C7_XREFERE
		aDADOS[ nE, ++nC ] := StrTran( ToXlsFormat( SC7->C7_APBUDGE, 'C7_APBUDGE' ), '"', '' )
		aDADOS[ nE, ++nC ] := StrTran( ToXlsFormat( SC7->C7_XRECORR, 'C7_XRECORR' ), '"', '' )
		
		aDADOS[ nE, ++nC ] := SC7->C7_CCAPROV
		aDADOS[ nE, ++nC ] := Iif( Empty( SC7->C7_CCAPROV ), '', aCCAPROV[ nP1, 2 ] )
		
		aDADOS[ nE, ++nC ] := SC7->C7_CC
		aDADOS[ nE, ++nC ] := Iif( Empty( SC7->C7_CC ), '', aCC[ nP2, 2 ] )
		
		aDADOS[ nE, ++nC ] := SC7->C7_ITEMCTA
		aDADOS[ nE, ++nC ] := Iif( Empty( SC7->C7_ITEMCTA ), '', aITEMCTA[ nP3, 2 ] )
		
		aDADOS[ nE, ++nC ] := SC7->C7_CLVL
		aDADOS[ nE, ++nC ] := Iif( Empty( SC7->C7_CLVL ), '', aCLVL[ nP4, 2 ] )
		
		aDADOS[ nE, ++nC ] := SC7->C7_CTAORC
		aDADOS[ nE, ++nC ] := Iif( Empty( SC7->C7_CTAORC ), '', aCTAORC[ nP5, 2 ] )
		
		aDADOS[ nE, ++nC ] := SC7->C7_DDORC
		aDADOS[ nE, ++nC ] := SC7->C7_DESCRCP
		
		aDADOS[ nE, ++nC ] := SC7->C7_XJUST
		aDADOS[ nE, ++nC ] := SC7->C7_XOBJ
		aDADOS[ nE, ++nC ] := SC7->C7_XADICON
		aDADOS[ nE, ++nC ] := SC7->C7_FORMPG
		aDADOS[ nE, ++nC ] := SC7->C7_XVENCTO
		aDADOS[ nE, ++nC ] := SC7->C7_DOCFIS
		aDADOS[ nE, ++nC ] := Iif( Empty( SC7->C7_COND ), '', SC7->C7_COND + '-' + aCOND[ nP6, 2 ] )
		aDADOS[ nE, ++nC ] := Iif( Empty( SC7->C7_CNPJ ), A610NomFil( SC7->C7_FILENT, .T. ), TransForm( SC7->C7_CNPJ, '@R 99.999.999/9999-99' ))
		aDADOS[ nE, ++nC ] := Iif( Empty( SC7->C7_FILENT ), '', SC7->C7_FILENT + '-' + aFILENT[ nP7, 2 ] )
		aDADOS[ nE, ++nC ] := StrTran( ToXlsFormat( SC7->C7_RATCC, 'C7_RATCC' ), '"', '' )

		aDADOS[ nE, ++nC ] := SC7->C7_FORNECE + '-' + SC7->C7_LOJA
		aDADOS[ nE, ++nC ] := aFORNEC[ nP8, 2 ]
		aDADOS[ nE, ++nC ] := aFORNEC[ nP8, 3 ]
		aDADOS[ nE, ++nC ] := TransForm( aFORNEC[ nP8, 4 ], '@R 99.999.999/9999-99' )
		aDADOS[ nE, ++nC ] := nVlrBruto
		aDADOS[ nE, ++nC ] := cCotacao
		
		(cTRB)->( dbSkip() )
		
		nC := 1
		nVlrBruto := 0
		cCotacao  := ''
	End
	(cTRB)->( dbCloseArea() )
	FWMsgRun( , {|| DlgToExcel( { { "ARRAY", cCadastro, aCabec, aDADOS } } ) }, ,'Exportando os dados, aguarde...' )
Return

//--------------------------------------------------------------------------
// Rotina | A610VBC | Autor | Robson Gonçalves           | Data | 08.06.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para buscar o valor bruto do pedido de compras e número
//        | da(s) cotação(ões).
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610VBC( cFIL, cNUM, nVlrBruto, cCotacao )
	Local cSQL := ''
	Local cTRB := ''
	
	cSQL := "SELECT SUM( C7_TOTAL + C7_DESPESA + C7_VALFRE + C7_VALIPI + C7_SEGURO ) - SUM( C7_VLDESC ) AS C7VLRBRUTO, "
	cSQL += "       C7_NUMCOT "
	cSQL += "FROM   "+RetSqlName("SC7")+" "
	cSQL += "WHERE  C7_FILIAL = "+ValToSql( cFIL )+" "
	cSQL += "       AND C7_NUM = "+ValToSql( cNUM )+" "
	cSQL += "       AND D_E_L_E_T_ = ' ' "
	cSQL += "GROUP  BY C7_NUMCOT "

	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTRB,.F.,.T.)
	While (cTRB)->( .NOT. EOF() )
		nVlrBruto += (cTRB)->C7VLRBRUTO
		If .NOT. EMPTY( (cTRB)->C7_NUMCOT )
			cCotacao  += (cTRB)->C7_NUMCOT + ', '
		Endif
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
	If .NOT. Empty( cCotacao )
		cCotacao := SubStr( cCotacao, 1, Len( cCotacao )-2 )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610SB2     | Autor | Robson Gonçalves       | Data | 14.05.2015
//--------------------------------------------------------------------------
// Descr. | Rotina para consultar o saldo do produto no estoque.
//        | Esta rotina está fora do contexto capa de despesa, porém foi 
//        | inserido aqui por conveniência.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610SB2()
	Local lReturn := .T.
	Local lSaldo := 0
	Local nD3_COD := 0
	Local nD3_LOCAL := 0
	Local nD3_QUANT := 0
	Local cTitulo := ''
	//--------------------------------------------------------------------------------
	// Somente para a rotina de movimento interno modelo 2.
	If FunName() == 'MATA241'
		//--------------------------------------------------------------------------------
		// Somente para requisição.
		If cTM >= '500'
			nD3_COD := GdFieldPos( 'D3_COD' )
			nD3_LOCAL := GdFieldPos( 'D3_LOCAL' )
			nD3_QUANT := GdFieldPos( 'D3_QUANT' )
			cTitulo := 'Disponibilidade de saldo do produto'
			//--------------------------------------------------------------------------------
			// Posicionar no registro de saldos do produto.
			SB2->( dbSetOrder( 1 ) )
			If SB2->( dbSeek( xFilial( 'SB2' ) + aCOLS[ N, nD3_COD ] + aCOLS[ N, nD3_LOCAL ] ) )
				//--------------------------------------------------------------------------------
				// Capturar o saldo atual do produto.
				nSaldo  := SaldoSB2()
				//--------------------------------------------------------------------------------
				// Calcular se há saldo suficiente em relação ao que está sendo solicitado.
				If ( nSaldo - M->D3_QUANT ) < 0
					lReturn := .F.
					MsgAlert( 'Não há saldo suficiente para atender a quantidade informada no armazém '+aCOLS[ N, nD3_LOCAL ]+'.'+CRLF+;
						'O saldo atual neste momento é: '+LTrim( Str( nSaldo, 12, 2 ) ), cTitulo )
				Endif
			Else
				lReturn := .F.
				MsgAlert( 'Não localizado o produto '+RTrim( aCOLS[ N, nD3_COD ] )+' no armazém '+aCOLS[ N, nD3_LOCAL ]+', verifique.', cTitulo )
			Endif
		Endif
	Endif
	//--------------------------------------------------------------------------------
	// Zerar a MEMVAR e o vetor da quantidade caso seja criticado.
	If .NOT. lReturn
		M->D3_QUANT := 0
		aCOLS[ N, nD3_QUANT ] := 0
	Endif
Return( lReturn )

//--------------------------------------------------------------------------
// Rotina | A610NGestor | Autor | Robson Gonçalves       | Data | 15.09.2016
//--------------------------------------------------------------------------
// Descr. | Rotina executada pelo ponto de entra MT120FIM - O objetivo é 
//        | enviar notificação por e-mail aos gestores quanto as despesas
//        | lançadas em seu centro de custo. Esta rotina está sendo executada 
//        | pelas rotinas: CN120ENMED e MT120FIM.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610NGestor( aParam, lIsBlind )
	Local aArea := {}
	Local aCC := {}
	Local aCONTA := {}
	Local aCTT := {}
	Local aDADOS := {}
	Local aSA2 := {}
	Local aSAL := {}
	
	Local cAL_COD := ''
	Local cC7_CCAPROV := ''
	Local cC7_FILIAL := ''
	Local cC7_NUM := ''
	Local cCH_FILIAL := ''
	Local cDirectory := '\A610NGestor\'
	Local cElaborad := ''
	Local cMsg := ''
	Local cMV610_008 := 'MV_610_008'
	Local cMV_SIMB := ''
	Local cNomeFilial := ''
	Local cTRB := ''
	Local cUser := ''
	
	Local lTemRateio := .F.
	
	Local nP_CC := 0
	Local nP_CONTA := 0
	Local nRotina := 0
	Local nTOTAL_ITEM := 0
	Local nTOTAL_PC := 0
	
	// Diretório onde ficará armazendo os arquivos HTML
	MakeDir( cDirectory )
	
	// Parâmetro com o endereço completo do template.
	If .NOT. GetMv( cMV610_008, .T. )
		CriarSX6( cMV610_008, 'C', 'ENDERECO E NOME DO ARQUIVO TEMPLATE PARA NOTIFICACAO GESTOR - ROTINA CSFA610.prw', '\workflow\evento\a610ngestor.htm' )
	Endif
	
	cMV610_008 := GetMv( cMV610_008, .F. )
	
	// Caso o arquivo template não existir, avisar e abandonar a rotina.
	If .NOT. File( cMV610_008 )
		cUser := RetCodUsr()
		FsSendMail( 'sistemascorporativos@certisign.com.br', ;
			'PROBLEMA - NOTIFICAÇÃO PARA GESTOR - LANÇAMENTO DE DESPESA.', ;
			'AO EXECUTAR A ROTINA (U_A610NGESTOR) CHAMADA PELO PONTO DE ENTRADA (MT120FIM) VERIFICOU-SE QUE:' + CRLF + ;
			'O ARQUIVO TEMPLATE NÃO FOI LOCALIZADO NO DESTINO: ' + cMV610_008 + '.' + CRLF + ;
			'A ROTINA NÃO ENVIARÁ E-MAIL PARA O GESTOR DO CENTRO DE CUSTO .' + CRLF + ;
			'DATA...: ' + Dtoc( dDataBase ) + CRLF + ;
			'HORA...: ' + Time() + CRLF + ;
			'USUÁRIO: ' + cUser + ' ' + Upper( RTrim( UsrFullName( cUser ) ) ) + '.' )
		Return
	Endif
	
	// Capturar o número do pedido de compras e a funcionalidade que a executou.
	cC7_NUM := aParam[ 2 ]
	nRotina := aParam[ 3 ] //-> 3=Incuir, 4-Alterar/Copiar, 5-Excluir.
	
	// Procurar saber quantos itens tem no PC ou no rateio (SCH) somente quando executado pelo usuário.
	If .NOT. lIsBlind
		nTOTAL_ITEM := A610TOTITEM( cC7_NUM )
		If nTOTAL_ITEM > 0
			RegProcDoc( nTOTAL_ITEM )
		Endif
	Endif

	// Capturar as filiais das tabelas.
	cC7_FILIAL := xFilial( 'SC7' )
	cCH_FILIAL := xFilial( 'SCH' )
	
	// Salvar o ambiente.
	aArea := { GetArea(), SC7->( GetArea() ), SCH->( GetArea() ) }
	
	// Posicionar nos registros da tabela de rateios e pedido de compra.
	dbSelectArea( 'SCH' )
	SCH->( dbSetOrder( 1 ) )
	
	dbSelectArea( 'SC7' )
	SC7->( dbSetOrder( 1 ) )
	SC7->( dbSeek( cC7_FILIAL + cC7_NUM ) )
	
	While SC7->( .NOT. EOF() ) .AND. SC7->C7_FILIAL == cC7_FILIAL .AND. SC7->C7_NUM == cC7_NUM
		// Buscar nome do fornecedor.
		If Len( aSA2 ) == 0
			AAdd( aSA2, SC7->C7_FORNECE )
			AAdd( aSA2, SC7->C7_LOJA )
			AAdd( aSA2, RTrim( SA2->( GetAdvFVal( 'SA2', 'A2_NOME', xFilial( 'SA2' ) + SC7->C7_FORNECE + SC7->C7_LOJA, 1 ) ) ) )
			If Len( aSA2[ 3 ] ) > 40
				aSA2[ 3 ] := SubStr( aSA2[ 3 ], 1, 40 )
			Endif
		Endif
		
		// Buscar o valor total do PC considerando todos os campos.
		If nTOTAL_PC == 0
			nTOTAL_PC := StaticCall( MATA097, A097TOTPC, SC7->C7_NUM )
		Endif
		
		// Buscar o nome do elaborador do PC.
		If cElaborad == ''
			cElaborad := RTrim( UsrFullName( SC7->C7_USER ) ) + ' (' + SC7->C7_USER + ')'
		Endif
		
		// Buscar o símbolo da moeda.
		If cMV_SIMB == ''
			cMV_SIMB := GetMv( 'MV_SIMB' + LTrim( Str( SC7->C7_MOEDA, 1, 0 ) ) )
		Endif
		
		// Buscar o nome da filial.
		If cNomeFilial == ''
			cNomeFilial := A610NomFil( SC7->C7_FILIAL, .F. )
		Endif
		
		// Buscar o centro de custo de aprovação.
		If cC7_CCAPROV == ''
			cC7_CCAPROV := SC7->C7_CCAPROV
		Endif
		
		// Se conta contábil e centro de custo vazio e é rateio, então pegar no rateio (SCH).
		If Empty( SC7->C7_CONTA ) .AND. Empty( SC7->C7_CC ) .AND. SC7->C7_RATEIO == '1'
			SCH->( dbSeek( cCH_FILIAL + SC7->C7_NUM + SC7->C7_FORNECE + SC7->C7_LOJA + SC7->C7_ITEM ) )
			While SCH->( .NOT. EOF() ) .AND. SCH->CH_FILIAL == cCH_FILIAL .AND. ;
					SCH->CH_PEDIDO == SC7->C7_NUM .AND. ;
					SCH->CH_FORNECE == SC7->C7_FORNECE .AND. ;
					SCH->CH_LOJA == SC7->C7_LOJA .AND. ;
					SCH->CH_ITEMPD == SC7->C7_ITEM
				
				// A conta contábil existe no vetor?
				nP_CONTA := AScan( aCONTA, {|e| e[ 1 ] == SCH->CH_CONTA } )
				
				// Se não existe a conta no vetor, então buscar os vínculos e saber se é conta de despesa. 
				If nP_CONTA == 0
					AAdd( aCONTA, { SCH->CH_CONTA, CT1->( GetAdvFVal( 'CT1', 'CT1_NOTDES', xFilial( 'CT1' ) + SCH->CH_CONTA, 1 ) ) } )
					nP_CONTA := Len( aCONTA )
				Endif
				
				// Se for para notificar por ser conta de despesa.
				If aCONTA[ nP_CONTA, 2 ] == '1'
					nP_CC := AScan( aCC, {|e| e[ 1 ] == SCH->CH_CC } )
					
					If nP_CC == 0
						// Buscar os dados do centro de custo.
						aCTT := CTT->( GetAdvFVal( 'CTT', { 'CTT_GARFIX', 'CTT_GARVAR', 'CTT_GAPONT', 'CTT_DESC01' }, xFilial( 'CTT' ) + SCH->CH_CC, 1 ) )
						
						// Se não existe no vetor, adicionar os dados do centro de custo.
						AAdd( aCC, { aCTT[ 1 ], aCTT[ 2 ], aCTT[ 3 ], SCH->CH_CC, aCTT[ 4 ] } )
						nP_CC := Len( aCC )
					Endif
									
					// Buscar o código do grupo de aprovadores conforme o Tipo de Compra (C7_XRECORR).
					cAL_COD := aCTT[ Val( SubStr( SC7->C7_XRECORR, 1, 1 ) ) ]
					
					// Buscar o nome do aprovador do nível "01", o seu código de usuário e seu e-mail. 
					aSAL := SAL->( GetAdvFVal( 'SAL', { 'AL_NOME', 'AL_USER', '', 'AL_APROV' }, xFilial( 'SAL' ) + cAL_COD + '01', 2 ) )
					If aSAL[1]==NIL
						aSAL[1] := A610NAprov(aSAL[4])
					Endif
					aSAL[ 3 ] := UsrRetMail( aSAL[ 2 ] )
					
					// Armazenar os dados que serão elaborados no HTML para e-mail.	
					AAdd( aDADOS, { aSAL[ 3 ],;                                   //1
					RTrim( aSAL[ 1 ] ) + ' ('+cAL_COD+')',;                       //2
					RTrim( aCC[ nP_CC, 4 ] ) + '-' + RTrim( aCC[ nP_CC, 5 ] ),;   //3
					aSA2[ 3 ] + ' (' + aSA2[ 1 ] + '-' + aSA2[ 2 ] + ')',;        //4
					SC7->C7_NUM+' (Filial '+SC7->C7_FILIAL+' '+cNomeFilial+')',;  //5
					cMV_SIMB+' '+LTrim(TransForm(nTOTAL_PC,'@E 999,999,999.99')),;//6
					cElaborad,;                                                   //7
					RTrim( SC7->C7_DESCRCP ),;                                    //8
					RTrim( SC7->C7_XJUST ),;                                      //9
					RTrim( SC7->C7_XADICON ),;                                    //10
					RTrim( SC7->C7_PRODUTO ) + '-' + RTrim( SC7->C7_DESCRI ),;    //11
					LTrim( TransForm( SCH->CH_PERC, '@E 999.999999' ) )+'%',;     //12
					LTrim( TransForm( SCH->CH_VLRAT, '@E 999,999.99' ) ) } )      //13
				Endif
				SCH->( dbSkip() )
			End
		Else
			// A conta contábil existe no vetor?
			nP_CONTA := AScan( aCONTA, {|e| e[ 1 ] == SC7->C7_CONTA } )
			If nP_CONTA == 0
				// Se não existe no vetor, adicionar.
				AAdd( aCONTA, { SC7->C7_CONTA, CT1->( GetAdvFVal( 'CT1', 'CT1_NOTDES', xFilial( 'CT1' ) + SC7->C7_CONTA, 1 ) ) } )
				nP_CONTA := Len( aCONTA )
			Endif
			
			// A conta de despesa deve receber notificação?
			If aCONTA[ nP_CONTA, 2 ] == '1'
				// O centro de custo existe no vetor?
				nP_CC := AScan( aCC, {|e| e[ 1 ] == SC7->C7_CC } )
				If nP_CC == 0
					// Buscar os dados do centro de custo.
					aCTT := CTT->( GetAdvFVal( 'CTT', { 'CTT_GARFIX', 'CTT_GARVAR', 'CTT_GAPONT', 'CTT_DESC01' }, xFilial( 'CTT' ) + SC7->C7_CC, 1 ) )
					
					// Se não existe no vetor, adicionar os dados do centro de custo.
					AAdd( aCC, { aCTT[ 1 ], aCTT[ 2 ], aCTT[ 3 ], SC7->C7_CC, aCTT[ 4 ] } )
					nP_CC := Len( aCC )
				Endif
				
				// Buscar o código do grupo de aprovadores conforme o Tipo de Compra (C7_XRECORR).
				cAL_COD := aCTT[ Val( SubStr( SC7->C7_XRECORR, 1, 1 ) ) ]
				
				// Buscar o nome do aprovador do nível "01", o seu código de usuário e seu e-mail. 
				aSAL := SAL->( GetAdvFVal( 'SAL', { 'AL_NOME', 'AL_USER', '', 'AL_APROV' }, xFilial( 'SAL' ) + cAL_COD + '01', 2 ) )
				If aSAL[1]==NIL
					aSAL[1] := A610NAprov(aSAL[4])
				Endif
				aSAL[ 3 ] := RTrim( UsrRetMail( aSAL[ 2 ] ) )
				
				// Armazenar os dados que serão elaborados no HTML para e-mail.	
				AAdd( aDADOS, { aSAL[ 3 ],;                                   //1
				RTrim( aSAL[ 1 ] ) + ' ('+cAL_COD+')',;                       //2
				RTrim( aCC[ nP_CC, 4 ] ) + '-' + RTrim( aCC[ nP_CC, 5 ] ),;   //3
				aSA2[ 3 ] + ' (' + aSA2[ 1 ] + '-' + aSA2[ 2 ] + ')',;        //4
				SC7->C7_NUM+' (Filial '+SC7->C7_FILIAL+' '+cNomeFilial+')',;  //5
				cMV_SIMB+' '+LTrim(TransForm(nTOTAL_PC,'@E 999,999,999.99')),;//6
				cElaborad,;                                                   //7
				RTrim( SC7->C7_DESCRCP ),;                                    //8
				RTrim( SC7->C7_XJUST ),;                                      //9
				RTrim( SC7->C7_XADICON ),;                                    //10
				RTrim( SC7->C7_PRODUTO ) + '-' + RTrim( SC7->C7_DESCRI ),;    //11
				LTrim( TransForm( 100, '@E 999.999999' ) )+'%',;              //12
				LTrim( TransForm( SC7->C7_TOTAL, '@E 999,999,999.99' ) ) } )  //13
			Endif
		Endif
		If nTOTAL_ITEM > 0
			IncProcDoc( 'Notificar o gestor. Buscando os dados.' )
		Endif
		SC7->( dbSkip() )
	End
	
	// Se tem dados, enviar email.
	If Len( aDADOS ) > 0
		If nTOTAL_ITEM > 0
			IncProcDoc( 'Notificar o gestor. Emviando e-mail.' )
		Endif
		A610EnvNot( cMV610_008, cDirectory, aDADOS, cC7_CCAPROV )
	Endif
	
	// Restaurar o ambiente.
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return

Static Function A610NAprov(cCodAprov)
	Local cReturn := SAK->(GetAdvFVal( 'SAK', 'AK_NOME', xFilial( 'SAK' ) + cCodAprov, 1 ))
Return(cReturn)

//--------------------------------------------------------------------------
// Rotina | A610EnvNot  | Autor | Robson Gonçalves       | Data | 15.09.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para enviar notificação por e-mail aos gestores quanto as 
//        | despesas lançadas em seu centro de custo. Rotina executada pela
//        | rotina A610NGestor.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610EnvNot( cMV610_008, cDirectory, aDADOS, cC7_CCAPROV )
	Local cBody := ''
	Local cEMailGestor := ''
	Local cSaveFile := ''
	
	Local lEhFim := .F.
	Local lEnviou := .F.
	Local lMudouGestor := .F.
	
	Local nI := 0
	Local nTamVetor := Len( aDADOS )
	Local nTOTAL_ITEM := 0
	
	Local oHTML
	
	// Ordenar por email do gestor.
	ASort( aDADOS,,,{|a,b| a[ 1 ] < b[ 1 ] } )
	
	// Ler todos os registros.
	For nI := 1 To nTamVetor
		// Ignorar quando o email do elemento está vazio.
		If Empty( aDADOS[ nI, 1 ] )
			Loop
		Endif
		
		// Ignorar quando o centro de custo da despesa for o mesmo centro de custo da aprovação.
		// Subentende-se que o aprovador já está ciente da apropriação do custo em sua entidade contábil.
		If RTrim( cC7_CCAPROV ) $ aDADOS[ nI, 3 ] //-> 9999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
			Loop
		Endif
		
		// Controlar a quebra por gestor.
		If aDADOS[ nI, 1 ] <> cEMailGestor
			cEMailGestor := aDADOS[ nI, 1 ]
			
			// Iniciar o processo de integrar HTML com AdvPL.
			oHTML := TWFHTML():New( cMV610_008 )
			
			oHTML:ValByName( 'cGESTOR',         aDADOS[ nI, 2 ]  )
			oHTML:ValByName( 'cCCUSTO',         aDADOS[ nI, 3 ]  )
			oHTML:ValByName( 'cFORNEC',         aDADOS[ nI, 4 ]  )
			oHTML:ValByName( 'cNUM_PC',         aDADOS[ nI, 5 ]  )
			// oHTML:ValByName( 'cVL_TOTAL_PC',    aDADOS[ nI, 6 ]  )
			oHTML:ValByName( 'cELABORADOR',     aDADOS[ nI, 7 ]  )
			oHTML:ValByName( 'cDESCR_DESP',     aDADOS[ nI, 8 ]  )
			oHTML:ValByName( 'cJUSTIFICATIVA',  aDADOS[ nI, 9 ]  )
			oHTML:ValByName( 'cINF_ADICIONAIS', aDADOS[ nI, 10 ] )
		Endif
		
		// Listar os produtos em questão.
		AAdd( oHTML:ValByName( 'IT.PRODUTO' ), aDADOS[ nI, 11 ] )
		AAdd( oHTML:ValByName( 'IT.PERC' ),    aDADOS[ nI, 12 ] )
		AAdd( oHTML:ValByName( 'IT.VALOR' ),   aDADOS[ nI, 13 ] )
		
		// Totalizar o item do gestor em questão.
		nTOTAL_ITEM += Val( StrTran( StrTran( aDADOS[ nI, 13 ] , '.', ''  ), ',', '.' ) )
		
		// Avaliar se é fim do vetor.
		lEhFim := ( nI == nTamVetor )
		
		// Se não for fim do vetor, então...
		If .NOT. lEhFim
			// Avaliar se o tamanho do vetor é maior ou igual ao contator atual + 1 do For/Next
			If nTamVetor >= (nI+1)
				// Sendo, avaliar se será quebra de gestor.
				lMudouGestor := ( aDADOS[ (nI+1), 1 ] <> cEMailGestor )
			Endif
		Endif
		
		// Sendo fim da leitura do vetor OU vai ser quebra de gestor no próximo laço.
		If lEhFim .OR. lMudouGestor
			// Atribuir o valor total
			oHTML:ValByName( 'cVALOR_TOTAL', LTrim( TransForm( nTOTAL_ITEM, '@E 999,999,999.99' ) ) )
			
			// Capturar um próximo nome/nº de protocolo.
			cSaveFile := CriaTrab( NIL , .F. )
			
			oHTML:ValByName( 'cPROTOCOLO', cSaveFile )
			
			// Salvar o arquivo HTML.
			oHTML:SaveFile( cDirectory + cSaveFile + '.htm' )
			
			// Dar uma pausa.
			Sleep( Randomize( 1, 1500 ) )
			
			// Atribuir o conteúdo do arquivo à variável.
			cBody := A610LoadFile( cDirectory + cSaveFile + '.htm' )
			
			// Enviar o email para o gestor.
			FSSendMail( cEMailGestor, 'Notificação de apropriação de despesa nº ' + aDADOS[ nI, 5 ], cBody, /*cAnexo*/ )
			If .NOT. lEnviou 
				lEnvou := .T.
			Endif
			
			// Limpar/zerar as variáveis.
			cSaveFile := ''
			nTOTAL_ITEM := 0
			lEhFim := .F.
			lMudouGestor := .F.
			oHTML:Free()
			oHTML := NIL
		Endif
	Next nI
	If .NOT. lEnviou
		MsgAlert('Não foi possível enviar a notificação de apropriação de despesa para o(s) gestor(es).','Notificação de apropriação de despesa')
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610LoadFile | Autor | Robson Gonçalves      | Data | 21.09.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para ler o arquivo HTML gerado nesta operação.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610LoadFile( cFile )
	Local cLine := ''
	FT_FUSE( cFile )
	FT_FGOTOP()
	While .NOT. FT_FEOF()
		cLine += FT_FREADLN()
		FT_FSKIP()
	End
	FT_FUSE()
Return( cLine )

//--------------------------------------------------------------------------
// Rotina | A610TOTITEM | Autor | Robson Gonçalves       | Data | 21.09.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para saber quantos itens tem no PC ou no rateio.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610TOTITEM( cC7_NUM )
	Local aArea := GetArea()
	Local nRet := 0
	// Saber quantos itens tem na tabela SC7 sem rateio. 
	BeginSQL Alias "TABTMPSC7"
		SELECT COUNT(*) QTD_ITEM
		FROM   %Table:SC7%
		WHERE  %NotDel%
		AND C7_FILIAL = %xFilial:SC7%
		AND C7_RESIDUO <> 'S'
		AND C7_NUM = %Exp:cC7_NUM%
		AND C7_RATEIO <> '1'
	EndSQL
	nRet := TABTMPSC7->QTD_ITEM
	TABTMPSC7->( dbCloseArea() )
	// Caso não encontre registro, então procurar na tabela SCH.
	If nRet == 0
		BeginSQL Alias "TABTMPSCH"
			SELECT COUNT(*) QTD_ITEM
			FROM   %Table:SCH%
			WHERE  %NotDel%
			AND CH_FILIAL = %xFilial:SCH%
			AND CH_PEDIDO = %Exp:cC7_NUM%
		EndSQL
		nRet := TABTMPSCH->QTD_ITEM
		TABTMPSCH->( dbCloseArea() )
	Endif
	RestArea( aArea )
Return( nRet )

//--------------------------------------------------------------------------
// Rotina | A610CaVR | Autor | Robson Gonçalves          | Data | 25/10/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para calcular o valor do rateio quando o pedido de compra
//        | gerado pela medição do contrato e este houver rateio.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610CaVR( cNumPC )
	Local cTRB := GetNextAlias()
	Local nDECIMAL := SX3->( Posicione( 'SX3', 2, 'CH_VLRAT', 'X3_DECIMAL' ) )
	
	BEGINSQL ALIAS cTRB
		SELECT C7_FILIAL,
		C7_NUM,
		C7_ITEM,
		C7_FORNECE,
		C7_LOJA,
		C7_TOTAL
		FROM   %Table:SC7% SC7
		WHERE  C7_FILIAL = %xFilial:SC7%
		AND C7_NUM = %Exp:cNumPC%
		AND C7_CONTRA = %Exp:CND->CND_CONTRA%
		AND C7_CONTREV = %Exp:CND->CND_REVISA%
		AND C7_PLANILH = %Exp:CND->CND_NUMERO%
		AND C7_MEDICAO = %Exp:CND->CND_NUMMED%
		AND SC7.%NotDel%
	ENDSQL
	
	SCH->( dbSetOrder( 1 ) )
	
	While (cTRB)->( .NOT. EOF() )
		SCH->( dbSeek( xFilial( 'SCH' ) + (cTRB)->C7_NUM + (cTRB)->C7_FORNECE + (cTRB)->C7_LOJA + (cTRB)->C7_ITEM ) )
		
		While SCH->( .NOT. EOF() ) .AND. SCH->CH_FILIAL  == xFilial( 'SCH' )   .AND. SCH->CH_PEDIDO == (cTRB)->C7_NUM  ;
				.AND. SCH->CH_FORNECE == (cTRB)->C7_FORNECE .AND. SCH->CH_LOJA   == (cTRB)->C7_LOJA ;
				.AND. SCH->CH_ITEMPD  == (cTRB)->C7_ITEM
		   
			SCH->( RecLock( 'SCH', .F. ) )
			SCH->CH_VLRAT := Round( ( (cTRB)->C7_TOTAL * SCH->CH_PERC ) / 100, nDECIMAL )
			SCH->( MsUnLock() )
			SCH->( dbSkip() )
		End
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
Return

//--------------------------------------------------------------------------
// Rotina | A610SvPC    | Autor | Robson Gonçalves       | Data | 24/10/2016
//--------------------------------------------------------------------------
// Descr. | Rotina que armazena a variável para execução da A610NGestor.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
STATIC aPedComp := {}

User Function A610SvPC( aKeyPC )
	aPedComp := {}
	If ValType( aKeyPC ) == 'A' .AND. Len( aKeyPC ) > 0
		//[1]-Opção da aRotina.
		//[2]-Nº Pedido compras.
		//[3]-1=OK; 0=Cancel.
		aPedComp := AClone( aKeyPC )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610RsPC    | Autor | Robson Gonçalves       | Data | 24/10/2016
//--------------------------------------------------------------------------
// Descr. | Rotina que recupera a variável para a execução da A610NGestor.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610RsPC()
	Local aDados := {}
	If ValType( aPedComp ) == 'A' .AND. Len( aPedComp ) > 0
		//[1]-Opção da rotina.
		//[2]-Nº Pedido compras.
		//[3]-1=OK; 0=Cancel.
		aDados := AClone( aPedComp )
		aPedComp := {}
	Endif
Return( aDados )

//--------------------------------------------------------------------------
// Rotina | A610EProc2  | Autor | Robson Gonçalves       | Data | 03/11/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para buscar os pedidos de compras em aberto e com vencto.
//        | próximo de vencer.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610EProc2()
	Local aCTT := {}
	Local aDADOS := {}
	Local aPswRet := {}
	Local aRej := {}
	Local aSit := {}
	Local aUserElab := {}
	Local aUserGest := {}
	
	Local cAL_COD := ''
	Local cAL_USER := ''
	Local cCOUNT := ''
	Local cDTFIM := ''
	Local cMailElab := ''
	Local cMailGest := ''
	Local cMV_DIAS := 'MV_610MPFD'
	Local cMV_FKMAIL := 'MV_FKMAIL'
	Local cMV_MAIL_ENV := 'MV_610MPFF'
	Local cOthersMails := ''
	Local cQuery := ''
	Local cSituacao := ''
	Local cSQL := ''
	Local cStatus := ''
	Local cTRB := GetNextAlias()
	Local cWho := ''
	
	Local lMV_FKMAIL := .F.
	
	Local nCOUNT := 0
	Local nLoop := 0
	Local nP1 := 0
	Local nP2 := 0
	
	Local cMV_IPSRV := 'MV_610_IP'
	
	If .NOT. GetMv( cMV_MAIL_ENV, .T. )
		CriarSX6( cMV_MAIL_ENV, 'C', 'EMAIL PARA ENVIO DE AVISO DE VENCIMENTO DE PEDIDO DE COMPRA. Rotina: CSFA610.prw', 'ctapag@certisign.com.br; plan.financeiro@certisign.com.br; sistemascorporativos@certisign.com.br' )
	Endif

	cMV_MAIL_ENV := GetMv( cMV_MAIL_ENV, .F. )
	
	If .NOT. GetMv( cMV_DIAS, .T. )
		CriarSX6( cMV_DIAS, 'N', 'QUANTIDADE DE DIAS QUE O SISTEMA VERIFICARA O VENCIMENTO COM ANTECEDENCIA CSFA610.prw', '3' )
	Endif
	
	If .NOT. GetMv( cMV_FKMAIL, .T. )
		CriarSX6( cMV_FKMAIL, 'C', 'EMAIL FAKE SUBSTITUIR EMAIL DOS DESTINATÁRIOS. UTILIZADO PARA SIMULACAO/TESTE.', '' )
	Endif
	
	cMV_FKMAIL := GetMv( cMV_FKMAIL, .F. )
	
	lMV_FKMAIL := .NOT. Empty( cMV_FKMAIL )
	
	cMV_DIAS := GetMv( cMV_DIAS, .F. )
	
	If .NOT. GetMv( cMV_IPSRV, .T. )
		CriarSX6( cMV_IPSRV, 'C', 'IP dos servidores Teste/Homolog para identificar e sair a informação no assunto do e-mail. Rotina: CSFA610.prw', '10.130.0.117' )
	Endif

	cMV_IPSRV := GetMv( cMV_IPSRV, .F. )
	
	Conout('* Parâmetro MV_MAIL_ENV = ' + cMV_MAIL_ENV + '.' )
	Conout('* Parâmetro MV_DIAS = ' + LTrim( Str( cMV_DIAS ) ) + '.' )
	Conout('* Parâmetro MV_FKMAIL = ' + cMV_FKMAIL + '.' )
	Conout('* Parâmetro MV_IPSRV = ' + cMV_IPSRV + '.' )
	
	cOthersMails := cMV_MAIL_ENV
	cDTFIM := DtoS( MsDate() + cMV_DIAS )
	
	cSQL := "SELECT C7_FILIAL, "
	cSQL += "       C7_NUM, "
	cSQL += "       C7_FORNECE, "
	cSQL += "       C7_LOJA, "
	cSQL += "       A2_NOME, "
	cSQL += "       C7_XVENCTO, "
	cSQL += "       C7_CONAPRO, "
	cSQL += "       C7_TOT_PED, "
	cSQL += "       C7_USER, "
	cSQL += "       C7_CCAPROV, "
	cSQL += "       C7_XRECORR "
	cSQL += "FROM   (SELECT C7_FILIAL, "
	cSQL += "               C7_NUM, "
	cSQL += "               C7_FORNECE, "
	cSQL += "               C7_LOJA, "
	cSQL += "               C7_XVENCTO, "
	cSQL += "               C7_CONAPRO, "
	cSQL += "               SUM(C7_TOTAL + C7_VALFRE + C7_SEGURO + C7_DESPESA - C7_VLDESC) C7_TOT_PED, "
	cSQL += "               C7_USER, "
	cSQL += "               C7_CCAPROV, "
	cSQL += "               C7_XRECORR "
	cSQL += "        FROM   "+RetSqlName("SC7")+" SC7 "
	cSQL += "        WHERE  C7_FILIAL BETWEEN '  ' AND 'zz' "
	cSQL += "               AND C7_NUM BETWEEN '      ' AND 'zzzzzz' "
	cSQL += "               AND C7_QUJE < C7_QUANT "
	cSQL += "               AND C7_XVENCTO >= '20160101' "
	cSQL += "               AND C7_XVENCTO <= "+ValToSql(cDTFIM)+" "
	cSQL += "               AND C7_RESIDUO = ' ' "
	cSQL += "               AND SC7.D_E_L_E_T_ = ' ' "
	cSQL += "        GROUP  BY C7_FILIAL, "
	cSQL += "                  C7_NUM, "
	cSQL += "                  C7_FORNECE, "
	cSQL += "                  C7_LOJA, "
	cSQL += "                  C7_XVENCTO, "
	cSQL += "                  C7_CONAPRO, "
	cSQL += "                  C7_USER, "
	cSQL += "                  C7_CCAPROV, "
	cSQL += "                  C7_XRECORR) RESULT "
	cSQL += "       INNER JOIN "+RetSqlName("SA2")+" SA2 "
	cSQL += "               ON A2_FILIAL = "+ValToSql(xFilial("SA2"))+" "
	cSQL += "                  AND A2_COD = C7_FORNECE "
	cSQL += "                  AND A2_LOJA = C7_LOJA "
	cSQL += "ORDER  BY C7_FILIAL, "
	cSQL += "          C7_NUM "
	
	cCOUNT := " SELECT COUNT(*) TB_COUNT FROM ( " + cSQL + " ) QUERY "
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cCOUNT ), cTRB, .F., .T. )
	nCOUNT	:= (cTRB)->TB_COUNT
	(cTRB)->(dbCloseArea())
	
	cSQL := ChangeQuery( cSQL )
	Conout('* String query = ' + cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL), cTRB, .F., .T.)
	
	If nCOUNT == 0
		(cTRB)->(dbCloseArea())
		Return
	Endif
	
	PswOrder( 1 )
	
	While (cTRB)->( .NOT. EOF() )
		
		// Buscar dados do usuário elaborador.
		nP1 := AScan( aUserElab, {|e| e[ 1 ] == (cTRB)->C7_USER } )
		
		If nP1 == 0
			PswSeek( (cTRB)->C7_USER )
			aPswRet := PswRet( 1 )
			
			AAdd( aUserElab, { (cTRB)->C7_USER,;                        //[1]-Código
			Capital( RTrim( aPswRet[ 1, 4 ] ) ) ,;   //[2]-Nome completo
			RTrim( aPswRet[ 1, 14 ] ) } )            //[3]-e-mail
			nP1 := Len( aUserElab )
		Endif
		
		// Buscar dados do usuário gestor.
		aCTT := CTT->( GetAdvFVal( 'CTT', { 'CTT_GARFIX', 'CTT_GARVAR', 'CTT_GAPONT' }, xFilial( 'CTT' ) + (cTRB)->C7_CCAPROV, 1 ) )
		If Len( aCTT ) == 0
			Conout('* Filial ' + (cTRB)->C7_FILIAL + ' Pedido ' + (cTRB)->C7_NUM + ' sem centro de custo de aprovação.' )
			(cTRB)->( dbSkip() )
			Loop
		Else
			If Empty( aCTT[ 1 ] )
				Conout('* Filial ' + (cTRB)->C7_FILIAL + ' Pedido ' + (cTRB)->C7_NUM + ' sem dado no campo CTT_GARFIX.' )
				(cTRB)->( dbSkip() )
				Loop
			Endif
			If Len( aCTT ) > 1 .AND. Empty( aCTT[ 2 ] )
				Conout('* Filial ' + (cTRB)->C7_FILIAL + ' Pedido ' + (cTRB)->C7_NUM + ' sem dado no campo CTT_GARVAR.' )
				(cTRB)->( dbSkip() )
				Loop
			Endif
			If Len( aCTT ) > 2 .AND. Empty( aCTT[ 3 ] )
				Conout('* Filial ' + (cTRB)->C7_FILIAL + ' Pedido ' + (cTRB)->C7_NUM + ' sem dado no campo CTT_GAPONT.' )
				(cTRB)->( dbSkip() )
				Loop
			Endif
		Endif
		
		// Capturar o código do grupo de aprovadores.
		cAL_COD := aCTT[ Val( SubStr( (cTRB)->C7_XRECORR, 1, 1 ) ) ]
		// Capturar o código do usuário.
		cAL_USER := SAL->( GetAdvFVal( 'SAL', 'AL_USER', xFilial( 'SAL' ) + cAL_COD + '01', 2 ) )
		// Verificar se ele existe no vetor.
		nP2 := AScan( aUserGest, {|e| e[ 1 ] == cAL_USER } )
		// Se não existir, buscar os dados complementares e armazenar. Se existir basta o valor da posição do vetor.
		If nP2 == 0
			PswSeek( cAL_USER )
			aPswRet := PswRet( 1 )
			AAdd( aUserGest, { cAL_USER,;                            //[1]-Código
			Capital( RTrim( aPswRet[ 1, 4 ] ) ),; //[2]-Nome completo
			RTrim( aPswRet[ 1, 14 ] ) } )         //[3]-e-mail
			nP2 := Len( aUserGest )
		Endif
		
		// Verificar a situação do pedido de compras.
		If (cTRB)->C7_CONAPRO == 'L'
			If A610SitPC( (cTRB)->C7_FILIAL, (cTRB)->C7_NUM )
				cSituacao := 'PC liberado, falta classificar NF.'
			Else
				cSituacao := 'PC liberado, pendente FISCAL/FINANCEIRO'
			Endif
			cStatus := 'L'
		Else
			aRej := A610EstRej( (cTRB)->C7_FILIAL, (cTRB)->C7_NUM )
			If Len( aRej ) > 0
				For nLoop := 1 To Len( aRej )
					cWho += aRej[ nLoop, 2 ] + ', '
				Next nLoop
				cWho := SubStr( cWho, 1, Len( cWho )-2 )
				cSituacao := 'PC rejeitado por '+cWho
				cStatus := 'R'
			Else
				aSit := A610SitAlc( (cTRB)->C7_FILIAL, (cTRB)->C7_NUM )
				If Len( aSit ) > 0
					For nLoop := 1 To Len( aSit )
						cWho += aSit[ nLoop, 2 ] + ', '
					Next nLoop
					cWho := SubStr( cWho, 1, Len( cWho )-2 )
					cSituacao := 'PC pendente de liberação por '+cWho
					cStatus := 'P'
				Endif
			Endif
		Endif
		
		AAdd( aDADOS, { Dtoc(Stod((cTRB)->C7_XVENCTO)),; 				// [1]-Data de vencimento.
		SubStr((cTRB)->A2_NOME,1, 25),; 										// [2]-Nome do fornecedor.
		LTrim(TransForm((cTRB)->C7_TOT_PED,'@E 999,999,999.99')),; 	// [3]-Valor do pedido de compras.
		(cTRB)->C7_FILIAL + '-' + (cTRB)->C7_NUM,; 						// [4]-Número da filial e pedido.
		cSituacao,; 																// [5]-Situação do pedido de compras.
		cStatus,;																	// [6]-Status do PC => L=Liberado; P=Pendente; R=Rejeitado.
		aUserElab[ nP1, 3 ],;                                       // [7]-Email do usuário elaborador.
		aUserGest[ nP2, 3 ]})                                       // [8]-Email do usuário gestor.
      
		cStatus := ''
		cSituacao := ''
		cWho := ''
		aRej := {}
		aSit := {}
		aCTT := {}
      
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
	 
	//===============================================================
	// Ordenar o vetor ===> ( gestor + vencimento + filial + pedido )
	//===============================================================
	ASort( aDADOS,,,{|a,b| ( a[ 8 ] + a[ 1 ] + a[ 4 ] ) < ( b[ 8 ] + b[ 1 ] + b[ 4 ] ) } )
	//=======================================================
	// Executar a função que vai elaborar os e-mail e enviar.
	//=======================================================
	A610MakeOut( aDADOS, aUserGest, cMV_FKMAIL, cOthersMails, lMV_FKMAIL, 8, cMV_IPSRV )
	
	//===================================================================
	// Ordenar o vetor ===> ( elaborador + vencimento + filial + pedido )
	//===================================================================
	ASort( aDADOS,,,{|a,b| ( a[ 7 ] + a[ 1 ] + a[ 4 ] ) < ( b[ 7 ] + b[ 1 ] + b[ 4 ] ) } )
	//=======================================================
	// Executar a função que vai elaborar os e-mail e enviar.
	//=======================================================
	A610MakeOut( aDADOS, aUserElab, cMV_FKMAIL, cOthersMails, lMV_FKMAIL, 7, cMV_IPSRV )
Return

//--------------------------------------------------------------------------
// Rotina | A610MakeOut | Autor | Robson Gonçalves       | Data | 03/11/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para elaborar e enviar o e-mail para aprovador ou para a
//        | elaborador.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610MakeOut( aDADOS, aUser, cMV_FKMAIL, cOthersMails, lMV_FKMAIL, nPosEMail, cMV_IPSRV )
	Local lServerTst := GetServerIP() $ cMV_IPSRV
	Local cAssunto := IIF( lServerTst, "[TESTE] ", "" ) + 'Aviso de vencimento prévio de PC'
	Local cCor := ''
	Local cHTML := ''
	Local cMail := ''
	Local cNome := ''
	Local cUser := ''
	Local lEhFim := .F.
	Local lMudouUser := .F.
	Local nLoop := 0
	Local nTamVetor := Len( aDADOS )

	For nLoop := 1 To nTamVetor
		//---------------------------------------
		// Ignorar elemento sem e-mail do gestor.
		If Empty( aDADOS[ nLoop, nPosEmail ] )
			Conout('* Filial/Pedido ' + aDADOS[ nLoop, 4 ] + ' sem e-mail de gestor.' )
			Loop
		Endif
		//------------------
		// Início da quebra.
		If cUser <> aDADOS[ nLoop, nPosEMail ]
			cUser := aDADOS[ nLoop, nPosEMail ]
			cMail := aDADOS[ nLoop, nPosEMail ]
			cHTML := A610IniHTML(@cMV_IPSRV)
			
			If nPosEMail == 8
				Conout('* A seguir o aprovador(a) avisado: ' )
				Conout('* Aprovador(a): ' + cMail )
			Elseif nPosEMail == 7
				Conout('* A seguir o elaborador(a) avisado: ' )
				Conout('* Elaborador(a): ' + cMail )
			Else
				Conout('* A seguir quem será avisado: ' + cMail )
			Endif
			
			Conout('* Vencto   - Filial-PC - Status - Situação' )
		Endif
		
		//------------------------------------------------------------------
		// Variar a cor da linha na grade com os dados do pedido de compras.
		If cCor == ''
			cCor := 'background-color: rgb(191, 191, 191);'
		Else
			If cCor == 'background-color: rgb(191, 191, 191);'
				cCor := 'background-color: rgb(216, 216, 216);'
			Else
				cCor := 'background-color: rgb(191, 191, 191);'
			Endif
		Endif
		
		//-----------------------------
		// Detalhe dos dados do pedido.
		cHTML += A610DetHTML( aDADOS[ nLoop ], cCor )
		
		//---------------------------
		// É fim da leitura do vetor?
		lEhFim := ( nLoop == nTamVetor )
		
		//------------------------------------
		// Se não for fim da leitura do vetor.
		If .NOT. lEhFim
			//-------------------------------------------------
			// Verificar se no próximo elemento muda o usuário.
			If nTamVetor >= (nLoop+1)
				lMudouUser := ( aDADOS[ (nLoop+1), nPosEMail ] <> cUser )
			Endif
		Endif
		
		//------------------------------------------------------------------
		// Se é fim da leitura do vetor OU mudou o usuário gestor, enviar o e-mail.
		If lEhFim .OR. lMudouUser
			cHTML += A610FimHTML()
			
			// Buscar o nome do gestor.
			cNome := aUser[ AScan( aUser, {|e| e[ 3 ] == cMail } ), 2 ]
			
			// Trocar a string __DEAR__ pelo nome do gestor.
			cHTML := StrTran( cHTML, '__DEAR__', Iif( nPosEMail==8, 'aprovador(a) ', 'elaborador(a) ') + cNome )
			
			//-------------------------------------------------------------
			// Se houver MV_FKMAIL, então substituir o e-mail do aprovador.
			If lMV_FKMAIL
				cMail := cMV_FKMAIL
			Else
				cMail := aDADOS[ nLoop, nPosEMail ]
			Endif
			
			// Enviar o e-mail para o gestor.
			FsSendMail( Iif(lMV_FKMAIL,cMV_FKMAIL,cMail+';'+cOthersMails), cAssunto, cHTML, /*cAnexo*/ )
			
			cCor := ''
			cHTML := ''
			lEhFim := .F.
			lMudouUser := .F.
		Endif
	Next nLoop
Return

//--------------------------------------------------------------------------
// Rotina | A610IniHTML | Autor | Robson Gonçalves       | Data | 03/11/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para processar o início do HTML para o corpo do e-mail.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610IniHTML(cMV_IPSRV)
	Local cHTML	 := ''
	Local lServerTst := GetServerIP() $ cMV_IPSRV
	Local cTitle := IIF( lServerTst, "[TESTE] ", "" ) + 'Aviso de vencimento de pedido de compras'
	
	cHTML := '<!doctype html>'
	cHTML += '<html>'
	cHTML += '	<head>'
	cHTML += '		<meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type" />'
	cHTML += '		<title>Certisign</title>'
	cHTML += '	</head>'
	cHTML += '	<body>'
	cHTML += '		<table align="center" bgcolor="#F0F0F0" border="0" cellpadding="0" cellspacing="0" width="700px">'
	cHTML += '			<tbody>'
	cHTML += '				<tr>'
	cHTML += '					<td>'
	cHTML += '						<img alt="" height="69" src="http://www.comunicacaocertisign.com.br/mensagerias/topo.jpg" style="border:none; display:block" width="700" /></td>'
	cHTML += '				</tr>'
	cHTML += '				<tr>'
	cHTML += '					<td>'
	cHTML += '						<table border="0" cellpadding="0" cellspacing="0" width="100%">'
	cHTML += '							<tbody>'
	cHTML += '								<tr>'
	cHTML += '									<td style="width:30px" width="30">'
	cHTML += '										&nbsp;</td>'
	cHTML += '									<td>'
	cHTML += '										<table border="0" cellpadding="0" cellspacing="0" width="100%">'
	cHTML += '											<tbody>'
	cHTML += '												<tr>'
	cHTML += '													<td style="text-align: left; vertical-align: top; width: 700px;">'
	cHTML += '														<p style="font-family: "Myriad Pro", Arial, Century; font-size: 16px; color: #515151;">'
	cHTML += '															<span style="font-size:20px;"><b style="color: rgb(0, 79, 159);">' + cTitle + '</b></span></p>'
	cHTML += '														<hr />'
	cHTML += '														<p>'
	cHTML += '															<span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Prezado(a) __DEAR__,</span></p>'
	cHTML += '														<p>'
	cHTML += '															<span style="color: rgb(0, 79, 159); font-family: &quot;Myriad Pro&quot;, Arial, Century; font-size: 14px;">Abaixo a rela&ccedil;&atilde;o de pedido(s) de compra(s) com data de vencimento pr&eacute;vio pr&oacute;ximo de vencer. Por favor, o mais breve poss&iacute;vel, verifique para regularizar a situa&ccedil;&atilde;o.</span></p>'
	cHTML += '														<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 628px">'
	cHTML += '															<tbody>'
	cHTML += '																<tr>'
	cHTML += '																	<td style="text-align: center; width: 70px; background-color: rgb(244, 129, 29);">'
	cHTML += '																		<strong><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">Vencto.</span></span></strong></td>'
	cHTML += '																	<td style="text-align: left; width: 95px; background-color: rgb(244, 129, 29);">'
	cHTML += '																		<strong><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">Fornecedor</span></span></strong></td>'
	cHTML += '																	<td style="text-align: right; width: 100px; background-color: rgb(244, 129, 29);">'
	cHTML += '																		<strong><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">Valor R$</span></span></strong></td>'
	cHTML += '																	<td style="text-align: center; width: 100px; background-color: rgb(244, 129, 29);">'
	cHTML += '																		<strong><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">Filial + N&ordm; PC</span></span></strong></td>'
	cHTML += '																	<td style="text-align: left; background-color: rgb(244, 129, 29);">'
	cHTML += '																		<strong><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">Situa&ccedil;&atilde;o</span></span></strong></td>'
	cHTML += '																</tr>'
Return( cHTML )

//--------------------------------------------------------------------------
// Rotina | A610DetHTML | Autor | Robson Gonçalves       | Data | 03/11/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para elaborar o detalhe do corpo do HTML.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610DetHTML( aDADOS, cCor )
	Local cHTML := ''
	cHTML := '<tr>'
	
	cHTML += '<td style="text-align: center; '+cCor+'">'
	cHTML += '<span style="font-family: "Myriad Pro", Arial, Century;<span style="color:rgb(0,79,159);"><span style="font-size: 11px;">'+aDADOS[1]+'</span></td>'
	
	cHTML += '<td style="text-align: left; '+cCor+'">'
	cHTML += '<span style="font-family: "Myriad Pro", Arial, Century;<span style="color:rgb(0,79,159);"><span style="font-size: 11px;">'+aDADOS[2]+'</span></td>'
	
	cHTML += '<td style="text-align: right; '+cCor+'">'
	cHTML += '<span style="font-family: "Myriad Pro", Arial, Century;<span style="color:rgb(0,79,159);"><span style="font-size: 11px;">'+aDADOS[3]+'</span></td>'
	
	cHTML += '<td style="text-align: center; '+cCor+'">'
	cHTML += '<span style="font-family: "Myriad Pro", Arial, Century;<span style="color:rgb(0,79,159);"><span style="font-size: 11px;">'+aDADOS[4]+'</span></td>'
	
	cHTML += '<td style="text-align: left; '+cCor+'">'
	cHTML += '<span style="font-family: "Myriad Pro", Arial, Century;<span style="color:rgb(0,79,159);"><span style="font-size: 11px;">'+aDADOS[5]+'</span></td>'
	
	cHTML += '</tr>'
	
	Conout('* ' + aDADOS[1] + ' - ' + aDADOS[4] + ' - ' + Iif(aDADOS[6]=='L','LIBER ',Iif(aDADOS[6]=='P','PEND  ','REJEIT')) + ' - ' + aDADOS[ 5 ] )
Return( cHTML )

//--------------------------------------------------------------------------
// Rotina | A610FimHTML | Autor | Robson Gonçalves       | Data | 03/11/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para elaborar o final do corpo do HTML.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610FimHTML()
	Local cHTML := ''
	cHTML := '															</tbody>'
	cHTML += '														</table>'
	cHTML += '													</td>'
	cHTML += '												</tr>'
	cHTML += '												<tr>'
	cHTML += '													<td>'
	cHTML += '														<br />'
	cHTML += '														<hr />'
	cHTML += '													</td>'
	cHTML += '												</tr>'
	cHTML += '												<!--rodape-->'
	cHTML += '												<tr>'
	cHTML += '													<td>'
	cHTML += '														<table border="0" cellpadding="0" cellspacing="0" width="100%">'
	cHTML += '															<tbody>'
	cHTML += '																<tr>'
	cHTML += '																	<td width="55%">'
	cHTML += '																		<table border="0" cellpadding="0" cellspacing="0" width="100%">'
	cHTML += '																			<tbody>'
	cHTML += '																				<tr>'
	cHTML += '																					<td width="20%">'
	cHTML += '																						<img alt="" height="64" src="http://www.comunicacaocertisign.com.br/mensagerias/sign.jpg" style="border:none; display:block" width="63" /></td>'
	cHTML += '																					<td width="80%">'
	cHTML += '																						<p style="font-family: "Myriad Pro", Arial, Century; font-size: 16px; color: #004f9f;">'
	cHTML += '																							<span style="color:rgb(0,79,159);"><span style="font-size:14px;"><b>Aten&ccedil;&atilde;o</b></span><br />'
	cHTML += '																							<span style="font-size:12px;">Esta mensagem foi gerada e enviada<br />'
	cHTML += '																							automaticamente, n&atilde;o responda a<br />'
	cHTML += '																							este e-mail.</span></p>'
	cHTML += '																					</td>'
	cHTML += '																				</tr>'
	cHTML += '																			</tbody>'
	cHTML += '																		</table>'
	cHTML += '																	</td>'
	cHTML += '																	<td width="45%">'
	cHTML += '																		<br />'
	cHTML += '																		<span style="font-family: "Myriad Pro", Arial, Century; font-size: 16px; color: #004f9f;"><span style="color:#EF7D00">Certisign</span><span style="color:rgb(0,79,159);">, a sua identidade na rede</span>'
	cHTML += '																		<table border="0" cellpadding="0" cellspacing="0" width="98%">'
	cHTML += '																			<tbody>'
	cHTML += '																				<tr>'
	cHTML += '																					<td>'
	cHTML += '																						<a href="http://www.linkedin.com/company/certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/in.jpg" style="border:none; display:block" width="43" /></a></td>'
	cHTML += '																					<td>'
	cHTML += '																						<a href="http://twitter.com/certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/twi.jpg" style="border:none; display:block" width="43" /></a></td>'
	cHTML += '																					<td>'
	cHTML += '																						<a href="http://www.facebook.com/Certisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/face.jpg" style="border:none; display:block" width="43" /></a></td>'
	cHTML += '																					<td>'
	cHTML += '																						<a href="http://www.youtube.com/user/mktcertisign" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/you.jpg" style="border:none; display:block" width="43" /></a></td>'
	cHTML += '																					<td>'
	cHTML += '																						<a href="http://www.certisignexplica.com.br" target="_blank"><img alt="" height="42" src="http://www.comunicacaocertisign.com.br/mensagerias/blog.jpg" style="border:none; display:block" width="43" /></a></td>'
	cHTML += '																				</tr>'
	cHTML += '																			</tbody>'
	cHTML += '																		</table>'
	cHTML += '																	</td>'
	cHTML += '																</tr>'
	cHTML += '															</tbody>'
	cHTML += '														</table>'
	cHTML += '													</td>'
	cHTML += '												</tr>'
	cHTML += '											</tbody>'
	cHTML += '										</table>'
	cHTML += '									</td>'
	cHTML += '									<td style="width:30px" width="30">'
	cHTML += '										<p>'
	cHTML += '											&nbsp;</p>'
	cHTML += '									</td>'
	cHTML += '								</tr>'
	cHTML += '							</tbody>'
	cHTML += '						</table>'
	cHTML += '					</td>'
	cHTML += '				</tr>'
	cHTML += '			</tbody>'
	cHTML += '		</table>'
	cHTML += '		<p>'
	cHTML += '			&nbsp;</p>'
	cHTML += '	</body>'
	cHTML += '</html>'
Return( cHTML )

//--------------------------------------------------------------------------
// Rotina | A610SitPC   | Autor | Robson Gonçalves       | Data | 03/11/2016
//--------------------------------------------------------------------------
// Descr. | Rotina p/analisar a situação do PC caso já tenha sido aprovado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610SitPC( cFil, cPC )
	Local cTRB := 'CLASS_NFE'
	Local lC7_QTDACLA := .F.
	
	cSQL := "SELECT COUNT(*) nCOUNT "
	cSQL += "FROM "+RetSqlName('SC7')+" SC7 "
	cSQL += "WHERE C7_FILIAL = "+ValToSql( cFil )+" "
	cSQL += "      AND C7_NUM = "+ValToSql( cPC )+" "
	cSQL += "      AND C7_QTDACLA > 0 "
	cSQL += "      AND SC7.D_E_L_E_T_ = ' ' "

	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL), cTRB, .F., .T.)
	
	lC7_QTDACLA := ((cTRB)->nCOUNT > 0)
	
	(cTRB)->( dbCloseArea() )
Return( lC7_QTDACLA )

//--------------------------------------------------------------------------
// Rotina | A610EstRej  | Autor | Robson Gonçalves       | Data | 03/11/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para analisar se o PC está rejeitado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610EstRej( cFil, cPC )
	Local aNomeAprov := {}
	Local aRej := {}
	Local cName := ''
	Local cSQL := ''
	Local cTRB := 'EST_REJ'
	
	cSQL := "SELECT CR_APROV, "
	cSQL += "       AK_NOME "
	cSQL += "FROM   "+RetSqlName("SCR")+" SCR "
	cSQL += "       INNER JOIN "+RetSqlName("SAK")+" SAK "
	cSQL += "               ON AK_FILIAL = "+ValToSql(xFilial("SAK"))+" "
	cSQL += "                  AND AK_COD = CR_APROV "
	cSQL += "                  AND SAK.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  CR_FILIAL = "+ValToSql(cFil)+" "
	cSQL += "       AND CR_NUM = "+ValToSql(cPC)+" "
	cSQL += "       AND CR_TIPO = 'PC' "
	cSQL += "       AND CR_STATUS = '04' "
	cSQL += "       AND SCR.D_E_L_E_T_ = ' ' "

	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL), cTRB, .F., .T.)
	
	While (cTRB)->( .NOT. EOF() )
		
		nP := AScan( aNomeAprov, {|e| e[1]==(cTRB)->CR_APROV } )
		If nP == 0
			cName := A610FLName( RTrim( (cTRB)->AK_NOME ) )
			AAdd( aNomeAprov, { (cTRB)->CR_APROV, (cTRB)->CR_APROV + '-' + cName } )
			nP := Len( aNomeAprov )
		Endif
		
		AAdd( aRej, { (cTRB)->CR_APROV, aNomeAprov[ nP, 2 ] } )
		
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
Return( aRej )

//--------------------------------------------------------------------------
// Rotina | A610SitAlc  | Autor | Robson Gonçalves       | Data | 03/11/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para analisar a situação da alçada, quem é o próximo a
//        | aprovar.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610SitAlc( cFil, cPC )
	Local aNomeAprov := {}
	Local aSit := {}
	Local cName := ''
	Local cSQL := ''
	Local cTRB := 'SIT_ALC'
	
	Local nP := 0
	
	cSQL := "SELECT CR_APROV, "
	cSQL += "       CR_USER, "
	cSQL += "       AK_NOME "
	cSQL += "FROM   "+RetSqlName("SCR")+" SCR "
	cSQL += "       INNER JOIN "+RetSqlName("SAK")+" SAK "
	cSQL += "               ON AK_FILIAL = "+ValToSql(xFilial("SAK"))+" "
	cSQL += "                  AND AK_COD = CR_APROV "
	cSQL += "                  AND SAK.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  CR_FILIAL = "+ValToSql(cFil)+" "
	cSQL += "       AND CR_NUM = "+ValToSql(cPC)+" "
	cSQL += "       AND CR_TIPO = 'PC' "
	cSQL += "       AND CR_STATUS = '02' "
	cSQL += "       AND SCR.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY  CR_USER "
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL), cTRB, .F., .T.)
	
	While (cTRB)->( .NOT. EOF() )
		nP := AScan( aNomeAprov, {|e| e[ 1 ] == (cTRB)->CR_USER } )
		
		If nP==0
			cName := A610FLName( RTrim( (cTRB)->AK_NOME ) )
			AAdd( aNomeAprov, { (cTRB)->CR_APROV, (cTRB)->CR_APROV + '-' + cName } )
			nP := Len( aNomeAprov )
		Endif
		
		AAdd( aSit, { (cTRB)->CR_APROV, aNomeAprov[ nP, 2 ] } )
		
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
Return( aSit )

//--------------------------------------------------------------------------
// Rotina | A610FLName | Autor | Robson Gonçalves        | Data | 03/11/2016
//--------------------------------------------------------------------------
// Descr. | Rotina para retornar o primeiro e último nome.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610FLName( cFull ) // [F]-primeiro nome [L]-último nome.
	Local c1 := ''
	Local c2 := ''
	Local c3 := ''
	
	c1 := SubStr( cFull, 1, At( ' ', cFull )-1 )
	c2 := SubStr( cFull, Rat( ' ', cFull )+1 )
	c3 := Upper(  c1 + ' ' + c2 )
	
Return( c3 )

//--------------------------------------------------------------------------
// Rotina | A610PNFE | Autor | Robson Gonçalves          | Data | 30/01/2017
//--------------------------------------------------------------------------
// Descr. | Rotina follow-up do pré-documento de entrada
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610PNFE()
	Local aButton := {}
	Local aSay := {}
	Local nOpcao := 0
	Private cCadastro := 'Follow-up Pré-Documento de Entrada'
	
	AAdd( aSay, 'Follow-up de documento de entrada não classificados.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		A610NFEPar()
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610NFEPar | Autor | Robson Gonçalves        | Data | 30/01/2017
//--------------------------------------------------------------------------
// Descr. | Rotina de parâmetros do follow-up do pré-documento de entrada
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610NFEPar()
	Local aOpc := {}
	Local aPar := {}
	Local aRet := {}
	Local nOpc := 0
	
	aOpc := {'Não classificados','Somente com divergência','Ambas opções'}
	AAdd( aPar, { 2, 'Listar os documentos', 1, aOpc, 99, '', .T. } )
	If ParamBox( aPar, 'Parâmetros de filtro',@aRet,,,,,,,,.F.,.F.)
		nOpc := Iif( ValType( aRet[ 1 ] ) == 'N', aRet[ 1 ], AScan( aOpc, {|e| e==aRet[ 1 ] } ) )
		MsAguarde( {|| A610NFEQry( nOpc ) }, cCadastro, 'Início do processo, aguarde...', .F. )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610NFEQry | Autor | Robson Gonçalves        | Data | 30/01/2017
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610NFEQry( nOpc )
	Local aA2_NOME := {}
	Local aDADOS := {}
	Local aParc := {}
	Local aPoint := {'|','/','-','\'}
	
	Local cC7_COND := ''
	Local cC7_CONTRA := ''
	Local cC7_EMISSAO := ''
	Local cC7_FILENT := ''
	Local cC7_FILIAL := ''
	Local cC7_ITEMSC := ''
	Local cC7_MEDICAO := ''
	Local cC7_NUM := ''
	Local cC7_NUMCOT := ''
	Local cC7_NUMSC := ''
	Local cC7_USER := ''
	
	Local cDir := ''
	Local cDirTmp := ''
	Local cFile := ''
	Local cSit := ''
	Local cSQL := ''
	Local cTable := 'Follow-up Pré-documento de entrada'
	Local cTRB := GetNextAlias()
	Local cVencto := ''
	Local cWorkSheet := cTable
		
	Local nP := 0
	Local nPoint := 0
	
	Local oExcelApp
	Local oFwMsEx
	
	// Buscar todo e qualquer registro pendente de classificação. 
	cSQL := "SELECT R_E_C_N_O_ F1_RECNO "
	cSQL += "FROM   "+RETSQLNAME("SF1")+" SF1 "
	cSQL += "WHERE  F1_TIPO = 'N' "
	cSQL += "       AND F1_STATUS = ' ' "
	cSQL += "       AND (( F1_STATCON IN ('1|4') "
	cSQL += "              OR F1_STATCON = ' ' )) "
	cSQL += "       AND SF1.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY 1 "

	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	
	If (cTRB)->(.NOT. BOF() ) .AND. (cTRB)->(.NOT. EOF() )
		SF1->( dbSetOrder( 1 ) )
		SD1->( dbSetOrder( 1 ) )
		
		// Criar o nome do arquivo XML para excel.
		cFile := CriaTrab(NIL,.F.)+'.xml'
		// Estanciar a classe de integração.
		oFwMsEx := FWMsExcel():New()
		// Criar uma planilha.
		oFwMsEx:AddWorkSheet( cWorkSheet )
   	// Adicionar uma tabela.
		oFwMsEx:AddTable( cWorkSheet, cTable )
   	// Criar as colunas da tabela.
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Filial PC'     , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Filial entrega', 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Nº Pedido'     , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Emissão PC'    , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Elaborador PC' , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Nº SC'         , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Item da SC'    , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Nº Cotação'    , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Contrato'      , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Medição'       , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Filial Doc.'   , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Nº Documento'  , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Emissão Doc.'  , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Cond.Pagto.'   , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Prev.de Vencto', 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Código'        , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Loja'          , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Fornecedor'    , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'Situação'      , 1, 1 )
		
		While (cTRB)->( .NOT. EOF() )
			nPoint++
			If nPoint == 5
				nPoint := 1
			Endif
			
			MsProcTxt( 'Aguarde, lendo registros [ ' + aPoint[ nPoint ] + ' ]'  )
			ProcessMessage()
			
			// Posicionar no registro pendente.
			SF1->( dbGoTo( (cTRB)->F1_RECNO ) )
			
			// Analisar a condição conforme o parâmetro do usuário.
			If nOpc == 1 .AND. .NOT. Empty( SF1->F1_LOG )
				(cTRB)->( dbSkip() )
				Loop
			Elseif nOpc == 2 .AND. Empty( SF1->F1_LOG )
				(cTRB)->( dbSkip() )
				Loop
			Endif
			
			// Compor a descrição da situação.
			cSit := Iif( Empty( SF1->F1_LOG ), 'Não classificado', 'Não classificado e com divergência' )
			
			// Buscar os itens da NF
			SD1->( dbSeek( SF1->( F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) ) )
			
			// Buscar o pedido de compras - atenção quanto a filial, pois usa-se a FILIAL de ENTREGA.
			SC7->( dbSetOrder( 1 ) )
			If .NOT. SC7->( dbSeek( SD1->( D1_FILIAL + D1_PEDIDO ) ) )
				SC7->( dbSetOrder( 14 ) )
				SC7->( dbSeek( SF1->F1_FILIAL + SD1->D1_PEDIDO ) )
			Endif
			
			// Achou o registro, então atribuir as variáveis, do contrário limpa-las.
			If SC7->( Found() )
				cC7_NUM     := SC7->C7_NUM
				cC7_COND    := SC7->C7_COND
				cC7_EMISSAO := Dtoc( SC7->C7_EMISSAO )
				cC7_FILIAL  := SC7->C7_FILIAL
				cC7_FILENT  := SC7->C7_FILENT
				cC7_NUMSC   := SC7->C7_NUMSC
				cC7_ITEMSC  := SC7->C7_ITEMSC
				cC7_NUMCOT  := SC7->C7_NUMCOT
				cC7_CONTRA  := SC7->C7_CONTRA
				cC7_MEDICAO := SC7->C7_MEDICAO
				cC7_USER    := RTrim( UsrFullName( SC7->C7_USER ) )
			Else
				cC7_NUM     := ''
				cC7_COND    := ''
				cC7_EMISSAO := ''
				cVencto     := ''
				cC7_FILIAL  := ''
				cC7_FILENT  := ''
				cC7_NUMSC   := ''
				cC7_ITEMSC  := ''
				cC7_NUMCOT  := ''
				cC7_CONTRA  := ''
				cC7_MEDICAO := ''
				cC7_USER    :=  ''
			Endif
			
			// Controle de buscar de nome do fornecedor para não buscar o mesmo mais de uma vez.
			nP := AScan( aA2_NOME, {|e| e[ 1 ] == SF1->( F1_FORNECE + F1_LOJA ) } )
			If nP == 0
				AAdd( aA2_NOME, { SF1->( F1_FORNECE + F1_LOJA ),;
					RTrim( SA2->( Posicione( 'SA2', 1, xFilial( 'SA2' ) + SF1->( F1_FORNECE + F1_LOJA ), 'A2_NOME' ) ) ) } )
				nP := Len( aA2_NOME )
			Endif
			
			// Buscar a data de vencimento do título.
			aParc := Condicao( 1000, SC7->C7_COND, , SF1->F1_EMISSAO )
			If Len( aParc ) > 0
				cVencto := Dtoc( aParc[ 1, 1 ] )
			Else
				cVencto := 'Vencimento não localizado'
			Endif
			
			// Atribuir os valores à planilha.
			oFwMsEx:AddRow( cWorkSheet, cTable, { cC7_FILIAL, cC7_FILENT, cC7_NUM, cC7_EMISSAO, cC7_USER, cC7_NUMSC, cC7_ITEMSC,;
				cC7_NUMCOT, cC7_CONTRA, cC7_MEDICAO, SF1->F1_FILIAL, SF1->F1_DOC, Dtoc(SF1->F1_EMISSAO), cC7_COND, cVencto,;
				SF1->F1_FORNECE, SF1->F1_LOJA, aA2_NOME[ nP, 2 ], cSit } )
			
			(cTRB)->( dbSkip() )
		End
	Endif
	
	(cTRB)->( dbCloseArea() )
	
	// Abrir o aplicativo Ms-Excel.
	If oFwMsEx <> NIL
		oFwMsEx:Activate()
		cDirTmp := GetTempPath()
		cDir := GetSrvProfString('Startpath','')
		
		LjMsgRun( 'Gerando arquivo para impressão, aguarde...', cCadastro, {|| oFwMsEx:GetXMLFile( cFile ), Sleep( Randomize( 1, 499 ) ) } )
		
		If __CopyFile( cFile, cDirTmp + cFile )
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cFile )
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			Sleep( Randomize( 1, 499 ) )
		Else
			MsgInfo( 'Não foi possível copiar o arquivo para o diretório temporário do usuário.' )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | AvisoRun | Autor | Robson Gonçalves          | Data | 08/05/2017
//--------------------------------------------------------------------------
// Descr. | Rotina de alerta temporário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function AvisoRun( cCaption, cMensagem, bAction, nTimer )
	Local oDlgAviso
	Local oGet
	Local oFont := TFont():New('Calibri',,-15,,.F.)
	Local oTimer
	
	DEFAULT cCaption := 'Aguarde...'
	DEFAULT cMensagem := 'Processando...'
	DEFAULT nTimer := 30
	
	DEFINE MSDIALOG oDlgAviso FROM 0,0 TO 227,450 TITLE cCaption Of oMainWnd PIXEL
	DEFINE TIMER oTimer INTERVAL nTimer ACTION (Eval(bAction,oGet), oDlgAviso:End()) OF oDlgAviso
	@ 000,000 BITMAP RESNAME "LOGIN" OF oDlgAviso SIZE 035,210 NOBORDER WHEN .F. PIXEL
	@ 011,036 TO 012,400 LABEL '' OF oDlgAviso PIXEL
	@ 016,038 GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE 185,085 READONLY MEMO FONT oFont
	ACTIVATE MSDIALOG oDlgAviso CENTERED ON INIT oTimer:Activate()
Return

/*
_____________________________________________________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------------------------------------------------------------+¦¦
¦¦¦                                                                                                                               ¦¦¦
¦¦¦ AS ROTINAS ABAIXO FORAM CRIADAS PARA ATENDER A NECESSIDADE DA INTEGRAÇÃO VIA WEBSERVICE CONSUMIDO PELA APLICAÇÃO JAVA PARA A  ¦¦¦
¦¦¦ APROVAÇÃO DE PEDIDO DE COMPRAS.                                                                                               ¦¦¦
¦¦¦ _____________________________________________________________________________________________________________________________ ¦¦¦
¦¦¦ -> WEBSERVICE --> CSFA750                                                                                                     ¦¦¦
¦¦¦               --> MÉTODOS ---> getPendenciaAlcadaPC ----> executar U_A610PenPC  (autentica o usuário e retorna as pendência). ¦¦¦
¦¦¦                           ---> setAprovacaoPC       ----> executar U_A610RecApr (receber a ação do aprovador).                ¦¦¦
¦¦¦                           ---> getSituacaoPC        ----> executar U_A610Situac (receber dados do PC e retorna a situação).   ¦¦¦
¦¦¦                           ---> getConsultaPC        ----> executar U_A610Ped    (consultar os detallhes do PC).               ¦¦¦
¦¦¦ _____________________________________________________________________________________________________________________________ ¦¦¦
¦¦¦ -> ROTINAS ADVPL --> U_A610PenPC---> Recebe o e-mail do usuário.                                                              ¦¦¦
¦¦¦                                 ---> A610Autent ----> Tenta autenticar o e-mail.                                              ¦¦¦
¦¦¦                                 ---> A610Listar ----> Busca a lista de pendência e devolve o XML.                             ¦¦¦
¦¦¦                  --> A610RecApr ---> Recebe a aprovação/rejeição do aprovador e grava o registro LOTE na GTLOG.               ¦¦¦
¦¦¦                                      GTSetUp    ----> Verifica se a tabela GTLOG está criada.                                 ¦¦¦
¦¦¦                                      A610UseGTL ----> Faz a abertura da tabela GTLOG e seus índices.                          ¦¦¦
¦¦¦                  --> U_CSFA610G ---> Rotina JOB início para decompor o registro LOTE.                                         ¦¦¦
¦¦¦                                      A610JobG   ----> Rotina início para processar em modo JOB ou manual o LOTE.              ¦¦¦
¦¦¦                                      A610ManG   ----> Rotina início para processar em modo manual o LOTE.                     ¦¦¦
¦¦¦                                      A610PJobG  ----> Rotina executada pelo Ag610JobG e A610ManG para decompor o lote.        ¦¦¦
¦¦¦                  --> U_CSFA610H ---> Rotina JOB início para processar a ação da alçada do pedido decomposto.                  ¦¦¦
¦¦¦                                      A610JobH   ----> Rotina início para processar em modo JOB a alçada do PC.                ¦¦¦
¦¦¦                                      A610ManH   ----> Rotina início para processar em modo manual a alçada do PC.             ¦¦¦
¦¦¦                                      A610PJobH  ----> Rotina que processa o PC decomposto para a alçada A097ProcLib.          ¦¦¦
¦¦¦                                                 ----> A610PrxNiv  ---> Rotina para avaliar próximo nível de alçada.           ¦¦¦
¦¦¦                                                 ----> A610ProxApr ---> Rotina para avaliar se tem próximo nível e envia WF.   ¦¦¦
¦¦¦                  --> U_A610Situac--> Rotina que efetua consulta do resultado do processamento da liberação da alçada na GTLOG.¦¦¦
¦¦¦                  --> U_A610Ped  ---> Rotina para consultar os dados do pedido, inclusive a capa de despesa física.            ¦¦¦
¦¦¦                                      A610TotPC ----> Rotina que busca o valor total do PC.                                    ¦¦¦
¦¦¦                  --> A610GrvLog ---> Roitna responsável em gravar o log de comunicação entre Protheus e aplicação Java.       ¦¦¦
¦¦¦                                 ---> Rotina responsável em buscar o próximo número sequência do registro de log.              ¦¦¦
¦¦¦                  --> A610GTLOG  ---> Rotina de manutenção nos registros da tabela GTLOG.                                      ¦¦¦
¦¦¦                                      GTLApres ---> Interface de apresentação da rotina.                                       ¦¦¦
¦¦¦                                      GTLParam ---> Interface de parâmetros da rotina.                                         ¦¦¦
¦¦¦                                      GTLQuery ---> Rotina para buscar os dados conforme os parâmetros.                        ¦¦¦
¦¦¦                                      GTLHead  ---> Rotina para elaborar o Head do Browse ou da Enchoice.                      ¦¦¦
¦¦¦                                      GTLShow  ---> Rotina para apresentar os dados em tela.                                   ¦¦¦
¦¦¦                                      GTLSetArray > Rotina para estabelecer os dados que deverão ser apresentados no browse.   ¦¦¦
¦¦¦                                      GTLOrdHead -> Rotina para ordernar o browse conforme a coluna clicada pelo usuário.      ¦¦¦
¦¦¦                                      GTLReload --> Rotina para recarregar os dados no browse com novo parâmetro.              ¦¦¦
¦¦¦                                      GTLParPsq --> Rotina para o usuário escolher qual coluna ele quer pesquisar.             ¦¦¦
¦¦¦                                      GTLPesq ----> Rotina de pesquisa no browse.                                              ¦¦¦
¦¦¦                                      GTLVisual --> Interface de visualização dos dados na íntegra.                            ¦¦¦
¦¦¦                                      GTLEnchoice > Rotina para processar os objetos de visualização dos dados.                ¦¦¦
¦¦¦ _____________________________________________________________________________________________________________________________ ¦¦¦
¦¦¦                                                                                                                               ¦¦¦
¦¦¦ Estutura da tabela de LOG para sustentar a comunicação da aplicação Java com o Protheus.                                      ¦¦¦
¦¦¦                                                                                                                               ¦¦¦ 
¦¦¦ GT_IDOPER' , 'C',  9, 0 // Id operação.                                                                                       ¦¦¦
¦¦¦ GT_DTOPER' , 'D',  8, 0 // Data da operação.                                                                                  ¦¦¦
¦¦¦ GT_ACAO'   , 'C',  1, 0 // Ação da operação (A = aprovado; R=reprovado; L=Log).                                               ¦¦¦
¦¦¦ GT_EMAIL'  , 'C', 60, 0 // Email do aprovador.                                                                                ¦¦¦
¦¦¦ GT_MOTIVO' , 'M', 10, 0 // Motivo/Justificativa da ação.                                                                      ¦¦¦
¦¦¦ GT_CODAPRO', 'C',  6, 0 // Código do aprovador.                                                                               ¦¦¦
¦¦¦ GT_CODUSER', 'C',  6, 0 // Código do usuário.                                                                                 ¦¦¦
¦¦¦ GT_FILPC'  , 'C',  2, 0 // Código da filial da operação.                                                                      ¦¦¦
¦¦¦ GT_NUMPC'  , 'C',  6, 0 // Número do pedido de compras.                                                                       ¦¦¦
¦¦¦ GT_PARAM'  , 'M', 10, 0 // Parâmetros XML recebidos.                                                                          ¦¦¦
¦¦¦ GT_SEND'   , 'C',  1, 0 // Identificador de processo (F = recebido; T = processado )                                          ¦¦¦
¦¦¦ GT_INIPROC', 'C',  1, 0 // Identificador de processamento (F = não foi processado.                                            ¦¦¦
¦¦¦                         //                                 T = foi processado com sucesso.                                    ¦¦¦
¦¦¦                         //                                 1 = Registro reservado.                                            ¦¦¦
¦¦¦                         //                                 2 = Pedido não localizado.                                         ¦¦¦
¦¦¦                         //                                 3 = Pendência de alçada não lozalizada.                            ¦¦¦
¦¦¦                         //                                 4 = Não há pendência de alçada.)                                   ¦¦¦
¦¦¦                         //                                 5 = Pedido em uso não será possível processar.)                    ¦¦¦
¦¦¦ GT_DTPROC' , 'D',  8, 0 // Data do processamento                                                                              ¦¦¦
¦¦¦ GT_HRPROC' , 'C',  8, 0 // Hora do processamento                                                                              ¦¦¦
¦¦¦ GT_LOG'    , 'M', 10, 0 // log de processamento                                                                               ¦¦¦
¦¦¦ GT_DATE'   , 'D',  8, 0 // Legado                                                                                             ¦¦¦
¦¦¦ GT_TIME'   , 'C',  8, 0 // Legado                                                                                             ¦¦¦
¦¦¦ GT_ONLINE' , 'L',  1, 0 // Legado                                                                                             ¦¦¦
¦¦¦ GT_INFO'   , 'C',250, 0 // Legado                                                                                             ¦¦¦
¦¦¦                                                                                                                               ¦¦¦
¦¦+-------------------------------------------------------------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
//--------------------------------------------------------------------------
// Rotina | A610PenPC   | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que recebe o e-mail ou o CPF por meio WS CSFA750 acionado 
//        | pela aplicação java para validar se o usuário é aprovador e se 
//        | possui pedidos pendentes de alçada do usuário aprovador.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610PenPC( cMailAprov, cCPFAProv )
	Local cTag := ''
	Local cMsgLog := ''
	Local cUsr := ''
	Local cRetXML := ''
	Local nRet := 0
	
	//------------------
	// Criticar o email.
	nRet := A610Autent( cMailAprov, cCPFAprov, @cUsr )
	
	cRetXML := '<retorno>' + CRLF
	
	//-------------------------------------------------
	// Se maior que zero, elaborar mensagem da critica.
	If nRet > 0
		cRetXML += "<codigo>" + StrZero( nRet, 2, 0 ) + "</codigo>" + CRLF
		
		If     nRet == 1 ; cRetXML += "<mensagem>Usuário não existe.</mensagem>" + CRLF
		Elseif nRet == 2 ; cRetXML += "<mensagem>Usuário está bloqueado.</mensagem>" + CRLF
		Elseif nRet == 3 ; cRetXML += "<mensagem>Usuário não é aprovador.</mensagem>" + CRLF
		Elseif nRet == 4 ; cRetXML += "<mensagem>Usuário aprovador não está vinculado a nenhum grupo de aprovação.</mensagem>" + CRLF
		Else             ; cRetXML += "<mensagem>Condição não prevista nesta integração.</mensagem>" + CRLF
		Endif
		
		cRetXML += "<pedidos>"  + CRLF
		cRetXML += "</pedidos>"  + CRLF
	Else
		//------------------------------------------------------------------------
		// Se igual a zero, buscar lista de pendência de provação deste aprovador.
		nRet := A610Listar( cUsr, @cTag )
		cRetXML += "<codigo>" + StrZero( nRet, 2, 0 ) + "</codigo>" + CRLF
		
		//------------------------------------------------------------------------------
		// Se retornar zero, devolver os dados encontrados de pendência deste aprovador.
		If nRet == 0
			cRetXML += "<pedidos>" + CRLF
			cRetXML += cTag
			cRetXML += "</pedidos>" + CRLF
		Else
			//---------------------------------------------------------
			// Se retornar diferente de zero é porque não há pendência.
			cRetXML += "<mensagem>Não existe pendências de alçadas de compras.</mensagem>" + CRLF
			cRetXML += "<pedidos>" + CRLF
			cRetXML += "</pedidos>" + CRLF
		Endif
	Endif
	cRetXML += '</retorno>'
	
	cMsgLog := 'Foi solicitado autenticação com ' + cMailAprov + ' e/ou ' + cCPFAprov +;
		Iif( nRet == 0, ', localizei o ' + cUsr , ', não localizei o usuário' ) + ' e retornei a seguinte resposta: '+cRetXML
	A610GrvLog( cMsgLog )
Return( cRetXML )

//--------------------------------------------------------------------------
// Rotina | A610Autent  | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para autenticar o usuário através do email ou CPF.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Autent( cEmail, cCPF, cUsr )
	Local aPsw := {}
	Local cTRB := ''
	Local lSAK := .F.
	Local lSAL := .F.
	
	CONOUT('* ------------------------------------------------------------')
	CONOUT('* A610AUTENT (JAVA <-integracao-> PROTHEUS) APROVACAO DESPESA.')
	
	cTRB := GetNextAlias()
	
	// Verifica se não há o domínio da e-mail informado, sendo assim procurar pelo CPF
	If .NOT.  ( '@certisign' $ Lower( cEmail ) .or. '@certibio' $ Lower( cEmail ) )
		If Empty( cCPF )
			Return( 1 ) //Usuário não existe.
		Else
			BEGINSQL ALIAS cTRB
				SELECT RA_EMAIL
				FROM   %Table:SRA% SRA
				WHERE  RA_CIC = %Exp:cCPF%
				AND RA_DEMISSA = ' '
				AND RA_SITFOLH = ' '
				AND SRA.D_E_L_E_T_ = ' '
			ENDSQL
			cEmail := Lower( RTrim( (cTRB)->RA_EMAIL ) )
			(cTRB)->( dbCloseArea() )
			If Empty( cEmail )
				Return( 1 ) //Usuário não existe.
			Endif
			CONOUT('* PESQUISAR POR CPF.')
		Endif
	Else
		CONOUT('* PESQUISAR POR E-MAIL.')
	Endif
	
	//----------------------
	// Pesquisar por e-mail.
	PswOrder( 4 )
	If .NOT. PswSeek( RTrim( cEmail ) )
		//--------------------
		// Usuário não existe.
		Return( 1 )
	Endif
	
	//------------------------------------
	// Capturar todos os dados do usuário.
	aPsw := PswRet()
	cUsr := aPsw[ 1, 1 ]
	
	CONOUT('* CODIGO DO USUARIO '+cUsr+'.')
	//------------------------
	// Usuário está bloqueado.
	If aPsw[ 1, 17 ]
		Return( 2 )
	Endif
	
	CONOUT('* USUARIO NAO ESTA BLOQUEADO.')
	//---------------------------------------
	// Procurar saber se usuário é aprovador?
	BEGINSQL ALIAS cTRB
		SELECT COUNT(*) nSAK_COUNT
		FROM   %Table:SAK% SAK
		WHERE  AK_FILIAL = %xFilial:SAK%
		AND AK_USER = %Exp:cUsr%
		AND AK_MSBLQL <> '1'
		AND SAK.%NotDel%
	ENDSQL

	lSAK := ( (cTRB)->nSAK_COUNT > 0 )
	(cTRB)->( dbCloseArea() )
	
	CONOUT('* USUARIO EXISTE COMO APROVADOR? '+IIF(LSAK,'SIM.','NAO.'))
	
	//-------------------------
	// Usuário não é aprovador.
	If .NOT. lSAK
		Return( 3 )
	Endif
	
	//------------------------------------------------------
	// Procurar saber se usuário está em grupo de aprovação. 
	cTRB := GetNextAlias()
	BEGINSQL ALIAS cTRB
		SELECT COUNT(*) nSAL_COUNT
		FROM   %Table:SAL% SAL
		WHERE  AL_FILIAL = %xFilial:SAL%
		AND AL_USER = %Exp:cUsr%
		AND AL_MSBLQL <> '1'
		AND SAL.D_E_L_E_T_ = ' '
	ENDSQL
	
	lSAL := ( (cTRB)->nSAL_COUNT > 0 )
	(cTRB)->( dbCloseArea() )
	
	CONOUT('* USUARIO ESTA EM GRUPO DE APROVADORES? '+IIF(LSAK,'SIM.','NAO.'))
	
	If .NOT. lSAL
		//-----------------------------------------------
		// Usuário não está em nenhum grupo de aprovação.
		Return( 4 )
	Endif
Return( 0 )

//--------------------------------------------------------------------------
// Rotina | A610Listar  | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para listar as alçadas pendendes de aprovação do usuário 
//        | em questão.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610Listar( cUsr, cTag )
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	Local nRet := 0
	
	//---------------------------------
	// Estabelecer o ano com 4 dígitos.
	Set( 4, 'dd/mm/yyyy' )
	
	//---------------------------------------
	// Elaborar a query para buscar os dados.
	cSQL := "SELECT SC7_SA2.C7_FILIAL, "
	cSQL += "       SC7_SA2.C7_NUM, "
	cSQL += "       SC7_SA2.C7_FORNECE, "
	cSQL += "       SC7_SA2.C7_LOJA, "
	cSQL += "       SA2.A2_NOME, "
	cSQL += "       SC7_SA2.C7_XVENCTO, "
	cSQL += "       SC7_SA2.C7_COND, "
	cSQL += "       (SELECT SUM(SC7_TOT.C7_TOTAL + SC7_TOT.C7_VALFRE + SC7_TOT.C7_VALIPI"
	cSQL += "                   + SC7_TOT.C7_SEGURO + SC7_TOT.C7_DESPESA - SC7_TOT.C7_VLDESC) "
	cSQL += "        FROM   "+RetSqlName("SC7")+" SC7_TOT "
	cSQL += "        WHERE  SC7_TOT.C7_FILIAL = SC7_SA2.C7_FILIAL "
	cSQL += "               AND SC7_TOT.C7_NUM = SC7_SA2.C7_NUM "
	cSQL += "               AND SC7_TOT.C7_RESIDUO <> 'S' "
	cSQL += "               AND SC7_TOT.D_E_L_E_T_ = ' ') AS TOTAL_PC, "
	cSQL += "       SC7_SA2.CR_USER, "
	cSQL += "       SC7_SA2.CR_APROV "
	cSQL += "FROM   (SELECT SC7.C7_FILIAL, "
	cSQL += "               SC7.C7_NUM, "
	cSQL += "               SC7.C7_FORNECE, "
	cSQL += "               SC7.C7_LOJA, "
	cSQL += "               SC7.C7_XVENCTO, "
	cSQL += "               SC7.C7_COND, "
	cSQL += "               SCR.CR_USER, "
	cSQL += "               SCR.CR_APROV "
	cSQL += "        FROM   "+RetSqlName("SCR")+" SCR "
	cSQL += "               INNER JOIN "+RetSqlName("SC7")+" SC7 "
	cSQL += "                       ON SC7.C7_FILIAL = SCR.CR_FILIAL "
	cSQL += "                          AND SC7.C7_NUM = TRIM(SCR.CR_NUM) "
	cSQL += "                          AND SC7.C7_RESIDUO <> 'S' "
	cSQL += "                          AND SC7.D_E_L_E_T_ = ' ' "
	cSQL += "        WHERE  SCR.CR_FILIAL BETWEEN '  ' AND 'ZZ' "
	cSQL += "               AND SCR.CR_USER = "+ValToSql(cUsr)+" "
	cSQL += "               AND SCR.CR_STATUS = '02' "
	cSQL += "               AND SCR.CR_MAIL_ID <> ' ' "
	cSQL += "               AND SCR.D_E_L_E_T_ = ' ' "
	cSQL += "        GROUP  BY SC7.C7_FILIAL, "
	cSQL += "                  SC7.C7_NUM, "
	cSQL += "                  SC7.C7_FORNECE, "
	cSQL += "                  SC7.C7_LOJA, "
	cSQL += "                  SC7.C7_XVENCTO, "
	cSQL += "                  SC7.C7_COND, "
	cSQL += "                  SCR.CR_USER, "
	cSQL += "                  SCR.CR_APROV	) SC7_SA2 "
	cSQL += "       INNER JOIN "+RetSqlName("SA2")+" SA2 "
	cSQL += "               ON A2_COD = SC7_SA2.C7_FORNECE "
	cSQL += "                  AND A2_LOJA = SC7_SA2.C7_LOJA "
	cSQL += "                  AND SA2.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY C7_FILIAL, "
	cSQL += "          C7_NUM "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	
	//------------------------
	// Se não localizar dados.
	If (cTRB)->( BOF() ) .AND. (cTRB)->( EOF() )
		nRet := 5
	Else
		//------------------------------------------------------------
		// Localizando dados montar a tag para devolver ao requisitor.
		While (cTRB)->( .NOT. EOF() )
			cTag += '<pedido>'     + CRLF
			cTag += '<filial>'     + (cTRB)->C7_FILIAL                                      + '</filial>'         + CRLF
			cTag += '<num_pc>'     + (cTRB)->C7_NUM                                         + '</num_pc>'         + CRLF
			cTag += '<nome_fornec><![CDATA['+ RTrim((cTRB)->A2_NOME)                        + ']]></nome_fornec>' + CRLF
			cTag += '<cond_pagto>' + '('+(cTRB)->C7_COND+') '+RTrim(SE4->(Posicione('SE4',1,xFilial('SE4')+(cTRB)->C7_COND,'E4_DESCRI')))+'</cond_pagto>'+CRLF
			cTag += '<data_vencto>'+ Dtoc(Stod((cTRB)->C7_XVENCTO))                         + '</data_vencto>'    + CRLF
			cTag += '<valor>'      + LTrim(TransForm((cTRB)->TOTAL_PC,'@E 999,999,999.99')) + '</valor>'          + CRLF
			cTag += '<cod_user>'   + (cTRB)->CR_USER                                        + '</cod_user>'       + CRLF
			cTag += '<cod_aprov>'  + (cTRB)->CR_APROV                                       + '</cod_aprov>'      + CRLF
			cTag += '</pedido>'    + CRLF
			(cTRB)->( dbSkip() )
		End
	Endif
	(cTRB)->( dbCloseArea() )
Return( nRet )

//--------------------------------------------------------------------------
// Rotina | A610RecApr  | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que recebe a aprovação/rejeição do aprovador e grava 
//        | o registro LOTE na GTLOG. Rotina acionada pelo WS CSFA750.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610RecApr( cXML, lSincrono )
	Local cAcao := ''
	Local cEmailAprov := ''
	Local cError := ''
	Local cIdOperacao := ''
	Local cMotivo := ''
	Local cMsg := ''
	Local cRet := "<retorno>"
	Local cWarning := ''
	Local dDtOperacao := Ctod('  /  /  ')
	Local nHdl := 0
	Local oXML
	
	DEFAULT lSincrono := .F.
	//---------------------------------------------------------------------
	// Verificar se precisa executar a função que irá criar a tabela GTLOG.
	If .NOT. File( 'gtlog.log' )
		//-----------------------------------
		// Rotina que cria as tabelas de LOG.
		U_GTSetUp()
		//-----------------------------
		// Criar o arquivo de controle.
		nHdl := FCreate( 'gtlog.log' )
		//------------------------------
		// Fechar o arquivo de controle.
		FClose( nHdl )
	Endif
	//---------------------------------------------
	// Fazer o processo de análise do XML recebido.
	oXML := XMLParser( cXML, '_', @cError, @cWarning )
	//-------------------------------
	// Se não houver erro ou warning.
	If cError == '' .AND. cWarning == ''
		//-------------------
		// Capturar os dados.
		cAcao       := Iif( oXML:_SOLICITACAO:_ACAO:TEXT == 'aprovar', 'A', Iif( oXML:_SOLICITACAO:_ACAO:TEXT == 'reprovar', 'R', '' ) )
		cIdOperacao := oXML:_SOLICITACAO:_CODIGO:TEXT
		dDtOperacao := Ctod( oXML:_SOLICITACAO:_DATA:TEXT )
		cEmailAprov := oXML:_SOLICITACAO:_EMAIL:TEXT
		cMotivo     := oXML:_SOLICITACAO:_JUSTIFICATIVA:TEXT
		//----------------------------------
		// Fazer a abertura da tabela GTLOG.
		If Select('GTLOG') <= 0
			A610UseGTL()
		Endif
		//---------------------------
		// Gravar os dados recebidos.
		dbSelectArea( 'GTLOG' )
		dbSetOrder( 1 )
		GTLOG->( RecLock( 'GTLOG', .T. ) )
		GTLOG->GT_IDOPER  := cIdOperacao
		GTLOG->GT_DTOPER  := dDtOperacao
		GTLOG->GT_ACAO    := cAcao
		GTLOG->GT_EMAIL   := cEmailAprov
		GTLOG->GT_MOTIVO  := cMotivo
		GTLOG->GT_PARAM   := cXML
		GTLOG->GT_SEND    := 'F'
		GTLOG->GT_INIPROC := 'F'
		GTLOG->( MsUnLock() )
		GTLOG->( dbCommit() )
		GTLOG->( dbRUnLock( RecNo() ) )
		//--------------------------------
		// Elaborar a mensagem de retorno.
		cRet += "	<codigo>0</codigo>"
		cRet += "	<mensagem>Recebido com sucesso</mensagem>"
	Else
		//----------------------------------------------
		// Se houver crítica, devolver para a aplicação.
		If cError <> ''
			cMsg := cError
		Elseif cWarning <> ''
			cMsg := cWarning
		Else
			cMsg := 'Não foi possível interpretar o XML enviado.'
		Endif
		cRet += "	<codigo>1</codigo>"
		cRet += "	<mensagem>"+cMsg+"</mensagem>"
	Endif
	cRet += "</retorno>"
	//-------------------------------------------------------------------------------
	// Fazer o processo da decomposição e o processamento do pedido em modo síncrono.
	If lSincrono
		//--------------------------------------------
		// Rotina para decompor o XML. Não há retorno.
		A610PJobG( .T., cIdOperacao )
		//-----------------------------------------------------------
		// Rotina para processar o pedido de compras. Não há retorno.
		A610PJobH( .T., cIdOperacao )
	Endif
Return( cRet )

//--------------------------------------------------------------------------
// Rotina | A610UseGTL  | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para abrir a tabela GTLOG e seus índices.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610UseGTL()
	USE GTLOG ALIAS GTLOG SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException( "Falha ao abrir tabela GTLOG - SHARED" )
	Endif
	dbSetIndex("GTLOG01")
	dbSetIndex("GTLOG02")
	dbSetIndex("GTLOG03")
	dbSetIndex("GTLOG04")
	dbSelectArea("GTLOG")
	dbSetOrder(1)
Return

//--------------------------------------------------------------------------
// Rotina | CSFA610G    | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina JOB responsável em decompor o XML recebido pela aplicação
//        | Java.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA610G( aParam )
	Local lAuto := ( Select( 'SX6' ) == 0 )
	
	DEFAULT aParam := { '01', '02' }
	
	Conout('CSFA610G - Iniciando a rotina de processamento da GTLOG (LOTE).')
	If lAuto
		Conout('CSFA610G - Processamento automático por JOB.')
		A610JobG( aParam )
	Else
		Conout('CSFA610G - Processamento manual por usuário '+__cUserID+' '+RTrim(cUserName)+'.')
		U_A610ManG()
	Endif
	Conout('CSFA610G - Finalizadno a rotina de processamento da GTLOG (LOTE).')
Return

//--------------------------------------------------------------------------
// Rotina | A610JobG    | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar do JOB para preparar o ambiente antes de iniciar
//        | a decomposição do XML recebido pela aplicação Java.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610JobG( aParam )
	Local cEmp := ''
	Local cFil := ''
	
	cEmp := Iif( aParam == NIL, '01', aParam[ 1 ] )
	cFil := Iif( aParam == NIL, '02', aParam[ 2 ] )
	
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'COM' TABLES 'SC7', 'SCR'
	Conout('CSFA610G - A610JobG - Executar A610PJobG.')
	A610PJobG( .T. )
	Conout('CSFA610G - A610JobG - Fim da execução A610PJobG.')
	RESET ENVIRONMENT
Return

//--------------------------------------------------------------------------
// Rotina | A610ManG    | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina acionada pelo usuário para efetuar a decomposição do XML 
//        | recebido pela aplicação Java.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610ManG()
	Local cMsg := ''
	
	cMsg := 'Esta rotina irá processar registros de integração da aplicação de aprovação de pedido de compras. '
	cMsg += 'O objetivo e decompor os dados do pedido de compras para posterior processamento de aprovação/rejeição.'
	
	If Aviso( 'Processar', cMsg, { 'Processar', 'Sair' }, 3, 'Decompor PC na GTLOG')==1
		FWMsgRun( , {|| A610PJobG( .F. ), MsgInfo('Processamento finalizado.') }, ,'Aguarde, processando...' )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610PJobG   | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina de processamento para decompor o XML recebido pela
//        | aplicação Java.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610PJobG( lJob, cIdOperacao )
	Local aGTLog := {}
	Local aPedidos := {}
	
	Local cAcao := ''
	Local cCodUser := ''
	Local cEmailApr := ''
	Local cError := ''
	Local cIdOper := ''
	Local cMotivo := ''
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	Local cWarning := ''
	
	Local dDtOper := Ctod('  /  /  ')
	
	Local lCount := .F.
	
	Local nElem := 0
	Local nLoop := 0
	
	Local oXML
	
	DEFAULT cIdOperacao := ''
	
	//-------------------------------------
	// Existe registro LOTE para processar?
	cSQL := "SELECT COUNT(*) AS nCOUNT "
	cSQL += "FROM   GTLOG "
	cSQL += "WHERE  GT_SEND = 'F' "
	cSQL += "       AND GT_INIPROC = 'F' "
	cSQL += "       AND GT_FILPC = ' ' "
	cSQL += "       AND GT_NUMPC = ' ' "
	cSQL += "       AND GTLOG.D_E_L_E_T_ = ' ' "
	
	If cIdOperacao <> ''
		cSQL +=  "       AND GTLOG.GT_IDOPER = " + ValToSql( cIdOperacao ) + " "
	Endif
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL ), cTRB, .F., .T. )
	lCount := ( (cTRB)->nCOUNT > 0 )
	(cTRB)->( dbCloseArea() )
	
	If lCount
		//-----------------------------------------------------------------------
		// Existindo, fazer update para reservar os registros para este processo.
		cSQL := "UPDATE GTLOG "
		cSQL += "       SET GT_INIPROC = '1' "
		cSQL += "WHERE  GT_SEND = 'F' "
		cSQL += "       AND GT_INIPROC = 'F' "
		cSQL += "       AND GT_FILPC = ' ' "
		cSQL += "       AND GT_NUMPC = ' ' "
		cSQL += "       AND GTLOG.D_E_L_E_T_ = ' ' "
		
		If cIdOperacao <> ''
			cSQL +=  "       AND GTLOG.GT_IDOPER = " + ValToSql( cIdOperacao ) + " "
		Endif
		
		If TcSqlExec( cSQL ) < 0
			ConOut( 'CSFA610G - A610JobG - A610PJobG - ERRO NO UPDATE - TCSQLError() ' + TCSQLError() + '.' )
			Return
		Else
			ConOut( 'CSFA610G - A610JobG - A610PJobG - UPDATE EXECUTADO COM SUCESSO.')
		Endif
		
		//------------------------------------------------
		// Fazer a abertura da tabela GTLOG se necessário.
		If Select('GTLOG') <= 0
			A610UseGTL()
		Endif
		
		//---------------------------------------------------------------
		// Buscar todos os registros que foram reservador neste processo.
		cSQL := "SELECT R_E_C_N_O_ AS GT_RECNO "
		cSQL += "FROM   GTLOG "
		cSQL += "WHERE  GT_SEND = 'F' "
		cSQL += "       AND GT_INIPROC = '1' "
		cSQL += "       AND GT_FILPC = ' ' "
		cSQL += "       AND GT_NUMPC = ' ' "
		cSQL += "       AND GTLOG.D_E_L_E_T_ = ' ' "
		
		If cIdOperacao <> ''
			cSQL +=  "       AND GTLOG.GT_IDOPER = " + ValToSql( cIdOperacao ) + " "
		Endif
		
		cSQL += "ORDER  BY R_E_C_N_O_ "
		
		cSQL := ChangeQuery( cSQL )
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL ), cTRB, .F., .T. )
		
		While (cTRB)->( .NOT. EOF() )
			//------------------------------------------
			// Posicionar no registro que foi reservado.
			GTLOG->( dbGoTo( (cTRB)->GT_RECNO ) )
			
			//-----------------------------------------
			// Fazer leitura do XML que foi armazenado.
			oXML := XMLParser( AllTrim( GTLOG->GT_PARAM ), '_', @cError, @cWarning )
			
			//-------------------------------------------------------
			// Fazer a conversão para vetor quando um único elemento.
			If ValType( oXML:_SOLICITACAO:_PEDIDOS:_PEDIDO ) <> 'A'
				XMLNode2Arr( oXML:_SOLICITACAO:_PEDIDOS:_PEDIDO, '_PEDIDO' )
			Endif
			
			//---------------------------			
			// Decompor os dados básicos.
			cIdOper  := oXML:_SOLICITACAO:_CODIGO:TEXT
			dDtOper  := Ctod( oXML:_SOLICITACAO:_DATA:TEXT )
			cAcao    := Iif( oXML:_SOLICITACAO:_ACAO:TEXT == 'aprovar', 'A', Iif( oXML:_SOLICITACAO:_ACAO:TEXT == 'reprovar', 'R', '' ) )
			cEmailApr:= oXML:_SOLICITACAO:_EMAIL:TEXT
			cCodUser := oXML:_SOLICITACAO:_COD_USER:TEXT
			cMotivo  := oXML:_SOLICITACAO:_JUSTIFICATIVA:TEXT
			aPedidos := AClone( oXML:_SOLICITACAO:_PEDIDOS:_PEDIDO )
			
			//-----------------------------------------------------------------------------
			// Decompor os dados de pedido e gravar na tabela para posterior processamento.
			For nLoop := 1 To Len( aPedidos )
				GTLOG->( RecLock( 'GTLOG', .T. ) )
				GTLOG->GT_IDOPER  := cIdOper
				GTLOG->GT_DTOPER  := dDtOper
				GTLOG->GT_ACAO    := cAcao
				GTLOG->GT_EMAIL   := cEmailApr
				GTLOG->GT_MOTIVO  := cMotivo
				GTLOG->GT_CODAPRO := aPedidos[ nLoop ]:_COD_APROV:TEXT
				GTLOG->GT_CODUSER := cCodUser
				GTLOG->GT_FILPC   := aPedidos[ nLoop ]:_FILIAL:TEXT
				GTLOG->GT_NUMPC   := aPedidos[ nLoop ]:_NUM_PC:TEXT
				GTLOG->GT_SEND    := 'F'
				GTLOG->GT_INIPROC := 'F'
				GTLOG->GT_DTPROC  := MsDate()
				GTLOG->GT_HRPROC  := Time()
				GTLOG->GT_LOG     := Dtoc(MsDate())+'-'+Time()+' Processado por ['+Iif(lJob,'JOB',__cUserID+' '+RTrim(cUserName))+'] para decompor os dados do pedido.'
				GTLOG->( MsUnLock() )
			Next nLoop
			//-------------------------------------------
			// Gravar que o registro LOTE foi processado.
			GTLOG->( dbGoTo( (cTRB)->GT_RECNO ) )
			GTLOG->( RecLock( 'GTLOG', .F. ) )
			GTLOG->GT_SEND    := 'T'
			GTLOG->GT_INIPROC := 'T'
			GTLOG->( MsUnLock() )
			
			(cTRB)->( dbSkip() )
		End
		(cTRB)->( dbCloseArea() )
	Else
		Conout('CSFA610G - A610JobG - A610PJobG - Não existe registro LOTE para processar')
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | CSFA610H    | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina Job para processar os pedido/alçadas pendentes na tabela
//        | da integração GTLOG.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA610H( aParam )
	Local lAuto := ( Select( 'SX6' ) == 0 )
	
	DEFAULT aParam := { '01', '02' }
	
	Conout('CSFA610H - Iniciando a rotina de processamento da GTLOG (PEDIDO).')
	If lAuto
		Conout('CSFA610H - Processamento automático por JOB.')
		A610JobH( aParam )
	Else
		Conout('CSFA610H - Processamento manual por usuário '+__cUserID+' '+RTrim(cUserName)+'.')
		U_A610ManH()
	Endif
	Conout('CSFA610H - Finalizadno a rotina de processamento da GTLOG (PEDIDO).')
Return

//--------------------------------------------------------------------------
// Rotina | A610JobH    | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para preparar o ambiente antes de inciar o 
//        | processamento do pedido/alçada para aprovação/rejaição.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610JobH( aParam )
	Local cEmp := ''
	Local cFil := ''
	
	cEmp := Iif( aParam == NIL, '01', aParam[ 1 ] )
	cFil := Iif( aParam == NIL, '02', aParam[ 2 ] )
	
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'COM' TABLES 'SC7', 'SCR'
	Conout('CSFA610H - A610JobH - Executar A610PJobH.')
	A610PJobH( .T. )
	Conout('CSFA610H - A610JobH - Fim da execução A610PJobH.')
	RESET ENVIRONMENT
Return

//--------------------------------------------------------------------------
// Rotina | A610ManH    | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina auxiliar para o processamento do pedido/alçada para 
//        | aprovação/rejaição, esta é acionada pelo usuário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610ManH()
	Local cMsg := ''
	
	cMsg := 'Esta rotina irá processar registros de integração da aplicação de aprovação de pedido de compras. '
	cMsg += 'O objetivo e fazer a submeter para aprovação/rejeição do pedido de compras.'
	
	If Aviso( 'Processar', cMsg, { 'Processar', 'Sair' }, 3, 'Submete PC para aprovação/rejeição')==1
		FWMsgRun( , {|| A610PJobH( .F. ), MsgInfo('Processamento finalizado.') }, ,'Aguarde, processando...' )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610PJobH   | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para processar a alçada e seu pedido para aprovação ou 
//        | rejeição conforme a ação do aprovador.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610PJobH( lJob, cIdOperacao )
	Local aBkpUsrSys := { NIL, NIL }
	Local aMsg := {}
	Local aPsw := {}
	Local aPswElab := {}
	Local aRetSaldo := {}
	Local aUsrElab := {}
	
	Local cAssunto := ''
	Local cAuxNivel := ''
	Local cBkpFilial := cFilAnt
	Local cCodLiber := ''
	Local cCR_LOG := ''
	Local cDocto := ''
	Local cGrupo := ''
	Local cMotivo := ''
	Local cSQL := ''
	Local cTipoDoc := ''
	Local cTRB := GetNextAlias()
	
	Local lCount := .F.
	Local lFoundSCR := .F.
	Local lLiberado := .F.
	Local lPendencia := .F.
	
	Local nElem := 0
	Local nRec := 0
	Local nRecSC7 := 0
	Local nRecSCR := 0
	Local nTotal := 0
	
	DEFAULT cIdOperacao := ''
	
 	//-------------------------------------
  	// Existe registro PEDIDO para processar?
	cSQL := "SELECT COUNT(*) AS nCOUNT "
	cSQL += "FROM   GTLOG "
	cSQL += "WHERE  GT_SEND = 'F' "
	cSQL += "       AND GT_INIPROC = 'F' "
	cSQL += "       AND GT_FILPC <> ' ' "
	cSQL += "       AND GT_NUMPC <> ' ' "
	cSQL += "       AND GTLOG.D_E_L_E_T_ = ' ' "

	If cIdOperacao <> ''
		cSQL +=  "       AND GTLOG.GT_IDOPER = " + ValToSql( cIdOperacao ) + " "
	Endif
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL ), cTRB, .F., .T. )
	lCount := ( (cTRB)->nCOUNT > 0 )
	
	(cTRB)->( dbCloseArea() )
	
	If lCount
		//-----------------------------------------------------------------------
		// Existindo, fazer update para reservar os registros para este processo.
		cSQL := "UPDATE GTLOG "
		cSQL += "       SET GT_INIPROC = '1' "
		cSQL += "WHERE  GT_SEND = 'F' "
		cSQL += "       AND GT_INIPROC = 'F' "
		cSQL += "       AND GT_FILPC <> ' ' "
		cSQL += "       AND GT_NUMPC <> ' ' "
		cSQL += "       AND GTLOG.D_E_L_E_T_ = ' ' "
		
		If cIdOperacao <> ''
			cSQL +=  "       AND GTLOG.GT_IDOPER = " + ValToSql( cIdOperacao ) + " "
		Endif
		
		If TcSqlExec( cSQL ) < 0
			ConOut( 'CSFA610H - A610JobH - A610PJobH - ERRO NO UPDATE - TCSQLError() ' + TCSQLError() + '.' )
			Return
		Else
			ConOut( 'CSFA610H - A610JobH - A610PJobG - UPDATE EXECUTADO COM SUCESSO.')
		Endif
	
		//---------------------------------------------------------------
		// Buscar todos os registros que foram reservados neste processo.
		cSQL := "SELECT R_E_C_N_O_ AS GT_RECNO "
		cSQL += "FROM   GTLOG "
		cSQL += "WHERE  GT_SEND = 'F' "
		cSQL += "       AND GT_INIPROC = '1' "
		cSQL += "       AND GT_FILPC <> ' ' "
		cSQL += "       AND GT_NUMPC <> ' ' "
		cSQL += "       AND GTLOG.D_E_L_E_T_ = ' ' "
		
		If cIdOperacao <> ''
			cSQL +=  "       AND GTLOG.GT_IDOPER = " + ValToSql( cIdOperacao ) + " "
		Endif
		
		cSQL += "ORDER  BY R_E_C_N_O_ "
		
		cSQL := ChangeQuery( cSQL )
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL ), cTRB, .F., .T. )
		
		While (cTRB)->( .NOT. EOF() )
			//------------------------------------------------
			// Fazer a abertura da tabela GTLOG se necessário.
			If Select('GTLOG') <= 0
				A610UseGTL()
			Endif
			
			//------------------------------------------
			// Posicionar no registro que foi reservado.
			GTLOG->( dbGoTo( (cTRB)->GT_RECNO ) )
			
			If cFilAnt <> GTLOG->GT_FILPC
				cFilAnt := GTLOG->GT_FILPC
			Endif
						
			//------------------
			// Posicionar no PC.
			dbSelectArea( 'SC7' )
			SC7->( dbSetOrder( 1 ) )
			SC7->( dbSeek( GTLOG->GT_FILPC + GTLOG->GT_NUMPC ) )
			
			//---------------------------------
			// Se não localizar o PC registrar.
			If .NOT. SC7->( Found() )
				GTLOG->( RecLock( 'GTLOG', .F. ) )
				GTLOG->GT_INIPROC := '2' // Pedido não localizado.
				GTLOG->GT_LOG     := Dtoc(MsDate())+'-'+Time()+' Processado por ['+Iif(lJob,'JOB',__cUserID+' '+RTrim(cUserName))+'] pedido não localizado.'
				GTLOG->( MsUnLock() )
				
				(cTRB)->( dbSkip() )
				Loop
			Endif
			
			//------------------------------------------------------
			// Verificar se o PC pode ser bloqueado para manutenção.
			If .NOT. SC7->( MsRLock( RecNo() ) )
				GTLOG->( RecLock( 'GTLOG', .F. ) )
				GTLOG->GT_INIPROC := '5' // Pedido em uso, não será possível processar.
				GTLOG->GT_LOG     := Dtoc(MsDate())+'-'+Time()+' Processado por ['+Iif(lJob,'JOB',__cUserID+' '+RTrim(cUserName))+'] pedido em uso, não será possível processar.'
				GTLOG->( MsUnLock() )
				
				(cTRB)->( dbSkip() )
				Loop
			Endif
			SC7->( MsRUnLock( RecNo() ) )
			
			nRecSC7 := SC7->( RecNo() )
			cGrupo  := SC7->C7_APROV
			
			//----------------------
			// Posicionar na alçada.
			dbSelectArea( 'SCR' )
			SCR->( dbsetorder( 2 ) )
			lFoundSCR := SCR->( dbSeek( GTLOG->GT_FILPC + 'PC' + PadR( GTLOG->GT_NUMPC, Len( SCR->CR_NUM ), ' ' ) + GTLOG->GT_CODUSER ) )
			
			//-------------------------------------
			// Se não localizar a alçada registrar.
			If .NOT. lFoundSCR
				GTLOG->( RecLock( 'GTLOG', .F. ) )
				GTLOG->GT_INIPROC := '3' // Alçada não lozalizada.
				GTLOG->GT_LOG     := Dtoc(MsDate())+'-'+Time()+' Processado por ['+Iif(lJob,'JOB',__cUserID+' '+RTrim(cUserName))+'] alçada não localizada.'
				GTLOG->( MsUnLock() )
				
				(cTRB)->( dbSkip() )
				Loop
			Endif
			
			//-------------------------------------------------------
			// Verificar se há pendência para o aprovador em questão.
			While SCR->( .NOT. EOF() ) .AND. ;
					SCR->CR_FILIAL == GTLOG->GT_FILPC .AND. ;
					SCR->CR_TIPO == 'PC' .AND. ;
					SCR->CR_NUM == PadR( GTLOG->GT_NUMPC, Len( SCR->CR_NUM ), ' ' ) .AND. ;
					SCR->CR_USER == GTLOG->GT_CODUSER .AND. ;
					lFoundSCR
     			
				If SCR->CR_STATUS == '02'
					lPendencia := .T.
					Exit
				Endif
				SCR->( dbSkip() )
			End
			
			//---------------------------------------------------
			// Se não localizar o registro de penência registrar.
			If .NOT. lPendencia
				GTLOG->( RecLock( 'GTLOG', .F. ) )
				GTLOG->GT_INIPROC := '4' // Pendência de alçada não lozalizada.
				GTLOG->GT_LOG     := Dtoc(MsDate())+'-'+Time()+' Processado por ['+Iif(lJob,'JOB',__cUserID+' '+RTrim(cUserName))+'] pendência de alçada não localizada.'
				GTLOG->( MsUnLock() )
				
				(cTRB)->( dbSkip() )
				Loop
			Endif
			
			//--------------------------------------
			// Capturar dados do usuário elaborador.
			nElem := AScan( aUsrElab, {|e| e[ 1 ] == SC7->C7_USER } )
			If nElem == 0
				PswOrder( 1 )
				PswSeek( SC7->C7_USER )
				aPswElab := PswRet( 1 )
				AAdd( aUsrElab, {	SC7->C7_USER,;										//[1]-Código
				Capital( RTrim( aPswElab[ 1, 4 ] ) ) ,;	//[2]-Nome completo
				RTrim( aPswElab[ 1, 14 ] ) } )				//[3]-e-mail
				nElem := Len( aUsrElab )
			Endif
			
			//-------------------------------------
			// Posicionar no cadastro do aprovador.
			SAK->( dbSetOrder( 1 ) )
			SAK->( dbSeek( xFilial( 'SAK' ) + SCR->CR_APROV ) )
			
			//-----------------------------------------------------------
			// Posicionar no registro do aprovador no grupo de aprovação.
			SAL->( dbSetOrder( 3 ) )
			SAL->( dbSeek( xFilial( 'SAL' ) + SC7->C7_APROV + SCR->CR_APROV ) )
			
			//----------------------------------------------------------------------
			// Atribuir as variáveis para serem processadas pela função A097ProcLib.
			nRecSCR := SCR->( RecNo() )
			cCodLiber := SCR->CR_APROV
			aRetSaldo := MaSalAlc( cCodLiber, MsDate() )
			nTotal    := xMoeda( SCR->CR_TOTAL, SCR->CR_MOEDA, aRetSaldo[ 2 ], SCR->CR_EMISSAO,, SCR->CR_TXMOEDA )
			
			//---------------------------------------------
			// Salvar o conteúdo das variáveis do Protheus.
			If Type( '__cUserID' ) == 'C'
				aBkpUsrSys[ 1 ] := __cUserID
			Endif
			If Type( 'cUserName' ) == 'C'
				aBkpUsrSys[ 2 ] := cUserName
			Endif
			
			//----------------------------------------------------------
			// Posicionar no usuário do aprovador e capturar seus dados.
			PswOrder( 1 )
			PswSeek( GTLOG->GT_CODUSER )
			aPsw := PswRet()
			
			//-----------------------------------
			// Atribuir as variáveis do Protheus.
			__cUserID := SCR->CR_USER
			cUserName := aPsw[ 1, 2 ]
			
			//------------------------------------------------------------
			// Executar a rotina padrão de aprovação de pedido de compras.
			A097ProcLib( nRecSCR, Iif( GTLOG->GT_ACAO == 'A', 2, 3 ), nTotal, cCodLiber, cGrupo, RTrim( GTLOG->GT_MOTIVO ), MsDate() )
			
			//-------------------------
			// Reposicionar o registro.
			SC7->( MsGoTo( nRecSC7 ) )
			
			//-----------------------------------
			// Reposicionar o registro da alçada.
			SCR->( MsGoTo( nRecSCR ) )
			
			//-------------------------------------------------------------------------
			// Verificar se o próximo nível é igual ao atual, se há aprovação conjunta.
			//A610PrxNiv( xFilial( 'SCR' ), SCR->CR_NUM, SCR->CR_TIPO, SCR->CR_NIVEL )
			
			//------------------------------------
			// Restaurar as variáveis do Protheus.
			__cUserID := aBkpUsrSys[ 1 ]
			cUserName := aBkpUsrSys[ 2 ]
			
			//-----------------------------------------------
			// Se foi aprovado ou rejeitado, gravar o motivo.
			If SCR->CR_STATUS $ '03|04|05'
				cMotivo := Dtoc(MsDate())+'-'+Time()+' Processado por ['+Iif(lJob,'JOB',__cUserID+' '+RTrim(cUserName))+']. Motivo: ' + RTrim( GTLOG->GT_MOTIVO ) + '. '
				cMotivo += 'Ação: ' + Iif(SCR->CR_STATUS=='03','03-Aprovado',Iif(SCR->CR_STATUS=='04','04-Rejeitado','05-Liberado'))
				cCR_LOG := Iif( .NOT. Empty( SCR->CR_LOG ), AllTrim( SCR->CR_LOG ) + CRLF, '' ) + cMotivo
				
				SCR->( RecLock( 'SCR', .F. ) )
				SCR->CR_LOG := cCR_LOG
				SCR->( MsUnLock() )
				
				//------------------------------------------------------------------------------
				// Foi localizado os dados do elaborador e capturado seu nome completo e e-mail?
				// Sim, então enviar aviso de e-mail. 
				If nElem > 0
					lLiberado := A610ProxApr( .F. )
					
					AAdd( aMsg, rTrim(SCR->CR_NUM) )
					AAdd( aMsg, Iif(SCR->CR_STATUS $ '03|05',;
						Iif(lLiberado,'pedido de compra liberado e apto para entrar com o pré documento de entrada',;
						'alçada do pedido de compras aprovado, há mais aprovação(ões) para ser(em) analisada(s)'),;
						'alçada do pedido de compras rejeitado'))
					AAdd( aMsg, Dtoc( MsDate() ) )
					AAdd( aMsg, Time() )
					AAdd( aMsg, RTrim( GTLOG->GT_MOTIVO ) )
					
					cAssunto := 'Pedido de Compra nº ' + SCR->CR_FILIAL + '-' + rTrim(SCR->CR_NUM) + Iif( SCR->CR_STATUS $ '03|05', ' APROVADO', ' REJEITADO')+'.'
					IF .Not. lLiberado
						A610WFAvUs( aMsg, { RTrim( aUsrElab[ nElem, 2 ] ), RTrim( aUsrElab[ nElem, 3 ] ) }, cAssunto, .F., .F., 'A610PJobH' )
					Endif
				Endif
			Endif
			
			//---------------------------------
			// Registrar o sucesso do processo.
			GTLOG->( RecLock( 'GTLOG', .F. ) )
			GTLOG->GT_SEND    := 'T'
			GTLOG->GT_INIPROC := 'T' // Aprovação/Rejeição efetuada com sucesso.
			GTLOG->GT_LOG     := Dtoc(MsDate())+'-'+Time()+' Processado por ['+Iif(lJob,'JOB',__cUserID+' '+RTrim(cUserName))+'] '+Iif(GTLOG->GT_ACAO=='A','aprovação','reprovação')+' efetuada com sucesso.'
			GTLOG->( MsUnLock() )
			
			//-------------------------------------------------------------------------------------------------
			// Verificar se tem próximo nível para aprovar, havendo enviar ( parâmetro .T. ) aviso de workflow.
			A610ProxApr( .T. )
			
			(cTRB)->( dbSkip() )
		End
		(cTRB)->( dbCloseArea() )
		
		If cFilAnt <> cBkpFilial
			cFilAnt := cBkpFilial
		Endif
	Else
		Conout('CSFA610H - A610JobH - A610PJobH - Não existe registro PEDIDO para processar')
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A610Situac  | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que efetua consulta do resultado do processamento da 
//        | liberação da alçada na GTLOG.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Situac( cXML )
	Local aPedidos := {}
	
	Local cCodUser := ''
	Local cError := ''
	Local cIdOper := ''
	Local cMsg := ''
	Local cMsgLog := ''
	Local cRet := '<retorno>'
	Local cSQL := ''
	Local cTRB := ''
	Local cWarning := ''
	
	Local nHld := 0
	Local nLoop := 0
	
	Local oXML
	
	//---------------------------------------------------------------------
	// Verificar se precisa executar a função que irá criar a tabela GTLOG.
	If .NOT. File( 'gtlog.log' )
		//-----------------------------------
		// Rotina que cria as tabelas de LOG.
		U_GTSetUp()
		
		//-----------------------------
		// Criar o arquivo de controle.
		nHdl := FCreate( 'gtlog.log' )
		
		//------------------------------
		// Fechar o arquivo de controle.
		FClose( nHdl )
	Endif
	
	//----------------------------------
	// Fazer a abertura da tabela GTLOG.
	If Select('GTLOG') <= 0
		A610UseGTL()
	Endif
	
	//---------------------------------------------
	// Fazer o processo de análise do XML recebido.
	oXML := XMLParser( cXML, '_', @cError, @cWarning )
	
	// Fazer a conversão para vetor quando um único elemento.
	If ValType( oXML:_SOLICITACAO:_PEDIDOS:_PEDIDO ) <> 'A'
		XMLNode2Arr( oXML:_SOLICITACAO:_PEDIDOS:_PEDIDO, '_PEDIDO' )
	Endif
	
	//-------------------------------
	// Se não houver erro ou warning.
	If cError == '' .AND. cWarning == ''
		cIdOper  := oXML:_SOLICITACAO:_CODIGO:TEXT
		cCodUser := oXML:_SOLICITACAO:_COD_USER:TEXT
		aPedidos := AClone( oXML:_SOLICITACAO:_PEDIDOS:_PEDIDO )
		
		cRet +="<codigo>0</codigo>"
		cRet +="<mensagem>Sucesso ao ler o XML.</mensagem>"
		cRet +="<pedidos>"
		
		//------------------------------------------------------------
		// Buscar o registro e elaborar o retorno conforme a consulta.
		cTRB := GetNextAlias()
		For nLoop := 1 To Len( aPedidos )
			cSQL := "SELECT R_E_C_N_O_ AS GT_RECNO "
			cSQL += "FROM   GTLOG GTLOG "
			cSQL += "WHERE  GT_FILPC = "+ValToSQL( aPedidos[ nLoop ]:_FILIAL:TEXT )+" "
			cSQL += "       AND GT_NUMPC = "+ValToSQL( aPedidos[ nLoop ]:_NUM_PC:TEXT )+" "
			cSQL += "       AND GT_CODUSER = "+ValToSQL( cCodUser )+" "
			cSQL += "       AND GT_CODAPRO = "+ValToSQL( aPedidos[ nLoop ]:_COD_APROV:TEXT )+" "
			cSQL += "       AND GT_IDOPER = "+ValToSQL( cIdOper )+" "
			cSQL += "       AND GTLOG.D_E_L_E_T_ = ' ' "
			
			cSQL := ChangeQuery( cSQL )
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
			
			cRet += "<pedido>"
			cRet += "<filial>"   +aPedidos[ nLoop ]:_FILIAL:TEXT   +"</filial>"
			cRet += "<num_pc>"   +aPedidos[ nLoop ]:_NUM_PC:TEXT   +"</num_pc>"
			cRet += "<cod_user>" +cCodUser                         +"</cod_user>"
			cRet += "<cod_aprov>"+aPedidos[ nLoop ]:_COD_APROV:TEXT+"</cod_aprov>"
			
			If (cTRB)->( BOF() ) .AND. (cTRB)->( EOF() )
				cRet += "<status>6</status>"
				cRet += "<mensagem>Informação não localizada.</mensagem>"
			Else
				GTLOG->( dbGoTo( (cTRB)->GT_RECNO ) )
				cRet += "<status>"+GTLOG->GT_INIPROC+"</status>"
				cRet += "<mensagem>"+GTLOG->GT_LOG+"</mensagem>"
			Endif
			
			cRet += "</pedido>"
			
			(cTRB)->( dbCloseArea() )
		Next nLoop
		cRet += "</pedidos>"
	Else
		//----------------------------------------------
		// Se houver crítica, devolver para a aplicação.
		If cError <> ''
			cMsg := cError
		Elseif cWarning <> ''
			cMsg := cWarning
		Else
			cMsg := "Não foi possível interpretar o XML enviado."
		Endif
		cRet += "<codigo>1</codigo>"
		cRet += "<mensagem>"+cMsg+"</mensagem>"
	Endif
	cRet += '</retorno>'
	
	cMsgLog := 'Foi solicitado consulta a situação do pedido, recebi o XML: '+cXML+' e retornei a seguinte resposta: '+cRet+''
	A610GrvLog( cMsgLog )
Return( cRet )

//--------------------------------------------------------------------------
// Rotina | A610Ped     | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para consultar os dados do pedido, inclusive a capa de 
//        | despesa física.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Ped( cFilialPC, cNumeroPC )
	Local aC7_ANEXOS := {}
	
	Local cBkpFilAnt := cFilAnt
	Local cCapaDesp := ''
	Local cMsDocPath := ''
	Local cMsgLog := ''
	Local cMV610_009 := 'MV_610_009'
	Local cPICT := '@E 999,999,999.99'
	Local cRet := ''
	Local cRet1 := '<retorno>'
	Local cRet2 := ''
	Local cRootPath := ''
	Local cTOTAL_PC := ''
	
	Local lDesconto := .F.
	Local lDespesa := .F.
	Local lFrete := .F.
	Local lIpi := .F.
	Local lSeguro := .F.

	Local nC7_TOTAL := 0
	Local nLoop := 0
	
	Set( 4, 'dd/mm/yyyy' )
	
	If cFilAnt <> cFilialPC
		cFilAnt := cFilialPC
	Endif
	
	dbSelectArea( 'SC7' )
	SC7->( dbSetOrder( 1 ) )
	If SC7->( dbSeek( cFilialPC + cNumeroPC ) )
	
		SA2->( dbSetOrder( 1 ) )
		SA2->( dbSeek( xFilial( 'SA2' ) + SC7->C7_FORNECE + SC7->C7_LOJA ) )
		
		SE4->( dbSetOrder( 1 ) )
		SE4->( dbSeek( xFilial( 'SE4' ) + SC7->C7_COND ) )
		
		cTOTAL_PC := LTrim( TransForm( A610TotPC( SC7->C7_FILIAL, SC7->C7_NUM ), cPICT ) )
		
		A610GetAnexo( @aC7_ANEXOS, cFilialPC + cNumeroPC, NIL )
				
		If .NOT. GetMv( cMV610_009, .T. )
			CriarSX6( cMV610_009, 'C', 'ROOTPATH DO PROTHEUS, SE EM BRANCO SERA CONSIDERADO GetSrvProfString = RootPath - ROTINA CSFA610.prw', '' )
		Endif
		
		cMV610_009 := GetMv( cMV610_009, .F. )
		
		If Empty( cMV610_009 )
			cRootPath := GetSrvProfString( 'RootPath' , '' )
		Else
			cRootPath := cMV610_009
		Endif
		
		For nLoop := 1 To Len( aC7_ANEXOS )
			If 'CAPADESPESA_' $ aC7_ANEXOS[ nLoop ]
				cCapaDesp := cRootPath + aC7_ANEXOS[ nLoop ]
			Endif
		Next nLoop
		
		cCapaDesp := Encode64( cCapaDesp )
		
		cRet1 += '<codigo>0</codigo>'
		cRet1 += '<mensagem>Pedido de compra localizado</mensagem>'
		cRet1 += '<pedido>'
		cRet1 += '<num_pc>'              + SC7->C7_NUM                                  + '</num_pc>'
		cRet1 += '<emissao>'             + Dtoc(SC7->C7_EMISSAO)                        + '</emissao>'
		cRet1 += '<fornecedor><![CDATA[' + '('+SC7->C7_FORNECE+') '+RTrim(SA2->A2_NOME) + ']]></fornecedor>'
		cRet1 += '<cond_pagto>'          + '('+SC7->C7_COND+') '+RTrim(SE4->E4_DESCRI)  + '</cond_pagto>'
		cRet1 += '<vlt_total_pc>'        + cTOTAL_PC                                    + '</vlt_total_pc>'
		cRet1 += '<doc_capa_desp>'       + cCapaDesp                                    + '</doc_capa_desp>'
		
		cRet2 += '<itens>'
		
		While SC7->( .NOT. EOF() ) .AND. SC7->C7_FILIAL == cFilialPC .AND. SC7->C7_NUM == cNumeroPC
			
			nC7_TOTAL   += ( SC7->( C7_TOTAL + C7_DESPESA + C7_VALFRE + C7_VALIPI + C7_SEGURO ) - SC7->C7_VLDESC )
			
			cRet2 += '<item>'
			cRet2 += '<item_pc>'    + SC7->C7_ITEM                                          + '</item_pc>'
			cRet2 += '<produto>'    + '('+RTrim(SC7->C7_PRODUTO)+') '+RTrim(SC7->C7_DESCRI) + '</produto>'
			cRet2 += '<quantidade>' + LTrim(TransForm(SC7->C7_QUANT,cPICT))                 + '</quantidade>'
			cRet2 += '<unitario>'   + LTrim(TransForm(SC7->C7_PRECO,cPICT))                 + '</unitario>'
			cRet2 += '<total_item>' + LTrim(TransForm(nC7_TOTAL,cPICT))                     + '</total_item>'
			
			cRet2 += '<despesa>' + LTrim( TransForm( SC7->C7_DESPESA, cPICT ) ) + '</despesa>'
			cRet2 += '<frete>'   + LTrim( TransForm( SC7->C7_VALFRE, cPICT  ) ) + '</frete>'
			cRet2 += '<ipi>'     + LTrim( TransForm( SC7->C7_VALIPI, cPICT  ) ) + '</ipi>'
			cRet2 += '<seguro>'  + LTrim( TransForm( SC7->C7_SEGURO, cPICT  ) ) + '</seguro>'
			cRet2 += '<desconto>'+ LTrim( TransForm( SC7->C7_VLDESC, cPICT  ) ) + '</desconto>'
			cRet2 += '</item>'
			
			If SC7->C7_DESPESA > 0
				lDespesa := .T.
			Endif
			
			If SC7->C7_VALFRE > 0
				lFrete := .T.
			Endif
			
			If SC7->C7_VALIPI > 0
				lIpi := .T.
			Endif
			
			If SC7->C7_SEGURO > 0
				lSeguro := .T.
			Endif
			
			If SC7->C7_VLDESC > 0
				lDesconto := .T.
			Endif
			
			nC7_TOTAL := 0
			
			SC7->( dbSkip() )
		End
		
		cRet1 += '<despesa>'  + Iif( lDespesa, 'true', 'false' ) + '</despesa>'
		cRet1 += '<frete>'    + Iif( lFrete,   'true', 'false' ) + '</frete>'
		cRet1 += '<ipi>'      + Iif( lIpi,     'true', 'false' ) + '</ipi>'
		cRet1 += '<seguro>'   + Iif( lSeguro,  'true', 'false' ) + '</seguro>'
		cRet1 += '<desconto>' + Iif( lDesconto,'true', 'false' ) + '</desconto>'
		
		cRet2 += '</itens>'
		cRet2 += '</pedido>'
	Else
		cRet1 += '<codigo>1</codigo>'
		cRet1 += '<mensagem>Pedido de compra não localizado</mensagem>'
	Endif
	
	cRet2 += '</retorno>'
	
	cRet := cRet1 + cRet2
	
	cMsgLog := 'Foi solicitado a consulta ao pedido -> filial: '+cFilialPC+' nº PC: '+cNumeroPC+' e retornei a seguinte resposta: '+cRet
	A610GrvLog( cMsgLog )
	
	If cFilAnt <> cBkpFilAnt
		cFilAnt := cBkpFilAnt
	Endif
Return( cRet )

//--------------------------------------------------------------------------
// Rotina | A610PrxNiv  | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar se há alçada no mesmo nível com tipo de 
//        | liberação N=nível ou P=pedido para registrar que não é necessário 
//        | aprovação, pois assim caracteriza aprovação em conjunto.
//--------------------------------------------------------------------------
// Retirada função pois estava liberando o pedido de forma incorreta.
// Rafael Beghini - 22.05.2018
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
/*Static Function A610PrxNiv( cFilSCR, cDocto, cTipoDoc, cAuxNivel )
	Local nRec := 0
	SCR->( dbSeek( cFilSCR + cTipoDoc + cDocto + cAuxNivel ) )
	nRec := SCR->( RecNo() )
	While SCR->( .NOT. EOF() ) .AND. SCR->CR_FILIAL == xFilial( 'SCR' ) .AND. SCR->CR_NUM == cDocto .AND. SCR->CR_TIPO == cTipoDoc
		SAL->( dbSetOrder( 3 ) )
		SAL->( dbSeek( xFilial( 'SAL' ) + SC7->C7_APROV + SCR->CR_APROV ) )
		If SCR->CR_NIVEL == cAuxNivel .AND. SCR->CR_STATUS <> '03' .AND. SAL->AL_TPLIBER $ 'NP'
			SCR->( RecLock( 'SCR', .F.) )
			SCR->CR_STATUS  := '05'
			SCR->CR_DATALIB := MsDate()
			SCR->CR_USERLIB := SAK->AK_USER
			SCR->CR_OBS     := ''
			SCR->( MsUnLock() )
		EndIf
		SCR->( dbSkip() )
	End
	SCR->( dbGoTo( nRec ) )
Return
*/
//--------------------------------------------------------------------------
// Rotina | A610ProxApr | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar se o pedido de compras possui mais alçada 
//        | de aprovação. Havendo, enviar email de aviso de aprovação para o 
//        | próximo aprovador.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610ProxApr( lSend )
	Local aAprov := {}
	Local cCR_FILIAL := GTLOG->GT_FILPC
	Local cCR_NUM := PadR( GTLOG->GT_NUMPC, Len( SCR->CR_NUM ), ' ' )
	Local cTB_Qry := GetNextAlias()
	Local lPendencia := .F.
	//-----------------------------------------------
	// Tem mais alçada para avaliar/aprovar/rejeitar.
	BEGINSQL ALIAS cTB_Qry
		SELECT COUNT(*) AS SCR_COUNT
		FROM   %Table:SCR% SCR
		WHERE  CR_FILIAL = %Exp:cCR_FILIAL%
		AND CR_NUM = %Exp:cCR_NUM%
		AND CR_TIPO = 'PC'
		AND CR_STATUS = '02'
		AND CR_DATALIB = ' '
		AND CR_MAIL_ID = ' '
		AND SCR.%NotDel%
	ENDSQL
	lPendencia := ((cTB_Qry)->SCR_COUNT > 0)
	(cTB_Qry)->( dbCloseArea())
	//---------------------------------------------------------------------------
	// Se há alçada para aprovar, então acionar a rotina de envio de aviso de WF.
	If lPendencia .AND. lSend
		cCR_NUM := RTrim( cCR_NUM )
		aAprov := A610WF_Apv( cCR_FILIAL + cCR_NUM )
		If Len( aAprov ) > 0
			A610WF_Env( cCR_FILIAL + cCR_NUM )
		Endif
	Endif
Return( lPendencia )

//--------------------------------------------------------------------------
// Rotina | A610TotPC   | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para buscar o valor total do pedido de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610TotPC( cFilPC, cNumPC )
	Local aArea := GetArea()
	BeginSQL Alias "TMPSC7"
		SELECT SUM(C7_TOTAL + C7_VALFRE + C7_SEGURO + C7_VALIPI + C7_DESPESA - C7_VLDESC) TOTPED
		FROM %Table:SC7%
		WHERE %NotDel% AND
		C7_FILIAL = %Exp:cFilPC% AND
		C7_RESIDUO = ' ' AND
		C7_NUM = %Exp:cNumPC%
	EndSQL
	nRet := TMPSC7->TOTPED
	TMPSC7->(dbCloseArea())
	RestArea(aArea)
Return( nRet )

//--------------------------------------------------------------------------
// Rotina | A610GrvLog  | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para gravar o log de comunicação entre o Protheus e a
//        | aplicação Java.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610GrvLog( cMsgLog )
	Local cGT_IDOPER := ''
	//----------------------------------
	// Fazer a abertura da tabela GTLOG.
	If Select('GTLOG') <= 0
		A610UseGTL()
	Endif
	//--------------------------------------
	// Capturar o próximo número disponível.
	cGT_IDOPER := 'LOG' + A610PrxNum()
	//---------------------------
	// Efetuar a gravação do LOG.
	GTLOG->( RecLock( 'GTLOG', .T. ) )
	GTLOG->GT_IDOPER  := cGT_IDOPER
	GTLOG->GT_DTOPER  := MsDate()
	GTLOG->GT_ACAO    := 'L'
	GTLOG->GT_MOTIVO  := 'SOLICITAÇÃO PARA O PROTHEUS.'
	GTLOG->GT_DTPROC  := MsDate()
	GTLOG->GT_HRPROC  := Time()
	GTLOG->GT_LOG     := cMsgLog
	GTLOG->( MsUnLock() )
Return

//--------------------------------------------------------------------------
// Rotina | A610PrxNum  | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para buscar próximo número no controle de LOG.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A610PrxNum()
	Local cMV610_010 := 'MV_610_010'
	
	If .NOT. GetMv( cMV610_010, .T. )
		CriarSX6( cMV610_010, 'C',;
			'ULTIMO NUMERO SEQUENCIAL NA COMUNICACAO COM A APLICACAO JAVA P/ APROVAR PC. ESTE VALOR NAO DEVE SER ALTERADO PELOS USUARIOS. ROTINA CSFA610.prw.',;
			'000000' )
	Endif
	
	cMV610_010 := Soma1( GetMv( cMV610_010, .F. ) )
	
	While GTLOG->( dbSeek( 'LOG' + cMV610_010 ) )
		cMV610_010 := Soma1( cMV610_010 )
	End
	
	PutMV( 'MV_610_010', cMV610_010 )
Return( cMV610_010 )

//--------------------------------------------------------------------------
// Rotina | A610GTLOG   | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para fazer consulta na tabela GTLOG.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610GTLOG()
	Local aCOLS := {}
	Local aHeader := {}
	Local aRet := {}
	Local cTRB := ''
	Local lQry := .T.
	
	Private cCadastro := 'Integração ERP x Aprovação de PC'
	
	If .NOT. GTLApres()
		Return
	Endif
	
	If .NOT. GTLParam( @aRet )
		Return
	Endif
	
	ProcessaDoc( {|| lQry := GTLQuery( @cTRB, @aCOLS, aRet ) }, cCadastro ,'Carregando os dados...' )
	
	If .NOT. lQry
		Return
	Endif
	
	GTLHead( aHeader, 1 )
	
	GTLShow( aHeader, aCOLS )
Return

//--------------------------------------------------------------------------
// Rotina | GTLApres    | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que apresenta o objetivo do programa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLApres()
	Local nOpcao := 0
	FormBatch(cCadastro,{'Rotina para consultar os registros da comunicação da integração entre os sistemas ','ERP Protheus e a aplicação java.','',;
		'Também é possível executar os JOBs de decomposição e avaliação da aprovação ','de alçada que trafegou nesta integração.','',;
		'Clique em OK para prosseguir...'},{ { 1, .T., { || nOpcao := 1, FechaBatch() } }, { 22, .T., { || FechaBatch() } } } )
Return( nOpcao==1 )
//--------------------------------------------------------------------------
// Rotina | GTLParam    | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para solicitar parâmetros ao usuário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLParam( aRet )
	Local aPar := {}
	aRet := {}
	AAdd(aPar,{1,'Data inicial',Ctod(Space(8)),'','','','',50,.T.})//01
	AAdd(aPar,{1,'Data final'  ,Ctod(Space(8)),'','','','',50,.T.})//02
Return( ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.F.,.F.) )

//--------------------------------------------------------------------------
// Rotina | GTLQuery    | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que efetua a query.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLQuery( cTRB, aCOLS, aRet )
	Local cCount := ''
	Local cGT_ACAO := ''
	Local cGT_INIP := ''
	Local cGT_SEND := ''
	Local cSQL := ''
	
	Local nCount := 0
	Local nElem := 0
	Local nFCount := 0
	Local nI := 0
	Local nP_GT_ACAO := 0
	Local nP_GT_INIP := 0
	Local nP_GT_SEND := 0
	
	//--------------------------------------------
	// Elaborar a instrução par ao banco de dados.
	cSQL := "SELECT R_E_C_N_O_ AS GT_RECNO "
	cSQL += "FROM   GTLOG "
	cSQL += "WHERE  GT_DTOPER >= "+ValToSql(aRet[1])+" "
	cSQL += "       AND GT_DTOPER <= "+ValToSql(aRet[2])+" "
	cSQL += "       AND D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY GT_IDOPER "
	
	//--------------------------------------------------
	// Efetuar parse na instrução para o banco de dados.
	cSQL := ChangeQuery( cSQL )
	
	//-----------------
	// Buscar um alias.
	cTRB := GetNextAlias()
	
	//-----------------------------------------------------------------
	// Fazer query count() com a mesma instrução para o banco de dados.
	cCount := " SELECT COUNT(*) TB_COUNT FROM ( " + cSQL + " ) QUERY "
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cCount ), cTRB, .F., .T. )
	nCount	:= (cTRB)->TB_COUNT
	(cTRB)->(dbCloseArea())
	
	If nCount > 0
		// Fazer query com a instrução para o banco de dados.
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
		
		If Select('GTLOG') <= 0
			A610UseGTL()
		Endif
		
		nFCount := GTLOG->( FCount() )
		
		nP_GT_ACAO := GTLOG->( FieldPos( 'GT_ACAO' ) )
		nP_GT_SEND := GTLOG->( FieldPos( 'GT_SEND' ) )
		nP_GT_INIP := GTLOG->( FieldPos( 'GT_INIPROC' ) )
		
		RegProcDoc( nCount )
		
		While (cTRB)->( .NOT. EOF() )
			GTLOG->( dbGoTo( (cTRB)->( GT_RECNO ) ) )
			
			AAdd( aCOLS, Array( nFCount+1 ) )
			nElem++
			
			For nI := 1 To nFCount
				aCOLS[ nElem, nI ] := GTLOG->( FieldGet( nI ) )
			Next nI
			
			aCOLS[ nElem, nFCount+1 ] := GTLOG->( RecNo() )
			
			cGT_ACAO := aCOLS[ nElem, nP_GT_ACAO ]
			
			If     cGT_ACAO == 'L' ; cGT_ACAO := 'LOG'
			Elseif cGT_ACAO == 'A' ; cGT_ACAO := 'APROVAR'
			Elseif cGT_ACAO == 'R' ; cGT_ACAO := 'REPROVAR'
			Else                   ; cGT_ACAO := 'DESCONHECIDO' ; Endif
			
			aCOLS[ nElem, nP_GT_ACAO ] := cGT_ACAO
			
			cGT_SEND := aCOLS[ nElem, nP_GT_SEND ]
			
			If     cGT_SEND == 'T' ; cGT_SEND := 'PROCESSADO'
			Elseif cGT_SEND == 'F' ; cGT_SEND := 'NÃO PROCESSADO'
			Else                   ; cGT_SEND := ' ' ; Endif
			
			aCOLS[ nElem, nP_GT_SEND ] := cGT_SEND
			
			cGT_INIP := aCOLS[ nElem, nP_GT_INIP ]
			
			If     cGT_INIP == 'T' ; cGT_INIP := 'PROCESSADO'
			Elseif cGT_INIP == 'F' ; cGT_INIP := 'NÃO PROCESSADO'
			Elseif cGT_INIP == '1' ; cGT_INIP := 'RESERVADO'
			Elseif cGT_INIP == '2' ; cGT_INIP := 'PEDIDO EM USO'
			Elseif cGT_INIP == '3' ; cGT_INIP := 'ALÇADA NÃO LOCALIZADA'
			Elseif cGT_INIP == '4' ; cGT_INIP := 'ALÇADA PENDENTE NÃO LOCALIZADA'
			Elseif cGT_INIP == '7' ; cGT_INIP := 'PROCESSO REVOGADO'
			Elseif cGT_INIP == ' ' ; cGT_INIP := ' '
			Else                   ; cGT_INIP := 'FLAG NÃO IDENTIFICADO' ; Endif
			
			aCOLS[ nElem, nP_GT_INIP ] := cGT_INIP
			
			IncProcDoc('Carregando os dados...')
			
			(cTRB)->( dbSkip() )
		End
	Else
		ShowHelpDlg('Query',;
		{'Dados não localizados com os parâmetros informados.' },,; //Problema
		{'Informe outro período nos parâmetros'}) // Solução
	Endif
Return( Len( aCOLS ) > 0 )

//--------------------------------------------------------------------------
// Rotina | GTLHead     | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que monta o vetor com o título do campos ou o títulos dos
//        | campos e a nomenclatura dos campos.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLHead( aHeader, nTipo )
	If nTipo == 1
		aHeader := {'Id Operação',;
			'Data de operação',;
			'Ação (Aprov/Repr/Log)',;
			'Email do aprovador',;
			'Motivo/Justif.',;
			'Cód. Aprovador',;
			'Cód. Usuário',;
			'Filial',;
			'Pedido de compras',;
			'XML Recebido',;
			'Id. do processo',;
			'Id. do processamento',;
			'Data do processamento',;
			'Hora do processamento',;
			'Log do processamento',;
			'Data legado',;
			'Hora legado',;
			'Online legado',;
			'Info legado',;
			'RECNO'}
	Elseif nTipo == 2
		aHeader := { ;
			{'Id Operação'          ,'GT_IDOPER' },;
			{'Data de operação'     ,'GT_DTOPER' },;
			{'Ação (Aprov/Repr/Log)','GT_ACAO'   },;
			{'Email do aprovador'   ,'GT_EMAIL'  },;
			{'Motivo/Justif.'       ,'GT_MOTIVO' },;
			{'Cód. Aprovador'       ,'GT_CODAPRO'},;
			{'Cód. Usuário'         ,'GT_CODUSER'},;
			{'Filial'               ,'GT_FILPC'  },;
			{'Pedido de compras'    ,'GT_NUMPC'  },;
			{'XML Recebido'         ,'GT_PARAM'  },;
			{'Id. do processo'      ,'GT_SEND'   },;
			{'Id. do processamento' ,'GT_INIPROC'},;
			{'Data do processamento','GT_DTPROC' },;
			{'Hora do processamento','GT_HRPROC' },;
			{'Log do processamento' ,'GT_LOG'    },;
			{'Data legado'          ,'GT_DATE'   },;
			{'Hora legado'          ,'GT_TIME'   },;
			{'Online legado'        ,'GT_ONLINE' },;
			{'Info legado'          ,'GT_INFO'   },;
			{'Recno'                ,'R_E_C_N_O_'}}
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | GTLShow     | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que apresenta os dados em tela.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLShow( aHeader, aCOLS )
	Local aButton := {}
	Local aC := {}
	Local nButton := 0
	Local cOrd := ''
	Local nQtdButton := 0
	Local cSeek := Space(99)

	Local nOrd := 1

	Local oDlg
	Local oIndLbx
	Local oLbx
	Local oOrdem
	Local oPanelAll
	Local oPanelBot
	Local oPesq
	Local oSeek

	aC := FWGetDialogSize( oMainWnd )
	DEFINE MSDIALOG oDlg FROM aC[1],aC[2] TO aC[3], aC[4] TITLE cCadastro PIXEL OF oMainWnd STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.

		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP

		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		oLbx := TwBrowse():New(1,1,1000,1000,,aHeader,,oPanelAll,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| GTLOrdHead( nCol, oLbx, @oIndLbx ) }
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT

		GTLSetArray( @oLbx, aCOLS )

		@ 3, (((oPanelBot:oParent:nWidth/2)-4)-80) SAY oIndLbx PROMPT 'Ordem: ' + aHeader[ 1 ] OF oPanelTop PIXEL COLOR CLR_HRED SIZE 100,10

		@ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aHeader SIZE 80,36 ON CHANGE ( nOrd:=oOrdem:nAt ) PIXEL OF oPanelTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION ( GTLPesq (nOrd, RTrim( cSeek ), @oLbx ) )
		
		nQtdButton := 6
		aButton := Array( nQtdButton )
		
		@ 1,431 BUTTON aButton[++nButton] PROMPT 'Pesquisar'      SIZE 40,11 PIXEL OF oPanelBot ACTION ( GTLParPsq( @oLbx ) )
		@ 1,474 BUTTON aButton[++nButton] PROMPT 'Visualizar'     SIZE 40,11 PIXEL OF oPanelBot ACTION ( GTLVisual( oLbx ) )
		@ 1,517 BUTTON aButton[++nButton] PROMPT 'Processar lote' SIZE 40,11 PIXEL OF oPanelBot ACTION ( U_A610ManG() )
		@ 1,560 BUTTON aButton[++nButton] PROMPT 'Processar PC'   SIZE 40,11 PIXEL OF oPanelBot ACTION ( U_A610ManH() )
		@ 1,603 BUTTON aButton[++nButton] PROMPT 'Recarregar'     SIZE 40,11 PIXEL OF oPanelBot ACTION ( GTLReload( @oLbx ) )
		@ 1,646 BUTTON aButton[++nButton] PROMPT 'Sair'           SIZE 40,11 PIXEL OF oPanelBot ACTION ( oDlg:End() )

	ACTIVATE MSDIALOG oDlg CENTERED
Return

//--------------------------------------------------------------------------
// Rotina | GTLSetArray | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que estabelece os dados para o objeto.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLSetArray( oLbx, aCOLS )
	oLbx:SetArray( aCOLS )
	oLbx:bLine := {|| AEval( aCOLS[ oLbx:nAt ],{|xValue,nIndex| aCOLS[ oLbx:nAt, nIndex ] } ) }
	oLbx:Refresh()
Return

//--------------------------------------------------------------------------
// Rotina | GTLOrdHead  | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para fazer a ordem do vetor pela coluna do objeto.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLOrdHead( nCol, oLbx, oIndLbx )
	Local aHead := {}
	aHead := {;
				{'Id Operação'          ,'GT_IDOPER' ,'S'},;
				{'Data de operação'     ,'GT_DTOPER' ,'S'},;
				{'Ação (Aprov/Repr/Log)','GT_ACAO'   ,' '},;
				{'Email do aprovador'   ,'GT_EMAIL'  ,'S'},;
				{'Motivo/Justif.'       ,'GT_MOTIVO' ,' '},;
				{'Cód. Aprovador'       ,'GT_CODAPRO','S'},;
				{'Cód. Usuário'         ,'GT_CODUSER','S'},;
				{'Filial'               ,'GT_FILPC'  ,' '},;
				{'Pedido de compras'    ,'GT_NUMPC'  ,'S'},;
				{'XML Recebido'         ,'GT_PARAM'  ,' '},;
				{'Id. do processo'      ,'GT_SEND'   ,'S'},;
				{'Id. do processamento' ,'GT_INIPROC','S'},;
				{'Data do processamento','GT_DTPROC' ,'S'},;
				{'Hora do processamento','GT_HRPROC' ,'S'},;
				{'Log do processamento' ,'GT_LOG'    ,' '},;
				{'Data legado'          ,'GT_DATE'   ,'S'},;
				{'Hora legado'          ,'GT_TIME'   ,'S'},;
				{'Online legado'        ,'GT_ONLINE' ,' '},;
				{'Info legado'          ,'GT_INFO'   ,' '},;
				{'Recno'                ,'R_E_C_N_O_','S'} }
	If aHead[ nCol, 3 ] == 'S'
		oIndLbx:SetText( 'Ordem: ' + aHead[ nCol, 1 ] )
		ASort( oLbx:aArray,,,{|a,b| a[ nCol ] < b[ nCol ] } )
		oLbx:Refresh()
	Else
		ShowHelpDlg('Ordem dos dados',;
		{'Não está previsto ordenar os dados pela coluna: [' + aHead[ nCol, 1 ] +']' },,; //Problema
		{'Selecione outra coluna.'}) // Solução
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | GTLReload   | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que recarrega os dados com base em novos parâmetros.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLReload( oLbx )
	Local aCOLS := {}
	Local aRet := {}
	Local cTRB := ''
	Local lQry := .T.
	
	If .NOT.GTLParam( @aRet )
		Return
	Endif
	
	lQry := ProcessaDoc( {|| GTLQuery( @cTRB, @aCOLS, aRet ) }, cCadastro, 'Carregando os dados...' )
	
	If .NOT. lQry
		Return
	Endif
	
	GTLSetArray( @oLbx, aCOLS )
Return

//--------------------------------------------------------------------------
// Rotina | GTLParPsq   | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina interface que possibilita a pesquisa dos dados em tela.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLParPsq( oLbx )
	Local aPar := {}
	Local aRet := {}
	Local cSeek := ''
	Local nOrd := 0
	
	AAdd( aPar, { 2, 'Pesquisar por'       , 1, oLbx:aHeaders , 99, '.T.', .T.})
	AAdd( aPar, { 1, 'Valor para pesquisar', Space( 99 ),'','','','',99,.T.})
	
	If ParamBox( aPar,'Pesquisar',@aRet,,,,,,,,.F.)
		cSeek := RTrim( aRet[ 2 ] )
		nOrd := Iif( ValType( aRet[ 1 ] ) == 'N', aRet[ 1 ], AScan( oLbx:aHeaders, {|e| e==aRet[ 1 ] } ) )
		GTLPesq( nOrd, cSeek, @oLbx )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | GTLPesq     | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que possibilita a pesquisa dos dados em tela.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLPesq( nOrd, cSeek, oLbx )
	Local bAScan := {|| .T. }
	Local bCampo := {|nCPO| Field(nCPO) }

	Local nBegin := 0
	Local nEnd := 0
	Local nP := 0

	nBegin := Iif( oLbx:nAt==1, 1, Min( oLbx:nAt + 1, Len( oLbx:aArray ) ) )
	nEnd := Len( oLbx:aArray )

	If oLbx:nAt == Len( oLbx:aArray )
		nBegin := 1
	Endif

	If 'DATA' $ Upper( oLbx:aHeaders[ nOrd ] )
		bAScan := {|p| Ctod( cSeek ) == p[ nOrd ] }
	Else
		bAScan := {|p| Upper( cSeek ) $ AllTrim( p[ nOrd ] ) }
	Endif

	nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )

	If nP > 0
		oLbx:nAt := nP
		oLbx:Refresh()
		oLbx:SetFocus()
	Else
		nBegin := 1
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
			oLbx:SetFocus()
		Else
			ShowHelpDlg('Pesquisar',;
				{'Não foi possível localizar sua pesquisa.'},,; //Problema
			{'Verifique sua pesquisa:',;
				'1) A chave de pesquisa;',;
				'2) A ordem selecionada;',;
				'3) Se há realmente o que deseja pesquisar.'}) // Solução
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | GTLVisual   | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que possibilita visualizar os dados na íntegra (MsMGet).
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLVisual( oLbx )
	Local aC := {}
	Local aCampo := {}
	Local aStru := {}
	Local aTitle := {}

	Local cCampo := ''
	Local cTRB := ''

	Local bCampo  := {|nCPO| Field(nCPO) }

	Local i := 0
	Local nRecNo := 0

	Local oDlg
	Local oScroll

	nRecNo := oLbx:aArray[ oLbx:nAt, Len( oLbx:aArray[ oLbx:nAt ] ) ]

	cTRB := GetNextAlias()

	cSQL := "SELECT R_E_C_N_O_ "
	cSQL += "FROM   GTLOG "
	cSQL += "WHERE  R_E_C_N_O_ = "+LTrim(Str(nRecNo))+" "
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )

	If (cTRB)->( .NOT. BOF() ) .AND. (cTRB)->( .NOT. EOF() )

		If Select('GTLOG') <= 0
			A610UseGTL()
		Endif

		GTLOG->( dbGoTo( (cTRB)->R_E_C_N_O_ ) )

		aStru := GTLOG->( dbStruct() )
		AAdd( aStru, {'R_E_C_N_O_','N',15,0})

		For i := 1 TO GTLOG->( FCount() )
			cCampo := GTLOG->( FieldName( i ) )
			If aStru[ i, 2 ] == 'L'
				M->&(cCampo) := Iif( GTLOG->( FieldGet( i ) ), 'T', 'F' )
			Else
				M->&(cCampo) := GTLOG->( FieldGet( i ) )
			Endif
		Next i
		M->&('R_E_C_N_O_') := (cTRB)->R_E_C_N_O_

		GTLHead( @aTitle, 2 )

		ASize( aCampo, Len( aStru ) )
		AFill( aCampo, {,} )

		aC := FWGetDialogSize( oMainWnd )
		DEFINE MSDIALOG oDlg FROM aC[1],aC[2] TO aC[3], aC[4] TITLE 'Visualizar todos os dados do registro' PIXEL
		oDlg:lMaximized := .T.

		@ 00,00 SCROLLBOX oScroll VERTICAL OF oDlg PIXEL
		oScroll:Align := CONTROL_ALIGN_ALLCLIENT
		GTLEnchoice( aStru, aTitle, cTRB, @aCampo, oDlg, @oScroll )
		ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, {|| oDlg:End() }, {|| oDlg:End() } )
	Else
		ShowHelpDlg('GTLEnchoice',;
			{'O registro não foi localizado.' },,; //Problema
		{'Verifique com o administrador do Protheus.'}) // Solução
	Endif
	(cTRB)->( dbCloseArea())
Return

//--------------------------------------------------------------------------
// Rotina | GTLEnchoice | Autor | Robson Gonçalves       | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que apresenta os dados nos objetos TSay/TGet em tela.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function GTLEnchoice( aStru, aTitle, cTRB, aCampo, oDlg, oScroll )
	Local aPict := {'999999999999999','@E 999,999,999,999,999.999999','@E 999,999,999,999,999'}
	Local bGet
	Local bSay

	Local cCampo := ''
	Local cPict := ''

	Local nLinha := 5
	Local nTamanho := 0
	Local x := 0

	For x := 1 To Len( aStru )
		cPict := ''

		bSay := &("{|| '" + aTitle[ AScan( aTitle, {|e| e[ 2 ] == aStru[ x, 1 ] } ), 1 ] + "'}")
		cCampo := aStru[x,1]
		aCampo[x,1] := TSay():New( nLinha, 2, bSay,oScroll,,,,,,.T.,CLR_HBLUE)
		bGet := &('{ |u| Iif( GTLOG->(PCount()) == 0, m->'+cCampo+','+'m->'+cCampo+' := u)}')

		If aStru[x,2] == 'N'
			cPict := Iif( cCampo == 'R_E_C_N_O_', aPict[ 1 ], Iif( aStru[ x, 4 ] > 0, aPict[ 2 ], aPict[ 3 ] ) )
		Elseif aStru[x,2] == 'D'
			cPict := '@D'
		Endif

		nTamanho := CalcFieldSize( aStru[x,2], aStru[x,3], aStru[x,4], cPict, '') + 9

		If ( aStru[x,2] == 'D' )
			nTamanho += 2
		Endif

		nTamanho := Iif((nTamanho>(((oDlg:nRight)-(oDlg:nLeft))/2)-66) .OR. aStru[x,2] == 'M' ,(((oDlg:nRight)-(oDlg:nLeft))/2)-66,nTamanho)

		If aStru[x,2] == 'M'
			aCampo[x,2] := TMultiGet():New( nLinha,65, bGet,oScroll,nTamanho-1,100,,,,,,.T.,,,,,,.T.,,,,,,)
		Else
			aCampo[x,2] := TGet():New( nLinha,65, bGet,oScroll,nTamanho, ,cPict ,,,,,.F.,,.T.,'',.F.,,.F.,.F.,,.T.,.F.,,aStru[x,1],aStru[x,1],.F.,0,.T.)
		Endif
		nLinha := nLinha + Iif(aStru[x,2]=='M',102,14)
	Next x
Return

//--------------------------------------------------------------------------
// Rotina | A610Revog | Autor | Robson Gonçalves         | Data | 03.10.2016
//--------------------------------------------------------------------------
// Descr. | Rotina que revoga o registro decomposto da integração do pedido
//        | de compras, pois não há mais validade.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Revog( aParam )
	Local cDTeHR := Dtoc( MsDate() ) + '-' + Time()
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	//----------------------------------
	// Fazer a abertura da tabela GTLOG.
	If Select('GTLOG') <= 0
		A610UseGTL()
	Endif
	//--------------------------------------------------------------------
	// Buscar todos os registro de pedido de compras que foram decomposto.
	cSQL := "SELECT R_E_C_N_O_ AS GT_RECNO "
	cSQL += "FROM   GTLOG GTLOG "
	cSQL += "WHERE  GT_FILPC = "+ValToSql( xFilial( 'SC7' ) ) + " "
	cSQL += "       AND GT_NUMPC = " + ValToSql( aParam[ 1 ] ) + " "
	cSQL += "       AND GTLOG.D_E_L_E_T_ = ' ' "

	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	//-----------
	// Tem dados.
	If (cTRB)->(.NOT. BOF() ) .AND. (cTRB)->(.NOT. EOF() )
		While (cTRB)->( .NOT. EOF() )
			//------------------------------------------------
			// Posicionar no registro da tabela da integração.
			GTLOG->( MsGoTo( (cTRB)->GT_RECNO ) )
			//-----------------------------------------
			// Conferir se o registro está posicionado.
			If GTLOG->( RecNo() ) == (cTRB)->GT_RECNO
				//---------------------------------------
				// Gravar no log a revogação do registro.
				GTLOG->( RecLock( 'GTLOG', .F. ) )
				GTLOG->GT_INIPROC := '7'
				GTLOG->GT_LOG := AllTrim( GTLOG->GT_LOG ) + CRLF + cDTeHR + ;
				' A ação definida anteriormente foi revogada. O pedido de compras foi ' + Iif(aParam[3],'alterado','excluído')+'. Por isso será gerado novo processo.'
				GTLOG->( MsUnLock() )
			Endif
			(cTRB)->( dbSkip() )
		End
	Endif
	(cTRB)->( dbCloseArea() )
Return

//--------------------------------------------------------------------------
// Rotina | A610Alcad | Autor | Robson Gonçalves         | Data | 09.11.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para consultar a situação do pedido de compras e suas 
//        | alçadas.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610Alcad( cFilialPC, cNumeroPC )
	Local aStruSCR := ''
	Local aUSER_ALC := {}
	Local aUSER_LIB := {}

	Local cAliasSCR := ''
	Local cAprovador := ''
	Local cAprovLib := ''
	Local cCR_DATALIB := ''
	Local cQuery := ''
	Local cRet := '<retorno>'
	Local cSitAlcada := ''

	Local nP := 0

	Set( 4, 'dd/mm/yyyy' )

	If	cFilAnt <> cFilialPC
		cFilAnt := cFilialPC
	Endif

	dbSelectArea( 'SC7' )
	dbSetOrder( 1 )
	If MsSeek( cFilialPC + cNumeroPC )
		cAliasSCR := GetNextAlias()

		cQuery    := "SELECT " //SCR.*, "
		cQuery	  += "		 CR_USER,"
		cQuery	  += "		 CR_USERLIB,"
		cQuery	  += "		 CR_STATUS,"
		cQuery	  += "		 CR_NIVEL,"
		cQuery	  += "		 CR_DATALIB,"
		cQuery    += "		 UTL_RAW.CAST_TO_VARCHAR2(CR_OBS) AS CR_OBS,"
		cQuery    += "       SCR.R_E_C_N_O_ AS SCRRECNO "
		cQuery    += "FROM  "+RetSqlName("SCR")+" SCR "
		cQuery    += "WHERE  SCR.CR_FILIAL="+ValToSql(cFilialPC)+" "
		cQuery    += "       AND SCR.CR_NUM = "+ValToSql(Padr(SC7->C7_NUM,Len(SCR->CR_NUM)))+" "
		cQuery    += "       AND SCR.CR_TIPO = 'PC' "
		cQuery    += "       AND SCR.D_E_L_E_T_= ' ' "
		cQuery    += "ORDER  BY "+SqlOrder(SCR->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR)

		aStruSCR := SCR->( dbStruct() )
		AEval( aStruSCR, {|e| Iif( e[ 2 ] <> 'C', TCSetField( cAliasSCR, e[ 1 ], e[ 2 ], e[ 3 ], e[ 4 ] ), NIL ) } )

		cRet += '<codigo>0</codigo>'
		cRet += '<mensagem>Pedido de compra e alçadas localizados</mensagem>'
		cRet += '<pedido>'
		cRet += '<filial>'  + SC7->C7_FILIAL                                                                        + '</filial>'
		cRet += '<num_pc>'  + SC7->C7_NUM                                                                           + '</num_pc>'
		cRet += '<emissao>' + Dtoc(SC7->C7_EMISSAO)                                                                 + '</emissao>'
		cRet += '<sit_pc>'  + Iif(SC7->C7_CONAPRO=='L','Pedido liberado', 'Pedido em análise aguardando liberação') + '</sit_pc>'
		cRet += '<alcadas>'

		dbSelectArea(cAliasSCR)
		While (cAliasSCR)->( .NOT. EOF() )
		// Capturar o nome do aprovador.
			nP := AScan( aUSER_ALC, {|e| e[ 1 ] == (cAliasSCR)->CR_USER } )
			If nP == 0
				AAdd( aUSER_ALC, { (cAliasSCR)->CR_USER, RTrim( UsrFullName( (cAliasSCR)->CR_USER ) ) } )
				nP := Len( aUSER_ALC )
			Endif
			cAprovador := aUSER_ALC[ nP, 2 ]

			// Não tem aprovador que liberou?
			If Empty( (cAliasSCR)->CR_USERLIB )
				cAprovLib := ''
			Else
				// Tem aprovador que liberou. Aprovador é igual aprovador que liberou?
				If (cAliasSCR)->CR_USER == (cAliasSCR)->CR_USERLIB
					// Igualar os nomes para não rechamar a função.
					cAprovLib := cAprovador
				Else
					// Capturar o nome do aprovador que liberou.
					nP := nP := AScan( aUSER_LIB, {|e| e[ 1 ] == (cAliasSCR)->CR_USERLIB } )
					If nP == 0
						AAdd( aUSER_LIB, { (cAliasSCR)->CR_USERLIB, RTrim( UsrFullName( (cAliasSCR)->CR_USERLIB ) ) } )
						nP := Len( aUSER_LIB )
					Endif
					cAprovLib  := (cAliasSCR)->CR_USERLIB + '-' + aUSER_LIB[ nP, 2 ]
				Endif
			Endif

			// Avaliar o status da alçada.
			If     (cAliasSCR)->CR_STATUS == '01' ; cSitAlcada := 'Nível bloqueado'
			Elseif (cAliasSCR)->CR_STATUS == '02' ; cSitAlcada := 'Nível aguardando liberação'
			Elseif (cAliasSCR)->CR_STATUS == '03' ; cSitAlcada := 'Nível aprovado'
			Elseif (cAliasSCR)->CR_STATUS == '04' ; cSitAlcada := 'Nível rejeitado'
			Elseif (cAliasSCR)->CR_STATUS == '05' ; cSitAlcada := 'Nível liberado'
			Endif

			cCR_DATALIB := Dtoc((cAliasSCR)->CR_DATALIB)

			// Montar o detalhe do XML.
			cRet += '<alcada>'
			cRet += '<nivel>'        + (cAliasSCR)->CR_NIVEL                    + '</nivel>'
			cRet += '<aprovador>'    + (cAliasSCR)->CR_USER    +'-'+ cAprovador + '</aprovador>'
			cRet += '<sit_alc>'      + (cAliasSCR)->CR_STATUS  +'-'+ cSitAlcada + '</sit_alc>'
			cRet += '<aprovado_por>' + cAprovLib                                + '</aprovado_por>'
			cRet += '<data_lib>'     + Iif(Empty(cCR_DATALIB),'',cCR_DATALIB)   + '</data_lib>'
			cRet += '<obs>'          + (cAliasSCR)->CR_OBS                      + '</obs>'
			cRet += '</alcada>'

			(cAliasSCR)->( dbSkip() )
		End
		cRet += '</alcadas>'
		cRet += '</pedido>'

		(cAliasSCR)->( dbCloseArea() )
	Else
		cRet += '<codigo>1</codigo>'
		cRet += '<mensagem>Pedido de compra e alçadas não localizados</mensagem>'
	Endif

	cRet += '</retorno>'
Return( cRet )

//--------------------------------------------------------------------------
// Rotina | A610HistForn | Autor | Robson Gonçalves      | Data | 16.12.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para consultar o histórico do fornecedor.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A610HistForn( cFilialPC, cNumeroPC )
	Local aCOND := {}
	Local aFILIAL := {}

	Local cCondPg := ''
	Local cFilPC := ''
	Local cFornece := ''
	Local cMV610_012 := ''
	Local cRet := '<retorno>'
	Local cSQL := ''
	Local cTotalPC := ''
	Local cTRB := ''

	Local dDataFim := Ctod('')
	Local dDataIni := Ctod('')

	Local nP := 0

	dbSelectArea( 'SC7' )
	dbSetOrder( 1 )
	If SC7->( MsSeek( cFilialPC + cNumeroPC ) )
	// Verificar se o parâmetro existe.
		cMV610_012 := 'MV_610_012'
		If .NOT. GetMv( cMV610_012, .T. )
			CriarSX6( cMV610_012, 'N', 'NUMERO DE MESES P/ PESQ. HISTORICO DE COMPRAS DO FORNECEDOR - ROTINA CSFA610.prw','6' )
		Endif
		// Capturar o conteúdo do parâmetro.
		cMV610_012 := GetMv( cMV610_012, .F. )
		If cMV610_012 > 0
			dDataFim := MsDate()
			dDataIni := FirstDay( MonthSub( dDataFim, cMV610_012 ) )

			cFornece := SC7->C7_FORNECE + '-' + RTrim( SA2->( Posicione( 'SA2', 1, xFilial( 'SA2' ) + SC7->C7_FORNECE, 'A2_NOME' ) ) )

			// Não foi utilizado C7_FILIAL no Where porque é para pegar todos os registros.
			cSQL := "SELECT C7_FILIAL, "
			cSQL += "       C7_NUM, "
			cSQL += "       C7_FORNECE, "
			cSQL += "       C7_LOJA, "
			cSQL += "       C7_EMISSAO, "
			cSQL += "       C7_COND "
			cSQL += "FROM "+RetSqlName("SC7")+" SC7 "
			cSQL += "WHERE  C7_FORNECE = "+ValToSql( SC7->C7_FORNECE ) + " "
			cSQL += "       AND C7_LOJA = "+ValToSql( SC7->C7_LOJA ) + " "
			cSQL += "       AND C7_EMISSAO >= " + ValToSql( dDataIni ) + " "
			cSQL += "       AND C7_EMISSAO <= " + ValToSql( dDataFim ) + " "
			cSQL += "       AND C7_CONAPRO = 'L' "
			cSQL += "       AND C7_RESIDUO = ' ' "
			cSQL += "       AND SC7.D_E_L_E_T_ = ' ' "
			cSQL += "GROUP  BY C7_FILIAL, "
			cSQL += "          C7_NUM, "
			cSQL += "          C7_FORNECE, "
			cSQL += "          C7_LOJA, "
			cSQL += "          C7_EMISSAO, "
			cSQL += "          C7_COND "
			cSQL += "ORDER BY  C7_FILIAL, "
			cSQL += "          C7_NUM "

			cSQL := ChangeQuery( cSQL )
			cTRB := GetNextAlias()
			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cSQL),cTRB)

			If (cTRB)->(.NOT. BOF() ) .AND. (cTRB)->(.NOT. EOF() )

				cRet += '<codigo>0</codigo>'
				cRet += '<mensagem>Pedidos de compras localizados</mensagem>'
				cRet += '<pedidos>

				While (cTRB)->( .NOT. EOF() )

					nP := AScan( aFILIAL, {|e| e[ 1 ] == (cTRB)->C7_FILIAL } )

					If nP == 0
						AAdd( aFILIAL, { (cTRB)->C7_FILIAL, A610NomFil( (cTRB)->C7_FILIAL, .F. ) } )
						nP := Len( aFILIAL )
					Endif

					cFilPC := (cTRB)->C7_FILIAL + ' - ' + aFILIAL[ nP, 2 ]

					cTotalPC := LTrim( TransForm( A610TotPC( (cTRB)->C7_FILIAL, (cTRB)->C7_NUM ), '@E 999,999,999.99' ) )

					nP := AScan( aCOND, {|e| e[1] == (cTRB)->C7_COND } )

					If nP == 0
						AAdd( aCOND, { 	(cTRB)->C7_COND, RTrim( SE4->( GetAdvFVal( 'SE4', 'E4_DESCRI', xFilial('SE4')+(cTRB)->C7_COND, 1 ) ) ) } )
						nP := Len( aCOND )
					Endif

					cCondPg := (cTRB)->C7_COND + ' - ' + aCOND[ nP, 2 ]

					cRet += '<pedido>'
					cRet += '<filial>'     + cFilPC                         + '</filial>'
					cRet += '<num_pc>'     + (cTRB)->C7_NUM                 + '</num_pc>'
					cRet += '<emissao>'    + Dtoc(Stod((cTRB)->C7_EMISSAO)) + '</emissao>'
					cRet += '<valor>'      + cTotalPC                       + '</valor>'
					cRet += '<cond_pagto>' + cCondPg                        + '</cond_pagto>'
					cRet += '</pedido>'

					(cTRB)->( dbSkip() )
				End
				cRet += '</pedidos>'
			Else
				cRet += '<codigo>3</codigo>'
				cRet += '<mensagem>Não existe histórico para este fornecedor</mensagem>'
			Endif
			(cTRB)->( dbCloseArea() )
		Else
			cRet += '<codigo>2</codigo>'
			cRet += '<mensagem>Parâmetro (MV_610_012) sem configuração</mensagem>'
		Endif
	Else
		cRet += '<codigo>1</codigo>'
		cRet += '<mensagem>Pedido de compra não localizado</mensagem>'
	Endif
	cRet += '</retorno>'
Return( cRet )

User Function A610Noti( aPARAM, aDados )
	Local lOK  		:= .F.
	Local aMsg 		:= {}
	Local cTB_Qry 	:= GetNextAlias()
	Local cAssunto	:= ''
	
	//[ 1 ] - CR_NUM
	//[ 2 ] - CR_TIPO
	//[ 3 ] - nOpc
	//[ 4 ] - CR_FILIAL
	
	//-----------------------------------------------
	// Tem mais alçada para avaliar/aprovar/rejeitar.
	BEGINSQL ALIAS cTB_Qry
		SELECT COUNT(*) AS SCR_COUNT
		FROM   %Table:SCR% SCR
		WHERE  CR_FILIAL = %Exp:aPARAM[ 4 ]%
		AND CR_NUM = %Exp:aPARAM[ 1 ]%
		AND CR_TIPO = 'PC'
		AND CR_STATUS = '02'
		AND CR_DATALIB = ' '
		AND SCR.%NotDel%
	ENDSQL
	lOK := ( (cTB_Qry)->SCR_COUNT == 0 )
	(cTB_Qry)->( dbCloseArea())
	
	IF lOK
		SC7->( dbSetOrder(1) )	
		SC7->( dbSeek( aPARAM[ 4 ] + rTrim( aPARAM[ 1 ] ) ) )

		AAdd( aMsg, aPARAM[ 4 ] + '-' + aPARAM[ 1 ] )
		AAdd( aMsg, IIF( SC7->C7_CONAPRO == 'L',; 
						'pedido de compra liberado e apto para entrar com o pré documento de entrada.',;
						'pedido de compra rejeitado.' ) )
		AAdd( aMsg, Dtoc( MsDate() ) )
		AAdd( aMsg, Time() )
		cAssunto := 'Pedido de Compra nº ' + aPARAM[ 4 ] + '-' + aPARAM[ 1 ] + IIF( SC7->C7_CONAPRO == 'L',' APROVADO.', ' REJEITADO.' )
		A610WFAvUs( aMsg, aDados, cAssunto, .F., .F., 'A610Noti' )
	Endif
Return

Static Function A610XmlRateio( aRateio, cNomArqXML )
	Local cWorkSheet  := 'Rateio'
	Local cTable      := 'Informações de rateio'
	Local cPath       := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile   := cPath + cNomArqXML
	Local oExcel      := FWMSEXCEL():New() //Método para geração em XML
	Local nI		  := 0

	oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela

	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >           , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Item PC"    	, 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Item rateio"	, 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Percentual"  , 1     , 2      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor"		, 1     , 2      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "C. CUSTO"	, 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "C. CONTAB"	, 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "C. RESULT"	, 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "PROJETO"		, 1     , 1      , .F. )

	//nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada

	For nI := 1 To Len( aRateio )
		oExcel:AddRow( cWorkSheet, cTable, { aRateio[ nI, 1 ],;
                                             aRateio[ nI, 2 ],;
                                             aRateio[ nI, 3 ],;
                                             aRateio[ nI, 4 ],;
                                             aRateio[ nI, 5 ],;
                                             aRateio[ nI, 6 ],;
                                             aRateio[ nI, 7 ],;
                                             aRateio[ nI, 8 ]} )
	Next nI

	oExcel:Activate() //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório
Return( cNameFile )
/*
_____________________________________________________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------------------------------------------------------------+¦¦
¦¦¦                                                                                                                               ¦¦¦
¦¦¦ ****** FIM DAS ROTINAS DA INTEGRAÇÃO DO WEBSERVICE CONSUMIDO PELA APLICAÇÃO JAVA PARA A APROVAÇÃO DE PEDIDO DE COMPRAS ****** ¦¦¦
¦¦¦                                                                                                                               ¦¦¦
¦¦+-------------------------------------------------------------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
