#include 'Protheus.ch'
#include 'Restful.ch'
#include 'topconn.ch'
#include 'tbiconn.ch'

class produto

	data sku
	data nome
	data descricao
	data preco
	data precoPromocional
	data custo
	data ncm
	data cest
	data ativo
	data peso
	data altura
	data largura
	data profundidade
	data ean
	data marca
	data categorias
	data origem
	data endereco
	// Declaração dos Métodos da Classe
	method new() constructor
	method busca( cProd ) constructor

endclass


method new() class produto

	::sku := ""
	::nome := ""
	::descricao := ""
	::preco := 0
	::precoPromocional := 0
	::custo := 0
	::ncm := ""
	::cest := ""
	::ativo := .t.
	::peso := 0
	::altura := 0
	::largura := 0
	::profundidade := 0
	::ean := ""
	::marca := ""
	::categorias := {}
	::origem := ""
	::endereco := ""

Return Self

method busca(cProd) class produto

	local oGrupo

	sb5->(DbSetOrder(1))
	sb1->(DbSetOrder(1))
	if sb1->(dbseek(xfilial()+cProd))

		oGrupo := categorias():new()
		oGrupo:busca(sb1->b1_grupo)

		::sku := Alltrim(sb1->b1_cod)
		::nome := Alltrim(sb1->b1_desc)
		::preco := sb1->b1_prv1
		::precoPromocional := 0
		::custo := sb1->b1_custd
		::ncm := Alltrim(sb1->b1_posipi)
		::cest := Alltrim(sb1->b1_cest)
		if sb1->b1_ativo == "S"
			::ativo := .t.
		else
			::ativo := .f.
		endif
		::ean := Alltrim(sb1->b1_codbar)
		::categorias := { oGrupo }
		if sb1->b1_import == "N"
			::origem := "NACIONAL"
		elseif sb1->b1_import == "S"
			::origem := "INTERNACIONAL"
		endif
		::endereco := ""

		if sb5->(dbseek(xfilial()+cProd))
			::descricao := Alltrim(sb5->b5_ceme)
			::peso := sb5->b5_peso
			::altura := sb5->b5_altura
			::largura := sb5->b5_larg
			::profundidade := sb5->b5_ecprofu
			::marca := Alltrim(sb5->b5_marca)
		endif
	else
		::sku := ""
	endif

Return Self


	class categorias

		data id
		data nome
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cId ) constructor

	endclass


method new() class categorias

	::id	:= ""
	::nome	:= ""

Return Self


method busca(cId) class categorias

	sbm->(DbSetOrder(1))
	if sbm->(dbseek(xfilial()+cId))
		::Id	:= AllTrim(sbm->bm_grupo)
		::nome	:= Alltrim(sbm->bm_desc)
	else
		//SetRestFault(400,"Codigo de Grupo nao encontrado na base de dados!")
		::Id	:= ""
	endif

Return Self


	class saldoEst			/* Classe Saldo em estoque */

		data Codigo
		data LocPro
		data Saldo
		data SaldoValor
		data Reserva
		data QuantCompras
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cProd, cLocal ) constructor

	endclass


method new() class saldoEst

	::Codigo	:= ""
	::LocPro	:= ""
	::Saldo	 	:= 0
	::SaldoValor:= 0
	::Reserva	:= 0
	::QuantCompras:= 0

Return Self


method busca(cProd, cLocal) class saldoEst

	sb2->(DbSetOrder(1))
	if sb2->(dbseek(xfilial()+cProd+cLocal))
		::Codigo	:= cProd
		::LocPro	:= cLocal
		::Saldo	 	:= sb2->b2_qatu
		::SaldoValor:= sb2->b2_vatu1
		::Reserva	:= sb2->b2_reserva
		::QuantCompras:= sb2->b2_salpedi
	else
		//SetRestFault(400,"Saldo de Produto nao encontrado na base de dados!")
		::Codigo	:= ""
	endif

Return Self


	class itSaldoEst			/* Classe Itens da consulta de Saldo em  estoque */

		data status
		data Itens
		// Declaração dos Métodos da Classe
		method new() constructor

	endclass


method new() class itSaldoEst

	::status := 0
	::Itens	:= {}

Return Self



	class PedXFat			/* Classe lista Pedidos x Faturamento saída */

		data numero
		data status
		data dataEmissao
		data dataAtualizacao
		data pedidoShopify
		data subtotal			//Soma dos itens
		data desconto			//Valor do desconto
		data frete				//Valor do frete
		data total				//Subtotal - Desconto + Frete
		data descricaoNF
		data numeroNF
		data chaveNF
		data serieNf
		data idCliente
		data nomeCliente
		data transportadora
		data codigoFormaPagamento
		data nomeFormaPagamento
		data nomeShopify
		data enviouIntelipost
		data statusSeparacao
		data orderSeparacao
		data inicioSeparacao
		data fimSeparacao
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cnum,cDoc,cserie,nvalor ) constructor

	endclass


method new() class PedXFat

	::numero	:= ""
	::status	:= ""
	::dataEmissao := ""
	::dataAtualizacao := ""
	::pedidoShopify	:= ""
	::subtotal := 0				//Soma dos itens
	::desconto := 0				//Valor do desconto
	::frete := 0				//Valor do frete
	::total	:= 0				//Subtotal - Desconto + Frete
	::descricaoNF := ""
	::numeroNF := ""
	::chaveNF := ""
	::serieNf := 0
	::idCliente	:= ""
	::nomeCliente	:= ""
	::transportadora	:= ""
	::codigoFormaPagamento	:= ""
	::nomeFormaPagamento	:= ""
	::nomeShopify	:= ""
	::enviouIntelipost := .t.
	::statusSeparacao	:= 0
	::orderSeparacao	:= ""
	::inicioSeparacao	:= ""
	::fimSeparacao	:= ""

Return Self


