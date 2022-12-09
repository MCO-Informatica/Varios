#INCLUDE "rwmake.ch"                                                  	

/////////////////////////////////////////////////////////////////////////
//                                                                     //
//  Função.....: M020INC                          Módulo..: TODOS      //
//                                                                     //
//  Autor......: Júlio Cesar Almeida Bernardes    Data....: 15/03/2012 //
//                                                                     //
//  Descrição..: Ponto de Entrada na confirmação da alteração do       //
//               fornecedor para criar a Conta Contábil no Plano de    //
//               Contas                                                //
//                                                                     //
//  Uso........: Específico Fiação Fides                        	   //
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