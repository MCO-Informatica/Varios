//-----------------------------------------------------------------------
// Rotina | CSFA280    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para efetuar a relação de despesas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'
User Function CSFA280()
	Local aSubRot := {}
	Private cCadastro := 'Relação de Despesa'
	Private aRotina := {}
	
	AAdd( aSubRot, {'Conferência','U_A280Conf', 0, 6 } )
	AAdd( aSubRot, {'Auditoria'  ,'U_A280Exp' , 0, 6 } )
	
	AAdd( aRotina, {'Pesquisar'       ,'AxPesqui'  ,0, 1 } )
	AAdd( aRotina, {'Visualizar'      ,'U_A280Vis' ,0, 2 } )
	AAdd( aRotina, {'Digitar'         ,'U_A280Dig' ,0, 4 } )
	AAdd( aRotina, {'Relatório'       ,'U_A280Rel' ,0, 6 } )
	AAdd( aRotina, {'Exportar'        , aSubRot    ,0, 6 } )
	AAdd( aRotina, {'Aprovar'         ,'U_A280Apr' ,0, 6 } )
	AAdd( aRotina, {'Cancelar'        ,'U_A280CAp' ,0, 6 } )
	AAdd( aRotina, {'Anexar Documento','MsDocument',0 ,4 } )
	AAdd( aRotina, {'Legenda'         ,'U_A260Leg' ,0, 6 } )
	
	dbSelectArea('PAD')
	dbSetOrder(1)
	
	MBrowse(,,,,'PAD',,,,,,U_A260Leg(.T.))
Return

