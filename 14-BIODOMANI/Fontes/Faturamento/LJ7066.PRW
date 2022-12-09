#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function LJ7066()
    
Reclock("SC5",.f.)
SC5->C5_X_USERS := "e-commerce"
SC5->C5_X_EMPFA :=  "0102"
SC5->C5_X_ARMAZ :=  "01A1"
SC5->C5_DF      :=  "S"
SC5->C5_X_PROGR :=  "N"
SC5->C5_VENDE   :=  "3"
SC5->C5_FORMAPG :=  "CC"
SC5->C5_X_VIASP :=  1
SC5->C5_X_IMPRE :=  "N"
SC5->C5_XDIA    :=  "Liberado Entrega"
SC5->C5_OBS1    :=  "PEDIDO E-COMMERCE"
SC5->C5_VEND1   :=  Posicione("SA1",1,Xfilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_VEND")
//SC5->C5_NOMCLI  :=  Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
//SC5->C5_XPRIORI  :=  "A"
MsUnLock()

Return
