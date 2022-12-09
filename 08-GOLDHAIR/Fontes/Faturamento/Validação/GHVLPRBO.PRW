#INCLUDE "Protheus.ch"   

/******************************************************************************
* Valida se produto pode ser bonificado, se faz parte de grupo de bonificação *
* Função na validação do campo C6_PRODUTO                                     *
******************************************************************************/

USER FUNCTION GHVLPRBO

Local cBoni   := ""
Local lRet    := .T.
Local cProd := aCols[n][Ascan(aHeader,{|x| Trim(x[2]) == "C6_PRODUTO"})]

If SB1->(DbSeek(xFilial("SB1") + cProd))
   cBoni :=POSICIONE("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_X_BONI")
   If cBoni <> "1"
      lRet := .F.
      Alert("Produto faz parte de grupo que não pode ser bonificado!")
   Endif
Endif