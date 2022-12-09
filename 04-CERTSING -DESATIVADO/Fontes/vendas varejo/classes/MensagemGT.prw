#Include "Protheus.ch"
#Include "Ap5Mail.ch"
#Include "TbiConn.ch"
#Include "Totvs.ch"

/*/{Protheus.doc} GTMensagem
@author    bruno.nunes
@since     09/01/2021
@version   P12
/*/   
class MensagemGT
	data cGTId						as string
	data cType 						as string
	data cPedidoLog					as string
	data cPedidoSite				as string
	data cPedidoEcommerce			as string
	data aLog						as array
	data lGTSend					as logical
	data cCartao					as string
	data cCartaoDigito   			as string
	data cVoucher   				as string
	data cCCDOC						as string
	data cCCCONF   					as string
	data cCCAUT   					as string
	data cRightnowCNPJContato 		as string //CNPJ DO CONTATO <contato><cpf ou cnpj>
	data cRightnowCNPJFaturamento 	as string //CNPJ DO FATUTAENTO <fatura><cpf ou cnpj>
	data cRightnowOrigemVenda 		as string //Origem da venda <pagamento><origemVenda>

	method New() constructor
	method SetTitulo( cTitMsg ) //Adicionar mensagem
	method AddMensagem( oDado ) //Adicionar mensagem
	method SetMensagem( aLista )
	method AddGTOut( pcGTId, pcType, pcPedLog, pcPedSit, pcPedEco )
	method AddGTIn(  pcGTId, pcType, pcPedLog, pcCartao, pcDigito, pcVoucher, pcCCDOC, pcCCCONF, pcCCAUT, pCNPJCon, pCNPJFat, pOriVen )
endclass

/*/{Protheus.doc} New
Metodo construtor
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method New() class MensagemGT as object
	::cGTId 					:= ""
	::cType 					:= ""
	::cPedidoLog 				:= ""
	::cPedidoSite 				:= ""
	::cPedidoEcommerce  		:= ""
	::aLog 						:= {}
	::lGTSend					:= .T.
	::cCartao					:= ""
	::cCartaoDigito   			:= ""
	::cVoucher   				:= ""
	::cCCDOC					:= ""
	::cCCCONF   				:= ""
	::cCCAUT   					:= ""
	::cRightnowCNPJContato 		:= "" //CNPJ DO CONTATO <contato><cpf ou cnpj>
	::cRightnowCNPJFaturamento 	:= "" //CNPJ DO FATUTAENTO <fatura><cpf ou cnpj>
	::cRightnowOrigemVenda 		:= "" //Origem da venda <pagamento><origemVenda>
return self

/*/{Protheus.doc} AddMensagem

@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method AddMensagem( oDado ) class MensagemGT as Undefinied
	aAdd( ::aLog , oDado )
return

/*/{Protheus.doc} SetMensagem
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method SetMensagem( aLista ) class MensagemGT as Undefinied
	::aLog := aLista
return 

/*/{Protheus.doc} SetMensagem
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method AddGTOut( pcGTId, pcType, pcPedLog, pcPedSit, pcPedEco ) class MensagemGT as Undefinied
	default pcGTId		:= ""
	default pcType		:= ""
	default pcPedLog	:= ""
	default pcPedSit	:= ""
	default pcPedEco	:= ""

	::cGTId				:= pcGTId
	::cType				:= pcType
	::cPedidoLog		:= pcPedLog
	::cPedidoSite		:= pcPedSit
	::cPedidoEcommerce  := pcPedEco

	//##TODO passar essa funcao para dentro da classe
	U_GTPutOUT( ::cGTId, ::cType , ::cPedidoLog, ::aLog, ::cPedidoSite, ::cPedidoEcommerce )
return 

/*/{Protheus.doc} AddGTIn
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method AddGTIn( pcGTId, pcType, pcPedLog, pcCartao, pcDigito, pcVoucher, pcCCDOC, pcCCCONF, pcCCAUT, pCNPJCon, pCNPJFat, pOriVen ) class MensagemGT as Undefinied
	local aDetPag := {}
	local aXmlCC  := {}
	local aChkOut := {}
	
	default pcGTId		:= ""
	default pcType		:= ""
	default pcPedLog	:= ""
	default pcCartao	:= ""
	default pcDigito	:= ""
	default pcVoucher	:= ""
	default pcCCDOC		:= ""
	default pcCCCONF	:= ""
	default pcCCAUT		:= ""
	default pCNPJCon	:= ""
	default pCNPJFat	:= ""
	default pOriVen		:= ""
	
	::cGTId						:= pcGTId
	::cType						:= pcType
	::cPedidoLog				:= pcPedLog
	::cCartao					:= pcCartao
	::cCartaoDigito				:= pcDigito
	::cVoucher					:= pcVoucher
	::cCCDOC					:= pcCCDOC
	::cCCCONF					:= pcCCCONF
	::cCCAUT					:= pcCCAUT
	::cRightnowCNPJContato		:= pCNPJCon
	::cRightnowCNPJFaturamento	:= pCNPJFat
	::cRightnowOrigemVenda		:= pOriVen

	aDetPag := { ::cCartao, ::cCartaoDigito, ::cVoucher}
	aXmlCC  := { ::cCCDOC , ::cCCCONF      , ::cCCCONF}
	aChkOut := { ::cRightnowCNPJContato, ::cRightnowCNPJFaturamento, ::cRightnowOrigemVenda}

	//##TODO passar essa funcao para dentro da classe
	U_GTPutIN( ::cGTId, ::cType,  ::cPedidoLog, ::lGTSend, ::aLog, ::cPedidoSite, aDetPag, aXmlCC, aChkOut, ::cPedidoEcommerce )

	
return
