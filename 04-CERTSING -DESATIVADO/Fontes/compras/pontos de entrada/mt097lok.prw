//--------------------------------------------------------------------------
// Rotina | A610Lib | Autor | Robson Gon�alves           | Data | 17.05.2016
//--------------------------------------------------------------------------
// Descr. | O ponto de entrada se encontra no inicio da fun��o A097LIBERA 
//        | antes da cria��o da dialog de libera��o e bloqueio, pode ser 
//        | utilizado para validar se a opera��o deve continuar ou n�o 
//        | conforme seu retorno, ou ainda pode ser usado para substituir o 
//        | programa de libera��o por um especifico do usuario.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MT097LOK()
	Local lRet := .T.
	lRet := U_A610Lib()
Return( lRet )