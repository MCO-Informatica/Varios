//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+--------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | OTRS             | JIRA   |
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+--------+
//| 15/05/2020 | Bruno Nunes   | - Tratar quando o produto for um kit mas no XML não esta preenchido o a          | 1.00   | 2020042710002840 | PROT-6 |
//|            |               | TAG <CODCOMBO>                                                                   |	       |                  |        |
//|            |               | - Controle de mensageria caso queria pegar informações da classe sem debugar     |	       |                  |        |
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+--------+
//| 26/06/2020 | Bruno Nunes   | - Tratamento para entrar Voucher corretamente.                                   | 1.06   |                  | PROT-  |
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+--------+

#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE cVERSAO "1.06"

// **************************************************************************
// ****                                                                  ****
// **** Rotina auxiliares para a nova forma de vendas do Varejo          ****
// ****                                                                  ****
// **************************************************************************

//-- Definada a classe 'COMBO'
CLASS Combo 
	// Declaracao das propriedades da Classe
	DATA aProduto				as array
	DATA itensPedidoVenda		as array
	DATA composicao				as array
	DATA lRetorno				as logical
	DATA SKU					as logical 
	DATA nValor					as numeric //TODO para mim esta esta errada a forma que é usada essa variavel
	DATA quantidade				as numeric
	DATA valorUnitario 			as numeric
	DATA valorUnitarioLiquido	as numeric
	DATA valorTotal         	as numeric
	DATA valorTotalLiquido     	as numeric
	DATA quantidadeVoucher		as numeric
	DATA percentualDesconto 	as numeric
	DATA valorDesconto 			as numeric
	DATA cMsgRetorno			as string
	DATA codigoProdutoSG1		as string
	DATA cupomOrigem			as string
	DATA codigoBPAG				as string
	DATA descricao				as string
	DATA grupo					as string
	DATA grupoPreco				as string
	DATA pedidoSite				as string 
	DATA item  					as string
	DATA codigoProduto      	as string
	DATA codigoProdutoGAR   	as string
	DATA codigoCombo 			as string
	DATA dataEntrega 			as string
	DATA TES 					as string
	DATA numeroVoucher			as string
	DATA origemVenda			as string
	DATA pedidoOrigem			as string
	DATA idPedidoProduto		as string
	DATA idPedidoPai 			as string
	DATA tabelaPreco 			as string
	DATA tipoVoucher 			as string
	DATA pedidoEcommerce        as string
	DATA cupomDesconto 			as string
	DATA KIT 					as logical
	
	METHOD XmlBProd( aDadosXML, dEntreg, cNumvou, nQtdVou, cOriVen, cPedLog, cEcommerce, cCumpomDesc ) constructor
	METHOD BuscaCodCombo( cID )
	METHOD ExistSG1( aComp )
	METHOD CodComboInvalido()
	METHOD AddItemPedidoVenda()
	METHOD CarregarItensCombo()  
	METHOD ValidarXMLProduto( oXMLProd, nL ) 
ENDCLASS

