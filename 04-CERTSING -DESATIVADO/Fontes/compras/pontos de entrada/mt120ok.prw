//-----------------------------------------------------------------------
// Rotina | MT120OK    | Autor | Robson Gon�alves     | Data | 02.01.2013
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada respons�vel pela valida��o de todos os itens 
//        | da GetDados do Pedido de Compras / Autoriza��o de Entrega.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function MT120OK()
	Local cFunc := ''
	Local lRetorno := .T.
	Private aHeadSCH := AClone( aCPHSCH )
	Private aColsSCH := AClone( ACPISCH )
	If FunName()=='CNTA120'
		lRetorno := U_A610COLS()
	Else
		If FunName()=='MATA121'
			cFunc := Iif( INCLUI, 'INC', Iif( ALTERA, 'ALT', '' ) )
			lRetorno := U_CSFA610( 'COM', 'MATA120', cFunc )
		Endif
	Endif
Return( lRetorno )