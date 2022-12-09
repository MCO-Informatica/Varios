#include 'protheus.ch'
#include 'parmtype.ch'

//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | Jira     |
//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+
//| 18/06/2020 | Bruno Nunes   | - Tratamento para desconto no item do produto e falhas gerais.                   | 1.00   | PROT-    |
//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+
//| 09/10/2020 | Bruno Nunes   | Correção código pedgar                                                           | 1.01   | PROT-262 |
//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+

#define nCASAS_DECIMAIS          2
#define nCODIGO_PRODUTO_PROTHEUS 1
#define nCODIGO_PRODUTO_GAR      2
#define nCODIGO_PRODUTO_ID_ITEM  3

/*/{Protheus.doc} CSDescontoPedido
Classe para calcular itens do pedido de venda
@type class 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
class CSDescontoPedido
	data pedidoSite 		  as string
	data codigoProduto 		  as string
	data codigoCombo		  as string
	data codigoProdutoGAR     as string
	data grupo 				  as string
	data grupoPreco 	 	  as string
	data quantidadeUnitaria   as numeric
	data valorUnitario 		  as numeric
	data valorUnitarioLiquido as numeric
	data valorTotal 		  as numeric
	data valorTotalLiquido 	  as numeric
	data valorDesconto 		  as numeric
	data percentualDesconto   as numeric
	data itens   		  	  as array
	data total     		  	  as CSItemProdutoDesconto
	data item 				  as string
	data dataEntrega	 	  as date
	data TES				  as string
	data numeroVoucher		  as string
	data quantidadeVoucher	  as string	
	data origemVenda     	  as string	
	data pedidoOrigem    	  as string	
	data idProdutoPedido 	  as string	
    data idProdutoPai 	 	  as string	                    
    data idProd     		  as string 
	data tabelaPreco 	 	  as string	
    data tipoVoucher 	 	  as string	
    data pedidoEcommerce 	  as string	
    data cupomDesconto 	 	  as string	
    data KIT				  as logical
    data composicao			  as array
    data certified2		  	  as logical
	
	method New( cPedSite	, ;//[01] 
				cCodProd	, ;//[02]
				cCodCombo	, ;//[03]
				cCodGAR     , ;//[04]
				nQtdUnit	, ;//[05]
				nValUnit	, ;//[06]
				nValUnitLq	, ;//[07]
				nValTot		, ;//[08]
				nValTotLq	, ;//[09]
				nValDes		, ;//[10]
				PercDes		, ;//[11]
				cItem		, ;//[12]
				dEntrega	, ;//[13]
				cTES		, ;//[14]
				cVoucher	, ;//[15]
				nVoucherQt	, ;//[16]
				cOrigVenda	, ;//[17]
				cPedOrigem	, ;//[18]
				cIDProPed	, ;//[19]
				cIDProPai	, ;//[20]
				cTabPre		, ;//[21]
				cTpVoucher	, ;//[22]
				cPedEcomme	, ;//[23]
				cCupomDesc	, ;//[24]
				lKit		, ;//[25]
				aComposica    ;//[26]
				) constructor //Metodo para iniciar a classe
				
	method AtualizarPreco() 	//Método para retornar o total de registros
	method ArredondarPreco() 	//Método para retornar o total de registros
	method CarregarPrecoCombo() //Método para retornar o total de registros
	method Totalizar() 			//Método para retornar o total de registros
	method GetProduto()			//Método para retornar o total de registros
	method ToArray()
	method Is2Certified()
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
method New( cPedSite  , ; //[01] Pedido site
			cCodProd  , ; //[02] Codigo produto
			cCodCombo , ; //[03] Codigo combo
			cCodGAR   , ; //[04] Codigo GAR
			nQtdUnit  , ; //[05] Quantidade unitario
			nValUnit  , ; //[06] Valor unitario
			nValUnitLq, ; //[07] Valor unitario liquido
			nValTot   , ; //[08] Valor total
			nValTotLq , ; //[09] Valor total liquido
			nValDes   , ; //[10] Valor desconto
			PercDes   , ; //[11] Percentual desconto
			cItem     , ; //[12] Item
			dEntrega  , ; //[13] Data entrega
			cTES      , ; //[14] TES
			cVoucher  , ; //[15] Numero do voucher
			nVoucherQt, ; //[16] Quantidade voucher
			cOrigVenda, ; //[17] Origem venda
			cPedOrigem, ; //[18] Pedido Origem
			cIDProPed , ; //[19] Id produto pedido
			cIDProPai , ; //[20] Id produto pai
			cTabPre   , ; //[21] Tabela preco 
			cTpVoucher, ; //[22] Tipo voucher
			cPedEcomme, ; //[23] Pedido Ecommerce
			cCupomDesc, ; //[24] Cumpom desconto
			lKit	  , ; //[25] É do tipo KIT?
			aComposica, ; //[26] Lista da composicao [1] Codigo produto, [2] Codigo GAR, [3] Id Item
			 ) class CSDescontoPedido as object
	default cPedSite	:= ""		  //[01] Pedido site
	default cCodProd	:= ""		  //[02] Codigo produto
	default cCodCombo	:= ""		  //[03] Codigo combo
	default cCodGAR     := ""		  //[04] Codigo GAR
	default nQtdUnit	:= 0		  //[05] Quantidade unitario
	default nValUnit	:= 0.00		  //[06] Valor unitario
	default nValUnitLq	:= 0.00		  //[07] Valor unitario liquido
	default nValTot		:= 0.00		  //[08] Valor total
	default nValTotLq	:= 0.00		  //[09] Valor total liquido
	default nValDes		:= 0.00		  //[10] Valor desconto
	default PercDes		:= 0.00		  //[11] Percentual desconto
	default cItem 		:= ""		  //[12] Item
	default dEntrega 	:= ctod("//") //[13] Data entrega
	default cTES 		:= ""		  //[14] TES
	default cVoucher 	:= "" 		  //[15] Numero do voucher
	default nVoucherQt 	:= 0		  //[16] Quantidade voucher
	default cOrigVenda  := ""		  //[17] Origem venda
	default cPedOrigem  := ""		  //[18] Pedido Origem
	default cIDProPed 	:= ""		  //[19] Id produto pedido
	default cIDProPai 	:= ""		  //[20] Id produto pai
	default cTabPre 	:= ""		  //[21] Tabela preco
	default cTpVoucher 	:= ""		  //[22] Tipo voucher
	default cPedEcomme 	:= ""		  //[23] Pedido Ecommerce
	default cCupomDesc 	:= ""		  //[24] Cumpom desconto
	default lKIT        := .F.        //[25] É do tipo KIT?
	default aComposica  := {}		  //[26] [1] Codigo produto, [2] Codigo GAR, [3] Id Item

	::pedidoSite    	   := cPedSite	 //[01] Pedido site
	::codigoProduto  	   := cCodProd   //[02] Codigo produto
	::codigoCombo		   := cCodCombo  //[03] Codigo combo
	::codigoProdutoGAR     := cCodGAR    //[04] Codigo GAR
	::quantidadeUnitaria   := nQtdUnit   //[05] Quantidade unitario
	::valorUnitario 	   := nValUnit   //[06] Valor unitario
	::valorUnitarioLiquido := nValUnitLq //[07] Valor unitario liquido
	::valorTotal 		   := nValTot    //[08] Valor total
	::valorTotalLiquido    := nValTotLq  //[09] Valor total liquido
	::valorDesconto 	   := nValDes    //[10] Valor desconto
	::percentualDesconto   := PercDes    //[11] Percentual desconto
	::item 				   := cItem      //[12] Item
	::dataEntrega		   := dEntrega   //[13] Data entrega
	::TES				   := cTES       //[14] TES
	::numeroVoucher		   := cVoucher   //[15] Numero do voucher
	::quantidadeVoucher	   := nVoucherQt //[16] Quantidade voucher
	::origemVenda          := cOrigVenda //[17] Origem venda
	::pedidoOrigem         := cPedOrigem //[18] Pedido Origem
	::idProdutoPedido      := cIDProPed  //[19] Id produto pedido
    ::idProdutoPai 	       := cIDProPai  //[20] Id produto pai
    ::tabelaPreco 	       := cTabPre    //[21] Tabela preco
    ::tipoVoucher 	       := cTpVoucher //[22] Tipo voucher
    ::pedidoEcommerce      := cPedEcomme //[23] Pedido Ecommerce
    ::cupomDesconto        := cCupomDesc //[24] Cumpom desconto
    ::KIT                  := lKIT       //[25] É do tipo KIT?
    ::composicao		   := aComposica //[26] [1] Codigo produto, [2] Codigo GAR, [3] Id Item

	::total := CSDescontoPedidoItem():New()
	::itens := {}
	::CarregarPrecoCombo()
	::AtualizarPreco()
	::ArredondarPreco()
return self

/*/{Protheus.doc} CarregarPrecoCombo
Método para carregar dados inicias nos itens do pedido de venda
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
method CarregarPrecoCombo() class CSDescontoPedido as logical
	local lCarregou  := .F.
	local cChaveSZJ  := ""
	local cChaveSZI  := ""
	local cChaveSG1  := ""
	local oItem      := nil
	local lSKU       := .F.
	local idProPed   := ""
	local nPos       := 0
	local cProdGAR   := ""
	local l2Certifie := .F.

	//Verifica se existe codigo do combo
	if empty( ::codigoCombo )
		return .F.
	endif
	
	//Pego o código GAR na SZI
	cChaveSZI := xFilial("SZI") + ::codigoCombo
	SZI->( dbSetOrder( 1 ) )
	if SZI->( dbSeek( cChaveSZI ) )
		lSKU     := SZI->ZI_KITCOMB == 'S' //É SKU? S - Sim / N Não		
	endif

	//PROT-262 Regra adicionado quando existe dois certificados no mesmo combo de produtos
	::Is2Certified()
	
	//Consultar SZJ
	cChaveSZJ := xFilial("SZJ") + ::codigoCombo
	SZJ->( dbSetOrder( 1 ) )
	if SZJ->( dbSeek( cChaveSZJ ) )
		while SZJ->( !EoF() ) .and. SZJ->( ZJ_FILIAL + ZJ_COMBO ) == cChaveSZJ
			cChaveSG1 := xFilial('SG1')+SZJ->ZJ_CODPROD
			
			//Se o produto não existir na tabela Estruturas dos Produtos, inclui para calculo.  
			//Tratamento para tipo SAGE / KIT     
			SG1->( dbSetOrder( 1 ) )
			if ! SG1->( dbSeek( cChaveSG1 ) )
				//Caso for SKU produto pedido é igual ao produto pai, depois an rotina executapedidogar é adicionado um novo valor.
				if ::KIT
					//Regra para atualizar o campo C6_XIDPED conforme SAGE (ANDRE SANT'ANA - COMPILA)
					If Alltrim(SZI->ZI_PROKIT) $ GetMv("CT_XDIDPED")
						idProPed  :=  ::idProdutoPedido       			//[3] C6_XIDPED - Id Item
					Else
						idProPed  := iif( lSKU, ::idProdutoPai, ::idProdutoPedido )
					EndIf 
				else
					idProPed  := ::idProdutoPedido
				endif 
				
				cProdGAR := SZJ->ZJ_PROGAR
				if len( ::composicao ) > 0
					nPos := aScan(  ::composicao,{ |x| alltrim( x[ 1 ] ) == alltrim( SZJ->ZJ_CODPROD ) })
					if nPos > 0
						cProdGAR := ::composicao[nPos][nCODIGO_PRODUTO_GAR]
						idProPed := ::composicao[nPos][nCODIGO_PRODUTO_ID_ITEM]
						
						//PROT-262 Regra adicionado quando existe dois certificados no mesmo combo de produtos
						if ::certified2 .and. !empty( idProPed ) .And. !(Alltrim(SZI->ZI_PROKIT) $ GetMv("CT_XDIDPED"))
							::idProdutoPai := idProPed //C6_XIDPEDO == C6_XIDPED
						endif						
					endif
				endif
				if empty( cProdGAR ) .and. !empty( ::codigoProdutoGAR )
					cProdGAR := ::codigoProdutoGAR
				endif
		
				//Adiciono os itens do combo
				oItem := CSDescontoPedidoItem():New( SZJ->ZJ_COMBO   	 , ; //[01] Codigo Combo
													 SZJ->ZJ_CODPROD 	 , ; //[02] Codigo Produto
													 cProdGAR	         , ; //[03] Codigo Produto GAR
													 SZJ->ZJ_QTDBAS  	 , ; //[04] Quantidade Produto
													 SZJ->ZJ_FATOR   	 , ; //[05] Fator
													 SZJ->ZJ_PREBASE 	 , ; //[06] Valor Unitario
													 SZJ->ZJ_PREBASE 	 , ; //[07] Valor Unitario Liquido
													 SZJ->ZJ_PRETAB  	 , ; //[08] Valor Total
													 SZJ->ZJ_PRETAB  	 , ; //[09] Valor Total Liquido
													 ::valorDesconto	 , ; //[10] Valor Desconto
													 ::percentualDesconto, ; //[11] Percentual de desconto
													 ::item 			 , ; //[12] Item no pedido de venda
													 ::dataEntrega		 , ; //[13] Data entrega
													 ::TES				 , ; //[14] TES
													 ::numeroVoucher	 , ; //[15] Numero voucher
													 ::quantidadeVoucher , ; //[16] Quantidade voucher
													 ::origemVenda       , ; //[17] Origem venda
													 ::pedidoOrigem      , ; //[18] Pedido origem
													 idProPed            , ; //[19] Produto pedido
													 ::idProdutoPai 	 , ; //[20] Produto pai        
													 ::tabelaPreco 	     , ; //[21] Tabelo preco
													 ::tipoVoucher 	     , ; //[22] Tipo voucher
													 ::pedidoEcommerce   , ; //[23] Pedido Ecommerce
													 ::cupomDesconto     , ; //[24] Cupom desconto												
													)	
                aAdd( ::itens, oItem )
            endif
			
			SZJ->( dbSkip() )
		end
		lCarregou := .T.
	endif
	::Totalizar()
