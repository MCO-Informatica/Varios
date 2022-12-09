//-------------------------------------------------------------------
// Rotina | CSFA800 | Autor | Robson Gonçalves    | Data | 30/05/2017
//-------------------------------------------------------------------
// Descr. | Rotina para criar o Formulário de Solicitação de Compras.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
#Include 'Protheus.ch'

#DEFINE cFONT     '<b><font size="4" color="blue"><b>'
#DEFINE cALERT    '<b><font size="4" color="red"><b>'
#DEFINE cFNTALERT '<b><font size="4" color="red"><b>'
#DEFINE cNOFONT   '</b></font></b></u>'

STATIC V_TIPOSC 
STATIC V_BUDGET 
STATIC V_DEP_SOL
STATIC V_NOMESOL
STATIC V_CTAORC 
STATIC V_DESCRDP
STATIC V_DEP_ENT
STATIC V_CONTATO
STATIC V_TELEF  
STATIC V_JUSTIF 
STATIC V_PQ_ESEM
STATIC V_OBS_SOL

User Function CSFA800()
	Local aButton := {}
	Local aCpo := {}
	Local aField := {}
	Local aX3_CAMPO := {}

	Local bOk := {|| .T. }

	Local cF3 := ''
	Local cMV_800OFF := 'MV_800OFF'
	Local cPicture := ''
	Local cRelacao := ''
	Local cTitulo := ''
	Local cValid := ''
	Local cWhen := ''

	Local lConfirm := .F.
	Local lMemoria := .F.
	Local lObrigat := .T.

	Local nI := 0

	Local oDlg
	Local oEnch
	Local oScroll
	
	If .NOT. GetMv( cMV_800OFF, .T. )
		CriarSX6( cMV_800OFF, 'L', 'LIGAR/DESLIGAR A GERACAO DO FORMULARIO DE SC, F=DESLIGADO, T=LIGADO . CSFA800.prw', '.F.' )
	Endif
	
	If .NOT. GetMv( cMV_800OFF, .F. )
		Return( .T. )
	Endif
	
	A800Clear()
	
	//[ 1 ] Nome do campo.
	//[ 2 ] Título do campo.
	//[ 3 ] .T. Obrigatório.
	//[ 4 ] When
	AAdd( aCpo, { 'C1_TIPOSC' , 'Tipo da solicitação'                 ,.T., '.T.' } )
	AAdd( aCpo, { 'C1_BUDGET' , 'Previsto em budget?'                 ,.T., '.T.' } )
	AAdd( aCpo, { 'C1_DEP_SOL', 'Depto do solicitante'                ,.T., '.T.' } )
	AAdd( aCpo, { 'C1_NOMESOL', 'Nome do solicitante'                 ,.T., '.T.' } )
	AAdd( aCpo, { 'C1_CTAORC' , 'Conta contábil orçada'               ,.F., 'U_A800When("C1_CTAORC")' } )
	AAdd( aCpo, { 'C1_DESCRDP', 'Descrição da despesa'                ,.F., 'U_A800When("C1_DESCRDP")' } )
	AAdd( aCpo, { 'C1_DEP_ENT', 'Depto de entrega'                    ,.T., '.T.' } )
	AAdd( aCpo, { 'C1_CONTATO', 'Nome do contato'                     ,.T., '.F.' } )
	AAdd( aCpo, { 'C1_TELEF'  , 'Telefone e/ou ramal'                 ,.T., '.T.' } )
	AAdd( aCpo, { 'C1_JUSTIF' , 'Justificativa da necessidade'        ,.T., '.T.' } )
	AAdd( aCpo, { 'C1_PQ_ESEM', 'Porque é Específica ou Emergencial?' ,.F., 'U_A800When("C1_PQ_ESEM")' } )
	AAdd( aCpo, { 'C1_OBS_SOL', 'Observações da solicitação'          ,.F., '.T.' } )
	
	AEval( aCpo, {|e| AAdd( aX3_CAMPO, e[ 1 ] ) } )
	
	A800ToMemory( aX3_CAMPO, INCLUI )
	
	SX3->( dbSetOrder( 2 ) )
	
	For nI := 1 To Len( aCPO )
		If SX3->( dbSeek( aCPO[ nI, 1 ] ) )
			cTitulo  := RTrim( Iif( Empty( aCPO[ nI, 2 ] ), SX3->X3_TITULO, aCPO[ nI, 2 ] ) )
			cF3      := SX3->X3_F3
			cValid   := SX3->X3_VALID
			
			If .NOT. Empty( SX3->X3_VLDUSER )
				If .NOT. Empty( cValid )
					cValid := cValid + ' .AND. '
				Endif
				cValid := cValid + RTrim( SX3->X3_VLDUSER )
			Endif
			
			cPicture := SX3->X3_PICTURE
			lObrigat := Iif( aCpo[ nI, 3 ], aCpo[ nI, 3 ], X3Obrigat( SX3->X3_CAMPO ) )
			cWhen    := RTrim( Iif( Empty( aCpo[ nI, 4] ), SX3->X3_WHEN, aCpo[ nI, 4 ] ) )
			
			If SX3->(ExistTrigger( X3_CAMPO ))
				If .NOT. Empty( cValid )
					cValid := RTrim( cValid ) + ' .AND. '
				Endif
				cValid := cValid + 'U_A800Trigger()'
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
		Endif
	Next nI
	
	M->C1_CONTATO := RTrim( UsrFullName( RetCodUsr() ) ) 
	
	bOk := {|| Iif( A800Obrig( aCpo ),( lConfirm := .T., oDlg:End() ), NIL ) }
	
	DEFINE MSDIALOG oDlg TITLE 'Formulário de Solicitação de Compras' FROM 0,0 TO 400,640 PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
			
		oScroll := TScrollBox():New(oDlg,1,1,1000,1000,.T.,.F.,.F.)
		oScroll:Align := CONTROL_ALIGN_ALLCLIENT
			
		oEnch := MsMGet():New(/*cAlias*/,;
		/*nRecNo*/,;
		Iif(INCLUI,3,Iif(ALTERA,4,2)),;
		/*aCRA*/,;
		/*cLetras*/,;
		/*cTexto*/,;
		aCPO,;
		/*aPos*/,;
		/*aAlterEnch*/,;
		/*nModelo*/,;
		/*nColMens*/,;
		/*cMensagem*/,;
		/*cTudoOk*/,;
		oDlg,;
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
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, bOK,{|| oDlg:End()}, ,aButton )
	
	If lConfirm
		V_TIPOSC  := M->C1_TIPOSC
		V_BUDGET  := M->C1_BUDGET
		V_DEP_SOL := M->C1_DEP_SOL
		V_NOMESOL := M->C1_NOMESOL
		V_CTAORC  := M->C1_CTAORC
		V_DESCRDP := M->C1_DESCRDP
		V_DEP_ENT := M->C1_DEP_ENT
		V_CONTATO := M->C1_CONTATO
		V_TELEF   := M->C1_TELEF
		V_JUSTIF  := M->C1_JUSTIF
		V_PQ_ESEM := M->C1_PQ_ESEM
		V_OBS_SOL := M->C1_OBS_SOL
	Else
		A800Clear()
		MsgAlert('Operação abandonada pelo usuário.','Abandono')
	Endif
