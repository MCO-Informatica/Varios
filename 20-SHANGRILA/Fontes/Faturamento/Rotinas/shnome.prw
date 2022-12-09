#include "rwmake.ch"

//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//   Programa ...: SHNOME                             Modulo : SIGAFAT      //
//                                                                          //
//   Autor ......: RODRIGO O. T. CAETANO              Data ..: 01/03/2004   //
//                                                                          //
//   Objetivo ...: Programa executado no X3_INIBRW do campo C5_NOME para    //
//                 mostrar o nome do cliente ou fornecedor                  //
//                                                                          //
//   Uso ........: Especifico da Shangri-la                                 //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

User Function SHNOME

Private _cNome := If(SC5->C5_TIPO$"NCIP",Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_NOME"))

Return(_cNome)