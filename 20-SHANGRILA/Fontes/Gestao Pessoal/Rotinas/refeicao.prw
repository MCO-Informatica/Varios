#Include "RwMake.Ch"
//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//   Programa ...: REFEICAO                           Modulo : SIGAGPE      //
//                                                                          //
//   Autor ......: FABIANO BERMUDES CARA              Data ..: 11/03/02     //
//                                                                          //
//   Objetivo ...: GERACAO DE VALORES NO SRC A TITULO DE VALE REFEICAO      //
//                                                                          //
//   Uso ........: ESPECIFICO DA SHANGRI-LA                                 //
//                                                                          //
//   Atualizacao :                                                          //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////
User Function Refeicao()
//
VREFEICAO := 0
QREFEICAO := SRC->RC_HORAS
//
Reclock("SRC")
//
IF QREFEICAO>0 
VREFEICAO := SRC->RC_HORAS * 1.80
fGeraVerba("424",VREFEICAO,,,,,,,,,.T.)
//
ENDIF
//
Msunlock("SRC")
//
Return() 