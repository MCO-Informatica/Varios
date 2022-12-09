#include "Protheus.ch"
/* Retornar fator indicativo do valor para gerar venda à empresa*/
User Function gtf005(cProduto,nPIcms,nPIpi,nPpis,nPcof)

	Local aAreas := {sf7->(GetArea()), sb1->(GetArea()), GetArea()}

    nPIcms := nPIpi := nPpis := nPcof := 0

	if cProduto != sb1->b1_cod
		sb1->(DbSetOrder(1))
		sb1->(DbSeek(xFilial()+cProduto))
	endif

	sf7->(DbSetOrder(1))
	sf7->(dbseek(xfilial()+sb1->b1_grtrib+sa1->a1_grptrib))
	while !sf7->(eof()) .and. sf7->f7_grtrib+sf7->f7_grpcli == sb1->b1_grtrib+sa1->a1_grptrib
		if sa1->a1_est == sf7->f7_est
            if sm0->m0_estent != sa1->a1_est
                nPIcms := sf7->f7_aliqext
            else
                nPIcms := sf7->f7_aliqint
            endif
            nPipi  := sf7->f7_aliqipi
		endif
		sf7->(dbskip())
	end
	if nPIcms == 0
		if sa1->a1_contrib == '1' .and. sa1->a1_est $ GetMv("MV_NORTE")
			nPIcms := 7
		elseif sa1->a1_contrib == '1' .and. sm0->m0_estent != sa1->a1_est
			nPIcms := 12
		else
			nPIcms := iif(sb1->b1_picm==0,GetMv("MV_ICMPAD"),sb1->b1_picm)
			//nPIcms := val(substr(cEstICMS,(at(sa1->a1_est,cEstICMS)+2),2))
		endif
	endif
    if nPIpi == 0
        nPIpi := sb1->b1_ipi
    endif

	nPpis := iif(sb1->b1_ppis==0,GetMv("MV_TXPIS"),sb1->b1_ppis)
	nPcof := iif(sb1->b1_pcofins==0,GetMv("MV_TXCOFIN"),sb1->b1_pcofins)

	aEval(aAreas, {|x| RestArea(x) })

Return nil
