//-----------------------------------------------------------------------
// Rotina | MT110END | Autor | Robson Gon�alves       | Data | 13/04/2016
//-----------------------------------------------------------------------
// Descr. | Rotina ponto de entrada executado ap�s a aprova��o da solici-
//        | ta��o de compras, o objetivo � avisar suprimentos a a��o.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function MT110CFM()
	Local aParam := {}
	Local cMotivo := ''
	Local cSituacao := ''
	Local cIdUser := RetCodUsr()
	Local cC1_SOLICIT := ''
	//----------------------
	// Par�metros da rotina.
	//----------------------
	// [1]-C1_NUM - Numero da solicita��o de compras.
	// [2]-nOpcA  - Op��o selecionada pelo usu�rio, sendo 1=Liberado; 2=Rejeitado; 3=Bloqueado
	aParam := AClone( ParamIXB )
	cSituacao := Iif( aParam[ 2 ] == 1, 'Aprovada', Iif( aParam[ 2 ] == 2, 'Rejeitada', 'Bloqueada' ) )
	cMotivo := 'N�o h� motivo declarado, pois o usu�rio '+RTrim(UsrFullName(cIdUser))+' fez esta a��o via Sistema Protheus.'
	cC1_SOLICIT := RTrim( SC1->( GetAdvFVal( 'SC1', 'C1_SOLICIT', xFilial( 'SC1' ) + aParam[ 1 ], 1 ) ) )
	U_A710MsgUsr( xFilial( 'SC1' ) + '-' + aParam[ 1 ], cSituacao, cMotivo, cC1_SOLICIT, RTrim( UsrRetName( cIdUser ) ) )
Return