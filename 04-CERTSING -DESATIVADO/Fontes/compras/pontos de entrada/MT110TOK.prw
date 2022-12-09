//--------------------------------------------------------------------------
// Rotina | MT110TOK   | Autor | Robson Goncalves        | Data | 05/06/2017
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada responsável pela validação da GetDados da 
//        | Solicitação de Compras de compras.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
// Onde   | O ponto se encontra no final da função e deve ser utilizado para 
//        | validações especificas do usuario onde será controlada pelo retorno 
//        | do ponto de entrada o qual se for .F. o processo será interrompido 
//        | e se .T. será validado.
//--------------------------------------------------------------------------
User Function MT110TOK()
	Local aParam := {}
	
	aParam := AClone( ParamIXB )
	lRet := aParam[ 1 ] 
	
	If lRet .AND. ( INCLUI .OR. ALTERA )
		lRet := U_CSFA800()
	Endif
Return( lRet )