//-- Layout eCommerce - Contém a composição no XML Produto
METHOD XmlBProd( aDadosXML, dEntreg, cNumvou, nQtdVou, cOriVen, cPedLog, cEcommerce, cCumpomDesc ) Class Combo As Undefinied
	Local nI         := 0
	Local nL         := 0
	Local nTotalP    := 0.00
	Local lKit       := .T.
	local oProduto   := nil
	Private cIdProd  := ""
	Private aXML     := aClone( aDadosXML )
	
	default cOriVen := ""

	::itensPedidoVenda  := {}
	::pedidoSite	    := cPedLog
	::cupomOrigem       := cCumpomDesc
	::numeroVoucher     := cNumvou
	::quantidadeVoucher := nQtdVou
	::dataEntrega       := dEntreg
	::TES               := GetMV("MV_XTESWEB",,"502")
	::pedidoEcommerce   := cEcommerce
	::cMsgRetorno 		:= ""

	DbSelectArea( 'SG1' )
	DbSetOrder( 1 )

	DbSelectArea( 'SZI' )   
	DbSetOrder( 1 )

	DbSelectArea( "SZF" )
	DbSetOrder( 2 )

	::tipoVoucher := ""
	If .NOT. Empty( ::numeroVoucher ) .And. DbSeek( xFilial("SZF") + ::numeroVoucher )
		::tipoVoucher := SZF->ZF_TIPOVOU
	EndIF

	//Processo a tags de produto do XML
	For nL := 1 To Len( aXML )
		::lRetorno         := .T.	  //Inicia o processo valido	   
		::origemVenda      := cOriVen //Reseto a variavel na mudanca de cada item
		::pedidoOrigem     := cPedLog //Reseto a variavel na mudanca de cada item
		::codigoProduto    := ""
		::codigoProdutoGAR := ""
		::idPedidoProduto  := ""
		::composicao       := {}

		oProduto := aXML[nL]

		//Sai da rotina caso possua um produto XML invalido
		If !::ValidarXMLProduto( oProduto, nL )
			return
		endif

		//Transforma em array um objeto (nó) da estrutura do XML - eXtensible Markup Language
		If	Type("aXML["+Str(nL)+"]:_COMPOSICAO:TEXT") <> "U"  .and. .NOT. Empty( oProduto:_COMPOSICAO:TEXT ) .and.     Valtype( oProduto:_COMPOSICAO:_ITEM ) <> "A" 
			XmlNode2Arr( oProduto:_COMPOSICAO:_ITEM, "_ITEM" )
		EndIf

		//--A diferença irá utilizar lógica antiga (desmembra)]
		//Condicao para SKU
		If ::codigoProduto == ::codigoBPAG	
			If Type("aXML["+Str(nL)+"]:_COMPOSICAO:_ITEM") <> "U"
				For nI := 1 To Len( oProduto:_COMPOSICAO:_ITEM )
					::KIT := ::ExistSG1( oProduto:_COMPOSICAO:_ITEM[nI]:_CODPROD:TEXT ) 
					If ::KIT
						::codigoProduto := ::codigoProdutoSG1 //[1] Código Protheus
					Else
						::codigoProduto := Alltrim( oProduto:_COMPOSICAO:_ITEM[ nI ]:_CODPROD:TEXT ) //[1] Código Protheus
					EndIF
					::codigoProdutoGAR  := Alltrim( oProduto:_COMPOSICAO:_ITEM[ nI ]:_CODBPAG:TEXT ) //[2] Código GAR
					
					If Alltrim(oProduto:_codprod:text) $ GetMv("CT_XDIDPED")
						::idPedidoProduto   := Alltrim( oProduto:_COMPOSICAO:_ITEM[ 1 ]:_ID:TEXT )      //[3] C6_XIDPED - Id Item
					Else
						::idPedidoProduto   := Alltrim( oProduto:_COMPOSICAO:_ITEM[ nI ]:_ID:TEXT )      //[3] C6_XIDPED - Id Item
					EndIf 	
					aAdd( ::composicao, { ::codigoProduto, ::codigoProdutoGAR, ::idPedidoProduto } )			
				Next nI
			EndIF

			//Adiciona item SKU
			::SKU := .F.

			//Adiciono item do pedido venda
			::AddItemPedidoVenda() //Tratamento especial para produto combo

			::cupomDesconto := ::cupomOrigem
		Else
			If .NOT. ::SKU
				If .NOT. SG1->( DbSeek( xFilial("SG1") + ::codigoProduto ) )
					If Type("aXML["+Str(nL)+"]:_IDPAI:TEXT") == "U"
						::codigoCombo := ''    
					Else
						::BuscaCodCombo( ::idPedidoPai )
						//Para o processo desse produto se o combo for invalido
						If ::CodComboInvalido()
							return
						endif
					EndIF
				Else
					//::idPedidoPai := ''
					//If Type("aXML["+Str(nL)+"]:_IDPAI:TEXT") <> "U"
						//::idPedidoPai := AllTrim( ::idPedidoPai ) //TODO  Nao faz sentido essa condicao
					//EndIf
					If Type("aXML["+Str(nL)+"]:_IDPAI:TEXT") == "U"
						lKit := .T. //Antiga estrutura de formação de preço, não baseada em SKU
						//#TODO Verificar quando o código estiver vazio, olhar na SZI e verificar
						//se existe uma referencia no campo ZI_PROKIT, se existir considerar esse combo
						If ::CodComboInvalido() //Para o processo desse produto se o combo for invalido
							return
						endif
					Else
						lKit := .F. //Nova estrutura baseada em SKU 
						::BuscaCodCombo( ::idPedidoPai ) //Para o processo desse produto se o combo for invalido
						If ::CodComboInvalido()
							return
						endif
					EndIF
				EndIF
			EndIF
			
			//Adiciono item do pedido venda
			::AddItemPedidoVenda()
			::cupomDesconto := ::cupomOrigem
		EndIF
	Next nL

	AEval( ::itensPedidoVenda, { |x| nTotalP += ( x[3] * x[04] ), ::tabelaPreco := x[17] } )
	::aProduto   := ::itensPedidoVenda
	
	::nValor     := nTotalP
