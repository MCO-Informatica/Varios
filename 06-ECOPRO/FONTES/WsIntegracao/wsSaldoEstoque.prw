#include "Protheus.ch"
#include 'Restful.ch'
#include 'tbiconn.ch'
#include "Topconn.ch"

class saldoEst			/* Classe Saldo em estoque */

	data Empresa
	data Filial
	data Codigo
	data LocPro
	data Saldo
	data SaldoValor
	data Reserva
	data QuantCompras
	// Declaração dos Métodos da Classe
	method new() constructor
	method busca( cProd, cLocal )

endclass


method new() class saldoEst

	::Empresa	:= ""
	::Filial	:= ""
	::Codigo	:= ""
	::LocPro	:= ""
	::Saldo	 	:= 0
	::SaldoValor:= 0
	::Reserva	:= 0
	::QuantCompras:= 0

Return Self


method busca(cProd, cLocal) class saldoEst

	Local aAreaS := { sb2->(GetArea()), GetArea() }

	sb2->(DbSetOrder(1))
	if sb2->(dbseek(xfilial()+cProd+cLocal))
		::Empresa	:= cEmpAnt
		::Filial	:= cFilAnt
		::Codigo	:= cProd
		::LocPro	:= cLocal
		::Saldo	 	:= sb2->b2_qatu
		::SaldoValor:= sb2->b2_vatu1
		::Reserva	:= sb2->b2_reserva
		::QuantCompras:= sb2->b2_salpedi
	else
		::Codigo	:= ""
	endif

	aEval( aAreaS, {|x| RestArea(x) } )
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

	WsRestful wsSaldoEstoque  Description 'Saldos de produtos no Estoque' FORMAT "application/json"

		WsData CodPro AS Character
		WsData LocPro AS Character
		WsData Grupo  AS Character
		WsData Filial AS Character

		WsMethod GET  Description 'Consultar Saldos de produtos no Estoque' WsSyntax "/wsSaldoEstoque?CodPro=valueParam1&LocPro=valueParam2&Grupo=valueParam3&Filial=valueParam4"

	End WsRestful

WsMethod GET WsReceive CodPro, LocPro, Grupo, Filial WsService wsSaldoEstoque

	Local lRet 	  := .t.
	Local cCodPro := Self:CodPro
	Local cLocPro := Self:LocPro
	Local cGru    := Self:Grupo
	Local cFil    := Self:Filial
	Local nI      := 0
	Local cDes    := ""

	Local aIte    := {}
	Local oIte
	Local oPro
	Local oJson   := JsonObject():New()
	Local oResp   := JsonObject():New()
	//Local cBody   := ::GetContent()

	::SetContentType("application/json; charset=utf-8")

	if empty(cGru) .or. empty(cFil)
		cGru := "01"
		cFil := "0101"
	endif
	if !empty(cCodPro)
		cCodPro := cCodPro+space(15-len(cCodPro))
	endif
	lRet := u_abrirAmb(cGru,cFil,"EST")
	//oResp['Status'] := 200
	//oResp['Message']:= EncodeUTF8( cCodPro+" "+cLocPro+" "+cGru+" "+cFil, "cp1252")
	//::SetResponse(oResp:toJson())
	//return .t.
	if lRet
		cSql := "select * from "+RetSQLName("SB2")+" b2 "
		cSql += "inner join "+RetSQLName("SB1")+" b1 on b1_filial = '"+sb1->(xFilial())+"' and b1_cod = b2_cod and b1.d_e_l_e_t_ = ' ' "
		cSql += "where b2_filial = '"+sb2->(xFilial())+"' "
		if !empty(cCodPro)
			cSql += "and b2_cod = '"+cCodPro+"' "
			if !empty(cLocPro)
				cSql += "and b2_local = '"+cLocPro+"' "
			endif
		else
			cSql += "and substring(b2_cod,1,4) in ('1000','2000','3000','4000') "	//Iniciais de produtos que são do e-commerce
		endif
		cSql += "and b2.d_e_l_e_t_ = ' ' "
		dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
		if !trb->(eof())
			oIte:=itSaldoEst():new()
			oIte:status := 200
			while !trb->(eof())
				oPro:=saldoEst():new()
				//oPro:busca(trb->b2_cod, trb->b2_local)
				oPro:Empresa:= cEmpAnt
				oPro:Filial	:= trb->b2_filial
				oPro:Codigo	:= trb->b2_cod
				oPro:LocPro	:= trb->b2_local
				oPro:Saldo	:= trb->b2_qatu
				oPro:SaldoValor:= trb->b2_vatu1
				oPro:Reserva:= trb->b2_reserva
				oPro:QuantCompras:= trb->b2_salpedi
				aadd(oIte:itens,{ oPro })
				trb->(dbskip())
			end

			aIte := ClassDataArr(oIte)
			for nI := 1 to len(aIte)
				if &('oIte:'+lower(aIte[nI,1])) != nil
					cDes := 'oJson["'+lower(aIte[nI,1])+'"]'
					&cDes := atribObj(oIte,aIte[nI,1])
				endif
			next nI

			oResp := oJson
		else
			oResp['Status'] := 204
			oResp['Message']:= EncodeUTF8( "Saldo do produto não foi encontrado", "cp1252")
		endif
		trb->(dbclosearea())
		::SetResponse(oResp:toJson())

		RpcClearEnv()
	else
		SetRestFault(500, EncodeUTF8( "Não Abriu o Ambiente Protheus", "cp1252") )
	endif

Return lRet


Static Function atribObj(oObj,cNomObj)

	Local oJson
	Local oJsoD
	Local oObD
	Local aObD := {}

	Local cOri := ''
	Local cDes := ''

	Local aJsoD := {}
	Local cOrD := ''
	Local cDeD := ''
	Local nP := 0
	Local nO := 0

	oJson := JsonObject():new()
	oJsoD := JsonObject():new()
	cOri := 'oObj:'+lower(cNomObj)
	cDes := 'oJson["'+lower(cNomObj)+'"]'

	if ValType(&cOri) == "A"
		For nP := 1 to len(&cOri)
			Aadd(aJsoD,JsonObject():new())
			oObD := &(cOri+"["+str(nP)+"][1]")
			aObD := ClassDataArr(oObD)
			For nO := 1 to len(aObD)
				cOrD := 'oObD:'+lower(aObD[nO,1])
				cDeD := 'aJsoD['+str(nP)+',"'+lower(aObD[nO,1])+'"]'
				&cDeD := &cOrD
			next nO
		Next nP
		if !empty(cDeD)
			&cDes := aJsoD
		else
			&cDes := &cOri
		endif
	else
		&cDes := &cOri
	endif

Return &cDes
