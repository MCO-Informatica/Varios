//--------------------------------------------------------------------------
// Rotina | A610Lib | Autor | Robson Gonçalves           | Data | 17.05.2016
//--------------------------------------------------------------------------
// Descr. | O ponto de entrada se encontra no inicio das funções A097SUPERI 
//        | e A097TRANSF antes da criação da dialog de liberação e bloqueio, 
//        | pode ser utilizado par validar se a operação deve continuar ou 
//        | não conforme seu retorno, ou ainda pode ser usado para substituir
//        | o programa de liberação por um especifico do usuario.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MT097SOK()
	Local lRet := .T.
	lRet := U_A610Lib()
Return( lRet )