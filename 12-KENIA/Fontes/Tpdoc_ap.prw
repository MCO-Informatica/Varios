#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Tpdoc()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CTPDOC,AARRAY,NASCAN,CDOC,_CDOC,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿐xecBlock ? TPDOC    ? Autor ? MARCOS GOMES          ? Data ? 02.02.00 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Cnab a Receber BANCO DO BRASIL/BRADESCO                    낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so       ? Exclusivo para Clientes Microsiga - Kenia                  낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/

// Devido a falta de espaco no configurador para acomodar a expressao abaixo, 
// foi utilizado o ExecBlock abaixo. 

_cTPDOC := SE1->E1_TIPO
//aArray := {}
//AADD( aArray, {"DP "})    // 1.DUPLICATA
//AADD( aArray, {"NP "})    // 2.NOTA PROMISSORIA
//AADD( aArray, {"   "})    // 3.NOTA DE SEGURO
//AADD( aArray, {"   "})    // 4.COBRANCA SERIADA
//AADD( aArray, {"REC"})    // 5.RECIBOS

//nAscan := Ascan( aArray, cTPDOC )

//If Empty(nAscan)
//		 cDOC  := StrZero( Ascan( aArray, cTPDOC ), 2 )
//	 ElseIf Empty(nAscan)
//		 cDOC  := "99"
//	 ElseIf nTPDOC == "NF "
//		 cDOC  := "01"
//EndIf

Do Case
   Case _cTPDOC == "DP "
	  _cDoc := "01"
   Case _cTPDOC == "NF "
	  _cDoc := "01"
   Case _cTPDOC == "NP "
	  _cDoc := "02"
   Case _cTPDOC == "REC"
	  _cDoc := "05"
   OtherWise
	  _cDoc := "01"
EndCase

__RetProc( _cDOC )


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