return lCarregou

/*/{Protheus.doc} AtualizarPreco
Método de para calcular preco dos itens dos combos do pedido de venda
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
method AtualizarPreco() class CSDescontoPedido as logical
	local i     := 0
	local oItem := nil
	
	//Verifico se existem itens a ser calculado
	if len( ::itens ) == 0
		return .F.
	endif
	
	//Reinicializo os valores totais
	::total:fatorCalculado         := 0.00
	::total:valorUnitarioCalculado := 0.00
	::total:valorDesconto          := 0.00
	
		
	for i := 1 to len( ::itens )
		oItem := ::itens[ i ] //Carrego um item do pedido para recalcular
		
		//Bruno Nunes - adaptado para calculo em classe
		//+---------------------------------------------------------------------------------------------------------+
		//| 07.11.2018 - Yuri Volpe                                                                                 |
		//| Se houve diferenca de valores, calcula o percentual de ajuste e iguala os valores                       |
		//| O arredondamento foi tratado para truncar os decimais (Round zero), devido à regra de ICMS-ST embutido  |
		//| A dízima calculada gerava uma diferença de R$ 0.01 no faturamento, ao termino do processo.              |
		//| todo refazer                                                                                            |
		//+---------------------------------------------------------------------------------------------------------+		

		//Quantidade utilizada para calculo
		oItem:quantidadeProdutoCalculado := oItem:quantidadeProduto

		//Descubro o fator de proporção do valor original na tabela do Protheus
		oItem:fatorCalculado := oItem:valorTotal / ::total:valorTotal 
		
		//Valor Unitario calculado
		oItem:valorUnitarioCalculado := oItem:fatorCalculado * ::valorUnitario //Calculo o novo preço aplicando o fator vezes o valor unitario do pedido
		oItem:valorUnitarioCalculado := Round( oItem:valorUnitarioCalculado, nCASAS_DECIMAIS ) //Arredondo o valor para duas casas decimais
		
		//Calculo o desconto calculado
		oItem:valorDescontoCalculado := oItem:fatorCalculado * ::valorDesconto 		//Calculo o novo preço aplicando o fator vezes o valor unitario do pedido
		//nao arredondar o valor do desconto. 
		//oItem:valorDescontoCalculado := Round( oItem:valorDescontoCalculado, nCASAS_DECIMAIS ) //Arredondo o valor para duas casas decimais

		//Valor Total calculado
		oItem:valorTotalCalculado := oItem:quantidadeProdutoCalculado * oItem:valorUnitarioCalculado
		oItem:valorTotalCalculado := Round( oItem:valorTotalCalculado, nCASAS_DECIMAIS ) //Arredondo o valor para duas casas decimais		     

		//Valor Unitario liquido calculado
		oItem:valorUnitarioLiquidoCalculado := oItem:valorUnitarioCalculado - oItem:valorDesconto
		oItem:valorUnitarioLiquidoCalculado := Round( oItem:valorUnitarioLiquidoCalculado, nCASAS_DECIMAIS ) //Arredondo o valor para duas casas decimais		
	
		//Valor Total liquido calculado
		oItem:valorTotalLiquidoCalculado := oItem:quantidadeProdutoCalculado * oItem:valorUnitarioLiquido
		oItem:valorTotalLiquidoCalculado := Round( oItem:valorTotalLiquidoCalculado, nCASAS_DECIMAIS ) //Arredondo o valor para duas casas decimais		
	next i
	
	::Totalizar()	
return .T.

/*/{Protheus.doc} ArredondarPreco
Método para arrendondar os valores dos itens e para não dar problema na nota fiscal
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
method ArredondarPreco() class CSDescontoPedido as logical
	local nDif  := 0.00
	
	//Verifico se existem itens a ser calculado
	if len( ::itens ) == 0
		return .F.
	endif
	
	//Diferenca atribuio ao primeiro item
	nDif := ::valorUnitario - ::total:valorUnitarioCalculado
	::itens[ 1 ]:valorUnitarioCalculado  += nDif  
	
	//Diferenca atribuio ao primeiro item
	nDif := ::valorDesconto - ::total:valorDescontoCalculado
	::itens[ 1 ]:valorDescontoCalculado += nDif

	//Diferenca atribuio ao primeiro item
	nDif := ::valorTotal - ::total:valorTotalCalculado
	::itens[ 1 ]:valorTotalCalculado += nDif

	//Diferenca atribuio ao primeiro item
	nDif := ::valorUnitarioLiquido - ::total:valorUnitarioLiquidoCalculado
	::itens[ 1 ]:valorUnitarioLiquidoCalculado += nDif

	//Diferenca atribuio ao primeiro item
	nDif := ::valorUnitarioLiquido - ::total:valorTotalLiquidoCalculado
	::itens[ 1 ]:valorTotalLiquidoCalculado += nDif

	//Refaço os totais
	::Totalizar()
