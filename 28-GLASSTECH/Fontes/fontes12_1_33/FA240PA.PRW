#Include  'Protheus.ch'

User Function FA240PA()

Local lRet  :=  .T.  // .T. - para o sistema permitir a sele??o de PA (com mov. Banc?rio) na tela de border? de pagamento e
                     // .F. - para n?o permitir.

lRet :=  .T. //MsgYesNo("Permite selecionar PA? ","PONTO DE ENTRADA - FA240PA")

Return lRet
