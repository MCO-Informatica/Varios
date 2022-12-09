#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CSDescontoPedido
Classe para facilitar a consulta SQL no banco de dados
@type class 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
class CSDescontoPedidoItem
	//Inicializa variaveis
	data codigoCombo          as string  //[01]Codigo do combo
	data codigoProduto        as string  //[02]Codigo Produto
	data codigoProdutoGAR     as string  //[03]Codigo GAR
	data quantidadeProduto    as numeric //[04]Quantidade produto
	data fator                as numeric //[05]Fator
	data valorUnitario        as numeric //[06]Valor unitario
	data valorUnitarioLiquido as numeric //[07]Valor unitario liquido
	data valorTotal           as numeric //[08]Valor total
	data valorTotalLiquido    as numeric //[09]Valor total liquido
	data valorDesconto        as numeric //[10]Valor desconto
	data percentualDesconto   as numeric //[11]Percentual desconto
	data item 				  as string  //[12]Item no pedido de venda
	data dataEntrega		  as date    //[13]Data entrega
	data TES				  as string  //[14]TER
	data numeroVoucher		  as string  //[15]Numero voucher
	data quantidadeVoucher	  as numeric //[16]Quantidade voucher
	data origemVenda          as string  //[17]Origem venda
	data pedidoOrigem         as string  //[18]Pedido origem
	data idProdutoPedido      as string  //[20]Produto pedido
    data idProdutoPai 	      as string  //[21]Produto pai
    data tabelaPreco 	      as string  //[22]Tabelo preco
    data tipoVoucher 	      as string  //[23]Tipo voucher
    data pedidoEcommerce      as string  //[24]Pedido Ecommerce
    data cupomDesconto        as string  //[25]Cupom desconto

	//Valores de retorno
	data quantidadeProdutoCalculado    as numeric //[26] Quantidade produto calculado
	data fatorCalculado 			   as numeric //[27] Fator calculado
	data valorUnitarioCalculado 	   as numeric //[28] Valor unitario Calculado
	data valorUnitarioLiquidoCalculado as numeric //[29] Valor unitario liquido calculado
	data valorTotalCalculado 		   as numeric //[30] Valor total calculado
	data valorDescontoCalculado 	   as numeric //[31] Valor desconto calculado
	data valorTotalLiquidoCalculado    as numeric //[32] Valor total liquido calculado

	method New( cCodCombo, cCodProd, cCodGAR, nQtd, nFator, nValUni, nValUniLiq, nValTot, nValTotLiq, nValDesc, nPercDes, cItem,   ; 
				dEntrega, cTES, cVoucher, nVoucherQt, cOrigVenda, cIDProPed, cIDProPai, cTabPre, cTpVoucher, cPedEcomme, cCupomDesc;
			  ) constructor //Metodo para iniciar a classe
	method GetPrcCalc()
	method GetDesCalc()
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
method New( cCodCombo , ; //[01]Codigo do combo
			cCodProd  , ; //[02]Codigo Produto
			cCodGAR   , ; //[03]Codigo GAR
			nQtd      , ; //[04]Quantidade produto
			nFator    , ; //[05]Fator
			nValUni   , ; //[06]Valor unitario
			nValUniLiq, ; //[07]Valor unitario liquido
			nValTot   , ; //[08]Valor total
			nValTotLiq, ; //[09]Valor unitario liquido
			nValDesc  , ; //[10]Valor desconto
			nPercDes  , ; //[11]Percentual desconto
			cItem     , ; //[12]Item
			dEntrega  , ; //[13]Data entrega
			cTES      , ; //[14]TES
			cVoucher  , ; //[15]Numero voucher
			nVoucherQt, ; //[16]Quantidade voucher
			cOrigVenda, ; //[17]Origem venda
			cPedOrigem, ; //[18]Pedido origem
			cIDProPed , ; //[19]Produto pedido
			cIDProPai , ; //[20]Produto pai
			cTabPre   , ; //[21]Tabelo preco
			cTpVoucher, ; //[22]Tipo voucher
			cPedEcomme, ; //[23]Pedido Ecommerce
			cCupomDesc  ; //[24]Cupom desconto
		  ) class CSDescontoPedidoItem as object
	default cCodCombo	:= ""		 //[01]Codigo do combo
	default cCodProd	:= ""		 //[02]Codigo Produto
	default cCodGAR		:= ""		 //[03]Codigo GAR
	default nQtd		:= 0		 //[04]Quantidade produto
	default nFator		:= 0		 //[05]Fator
	default nValUni		:= 0		 //[06]Valor unitario
	default nValUniLiq	:= 0		 //[07]Valor unitario liquido
	default nValTot		:= 0		 //[08]Valor total
	default nValTotLiq	:= 0		 //[09]Valor unitario liquido
	default nValDesc	:= 0		 //[10]Valor desconto
	default nPercDes	:= 0		 //[11]Percentual desconto
	default cItem		:= ""		 //[12]Item
	default dEntrega	:= ctod("//")//[13]Data entrega
	default cTES		:= ""		 //[14]TES
	default cVoucher	:= ""		 //[15]Numero voucher
	default nVoucherQt	:= 0		 //[16]Quantidade voucher
	default cOrigVenda	:= ""		 //[17]Origem venda
	default cPedOrigem	:= ""		 //[18]Pedido origem
	default cIDProPed	:= ""		 //[19]Produto pedido
	default cIDProPai	:= ""		 //[20]Produto pai
	default cTabPre		:= ""		 //[21]Tabelo preco
	default cTpVoucher	:= ""		 //[22]Tipo voucher
	default cPedEcomme	:= ""		 //[23]Pedido Ecommerce
	default cCupomDesc	:= ""		 //[24]Cupom desconto
		
	//Inicializa variaveis
	::codigoCombo          := cCodCombo  //[01]Codigo do combo
	::codigoProduto        := cCodProd   //[02]Codigo Produto
	::codigoProdutoGAR     := cCodGAR    //[03]Codigo GAR
	::quantidadeProduto    := nQtd       //[04]Quantidade produto
	::fator                := nFator     //[05]Fator
	::valorUnitario        := nValUni    //[06]Valor unitario
	::valorUnitarioLiquido := nValUniLiq //[07]Valor unitario liquido
	::valorTotal           := nValTot    //[08]Valor total
	::valorTotalLiquido    := nValTotLiq //[09]Valor total liquido
	::valorDesconto        := nValDesc   //[10]Valor desconto
	::percentualDesconto   := nPercDes   //[11]Percentual desconto
	::item 				   := cItem      //[12]Item
	::dataEntrega		   := dEntrega   //[13]Data entrega
	::TES				   := cTES       //[14]TES
	::numeroVoucher		   := cVoucher   //[15]Numero voucher
	::quantidadeVoucher	   := nVoucherQt //[16]Quantidade voucher
	::origemVenda          := cOrigVenda //[17]Origem venda
	::pedidoOrigem         := cPedOrigem //[18]Pedido origem
	::idProdutoPedido      := cIDProPed  //[19]Produto pedido
    ::idProdutoPai 	       := cIDProPai  //[20]Produto pai
    ::tabelaPreco 	       := cTabPre    //[21]Tabelo preco
    ::tipoVoucher 	       := cTpVoucher //[22]Tipo voucher
    ::pedidoEcommerce      := cPedEcomme //[23]Pedido Ecommerce
    ::cupomDesconto        := cCupomDesc //[24]Cupom desconto

	//Valores de retorno
	::quantidadeProdutoCalculado    := 0.00 //[26] Quantidade produto calculado
	::fatorCalculado 			    := 0.00 //[27] Fator calculado
	::valorUnitarioCalculado 	    := 0.00 //[28] Valor unitario Calculado
	::valorUnitarioLiquidoCalculado := 0.00 //[29] Valor unitario liquido calculado
	::valorTotalCalculado 		    := 0.00 //[30] Valor total calculado
	::valorDescontoCalculado 	    := 0.00 //[31] Valor desconto calculado
	::valorTotalLiquidoCalculado 	:= 0.00	//[32] Valor total liquido calculado
return self

/*/{Protheus.doc} GetPrcCalc
Método para inicializar a classe
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return class - classe CSQuerySQL
/*/
method GetPrcCalc() class CSDescontoPedidoItem as numeric
return ::valorUnitarioCalculado

/*/{Protheus.doc} GetDesCalc
Método para inicializar a classe
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return class - classe CSQuerySQL
/*/
method GetDesCalc() class CSDescontoPedidoItem as numeric
return ::valorDesconto