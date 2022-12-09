#INCLUDE "Protheus.ch"   

/******************************************************************************
* Valida se a condição de pagamento é válida para o faturamento               *
******************************************************************************/

USER FUNCTION GHVLCPGT

Local lRet    := .T.

/*
Local CValida := ''

   cValida :=POSICIONE("SE4",1,xFilial("SE4")+M->C5_CONDPAG,"E4_X_FATUR")
   If cValida <> "1"
      lRet := .F.
      Alert("Condição de pagamento não pode ser usada para pedido de venda!")
   Endif
*/
 
Return(lRet)