Return self

//-- Utilizando para saber o código do Combo quando KIT
METHOD BuscaCodCombo( cID ) Class Combo As Undefinied
	Local cNumero   := ''
	Local nValor    := 0
	Local i         := 0

	For i := 1 To Len( aXML )
		/* 
		1 o _ID é igual da variavel "cID" e não tem _IDPAI, OK - retorno o codigo combo "_CODcombo"
		2 o _ID é igual da variavel "cID" e TEM _IDPAI, chama recursivo o methodo BuscaCodCombo() novamente como parametro _IDPAI
		*/
		If aXML[i]:_ID:TEXT == cID .And. Type("aXML["+Str(i)+"]:_IDPAI:TEXT") == "U"
			cNumero := aXML[i]:_CODCOMBO:TEXT
			nValor  := aXML[i]:_VLTOTAL:TEXT
			Exit
		ElseIf aXML[i]:_ID:TEXT == cID .And. Type("aXML["+Str(i)+"]:_IDPAI:TEXT") <> "U"
			cNumero := ::BuscaCodCombo( aXML[i]:_ID:TEXT )
			Exit
		EndIF
	Next i

	::codigoCombo := cNumero
	::nValor      := nValor
	
Return

METHOD ExistSG1( cProdKit ) Class Combo As Logical
	Local nRecno    := 0
	local lExistSG1 := .F.

	::codigoProdutoSG1	:= ""

	//Posiciona no Produto KIT
	dbSelectArea("SG1")
	SG1->(dbSetOrder(1))
	If SG1->(dbSeek(xFilial("SG1") + cProdKit))
		While .NOT. EOF() .And. Alltrim(SG1->G1_COD) == Alltrim(cProdKit)
			nRecno   := SG1->( Recno() )
			cCodComp := SG1->G1_COMP
			nQuant	 := SG1->G1_QUANT

			::codigoProdutoSG1 := rTrim(cCodComp)

			//Executa recursivamente a carga do array
			If SG1->(dbSeek(xFilial("SG1") + cCodComp))
				::ExistSG1( cCodComp )            
			EndIf

			SG1->(DbGoTo(nRecno))
			SG1->(dbSkip())
		End
	EndIf

	lExistSG1 := !empty( ::codigoProdutoSG1 )
Return lExistSG1 

//PROT-6 | 2020042710002840 - 15/05/2020
//Tratar quando o produto for um kit mas no XML não esta preenchido o a TAG <CODCOMBO>
METHOD CodComboInvalido() Class Combo As Logical
	::lRetorno := .T.
	If empty( ::codigoCombo ) 
		::lRetorno := .F.
		::cMsgRetorno := "Erro: Tag <CODCOMBO> esta vazia, o produto é do tipo kit mas o XML não possui o todas informações do kit" + CRLF
		::cMsgRetorno += "Revise as tabelas SG1, PA8, DA1, SZI e SZJ" 
	endif
return !::lRetorno

method AddItemPedidoVenda() Class Combo As Undefinied
	local cItem     := ""
	local nTam      := TamSX3("C6_ITEM")[1]
	local aItensCbo := {}
	local i         := 0

	cItem := StrZero( Len(::itensPedidoVenda) + 1, nTam )

	//Caso o codigo GAR esteja vazio, tenta preencher com o código do XML
	if !empty( ::codigoBPAG ) .and. empty( ::codigoProdutoGAR )
		::codigoProdutoGAR := ::codigoBPAG
	endif

	//Se nao for combo inclui item manualmente
	If empty( ::codigoCombo )

		aAdd( ::itensPedidoVenda, { cItem				  ,; //[01]Item
									::codigoProduto       ,; //[02]Codigo Produto
									::quantidade          ,; //[03]Quantidade
									::valorUnitario    	  ,; //[04]Preço de Lista
									::valorUnitarioLiquido,; //[05]Valor Liquido
									::valorTotal       	  ,; //[06]Valor Total
									::codigoProdutoGAR    ,; //[07]Codigo Produto GAR
									::codigoCombo         ,; //[08]Codigo Combo
									::dataEntrega         ,; //[09]Data da Entrega
									::TES                 ,; //[10]TES
									::numeroVoucher       ,; //[11]Numero Voucher
									::quantidadeVoucher   ,; //[12]Saldo Voucher
									::origemVenda         ,; //[13]Origem Venda
									::pedidoOrigem        ,; //[14]Pedido de origem
									::idPedidoProduto  	  ,; //[15]ID Prod no Pedido (Composição) - C6_XIDPED
									::idPedidoPai         ,; //[16]ID PAI - regra de loop
									::tabelaPreco         ,; //[17]Tabela de preço
									::tipoVoucher         ,; //[18]Tipo do Voucher
									::pedidoEcommerce     ,; //[19]Pedido Ecommerce
									::cupomDesconto       ,; //[20]Cupom Desconto
									::percentualDesconto  ,; //[21]Percentual Desconto
									::valorDesconto       }; //[22]Valor do desconto
									)
	else
		//Chama metodo de carregar combo
		aItensCbo := ::CarregarItensCombo()

		//Adiciono dessa forma pois pode haver mais de um produto nesse pedido
		for i := 1 to len( aItensCbo )
			aAdd( ::itensPedidoVenda, aItensCbo[ i ] )
		next i 
	endif
