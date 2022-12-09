#include "Protheus.ch"
/* Gatilho referente as escolhas dos níveis */
User Function gtg004()
	Local aAreas := {sa1->(GetArea()), GetArea()}
	Local lRet   := .t.

	if m->cj_cliente+m->cj_loja != sa1->a1_cod+sa1->a1_loja
		sa1->(DbSetOrder(1))
		sa1->( DbSeek( xFilial()+m->cj_cliente+m->cj_loja ) )
	endif
	if Empty(m->cj_xnivel)
		lRet := .f.
	else
		if m->cj_xnivel == "1" .and. !sa1->a1_xnivel1
			lRet := .f.
		elseif m->cj_xnivel == "2" .and. !sa1->a1_xnivel2
			lRet := .f.
		elseif m->cj_xnivel == "6" .and. !sa1->a1_xnivel6
			lRet := .f.
		elseif m->cj_xnivel == "8" .and. !sa1->a1_xnivel8
			lRet := .f.
		endif
	endif
	if !lRet
		Alert("Nível de faturamento inválido!")
	endif

	aEval(aAreas, {|x| RestArea(x) })

Return lRet
