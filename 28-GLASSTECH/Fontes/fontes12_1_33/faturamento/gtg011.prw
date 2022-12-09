#include "Protheus.ch"
/* Gatilho referente ao retorno dos descontos: nPar 1 - vendedor, 2 gerente */
User Function gtg011(npar)

	Local aAreas   := {sa1->(GetArea()), sb1->(GetArea()), GetArea()}
	Local n_LimDVe := 0
	Local n_LimDGe := 0
	Local cUf      := "**"
	Local nVlr     := iif(nPar==1,tmp1->ck_xdescV,tmp1->ck_xdescG)

	if !tmp1->ck_flag .and. !lDir

		if m->cj_cliente+m->cj_loja != sa1->a1_cod+sa1->a1_loja
			sa1->(DbSetOrder(1))
			sa1->( DbSeek( xFilial()+m->cj_cliente+m->cj_loja ) )
		endif

		if sa1->a1_est $ "RJ|SP|MG"
			cUf := sa1->a1_est
		endif

		if sa1->a1_xpdce == 0
			if tmp1->ck_produto != sb1->b1_cod
				sb1->( DbSeek( xFilial()+tmp1->ck_produto ) )
			endif

			if sz3->( DbSeek( xFilial()+m->cj_xtpfatu+cUf+sb1->b1_tipoprd+sb1->b1_grupo ) )  // Z3_FILIAL+Z3_TPFATU+Z3_UF+Z3_TPMATE+Z3_GRUPO
				n_LimDVe := sz3->z3_pmaxVe
				n_LimDGe := sz3->z3_pmaxGe
			endif

			if npar == 1 .and. tmp1->ck_xdescV > n_LimDVe
				nVlr := n_LimDVe
			endif
			if npar == 2 .and. tmp1->ck_xdescG > n_LimDGe
				nVlr := n_LimDGe
			endif

		elseif tmp1->ck_xdescV + tmp1->ck_xdescG > sa1->a1_xpdce
			nVlr := 0
			alert("O limite do desconto foi estrapolado no produto "+alltrim(tmp1->ck_produto)+". Seu limite é "+alltrim(str(sa1->a1_xpdce))+"%, Verifique!")
		endif
	endif

	aEval(aAreas, {|x| RestArea(x) })

Return nVlr