return

method CarregarItensCombo() Class Combo As Array
	local aItensProd := {}

	//Calcula produtos combo
	oDesconto := CSDescontoPedido():New( ::pedidoSite			, ; //[01] Pedido site
										 ::codigoProduto		, ; //[02] Codigo produto
										 ::codigoCombo			, ; //[03] Codigo combo
										 ::codigoProdutoGAR		, ; //[04] Codigo produto GAR
										 ::quantidade			, ; //[05] Quantidade unitario
										 ::valorUnitario		, ; //[06] Valor unitario
										 ::valorUnitarioLiquido , ; //[07] Valor unitario liquido
										 ::valorTotal		   	, ; //[08] Valor total
										 ::valorTotalLiquido	, ; //[09] Valor total liquido
										 ::valorDesconto		, ; //[10] Valor desconto
										 ::percentualDesconto	, ; //[11] Percentual desconto
										 ::item					, ; //[12] Item
										 ::dataEntrega			, ; //[13] Data entrega
										 ::TES					, ; //[14] TES
										 ::numeroVoucher		, ; //[15] Numero do voucher
										 ::quantidadeVoucher	, ; //[16] Quantidade voucher
										 ::origemVenda			, ; //[17] Origem venda
										 ::pedidoOrigem			, ; //[18] Pedido Origem
										 ::idPedidoProduto		, ; //[19] Id produto pedido
										 ::idPedidoPai			, ; //[20] Id produto pai
										 ::tabelaPreco			, ; //[21] Tabela preco
										 ::tipoVoucher			, ; //[22] Tipo voucher
										 ::pedidoEcommerce		, ; //[23] Pedido Ecommerce
										 ::cupomDesconto		, ; //[24] Cumpom desconto 
										 ::KIT					, ; //[25] Kit
										 ::composicao             ; //[26] Composicao
										)

	//Pego o calculo no formato de array
	aItensProd := aClone( oDesconto:ToArray() )

	//Se der erro monta out de erro
	If len( aItensProd ) == 0
		::lRetorno := .F.
		::cMsgRetorno += "Metodo 'CarregarItensCombo()', nao carregou o combo de produtos: " + ::codigoCombo + CRLF
	endif
return aItensProd

