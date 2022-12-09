//------------------------------------------------------------------
// Rotina | CN120GRPED 	| Autor | Renato Ruy 	  | Data | 18/02/14
//------------------------------------------------------------------
// Descr. | Ponto de Entrada para verificar se gera ou não Pedido.
//        |
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
#DEFINE cFONT   '<b><font size="4" color="red"><b><u>'
#DEFINE cFONTOK '<font size="5" color="green">'
#DEFINE cNOFONT '</b></font></u></b> '
User Function CN120GRPED()
	Local cPedido  := ''
	Local aArea    := { CNE->( GetArea() ), CNL->( GetArea() ), CN1->( GetArea() ), CNA->( GetArea() ), CNS->( GetArea() ), CNF->( GetArea() ), CNL->( GetArea() ) }
	CN9->( dbSetOrder( 1 ) )
	If CN9->( MsSeek( xFilial( 'CN9' ) + CND->( CND_CONTRA + CND_REVISA ) ) )
		IF CNA->CNA_CONTRA == CN9->CN9_NUMERO
			CN1->( dbSetOrder( 1 ) )
			If CN1->( MsSeek( xFilial( 'CN1' ) + CN9->CN9_TPCTO ) )
				If CN1->CN1_ESPCTR == '2' /*$ "1|2"*/ .AND. .NOT. Empty(CNA->CNA_CONTRA) .AND. .NOT. Empty(CNA->CNA_NUMERO)
					//Se Posiciona no tipo de planilha, para ver se gera pedido de venda/compra.
					CNL->( DbSetOrder(1) )
					If CNL->( DbSeek( xFilial("CNL") + CNA->CNA_TIPPLA ) )
						//If CNL->CNL_XGRPD == "2"
						cPedido := Iif( CN1->CN1_ESPCTR == '1', 'compra.', Iif( CN1->CN1_ESPCTR == '2', 'venda.', '.' ) )
						MsgInfo(cFONT+"ATENÇÃO"+cNOFONT+;
							cFONTOK+"<br><br>Para esta medição não será gerado pedido de "+cPedido+cNOFONT,;
							"PE-CN120GrPed | Tipo de planilha gera pedido compra/venda")
						AEval( aArea, {|xArea| RestArea( xArea ) } )
						Return( .F. )
						//EndIf
					EndIf
				EndIf
			Endif
		EndIF
	Endif
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return( .T. )