//-----------------------------------------------------------------------
// Rotina | A280Vis    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para visualizar a relação de despesas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A280Vis( cAlias, nRecNo, nOpc )
	Local oDlg
	Local oFld
	Local oPnl1
	Local oPnl2
	Local oMsMGet
	Local oSplitter
	
	Local nI := 0
	Local nElem := 0
	Local nPAD_RECNO := 0
	
	Local cPAD_NUMERO := ''
	Local cXE_RELACAO := ''
	
	Local aC := {}
	Local aCOLS := {}
	Local aHeader := {}
	Local aCompl := {}
	Local aFolder := {}
	
	Local oGride
	
	If PAD->PAD_STATUS $ '3|4'
		If PAD->PAD_COMPL == '0'
			nPAD_RECNO := PAD->(RecNo())
			cPAD_NUMERO := PAD->PAD_NUMERO
			While PAD->(.NOT. EOF()) .And. PAD->PAD_FILIAL==xFilial('PAD') .And. PAD->PAD_NUMERO==cPAD_NUMERO
				AAdd(aCompl,{PAD->(RecNo()),PAD->(PAD_NUMERO+'-'+PAD_COMPL),})
				PAD->(dbSkip())
			End
			PAD->(dbGoTo(nPAD_RECNO))
			aHeader := APBuildHeader('PAE')
			PAE->( dbSetOrder( 1 ) )
			If PAE->( dbSeek( xFilial( 'PAE' ) + PAD->PAD_NUMERO ) )
				While PAE->( .NOT. EOF() ) .And. PAE->PAE_FILIAL==xFilial('PAE') .And. PAE->PAE_NUMERO==PAD->PAD_NUMERO
					AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
					nElem := Len( aCOLS )
					For nI := 1 To Len( aHeader )
						If aHeader[ nI, 10 ] == 'V'
							cX3_RELACAO := Posicione('SX3',2,aHeader[nI,2],'X3_RELACAO')
							If .NOT. Empty(cX3_RELACAO)
								aCOLS[ nElem, nI ] := &(cX3_RELACAO)
							Endif
						Else
							aCOLS[ nElem, nI ] := PAE->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) )
						Endif
					Next nI
					aCOLS[ nElem, Len( aHeader ) + 1 ] := .F.
					PAE->( dbSkip() )
				End
			Endif
			aC := FWGetDialogSize( oMainWnd )
			DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE DS_MODALFRAME STATUS
				oDlg:lEscClose := .F.
				
				oSplitter := TSplitter():New( 1, 1, oDlg, 1000, 1000, 1 )
				oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
				
				oPnl1:= TPanel():New(1,1,'',oSplitter,,,,,,60,60)
				oPnl1:Align := CONTROL_ALIGN_ALLCLIENT
				
				oPnl2:= TPanel():New(1,1,'',oSplitter,,,,,,60,60)
				oPnl2:Align := CONTROL_ALIGN_ALLCLIENT
				
				PAD->(RegToMemory('PAD'))
				If Len(aCompl)>1
					For nI := 1 To Len( aCompl )
						If nI==1
							AAdd( aFolder, 'Solicitação nº '+aCompl[nI,2] )
						Else
							AAdd( aFolder, 'Complemento nº '+aCompl[nI,2] )
						Endif
					Next nI
					oFld := TFolder():New(0,0,aFolder,,oPnl1,,,,.T.,,260,184 )
					oFld:Align := CONTROL_ALIGN_ALLCLIENT
					oFld:bChange := {|| A280Change( @oFld, @aCompl ) }
					oMsMGet := MsMGet():New('PAD',PAD->(RecNo()),2,,,,,{0,0,400,600},,,,,,oFld:aDialogs[1],,,,,,,,,,,)
					oMsMGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
					aCompl[1,3] := oMsMGet
				Else
					oMsMGet := MsMGet():New('PAD',PAD->(RecNo()),2,,,,,{0,0,400,600},,,,,,oPnl1,,,,,,,,,,,)
					oMsMGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
				Endif
				
				oGride := MsNewGetDados():New(2,2,1000,1000,0,,,,,,Len(aCOLS),,,,oPnl2,aHeader,aCOLS)
				oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() })
		Else
			MsgAlert('Por favor, posicionar na solicitação de despesa principal.',cCadastro)
		Endif
	Else
		MsgAlert('Solicitação de despesa indisponível.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A280Dig    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para digitar a relação de despesas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A280Dig( cAlias, nRecNo, nOpc )
	Local oDlg
	Local oFld 
	Local oPnl1
	Local oPnl2
	Local oMsMGet
	Local oSplitter
	
	Local nI := 0
	Local nElem := 0
	Local nOpcao := 0
	Local nPAD_RECNO := 0
	
	Local cPAD_NUMERO := ''
	Local cXE_RELACAO := ''
	
	Local aC := {} 
	Local aCOLS := {}
	Local aHeader := {}
	Local aCompl := {}
	Local aFolder := {}
	Local aButton := {}
	
	Private oGride

	If PAD->PAD_STATUS $ '1|3'
		If PAD->PAD_COMPL == '0'
			nPAD_RECNO := PAD->(RecNo())
			cPAD_NUMERO := PAD->PAD_NUMERO
			While PAD->(.NOT. EOF()) .And. PAD->PAD_FILIAL==xFilial('PAD') .And. PAD->PAD_NUMERO==cPAD_NUMERO
				AAdd(aCompl,{PAD->(RecNo()),PAD->(PAD_NUMERO+'-'+PAD_COMPL),})
				PAD->(dbSkip())
			End
			PAD->(dbGoTo(nPAD_RECNO))
			aHeader := APBuildHeader('PAE')
			// Aprovado para digitar as despesas.
			If PAD->PAD_STATUS == '1'
				AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
				For nI := 1 To Len( aHeader )
					aCOLS[1,nI] := CriaVar(aHeader[nI,2],.F.)
				Next nI
				aCOLS[ 1, GdFieldPos('PAE_DATA' ,aHeader) ] := dDataBase
				aCOLS[ 1, GdFieldPos('PAE_ITEM' ,aHeader) ] := StrZero(1,Len(PAE->PAE_ITEM))
				aCOLS[ 1, GdFieldPos('PAE_MOEDA',aHeader) ] := '1'
				aCOLS[ 1, Len( aHeader ) + 1 ] := .F.
			// Despesas em fase de digitação.
			Elseif PAD->PAD_STATUS == '3'
				PAE->( dbSetOrder( 1 ) )
				If PAE->( dbSeek( xFilial( 'PAE' ) + PAD->PAD_NUMERO ) )
					While PAE->( .NOT. EOF() ) .And. PAE->PAE_FILIAL==xFilial('PAE') .And. PAE->PAE_NUMERO==PAD->PAD_NUMERO
						AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
						nElem := Len( aCOLS )
						For nI := 1 To Len( aHeader )
							If aHeader[ nI, 10 ] == 'V'
								cX3_RELACAO := Posicione('SX3',2,aHeader[nI,2],'X3_RELACAO')
								If .NOT. Empty(cX3_RELACAO)
									aCOLS[ nElem, nI ] := &(cX3_RELACAO)
								Endif
							Else
								aCOLS[ nElem, nI ] := PAE->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) )
							Endif
						Next nI
						aCOLS[ nElem, Len( aHeader ) + 1 ] := .F.
						PAE->( dbSkip() )
					End
				Endif
			Else
				MsgInfo('Solicitação de despesa indisponível.',cCadastro)
				Return
			Endif
			aC := FWGetDialogSize( oMainWnd )
			AAdd( aButton,{'ORDEM',{|| A280Ordenar() },'Ordenar','Ordenar'} )
			DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE DS_MODALFRAME STATUS
				oDlg:lEscClose := .F.
				
				oSplitter := TSplitter():New( 1, 1, oDlg, 1000, 1000, 1 ) 
				oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
				
				oPnl1:= TPanel():New(1,1,'',oSplitter,,,,,,60,60)
				oPnl1:Align := CONTROL_ALIGN_ALLCLIENT
				
				oPnl2:= TPanel():New(1,1,'',oSplitter,,,,,,60,60)
				oPnl2:Align := CONTROL_ALIGN_ALLCLIENT
				
				PAD->(RegToMemory('PAD',.F.))
				If Len(aCompl)>1
				   For nI := 1 To Len( aCompl )
						If nI==1
							AAdd( aFolder, 'Solicitação nº '+aCompl[nI,2] )
						Else
							AAdd( aFolder, 'Complemento nº '+aCompl[nI,2] )
						Endif
					Next nI
					oFld := TFolder():New(0,0,aFolder,,oPnl1,,,,.T.,,260,184 )
					oFld:Align := CONTROL_ALIGN_ALLCLIENT
					oFld:bChange := {|| A280Change( @oFld, @aCompl ) }
					oMsMGet := MsMGet():New('PAD',PAD->(RecNo()),2,,,,,{0,0,400,600},,,,,,oFld:aDialogs[1],,,,,,,,,,,)
					oMsMGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
					aCompl[1,3] := oMsMGet
				Else
					oMsMGet := MsMGet():New('PAD',PAD->(RecNo()),2,,,,,{0,0,400,600},,,,,,oPnl1,,,,,,,,,,,)
					oMsMGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
				Endif
				
				oGride := MsNewGetDados():New(2,2,1000,1000,GD_INSERT+GD_UPDATE+GD_DELETE,,,'+PAE_ITEM',,,999,,,,oPnl2,aHeader,aCOLS)
				oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
				oGride:oBrowse:SetFocus()
				oGride:oBrowse:nColPos := GdFieldPos('PAE_DATA',oGride:aHeader)
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT ;
			EnchoiceBar(oDlg, {|| Iif(MsgYesNo('Confirma a gravação dos dados?',cCadastro),(oDlg:End(),nOpcao:=1),NIL) }, {|| oDlg:End() },,aButton)
			If nOpcao == 1
				FwMsgRun(,{|| A280Grava( nRecNo )},,'Aguarde, gravando os dados...')
			Endif
		Else
			MsgAlert('Por favor, posicionar na solicitação de despesa principal.',cCadastro)
		Endif
	Else
		MsgAlert('Solicitação de despesa não disponível.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A280Ordenar| Autor | Robson Gonçalves     | Data | 28.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para ordenar os itens da digitação conforme a data.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A280Ordenar()
	Local nI := 0
	Local nPAE_ITEM := 0
	Local nPAE_DATA := 0
	
	nPAE_ITEM := GdFieldPos('PAE_ITEM',oGride:aHeader)
	nPAE_DATA := GdFieldPos('PAE_DATA',oGride:aHeader)

	ASort(oGride:aCOLS,,,{|a,b| a[nPAE_DATA] < b[nPAE_DATA]})
	
	For nI := 1 To Len(oGride:aCOLS)
		oGride:aCOLS[nI,nPAE_ITEM] := StrZero(nI,Len(PAE->PAE_ITEM),0)
	Next nI
	
	oGride:Refresh()
Return

//-----------------------------------------------------------------------
// Rotina | A280Change | Autor | Robson Gonçalves     | Data | 11.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para atualizar a MsMGet quando mudar de pasta.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A280Change( oFld, aCompl )
	Local oMsMGet
	If Empty( aCompl[ oFld:nOption, 3 ] )
		PAD->( dbGoTo( aCompl[ oFld:nOption, 1 ] ) )
		PAD->( RegToMemory('PAD',.F.) )
		oMsMGet := MsMGet():New('PAD',PAD->(RecNo()),2,,,,,{0,0,400,600},,,,,,oFld:aDialogs[oFld:nOption],,,,,,,,,,,)
		oMsMGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
		aCompl[ oFld:nOption, 3 ] := oMsMGet
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A280Apr    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para aprovar a relação de despesas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A280Apr( cAlias, nRecNo, nOpc )
	Local oDlg
	Local oFld
	Local oPnl1
	Local oPnl2
	Local oMsMGet
	Local oSplitter

	Local nI := 0
	Local nElem := 0
	Local nOpcao := 0
	Local nPAD_RECNO := 0
	
	Local aC := {} 
	Local aCOLS := {}
	Local aHeader := {}
	Local aCompl := {}
	Local aFolder := {}
	
	Local oGride
	
	Local cXE_RELACAO := ''
	Local cPAD_NUMERO := ''
	Local cMsg := 'Confirmar a aprovação das despesas? '+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
	              'Após a aprovação das despesas não será possível efetuar manutenção nos registros e nem imprimir o relatório.'

	If PAD->PAD_STATUS == '3'
		If PAD->PAD_COMPL == '0'
				nPAD_RECNO := PAD->(RecNo())
				cPAD_NUMERO := PAD->PAD_NUMERO
				While PAD->(.NOT. EOF()) .And. PAD->PAD_FILIAL==xFilial('PAD') .And. PAD->PAD_NUMERO==cPAD_NUMERO
					AAdd(aCompl,{PAD->(RecNo()),PAD->(PAD_NUMERO+'-'+PAD_COMPL),})
					PAD->(dbSkip())
				End
				PAD->(dbGoTo(nPAD_RECNO))
				aHeader := APBuildHeader('PAE')
				PAE->( dbSetOrder( 1 ) )
				If PAE->( dbSeek( xFilial( 'PAE' ) + PAD->PAD_NUMERO ) )
					While PAE->( .NOT. EOF() ) .And. PAE->PAE_FILIAL==xFilial('PAE') .And. PAE->PAE_NUMERO==PAD->PAD_NUMERO
						AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
						nElem := Len( aCOLS )
						For nI := 1 To Len( aHeader )
							If aHeader[ nI, 10 ] == 'V'
								cX3_RELACAO := Posicione('SX3',2,aHeader[nI,2],'X3_RELACAO')
								If .NOT. Empty(cX3_RELACAO)
									aCOLS[ nElem, nI ] := &(cX3_RELACAO)
								Endif
							Else
								aCOLS[ nElem, nI ] := PAE->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) )
							Endif
						Next nI
						aCOLS[ nElem, Len( aHeader ) + 1 ] := .F.
						PAE->( dbSkip() )
					End
				Endif
			aC := FWGetDialogSize( oMainWnd )
			DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE DS_MODALFRAME STATUS
				oDlg:lEscClose := .F.
				
				oSplitter := TSplitter():New( 1, 1, oDlg, 1000, 1000, 1 )
				oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
				
				oPnl1:= TPanel():New(1,1,'',oSplitter,,,,,,60,60)
				oPnl1:Align := CONTROL_ALIGN_ALLCLIENT
				
				oPnl2:= TPanel():New(1,1,'',oSplitter,,,,,,60,60)
				oPnl2:Align := CONTROL_ALIGN_ALLCLIENT
				
				PAD->(RegToMemory('PAD'))
				If Len(aCompl)>1
					For nI := 1 To Len( aCompl )
						If nI==1
							AAdd( aFolder, 'Solicitação nº '+aCompl[nI,2] )
						Else
							AAdd( aFolder, 'Complemento nº '+aCompl[nI,2] )
						Endif
					Next nI
					oFld := TFolder():New(0,0,aFolder,,oPnl1,,,,.T.,,260,184 )
					oFld:Align := CONTROL_ALIGN_ALLCLIENT
					oFld:bChange := {|| A280Change( @oFld, @aCompl ) }
					oMsMGet := MsMGet():New('PAD',PAD->(RecNo()),2,,,,,{0,0,400,600},,,,,,oFld:aDialogs[1],,,,,,,,,,,)
					oMsMGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
					aCompl[1,3] := oMsMGet
				Else
					oMsMGet := MsMGet():New('PAD',PAD->(RecNo()),2,,,,,{0,0,400,600},,,,,,oPnl1,,,,,,,,,,,)
					oMsMGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
				Endif
				
				oGride := MsNewGetDados():New(2,2,1000,1000,0,,,,,,Len(aCOLS),,,,oPnl2,aHeader,aCOLS)
				oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| Iif(MsgYesNo(cMsg,cCadastro),(oDlg:End(),nOpcao:=1),NIL) }, {|| oDlg:End() })	
			If nOpcao==1
				// Posicionar em todas as solicitações para mudar o status.
				cPAD_NUMERO := PAD->PAD_NUMERO
				While PAD->(.NOT. EOF()) .And. PAD->PAD_FILIAL==xFilial('PAD') .And. PAD->PAD_NUMERO==cPAD_NUMERO
					PAD->(RecLock('PAD',.F.))
					PAD->PAD_STATUS := '4'
					PAD->PAD_DTAPDE := MsDate()
					PAD->(MsUnLock())
					PAD->(dbSkip())
				End
			Endif
		Else
			MsgAlert('Por favor, posicionar na solicitação de despesa principal.',cCadastro)
		Endif
	Else
		MsgAlert('Solicitação de despesa indisponível.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A280CAp    | Autor | Robson Gonçalves     | Data | 11.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para cancelar a aprovação das despesas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A280CAp( cAlias, nRecNo, nOpc )
	Local aSay := {}
	Local aButton := {}

	Local cPAD_NUMERO := ''
	
	Local nOpcao := 0
	
	If PAD->PAD_STATUS == '4'
		If PAD->PAD_COMPL == '0'
			AAdd( aSay, 'Esta ação permite ao usuário cancelar a aprovação das despesas.')
			AAdd( aSay, 'Concluíndo este processo de cancelamento da aprovação, será permitido a ')
			AAdd( aSay, 'manutenção na relação das despesas.')
			AAdd( aSay, '' )
			AAdd( aSay, 'Clique em OK para prosseguir.')
			AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
			AAdd( aButton, { 22, .T., { || FechaBatch() } } )
			FormBatch( cCadastro, aSay, aButton )
			If nOpcao==1
				If MsgYesNo('Deseja realmente CANCELAR a Aprovação das Despesas digitadas?',cCadastro)
					cPAD_NUMERO := PAD->PAD_NUMERO
					While PAD->(.NOT. EOF()) .And. PAD->PAD_FILIAL==xFilial('PAD') .And. PAD->PAD_NUMERO==cPAD_NUMERO
						PAD->(RecLock('PAD',.F.))
						PAD->PAD_STATUS := '3'
						PAD->PAD_DTAPDE := Ctod('  /  /  ')
						PAD->(MsUnLock())
						PAD->(dbSkip())
					End
					If PAD->(RecNo())<>nRecNo
						PAD->(dbGoTo(nRecNo))
					Endif
					MsgInfo('Operação realizada com sucesso.',cCadastro)
				Endif
			Endif
		Else
			MsgAlert('Por favor, posicionar na solicitação de despesa principal.',cCadastro)
		Endif
	Else
		MsgAlert('Somente solicitação de despesa aprovadas e que poderá cancelar a aprovação.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A280VldDt  | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar a sequencia de data informada.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A280VldDt()
	Local nI := 0
	Local lRet := .T.
	Local nPAE_DATA := 0
	If Len(oGride:aCOLS) > 1   
		nPAE_DATA := GdFieldPos('PAE_DATA',oGride:aHeader)
		For nI := 1 To Len(oGride:aCOLS)
			If .NOT. oGride:aCOLS[nI,Len(aCOLS[nI])]
				If oGride:nAt <> nI
					If M->PAE_DATA < oGride:aCOLS[nI,nPAE_DATA]
						MsgInfo('Por favor, digite as despesas na ordem de data.',cCadastro)
						Exit
					Endif
				Endif
			Endif
		Next nI
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A280StrZero| Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina p/inserir zeros a esquerda no código do Tp.da despesa.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A280StrZero()
	Local nI := 0
	Local lOK := .T.
	Local cCodigo := ''
	cCodigo := RTrim(M->PAE_TPDESP)
	For nI := 1 To Len( cCodigo )
		If .NOT. SubStr(cCodigo,nI,1) $ '0123456789'
			lOK := .F.
		Endif
	Next nI
	If lOK
		M->PAE_TPDESP := StrZero(Val(M->PAE_TPDESP),Len(PAE->PAE_TPDESP))
	Endif
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A280KM     | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para calcular o KM rodado.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A280KM()
	Local lRet := .T.
	Local nPAE_KMINI := GdFieldPos('PAE_KMINI',oGride:aHeader)
	If M->PAE_KMFIM <= oGride:aCOLS[oGride:nAt,nPAE_KMINI]
		MsgAlert('O KM final deve ser maior que o KM inicial, por favor, corrija.',cCadastro)
		lRet:=.F.
	Endif
Return(lRet)

//-----------------------------------------------------------------------
// Rotina | A280Grava  | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para gravar as despesas digitadas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A280Grava( nRecNo )
	Local nI := 0
	Local nJ := 0
	Local nCOLS := 0
	
	Local cPAD_NUMERO := ''
	Local lFound := .T.
	
	Local nCPOS := Len(oGride:aHeader)
	Local nPAE_ITEM := GdFieldPos('PAE_ITEM',oGride:aHeader)

	// Garantir que o registro está deonde partiu na MBrowse.
	If PAD->(RecNo()) <> nRecNo
		PAD->(dbGoTo(nRecNo))
	Endif

	cPAD_NUMERO := PAD->PAD_NUMERO

	PAE->(dbSetOrder(1))
	For nI := 1 To Len( oGride:aCOLS )
		If PAE->(dbSeek(xFilial('PAE')+M->PAD_NUMERO+oGride:aCOLS[nI,nPAE_ITEM]))
			If .NOT. oGride:aCOLS[nI,nCPOS+1]
				PAE->(RecLock('PAE',.F.))
				For nJ := 1 To nCPOS
					If oGride:aHeader[nJ,10]<>'V'
						PAE->(FieldPut(FieldPos(oGride:aHeader[nJ,2]),oGride:aCOLs[nI,nJ]))
					Endif
				Next nJ
			Else
				PAE->(RecLock('PAE',.F.))
				PAE->(dbDelete())
			Endif
		Else
			If .NOT. oGride:aCOLS[nI,nCPOS+1]
				PAE->(RecLock('PAE',.T.))
				PAE->PAE_FILIAL := xFilial('PAE')
				PAE->PAE_NUMERO := M->PAD_NUMERO
				For nJ := 1 To nCPOS
					If oGride:aHeader[nJ,10]<>'V'
						PAE->(FieldPut(FieldPos(oGride:aHeader[nJ,2]),oGride:aCOLs[nI,nJ]))
					Endif
				Next nJ
			Endif
		Endif
		PAE->(MsUnLock())
	Next nI

	// Reposicionar para saber se o usuário apagou todos os itens da relação de despesa.
	// Se foi apagado é preciso mudar o status da solicitação de despesa.
	lFound := PAE->(dbSeek(xFilial('PAE')+M->PAD_NUMERO))
		
	// Posicionar em todas as solicitações para mudar o status e atualizar a data.
	While PAD->(.NOT. EOF()) .And. PAD->PAD_FILIAL==xFilial('PAD') .And. PAD->PAD_NUMERO==cPAD_NUMERO
		PAD->(RecLock('PAD',.F.))
		PAD->PAD_STATUS := Iif(lFound,'3','1')
		PAD->PAD_ULTDIG := Iif(lFound,MsDate(),Ctod(Space(8)))
		PAD->(MsUnLock())
		PAD->(dbSkip())
	End
	// Garantir que o registro está deonde partiu na MBrowse.
	If PAD->(RecNo()) <> nRecNo
		PAD->(dbGoTo(nRecNo))
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A280Conf   | Autor | Robson Gonçalves     | Data | 07.05.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para gerar planilha Excel para conferência de dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A280Conf()
	Local nOpc := 0
	Local nErro := 0
	
	Local aPar := {}
	Local aRet := {}
	Local aSay := {}
	Local aButton := {}
	
	Local cFile := ''
	Local cSDKPath := 'SDKPATH'
	
	Local lExiste := .F.
	
	Local bValid := {|| Iif(ApOleClient("MsExcel"),.T.,(MsgInfo("MsExcel não instalado",cCadastro),NIL)) }

	AAdd( aSay, 'Gerar planilha Ms-Excel com os dados da solicitação de despesa para conferência.')
	AAdd( aSay, '' )
	AAdd( aSay, 'Somente as solicitações com os status 3=Despesas digitadas e 4=Despesas aprovadas. ' )
	AAdd( aSay, 'serão impressos.' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir.')
	
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpc == 1
		AAdd( aPar, { 1, 'Nº Solicitação de'    , Space(Len(PAD->PAD_NUMERO)),'',''                    , 'PAD'   , '', 50, .F. } )
		AAdd( aPar, { 1, 'Nº Solicitação até'   , Space(Len(PAD->PAD_NUMERO)),'','(mv_par02>=mv_par01)', 'PAD'   , '', 50, .T. } )
		AAdd( aPar, { 1, 'Período de'           , Ctod(Space(8))             ,'',''                    , ''      , '', 50, .F. } )
		AAdd( aPar, { 1, 'Período até'          , Ctod(Space(8))             ,'','(mv_par04>=mv_par03)', ''      , '', 50, .T. } )
		AAdd( aPar, { 1, 'Solicitante de'       , Space(Len(PAD->PAD_SOLICI)),'',''                    , 'RD0'   , '', 50, .F. } )
		AAdd( aPar, { 1, 'Solicitante até'      , Space(Len(PAD->PAD_SOLICI)),'','(mv_par06>=mv_par05)', 'RD0'   , '', 50, .T. } )
		AAdd( aPar, { 5, "Mostrar a planilha no final do processamento?"                               , .F., 150, bValid, .F. } )
		
		If ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.T.,.T.)
			cFile := CriaTrab(NIL,.F.)+'.xml'
			lExiste := File( cFile )	
			If lExiste
				nErro := FErase( cFile )
			Endif
			If lExiste .And. nErro == -1
				MsgAlert('Problemas ao tentar gerar o arquivo Excel. Verifique se há planilha está aberta e tente novamente.',cCadastro)
			Else
				FWMsgRun(,{|| A280Gera( cFile, aRet ) },,'Aguarde, gerando dados em XML...')
			Endif
		Endif
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A280Gera   | Autor | Robson Gonçalves     | Data | 07.05.2014
//-----------------------------------------------------------------------
// Descr. | Rotina para gerar a planilha.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A280Gera( cFile, aRet )
	Local oFwMsEx
	Local oExcelApp
	Local cSQL := ''
	Local cTRB := ''
	Local cWorkSheet := ''
	Local cTable := ''	
	Local cPAD_NUMERO := ''
	Local cPAD_EMISSA := ''
	Local cPAD_CC := ''
	Local cPAD_NOMSOL := ''
	Local cPAD_MOT := ''
	Local cPAD_UF := ''
	Local cPAD_PERDE := ''
	Local cPAD_PERATE := ''
	Local cPAE_DESDES := ''
	Local cPAE_TPDESP := ''
	Local cPAD_ULTDIG := ''
	Local nPAD_VLHOSP := 0
	Local nPAD_VLPAAE := 0
	Local nPAD_VLAPAE := 0
	Local nPAD_VLALVE := 0
	Local nPAD_RECNO := 0
	Local cDirTmp := ''
	Local cDir := ''
	Local lFirst := .T.	
	
	nPAD_RECNO := PAD->( RecNo() )
	
	cSQL := "SELECT R_E_C_N_O_ AS PAD_RECNO "
	cSQL += "FROM   " + RetSqlName( "PAD" ) + " PAD "
	cSQL += "WHERE  PAD_FILIAL = " + ValToSql( xFilial( "PAD" ) ) + " "
	cSQL += "       AND PAD_NUMERO BETWEEN " + ValToSql( aRet[ 1 ] ) + " AND " + ValToSql( aRet[ 2 ] ) + " "
	cSQL += "       AND PAD_PERDE BETWEEN " + ValToSql( aRet[ 3 ] ) + " AND " + ValToSql( aRet[ 4 ] ) + " "
	cSQL += "       AND PAD_SOLICI BETWEEN " + ValToSql( aRet[ 5 ] ) + " AND " + ValToSql( aRet[ 6 ] ) + " "
	cSQL += "       AND PAD_STATUS IN ('1','3','4') "
	cSQL += "       AND PAD.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando os dados...')
	
	If (cTRB)->( BOF() .And. EOF() )
		MsgInfo('Não foi possível localizar dados com os parâmetros informados.',cCadastro)
		(cTRB)->( dbCloseArea() )
	Else   
	   oFwMsEx := FWMsExcel():New()
		While .NOT. (cTRB)->( EOF() )
			// posicionar.
			PAD->( dbGoTo( (cTRB)->PAD_RECNO ) )
			If PAD->PAD_NUMERO <> cPAD_NUMERO
				// guardar o número da despesa para não ser mais lido outro registro com mesmo número.
				cPAD_NUMERO := PAD->PAD_NUMERO
				// é a despesa principal?
				// não, posicione na despesa principal, ler ele e todos os registros de complementos.
				If PAD->PAD_COMPL <> '0'
					PAD->( dbSeek( xFilial( 'PAD' ) + cPAD_NUMERO ) )
				Endif

			   cWorkSheet := PAD->( PAD_NUMERO + '-' + PAD_COMPL )
			   cTable := 'CONTROLE_DESPESAS_NR_' + cWorkSheet
			   
			   oFwMsEx:AddWorkSheet( cWorkSheet )
			   oFwMsEx:AddTable( cWorkSheet, cTable )	

				oFwMsEx:AddColumn( cWorkSheet, cTable , "Centro de custo"       , 1,1)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Colaborador"           , 1,1)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Data da despesa"       , 2,1)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Tipo da despesa"       , 1,1)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Valor da despesa"      , 3,2,.T.)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Projeto"               , 1,1)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Motivo"                , 1,1)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "UF"                    , 1,1)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Período de"            , 2,1)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Período até"           , 2,1)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Valor hospedagem"      , 3,2)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Vlr.Passagem aérea"    , 3,2)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Vlr.Alter.Passag.Aérea", 3,2)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Vlr.Aluguel veículo"   , 3,2)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Dt.Última Dig.Despesas", 2,1)
            
				// sim, então ler ele e todos os complementos.
				While .NOT. PAD->( EOF() ) .And. PAD->( PAD_FILIAL + PAD_NUMERO ) == xFilial( 'PAD' ) + cPAD_NUMERO
					cPAD_EMISSA := Dtoc( PAD->PAD_EMISSA )
					cPAD_CC     := PAD->PAD_CC
					cPAD_NOMSOL := PAD->(PAD_SOLICI + '-' + RTrim( PAD_NOMSOL ))
					cPAD_MOT    += Iif(Empty(PAD->PAD_MOT),'',RTrim( PAD->PAD_MOT ) + ' | ') 
					cPAD_UF     := PAD->PAD_UF
					If Empty( cPAD_PERDE )
						cPAD_PERDE := Dtoc( PAD->PAD_PERDE ) 
					Endif
					cPAD_PERATE := Dtoc( PAD->PAD_PERATE )
					nPAD_VLHOSP += PAD->PAD_VLHOSP
					nPAD_VLPAAE += PAD->PAD_VLPAAE
					nPAD_VLAPAE += PAD->PAD_VLAPAE
					nPAD_VLALVE += PAD->PAD_VLALVE
					cPAD_ULTDIG := Dtoc( PAD->PAD_ULTDIG )
					PAD->( dbSkip() )
				End
				// ler relação de despesas
				PAE->( dbSetOrder( 1 ) )
				If PAE->( dbSeek( xFilial( 'PAD' ) + cPAD_NUMERO ) )
					While PAE->( .NOT. EOF() ) .And. PAE->PAE_FILIAL==xFilial( 'PAE' ) .And. PAE->PAE_NUMERO==cPAD_NUMERO
						If .NOT. lFirst
							nPAD_VLHOSP := 0
							nPAD_VLPAAE := 0
							nPAD_VLAPAE := 0
							nPAD_VLALVE := 0
						Endif
						If cPAE_TPDESP <> PAE->PAE_TPDESP
							cPAE_TPDESP := PAE->PAE_TPDESP
							PAF->( dbSetOrder( 1 ) )
							PAF->( MsSeek( xFilial( 'PAF' ) + cPAE_TPDESP ) )
							cPAD_DESDES := RTrim( PAF->PAF_DESCR )
						Endif
						
						oFwMsEx:AddRow( cWorkSheet, cTable, { cPAD_CC, cPAD_NOMSOL, Dtoc( PAE->PAE_DATA ), cPAE_TPDESP + '-' + cPAD_DESDES, PAE->PAE_TOTAL, ;
						PAE->PAE_CLVL, cPAD_MOT, cPAD_UF, cPAD_PERDE, cPAD_PERATE, nPAD_VLHOSP, nPAD_VLPAAE, nPAD_VLAPAE, nPAD_VLALVE, cPAD_ULTDIG} )
	               lFirst := .F.
						PAE->( dbSkip() )
					End
				Else
					oFwMsEx:AddRow( cWorkSheet, cTable, { cPAD_CC, cPAD_NOMSOL, cPAD_EMISSA, '_', 0, ;
					'_', cPAD_MOT, cPAD_UF, cPAD_PERDE, cPAD_PERATE, nPAD_VLHOSP, nPAD_VLPAAE, nPAD_VLAPAE, nPAD_VLALVE, cPAD_ULTDIG } )
				Endif
			Endif
         lFirst := .T.
			nPAD_VLHOSP := 0
			nPAD_VLPAAE := 0
			nPAD_VLAPAE := 0
			nPAD_VLALVE := 0
			cPAD_MOT    := ''
			(cTRB)->( dbSkip() )
		End
		(cTRB)->( dbCloseArea() )
		PAD->( dbGoTo( nPAD_RECNO ) )
		oFwMsEx:Activate()
		cDirTmp := GetTempPath()
		cDir := GetSrvProfString("Startpath","")
		LjMsgRun( "Gerando o arquivo, aguarde...","Conferência", {|| oFwMsEx:GetXMLFile( cFile ), Sleep( 500 ) } )
		If __CopyFile( cFile, cDirTmp + cFile )
			If aRet[ 7 ]
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( cDirTmp + cFile )
				oExcelApp:SetVisible(.T.)
				oExcelApp:Destroy()
			Else
				MsgInfo( "Arquivo " + cFile + " gerado com sucesso no diretório " + cDir )
			Endif
		Else
			MsgInfo( "Arquivo não copiado para temporário do usuário." )
		Endif		
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A280Exp    | Autor | Robson Gonçalves     | Data | 19.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para imprimir os dados da solicitação e despesas
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A280Exp()
	Local nOpc := 0
	Local nErro := 0
	
	Local aPar := {}
	Local aRet := {}
	Local aSay := {}
	Local aButton := {}
	
	Local cFile := ''
	
	Local lExiste := .F.
	
	AAdd( aSay, 'Esta rotina imprime todos os dados da solicitação de despesa conforme informado')
	AAdd( aSay, 'nos parâmetros a seguir com objetivo de auditar os dados.')
	AAdd( aSay, '' )
	AAdd( aSay, 'Somente as solicitações com os status 3=Despesas digitadas e 4=Despesas aprovadas. ' )
	AAdd( aSay, 'serão impressos.' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir.')
	
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpc == 1
		AAdd( aPar, { 1, 'Nº Solicitação de' , Space(Len(PAD->PAD_NUMERO)),'',''                    , 'PAD', '', 50, .F. } )
		AAdd( aPar, { 1, 'Nº Solicitação até', Space(Len(PAD->PAD_NUMERO)),'','(mv_par02>=mv_par01)', 'PAD', '', 50, .T. } )
		AAdd( aPar, { 1, 'Período de'        , Ctod(Space(8))             ,'',''                    , ''   , '', 50, .F. } )
		AAdd( aPar, { 1, 'Período até'       , Ctod(Space(8))             ,'','(mv_par04>=mv_par03)', ''   , '', 50, .T. } )
		
		If ParamBox( aPar, 'Parâmetros',@aRet,,,,,,,,.T.,.T.)
			cFile := CriaTrab(NIL,.F.)+'.csv'
			lExiste := File( cFile )
			If lExiste
				nErro := FErase( cFile )
			Endif
			If lExiste .And. nErro == -1
				MsgAlert('Problemas ao tentar gerar o arquivo Excel. Verifique se há planilha está aberta e tente novamente.',cCadastro)
			Else
				FWMsgRun(,{|| A280Prc( cFile, aRet ) },,'Aguarde, gerando dados em CSV...')
			Endif
		Endif
	Endif
Return
//-----------------------------------------------------------------------
// Rotina | A280Prc    | Autor | Robson Gonçalves     | Data | 19.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para processar os dados a ser impresso.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A280Prc( cFile, aRet )
	Local cSQL := ''
	Local cTRB := ''	
	Local cPAD_NUMERO := ''
	Local nPAD_RECNO := 0
	
	Private nHdl := 0
	Private lUnLoad := .F.
	Private aPAD := {}
	Private aPAE := {}
	Private aDADOS_PAD := {}
	Private aDADOS_PAE := {}

	LoadCpos()
	nHdl := FCreate(cFile)
	nPAD_RECNO := PAD->( RecNo() )
	
	cSQL := "SELECT R_E_C_N_O_ AS PAD_RECNO "
	cSQL += "FROM   " + RetSqlName( "PAD" ) + " PAD "
	cSQL += "WHERE  PAD_FILIAL = " + ValToSql( xFilial( "PAD" ) ) + " "
	cSQL += "       AND PAD_NUMERO BETWEEN " + ValToSql( aRet[ 1 ] ) + " AND " + ValToSql( aRet[ 2 ] ) + " "
	cSQL += "       AND PAD_PERDE BETWEEN " + ValToSql( aRet[ 3 ] ) + " AND " + ValToSql( aRet[ 4 ] ) + " "
	cSQL += "       AND PAD_STATUS IN ('3','4') "
	cSQL += "       AND PAD.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando os dados...')
	
	If (cTRB)->( BOF() .And. EOF() )
		MsgInfo('Não foi possível localizar dados com os parâmetros informados.',cCadastro)
	Else
		While .NOT. (cTRB)->( EOF() )
			// posicionar.
			PAD->( dbGoTo( (cTRB)->PAD_RECNO ) )
			If PAD->PAD_NUMERO <> cPAD_NUMERO
				// guardar o número da despesa para não ser mais lido outro registro com mesmo número.
				cPAD_NUMERO := PAD->PAD_NUMERO
				// é a despesa principal?
				// não, posicione na despesa principal, ler ele e todos os registros de complementos.
				If PAD->PAD_COMPL <> '0'
					PAD->( dbSeek( xFilial( 'PAD' ) + cPAD_NUMERO ) )
				Endif
				// sim, então ler ele e todos os complementos.
				While .NOT. PAD->( EOF() ) .And. PAD->( PAD_FILIAL + PAD_NUMERO ) == xFilial( 'PAD' ) + cPAD_NUMERO
					LoadPAD()
					PAD->( dbSkip() )
				End
				// ler relação de despesas
				LoadPAE(cPAD_NUMERO)
				// descarregar
				UnLoad()
			Endif
			(cTRB)->( dbSkip() )
		End
	Endif
	(cTRB)->( dbCloseArea() )
	PAD->( dbGoTo( nPAD_RECNO ) )
	
	If !lUnLoad
		For nI := 1 To Len( aDADOS_PAD )
			FWrite( nHdl, aDADOS_PAD[ nI, 1 ] + CRLF )
		Next nI
	Endif
	
	FClose( nHdl )
	
	If __CopyFile( cFile, GetTempPath() + cFile )
		ShellExecute('open', cFile , '', GetTempPath(), 1 )
	Else
		MsgAlert('Não foi possível copiar o arquivo CSV para sua máquina.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | LoadCpos   | Autor | Robson Gonçalves     | Data | 21.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para carregar os campos conforme o dicionário SX3.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function LoadCpos()
	SX3->( dbSetOrder( 1 ) )
	SX3->( dbSeek( 'PAD' ) )
	While SX3->( .NOT. EOF() ) .And. SX3->X3_ARQUIVO=='PAD'
		If .NOT. ('FILIAL' $ RTrim( SX3->X3_CAMPO ))
			SX3->( AAdd( aPAD, { RTrim( X3_CAMPO ), X3_TITULO, X3_CONTEXT, X3_RELACAO } ) )
		Endif
		SX3->( dbSkip() )
	End
	SX3->( dbSeek( 'PAE' ) )
	While SX3->( .NOT. EOF() ) .And. SX3->X3_ARQUIVO=='PAE'
		If .NOT. ('FILIAL' $ RTrim( SX3->X3_CAMPO ))
			SX3->( AAdd( aPAE, { RTrim( X3_CAMPO ), X3_TITULO, X3_CONTEXT, X3_RELACAO } ) )
		Endif
		SX3->( dbSkip() )
	End
Return

//-----------------------------------------------------------------------
// Rotina | LoadPAD    | Autor | Robson Gonçalves     | Data | 19.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para carregar os campos da solicitação.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function LoadPAD()
	Local nI := 0
	Local nElem := 0
	AAdd( aDADOS_PAD, Array( Len( aPAD ) ) )
	nElem := Len( aDADOS_PAD )
	For nI := 1 To Len( aPAD )
		If aPAD[ nI, 3 ] <> 'V'
			aDADOS_PAD[ nElem, nI ] := PAD->( FieldGet( FieldPos( aPAD[ nI, 1 ] ) ) )
		Else
			aDADOS_PAD[ nElem, nI ] := &( aPAD[ nI, 4 ] )
		Endif
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | LoadPAE    | Autor | Robson Gonçalves     | Data | 19.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para carregar os campos das despesas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function LoadPAE(cPAD_NUMERO)
	Local nI := 0
	Local nElem := 0
	PAE->( dbSetOrder( 1 ) )
	PAE->( dbSeek( xFilial( 'PAD' ) + cPAD_NUMERO ) )
	While PAE->( .NOT. EOF() ) .And. PAE->PAE_FILIAL==xFilial( 'PAE' ) .And. PAE->PAE_NUMERO==cPAD_NUMERO
		AAdd( aDADOS_PAE, Array( Len( aPAE ) ) )
		nElem := Len( aDADOS_PAE )
		For nI := 1 To Len( aPAE )
			If aPAE[ nI, 3 ] <> 'V'
				aDADOS_PAE[ nElem, nI ] := PAE->( FieldGet( FieldPos( aPAE[ nI, 1 ] ) ) )
			Else
				aDADOS_PAE[ nElem, nI ] := &( aPAE[ nI, 4 ] )
			Endif
		Next nI
		PAE->( dbSkip() )
	End
Return

//-----------------------------------------------------------------------
// Rotina | UnLoad     | Autor | Robson Gonçalves     | Data | 19.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para descarregar os dados dos vetores no arquivo CSV.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function UnLoad()
	Local nI := 0
	Local nJ := 0
	Local cDado := ''
	
	lUnLoad := .T.
	
	For nI := 1 To Len( aPAD )
		cDado += aPAD[ nI, 2 ] + ';'
	Next nI
	FWrite( nHdl, cDado + CRLF )
	
	cDado := ''
	For nI := 1 To Len( aDADOS_PAD )
		For nJ := 1 To Len( aDADOS_PAD[ nI ] )
			If ValType(aDADOS_PAD[ nI, nJ ])=='N'
				cDado += TransForm( aDADOS_PAD[ nI, nJ ], '@E 999,999,999.99' ) + ';'
			Elseif ValType(aDADOS_PAD[ nI, nJ ])=='D'
				cDado += Dtoc( aDADOS_PAD[ nI, nJ ] ) + ';'
			Else
				cDado += aDADOS_PAD[ nI, nJ ] + ';'
			Endif
		Next nJ
		FWrite( nHdl, cDado + CRLF )
		cDado := ''
	Next nI
	
	FWrite( nHdl, ' ' + CRLF )
	
	cDado := ''
	For nI := 1 To Len( aPAE )
		cDado += aPAE[ nI, 2 ] + ';'
	Next nI
	FWrite( nHdl, cDado + CRLF )
	
	cDado := ''
	For nI := 1 To Len( aDADOS_PAE )
		For nJ := 1 To Len( aDados_PAE[ nI ] )
			If ValType(aDADOS_PAE[ nI, nJ ])=='N'
				cDado += TransForm( aDADOS_PAE[ nI, nJ ], '@E 999,999,999.99' ) + ';'
			Elseif ValType(aDADOS_PAE[ nI, nJ ])=='D'
				cDado += Dtoc( aDADOS_PAE[ nI, nJ ] ) + ';'
			Else
				cDado += aDADOS_PAE[ nI, nJ ] + ';'
			Endif
		Next nJ
		FWrite( nHdl, cDado + CRLF )
		cDado := ''
	Next nI
	
	aDADOS_PAD := {}
	aDADOS_PAE := {}
Return

//-----------------------------------------------------------------------
// Rotina | A280Rel    | Autor | Robson Gonçalves     | Data | 22.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento para impressão do relatório.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A280Rel()
	Local nPAD_RECNO := 0
	Local cPAD_NUMERO := ''
	
	Private aPAD := {}
	Private aPAE := {}
	
	Private aDADOS_PAD := {}
	Private aDADOS_PAE := {}

	If PAD->PAD_COMPL == '0'
		If PAD->PAD_STATUS $ '3|4'
			nPAD_RECNO := PAD->( RecNo() )
			cPAD_NUMERO := PAD->PAD_NUMERO
			FwMsgRun(,{|| LoadCpos()},,'Aguarde, processando...')
			While PAD->( .NOT. EOF() ) .And. PAD->PAD_FILIAL==xFilial('PAD') .And. PAD->PAD_NUMERO==cPAD_NUMERO
				FwMsgRun(,{|| LoadPAD()},,'Aguarde, processando...')
				PAD->( dbSkip() )
			End
			FwMsgRun(,{|| LoadPAE(cPAD_NUMERO)},,'Aguarde, processando...')
			A280Imp()
		Else
			MsgAlert('Solicitação de despesa Nº '+PAD->PAD_NUMERO+'-'+PAD->PAD_COMPL+' indisponível para impressão, é preciso digitar as despesas.',cCadastro)
		Endif
		PAD->( dbGoTo( nPAD_RECNO ) )
	Else
		MsgAlert('Por favor, posicionar na solicitação de despesa principal.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A280Imp    | Autor | Robson Gonçalves     | Data | 22.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de impressão do relatório.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A280Imp()
	Local nL := 0
	Local nPapelA4 := 9
	
	Local nQtdePag := 0
	Local nQtdeItens := 33
	
	Local aSRA_CONTA := {}
	
	Private oPrint
	Private oArial_08n := TFont():New('Arial'      ,NIL, 8,NIL,.F.,NIL,NIL,NIL,NIL,.F.,.F.)
	Private oArial_08b := TFont():New('Arial'      ,NIL, 8,NIL,.T.,NIL,NIL,NIL,NIL,.F.,.F.)
	Private oArial_09n := TFont():New('Arial'      ,NIL, 9,NIL,.F.,NIL,NIL,NIL,NIL,.F.,.F.)
	Private oArial_12n := TFont():New('Arial'      ,NIL,12,NIL,.F.,NIL,NIL,NIL,NIL,.F.,.F.)
	Private oCouri_10b := TFont():New('Courier New',NIL,10,NIL,.T.,NIL,NIL,NIL,NIL,.F.,.F.)
	Private oCouri_12b := TFont():New('Courier New',NIL,12,NIL,.T.,NIL,NIL,NIL,NIL,.F.,.F.)
	Private oArial_18b := TFont():New('Arial'      ,NIL,18,NIL,.T.,NIL,NIL,NIL,NIL,.F.,.F.)
	
	Private aPAE_MOEDA := {}
	Private aDADOS_PART := {}
	
	Private cSALDO := ''
	
	Private nSALDO := 0
	Private nTOTAL_ADIA := 0
	Private nTOTAL_DESP := 0
	Private nTOTAL_DIGI := 0
	
	Private nPAD_NUMERO := 0
	Private nPAD_COMPL  := 0
	Private nPAD_SOLICI := 0
	Private nPAD_PERDE  := 0
	Private nPAD_PERATE := 0
	Private nPAD_VLRADI := 0
	Private nPAD_BANCO  := 0
	Private nPAD_AGENCI := 0
	Private nPAD_DVAGEN := 0
	Private nPAD_NUMCTA := 0
	Private nPAD_DVCTA  := 0

	Private nPAE_ITEM   := 0
	Private nPAE_DATA   := 0
	Private nPAE_TPDESP := 0
	Private nPAE_DESDES := 0
	Private nPAE_DESCRI := 0
	Private nPAE_CLVL   := 0
	Private nPAE_OUTPRJ := 0
	Private nPAE_CC     := 0
	Private nPAE_QTDE   := 0
	Private nPAE_UNIT   := 0
	Private nPAE_TOTAL  := 0
	Private nPAE_MOEDA  := 0
	
	nPAD_NUMERO := AScan( aPAD, {|e| e[1]=='PAD_NUMERO' } )
	nPAD_COMPL  := AScan( aPAD, {|e| e[1]=='PAD_COMPL' } )
	nPAD_SOLICI := AScan( aPAD, {|e| e[1]=='PAD_SOLICI' } )
	nPAD_PERDE  := AScan( aPAD, {|e| e[1]=='PAD_PERDE' } )
	nPAD_PERATE := AScan( aPAD, {|e| e[1]=='PAD_PERATE' } )
	nPAD_VLRADI := AScan( aPAD, {|e| e[1]=='PAD_VLRADI' } )
	nPAD_BANCO  := AScan( aPAD, {|e| e[1]=='PAD_BANCO' } )
	nPAD_AGENCI := AScan( aPAD, {|e| e[1]=='PAD_AGENCI' } )
	nPAD_DVAGEN := AScan( aPAD, {|e| e[1]=='PAD_DVAGEN' } )
	nPAD_NUMCTA := AScan( aPAD, {|e| e[1]=='PAD_NUMCTA' } )
	nPAD_DVCTA  := AScan( aPAD, {|e| e[1]=='PAD_DVCTA' } )

	nPAE_ITEM   := AScan( aPAE, {|e| e[1]=='PAE_ITEM' } )
	nPAE_DATA   := AScan( aPAE, {|e| e[1]=='PAE_DATA' } )
	nPAE_TPDESP := AScan( aPAE, {|e| e[1]=='PAE_TPDESP' } )
	nPAE_DESDES := AScan( aPAE, {|e| e[1]=='PAE_DESDES' } )
	nPAE_DESCRI := AScan( aPAE, {|e| e[1]=='PAE_DESCRI' } )
	nPAE_CLVL   := AScan( aPAE, {|e| e[1]=='PAE_CLVL' } )
	nPAE_OUTPRJ := AScan( aPAE, {|e| e[1]=='PAE_OUTPRJ' } )
	nPAE_CC     := AScan( aPAE, {|e| e[1]=='PAE_CC' } )
	nPAE_QTDE   := AScan( aPAE, {|e| e[1]=='PAE_QTDE' } )
	nPAE_UNIT   := AScan( aPAE, {|e| e[1]=='PAE_UNIT' } )
	nPAE_TOTAL	:= AScan( aPAE, {|e| e[1]=='PAE_TOTAL' } )
	nPAE_MOEDA	:= AScan( aPAE, {|e| e[1]=='PAE_MOEDA' } )
	
	//Quanto foi adiantado?
	AEval( aDADOS_PAD, {|e| nTOTAL_ADIA += e[nPAD_VLRADI] } )
	
	aPAE_MOEDA := StrToKarr( Posicione( 'SX3', 2, 'PAE_MOEDA', 'X3CBox()' ), ';' )
	
	For nL := 1 To Len( aDADOS_PAE )
		//Quanto foi declarado?
		nTOTAL_DESP += aDADOS_PAE[nL,nPAE_TOTAL]
		//Atualizar o texto do nome da moeda conforme o seu código.
		aDADOS_PAE[nL,nPAE_MOEDA] := aPAE_MOEDA[Val(aDADOS_PAE[nL,nPAE_MOEDA])]
	Next nL
		
	//Qual é o saldo, receber ou pagar?
	nSALDO := nTOTAL_ADIA - nTOTAL_DESP
	If nSALDO < 0
		cSALDO := 'Receber'
		nSALDO := nSALDO * (-1)
	Else
		cSALDO := 'Pagar'
	Endif
	
	aDADOS_PART := Array( 8 )

	//Tem os dados da conta corrente na solicitação de desepsas?
	//Se não tem capturar do RD0.
	//Se não houver dados no RD0 capturar do SRA
	//Se não houver dados no SRA, informar que não há.
	If Empty( aDADOS_PAD[ 1, nPAD_BANCO ] ) .And. Empty( aDADOS_PAD[ 1, nPAD_AGENCI ] ) .And. Empty( aDADOS_PAD[ 1, nPAD_NUMCTA ] )
		aDADOS_PART := GetAdvFVal('RD0',{'RD0_NOME','RD0_CIC','RD0_BANCO','RD0_AGENCI','RD0_DVAGEN','RD0_NUMCTA','RD0_DVCTA','RD0_MAT'},xFilial('RD0')+aDADOS_PAD[1,nPAD_SOLICI],1)
		If .NOT. Empty( aDADOS_PART[ 8 ]  )
			aDADOS_PART[ 1 ] := Posicione( 'RD0', 1, xFilial( 'RD0' ) + aDADOS_PAD[ 1, nPAD_SOLICI ], 'RD0_NOME' )
			aDADOS_PART[ 2 ] := 'SEM CPF/CNPJ'
			aDADOS_PART[ 3 ] := 'SEM BANCO'
			aDADOS_PART[ 4 ] := 'SEM AGÊNCIA'
			aDADOS_PART[ 5 ] := ''
			aDADOS_PART[ 6 ] := 'SEM CONTA CORRENTE'
			aDADOS_PART[ 7 ] := ''
			aDADOS_PART[ 8 ] := ''
		Else
			If Empty( aDADOS_PART[ 3 ] ) .And. Empty( aDADOS_PART[ 4 ] ) .And. Empty( aDADOS_PART[ 6 ] )
				aSRA_CONTA := GetAdvFVal( 'SRA', { 'RA_CIC', 'RA_BCDEPSA', 'RA_CTDEPSA' }, xFilial( 'SRA' ) + aDADOS_PART[ 8 ], 1)
				aDADOS_PART[ 1 ] := Posicione( 'RD0', 1, xFilial( 'RD0' ) + aDADOS_PAD[ 1, nPAD_SOLICI ], 'RD0_NOME' )
				aDADOS_PART[ 2 ] := aSRA_CONTA[ 1 ] 
				aDADOS_PART[ 3 ] := Left( aSRA_CONTA[ 2 ], 3 )
				aDADOS_PART[ 4 ] := RTrim( SubStr( aSRA_CONTA[ 2 ], 4 ) )
				aDADOS_PART[ 5 ] := ''
				aDADOS_PART[ 6 ] := RTrim( aSRA_CONTA[ 3 ] )
				aDADOS_PART[ 7 ] := ''
				aDADOS_PART[ 8 ] := ''
			Endif
		Endif		
	Else
		aDADOS_PART[ 1 ] := Posicione( 'RD0', 1, xFilial( 'RD0' ) + aDADOS_PAD[ 1, nPAD_SOLICI ], 'RD0_NOME' )
		aDADOS_PART[ 2 ] := Posicione( 'RD0', 1, xFilial( 'RD0' ) + aDADOS_PAD[ 1, nPAD_SOLICI ], 'RD0_CIC' )
		aDADOS_PART[ 3 ] := aDADOS_PAD[ 1, nPAD_BANCO ]
		aDADOS_PART[ 4 ] := aDADOS_PAD[ 1, nPAD_AGENCI ]
		aDADOS_PART[ 5 ] := aDADOS_PAD[ 1, nPAD_DVAGEN ]
		aDADOS_PART[ 6 ] := aDADOS_PAD[ 1, nPAD_NUMCTA ]
		aDADOS_PART[ 7 ] := aDADOS_PAD[ 1, nPAD_DVCTA ]		
		aDADOS_PART[ 8 ] := ''
	Endif
   
	oPrint := TMSPrinter():New( 'RELATÓRIO DE PRESTAÇÃO DE CONTAS' )
	
	If .NOT. oPrint:IsPrinterActive()
		oPrint:Setup()
	Endif
	
	oPrint:SetPaperSize( nPapelA4 )
	oPrint:SetLandsCape()
	
	// Calcular o número de páginas.
	If (Len(aDADOS_PAE)/nQtdeItens)-Int(Len(aDADOS_PAE)/nQtdeItens)>0
		nQtdePag := Int(Len(aDADOS_PAE)/nQtdeItens)+1
	Else
		nQtdePag := Int(Len(aDADOS_PAE)/nQtdeItens)
	Endif
	
	FwMsgRun(,{|| ProcImp( nQtdePag, nQtdeItens )},,'Imprimindo...')
	
	oPrint:Preview()
	
	FreeObj( oPrint )
Return

//-----------------------------------------------------------------------
// Rotina | ProcImp    | Autor | Robson Gonçalves     | Data | 22.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de controle de impressão em vários formulários.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function ProcImp( nQtdePag, nQtdeItens)
	Local nI := 0
	
	Private nPreto  := 0
	Private nCinza  := 0
	Private nBranco := 0

	nPreto  := RGB(0,0,0)
	nCinza  := RGB(217,217,217)
	nBranco := RGB(255,255,255) 
	
	For nI := 1 To nQtdePag
		oPrint:StartPage()
		ImpCabec( nI, nQtdePag )
		ImpItem( nI, nQtdeItens, nQtdePag )
		ImpSolicit()
		oPrint:EndPage()
	Next nI
Return

//-----------------------------------------------------------------------
// Rotina | ImpCabec   | Autor | Robson Gonçalves     | Data | 22.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de impressão do cabeçalho do relatório.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function ImpCabec( nI, nQtdePag )
	Local nTam := 0	
	Local oPintarPreto
	
	oPintarPreto := TBrush():New(,nPreto)
	
	nTam := Len(LTrim(Str(nQtdePag)))
	
	oPrint:Box(0050,0050,0175,3350)
		oPrint:SayBitMap(0052,0052,'lgrl01.bmp',0250,0120)
		oPrint:Say(0075,0670,'RELATÓRIO DE PRESTAÇÃO DE CONTAS',oArial_18b)
		oPrint:Say(0057,2263,'CÓDIGO: '+'FRM-FNN.0001/0001',oArial_09n)
		oPrint:FillRect({0053,2928,0090,3348},oPintarPreto)
		oPrint:Say(0053,2930,'SOLICITAÇÃO: '+aDADOS_PAD[ 1, nPAD_NUMERO ],oCouri_10b,,nBranco)
		oPrint:Say(0096,2263,'REVISÃO: '+'9',oArial_09n)
		oPrint:Say(0096,2930,'PÁGINA: '+StrZero(nI,nTam,0)+'/'+LTrim(Str(nQtdePag,nTam,0)),oArial_09n)
		oPrint:Say(0135,2263,'EMISSÃO: '+Dtoc(dDataBase)+' - HORA: '+Time(),oArial_09n)
		oPrint:Say(0135,2930,'PROGRAMA: CSTA280-v3',oArial_09n)	
Return

//-----------------------------------------------------------------------
// Rotina | ImpItem    | Autor | Robson Gonçalves     | Data | 22.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de impressão dos itens do relatório.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function ImpItem(  nI, nQtdeItens, nQtdePag )
	Local oPintaCinza
	Local oPintaPreto
	
	Local nJ := 0
	Local nEnd := 0
	Local nStart := 0
	Local nLinha := 250
	
	Local lContinua := .F.
	
	//Achar os valores para o controle do laço FOR/NEXT.
	If nI == 1
		nStart := 1
		If Len( aDADOS_PAE ) > nQtdeItens
			nEnd := nQtdeItens
			lContinua := .T.
		Else
			nEnd := Len( aDADOS_PAE )
		Endif
	Else	
		nStart := (nQtdeItens*(nI-1))+1
		If Len( aDADOS_PAE ) > nQtdeItens*nI
			nEnd := nQtdeItens*nI
			lContinua := .T.
		Else
			nEnd := Len( aDADOS_PAE )
		Endif
	Endif
	
	oPintaCinza := TBrush():New(,nCinza)
	oPintaPreto := TBrush():New(,nPreto)
	
	//Box dos itens.
	oPrint:Box(0212,0050,1600,3350)
		//Linhas horizontais dentro do box dos itens.
		oPrint:Line(0249,0050,0249,3350)
		oPrint:FillRect({0214,0051,0247,3350},oPintaPreto)
		//Preenchimento das linas para ficar listrado (com listras, tipo formulário contínuo.
		For nJ := 1 To 32
			If Mod(nJ,2)==0
				oPrint:FillRect({nLinha,0052,nLinha+37,3348},oPintaCinza)
			Endif
			nLinha+=37
		Next nJ
		
		//Linhas veticais para dividir a informação de cada item.
		oPrint:Line(0213,0110,1474,0110) // 1-Data
		oPrint:Line(0213,0237,1474,0237) // 2-Código
		oPrint:Line(0213,0375,1474,0375) // 3-Tipo de despesa
		oPrint:Line(0213,1195,1474,1195) // 4-Descrição de despesa
		oPrint:Line(0213,2035,1474,2035) // 5-Projeto
		oPrint:Line(0213,2233,1474,2233) // 6-Desc.Outros Proj
		oPrint:Line(0213,2795,1474,2790) // 7-Centro de custo
		oPrint:Line(0213,2953,1474,2953) // 8-Moeda
		oPrint:Line(0213,3080,1474,3080) // 9-Total
		oPrint:Line(1475,2738,1599,2738) // Total despesa - Total adiantado - Saldo
		
		//Título do cabeçalho da relação de despesa.
		oPrint:Say(0214,0055,'It'                          ,oArial_08b,,nBranco)
		oPrint:Say(0214,0115,'Data'                        ,oArial_08b,,nBranco)
		oPrint:Say(0214,0242,'Código'                      ,oArial_08b,,nBranco)
		oPrint:Say(0214,0380,'Tipo de despesa'             ,oArial_08b,,nBranco)
		oPrint:Say(0214,1200,'Descrição da despesa'        ,oArial_08b,,nBranco)
		oPrint:Say(0214,2040,'Projeto'                     ,oArial_08b,,nBranco)
		oPrint:Say(0214,2238,'Descrição de outros projetos',oArial_08b,,nBranco)
		oPrint:Say(0214,2800,'C.Custo'                     ,oArial_08b,,nBranco)
		oPrint:Say(0214,2958,'Moeda'                       ,oArial_08b,,nBranco)
		oPrint:Say(0214,3278,'Total'                       ,oArial_08b,,nBranco)
		
	nLinha := 252
	For nJ := nStart To nEnd
		oPrint:Say(nLinha, 0055, aDADOS_PAE[ nJ, nPAE_ITEM ]             ,oArial_08n)
		oPrint:Say(nLinha, 0115, Dtoc(aDADOS_PAE[ nJ, nPAE_DATA ])       ,oArial_08n)
		oPrint:Say(nLinha, 0242, aDADOS_PAE[ nJ, nPAE_TPDESP]            ,oArial_08n)
		oPrint:Say(nLinha, 0380, Left( aDADOS_PAE[ nJ, nPAE_DESDES], 30 ),oArial_08n)
		oPrint:Say(nLinha, 1200, aDADOS_PAE[ nJ, nPAE_DESCRI]            ,oArial_08n)
		oPrint:Say(nLinha, 2040, aDADOS_PAE[ nJ, nPAE_CLVL]              ,oArial_08n)
		oPrint:Say(nLinha, 2238, aDADOS_PAE[ nJ, nPAE_OUTPRJ]            ,oArial_08n)
		oPrint:Say(nLinha, 2800, aDADOS_PAE[ nJ, nPAE_CC]                ,oArial_08n)
		oPrint:Say(nLinha, 2958, SubStr(aDADOS_PAE[ nJ, nPAE_MOEDA],3)   ,oArial_08n)
		oPrint:Say(nLinha, 3335, TransForm(aDADOS_PAE[ nJ, nPAE_TOTAL],'@E 999,999,999.99') ,oArial_08n,,,,1)
		
		nTOTAL_DIGI += aDADOS_PAE[ nJ, nPAE_TOTAL]
		nLinha+=37
	Next nJ

	oPrint:Line(1475,0050,1475,3350)
		//Dados do colaborador.
		oPrint:Say(1490,055,'Colaborador: '+aDADOS_PAD[1,nPAD_SOLICI]+' - '+RTrim(aDADOS_PART[1])+' - CPF: '+TransForm(aDADOS_PART[2],'@R 999.999.999-99'),oArial_12n)
		
		If Empty(aDADOS_PART[3]) .And. Empty(aDADOS_PART[4]) .And. Empty(aDADOS_PART[6])
			oPrint:Say(1540,055,'<<< COLABORADOR SEM DADOS BANCÁRIOS >>>',oArial_12n)
		Else
			oPrint:Say(1540,055,'Banco - '+aDADOS_PART[3]+;
			                    ' - Agência: '+RTrim(aDADOS_PART[4])+Iif(Empty(aDADOS_PART[5]),'','-'+aDADOS_PART[5])+;
			                    ' - Conta Corrente: '+RTrim(aDADOS_PART[6])+Iif(Empty(aDADOS_PART[7]),'','-'+aDADOS_PART[7]),oArial_12n)
		Endif
	
	If lContinua
		//Fazer um X gigante para não apresentar os valores de (total despesa/total adiantado/saldo)
		oPrint:Line(1475,2738,1600,3350)
		oPrint:Line(1600,2738,1475,3350)
		oPrint:Say(1900,2600,'Continua na próxima página...',oCouri_12b)
	Else
		//Dados dos totais.
		oPrint:Say(1482,2745,'Total despesa: ',oArial_09n)
		oPrint:Say(1482,3335,TransForm(nTOTAL_DIGI,'@E 999,999,999,999.99'),oArial_09n,,,,1)
		
		oPrint:Say(1521,2745,'Total adiantado: ',oArial_09n)
		oPrint:Say(1521,3335,TransForm(nTOTAL_ADIA,'@E 999,999,999,999.99'),oArial_09n,,,,1)
		
		oPrint:Say(1560,2745,'Saldo - '+cSALDO+': ',oArial_09n)		
		oPrint:Say(1560,3335,TransForm(nSALDO,'@E 999,999,999,999.99'),oArial_09n,,,,1)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | ImpSolicit | Autor | Robson Gonçalves     | Data | 22.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de impressão do rodapé do relatório.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function ImpSolicit()
	Local nJ := 0
	Local nDias := 0
	Local nTotal := 0
	Local nLinha := 0
	
	//Box com os dados da solicitação e complemento.
	oPrint:Box(1637,0050,1850,3350)
		//Linhas horizontais
		oPrint:Line(1800,0050,1800,3350)
		
	nLinha := 1638
	For nJ := 1 To Len( aDADOS_PAD )
		oPrint:Say(nLinha, 0055, 'Nº ' + Iif(nJ==1,'Solicitação','Complemento')+':',oArial_09n)
		oPrint:Say(nLinha, 0350, aDADOS_PAD[ nJ, nPAD_NUMERO ]+'-'+aDADOS_PAD[ nJ, nPAD_COMPL ] ,oArial_09n)
		oPrint:Say(nLinha, 1450, 'Período de: '+Dtoc(aDADOS_PAD[ nJ, nPAD_PERDE ])+' até: '+Dtoc(aDADOS_PAD[ nJ, nPAD_PERATE ]),oArial_09n)
		oPrint:Say(nLinha, 2745, 'Valor: ',oArial_09n)
		oPrint:Say(nLinha, 3335, TransForm(aDADOS_PAD[ nJ, nPAD_VLRADI ],'@E 999,999,999.99'),oArial_09n,,,,1)
		
		nDias += ((aDADOS_PAD[ nJ, nPAD_PERATE ]-aDADOS_PAD[ nJ, nPAD_PERDE ])+1)
		nTotal += aDADOS_PAD[ nJ, nPAD_VLRADI ]
		nLinha+=37
	Next nJ
	
	oPrint:Say(1805,0055,'Totais: 1 solicitação e '+LTrim(Str(Len(aDADOS_PAD)-1))+' complemento(s)' ,oArial_09n)
	oPrint:Say(1805,1550,'Total do período: '+LTrim(Str(nDias,3,0))+' dias ',oArial_09n)
	oPrint:Say(1805,2745,'Total adiantado: ',oArial_09n)
	oPrint:Say(1805,3335,TransForm(nTotal,'@E 999,999,999,999.99'),oArial_09n,,,,1)

	//Linhas horizontais de assinaturas
	oPrint:Line(2065,0050,2065,1225)
		oPrint:Say(2070,0050,'Colaborador - Assinatura e data',oArial_09n)	
		
	oPrint:Line(2280,0050,2280,1225)
		oPrint:Say(2285,0050,'Conferente do financeiro - Assinatura e data',oArial_09n)	
	
	oPrint:Line(2065,2263,2065,3350)
		oPrint:Say(2070,2263,'Aprovador  - Assinatura e data',oArial_09n)	
		
	oPrint:Line(2280,2263,2280,3350)
		oPrint:Say(2285,2263,'Aprovador do financeiro - Assinatura e data',oArial_09n)	
Return