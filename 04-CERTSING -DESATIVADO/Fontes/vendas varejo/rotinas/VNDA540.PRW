#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} VNDA540

Funcao criada para controle de etiquetas de rastreamento dos correios por transportadora  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/

User Function VNDA540()
	Private aHeader := {}
	Private aCOLS := {}
	Private cCadastro := 'Lista de Códigos de Rastreamento'
	
	Processa( {|lEnd| Iif( A540Load(), A540Show(), NIL ) }, cCadastro, 'Processando, aguarde...', .F. )
	
Return

/*/{Protheus.doc} A540Load

Funcao criada para carregar etiquetas de rastreamento dos correios de acordo transportadora posicionada  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/

Static Function A540Load()
	Local lRet	:= .T. 
	Local aCPO 	:= {}
	Local cAlias:= ""
			
	AAdd( aCPO, { 'STATUS'		,	'STATUS'          	} )
	AAdd( aCPO, { 'PAG_CODRAS'	,	'Rastreamento'		} ) 	
	AAdd( aCPO, { 'PAG_CODPED'	,	'Pedido Protheus'	} )
	AAdd( aCPO, { 'PAG_STATUS'	,	'Status'        	} )
	AAdd( aCPO, { 'PAG_ENTREG'	,	'Posição Entrega'	} )
	AAdd( aCPO, { 'PAG_DESENT'	,	'Descrição'		} )
	
	cAlias := GetNextALias()
	
	BeginSql Alias cAlias
		SELECT
		  R_E_C_N_O_ PAGREC,	 
		  PAG_CODRAS,
		  PAG_CODPED,
		  PAG_STATUS,
		  PAG_ENTREG
		FROM
		  %Table:PAG% PAG
		WHERE
			PAG.PAG_FILIAL = %xFilial:PAG%	AND
			PAG.PAG_CODTRA = %Exp:SA4->A4_COD%	AND
			PAG.%NotDel%
	EndSql
	
	If !(cAlias)->(EoF())
		SX3->( dbSetOrder( 2 ) )
		For nI := 1 To Len( aCPO )
			SX3->( dbSeek( aCPO[ nI, 1 ] ) )
			If aCPO[ nI, 1 ] $ 'STATUS'
				AAdd( aHeader, { aCPO[ nI, 2 ], aCPO[ nI, 1] , '@BMP', 10, 0, '', '', '', '', '' } ) 
			Else
				SX3->( AAdd( aHeader,{ aCPO[ nI, 2 ], RTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL,'AllWaysTrue', X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } ) )
			Endif
		Next nI
	
		While ! (cAlias)->( EOF() )
			PAG->(DbGoTo((cAlias)->PAGREC))
			
			AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
			nElem := Len( aCOLS )
		   
			For nI := 1 To Len( aHeader )
				If aHeader[ nI, 2 ] == 'STATUS'
					If Empty(PAG->PAG_STATUS)
						aCOLS[ nElem, nI ] := 'BR_BRANCO'	
					ElseIf PAG->PAG_STATUS == '1'
						aCOLS[ nElem, nI ] := 'BR_CINZA'
					ElseIf PAG->PAG_STATUS == '2' 
						aCOLS[ nElem, nI ] := 'BR_AZUL'
					ElseIf PAG->PAG_STATUS == '3' .AND. Empty(PAG->PAG_ENTREG)  
						aCOLS[ nElem, nI ] := 'BR_AMARELO'
					ElseIf PAG->PAG_STATUS == '3' .AND. Alltrim(PAG->PAG_ENTREG) = '00'  
						aCOLS[ nElem, nI ] := 'BR_MARROM'
					ElseIf PAG->PAG_STATUS == '3' .AND. Right(PAG->PAG_ENTREG,2) = '01'  
						aCOLS[ nElem, nI ] := 'BR_VERDE'
					ElseIf PAG->PAG_STATUS == '3' .AND. Right(PAG->PAG_ENTREG,2) <> '01'
						aCOLS[ nElem, nI ] := 'BR_VERMELHO'
					EndIf
				ElseIf aHeader[ nI, 2 ] == 'PAG_DESENT'
					aCOLS[ nElem, nI ] := Posicione("SX5",1,xFilial("SX5")+"PG"+PAG->PAG_ENTREG,"X5_DESCRI")	
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
		EndDo
	Else
		lRet := .F.
		MsgInfo('Não há dados.',cCadastro)	
	EndIf
	
	(cAlias)->( dbCloseArea() )
	
Return(lRet)

/*/{Protheus.doc} A540Show

Funcao criada para mostrar tela com as etiquetas de rastreamento dos correios de acordo transportadora posicionada  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/

Static Function A540Show()
	Local oDlg 
	
	Local nCol := 0
	Local nRow := 0
	Local nL := 2
	Local nI := 0
	
	Local cOK := 'AllWaysTrue'
	
	Local aButton := {}
	
	Local oFont := TFont():New('Courier new',,-16,,.T.)
		
	Private oGride
	
	Private oPanel
	
	// [1] - Título do botão.
	// [2] - Chamada da funcionalidade.
	// [3] - Nº da tecla de atalho.
	AAdd( aButton, { '&Pesquisar F4'        , '{|| GdSeek(oGride,,aHeader,aCOLS,.F.) }' , 115 } )
	AAdd( aButton, { '&Legenda F5'          , '{|| A540Legenda( Len( oGride:aCOLS ) ) }' , 116 } )
	AAdd( aButton, { '&Sair F6'            , '{|| Iif( MsgYesNo("Deseja realmente sair da rotina?", cCadastro ), oDlg:End(), NIL ) }' , 117 } )
	
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
	ACTIVATE MSDIALOG oDlg
	
	AEval( aButton, {|p| SetKey( p[ 3 ], NIL ) } )
Return

/*/{Protheus.doc} A540Legenda

Funcao criada para mostrar tela com as legendas do status das etiquetas de rastreamento dos correios atreladas a transportadora  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
Static Function A540Legenda( nRegistros )
	Local aCor := {}
	
	AAdd( aCor, { 'BR_BRANCO' 	, 'Pedido sem Cod. de Rastreamento' } )
	AAdd( aCor, { 'BR_CINZA' 	, 'Cód. Rastreamento incluído' } )
	AAdd( aCor, { 'BR_AZUL'     , 'Pedido com Cód. de Rastreamento' } )
	AAdd( aCor, { 'BR_AMARELO'  , 'Pedido com Etiqueta gerada' } )
	AAdd( aCor, { 'BR_MARROM'   , 'Pedido enviado a Transportadora' } )
	AAdd( aCor, { 'BR_VERDE'  	, 'Entrega confirmada pela transportadora' } )
	AAdd( aCor, { 'BR_VERMELHO' , 'Ocorrência na entrega' } )
	AAdd( aCor, { ' '       	, '' } )
	AAdd( aCor, { ''            , LTrim(Str(nRegistros))+' registro(s) localizado(s).' } )
	
	BrwLegenda( cCadastro, 'Legenda dos registros', aCor )	
Return