method busca(cnum,cDoc,cserie,nValor,nDesc,nFrete) class PedXFat

	Local cStatus	:= ""	// FATURADO, PENDENTE, PAGO, CANCELADO
	Local cEntrada	:= ""
	Local cchvnfe	:= ""
	Local cCliefor	:= ""
	Local cLoja		:= ""
	Local cCfo 		:= ""
	Local cAliqicm  := ""
	Local cTransp	:= ""
	Local nTotal	:= 0
	Local cDupl		:= ""
	Local cPrefixo	:= ""
	Local cTipo		:= ""
	Local nSaldo 	:= 0
	Local cDtAtu	:= ""

	sc5->(DbSetOrder(1))
	sf1->(DbSetOrder(1))
	sd1->(DbSetOrder(1))
	sf2->(DbSetOrder(1))
	sd2->(DbSetOrder(3))
	sf3->(DbSetOrder(1))

	cb7->(DbSetOrder(1))
	cb8->(DbSetOrder(5))	//CB8_FILIAL + CB8_NOTA + CB8_SERIE + CB8_ITEM + CB8_SEQUEN + CB8_PROD

	sc5->(dbseek(xfilial()+cnum))
	cb8->(dbseek(xfilial()+cdoc+cserie))
	cb7->(dbseek(xfilial()+cb8->cb8_ordsep))

	if !empty(cDoc)
		sf2->(dbseek(xfilial()+cDoc+cserie+sc5->c5_cliente+sc5->c5_lojacli))
		cEntrada := sf2->f2_emissao
		cchvnfe := sf2->f2_chvnfe
		cCliefor := sf2->f2_cliente
		cLoja := sf2->f2_loja
		nValor := sf2->f2_valmerc
		nDesc := sf2->f2_descont
		nFrete := sf2->f2_frete
		nTotal	:= iif(sf2->f2_valfat==0,sf2->f2_valmerc+sf2->f2_valipi+sf2->f2_icmsret+sf2->f2_seguro+sf2->f2_despesa+sf2->f2_frete-sf2->f2_descont,sf2->f2_valfat)
		cTransp := sf2->f2_transp
		cDupl := sf2->f2_dupl
		cPrefixo := sf2->f2_prefixo
		cTipo := "NF"

		sd2->(dbseek(xfilial()+cDoc+cserie+sc5->c5_cliente+sc5->c5_lojacli))
		cCfo := sd2->d2_cf
		cAliqicm := str(sd2->d2_picm,5,2)
		//F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM,5,2)
		sf3->(dbseek(xfilial()+dtos(cEntrada)+cDoc+cSerie+cCliefor+cLoja+cCfo+cAliqicm))
		if alltrim(sf3->f3_observ) == "NF CANCELADA"
			cStatus	:= "CANCELADO"
		else
			BeginSql Alias "tse"
				%NOPARSER%
				select E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VALOR,E1_SALDO SALDO from %table:SE1% E1
				where E1_FILIAL = %xfilial:SE1% and E1_PREFIXO = %exp:cPrefixo% and E1_NUM = %exp:cDupl% 
				and E1_TIPO = %exp:cTipo% and E1_SALDO > 0 and E1.%NOTDEL%
			EndSql
			while !tse->(eof())
				nSaldo += tse->saldo
				tse->(dbskip())
			end
			tse->(dbclosearea())
			if nSaldo == 0
				cStatus	:= "PAGO"		//FATURADO, PAGO, CANCELADO
			else
				cStatus	:= "FATURADO"
			endif
		endif
	else
		nTotal := nValor - nDesc + nFrete
		cTransp := sc5->c5_transp
		if sc5->c5_nota == "XXXXXXXXX"
			cStatus	:= "PEDIDO CANCELADO"	// PENDENTE ou PEDIDO CANCELADO
		else
			cStatus	:= "PENDENTE"
		endif
	endif

	if !empty(sc5->c5_xdtatu)
		cDtAtu := transform(dtos(sc5->c5_xdtatu),"@R 9999-99-99")
		if !empty(sc5->c5_xhratu)
			cDtAtu += " "+transform(sc5->c5_xhratu,"@R 99:99:99")
		endif
	endif

	::numero := cnum
	::status := cStatus
	::dataEmissao := iif( empty(sc5->c5_emissao),"", transform(dtos(sc5->c5_emissao),"@R 9999-99-99") )
	::dataAtualizacao := cDtAtu
	::pedidoShopify	:= alltrim(sc5->c5_xpedshp)
	::subtotal := nValor
	::desconto := nDesc
	::frete := nFrete
	::total	:= nTotal
	::descricaoNF := ""
	::numeroNF := cDoc
	::chaveNF := cchvnfe
	::serieNf := val(cserie)
	::idCliente	:= alltrim(sc5->c5_cliente)
	::nomeCliente := alltrim(EncodeUTF8( sc5->c5_xclifor, "cp1252"))
	::transportadora := alltrim(Posicione( 'SA4', 1, xFilial('SA4')+cTransp, 'A4_NREDUZ'))
	::codigoFormaPagamento := sc5->c5_xformpg
	::nomeFormaPagamento := alltrim(Posicione( 'SX5', 1, xFilial('SX5')+'ZX'+sc5->c5_xformpg,'X5_DESCRI'))
	::nomeShopify := alltrim(sc5->c5_nmeshp)
	::enviouIntelipost := iif(sc5->c5_xinteli=="1",.t.,.f.)
	::statusSeparacao	:= val(	CVALTOCHAR(POSICIONE('CB7',1,XFILIAL('CB7')+FORMULA('OSP'),'CB7_STATUS')) )
	::orderSeparacao	:= sc5->c5_xords
	::inicioSeparacao	:= iif( empty(cb7->cb7_dtinis),"", transform(dtos(cb7->cb7_dtinis),"@R 9999-99-99")+" "+transform(alltrim(cb7->cb7_hrinis),"@R 99:99:99" ) )
	::fimSeparacao	:= iif( empty(cb7->cb7_dtfims),"", transform(dtos(cb7->cb7_dtfims),"@R 9999-99-99")+" "+transform(alltrim(cb7->cb7_hrfims),"@R 99:99:99" ) )

Return Self


	class lstPedXFat			/* Classe Lista de pedidos x faturamento saída */

		data Itens
		// Declaração dos Métodos da Classe
		method new() constructor

	endclass


method new() class lstPedXFat

	::Itens	:= {}

