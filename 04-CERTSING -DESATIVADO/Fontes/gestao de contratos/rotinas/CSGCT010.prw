#Include "Totvs.ch"

/*__________________________________________________________/
# Altera Origem do Pedido de Venda, para liberar alteração.	#
# Renato Ruy - 01/07/2014								    #
/__________________________________________________________*/ 

User Function CSGCT010()

If !Empty(SC5->C5_MDCONTR)
	RecLock("SC5",.F.)
		SC5->C5_MDCONTR := ""
	SC5->(MsUnlock())
	Alert("Pedido do Gestão de Contratos Liberado Para Alteração.")
Else
	DbSelectArea("CND")
	DbSetOrder(4)
	If DbSeek(xFilial("CND")+SC5->C5_MDNUMED)
		RecLock("SC5",.F.)
			SC5->C5_MDCONTR := CND->CND_CONTRA
		SC5->(MsUnlock())
		Alert("Pedido do Gestão de Contratos Bloqueado Para Alteração.")
	EndIf
EndIf

Return()