#Include "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} MA410LEG
	(Altera os textos da legenda, que representam o “status” do pedido)
	@type User Function
	@author Calabro'
	@since 19/10/2021
	@version version
	@return aLeg, array, (Array contendo os status do pedido)
	@example
	(examples)
	@see (links_or_references)
	/*/

User Function MA410LEG()

Local aLeg := PARAMIXB

aAdd(aLeg, {"BR_BRANCO"		, "Pedido sem triagem realizada"})
aAdd(aLeg, {"BR_PRETO"		, "Pedido com Romaneio gerado"})
aAdd(aLeg, {"BR_VIOLETA"	, "Pedido com Pré-nota gerada"})

Return aLeg
