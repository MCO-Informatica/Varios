//-------------------------------------------------------------------------
// Rotina | CN130TOK     | Autor | Rafael Beghini       | Data | 11/09/2015
//-------------------------------------------------------------------------
// Descr. | Rotina que executa Valida��es Espec�ficas da Medi��o do Contrato
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function CN130TOK()
	Local lRet := .T.
	lRet := U_A670TudOk()
Return( lRet )