Return( lConfirm )

User Function A800When( cField )
	If cField $ 'C1_CTAORC|C1_DESCRDP'
		If M->C1_BUDGET == '2' //1=Sim; 2=Não.
			Return(.F.)
		Endif
	Endif
	If cField == 'C1_PQ_ESEM'
		If M->C1_TIPOSC == '1' //1=Normal;2=Especifíco;3=Emergencial.
			Return(.F.)
		Endif
	Endif
Return(.T.)

//-------------------------------------------------------------------
// Rotina | A800Clear | Autor | Robson Gonçalves  | Data | 30/05/2017
//-------------------------------------------------------------------
// Descr. | Rotina para limpar as variáveis.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
Static Function A800Clear()
	V_TIPOSC  := Space( Len( SC1->C1_TIPOSC  ) ) 
	V_BUDGET  := Space( Len( SC1->C1_BUDGET  ) )
	V_DEP_SOL := Space( Len( SC1->C1_DEP_SOL ) )
	V_NOMESOL := Space( Len( SC1->C1_NOMESOL ) )
	V_CTAORC  := Space( Len( SC1->C1_CTAORC  ) )
	V_DESCRDP := Space( Len( SC1->C1_DESCRDP ) )
	V_DEP_ENT := Space( Len( SC1->C1_DEP_ENT ) )
	V_CONTATO := Space( Len( SC1->C1_CONTATO ) )
	V_TELEF   := Space( Len( SC1->C1_TELEF   ) )
	V_JUSTIF  := Space( Len( SC1->C1_JUSTIF  ) )
	V_PQ_ESEM := Space( Len( SC1->C1_PQ_ESEM ) )
	V_OBS_SOL := Space( Len( SC1->C1_OBS_SOL ) )
Return

//-------------------------------------------------------------------
// Rotina | A800ToMemory | Autor | Robson Gonçalves | Data | 30/05/17
//-------------------------------------------------------------------
// Descr. | Rotina para inicializar as variáveis.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
Static Function A800ToMemory( aFields, lInsert )
	Local cCpo := ''
	Local lInitPad := .T.
	Local nI := 0
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

