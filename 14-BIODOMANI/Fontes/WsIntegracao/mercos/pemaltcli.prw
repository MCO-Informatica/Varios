#include "Protheus.ch"

user function pemaltcli(lcrma980)
	Local aAreas := {szb->(GetArea()), GetArea()}
	Local cOpc  := ''       //C-Consulta;I-Inclusão;A-Alteração;B-Bloqueio;E-Exclusão
	Local cErro := ''
	Local nI := 0
	Local aLocal := {}
	Local cJobEmp := cEmpAnt
	Local cJobFil := '0101'
	Local cJobMod := 'FAT'
	Local cIdMercos := ''
	Local lOk	  := .t.
	Local lRet	  := .t.
	Local lWait   := .t.
	Local nTotThread := 0

	Default lcrma980 := .f.

	If lRet .and. cJobEmp == '01'
		if !lcrma980
			sa1->(dbcommit())
		endif
		szb->(DbSetOrder(1))
		aLocal := u_mercos98()

		for nI := 1 to len(aLocal)
			cJobFil := aLocal[nI,1]
			cErro 	:= ''
			cIdMercos := ''
			if szb->(dbseek(xfilial()+cJobFil+"C"+sa1->a1_cod+sa1->a1_loja))
				cIdMercos := szb->zb_idreg
			endif
			if sa1->a1_msblql != "1" .and. empty(cIdMercos)
				cOpc := "I"
			elseIf sa1->a1_msblql == "1"
				//cOpc  := "B"
			elseif !empty(cIdMercos)
				cOpc := "A"
			EndIf
			if !empty(cOpc)

				nTotThread += 1
				lWait := .f.

				lOk := startjob("u_cliOper",getenvserver(),lWait,cJobEmp,cJobFil,cJobMod,cOpc,sa1->a1_cod,sa1->a1_loja,@cErro)
				if !empty(cErro) .or. lWait .and. !lOk
					MsgInfo("Não conseguiu abrir a filial "+cJobFil+" para efetuar a alteração no cliente no ambiente Mercos Correspondente!", "Problema")
				endif

				If nTotThread > 5
					DelClassIntf()
					nTotThread := 0
				EndIf
			endif
		Next
		aEval(aAreas, {|x| RestArea(x) })
	endif
Return lRet