Return Self

	WsRestful wsDolado  Description 'Integração Protheus X SHOPIFY (diversos)' FORMAT "application/json"

		WsData CodPro AS Character
		WsData LocPro AS Character

		WsData DtEmi1 AS Character
		WsData DtEmi2 AS Character
		WsData DtAtu1 AS Character
		WsData DtAtu2 AS Character

		WsMethod POST PRODUTO Description 'Incluir Produto no protheus'  WsSyntax "/Produto" path "/Produto"
		WsMethod PUT  PRODUTO Description 'Alterar Produto no Protheus'  WsSyntax "/Produto" path "/Produto"
		WsMethod DELETE PRODUTO Description 'Excluir Produto no Protheus' WsSyntax "/Produto" path "/Produto"
		WsMethod GET  PRODUTO Description 'Consultar Produtos'           WsSyntax "/Produto?CodPro=valueParam1" path "/Produto"

		WsMethod GET SALDO   Description 'Consultar Saldos de produtos no Estoque' WsSyntax "/Saldo?CodPro=valueParam1&LocPro=valueParam2" path "/Saldo"
		WsMethod GET PEDXFAT Description 'Lista Pedidos X Notas fiscais de saída'  WsSyntax "/PedXFat?DtEmi1=valueParam1&DtEmi2=valueParam2&DtAtu1=valueParam3&DtAtu2=valueParam4" path "/PedXFat"

		WsMethod PUT ATUPED Description 'Liberação do pedido de vendas no Protheus'  WsSyntax "/AtuPed" path "/AtuPed"

	End WsRestful


WsMethod POST PRODUTO WsService wsDolado

	Local lRet 	  := .t.
	Local cMens	  := ""
	Local oJson   := JsonObject():New()
	Local oResp   := JsonObject():New()
	Local cBody   := ::GetContent()

	::SetContentType("application/json; charset=utf-8")

	if u_critJson(cBody,@cMens)
		oJson:fromJson(cBody)
		if critProd(3,oJson,@cMens)
			if cadProd(3,oJson,@cMens)
				oResp['Status'] := 201
			else
				lRet := .f.
				oResp['Status'] := 400
			endif
		else
			lRet := .f.
			oResp['Status'] := 404
		endif
	else
		lRet := .f.
		oResp['Status'] := 400
	endif
	oResp['Message']:= EncodeUTF8( cMens, "cp1252")

	::SetResponse(oResp:toJson())

Return lRet


WsMethod PUT PRODUTO WsService wsDolado

	Local lRet 	  := .t.
	Local cMens	  := ""
	Local oJson   := JsonObject():New()
	Local oResp   := JsonObject():New()
	Local cBody   := ::GetContent()

	::SetContentType("application/json; charset=utf-8")

	if u_critJson(cBody,@cMens)
		oJson:fromJson(cBody)
		if critProd(4,oJson,@cMens)
			if cadProd(4,oJson,@cMens)
				oResp['Status'] := 201
			else
				lRet := .f.
				oResp['Status'] := 400
			endif
		else
			lRet := .f.
			oResp['Status'] := 404
		endif
	else
		lRet := .f.
		oResp['Status'] := 400
	endif
	oResp['Message']:= EncodeUTF8( cMens, "cp1252")

	::SetResponse(oResp:toJson())

Return lRet


WsMethod DELETE PRODUTO WsService wsDolado

	Local lRet 	  := .t.
	Local cMens	  := ""
	Local oJson   := JsonObject():New()
	Local oResp   := JsonObject():New()
	Local cBody   := ::GetContent()

	::SetContentType("application/json; charset=utf-8")

	if u_critJson(cBody,@cMens)
		oJson:fromJson(cBody)
		if critProd(5,oJson,@cMens)
			if cadProd(5,oJson,@cMens)
				oResp['Status'] := 201
			else
				lRet := .f.
				oResp['Status'] := 400
			endif
		else
			lRet := .f.
			oResp['Status'] := 404
		endif
	else
		lRet := .f.
		oResp['Status'] := 400
	endif
	oResp['Message']:= EncodeUTF8( cMens, "cp1252")

	::SetResponse(oResp:toJson())

Return lRet


WsMethod GET PRODUTO WsReceive CodPro WsService wsDolado

	Local lRet 	  := .t.
	Local cCodPro := ""

	Local nI      := 0
	Local cDes    := ""
	Local aPro    := {}
	Local oPro
	Local oJson   := JsonObject():New()
	Local oResp   := JsonObject():New()

	Default self:CodPro := ""

	cCodPro := self:CodPro

	::SetContentType("application/json; charset=utf-8")

	cCodPro := Padr(cCodPro ,TamSx3("B1_COD")[1])

	oPro:=produto():new()
	oPro:busca(cCodPro)
	if empty(oPro:sku)
		lRet := .f.
		oResp['Status'] := 404
		oResp['Message']:= EncodeUTF8( "O sku "+alltrim(cCodPro)+" não esta cadastrado!", "cp1252")
	else
		aPro := ClassDataArr(oPro)
		for nI := 1 to len(aPro)
			if &('oPro:'+lower(aPro[nI,1])) != nil
				cDes := 'oJson["'+lower(aPro[nI,1])+'"]'
				&cDes := u_atribJson(oPro,aPro[nI,1])
			endif
		next nI
		oResp := oJson
	endif

	::SetResponse(oResp:toJson())

Return lRet


WsMethod GET SALDO WsReceive CodPro, LocPro WsService wsDolado

	Local lRet 	  := .t.
	Local cCodPro := ""
	Local cLocPro := ""

	Local nI      := 0
	Local cDes    := ""
	Local aIte    := {}
	Local oIte
	Local oPro
	Local oJson   := JsonObject():New()
	Local oResp   := JsonObject():New()
	//Local cBody   := ::GetContent()

	Default self:CodPro := ""
	Default self:LocPro := ""

	cCodPro := self:CodPro
	cLocPro := self:LocPro

	::SetContentType("application/json; charset=utf-8")

	if !empty(cCodPro)
		cCodPro := Padr(cCodPro ,TamSx3("B1_COD")[1])
	endif

	if !empty(cCodPro)
		if !empty(cLocPro)
			BeginSql Alias "trb"
				%NOPARSER%
				select * from %TABLE:SB2% B2
				INNER JOIN %TABLE:SB1% B1 ON B1_FILIAL = %XFILIAL:SB1% AND B1_COD = B2_COD AND B1.%NOTDEL%
				WHERE B2_FILIAL = %XFILIAL:SB2% AND B2_COD = %exp:cCodPro% AND B2_LOCAL = %exp:cLocPro%
				AND B2.%NOTDEL%
			EndSql
		else
			BeginSql Alias "trb"
				%NOPARSER%
				select * from %TABLE:SB2% B2
				INNER JOIN %TABLE:SB1% B1 ON B1_FILIAL = %XFILIAL:SB1% AND B1_COD = B2_COD AND B1.%NOTDEL%
				WHERE B2_FILIAL = %XFILIAL:SB2% AND B2_COD = %exp:cCodPro% AND B2.%NOTDEL%
			EndSql
		endif
	else
		BeginSql Alias "trb"
			%NOPARSER%
			select * from %TABLE:SB2% B2
			INNER JOIN %TABLE:SB1% B1 ON B1_FILIAL = %XFILIAL:SB1% AND B1_COD = B2_COD AND B1.%NOTDEL%
			WHERE B2_FILIAL = %XFILIAL:SB2% AND B2.%NOTDEL%
		EndSql
	endif
	if !trb->(eof())
		oIte:=itSaldoEst():new()
		oIte:status := 200
		while !trb->(eof())
			oPro:=saldoEst():new()
			//oPro:busca(trb->b2_cod, trb->b2_local)
			oPro:Codigo	:= alltrim(trb->b2_cod)
			oPro:LocPro	:= trb->b2_local
			oPro:Saldo	:= trb->b2_qatu
			oPro:SaldoValor:= trb->b2_vatu1
			oPro:Reserva:= trb->b2_reserva
			oPro:QuantCompras:= trb->b2_salpedi
			aadd(oIte:itens, oPro )
			trb->(dbskip())
		end
		aIte := ClassDataArr(oIte)
		for nI := 1 to len(aIte)
			if &('oIte:'+lower(aIte[nI,1])) != nil
				cDes := 'oJson["'+lower(aIte[nI,1])+'"]'
				&cDes := u_atribJson(oIte,aIte[nI,1])
			endif
		next nI

		oResp := oJson
	else
		oResp['Status'] := 204
		oResp['Message']:= EncodeUTF8( "Saldo do produto não foi encontrado", "cp1252")
	endif
	trb->(dbclosearea())
	::SetResponse(oResp:toJson())

