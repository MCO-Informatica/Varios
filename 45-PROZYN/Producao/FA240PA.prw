#Include "Protheus.ch"
#Include "TOPCONN.CH"
#Include "FINA330.ch"

User Function FA240PA() 
Local aAreaAtu	:= GetArea()     
Local lRet := .T. // .T., para o sistema permitir a sele��o de PA (com mov. Banc�rio) - // na tela de border� de pagamento e .F. para n�o permitir.

RestArea(aAreaAtu)
Return lRet