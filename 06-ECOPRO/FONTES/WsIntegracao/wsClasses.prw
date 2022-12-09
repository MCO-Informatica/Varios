#include "protheus.ch"
/* Definição Classes E-Commerce */

class produto	/* Classe produtos */

	data nome
	data descricao
	data modelo
	data sku
	data ncm
	data cest
	data ean 
	data isbn 
	data mpn
	data valor
	data quantidade
	data comprimento
	data largura
	data altura
	data peso
	data Imagem
	// Declaração dos Métodos da Classe
	method new() constructor
	method busca( cProd, cLocal ) constructor

endclass

method new() class produto

	::nome	:= ""
	::descricao := ""
	::modelo := ""
	::sku := ""
	::ncm := ""
	::cest := ""
	::ean := ""
	::isbn := "" 
	::mpn := ""
	::valor := 0
	::quantidade := 0
	::comprimento := 0
	::largura := 0
	::altura := 0
	::peso := 0
	::Imagem := nil

Return Self

method busca( cProd, cLocal ) Class produto

	Local aAreaS := { sb1->(GetArea()), sb2->(GetArea()), da1->(GetArea()), da0->(GetArea()), sb5->(GetArea()), GetArea() }
	Local nPreco := 0
	Local nSDisp := 0
	local nCompr := 0
	Local nLarg  := 0
	Local nAltur := 0
	
	sb1->(DbSetOrder(1))
	sb1->(dbseek(xfilial()+cProd))
	if empty(cLocal)
		cLocal := sb1->b1_locpad
	endif

	sb5->(DbSetOrder(1))
	if sb5->(dbseek(xfilial()+cProd))
		nCompr := sb5->b5_compr
		nLarg  := sb5->b5_larg
		nAltur := sb5->b5_altura
	endif

	sb2->(DbSetOrder(1))
	if sb2->(dbseek(xfilial()+cProd+cLocal))
		nSDisp := SaldoSB2()	//sb2->b2_qatu-sb2->b2_qpedven-sb2->b2_qemp-sb2->b2_reserva
	endif

	da1->(DbSetOrder(2))
	da1->(dbseek(xfilial()+cProd))
	while !da1->(eof()) .and. da1->da1_codpro == da1->(xfilial()) .and. da1->da1_codpro == cProd
		da0->(DbSetOrder(1))
		if da0->(dbseek(xfilial()+da1->da1_codtab)) .and. da0->da0_ativo == "1"
			if da1->da1_prcven > nPreco .and. da1->da1_ativo == "1"
				nPreco := da1->da1_prcven
			endif
		endif
		da1->(dbskip())
	end

	::nome	:= sb1->b1_desc
	::descricao := sb5->b5_ceme
	::modelo := sb1->b1_grupo
	::sku := sb1->b1_cod
	::ncm := sb1->b1_posipi
	::cest := sb1->b1_cest
	::ean := sb1->b1_verean
	::isbn := "" 
	::mpn := ""
	::valor := nPreco
	::quantidade := nSDisp
	::comprimento := sb5->b5_compr
	::largura := sb5->b5_larg
	::altura := sb5->b5_altura
	::peso := sb1->b1_peso
	::Imagem := nil

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self
