#include "protheus.ch"
/*
Inclusão / Alteração de produtos
nOpc = 1 -> Função executada OK.
nOpc = 3 -> Função Cancelada.

Exclusão de produtos
nOpc = 2 -> Função executada OK.
nOpc = 1 -> Função Cancelada.
*/
User Function mt010can()
	Local aAreas := {sb5->(GetArea()), GetArea()}
	Local nOpc := ParamIxb[1]
	Local cOpc  := ""       //C-Consulta;I-Inclusão;A-Alteração;B-Bloqueio;E-Exclusão
	Local cErro := ""
	Local cJobEmp := cEmpAnt
	Local cJobFil := '0101'
	Local cJobMod := 'EST'

	if (inclui .or. Altera) .and. nOpc == 1
		if inclui
			cOpc := "I"
		else
			If sb1->b1_msblql == '1'
				cOpc := 'B'
			else
				cOpc := 'A'
			EndIf
		endif
	elseif !inclui .and. !Altera .and. nOpc == 2
		cOpc := "E"
	endif
	if !empty(cOpc)
		u_prodOper(cJobEmp,cJobFil,cJobMod,cOpc,sb1->b1_cod,"02",@cErro)
		if !empty(cErro)
			MsgInfo("Não conseguiu abrir a filial "+cJobFil+" para efetuar a operação no produto no ambiente Mercos Correspondente!", "Problema")
		endif
	endif
	aEval(aAreas, {|x| RestArea(x) })

Return Nil
