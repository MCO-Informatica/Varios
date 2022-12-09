//-----------------------------------------------------------------------
// Rotina | MT110END | Autor | Robson Gonçalves       | Data | 13/04/2016
//-----------------------------------------------------------------------
// Descr. | Rotina ponto de entrada executado após a aprovação da solici-
//        | tação de compras, o objetivo é avisar suprimentos a ação.
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
	// Parâmetros da rotina.
	//----------------------
	// [1]-C1_NUM - Numero da solicitação de compras.
	// [2]-nOpcA  - Opção selecionada pelo usuário, sendo 1=Liberado; 2=Rejeitado; 3=Bloqueado
	aParam := AClone( ParamIXB )
	cSituacao := Iif( aParam[ 2 ] == 1, 'Aprovada', Iif( aParam[ 2 ] == 2, 'Rejeitada', 'Bloqueada' ) )
	cMotivo := 'Não há motivo declarado, pois o usuário '+RTrim(UsrFullName(cIdUser))+' fez esta ação via Sistema Protheus.'
	cC1_SOLICIT := RTrim( SC1->( GetAdvFVal( 'SC1', 'C1_SOLICIT', xFilial( 'SC1' ) + aParam[ 1 ], 1 ) ) )
	U_A710MsgUsr( xFilial( 'SC1' ) + '-' + aParam[ 1 ], cSituacao, cMotivo, cC1_SOLICIT, RTrim( UsrRetName( cIdUser ) ) )
Return