Return lRet


WsMethod GET PEDXFAT WsReceive DtEmi1, DtEmi2, DtAtu1, DtAtu2 WsService wsDolado

	Local lRet 	  := .t.
	Local cDtEmi1 := ""
	Local cDtEmi2 := ""
	Local cDtAtu1 := ""
	Local cHrAtu1 := ""
	Local cDtAtu2 := ""
	Local cHrAtu2 := ""

	Local nI      := 0
	Local cDes    := ""
	Local aLst    := {}
	Local oLst
	Local oPxF

	Local oJson   := JsonObject():New()
	Local oResp   := JsonObject():New()
	//Local cBody   := ::GetContent()

	Default self:DtEmi1 := ""
	Default self:DtEmi2 := alltrim(dtos(date()+365))
	Default self:DtAtu1 := ""
	Default self:DtAtu2 := alltrim(dtos(date()+365))

	cDtEmi1 := replace(self:DtEmi1,"-","")
	cDtEmi2 := replace(self:DtEmi2,"-","")
	if at(' ',self:DtAtu1) == 0
		cDtAtu1 := replace(self:DtAtu1,"-","")
		cHrAtu1 := ""
	else
		cDtAtu1 := replace(substr(self:DtAtu1,1,at(' ',self:DtAtu1)-1),"-","")
		cHrAtu1 := replace(substr(self:DtAtu1,at(' ',self:DtAtu1)+1,8),":","")
	endif
	if at(' ',self:DtAtu2) == 0
		cDtAtu2 := replace(self:DtAtu2,"-","")
		cHrAtu2 := "235959"
	else
		cDtAtu2 := replace(substr(self:DtAtu2,1,at(' ',self:DtAtu2)-1),"-","")
		cHrAtu2 := replace(substr(self:DtAtu2,at(' ',self:DtAtu2)+1,8),":","")
	endif

	::SetContentType("application/json; charset=utf-8")

	BeginSql Alias "trb"
		%NOPARSER%
		SELECT C5_NUM,C5_FRETE,C6_NOTA,C6_SERIE,SUM(C6_VALOR) C6_VALOR,SUM(C6_VALDESC) C6_VALDESC FROM %TABLE:SC5% C5
		INNER JOIN %TABLE:SC6% C6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.%NOTDEL% 
		WHERE C5_FILIAL = %XFILIAL:SC5% AND C5.%NOTDEL% AND C5.C5_TIPO NOT IN ('D','B')
		AND C5_EMISSAO >= %exp:cDtEmi1% AND C5_EMISSAO <= %exp:cDtEmi2%
		AND C5_XDTATU >= %exp:cDtAtu1% AND C5_XDTATU <= %exp:cDtAtu2%
        AND C5_XHRATU >= %exp:cHrAtu1% AND C5_XHRATU <= %exp:cHrAtu2%
		GROUP BY C5_NUM,C5_FRETE,C6_NOTA,C6_SERIE
	EndSql

	if !trb->(eof())
		oLst:=lstPedXFat():new()
		while !trb->(eof())
			oPxF:=PedXFat():new()
			oPxF:busca(trb->c5_num,trb->c6_nota,trb->c6_serie,trb->c6_valor,trb->c6_valdesc,trb->c5_frete)
			aadd(oLst:Itens, oPxF )
			trb->(dbskip())
		end

		aLst := ClassDataArr(oLst)
		for nI := 1 to len(aLst)
			if &('oLst:'+lower(aLst[nI,1])) != nil
				cDes := 'oJson["'+lower(aLst[nI,1])+'"]'
				&cDes := u_atribJson(oLst,aLst[nI,1])
			endif
		next nI

		oResp := oJson
	else
		oResp['Status'] := 204
		oResp['Message']:= EncodeUTF8( "Nenhum pedido encontrado", "cp1252")
	endif
	trb->(dbclosearea())
	::SetResponse(oResp:toJson())

Return lRet


WsMethod PUT ATUPED WsService wsDolado

	Local lRet 	  := .t.

	Local cNumSho := ""
	Local aItens  := {}
	Local cMens	  := ""

	Local oJson   := JsonObject():New()
	Local oResp   := JsonObject():New()
	Local cBody   := ::GetContent()

	::SetContentType("application/json; charset=utf-8")

	if u_critJson(cBody,@cMens)
		oJson:fromJson(cBody)

		cNumSho := oJson['C5_XPEDSHP']
		aItens  := oJson['SC6']

		if empty(aItens) .or. len(aItens) == 0
			lRet := .f.
			oResp['Status'] := 404
			oResp['Message']:= EncodeUTF8( "Os itens do pedido "+alltrim(cNumSho)+" não foram encaminhados!", "cp1252")
		else
			sc5->( DbSetOrder(11) )
			if sc5->(dbseek(cNumSho))
				if atuPed(sc5->c5_num,aItens,@cMens)
					oResp['Status'] := 201
					oResp['Message']:= EncodeUTF8( "Alteração do pedido "+alltrim(cNumSho)+" realizada com sucesso", "cp1252")
				else
					lRet := .f.
					oResp['Status'] := 400
					oResp['Message']:= EncodeUTF8( cMens, "cp1252")
				endif
			else
				lRet := .f.
				oResp['Status'] := 404
				oResp['Message']:= EncodeUTF8( "O pedido "+alltrim(cNumSho)+" não existe!", "cp1252")
			endif

		endif
	else
		lRet := .f.
		oResp['Status'] := 400
		oResp['Message']:= EncodeUTF8( cMens, "cp1252")
	endif

	::SetResponse(oResp:toJson())

