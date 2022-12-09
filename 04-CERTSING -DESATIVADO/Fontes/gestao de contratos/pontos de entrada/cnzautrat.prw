//--------------------------------------------------------------------------
// Rotina | CNZAUTRAT  | Autor | Robson Goncalves        | Data | 18.05.2015
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada utilizado na rotina de rateio do valor de 
//        | contratos para preenchimento automático dos campos selecionados 
//        | para vínculo.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CNZAUTRAT()
	Local aCab := {}
	Local aDados := {}
	Local nOpc := 0

	aCab   := AClone( ParamIXB[ 1 ] )
	aDados := AClone( ParamIXB[ 2 ] )
	nOpc   := ParamIXB[ 3 ]
	
	If nOpc == 3 .OR. nOpc == 4
		U_CSFA620( aCab, @aDados )
	Endif
Return( aDados )