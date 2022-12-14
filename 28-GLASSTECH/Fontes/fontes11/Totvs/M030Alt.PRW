#INCLUDE "rwmake.ch"

/////////////////////////////////////////////////////////////////////////
//                                                                     //
//  Fun??o.....: M030ALT                          M?dulo..: TODOS      //
//                                                                     //
//  Autor......: J?lio Cesar Almeida Bernardes    Data....: 15/03/2012 //
//                                                                     //
//  Descri??o..: Ponto de Entrada na confirma??o da altera??o do       //
//               Cliente para alterar a Classe de Valor			       //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

User Function M030ALT
Local _aArea    := GetArea()
Local _cCliente := ""

_cCliente := "C"+SA1->A1_COD

CTH->(DbGoTop())          	
CTH->(DbSetOrder(1))	
If !CTH->(DbSeek(xFilial("CTH")+_cCliente))
  	RecLock("CTH",.T.)
  	  	CTH->CTH_FILIAL := xFilial("CTH")
	  	CTH->CTH_CLVL   := _cCliente
	  	CTH->CTH_DESC01 := SA1->A1_NOME 
	  	CTH->CTH_CLSUP  := "C" 
	  	CTH->CTH_CLASSE := "2"
	  	CTH->CTH_BLOQ   := "2"
//	  	CTH->CTH_ITLP   := _cCliente
//	  	CTH->CTH_CLOBRG := "2"
//	  	CTH->CTH_ACCLVL := "1"
  	CTH->(MsUnLock())
EndIf
RestArea(_aArea)               

Return(.T.)
