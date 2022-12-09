#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//==========================================================================================================================================================
//Nelson Hammel - 13/10/11 - Ponto de entrada para mudar cores no Mbrowse TMK271

User Function TK271LEG()            

Local aArea  := GetArea()                                                                                     //marrom = cinza
Local aArray := {}

//If cPasta == '2' //Televendas

Aadd(aArray, {"BR_MARRON" 	,"Atendimentos"			})
Aadd(aArray, {"BR_LARANJA"  ,"Ped Vendas Bloqueados"})
Aadd(aArray, {"BR_VERMELHO" ,"Nota Fiscal Emitida"	})
Aadd(aArray, {"BR_VERDE"	,"Pedido de Vendas"    	})
Aadd(aArray, {"BR_AZUL"		,"Orçamento Liberado" 	})
Aadd(aArray, {"BR_CINZA"	,"Orçamento Bloqueado" 	})
Aadd(aArray, {"BR_CANCEL"	,"Cancelado"		 	}) //Modificado de Preto para BR_CANCEL - X

//EndIf

RestArea(aArea)

Return aArray