//-------------------------------------------------------------------
// Rotina | A800Trigger | Autor | Robson Gonçalves | Data | 30/05/17
//-------------------------------------------------------------------
// Descr. | Rotina para executar os gatilhos de campos.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
User Function A800Trigger()
	Local aArea := GetArea()

	Local cCampo := ''
	Local cMacro := ''
	Local cMemVar := ''
	Local cResult := ''

	Local lRet := .T.

	Local nSavOrd := 0
	
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

//-------------------------------------------------------------------
// Rotina | A800Obrig | Autor | Robson Gonçalves  | Data | 30/05/2017
//-------------------------------------------------------------------
// Descr. | Rotina para criticar os campos.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
Static Function A800Obrig( aCPO )
	Local cCpo := ''
	Local cTitulo := 'Validação de campo'
	Local lRet := .T.
	Local nI := 0
	If M->C1_TIPOSC $ '23'
		If Empty( M->C1_PQ_ESEM )
			MsgAlert(cFONT+'Atenção'+cNOFONT+'<br><br>O campo TIPO SC igual a 2=Específica ou 3=Emergencia é obrigatório informar o Porque é Específica ou Emergencial,<br> por favor, preencher esta informação.',cTitulo)
			lRet := .F.
		Endif
	Endif
	If lRet .AND. M->C1_BUDGET == '1'
		If Empty( M->C1_CTAORC )
			MsgAlert(cFONT+'Atenção'+cNOFONT+'<br><br>O campo PREVISTO EM BUDGET igual a sim é obrigatório informar o código da Conta Contábil Orçada,<br> por favor, preencher esta informação.',cTitulo)
			lRet := .F.
	   Endif
	   If lRet .AND. Empty( M->C1_DESCRDP )
			MsgAlert(cFONT+'Atenção'+cNOFONT+'<br><br>O campo PREVISTO EM BUDGET igual a sim é obrigatório informar a descrição da despesa,<br> por favor, preencher esta informação.',cTitulo)
			lRet := .F.
		Endif
	Endif
	
	If lRet
		For nI := 1 To Len( aCPO )
			cCpo := 'M->' + aCpo[ nI, 1 ] 
			If aCpo[ nI, 3 ] .AND. Empty( &(cCpo) )
				cCpo := SX3->(Posicione('SX3',2,aCpo[nI,1],'X3_TITULO'))
				MsgAlert('O campo [' + Upper(RTrim( cCpo )) + '] é de preenchimento obrigatório, por favor, revise.','Criticar campos')
				lRet := .F.
				Exit
			Endif
		Next nI
	Endif
Return(lRet)

//-------------------------------------------------------------------
// Rotina | A800Gravar | Autor | Robson Gonçalves | Data | 30/05/2017
//-------------------------------------------------------------------
// Descr. | Rotina para gravar os dados complementares.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
Static Function A800Gravar()
	SC1->( RecLock( 'SC1', .F. ) )
	SC1->C1_TIPOSC  := V_TIPOSC 
	SC1->C1_BUDGET  := V_BUDGET 
	SC1->C1_DEP_SOL := V_DEP_SOL
	SC1->C1_NOMESOL := V_NOMESOL
	SC1->C1_CTAORC  := V_CTAORC 
	SC1->C1_DESCRDP := V_DESCRDP
	SC1->C1_DEP_ENT := V_DEP_ENT
	SC1->C1_CONTATO := V_CONTATO
	SC1->C1_TELEF   := V_TELEF  
	SC1->C1_JUSTIF  := V_JUSTIF 
	SC1->C1_PQ_ESEM := V_PQ_ESEM
	SC1->C1_OBS_SOL := V_OBS_SOL
	SC1->( MsUnLock() )
Return

