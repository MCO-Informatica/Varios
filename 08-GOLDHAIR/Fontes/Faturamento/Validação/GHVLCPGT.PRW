#INCLUDE "Protheus.ch"   

/******************************************************************************
* Valida se a condi??o de pagamento ? v?lida para o faturamento               *
******************************************************************************/

USER FUNCTION GHVLCPGT

Local lRet    := .T.

/*
Local CValida := ''

   cValida :=POSICIONE("SE4",1,xFilial("SE4")+M->C5_CONDPAG,"E4_X_FATUR")
   If cValida <> "1"
      lRet := .F.
      Alert("Condi??o de pagamento n?o pode ser usada para pedido de venda!")
   Endif
*/
 
Return(lRet)