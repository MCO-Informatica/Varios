#INCLUDE "rwmake.ch"                                                  	

/////////////////////////////////////////////////////////////////////////
//                                                                     //
//  Fun??o.....: M020INC                          M?dulo..: TODOS      //
//                                                                     //
//  Autor......: J?lio Cesar Almeida Bernardes    Data....: 15/03/2012 //
//                                                                     //
//  Descri??o..: Ponto de Entrada na confirma??o da altera??o do       //
//               fornecedor para criar a Conta Cont?bil no Plano de    //
//               Contas                                                //
//                                                                     //
//  Uso........: Espec?fico Fia??o Fides                        	   //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

User Function M020INC
/*Local _aArea      := GetArea()
Local cFornecedor := ""

cFornecedor 	:= "F"+SA2->A2_COD

CTH->(DbGoTop())          	
CTH->(DbSetOrder(1))	
If !CTH->(DbSeek(xFilial("CTH")+cFornecedor))
  	RecLock("CTH",.T.)
  		CTH->CTH_FILIAL := xFilial("CTH")
	  	CTH->CTH_CLVL  := cFornecedor
	  	CTH->CTH_DESC01 := SA2->A2_NOME
	  	CTH->CTH_CLSUP :="F"
	  	CTH->CTH_CLASSE := "2"
	  	CTH->CTH_BLOQ := "2"
//	  	CTH->CTH_ITLP := cFornecedor
//	  	CTH->CTH_CLOBRG := "2"
//	  	CTH->CTH_ACCLVL := "1"
  	CTH->(MsUnLock())
Endif
RestArea(_aArea)  */              

Return(.T.)