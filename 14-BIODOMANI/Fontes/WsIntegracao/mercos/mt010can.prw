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
	Local aAreas := {szb->(GetArea()), sb5->(GetArea()), GetArea()}
	Local nOpc := ParamIxb[1]
	Local cLocal := ""
	Local cOpc  := ""       //C-Consulta;I-Inclusão;A-Alteração;B-Bloqueio;E-Exclusão
	Local cErro := ""
	Local nI := 0
	Local aLocal := {}
	Local cJobEmp := cEmpAnt
	Local cJobFil := '0101'
	Local cJobMod := 'FAT'
	Local cIdMercos := ''
	Local lOk	  := .t.
	Local lWait   := .t.
	Local nTotThread := 0

	If cJobEmp == '01'
		sb5->(DbSetOrder(1))
		if sb5->(dbseek(xfilial()+sb1->b1_cod))
			szb->(DbSetOrder(1))
			aLocal := u_mercos98()
			for nI := 1 to len(aLocal)
				cJobFil := aLocal[nI,1]
				cLocal  := aLocal[nI,2]
				cErro 	:= ''

				if (inclui .or. Altera) .and. nOpc == 1
					if inclui .and. sb5->b5_xmercos == '1'
						cOpc := "I"
					else
						cIdMercos := ''
						if szb->(dbseek(xfilial()+cJobFil+"P"+sb1->b1_cod))
							cIdMercos := szb->zb_idreg
						endif
						if sb5->b5_xmercos == '1' .and. empty(cIdMercos)
							cOpc := "I"
						elseIf sb1->b1_msblql == '1' .or. sb5->b5_xmercos != '1' .and. !empty(cIdMercos)
							cOpc := 'B'
						elseif !empty(cIdMercos)
							cOpc := 'A'
						EndIf
					endif
				elseif !inclui .and. !Altera .and. nOpc == 2
					cOpc := "B" //"E"
				endif
				if !empty(cOpc)

					nTotThread += 1
					lWait := .f.
					if lWait
						lOk := startjob("u_prodOper",getenvserver(),lWait,cJobEmp,cJobFil,cJobMod,cOpc,sb1->b1_cod,cLocal,@cErro)
						if !lOk
							MsgInfo("Não conseguiu abrir a filial "+cJobFil+" para efetuar a operação no produto no ambiente Mercos Correspondente!", "Problema")
						endif
					else
						startjob("u_prodOper",getenvserver(),lWait,cJobEmp,cJobFil,cJobMod,cOpc,sb1->b1_cod,cLocal,@cErro)
						if !empty(cErro)
							MsgInfo("Não conseguiu abrir a filial "+cJobFil+" para efetuar a operação no produto no ambiente Mercos Correspondente!", "Problema")
						endif
					endif
					If nTotThread > 5
						DelClassIntf()
						nTotThread := 0
					EndIf
				endif
			Next
			aEval(aAreas, {|x| RestArea(x) })
		endif
	endif

Return Nil
