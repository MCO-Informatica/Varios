
#INCLUDE "PROTHEUS.CH"

//----------------------------------------------------------------------------------------------------
// Descr. |A rotina padr?o, efetua a soma dos produtos iguais no momento de gerar cota??o.
//        |Com isso, foi necess?rio o desenvolvimento do Ponto de Entrada para caso o produto
//        |seja o mesmo, por?m, os campos de observa??o e data de necessidade sejam preenchidos,
//        |no momento de gerar a cota??o , o pedido esteja separado. 
//        | 
//        |
//        |
//        |
//        |
//        |
//----------------------------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//----------------------------------------------------------------------------------------------------

User Function MT110LOK

LOCAL nC1_PRODUTO   := GdFieldPos("C1_PRODUTO", aHeader)
LOCAL nC1_NECESS    := GdFieldPos("C1_DATPRF", aHeader)
LOCAL nC1_OBS       := GdFieldPos("C1_OBS", aHeader)

   If n > 1
      If (aCols[n,nC1_PRODUTO] == aCols[n-1,nC1_PRODUTO]) .and. (aCols[n,nC1_OBS] <> aCols[n-1,nC1_OBS])
         aCols[n,nC1_NECESS] := aCols[n-1,nC1_NECESS] + 1
      EndIf
   EndIf


Return(.t.)       
