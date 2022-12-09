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
	Local aAreas := {sb1->(GetArea()), sb5->(GetArea()), GetArea()}
	Local nOpc := ParamIxb[1]
	Local cOpc  := ""       //C-Consulta;I-Inclus�o;A-Altera��o;B-Bloqueio;E-Exclus�o
	Local cErro := ""
	Local cJobEmp := cEmpAnt
	Local cJobFil := '0101'
	Local cJobMod := 'EST'

	sb5->(DbSetOrder(1))
	if sb5->(dbseek(xfilial()+sb1->b1_cod))
		if (inclui .or. Altera) .and. nOpc == 1
			if inclui
				cOpc := "I"
			else
				If sb1->b1_msblql == '1'
					//cOpc := 'B'
				else
					cOpc := 'A'
				EndIf
			endif
		elseif !inclui .and. !Altera .and. nOpc == 2
			//cOpc := "E"
		endif
		if !empty(cOpc)
			u_prodOper(cJobEmp,cJobFil,cJobMod,cOpc,sb1->b1_cod,"",@cErro)
			if !empty(cErro)
				MsgInfo("N�o conseguiu efetuar a opera��o no produto no ambiente Shopify. "+cErro, "Problema")
			endif
		endif
		aEval(aAreas, {|x| RestArea(x) })
	endif

Return Nil