return .T.

/*/{Protheus.doc} Totalizar
Método para totalizar os valores dos itens dos pedidos de venda
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
method Totalizar() class CSDescontoPedido as logical
	local i     := 0
	local oItem := nil
	if len( ::itens ) == 0
		return .F.
	endif

	//Totalizo os novos valores
	::total:quantidadeProduto          := 0
	::total:fator         	 	       := 0.00
	::total:valorUnitario  		       := 0.00
	::total:valorUnitarioLiquido       := 0.00 
	::total:valorTotal     		       := 0.00
	::total:valorTotalLiquido    	   := 0.00
	::total:valorDesconto        	   := 0.00
	::total:quantidadeProdutoCalculado := 0
	::total:fatorCalculado 			   := 0.00
	::total:valorUnitarioCalculado 	   := 0.00
	::total:valorTotalCalculado 	   := 0.00
	::total:valorDescontoCalculado 	   := 0.00			
	for i := 1 to len( ::itens )
		oItem := ::itens[ i ] //Carrego um item do pedido para recalcular
		
		::total:quantidadeProduto          += oItem:quantidadeProduto
		::total:fator         	 	       += oItem:fator
		::total:valorUnitario  		       += oItem:valorUnitario
		::total:valorUnitarioLiquido       += oItem:valorUnitarioLiquido
		::total:valorTotal     		       += oItem:valorTotal
		::total:valorTotalLiquido    	   += oItem:valorTotalLiquido
		::total:valorDesconto        	   += oItem:valorDesconto
		::total:quantidadeProdutoCalculado += oItem:quantidadeProdutoCalculado
		::total:fatorCalculado 			   += oItem:fatorCalculado
		::total:valorUnitarioCalculado 	   += oItem:valorUnitarioCalculado
		::total:valorTotalCalculado 	   += oItem:valorTotalCalculado
		::total:valorDescontoCalculado 	   += oItem:valorDescontoCalculado			
	next i
return .T.

/*/{Protheus.doc} GetProduto
Método para pegar o item de um pedido pelo Produto
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
method GetProduto( cProduto ) class CSDescontoPedido as CSDescontoPedidoItem
	local i     := 0
	local oItem := CSDescontoPedidoItem():New()
	
	for i := 1 to len( ::itens )
		if alltrim( cProduto ) == alltrim( ::itens[ i ]:codigoProduto )   
			oItem := ::itens[ i ] //Carrego um item do pedido para recalcular  
			exit //Sai da estrutura de repeticao
		endif
	next i
