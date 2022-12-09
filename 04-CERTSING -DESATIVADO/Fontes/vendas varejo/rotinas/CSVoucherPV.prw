#include 'protheus.ch'
#include 'parmtype.ch'

//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+--------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | OTRS             | Jira   |
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+--------+
//| 26/06/2020 | Bruno Nunes   | - Tratamento para desconto no item do produto e falhas gerais.                   | 1.00   |                  | PROT-  |
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+--------+
//| 21/07/2020 | Bruno Nunes   | Revisão do processo de  fluxo de voucher / negativo.                             | 1.01   |                  | PROT-89|
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+--------+

/*/{Protheus.doc} CSVoucherPV
Classe para calcular itens do pedido de venda
@type class 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
class CSVoucherPV
	data id 		             as string
	data pedidoSite 		     as string
	data pedidoLog		         as string
	data voucherCodigo           as string
	data voucherQuantidade       as numeric
	data produtoCodigo 		     as string
	data produtoQuantidade       as numeric
	data pedidoXML               as object
	data pedidoGAR 		         as string
	data pedidoProtheus          as string
	data itemPVProtheus          as string
	data voucherValido           as logical
	data mensagem                as string
	data geraPedidoProtheus      as logical
	data geraNFServico           as logical
	data geraNFProduto           as logical
	data operacaoVendaServico    as string //Operação de venda de Serviço
	data operacaoVendaHardware   as string //Operação de venda Hardware 
	data operacaoEntregaHardware as string //Operação de entrega Hardware 

	method New( cID, cNpSite, cPedLog, oParPed, cPedGar, cNumSC5 ) constructor //Metodo para iniciar a classe
	method CarregarVoucherXML() 	//Método para retornar o total de registros
endClass

/*/{Protheus.doc} New
Método para inicializar a classe
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return class - classe CSQuerySQL
/*/
method New( cID, cNpSite, cPedLog, oParPed, cPedGar, cNumSC5 ) class CSVoucherPV as object
	default cID	    := ""		  //[01] Id na GTIN
	default cNpSite	:= ""		  //[02] Número do pedido SITE
	default cPedLog	:= ""		  //[03] Numero do log para GTIN / GTOUT
	default cPedGar := ""         //[04] Pedido GAR
	default cPedGar := ""         //[05] Pedido Venda no Protheus

	::id 		        := cID
	::pedidoSite 		:= cNpSite
	::pedidoLog		    := cPedLog
	::pedidoXML         := oParPed
	::voucherCodigo     := ""
	::voucherQuantidade := 0
	::produtoCodigo 	:= ""
	::produtoQuantidade := 0
	::pedidoGAR         := cPedGar 
	::pedidoProtheus    := cNumSC5
	::voucherValido     := .F.

	::CarregarVoucherXML()
return self 

method CarregarVoucherXML() class CSVoucherPV as Undefinied
	local nProd := 0

	//Monto XML do pedido
	if empty( ::id ) .or. ::pedidoXML == nil
		return
	endif

	::voucherCodigo     := alltrim( ::pedidoXML:_PAGAMENTO:_NUMERO:TEXT      )
	::voucherQuantidade := val(     ::pedidoXML:_PAGAMENTO:_QTCONSUMIDA:TEXT )

	dbSelectArea( "SZF" )
	SZF->( dbSetOrder(2) )	// ZF_FILIAL + ZF_COD
	If SZF->( dbSeek(xFilial("SZF") + ::voucherCodigo ) )	// Verifico se o numero do voucher existe
		if Valtype( ::pedidoXML:_PRODUTO ) <> "A"
			XmlNode2Arr( ::pedidoXML:_PRODUTO, "_PRODUTO" )
		endif
		for nProd := 1 To Len( ::pedidoXML:_PRODUTO )
			oProduto := ::pedidoXML:_PRODUTO[ nProd ]         //Objeto do produto
			if alltrim( SZF->ZF_PRODEST ) == oProduto:_CODPROD:TEXT
				::produtoCodigo     := alltrim( oProduto:_CODPROD:TEXT ) //Codigo do produto
				::produtoQuantidade := val(     oProduto:_QTD:TEXT     ) //Quantidade
				
				if !empty( ::pedidoProtheus )
					SC6->(dbSetOrder(1))
					if SC6->( dbSeek( xFilial("SC6") + ::pedidoProtheus ) )
						::itemPVProtheus := SC6->C6_ITEM
					endif
				endif
				exit
			endif
		next nProd
	endif
return