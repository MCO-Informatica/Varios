//----------------------------------------------------------------
// Rotina | FT300Rod   | Autor | Robson Gonçalves     | 01.08.2014
//----------------------------------------------------------------
// Descr. | Ponto de entrada para exibir mensagem no rodape da 
//        | oportunidade.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function FT300Rod()
	If .NOT. Empty( GetMv( 'MV_250TABP', .F. ) )
		U_A250TrF3()
	Endif
Return(' ')