//---------------------------------------------------------------------------------
// Rotina    | MT010Can | Autor | Robson Gonçalves              | Data | 16.02.2015
//---------------------------------------------------------------------------------
// Descrição | Este ponto está localizado nas funções  A010Inclui (Inclusão do 
//           | Produto), A010Altera (Alteração do Produto) e A010Deleta (Deleção do 
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