/*/{Protheus.doc} ValidarXMLProduto
Método para inicializar a classe
@type method 
@author Bruno Vilas Boas Nunes
@since 29/05/2020
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return class - classe CSQuerySQL
/*/
method ValidarXMLProduto( oProduto, nL ) Class Combo As Logical
	::origemVenda  := ""
	If Type("aXML["+Str(nL)+"]:_ORIGEMVENDA:TEXT") <> "U"
		::origemVenda  := AllTrim( oProduto:_ORIGEMVENDA:TEXT )
	EndIf

	If Type("aXML["+Str(nL)+"]:_PEDIDOORIGEM:TEXT") <> "U"
		::pedidoOrigem := AllTrim( oProduto:_PEDIDOORIGEM:TEXT )
	EndIf

	::descricao := ""
	If Type("aXML["+Str(nL)+"]:_DESCRICAO:TEXT") <> "U"
		::descricao := AllTrim( oProduto:_DESCRICAO:TEXT )
	EndIf

	::grupo := ""
	If Type("aXML["+Str(nL)+"]:_GRUPO:TEXT") <> "U"
		::grupo := AllTrim( oProduto:_GRUPO:TEXT )
	EndIf        

	::grupoPreco := ""
	If Type("aXML["+Str(nL)+"]:_GRUPOPRECO:TEXT") <> "U"
		::grupoPreco := AllTrim( oProduto:_GRUPOPRECO:TEXT )
	EndIf        

	::idPedidoPai := ""
	If Type("aXML["+Str(nL)+"]:_IDPAI:TEXT") <> "U"
		::idPedidoPai := AllTrim( oProduto:_IDPAI:TEXT )
	ELSEIF Type("aXML["+Str(nL)+"]:_ID:TEXT") <> "U"
		::idPedidoPai := AllTrim( oProduto:_ID:TEXT )
	endIf

	::idPedidoProduto := ""
	If Type("aXML["+Str(nL)+"]:_ID:TEXT") <> "U"
		::idPedidoProduto := AllTrim( oProduto:_ID:TEXT )
	EndIf

	::tabelaPreco := ""
	If Type("aXML["+Str(nL)+"]:_TABELAPRECO:TEXT") <> "U"
		::tabelaPreco := AllTrim( oProduto:_TABELAPRECO:TEXT )
	EndIf

	::quantidade := 0
	If Type("aXML["+Str(nL)+"]:_QTD:TEXT") <> "U"
		::quantidade := Val( oProduto:_QTD:TEXT )
	EndIf        

	::valorTotal := 0
	If Type("aXML["+Str(nL)+"]:_VLTOTAL:TEXT") <> "U"
		::valorTotal := Val( AllTrim( oProduto:_VLTOTAL:TEXT ) )
	EndIf

	::valorTotalLiquido := 0
	If Type("aXML["+Str(nL)+"]:_VLTOTALLIQ:TEXT") <> "U"
		::valorTotalLiquido := Val( AllTrim( oProduto:_VLTOTALLIQ:TEXT ) )
	EndIf

	::percentualDesconto := 0
	If Type("aXML["+Str(nL)+"]:_PORCENTUALDESCONTO:TEXT") <> "U"
		::percentualDesconto := Val( AllTrim( oProduto:_PORCENTUALDESCONTO:TEXT ) )
	EndIf

	::valorDesconto := 0
	If Type("aXML["+Str(nL)+"]:_VALORDESCONTO:TEXT") <> "U"
		::valorDesconto := Val( AllTrim( oProduto:_VALORDESCONTO:TEXT ) )
	EndIf

	::valorUnitario := 0
	If Type("aXML["+Str(nL)+"]:_VLUNITARIO:TEXT") <> "U"
		::valorUnitario := Val( AllTrim( oProduto:_VLUNITARIO:TEXT ) )
	EndIf

	::valorUnitarioLiquido := ::valorUnitario - ::valorDesconto

	//-- Verifico caso o item contenha um cupom de desconto específico, recebo via parâmetro por default
	If Type("aXML["+Str(nL)+"]:_CUPOMDESCONTO:TEXT") <> "U"
		::cupomDesconto := AllTrim( oProduto:_CUPOMDESCONTO:TEXT )
	EndIf

	::codigoCombo := ""
	If Type("aXML["+Str(nL)+"]:_CODCOMBO:TEXT") <> "U"
		::codigoCombo := AllTrim( oProduto:_CODCOMBO:TEXT )
	EndIf

	//Valida campo CODBPAG
	::codigoBPAG := ""
	If type("aXML["+Str(nL)+"]:_CODBPAG:TEXT") == "U"
		::lRetorno := .F.
		::cMsgRetorno += "Erro: Tag <CODBPAG> nao existe" + CRLF
		::cMsgRetorno += varInfo( "oProduto", oProduto, , .F. )
		return
	else
		::codigoBPAG :=  AllTrim( oProduto:_CODBPAG:TEXT )
	endif

	//Valida campo CODPROD
	::codigoProduto := ""
	If type("aXML["+Str(nL)+"]:_CODPROD:TEXT") == "U"
		::lRetorno := .F.
		::cMsgRetorno := "Erro: Tag <CODPROD> nao existe" + CRLF
		::cMsgRetorno += varInfo( "oProduto", oProduto, , .F. )
		return
	else
		::codigoProduto := AllTrim( oProduto:_CODPROD:TEXT )
	endif	

return ::lRetorno


//TODO fazer um metodo de mensageria 
//METHOD infoGTOUT( cCodInfo, cMensagem )
	//U_GTPutOUT(cID,"P", ::pedidoSite, {"EXECUTAPEDIDOS",{.T., cCodInfo, ::pedidoSite, cMensagem} }, cNpSite)
//return
