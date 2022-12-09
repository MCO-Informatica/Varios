//---------------------------------------------------------------------------------
// Rotina    | MT010Can | Autor | Robson Gon�alves              | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descri��o | Este ponto est� localizado nas fun��es  A010Inclui (Inclus�o do 
//           | Produto), A010Altera (Altera��o do Produto) e A010Deleta (Dele��o do 
//           | Produto).
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function MT010Can()
	Local nOpc := 0
	nOpc := ParamIXB[ 1 ]
	If Select( 'SX6' ) > 0 .AND. ( .NOT. IsBlind() )
		If nOpc == 1
			If IsInCallStack('A010Inclui') .OR. IsInCallStack('A010Altera')
				U_A550Filiais()
			Endif
		Endif
	Endif
Return