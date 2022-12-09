#Include 'Protheus.ch'

Static __nExec := 0

//-----------------------------------------------------------------------
// Rotina | VNDA530      | Autor | David - TOTVS SM   | Data | 15/01/2014
//-----------------------------------------------------------------------
// Descr. | Rotina para cancelamento de voucher em lote         
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
User Function VNDA530()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private cCadastro := 'Cancelamento de Voucher'
	
	AAdd( aSay, 'Este programa permite que sejam cancelados voucher´s referente ao fluxo posicionado em lote.' )
		
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1 .and. A530VLD() 
		A530Proc()
	Endif
	
Return

//-----------------------------------------------------------------------
// Rotina | A530VLD     | Autor | David - TOTVS SM   | Data | 15/01/2014
//-----------------------------------------------------------------------
// Descr. | Rotina para validação do inicio de processo de cancelamneto
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A530VLD()
Local lRet 		:= .T.
Local aRet		:= {}
Local GrpAltVou	:= GetNewPar("MV_XALTVOU", "000001" )

If Alltrim(__CUSERID) <> Alltrim(SZF->ZF_USERCOD)
	DbSelectArea("SZO")
	SZO->(DbSetOrder(1))

	If !SZO->(DbSeek(xFilial("SZO")+Alltrim(__CUSERID) )) .OR. !SZO->ZO_EQATEND $ GrpAltVou 
		Help( ,, 'VoucherTOK',, 'Usuário sem permissão para alterar o Voucher.';
				+' Apenas o usuário que criou o Voucher poderá alterá-lo', 1, 0 ) 
		lRet:=.F.
	EndIf
EndIf

Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A530Proc     | Autor | David - TOTVS SM   | Data | 15/01/2014
//-----------------------------------------------------------------------
// Descr. | Rotina para dar início no processamento dos dados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A530Proc()
	Local aPar := {}
	Local aRet := {}

	Local bValid := {|| NIL }
	
	Private aHeader := {}
	Private aCOLS := {}
	
	Processa( {|lEnd| Iif( A530Load(), A530Show(), NIL ) }, cCadastro, 'Processando, aguarde...', .F. )
	
Return