Return lRet


Static Function critProd(nOpc,oJson,cMens)	//nOpc => 3-inclusão; 4-alteração; 5-Exclusão
	Local lRet := .t.
	Local oProd := produto():new()
	Local cCodPro := Padr(oJson['sku'] ,TamSx3("B1_COD")[1])
	Local cLocal := "02"
	Local cGrupo := Padr("" ,TamSx3("B1_GRUPO")[1] )

	u_atribObj(oJson,@oProd)

	sb1->(DbSetOrder(1))
	sb1->(dbseek(xfilial()+cCodPro))
	if !sb1->(eof())
		if nOpc == 3
			lRet := .f.
			cMens := "O sku "+alltrim(cCodPro)+" já esta cadastrado. "
		endif
	elseif nOpc != 3
		lRet := .f.
		cMens := "O sku "+alltrim(cCodPro)+" não esta cadastrado. "
	endif

	if nOpc != 5
		if len(oProd:categorias) > 0
			cGrupo := Padr( oProd:categorias[1]["id"] ,TamSx3("B1_GRUPO")[1] )
		endif
		if !empty(cGrupo)
			sbm->(DbSetOrder(1))
			if !sbm->(dbseek(xfilial()+cGrupo))
				lRet := .f.
				cMens += "O Codigo de Grupo "+cGrupo+" nao foi encontrado na base de dados. "
			endif
		endif
		if oJson['endereco'] != nil
			if !empty(oProd:endereco)
				sbe->(DbSetOrder(1))
				if !sbe->(dbseek(xfilial()+cLocal+oProd:endereco))
					cMens += "O endereço "+oProd:endereco+" não esta cadastrado. "
				endif
			endif
		endif
	endif

Return lRet


Static Function cadProd(nOpc,oJson,cMens)	//nOpc => 3-inclusão; 4-alteração; 5-Exclusão

	Local lRet := .t.
	Local cGrupo := ""
	Local cImport := ""
	Local cAtivo := ""
	Local cMsblql := ""
	Local cLocal := ""
	Local cLocaliz := ""
	Local cOperaca := iif(nOpc == 3, "Inclusão",iif(nOpc == 4, "Alteração",iif(nOpc == 5, "Exclusão","Outra")))

	Local aErro := {}
	Local oModel
	Local oSB1Mod
	Local oSB5Mod
	Local oProd := produto():new()
	/*
	oProd:sku := iif(oJson['sku']==nil,"",Alltrim(Padr(oJson['sku'] ,TamSx3("B1_COD")[1])))
	oProd:nome := iif(oJson['nome']==nil,"",Alltrim(oJson['nome']) )
	oProd:descricao := iif(oJson['descricao']==nil,"",Alltrim(oJson['descricao']) )
	oProd:preco := iif(oJson['preco']==nil,0,oJson['preco'] )
	oProd:precoPromocional := iif(oJson['precoPromocional']==nil,0,oJson['precoPromocional'] )
	oProd:custo := iif(oJson['custo']==nil,0,oJson['custo'] )
	oProd:ncm := iif(oJson['ncm']==nil,"",Alltrim(oJson['ncm']) )
	oProd:cest := iif(oJson['cest']==nil,"",Alltrim(oJson['cest']) )
	oProd:ativo := iif(oJson['ativo']==nil,.t.,oJson['ativo'] )
	oProd:peso := iif(oJson['peso']==nil,0,oJson['peso'] )
	oProd:altura := iif(oJson['altura']==nil,0,oJson['altura'] )
	oProd:largura := iif(oJson['largura']==nil,0,oJson['largura'] )
	oProd:profundidade := iif(oJson['profundidade']==nil,0,oJson['profundidade'] )
	oProd:ean := iif(oJson['ean']==nil,"",Alltrim(oJson['ean']) )
	oProd:marca := iif(oJson['marca']==nil,"",Alltrim(oJson['marca']) )
	oProd:categorias := iif(oJson['categorias']==nil,{},oJson['categorias'] )
	oProd:origem := iif(oJson['origem']==nil,"",Alltrim(oJson['origem']) )
	oProd:endereco := iif(oJson['endereco']==nil,"",Alltrim(oJson['endereco']) )
	*/
	u_atribObj(oJson,@oProd)

	if len(oProd:categorias) > 0
		cGrupo := oProd:categorias[1]["id"]
	else
		cGrupo := ""
	endif
	if oProd:origem == "NACIONAL"
		cImport := "N"
	elseif oProd:origem == "INTERNACIONAL"
		cImport := "S"
	endif
	if oJson['ativo'] != nil
		if oProd:ativo
			cAtivo := "S"
			cMsblql := "2"
		else
			cAtivo := "N"
			cMsblql := "1"
		endif
	endif
	cLocal := "02"
	if oJson['endereco'] != nil
		if empty(oProd:endereco)
			cLocaliz := "N"
		else
			cLocaliz := "S"
		endif
	endif

	//Pegando o modelo de dados
	oModel:=FWLoadModel("MATA010")
	oModel:SetOperation(nOpc)
	oModel:Activate()
	if nOpc != 5
		//Pegando o model e setando os campos
		oSB1Mod := oModel:GetModel("SB1MASTER")
		if nOpc == 3
			oSB1Mod:SetValue("B1_COD"    , oProd:sku )
		endif
		if !empty(oProd:nome)
			oSB1Mod:SetValue("B1_DESC"   , FwCutOff(DecodeUTF8(oProd:nome, "cp1252"), .t.) )
		endif
		if nOpc == 3
			oSB1Mod:SetValue("B1_TIPO"   , "PA" )
			oSB1Mod:SetValue("B1_UM"     , "UN" )
			oSB1Mod:SetValue("B1_LOCPAD" , cLocal )
		endif
		if !empty(cGrupo)
			oSB1Mod:SetValue("B1_GRUPO"  , cGrupo )
		endif
		if oProd:preco != 0
			oSB1Mod:SetValue("B1_PRV1"   , oProd:preco )
		endif
		if oProd:custo != 0
			oSB1Mod:SetValue("B1_CUSTD"  , oProd:custo )
		endif
		if !empty(cLocaliz)
			oSB1Mod:SetValue("B1_LOCALIZ", cLocaliz )
		endif
		if !empty(cImport)
			oSB1Mod:SetValue("B1_IMPORT" , cImport )
		endif
		if !empty(cAtivo)
			oSB1Mod:SetValue("B1_ATIVO"  , cAtivo )
			oSB1Mod:SetValue("B1_MSBLQL" , cMsblql )
		endif
		if !empty(oProd:ncm)
			oSB1Mod:SetValue("B1_POSIPI" , oProd:ncm )
		endif
		if !empty(oProd:ean)
			oSB1Mod:SetValue("B1_CODBAR" , oProd:ean )
		endif
		if !empty(oProd:cest)
			oSB1Mod:SetValue("B1_CEST"   , oProd:cest )
		endif
		//Setando o complemento do produto
		oSB5Mod := oModel:GetModel("SB5DETAIL")
		If oSB5Mod != Nil
			if !empty(oProd:descricao)
				oSB5Mod:SetValue("B5_CEME"   , FwCutOff(DecodeUTF8(oProd:descricao, "cp1252"), .t.)	 )
			endif
			if !empty(oProd:marca)
				oSB5Mod:SetValue("B5_MARCA"  , oProd:marca )
			endif
			if oProd:peso != 0
				oSB5Mod:SetValue("B5_PESO"  , oProd:peso )
			endif
			if oProd:altura != 0
				oSB5Mod:SetValue("B5_ALTURA"  , oProd:altura )
			endif
			if oProd:largura != 0
				oSB5Mod:SetValue("B5_LARG"  , oProd:largura )
			endif
			if oProd:profundidade != 0
				oSB5Mod:SetValue("B5_ECPROFU"  , oProd:profundidade )
			endif
		endIf
	endif
	//Se conseguir validar as informações
	If oModel:VldData()
		If !oModel:CommitData()
			lRet := .f.
		EndIf
	Else
		lRet := .f.
	endIf
	//Se não deu certo a inclusão, mostra a mensagem de erro
	If lRet
		cMens := cOperaca+" do sku "+alltrim(oProd:sku)+" realizada com sucesso"
	else
		//Busca o Erro do Modelo de Dados
		aErro := oModel:GetErrorMessage()
		//Monta o Texto que será mostrado na tela
		//cMens += "Id do formulário de origem:"  + ' [' + cValToChar(aErro[01]) + '], '
		//cMens += "Id do campo de origem: "      + ' [' + cValToChar(aErro[02]) + '], '
		//cMens += "Id do formulário de erro: "   + ' [' + cValToChar(aErro[03]) + '], '
		cMens += "Id do campo de erro: "        + ' [' + cValToChar(aErro[04]) + '], '
		//cMens += "Id do erro: "                 + ' [' + cValToChar(aErro[05]) + '], '
		cMens += "Mensagem do erro: "           + ' [' + cValToChar(aErro[06]) + '], '
		cMens += "Mensagem da solução: "        + ' [' + cValToChar(aErro[07]) + '], '
		cMens += "Valor atribuído: "            + ' [' + cValToChar(aErro[08]) + '], '
		cMens += "Valor anterior: "             + ' [' + cValToChar(aErro[09]) + ']'
	EndIf
	//Desativa o modelo de dados
	oModel:DeActivate()

