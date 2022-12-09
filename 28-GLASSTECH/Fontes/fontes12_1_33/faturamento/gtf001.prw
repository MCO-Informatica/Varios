#include "Protheus.ch"
/* Retornar impostos dos Itens de orçamento e pvs. Obs traz valor total do item */

User Function gtf001(cCodCli,cloja,ctipo,cproduto,cCondpg,ctes,nqtdven,nPrcVen,nValor,nDescont,nBasICM,nVlrICM,nVlrPIS,nVlrCOF,nVlrIPI,nVlrSol,nVlrTot)

	Local aAreas   := {se4->(GetArea()), sa1->(GetArea()), sb1->(GetArea()), sf4->(GetArea()), GetArea()}
	Local nPercPIS := 0
	Local nPercCOF := 0
	Local aImpostos:= {}

	nBasICM := nVlrICM := nVlrPIS := nVlrCOF := nVlrIPI := nVlrSol := nVlrTot := 0

	if cCodCli+cloja != sa1->a1_cod+sa1->a1_loja
		sa1->(DbSetOrder(1))
		sa1->(DbSeek(xFilial()+cCodCli+cloja))
	endif

	if cproduto != sb1->b1_cod
		sb1->(DbSetOrder(1))
		sb1->(DbSeek(xFilial()+cproduto))
	endif

	if cCondpg != se4->e4_codigo
		se4->(dbSetOrder(1))
		se4->(dbSeek(xFilial()+cCondpg))
	endif

	if ctes != sf4->f4_codigo
		sf4->(DbSetOrder(1))
		sf4->(DbSeek(xFilial()+ctes))
	endif

	aImpostos := MaFisRelImp(funname(),{"SC5","SC6"})

	MaFisIni(cCodCli,;             			// 01 - Codigo Cliente/Fornecedor
	cloja,;                         	  	// 02 - Loja do Cliente/Fornecedor
	"C"	,;								    // 03 - C:Cliente , F:Fornecedor
	"N"	,;                            		// 04 - Tipo da NF
	ctipo,;                         	  	// 05 - Tipo do Cliente/Fornecedor
	aImpostos,;								// 06 - Relacao de Impostos que suportados no arquivo
	,;                                      // 07 - Tipo de complemento
	,;                                      // 08 - Permite Incluir Impostos no Rodape .T./.F.
	"SB1",;                                 // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	funname())                              // 10 - Nome da rotina que esta utilizando a funcao

	MaFisAdd(cproduto  , ;  // 01 - Codigo do Produto                    ( Obrigatorio )
	ctes               , ;  // 02 - Codigo do TES                        ( Opcional )
	nqtdven		       , ;  // 03 - Quantidade                           ( Obrigatorio )
	nPrcVen		       , ;  // 04 - Preco Unitario                       ( Obrigatorio )
	nDescont           , ;  // 05 - Desconto
	""			       , ;  // 06 - Numero da NF Original                ( Devolucao/Benef )
	""			       , ;  // 07 - Serie da NF Original                 ( Devolucao/Benef )
	0                  , ;  // 08 - RecNo da NF Original no arq SD1/SD2
	0                  , ;  // 09 - Valor do Frete do Item               ( Opcional )
	0                  , ;  // 10 - Valor da Despesa do item             ( Opcional )
	0                  , ;  // 11 - Valor do Seguro do item              ( Opcional )
	0                  , ;  // 12 - Valor do Frete Autonomo              ( Opcional )
	nValor             , ;  // 13 - Valor da Mercadoria                  ( Obrigatorio )
	0                  , ;  // 14 - Valor da Embalagem                   ( Opcional )
	sb1->(RecNo())     , ;  // 15 - RecNo do SB1
	sf4->(RecNo())       ;  // 16 - RecNo do SF4
	)

	nBasICM := MaFisRet(1, "IT_BASEICM")
	nVlrICM := MaFisRet(1, "IT_VALICM")
	nVlrPIS := MaFisRet(1, "IT_VALPIS")
	if nVlrPIS == 0 .and. sf4->f4_piscof $ "1|3"
		nPercPIS := iif(sb1->b1_ppis==0,GetMv("MV_TXPIS"),sb1->b1_ppis) /100
		nVlrPIS  := round(nBasICM * nPercPIS,2)
	endif
	nVlrCOF := MaFisRet(1, "IT_VALCOF")
	if nVlrCOF == 0 .and. sf4->f4_piscof $ "2|3"
		nPercCOF := iif(sb1->b1_pcofins==0,GetMv("MV_TXCOFIN"),sb1->b1_pcofins) /100
		nVlrCOF  := round(nBasICM * nPercCOF,2)
	endif

	nVlrIPI := MaFisRet(1, "IT_VALIPI") * (1+(se4->e4_acrsfin/100))
	nVlrSol := MaFisRet(1, "IT_VALSOL")
	nVlrTot := MaFisRet(1, "IT_TOTAL")

	if !empty(sa1->a1_suframa) .and. nVlrSol > 0
		nBicmori := mafisret(1,"IT_BICMORI")			//nValor - nVlrPIS - nVlrCOF
		nAliqSol := MaFisRet(1,"IT_ALIQSOL") / 100
		//nAliq := mafisret(1,"IT_ALIQICM")
		nDescZF := MaFisRet(1,"IT_DESCZF")				//nBCalc * nAliq
		nMargem := mafisret(1,"IT_MARGEM") / 100 		//MVA Ajustada
		nBCDesc := nBicmori - nVlrPIS - nVlrCOF - nDescZF					//Base de calculo descontada
		nBCst := nBCDesc + (nBCDesc * nMargem)
		nicmsSt := round((nBCst * nAliqSol) - nDescZF,2)
		if nVlrSol != nicmsSt
			nVlrSol := nicmsSt
			nVlrTot := nBCDesc + nicmsSt
		endif
	endif

	//MaFisSave()
	MaFisEnd()

	aEval(aAreas, {|x| RestArea(x) })

Return
