//-----------------------------------------------------------------------
// Rotina | CSFA360    | Autor | Robson Gon�alves     | Data | 26.02.2014
//-----------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada MT410TOK.
//        | O objetivo � criticar caso haja diverg�ncia entre o pedido de
//        | vendas e o atendimento do Televendas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSFA360()
	Local nI := 0
	Local nP := 0
	
	Local lRet := .T.
	
	Local aArea := {}
	Local aAreaSUB := {}
	
	Local aSUB := {}
	
	Local nP_C6_PRODUTO := 0
	Local nP_C6_VALOR := 0
	
	Local cTitulo := 'MT410TOK | CSFA360 | Valida��o do P.V.'
	
	aArea := GetArea()
	
	// Capturar o c�digo do produto no atendimento.
	aAreaSUB := SUB->( GetArea() )
	SUB->( dbSetOrder( 1 ) )
	SUB->( dbSeek( xFilial( 'SUB' ) + M->C5_ATDTLV ) )
	While .NOT. SUB->( EOF() ) .And. SUB->UB_FILIAL == xFilial( 'SUB' ) .And. SUB->UB_NUM == M->C5_ATDTLV
		SUB->( AAdd( aSUB, { UB_PRODUTO, UB_VLRITEM } ) )
		SUB->( dbSkip() )
	End
	
	// Criticar caso o tamanho dos aCOLS sejam diferentes.
	If Len( aCOLS ) == Len( aSUB )
		// Capturar a posi��o dos campos na GetDados.
		nP_C6_PRODUTO := GdFieldPos('C6_PRODUTO')
		nP_C6_VALOR   := GdFieldPos('C6_VALOR')
		// Ler todos em todos os itens de produtos do atendimento.
		// Comparar o dados do aCOLS do pedido de venda com os dados dos itens do atendimento.	
		For nI := 1 To Len( aSUB )
			nP := AScan( aCOLS, {|p| p[ nP_C6_PRODUTO ] == aSUB[ nI, 1 ] } )
			If nP > 0
				If aSUB[ nI, 2 ] <> aCOLS[ nP, nP_C6_VALOR ]
					If .NOT. MsgYesNo('O produto ' + RTrim( aSUB[ nI, 1 ] )+' est� com diverg�ncia de quantidade ou valor entre o atendimento e o pedido de venda. Continuar com esta diverg�ncia?', cTitulo )
						lRet := .F.
					Else
						A360Diverg( 3 )
					Endif
				Endif
			Else
				If .NOT. MsgYesNo( 'O c�digo do produto ' + RTrim( aSUB[ nI, 1 ] ) + ' n�o foi localizado no pedido. Continuar com esta diverg�ncia?', cTitulo )
					lRet := .F.
				Else
					A360Diverg( 2 )
				Endif
			Endif
		Next nI
	Else
		If .NOT. MsgYesNo('A quantidade de itens do pedido est� divergente do atendimento. Continuar com esta diverg�ncia?', cTitulo )
			lRet := .F.
		Else
			A360Diverg( 1 )
		Endif
	Endif
	
	SUB->( RestArea( aAreaSUB ) )
	RestArea( aArea )
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A360Diverg | Autor | Robson Gon�alves     | Data | 26.02.2014
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar para atribuir a a��o do usu�rio caso ele 
//        | aceite a diverg�ncia.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A360Diverg( nDiverg )
	Local cC5_XOBS := ''
	Local cDiverg := ''
	
	cC5_XOBS := AllTrim( M->C5_XOBS )
	cDiverg := 'User: ' + __cUserID + ' DT: ' + Dtoc( dDataBase ) + 'HR: ' + Time()
	
	If nDiverg == 1
		cDiverg += ' aceitou a diverg�ncia de quantidade de itens do pedido com o atendimento.'
	Elseif nDiverg == 2
		cDiverg += ' aceitou a diverg�ncia de c�digo de produto do pedido com o atendimento.'
	Elseif nDiverg == 3
		cDiverg += ' aceitou a diverg�ncia de quantidade ou pre�o do pedido com o atendimento.'
	Endif
	
	If .NOT. Empty( cC5_XOBS )
		cC5_XOBS := cC5_XOBS + Chr( 13 ) + Chr( 10 ) + cDiverg
	Else
		cC5_XOBS := cDiverg
	Endif
	
	M->C5_XOBS := cC5_XOBS
Return