Return lRet


static function atuPed(cNumPed,aItens,cMens)

	Local nX := 0
	Local nI := 0
	Local aItem := {}
	//Local aLinha := {}
	//Local aSC6Itens := {}

	Local cItem := ""
	Local cProduto := ""
	Local nQtdlib := 0
	Local nTotlib := 0
	Local nTotVen := 0

	Local cProdfil := ""
	Local nQtdfil := 0
	Local aEst := {}
	Local nEst := 0

	Local lFaz := .t.

	for nX := 1 to Len( aItens )
		cItem := aItens[nX]['C6_ITEM']
		cProduto := aItens[nX]['C6_PRODUTO']
		nQtdlib := aItens[nX]['C6_QTDLIB']

		aEst := retEstrut(cProduto,nQtdlib)
		nEst := len(aEst)
		if nEst > 0
			for nI := 1 to nEst
				cProdfil := aEst[nI,1]
				nQtdfil := aEst[nI,2]
				sc6->( DbSetOrder(2) )
				if sc6->(dbseek(xfilial()+cNumPed+cProdfil))
					while sc6->(eof()) .and. sc6->c6_num == cNumPed .and. sc6->c6_produto == cProdfil
						if sc6->c6_xcodkit == cProduto
							if sc6->c6_qtdent > 0 .or. !empty(sc6->c6_nota)
								lFaz := .f.
								cMens += "O Produto "+sc6->c6_item+"/"+alltrim(sc6->c6_produto)+" já foi faturado. "
							elseif nQtdfil > 0 .and. sc6->c6_qtdven != nQtdfil
								lFaz := .f.
								cMens += "A quantidade para liberar o Produto "+sc6->c6_item+"/"+alltrim(sc6->c6_produto)+" não é válida. "
							endif
							cItem := sc6->c6_item
						endif
						sc6->(dbskip())
					end
					nTotlib += nQtdfil
					aadd(aItem,cItem)
				else
					lFaz := .f.
					cMens += "O Produto "+sc6->c6_item+"/"+alltrim(sc6->c6_produto)+" não foi encontrado. "
				endif
			next
		else
			sc6->( DbSetOrder(1) )
			if sc6->(dbseek(xfilial()+cNumPed+cItem+cProduto))
				if sc6->c6_qtdent > 0 .or. !empty(sc6->c6_nota)
					lFaz := .f.
					cMens += "O Produto "+sc6->c6_item+"/"+alltrim(sc6->c6_produto)+" já foi faturado. "
				elseif nQtdlib > 0 .and. sc6->c6_qtdven != nQtdlib
					lFaz := .f.
					cMens += "A quantidade para liberar o Produto "+sc6->c6_item+"/"+alltrim(sc6->c6_produto)+" não é válida. "
				endif
			else
				lFaz := .f.
				cMens += "O Produto "+sc6->c6_item+"/"+alltrim(sc6->c6_produto)+" não foi encontrado. "
			endif
			nTotlib += nQtdlib
			aadd(aItem,cItem)
		endif

	next nX

	if lFaz
		sc6->( DbSetOrder(1) )
		sc6->(DbSeek(xFilial()+cNumPed))
		While !sc6->(eof()) .and. sc6->c6_num == cNumPed
			if ascan(aItem,sc6->c6_item) == 0
				lFaz := .f.
				cMens += "O Produto "+sc6->c6_item+"/"+alltrim(sc6->c6_produto)+" não foi encaminhado. "
			endif

			nTotVen += sc6->c6_qtdven
			sc6->(dbskip())
		End
	endif

	if lFaz .and. nTotlib > 0 .and. nTotVen != nTotlib
		lFaz := .f.
		cMens += "A qtd total a liberar ("+alltrim(str(nTotlib))+") não corresponde a qtd total vendida ("+alltrim(str(nTotVen))+"). "
	endif

	if lFaz

		Begin Transaction

			sc9->( DbSetOrder(1) )
			sc6->( DbSetOrder(1) )

			for nX := 1 to Len( aItens )

				cItem := aItens[nX]['C6_ITEM']
				cProduto := aItens[nX]['C6_PRODUTO']
				nQtdlib := aItens[nX]['C6_QTDLIB']

				if sc6->(dbseek(xfilial()+cNumPed+cItem+cProduto))
					sc9->(DbSeek(xFilial()+sc6->c6_num+sc6->c6_item))
					While  !sc9->(Eof()) .and. sc9->(c9_filial+c9_pedido+c9_item) == sc9->(xFilial())+SC6->(C6_NUM+C6_ITEM)
						sc9->(a460Estorna(.t.))
						sc9->(DbSkip())
					End

					if nTotlib > 0
						nQtdLib := MaLibDoFat(sc6->(RecNo()),nQtdlib,.t./*lcredito*/,.t./*lestoque*/,.f.,.f.,.f./*lLiber*/,.f./*lTrsnf*/)
						a450Grava(1,.t.,.t.)
						//sc6->(MaLiberOk({cNumPed},.F.))
						if nQtdLib != sc6->c6_qtdven
							sc9->(DbSeek(xFilial()+sc6->c6_num+sc6->c6_item))
							While  !sc9->(Eof()) .and. sc9->(c9_filial+c9_pedido+c9_item) == sc9->(xFilial())+SC6->(C6_NUM+C6_ITEM)
								sc9->(a460Estorna(.t.))
								sc9->(DbSkip())
							End
							lFaz := .f.
							cMens += "O Produto "+sc6->c6_item+"/"+alltrim(sc6->c6_produto)+" não foi liberado. "
						endif
					else
						sc6->(RecLock("SC6",.f.))
						sc6->c6_blq := "R"
						sc6->(MsUnlock())
					endif
				endif
			next nX

			if lFaz
				if nTotlib == 0
					sc5->(RecLock("SC5", .f.))
					sc5->c5_nota := Replicate("X",TamSx3("C5_NOTA")[1])
					sc5->(MsUnLock())
				else
					sc5->(RecLock("SC5", .f.))
					sc5->c5_liberok := "S"
					sc5->(MsUnLock())
				endif
			endif

		End Transaction

	endif