return oItem

/*/{Protheus.doc} ToArray
Método para converter o objeto em array no formato para ser lido no VNDA260
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
method ToArray() class CSDescontoPedido as Array
	local i      := 0
	local aItens := {}
	local oItem  := nil
	local cItem := ""
	
	for i := 1 to len( ::itens )
		oItem  := ::itens[ i ]
		
		cItem := iif ( empty( oItem:item ), StrZero( i , TamSX3("C6_ITEM")[1]), oItem:item )
		aAdd( aItens, { cItem						, ; //[1]Item
						oItem:codigoProduto			, ; //[2]Codigo Produto
						oItem:quantidadeProduto		, ; //[3]Quantidade
						oItem:valorUnitarioCalculado, ; //[4]Valor Unitario
						oItem:valorUnitarioLiquido	, ; //[5]Valor com desconto
						oItem:valorTotalCalculado	, ; //[6]Valor Total
						oItem:codigoProdutoGAR		, ; //[7]Codigo Produto GAR
						oItem:codigoCombo			, ; //[8]Codigo Combo
						oItem:dataEntrega			, ; //[9]Data da Entrega
						oItem:TES					, ; //[10]TES
						oItem:numeroVoucher			, ; //[11]Numero Voucher
						oItem:quantidadeVoucher		, ; //[12]Saldo Voucher
					    oItem:origemVenda           , ; //[13]Origem Venda
					    oItem:pedidoOrigem          , ; //[14]Pedido de origem
					    oItem:idProdutoPedido       , ; //[15]ID Prod no Pedido - C6_XIDPED
					    oItem:idProdutoPai          , ; //[16]ID PAI (Quem é o pai, então esse registro do aProduto é FILHO!!!)                    
					    oItem:tabelaPreco           , ;	//[17]Tabela de preço
					    oItem:tipoVoucher           , ;	//[18]Tipo do Voucher
					    oItem:pedidoEcommerce       , ;	//[19]Pedido Ecommerce
					    oItem:cupomDesconto         , ;	//[20]Cupom Desconto
					    0						    , ;	//[21]Percentual Desconto
					    oItem:valorDescontoCalculado; //[22]Valor do desconto	  				
						})
	next i	
return aItens

/*/{Protheus.doc} Is2Certified
Verifica se o produto é um Cerficado
@type method 
@author Bruno Vilas Boas Nunes
@since 09/10/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
method Is2Certified() class CSDescontoPedido as logical
	local cCategoSFW := GetNewPar( "MV_GARSFT", "2" )	
	local cChaveSZJ  := ""
	local nQtdProSer := 0 //Quantidade de produtos do tipo de servico

	//Consultar SZJ
	cChaveSZJ := xFilial("SZJ") + ::codigoCombo
	SZJ->( dbSetOrder( 1 ) )
	if SZJ->( dbSeek( cChaveSZJ ) )
		while SZJ->( !EoF() ) .and. SZJ->( ZJ_FILIAL + ZJ_COMBO ) == cChaveSZJ
			dbSelectArea( "SB1" )
			SB1->( dbSetOrder( 1 ) )
			if SB1->( dbSeek( xFilial( "SB1" ) + SZJ->ZJ_CODPROD ) )
				if SB1->B1_CATEGO $ cCategoSFW
					nQtdProSer++
				endif
			endif	
			SZJ->( dbSkip() )
		end
	endif	
	
	if nQtdProSer > 1
		::certified2 := .T.
	endif
return ::certified2
