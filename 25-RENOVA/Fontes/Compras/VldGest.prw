#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/**
* Rotina		:	VldGest()
* Autor			:	Pedro Augusto
* Data			:	31/08/2015
* Descricao		:	Validar preenchimento do campo GESTOR na solic.compra
* Uso           :   RENOVA ENERGIA
* OBS           :   Tem que estar no VALIDUSER do campo C1_UNIDREQ
*/

User Function VldGest()
	_cAprovSC  := Posicione("SY3",1,xFilial("SY3")+cUnidReq,"Y3_XAPROSC")
	Return .T.