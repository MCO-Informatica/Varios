#Include "Protheus.ch"
#Include "TOPCONN.CH"
#Include "FINA330.ch"

User Function FA240PA() 
Local aAreaAtu	:= GetArea()     
Local lRet := .T. // .T., para o sistema permitir a seleção de PA (com mov. Bancário) - // na tela de borderô de pagamento e .F. para não permitir.

RestArea(aAreaAtu)
Return lRet