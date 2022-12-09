#Include "RwMake.Ch"
//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//   Programa ...: MENSALIDADE SINDICATO              Modulo : SIGAGPE      //
//                                                                          //
//   Autor ......: FABIANO BERMUDES CARA              Data ..: 15/07/02     //
//                                                                          //
//   Objetivo ...: GERACAO DE VALORES NO SRC DE SOCIOS DO SINDICATO         //
//                                                                          //
//   Uso ........: ESPECIFICO DA SHANGRI-LA                                 //
//                                                                          //
//   Atualizacao :                                                          //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////
USER FUNCTION SINDICA()

SINDICA := SRA->RA_SALARIO * 0.005

MSUNLOCK("SRC")
 IF SRA->RA_SOCIO=="S"
 FGERAVERBA(429,SINDICA,,,,,,,,,)
 ENDIF
RECLOCK("SRC")
RETURN()