//-------------------------------------------------------------------
// Rotina | A800FormSC | Autor | Robson Gonçalves | Data | 30/05/2017
//-------------------------------------------------------------------
// Descr. | Rotina para iniciar o processo de gerar o formulário.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
User Function A800FormSC( cC1_NUM )
	Local aArea := { SC1->( GetArea() ), SCX->( GetArea() ) }
	Local aCidades := {}
	Local aCtaCusto := {}
	Local aSM0 := {}
	Local aWord_Head := {}
	Local aWord_Prod := {}
	
	Local cCtaCusto := ''
	Local cMV_800OFF := 'MV_800OFF'
	Local cRateio := '*** RATEIO ***'
	
	Local nP := 0
	Local nTOTAL_SC := 0
	
	aCidades := {{'SAO PAULO','São Paulo'},{'BRASILIA','Brasília'},{'GOIANIA','Goiânia'}}
	
	// Criar parâmetro para ligar e desligar a funcionalidade.
	If .NOT. GetMv( cMV_800OFF, .T. )
		CriarSX6( cMV_800OFF, 'L', 'LIGAR/DESLIGAR A GERACAO DO FORMULARIO DE SC, F=DESLIGADO, T=LIGADO . CSFA800.prw', '.F.' )
	Endif
	
	// Parâmetro para ligar e desligar a funcionalidade.
	If .NOT. GetMv( cMV_800OFF, .F. )
		Return
	Endif
		
	SC1->( dbSeek( xFilial( 'SC1' ) + cC1_NUM ) )
   While SC1->( .NOT. EOF() ) .And. SC1->C1_FILIAL == xFilial('SC1') .And. SC1->C1_NUM == cC1_NUM
   	// Fazer a gravação dos campos do Formulário da SC - CSFA800
		A800Gravar()

		// 1=Sim;2=Nao
		If SC1->C1_RATEIO == '1'
			SCX->( dbSetOrder( 1 ) )
			SCX->( dbSeek( xFilial( 'SCX' ) + SC1->C1_NUM + SC1->C1_ITEM ) )
			While SCX->( .NOT. EOF() ) .AND. SCX->CX_FILIAL == xFilial( 'SCX' ) .AND. SCX->CX_SOLICIT == SC1->C1_NUM .AND. SCX->CX_ITEMSOL == SC1->C1_ITEM
				SCX->( AAdd( aCtaCusto, { CX_ITEMSOL, CX_ITEM, CX_CONTA, CX_CC, CX_ITEMCTA, CX_CLVL } ) )
				SCX->( dbSkip() )
			End
		Else
			If AScan( aCtaCusto, {|e| e[ 3 ] + e[ 4 ] + e[ 5 ] + e[ 6 ] == SC1->( C1_CONTA + C1_CC + C1_ITEMCTA + C1_CLVL ) } ) == 0
				SC1->( AAdd( aCtaCusto, { C1_ITEM, '  ', C1_CONTA, C1_CC, C1_ITEMCTA, C1_CLVL } ) )
			Endif
		Endif
		
		If Len( aWord_Head ) == 0
			aSM0 := SM0->( GetAdvFVal( 'SM0', {'M0_FILIAL','M0_CIDCOB'}, cEmpAnt + SC1->C1_FILENT, 1 ) )
			
			nP := AScan( aCidades,{|e| e[ 1 ] == RTrim( aSM0[ 2 ] ) } )
			
			If nP > 0
				aSM0[ 2 ] := aCidades[ nP, 2 ]
			Endif
			
			aSM0[ 2 ] := Capital( RTrim( aSM0[ 2 ] ) ) 
			
			AAdd( aWord_Head, SC1->( C1_FILIAL + '-' + C1_NUM ) )
			AAdd( aWord_Head, Iif(Empty(SC1->C1_TIPOSC),'',StrTokArr(SX3->(Posicione('SX3',2,'C1_TIPOSC','X3CBox()')),';')[Val(SC1->C1_TIPOSC)]))
			AAdd( aWord_Head, SC1->C1_DEP_SOL )
			AAdd( aWord_Head, SC1->C1_NOMESOL )
			AAdd( aWord_Head, RTrim( SC1->C1_CC ) + ' ' + CTT->( Posicione('CTT',1,xFilial('CTT')+SC1->C1_CC,'CTT_DESC01') ) )
			AAdd( aWord_Head, RTrim( SC1->C1_ITEMCTA ) + ' ' + CTD->( Posicione('CTD',1,xFilial('CTD')+SC1->C1_ITEMCTA,'CTD_DESC01') ) )
			AAdd( aWord_Head, RTrim( SC1->C1_CLVL ) + ' ' + CTH->( Posicione('CTH',1,xFilial('CTH')+SC1->C1_CLVL,'CTH_DESC01') ) )
			AAdd( aWord_Head, 'VALOR ESTIMADO DA SC' )
			AAdd( aWord_Head, Iif(Empty(SC1->C1_BUDGET),'',StrTokArr(SX3->(Posicione('SX3',2,'C1_BUDGET','X3CBox()')),';')[Val(SC1->C1_BUDGET)]))
			AAdd( aWord_Head, SC1->C1_CTAORC )
			AAdd( aWord_Head, SC1->C1_DESCRDP )
			AAdd( aWord_Head, SM0->M0_NOMECOM )
			AAdd( aWord_Head, SC1->C1_FILENT + '-' + aSM0[ 2 ] )
			AAdd( aWord_Head, SC1->C1_DEP_ENT )
			AAdd( aWord_Head, SC1->C1_CONTATO )
			AAdd( aWord_Head, SC1->C1_TELEF )
			AAdd( aWord_Head, SC1->C1_JUSTIF )
			AAdd( aWord_Head, SC1->C1_PQ_ESEM )
			AAdd( aWord_Head, SC1->C1_OBS_SOL )
			AAdd( aWord_Head, aSM0[ 2 ] )
		Endif
		
		AAdd( aWord_Prod, { SC1->C1_ITEM,;
		Iif( Empty( SC1->C1_PARTNUM ), SC1->C1_PRODUTO, SC1->C1_PARTNUM ),;
		Iif( Empty( SC1->C1_ESPECIF ), SC1->C1_DESCRI, SC1->C1_ESPECIF ),;
		LTrim( TransForm( SC1->C1_QUANT, '@E 999,999,999.99' ) ),;
		LTrim( TransForm( SC1->C1_XPRECO,'@E 999,999,999.99' ) ),;
		LTrim( TransForm( SC1->C1_XTOTAL,'@E 999,999,999.99' ) ) } )

		// Totalizar o valor estimado dos produtos.
		nTOTAL_SC += SC1->C1_XTOTAL

		SC1->( dbSkip() )
	End
	
	If Len( aCtaCusto ) > 1
		aWord_Head[ 5 ] := cRateio
		aWord_Head[ 6 ] := cRateio
		aWord_Head[ 7 ] := cRateio
	Endif
	
	aWord_Head[ 08 ] := LTrim( TransForm( nTOTAL_SC, '@E 999,999,999.99' ) )
	
	// Se é maior que 1 é porque há rateio, então imprimir no formulário.
	If Len( aCtaCusto ) > 1
		cCtaCusto := '[ RATEIO ]-----------------------------------------------------' + CRLF
		cCtaCusto += 'Item It.Rat. C.Contabil           C.Custo   C.Result. C.Projeto' + CRLF
		//            xxxx xx      xxxxxxxxxxxxxxxxxxxx xxxxxxxxx xxxxxxxxx xxxxxxxxx
		AEval( aCtaCusto, {|e| cCtaCusto += e[1] + ' ' + e[2] + '      ' + e[3] + ' ' + e[4] + ' ' + e[5] + ' ' + e[6] + CRLF } )
		aWord_Head[ 19 ] := aWord_Head[ 19 ] + CRLF + cCtaCusto
	Endif
	
	// Limpas as variáveis (MEMVAR).
	A800Clear()

	// Integração com o Ms-Word.
	A800PDF( aWord_Head, aWord_Prod )
