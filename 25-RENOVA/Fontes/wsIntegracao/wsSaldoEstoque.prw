#include "Protheus.ch"
#include 'Restful.ch'
#include 'tbiconn.ch'
#include "Topconn.ch"

class saldoEst			/* Classe Saldo em estoque */

	data Empresa
	data Filial
	data Codigo
	data LocPro
	data EndPro
	data Saldo
	data SaldoValor
	data Reserva
	//data QuantCompras
	// Declaração dos Métodos da Classe
	method new() constructor
	method buscar( cProd, cLocal ) constructor

endclass


method new() class saldoEst

	::Empresa	:= ""
	::Filial	:= ""
	::Codigo	:= ""
	::LocPro	:= ""
	::EndPro	:= ""
	::Saldo	 	:= 0
	::SaldoValor:= 0
	::Reserva	:= 0
	//::QuantCompras:= 0

Return Self


method buscar(cProd, cLocal, cEndereco) class saldoEst

	Local aAreaS := { sb2->(GetArea()), sbf->(GetArea()), GetArea() }
	Local nVlrUnit := 0

	sbf->(DbSetOrder(1))	//BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
	if sbf->(dbseek(xfilial()+cLocal+cEndereco+cProd))

		sb2->(DbSetOrder(1))
		sb2->(dbseek(xfilial()+cProd+cLocal))

		nVlrUnit := sb2->b2_vatu1/sb2->b2_qatu

		::Empresa	:= cEmpAnt
		::Filial	:= cFilAnt
		::Codigo	:= cProd
		::LocPro	:= cLocal
		::EndPro	:= cEndereco
		::Saldo	 	:= sbf->bf_quant
		::SaldoValor:= nVlrUnit * sbf->bf_quant
		::Reserva	:= sbf->bf_empenho
		//::QuantCompras:= sbf->bf_salpedi
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

	WsRestful wsSaldoEstoque  Description 'Saldos de produtos no Estoque' format "application/json"

		WsData CodPro AS Character
		WsData LocPro AS Character
		WsData EndPro AS Character
		WsData Grupo  AS Character
		WsData Filial AS Character

		WsMethod GET  Description 'Consultar Saldos de produtos no Estoque' WsSyntax "/wsSaldoEstoque?CodPro=valueParam1&LocPro=valueParam2&EndPro=valueParam3&Grupo=valueParam4&Filial=valueParam5"

	End WsRestful

WsMethod GET WsReceive CodPro, LocPro, EndPro, Grupo, Filial WsService wsSaldoEstoque

	Local lRet 	  := .t.
	Local cCodPro := Self:CodPro
	Local cLocPro := Self:LocPro
	Local cEndPro := Self:EndPro
	Local cGru    := Self:Grupo
	Local cFil    := Self:Filial
	Local nI      := 0
	Local cDes    := ""
	Local cGruMat := ""
	Local lLisGru := ""
	Local cParte  := ""
	Local nVlrUnit := 0

	Local aIte    := {}
	Local oIte
	Local oPro
	Local oJson   := JsonObject():New()
	Local oResp   := JsonObject():New()
	//Local cBody   := ::GetContent()

	::SetContentType("application/json; charset=utf-8")

	if empty(cGru) .or. empty(cFil)
		cGru := "00"
		cFil := "1330001"
	endif
	if u_abrirAmb(cGru,cFil,"EST")
		if !empty(cCodPro)
			cCodPro := Padr(cCodPro ,TamSx3("B1_COD")[1])
		endif
		cSql := "select bf_filial,bf_produto,bf_local,bf_localiz,"
		cSql += "sum(bf_quant) bf_quant,sum(bf_empenho) bf_empenho,sum(bf_qemppre) bf_qemppre "
		cSql += "from "+RetSQLName("SBF")+" bf "
		cSql += "inner join "+RetSQLName("SB1")+" b1 on b1_filial = '"+sb1->(xFilial())+"' and b1_cod = bf_produto and b1.d_e_l_e_t_ = ' ' "
		cSql += "where bf_filial = '"+sbf->(xFilial())+"' "
		if !empty(cCodPro)
			cSql += "and bf_produto = '"+cCodPro+"' "
			if !empty(cLocPro)
				cSql += "and bf_local = '"+cLocPro+"' "
			endif
			if !empty(cEndPro)
				cSql += "and bf_localiz = '"+cEndPro+"' "
			endif
		else
			cGruMat := alltrim( GetNewPar("MV_XGRPMAT","AEG1;BOP1") )
			for nI := 1 to len(cGruMat)
				if nI > 1 .or. !substr(cGruMat,nI,1) $ ";,"
					if substr(cGruMat,nI,1) == ";"
						if !empty(lLisGru)
							lLisGru += ","
						endif
						lLisGru += "'"+cParte+"'"
						cParte := ""
					else
						cParte += substr(cGruMat,nI,1)
						if nI == len(cGruMat)
							lLisGru += ",'"+cParte+"'"
						endif
					endif
				endif
			next
			cSql += "and b1_grupo in ("+lLisGru+") "
		endif
		cSql += "and substr(bf_local,1,1) != 'R' and bf.d_e_l_e_t_ = ' ' "
		cSql += "group by bf_filial,bf_produto,bf_localiz,bf_local"
		dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
		if !trb->(eof())
			oIte:=itSaldoEst():new()
			oIte:status := 200
			while !trb->(eof())

				sb2->(DbSetOrder(1))
				sb2->(dbseek(xfilial()+trb->bf_produto+trb->bf_local))
				nVlrUnit := sb2->b2_vatu1/sb2->b2_qatu

				oPro:=saldoEst():new()
				//oPro:buscar(trb->bf_cod, trb->bf_local, trb->bf_localiz)
				oPro:Empresa:= cEmpAnt
				oPro:Filial	:= trb->bf_filial
				oPro:Codigo	:= trb->bf_produto
				oPro:LocPro	:= trb->bf_local
				oPro:EndPro	:= trb->bf_localiz
				oPro:Saldo	:= trb->bf_quant
				oPro:SaldoValor := nVlrUnit * trb->bf_quant
				oPro:Reserva := trb->bf_empenho
				//oPro:QuantCompras := trb->b2_salpedi
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
		lRet := .f.
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
