#Include 'Protheus.ch'
//---------------------------------------------------------------------
// Rotina | CSCTA100  | Autor | Rafael Beghini      | Data | 10.04.2018
//---------------------------------------------------------------------
// Descr. | Altera��es espec�ficas em Contratos
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------
User Function CSCTA100( nOpc )
	IF nOpc == 1
		A100Assina()
	ElseIF nOpc == 2
		A100Area()
	ElseIf nOpc == 3
		A100Descr()
	ElseIf nOpc == 4
		A100Cond()
	EndIF
Return
//---------------------------------------------------------------------
// Rotina | A100Assina  | Autor | Rafael Beghini  | Data | 10.04.2018
//---------------------------------------------------------------------
// Descr. | Altera os assinantes do contrato
//---------------------------------------------------------------------
Static Function A100Assina()
	Local aPar := {}
	Local aRet := {}
	Local cHistory := ''
	
	AAdd( aPar,{ 9, 'Informe os assinantes do contrato', 150, 7, .T. } )
	AAdd( aPar,{ 1, 'Assinates', Left(CN9->CN9_XASSIN,50), "","","A650AS","",100,.T.})
	
	bOk := {|| MsgYesNo( "Confirma o in�cio do processamento?", '[CSCTA100]' ) }	
					
	IF ParamBox( aPar, '', @aRet, bOk )
		cHistory := 'Mensagem informativa: Alterado os assinantes, por '+RTrim( UsrFullName( __cUserID ) )+' em '+Dtoc( MsDate() )+' as '+Time()+'. '
		cHistory += 'Cont�udo anterior: ' + Alltrim(CN9->CN9_XASSIN)
		
		CN9->( RecLock( 'CN9', .F. ) )
		CN9->CN9_MOTALT := IIF( Empty(CN9->CN9_MOTALT), cHistory, AllTrim( CN9->CN9_MOTALT ) + CRLF + CRLF + cHistory )
		CN9->CN9_XASSIN := Alltrim( aRET[ 2 ] )
		CN9->( MsUnLock() )
		
		MsgInfo('Altera��o realizada com sucesso.','[CSCTA100]')
	EndIF
Return
//---------------------------------------------------------------------
// Rotina | A100Area  | Autor | Rafael Beghini  | Data | 10.04.2018
//---------------------------------------------------------------------
// Descr. | Altera a �rea respons�vel do contrato
//---------------------------------------------------------------------
Static Function A100Area()
	Local aPar := {}
	Local aRet := {}
	Local cHistory := ''
	
	AAdd( aPar,{ 9, 'Informe a �rea respons�vel', 150, 7, .T. } )
	AAdd( aPar,{ 1, '�rea', Left(CN9->CN9_XAREA,50), "","","A650AR","",100,.T.})
	
	bOk := {|| MsgYesNo( "Confirma o in�cio do processamento?", '[CSCTA100]' ) }	
					
	IF ParamBox( aPar, '', @aRet, bOk )
		cHistory := 'Mensagem informativa: Alterado a �rea, por '+RTrim( UsrFullName( __cUserID ) )+' em '+Dtoc( MsDate() )+' as '+Time()+'. '
		cHistory += 'Cont�udo anterior: ' + Alltrim(CN9->CN9_XAREA)
		
		CN9->( RecLock( 'CN9', .F. ) )
		CN9->CN9_MOTALT := IIF( Empty(CN9->CN9_MOTALT), cHistory, AllTrim( CN9->CN9_MOTALT ) + CRLF + CRLF + cHistory )
		CN9->CN9_XAREA := Alltrim( aRET[ 2 ] )
		CN9->( MsUnLock() )
		
		MsgInfo('Altera��o realizada com sucesso.','[CSCTA100]')
	EndIF
Return


//---------------------------------------------------------------------
// Rotina | A100Descr  | Autor | Lucas Baia  | Data | 29.04.2021
//---------------------------------------------------------------------
// Descr. | Altera a descri��o do contrato
//---------------------------------------------------------------------
Static Function A100Descr()
	Local aPar := {}
	Local aRet := {}
	Local cHistory := ''
	
	AAdd( aPar,{ 9, 'Informe a descri��o', 150, 7, .T. } )
	AAdd( aPar,{ 1, 'Descri��o', Left(CN9->CN9_DESCRI,100), "","","","",100,.T.})
	
	bOk := {|| MsgYesNo( "Confirma o in�cio do processamento?", '[CSCTA100]' ) }	
					
	IF ParamBox( aPar, '', @aRet, bOk )
		cHistory := 'Mensagem informativa: Alterado a Descri��o, por '+RTrim( UsrFullName( __cUserID ) )+' em '+Dtoc( MsDate() )+' as '+Time()+'. '
		cHistory += 'Cont�udo anterior: ' + Alltrim(CN9->CN9_DESCRI)
		
		CN9->( RecLock( 'CN9', .F. ) )
		CN9->CN9_MOTALT := IIF( Empty(CN9->CN9_MOTALT), cHistory, AllTrim( CN9->CN9_MOTALT ) + CRLF + CRLF + cHistory )
		CN9->CN9_DESCRI := Alltrim( aRET[ 2 ] )
		CN9->( MsUnLock() )
		
		MsgInfo('Altera��o realizada com sucesso.','[CSCTA100]')
	EndIF
Return

//---------------------------------------------------------------------
// Rotina | A100Cond  | Autor | Lucas Baia  | Data | 29.04.2021
//---------------------------------------------------------------------
// Descr. | Altera a condi��o de pagamento do contrato
//---------------------------------------------------------------------
Static Function A100Cond()
	Local aPar := {}
	Local aRet := {}
	Local cHistory := ''
	
	AAdd( aPar,{ 9, 'Informe a Condi��o de Pagamento', 150, 7, .T. } )
	AAdd( aPar,{ 1, 'Cond.Pagto.', Left(CN9->CN9_CONDPG,30), "","","SE4","",100,.T.})
	
	bOk := {|| MsgYesNo( "Confirma o in�cio do processamento?", '[CSCTA100]' ) }	
					
	IF ParamBox( aPar, '', @aRet, bOk )
		cHistory := 'Mensagem informativa: Alterado a Cond. Pagto., por '+RTrim( UsrFullName( __cUserID ) )+' em '+Dtoc( MsDate() )+' as '+Time()+'. '
		cHistory += 'Cont�udo anterior: ' + Alltrim(CN9->CN9_CONDPG)
		
		CN9->( RecLock( 'CN9', .F. ) )
		CN9->CN9_MOTALT := IIF( Empty(CN9->CN9_MOTALT), cHistory, AllTrim( CN9->CN9_MOTALT ) + CRLF + CRLF + cHistory )
		CN9->CN9_CONDPG := Alltrim( aRET[ 2 ] )
		CN9->( MsUnLock() )
		
		MsgInfo('Altera��o realizada com sucesso.','[CSCTA100]')
	EndIF
Return
