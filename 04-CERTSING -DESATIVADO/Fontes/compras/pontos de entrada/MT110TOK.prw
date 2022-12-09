//--------------------------------------------------------------------------
// Rotina | MT110TOK   | Autor | Robson Goncalves        | Data | 05/06/2017
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada respons�vel pela valida��o da GetDados da 
//        | Solicita��o de Compras de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
// Onde   | O ponto se encontra no final da fun��o e deve ser utilizado para 
//        | valida��es especificas do usuario onde ser� controlada pelo retorno 
//        | do ponto de entrada o qual se for .F. o processo ser� interrompido 
//        | e se .T. ser� validado.
//--------------------------------------------------------------------------
User Function MT110TOK()
	Local aParam := {}
	
	aParam := AClone( ParamIXB )
	lRet := aParam[ 1 ] 
	
	If lRet .AND. ( INCLUI .OR. ALTERA )
		lRet := U_CSFA800()
	Endif
Return( lRet )