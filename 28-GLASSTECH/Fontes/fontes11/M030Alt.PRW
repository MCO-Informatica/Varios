#INCLUDE "rwmake.ch"

/////////////////////////////////////////////////////////////////////////
//                                                                     //
//  Função.....: M030ALT                          Módulo..: TODOS      //
//                                                                     //
//  Autor......: Júlio Cesar Almeida Bernardes    Data....: 15/03/2012 //
//                                                                     //
//  Descrição..: Ponto de Entrada na confirmação da alteração do       //
//               Cliente para alterar a Classe de Valor			       //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

User Function M030ALT
/*Local _aArea    := GetArea()
Local _cCliente := ""

_cCliente := "C"+SA1->A1_COD

CTH->(DbGoTop())          	
CTH->(DbSetOrder(1))	
If !CTH->(DbSeek(xFilial("CTH")+_cCliente))
  	RecLock("CTH",.T.)
  	  	CTH->CTH_FILIAL := xFilial("CTH")
	  	CTH->CTH_ITEM   := _cCliente
	  	CTH->CTH_DESC01 := SA1->A1_NOME 
	  	CTH->CTH_CLSUP  := "C" 
	  	CTH->CTH_CLASSE := "2"
	  	CTH->CTH_BLOQ   := "2"
//	  	CTH->CTH_ITLP   := _cCliente
//	  	CTH->CTH_CLOBRG := "2"
//	  	CTH->CTH_ACCLVL := "1"
  	CTH->(MsUnLock())
EndIf
RestArea(_aArea)   */            

Return(.T.)