//-----------------------------------------------------------------------
// Rotina | A530Load     | Autor | David - TOTVS SM   | Data | 15/01/2014
//-----------------------------------------------------------------------
// Descr. | Rotina para carregar os dados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A530Load( )
	Local lRet := .T.
	Local cAlias := ''
	
	Local nI := 0
	Local nElem := 0
	Local nPos := 0
	
	Local aCPO := {}
		
	AAdd( aCPO, { 'MARK',       '   x'               } )
	AAdd( aCPO, { 'STATUS',     'Status'             } )
	AAdd( aCPO, { 'ZF_CODFLU',  'Fluxo'	             } ) 	
	AAdd( aCPO, { 'ZF_COD',  	'Voucher'            } )
	AAdd( aCPO, { 'ZF_QTDVOUC', 'Qtd Voucher'        } )
	AAdd( aCPO, { 'ZF_SALDO',  	'Saldo'           	 } )
	AAdd( aCPO, { 'OBSCAN',  	'Obs. Canc.'		 } )
	
	cALias := GetNextALias()  
	
	BeginSql Alias cALias
		SELECT 
			SZF.R_E_C_N_O_ SZFREC,
			ZF_CODFLU,
			ZF_COD,
			ZF_QTDVOUC,
			ZF_SALDO
		FROM
			%Table:SZF%	SZF
		WHERE
			SZF.ZF_FILIAL = %xFilial:SZF%	AND
			SZF.ZF_CODFLU = %Exp:SZF->ZF_CODFLU%	AND
			SZF.%NotDel%
	EndSql

	If !(cAlias)->(EoF())
		SX3->( dbSetOrder( 2 ) )
		For nI := 1 To Len( aCPO )
			SX3->( dbSeek( aCPO[ nI, 1 ] ) )
			If aCPO[ nI, 1 ] $ 'MARK|STATUS'
				AAdd( aHeader, { aCPO[ nI, 2 ], aCPO[ nI, 1] , '@BMP', 10, 0, '', '', '', '', '' } ) 
			ElseIf aCPO[ nI, 1 ] $ 'OBSCAN'
				AAdd( aHeader, { aCPO[ nI, 2 ], aCPO[ nI, 1] , '@!', 100, 0, '', '', '', '', '' } ) 
			Else
				SX3->( AAdd( aHeader,{ aCPO[ nI, 2 ], RTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL,'AllWaysTrue', X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } ) )
			Endif
		Next nI
		
		While ! (cAlias)->( EOF() )
				SZF->(DbGoTo((cALias)->SZFREC))
				
				AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
				nElem := Len( aCOLS )
			   
				For nI := 1 To Len( aHeader )
					If aHeader[ nI, 2 ] == 'MARK'
						aCOLS[ nElem, nI ] := 'LBNO'
					Elseif aHeader[ nI, 2 ] == 'STATUS'
						If SZF->ZF_SALDO == 0 .or. SZF->ZF_ATIVO == 'N'
							aCOLS[ nElem, nI ] := 'BR_CINZA'
						Else 
							aCOLS[ nElem, nI ] := 'BR_AZUL'
						EndIf
					Elseif aHeader[ nI, 2 ] == 'OBSCAN'
						If SZF->ZF_SALDO == 0 
							aCOLS[ nElem, nI ] := 'Voucher utilizado e não poderá ser cancelado'
						ElseIf SZF->ZF_ATIVO == 'N'
							aCOLS[ nElem, nI ] := 'Voucher cancelado'
						Else
							aCOLS[ nElem, nI ] := ''
						EndIf
					Else
						If ValType( (cAlias)->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) ) ) == 'C'
							aCOLS[ nElem, nI ] := RTrim( (cAlias)->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) ) )
						Else
							aCOLS[ nElem, nI ] := (cALias)->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) )
						Endif
					Endif
				Next nI
				aCOLS[ nElem, Len( aHeader ) + 1 ] := .F.
				
				IncProc()
				(cAlias)->( dbSkip() )
		End
	Else
		lRet := .F.
		MsgInfo('Não há dados para ser processado, verifique os parâmetros.',cCadastro)	
	EndIf
	(cAlias)->(DbCLoseArea())		
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A530Show     | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar os dados.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A530Show()
	Local oDlg 
	
	Local nCol := 0
	Local nRow := 0
	Local nL := 2
	Local nI := 0
	
	Local cOK := 'AllWaysTrue'
	Local cU7_COD_NOME := ''
	
	Local aButton := {}
	
	Local oFont := TFont():New('Courier new',,-16,,.T.)
	
	Private lA530Mrk := .F.
		
	Private oGride
	
	Private oPanel
	
	// [1] - Título do botão.
	// [2] - Chamada da funcionalidade.
	// [3] - Nº da tecla de atalho.
	AAdd( aButton, { '&Pesquisar F4'        , '{|| GdSeek(oGride,,aHeader,aCOLS,.F.) }' , 115 } )
	AAdd( aButton, { '&Legenda F5'          , '{|| A530Legenda( Len( oGride:aCOLS ) ) }' , 116 } )
	AAdd( aButton, { '&Marcar todos F6'     , '{|| A530MrkAll() }' , 117 } )
	AAdd( aButton, { '&Desmarcar todos F7'  , '{|| A530DesMrk() }' , 118 } )
	AAdd( aButton, { '&Inverter seleção F8' , '{|| A530Invert() }' , 119 } )
	AAdd( aButton, { '&Cancelar Seleção F9' , '{|| A530ProcC(oPanel) }' , 120 } )
	AAdd( aButton, { '&Sair F10'            , '{|| Iif( MsgYesNo("Deseja realmente sair da rotina?", cCadastro ), oDlg:End(), NIL ) }' , 121 } )
	
	oMainWnd:ReadClientCoors()
	nCol := oMainWnd:nClientWidth
	nRow := oMainWnd:nClientHeight
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 00,00 TO nRow-34,nCol-8 PIXEL
		oDlg:lMaximized := .T.
		
		oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,26,.F.,.T.)
		oPanel:Align := CONTROL_ALIGN_TOP
		
		For nI := 1 To Len( aButton )			
			SetKey( aButton[ nI, 3 ], &(aButton[nI,2]) )
			TButton():New(3,nL,aButton[nI,1],oPanel,&(aButton[nI,2]),56,9,,,.F.,.T.,.F.,,.F.,,,.F.)
			nL += 60
		Next nI
		
		oGride := MsNewGetDados():New( 012, 002, 120, 265, 0, cOK, cOK, '', {}, 0, Len(aCOLS), '', '', '', oDlg, aHeader, aCOLS )
		oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		oGride:oBrowse:bLDblClick := {||  A530MrkOne(), oGride:Refresh() }
		oGride:oBrowse:bHeaderClick := {|| __nExec++,Iif((__nExec%2)<>0,(Iif(lA530Mrk,A530DesMrk(),A530MrkAll()),oGride:Refresh()),NIL)}
	ACTIVATE MSDIALOG oDlg
	
	AEval( aButton, {|p| SetKey( p[ 3 ], NIL ) } )
Return

//-----------------------------------------------------------------------
// Rotina | A530Legenda  | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar as legendas dos registros.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A530Legenda( nRegistros )
	Local aCor := {}
	
	AAdd( aCor, { 'LBNO'        , 'Registro não selecionado' } )
	AAdd( aCor, { 'LBOK'        , 'Registro selecionado' } )

	AAdd( aCor, { 'BR_VERMELHO' , 'Voucher Criticado durante cancelamento' } )
	AAdd( aCor, { 'BR_AZUL'     , 'Voucher Apto a Cancelar' } )
	AAdd( aCor, { 'BR_AMARELO'  , 'Voucher Cancelado pela Rotina' } )
	AAdd( aCor, { 'BR_CINZA'  	, 'Voucher inapto para cancelamento' } )

	AAdd( aCor, { ''            , LTrim(Str(nRegistros))+' registro(s) localizado(s).' } )
	
	BrwLegenda( cCadastro, 'Legenda dos registros', aCor )	