Return lFaz


Static Function retEstrut(cPrdPai,nQtdPai)

	Local aRet := {}
	Local aEst := {}
	Local nI := 0
	Local cQuery := ""
	Local cAlias := GetNextAlias()

	cQuery := "select g1_filial,g1_cod,g1_comp,g1_quant from "+RetSQLName("SG1")+" g1 "
	cQuery += "where g1_filial = '"+xFilial("SG1")+"' and g1_cod = '"+cPrdPai+"' and g1.d_e_l_e_t_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.f.,.t.)
	while (cAlias)->( !eof() )
		aEst := retEstrut((cAlias)->g1_comp,nQtdPai*(cAlias)->g1_quant)
		if len(aEst) > 0
			for nI := 1 to len(aEst)
				aadd( aRet, {aEst[nI,1],aEst[nI,2],aEst[nI,3],aEst[nI,4]} )
			next
		else
			aadd( aRet, {(cAlias)->g1_comp,nQtdPai*(cAlias)->g1_quant,cPrdPai,nQtdPai} )
		endif

		(cAlias)->(dbskip())
	end

	(cAlias)->( DbCloseArea() )

Return aRet


User function prodOper(cEmp,cFil,cMod,cOpc,cCod,cCompl,cErro)
	Local lRet := .t.
	Local oProd
	Local lJob := ( Select( "SX6" ) == 0 )

	if lJob
		RpcSetType( 3 )
		lRet := RpcSetEnv( cEmp, cFil, , , cMod )
	endif
	if lRet
		oProd:=produto():new()
		oProd:busca(cCod)
		u_dolp002("P",cOpc,oProd,sb1->(xfilial()),cCod,"",@cErro)
		FreeObj(oProd)
		if !empty(cErro)
			lRet := .f.
		endif
		if lJob
			RpcClearEnv()
		endif
	endif

Return lRet


