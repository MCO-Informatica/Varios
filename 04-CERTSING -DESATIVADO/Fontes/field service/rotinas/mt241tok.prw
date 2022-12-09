//----------------------------------------------------------------
// Rotina | MT241TOK   | Autor | Robson Gonçalves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Ponto de entrada acionado ao clicar OK na gravação do 
//        | movimento interno modelo 2 (MATA241).
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function MT241TOK()
	Local lRet := .T.
	lRet := U_A400TOk()
Return( lRet )