Return

//-----------------------------------------------------------------------
// Rotina | A530MrkOne   | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina p/ marcar somente um registro ou todos da mesma lista.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A530MrkOne()
	Local nI := 0
	Local cMark := ''
	
	If oGride:aCOLS[ oGride:nAt, 2 ] <> "BR_AZUL"
		MsgStop("Voucher inapto para cancelamento. Verifique o campo 'Obs. Canc.'")
	ElseIf oGride:aCOLS[ oGride:nAt, 1 ] == 'LBOK'
		oGride:aCOLS[ oGride:nAt, 1 ] := 'LBNO'
	Else
		oGride:aCOLS[ oGride:nAt, 1 ] := 'LBOK'
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A530MrkAll   | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para marcar todos os registro.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A530MrkAll()
	Local nI := 0
	lA530Mrk:=!lA530Mrk
	For nI := 1 To Len( oGride:aCOLS )
		If oGride:aCOLS[ nI, 2 ] <> "BR_CINZA" .and. oGride:aCOLS[ nI, 2 ] <> "BR_VERMELHO"
			oGride:aCOLS[ nI, 1 ] := 'LBOK'
		EndIf
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | A530DesMrk   | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para desmarcar todos os registros.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A530DesMrk()
	Local nI := 0
	lA530Mrk:=!lA530Mrk
	For nI := 1 To Len( oGride:aCOLS )
		oGride:aCOLS[ nI, 1 ] := 'LBNO'
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | A530Invert   | Autor | Robson Luiz - Rleg | Data | 10/12/2012
//-----------------------------------------------------------------------
// Descr. | Rotina para inverter a marca dos registros.
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A530Invert()
	Local nI := 0
	For nI := 1 To Len( oGride:aCOLS )
		If oGride:aCOLS[ nI, 2 ] <> "BR_CINZA" .and. oGride:aCOLS[ nI, 2 ] <> "BR_VERMELHO"
			If oGride:aCOLS[ nI, 1 ] == 'LBOK'
				oGride:aCOLS[ nI, 1 ] := 'LBNO'
			Else
				oGride:aCOLS[ nI, 1 ] := 'LBOK'
			Endif
		EndIf
	Next nI	
Return

//---------------------------------------------------------
// Rotina | A530Proc   | Autor | David - TOTVS SM   | Data | 16/01/2014
//-----------------------------------------------------------------------
// Descr. | Rotina que solicita ao operador a confirmação do cancelamento
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A530ProcC( oPanel )
	Local lRet    := .F.
	Local aPar    := {}
	Local aRet    := {}
	Local cTitulo := 'Cancelamento de voucher'
	Local cMsg1   := 'Esta ação irá realizar o cancelamento dos voucher selecionados no sistema Protheus juntamente '+; 
                      'com o Portal de Vendas. Deseja Confirmar?'
	Local cMsg2   := 'Informe o motivo em 100 caracteres apenas.'
	Local bOk     := {|| Iif(Len(aRet[1])<=100,.T.,(MsgAlert(cMsg2,cTitulo),.F.)) }
	
	If MsgYesNo(cMsg1,cTitulo)
		AAdd(aPar,{11,"Informe o motivo do cancelamento","",".T.",".T.",.T.})
		lRet := ParamBox( aPar,"Motivo do cancelamento", @aRet, bOk )
		If lRet
			FWMsgRun(oPanel, {|oSay| A530Canc( oSay, aRet[1] ) } )
			MsgInfo("Observe o Status de Cancelamento dos voucher´s selecionados",cTitulo)			
		Endif
	Endif	
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A530Canc   | Autor | David - TOTVS SM   | Data | 16/01/2014
//-----------------------------------------------------------------------
// Descr. | Rotina que cancela os voucher´s                            
//-----------------------------------------------------------------------
// Uso    | Certisign
//-----------------------------------------------------------------------
Static Function A530Canc( oSay, cMotivo )
	Local lRetCan	:= .F.
	Local nI		:= 0
	Local cMsg		:= ""
	
	For nI := 1 To Len( oGride:aCOLS )
		If oGride:aCOLS[ nI, 1 ] == 'LBOK'
			lRetCan := .T.
			oSay:cCaption := ('Cancelando Voucher Código ' + oGride:aCOLS[ nI, 4 ])
			ProcessMessages()
			cMsg := U_VNDA520(Alltrim(oGride:aCOLS[ nI, 4 ]),.F.,cMotivo)
			If Empty(cMsg)
				cMsg := "voucher cancelado com sucesso"
				oGride:aCOLS[ nI, 2 ] :=  "BR_VERDE"
			Else
				oGride:aCOLS[ nI, 2 ] :=  "BR_VERMELHO"
			EndIf
			oGride:aCOLS[ nI, 7 ] :=  cMsg
		EndIf
	Next nI
		
Return( lRetCan )