user function teste()

	Local lRet 	  := .t.
	/*
	Local cNumSho := ""
	Local aItens  := {}
	Local cMens	  := ""

	Local oJson   := JsonObject():New()
	Local oResp   := JsonObject():New()
	Local cBody   := '{ "C5_XPEDSHP": "4496863756451", "SC6": [{"C6_ITEM": "01","C6_PRODUTO": "CAR-AL9006-V8","C6_QTDVEN": 25,"C6_QTDLIB": 0},{"C6_ITEM": "02","C6_PRODUTO": "CAR-V8/8112","C6_QTDVEN": 25,"C6_QTDLIB": 0},{"C6_ITEM": "03","C6_PRODUTO": "CBO-TC-25W","C6_QTDVEN": 20,"C6_QTDLIB": 0},{"C6_ITEM": "04","C6_PRODUTO": "BRA-5.5","C6_QTDVEN": 5,"C6_QTDLIB": 0},{ "C6_ITEM": "05","C6_PRODUTO": "SUP-AR","C6_QTDVEN": 10,"C6_QTDLIB": 0},{"C6_ITEM": "06","C6_PRODUTO": "FON-LE360","C6_QTDVEN": 1,"C6_QTDLIB": 0},{"C6_ITEM": "07","C6_PRODUTO": "CX-SPK-01","C6_QTDVEN": 3,"C6_QTDLIB": 0},{"C6_ITEM": "08","C6_PRODUTO": "CAR-AL9006-TC","C6_QTDVEN": 25,"C6_QTDLIB": 0},{"C6_ITEM": "09","C6_PRODUTO": "CBO-SJX03-2","C6_QTDVEN": 20,"C6_QTDLIB": 0}]} '

	Local oJson   := JsonObject():New()
	Local cBody   := '{ "sku": "ABC-123","nome": "Produto ABC","descricao": "Descrição produto ABC","preco": 34.5,"precoPromocional": 34.5,"custo": 12.5,"ncm": "96081000","cest": "1200700","ativo": false,"peso": 0.100,"altura": 10,"largura": 10,"profundidade": 10,"ean": "08","marca": "Apple","categorias": [ { "id": "0014", "nome": "Capas"} ],  "origem": "NACIONAL", "endereco": "C.004.03.D" } '
	Local cMens   := ""
	Local oPro
	*/

	//Listagem de pedido de venda
	Local cDtEmi1 := replace("2022-07-01","-","")
	Local cDtEmi2 := replace("2022-07-31","-","")
	Local cDtAt1 := ""
	Local cDtAt2 := "2022-07-31 23:59:59"
	Local cDtAtu1 := ""
	Local cHrAtu1 := ""
	Local cDtAtu2 := ""
	Local cHrAtu2 := ""

	RpcSetType( 3 )
	RpcSetEnv( "01", "0101", , , "FAT" )
	/*
	oJson:fromJson(cBody)
	oPro:=produto():new()
	oPro:busca(oJson['sku'])
	u_atribObj(oJson,@oPro)
	if critProd(4,oJson,@cMens)
		alert("ok")
	else
		alert("erro")
	endif
	*/
	// Listagem de pedidos de venda
	if at(' ',cDtAt1) == 0
		cDtAtu1 := replace(cDtAt1,"-","")
		cHrAtu1 := ""
	else
		cDtAtu1 := replace(substr(cDtAt1,1,at(' ',cDtAt1)-1),"-","")
		cHrAtu1 := replace(substr(cDtAt1,at(' ',cDtAt1)+1,8),":","")
	endif
	if at(' ',cDtAt2) == 0
		cDtAtu2 := replace(cDtAt2,"-","")
		cHrAtu2 := ""
	else
		cDtAtu2 := replace(substr(cDtAt2,1,at(' ',cDtAt2)-1),"-","")
		cHrAtu2 := replace(substr(cDtAt2,at(' ',cDtAt2)+1,8),":","")
	endif

	BeginSql Alias "trb"
		%NOPARSER%
		SELECT C5_NUM,C5_FRETE,C6_NOTA,C6_SERIE,SUM(C6_VALOR) C6_VALOR,SUM(C6_VALDESC) C6_VALDESC FROM %TABLE:SC5% C5
		INNER JOIN %TABLE:SC6% C6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.%NOTDEL% 
		WHERE C5_FILIAL = %XFILIAL:SC5% AND C5.%NOTDEL% AND C5.C5_TIPO NOT IN ('D','B')
		AND C5_EMISSAO >= %exp:cDtEmi1% AND C5_EMISSAO <= %exp:cDtEmi2%
		AND C5_XDTATU >= %exp:cDtAtu1% AND C5_XDTATU <= %exp:cDtAtu2%
        AND C5_XHRATU >= %exp:cHrAtu1% AND C5_XHRATU <= %exp:cHrAtu2%
		GROUP BY C5_NUM,C5_FRETE,C6_NOTA,C6_SERIE
	EndSql
	if !trb->(eof())
		oLst:=lstPedXFat():new()
		while !trb->(eof())
			/*sc5->(dbseek(xfilial()+trb->c5_num))
			cDataAlt := FwLeUserLg( 'SC5->C5_USERLGA', 2 )
			if empty(cDataAlt)
				cDataAlt := FwLeUserLg( 'SC5->C5_USERLGI', 2 )
			endif
			cDataAlt := dtos(ctod(cDataAlt))
			cHrAlt := ""	//FwLeUserLg( 'SC5->C5_USERLGA', 2 )
			if ( empty(cDtAtu2) .or. empty(cDataAlt) .or. cDataAlt >= cDtAtu1 .and. cDataAlt <= cDtAtu2 ) .and. ;
					( empty(cHrAtu2) .or. empty(cHrAlt) .or. cHrAlt >= cHrAtu1 .and. cHrAlt <= cHrAtu2 )
				oPxF:=PedXFat():new()
				oPxF:busca(trb->c5_num,trb->c6_nota,trb->c6_serie,trb->c6_valor,cDataAlt,cHrAlt)
				aadd(oLst:Itens,{ oPxF })
			endif*/
			oPxF:=PedXFat():new()
			oPxF:busca(trb->c5_num,trb->c6_nota,trb->c6_serie,trb->c6_valor,trb->c6_valdesc,trb->c5_frete)
			aadd(oLst:Itens, oPxF )
			trb->(dbskip())
		end
	endif
	trb->(dbclosearea())
	/*
	// Pedido de Venda
	if u_critJson(cBody,@cMens)
		oJson:fromJson(cBody)

		cNumSho := Padr(oJson['C5_XPEDSHP'] ,TamSx3("C5_XPEDSHP")[1])
		aItens  := oJson['SC6']

		if empty(aItens) .or. len(aItens) == 0
			lRet := .f.
			oResp['Status'] := 404
			oResp['Message']:= EncodeUTF8( "Os itens do pedido "+alltrim(cNumSho)+" não foram encaminhados!", "cp1252")
		else
			sc5->( DbSetOrder(11) )
			if sc5->(dbseek(cNumSho))
				if atuPed(sc5->c5_num,aItens,@cMens)
					oResp['Status'] := 201
					oResp['Message']:= EncodeUTF8( "Alteração do pedido "+alltrim(cNumSho)+" realizada com sucesso", "cp1252")
				else
					lRet := .f.
					oResp['Status'] := 400
					oResp['Message']:= EncodeUTF8( cMens, "cp1252")
				endif
			else
				lRet := .f.
				oResp['Status'] := 404
				oResp['Message']:= EncodeUTF8( "O pedido "+alltrim(cNumSho)+" não existe!", "cp1252")
			endif

		endif
	else
		lRet := .f.
		oResp['Status'] := 400
		oResp['Message']:= EncodeUTF8( cMens, "cp1252")
	endif
*/
			RpcClearEnv()

			Return lRet
