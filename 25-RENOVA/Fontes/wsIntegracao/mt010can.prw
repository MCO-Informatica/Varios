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
	Local aAreas:= {szb->(GetArea()), GetArea()}
	Local nOpc	:= ParamIxb[1]
	Local cOpc  := ""       //C-Consulta;I-Inclus�o;A-Altera��o;B-Bloqueio;E-Exclus�o
	Local cErro := ""
	Local lOk   := .t.

	Local cGrupo:= GetNewPar("MV_XGRPMAT","AEG1;BOP1")
	Local cJobEmp := cEmpAnt
	Local cJobFil := cFilAnt
	Local cJobMod := 'FAT'
	Local cId     := ''

	If cJobEmp == '00'

		szb->(DbSetOrder(1))

		if (inclui .or. Altera) .and. nOpc == 1
			if inclui .and. alltrim(sb1->b1_grupo) $ cGrupo
				if sb1->b1_msblql != '1'
					cOpc := "I"
				endif
			else
				if szb->(dbseek(xfilial()+sb1->(xfilial())+"M"+sb1->b1_cod))
					cId := szb->zb_idreg
				endif
				if empty(cId)
					if alltrim(sb1->b1_grupo) $ cGrupo .and. sb1->b1_msblql != '1'
						cOpc := "I"
					endif
				elseIf sb1->b1_msblql == '1'
					cOpc := 'B'
				elseIf !alltrim(sb1->b1_grupo) $ cGrupo
					cOpc := 'E'
				else
					cOpc := 'A'
				EndIf
			endif
		elseif !inclui .and. !Altera .and. nOpc == 2
			cOpc := "E"
		endif
		if !empty(cOpc)
			//lOK := startjob("u_matOper",getenvserver(),.t./*lWait*/,cJobEmp,cJobFil,cJobMod,cOpc,sb1->b1_cod,,@cErro)
			lOK := u_matOper(cJobEmp,cJobFil,cJobMod,cOpc,sb1->b1_cod,,@cErro)
			if !lOk
				MsgInfo("N�o conseguiu efetuar a opera��o no material no ambiente CMMS!", "Problema")
			endif
		endif

		aEval(aAreas, {|x| RestArea(x) })

	endif

Return Nil