Return

//-------------------------------------------------------------------
// Rotina | A800PDF   | Autor | Robson Gonçalves  | Data | 30/05/2017
//-------------------------------------------------------------------
// Descr. | Rotina para compor os dados para gerar o formato PDF.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
Static Function A800PDF( aHead, aProd )
	Local aH_VarWord := {}
	Local aP_VarWord := {}
	Local cDOCUMENTO := ''
	Local cExtArq := ''
	Local cFormat := '17'
	Local cItem := ''
	Local cKey := ''
	Local cMV_800DOT := 'MV_800DOT'
	Local cMV_DIRDOC := GetMv('MV_DIRDOC')
	Local cNomArqDOC := ''
	Local cNomArqPDF := ''
	Local cNomeArq := ''
	Local cOrigem := ''
	Local cTemplate := ''
	Local cTempPath := GetTempPath()
	Local cVersaoPDF := ''
	
	Local lCopy := .F.
	Local lReadOnly := .F.
	
	Local nCheck := 0
	Local nI := 0
	Local oWord

	AAdd( aH_VarWord, 'W_C1_NUM' )
	AAdd( aH_VarWord, 'W_C1_TIPOSC' )
	AAdd( aH_VarWord, 'W_C1_DEP_SOL' )
	AAdd( aH_VarWord, 'W_C1_NOMESOL' )
	AAdd( aH_VarWord, 'W_C1_CC' )
	AAdd( aH_VarWord, 'W_C1_ITEMCTA' )
	AAdd( aH_VarWord, 'W_C1_CLVL' )
	AAdd( aH_VarWord, 'W_TOTAL_SC' )
	AAdd( aH_VarWord, 'W_C1_BUDGET' )
	AAdd( aH_VarWord, 'W_C1_CTAORC' )
	AAdd( aH_VarWord, 'W_C1_DESCRDP' )
	AAdd( aH_VarWord, 'W_M0_NOMECOM' )
	AAdd( aH_VarWord, 'W_M0_FILIAL' )
	AAdd( aH_VarWord, 'W_C1_DEP_ENT' )
	AAdd( aH_VarWord, 'W_C1_CONTATO' )
	AAdd( aH_VarWord, 'W_C1_TELEF' )
	AAdd( aH_VarWord, 'W_C1_JUSTIF' )
	AAdd( aH_VarWord, 'W_C1_PQ_ESEM' )
	AAdd( aH_VarWord, 'W_C1_OBS_SOL' )
	AAdd( aH_VarWord, 'W_M0_CIDCOB' )
	
	AAdd( aP_VarWord, 'W_C1_ITEM' )
	AAdd( aP_VarWord, 'W_C1_PRODUTO' )
	AAdd( aP_VarWord, 'W_C1_DESCRI' )
	AAdd( aP_VarWord, 'W_C1_QUANT' )
	AAdd( aP_VarWord, 'W_C1_XPRECO' )
	AAdd( aP_VarWord, 'W_C1_XTOTAL' )
	
	If .NOT. GetMv( cMV_800DOT, .T. )
		CriarSX6( cMV_800DOT, 'C', 'ARQUIVO TEMPLATE FORMULARIO SOLICITACAO DE COMPRAS. CSFA800.prw', 'formul_SC.dot' )
	Endif
	
	cMV_800DOT := GetMv( cMV_800DOT, .F. )
	
	cOrigem := cMV_DIRDOC + '\' + cMV_800DOT

	If File( cOrigem )
		CpyS2T( cOrigem, cTempPath, .T.)
		Sleep( Randomize( 1, 499 ) )
		
		cTemplate := cTempPath + SubStr( cOrigem, RAt( '\',cOrigem )+1 )
		
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
			SplitPath( cTemplate, , , @cNomeArq, @cExtArq )
			
			cNomeArq := cNomeArq + '_' + aHead[ 1 ]
			
			cVersaoPDF := A800Knowledge( cNomeArq, '.pdf' )
			
			cNomArqPDF := SubStr( cTemplate, 1, RAt( '\', cTemplate ) ) + cNomeArq + '_v' + cVersaoPDF + '.pdf'
			
			cNomArqDOC := StrTran( cNomArqPDF, '.pdf', '.doc' )
			
			oWord	:= OLE_CreateLink()
			
			OLE_SetProperty( oWord, '206', .F. )
			
			OLE_NewFile( oWord , cTemplate )
			
			// Descarregar os dados nas informações fixas.
			For nI := 1 To Len( aH_VarWord )
				OLE_SetDocumentVar( oWord, aH_VarWord[ nI ], aHead[ nI ] )
			Next nI
			
			// Descarregar os dados na informações de múltiplas linhas.
			For nI := 1 To Len( aProd )
				For nJ := 1 To Len( aP_VarWord )
					If	cItem == ''
						cItem := aProd[ nI, 1 ]
					Endif
					OLE_SetDocumentVar( oWord, aP_VarWord[ nJ ] + LTrim( Str( nI ) ), aProd[ nI, nJ ] )
				Next nJ
			Next nI
			
			OLE_SetDocumentVar( oWord, 'W_QTDE_ITENS', cValToChar( Len( aProd) ) )
			
			OLE_ExecuteMacro( oWord, 'ITENS_FORMUL_SC' )
			
			OLE_UpDateFields( oWord )
			
			OLE_SetProperty( oWord, '206', .F. )
			
			OLE_SaveAsFile( oWord, cNomArqDOC )
			Sleep( Randomize( 1, 499 ) )
			
			OLE_OpenFile( oWord, cNomArqDOC )
			Sleep( Randomize( 1, 499 ) )
			
			OLE_SaveAsFile( oWord, cNomArqPDF, /*cPassword*/, /*cWritePassword*/, lReadOnly, cFormat)
			Sleep( Randomize( 1, 499 ) )
			
			OLE_CloseFile( oWord )
			
			OLE_CloseLink( oWord )
			
			FErase( cTemplate )
			
			cKey := SubStr( aHead[ 1 ], At( '-', aHead[ 1 ] )+1 ) + cItem
			
			cDOCUMENTO := SubStr( cNomArqPDF, RAt( '\', cNomArqPDF )+1 )
			
			A800Anexar( cNomArqPDF, cKey, cDOCUMENTO, 'SC1', .T. )
			
			FErase( cNomArqDOC )
			Sleep( Randomize( 1, 499 ) )
			
			ShellExecute( 'Open', cNomArqPDF, '', cTempPath, 1 )
			Sleep( 3000 )
		Else
			MsgAlert('Não foi possível copiar o arquivo template do servidor para a estação, por isso não será possível gerar o formulário de solicitação de compras.','Inconsistência')
		Endif
	Else
		MsgAlert('Arquivo template para gerar o formulário de solicitação de compras no formato PDF não localizado. O formulário não será gerado.','Inconsistência')
	Endif
Return

//-------------------------------------------------------------------
// Rotina | A800Anexar | Autor | Robson Gonçalves | Data | 30/05/2017
//-------------------------------------------------------------------
// Descr. | Rotina para anexar o documento nos registros da SC.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
Static Function A800Anexar( cArquivo, cNUM_DOC, cDocumento, cEntidade, lFirst )
	Local lRet := .T.
	Local cFile := ''
	Local cExten := ''
	Local cObjeto := ''
	Local cACB_CODOBJ := ''
	
	//--------------------------------------------------------------------------------
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
		AC9->AC9_DTGER  := dDataBase
		AC9->( MsUnLock() )
		
		ACC->( RecLock( 'ACC', .T. ) )
		ACC->ACC_FILIAL := xFilial( 'ACC' )
		ACC->ACC_CODOBJ := cACB_CODOBJ
		ACC->ACC_KEYWRD := cDocumento 
		ACC->( MsUnLock() )
	Else
		MsgAlert('Não foi possível anexar o documento no banco de conhecimento, problemas com o FT340CPYOBJ.','Inconsistência')
	Endif
Return(cObjeto)

//-------------------------------------------------------------------
// Rotina | A800Knowledge | Autor | Robson Gonçalves | Data  30/05/17
//-------------------------------------------------------------------
// Descr. | Rotina para verificar se há documentos anexados.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
Static Function A800Knowledge( cArq, cExt )
	Local cSQL := ''
	Local cTRB := ''
	Local cSeek := ''
	Local nCount := 0
	Local nP := 0
	
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

//-------------------------------------------------------------------
// Rotina | UPD800 | Autor | Robson Gonçalves     | Data | 30/05/2017
//-------------------------------------------------------------------
// Descr. | Rotina de update para criar os campos.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
User Function UPD800()
	Local bPrepar := {||.T.}
	Local cModulo := 'COM'
	Local nVersao := 1
	
	If nVersao == 1
		bPrepar := {|| U_U800Ini() }
	Endif
	
	If nVersao > 0
		NGCriaUpd( cModulo, bPrepar, nVersao )
	Endif
Return

//-------------------------------------------------------------------
// Rotina | U800Ini | Autor | Robson Gonçalves    | Data | 30/05/2017
//-------------------------------------------------------------------
// Descr. | Rotina complementar do update para criar os campos.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-------------------------------------------------------------------
User Function U800Ini()
	aSX3 := {}
	aSX7 := {}
	aHelp := {}
	
	AAdd( aSX3, {"SC1",NIL,"C1_TIPOSC" ,"C", 1,0,"Tp.Solicit"  ,"Tp.Solicit"  ,"Tp.Solicit" ,"Tipo de solicitacao"       ,"Tipo de solicitacao"      ,"Tipo de solicitacao"      ,"@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","Pertence('123')","1=Normal;2=Especifica;3=Emergencial","1=Normal;2=Especifica;3=Emergencial","1=Normal;2=Especifica;3=Emergencial","","","","","","","","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_DEP_SOL","C",40,0,"Depto.Solici","Depto.Solici","Depto.Solici","Depto. do solicitante"    ,"Depto. do solicitante"    ,"Depto. do solicitante"    ,"@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","","","","","","","","","","" ,"","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_NOMESOL","C",30,0,"Solicitante" ,"Solicitante" ,"Solicitante" ,"Nome do solicitante"      ,"Nome do solicitante"      ,"Nome do solicitante"      ,"@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","","","","","","","","","","" ,"","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_BUDGET" ,"C", 1,0,"Prev.Budget?","Prev.Budget?","Prev.Budget?","Previsto em budget?"      ,"Previsto em budget?"      ,"Previsto em budget?"      ,"@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","Pertence('12')","1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao","","","","","","","","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_CTAORC" ,"C",40,0,"Cta.Ctb.Orc.","Cta.Ctb.Orc.","Cta.Ctb.Orc.","Cta.Contab.Orcada"        ,"Cta.Contab.Orcada"        ,"Cta.Contab.Orcada"        ,"@!"               ,"","€€€€€€€€€€€€€€ ","","CT1",0,"þÀ","","S","U","N","A","R","","Vazio() .Or. Ctb105Cta(SubS(M->C1_CTAORC,1,Len(CT1->CT1_CONTA)))","","","","","","","","","","","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_DESCRDP","M",10,0,"Descri. Desp","Descri. Desp","Descri. Desp","Descricao da despesa"     ,"Descricao da despesa"     ,"Descricao da despesa"     ,"@1"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","","","","","","","","","","" ,"","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_DEP_ENT","C",40,0,"Depto.Entreg","Depto.Entreg","Depto.Entreg","Departamento entrega"     ,"Departamento entrega"     ,"Departamento entrega"     ,"@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","","","","","","","","","","" ,"","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_CONTATO","C",30,0,"Nome contato","Nome contato","Nome contato","Nome do contato"          ,"Nome do contato"          ,"Nome do contato"          ,"@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","","","","","","","","","","" ,"","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_TELEF"  ,"C",30,0,"Fone/Ramal"  ,"Fone/Ramal"  ,"Fone/Ramal"  ,"Telefone e ramal"         ,"Telefone e ramal"         ,"Telefone e ramal"         ,"@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","","","","","","","","","","" ,"","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_JUSTIF" ,"M",10,0,"Justificativ","Justificativ","Justificativ","Justificativa da necessid","Justificativa da necessid","Justificativa da necessid","@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","","","","","","","","","","" ,"","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_PQ_ESEM","M",10,0,"Porque Es/Em","Porque Es/Em","Porque Es/Em","Porque especifica/emergen","Porque especifica/emergen","Porque especifica/emergen","@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","","","","","","","","","","" ,"","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_OBS_SOL","M",10,0,"Observacao"  ,"Observacao"  ,"Observacao"  ,"Observacao formulario"    ,"Observacao formulario"    ,"Observacao formulario"    ,"@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","","","","","","","","","","" ,"","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_ESPECIF","M",10,0,"Espec.Tecnic","Espec.Tecnic","Espec.Tecnic","Especificacao tecnica"    ,"Especificacao tecnica"    ,"Especificacao tecnica"    ,"@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","","","","","","","","","","" ,"","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_PARTNUM","C",40,0,"Part Number" ,"Part Number" ,"Part Number" ,"Part Number"              ,"Part Number"              ,"Part Number"              ,"@!"               ,"","€€€€€€€€€€€€€€ ","",""   ,0,"þÀ","","" ,"U","N","A","R","","","","","","","","","","","" ,"","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_XPRECO" ,"N",12,2,"Prc Un Estim","Prc Un Estim","Prc Un Estim","Preco unit. estimado"     ,"Preco unit. estimado"     ,"Preco unit. estimado"     ,"@E 999,999,999.99","","€€€€€€€€€€€€€€ ","",""   ,0,"þA","","S","U","N","A","R","","","","","","","","","","","S","","","","N","N","","","",""})
	AAdd( aSX3, {"SC1",NIL,"C1_XTOTAL" ,"N",12,2,"Total Estim" ,"Total Estim" ,"Total Estim" ,"Valor total estimado"     ,"Valor total estimado"     ,"Valor total estimado"     ,"@E 999,999,999.99","","€€€€€€€€€€€€€€ ","",""   ,0,"þA","","" ,"U","N","V","R","","","","","","","","","","","S","","","","N","N","","","",""})
	
	AAdd( aHelp, { 'C1_TIPOSC ', 'Tipo de solicitacao.' } )
	AAdd( aHelp, { 'C1_DEP_SOL', 'Departamento do solicitante.' } )
	AAdd( aHelp, { 'C1_NOMESOL', 'Nome do solicitante.' } )
	AAdd( aHelp, { 'C1_BUDGET ', 'Previsto em budget?' } )
	AAdd( aHelp, { 'C1_CTAORC ', 'Conta contábil orçada.' } )
	AAdd( aHelp, { 'C1_DESCRDP', 'Descrição da despesa.' } )
	AAdd( aHelp, { 'C1_DEP_ENT', 'Departamento de entrega.' } )
	AAdd( aHelp, { 'C1_CONTATO', 'Nome do contato.' } )
	AAdd( aHelp, { 'C1_TELEF  ', 'Telefone e/ou ramal.' } )
	AAdd( aHelp, { 'C1_JUSTIF ', 'Justificativa da necessidade.' } )
	AAdd( aHelp, { 'C1_PQ_ESEM', 'Porque a solicitação é específica ou emergencia.' } )
	AAdd( aHelp, { 'C1_OBS_SOL', 'Observação do formulário.' } )
	AAdd( aHelp, { 'C1_ESPECIF', 'Especificação técnica.' } )
	AAdd( aHelp, { 'C1_PARTNUM', 'Part Number do produto' } )
	AAdd( aHelp, { 'C1_XPRECO' , 'Preço estimado do produto.' } )
	AAdd( aHelp, { 'C1_XTOTAL' , 'Valor total estimado do produto.' } )

	AAdd( aSX7, { 'C1_QUANT' ,'001','M->C1_QUANT*aCOLS[n,GdFieldPos("C1_XPRECO")]'            ,'C1_XTOTAL','P','N','SC1',0,'','','U'})
	AAdd( aSX7, { 'C1_XPRECO','001','aCOLS[n,GdFieldPos("C1_QUANT")]*M->C1_XPRECO'            ,'C1_XTOTAL','P','N','SC1',0,'','','U'})
	AAdd( aSX7, { 'C1_CTAORC','001','RTrim( CT1->CT1_CONTA ) + "-" + RTrim( CT1->CT1_DESC01 )','C1_CTAORC','P','S','CT1',1,'xFilial("CT1")+M->C1_CTAORC','','U'})
Return