#Include 'Protheus.ch'
//---------------------------------------------------------------
// Rotina | MATA010 | Autor | Rafael Beghini | Data | 22/03/2018 
//---------------------------------------------------------------
// Descr. | Manuten��es na rotina de Produtos
//---------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//---------------------------------------------------------------
User Function MATA010()
	LOCAL xReturn  		:= .T.
		
	IF ( IsInCallStack('A010Inclui') .OR. IsInCallStack('A010Altera') .OR. IsInCallStack('A010Copia') ) ;
		.And. ( .NOT. IsBlind() )
		//Chamar fun��o para duplicar o produto nas filiais
		U_A550Filiais()
	EndIF
	
Return xReturn