#include "protheus.ch"
/*
Inclus�o / Altera��o de produtos
nOpc = 1 -> Fun��o executada OK.
nOpc = 3 -> Fun��o Cancelada.

Exclus�o de produtos
nOpc = 2 -> Fun��o executada OK.
nOpc = 1 -> Fun��o Cancelada.
*/
User Function mt010can()
	Local aAreas := {sb5->(GetArea()), GetArea()}
	Local nOpc := ParamIxb[1]

	if (inclui .or. Altera) .and. nOpc == 1
		sb5->(DbSetOrder(1))
		if sb5->(dbseek(xfilial()+sb1->b1_cod))
			sb1->(RecLock("SB1", .f.))
			sb1->b1_tipoprd := sb5->b5_xtpprod
			sb1->(MsUnlock())
		endif

		aEval(aAreas, {|x| RestArea(x) })
	endif

Return Nil
