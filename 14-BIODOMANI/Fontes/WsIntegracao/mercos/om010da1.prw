#include "protheus.ch"

User Function om010da1()
	Local aAreas := {da0->(GetArea()),da1->(GetArea()), GetArea()}
	Local nTp  := ParamIxb[1]   //nTipo:  1-Tabela; 2-Produto
	Local nOpc := ParamIxb[2]   //nOpção: 3-Inclusão; 4-Alteração; 5-Exclusão
	Local cOpc  := ""       	//C-Consulta;I-Inclusão;A-Alteração;B-Bloqueio;E-Exclusão
	Local cErro := ""
	Local nI := 0
	Local aLocal := {}
	Local cJobEmp := cEmpAnt
	Local cJobFil := '0101'
	Local cJobMod := 'FAT'
	Local cIdMercos := ''
	Local lOk	  := .t.
	Local lWait   := .t.
	Local lDel    := da1->(Deleted())
	Local nTotThread := 0
	//Somente fazer integração da tabela de preços quando foram as tabelas:
	//005 - TABELA SAMANA CONSUMIDOR FINAL e 201 - TABELA CONSUMIDOR COSMOBEAUTY
	If cJobEmp == '01' .and. nTp == 1 .and. da1->da1_codtab $ '005|201'

		szb->(DbSetOrder(1))
		aLocal := u_mercos98()

		if l_MyDa0

			for nI := 1 to len(aLocal)
				cJobFil := aLocal[nI,1]
				cErro 	:= ''

				if nOpc == 3
					cOpc := "I"
				elseif nOpc == 4
					cIdMercos := ''
					if szb->(dbseek(xfilial()+cJobFil+"B"+da0->da0_codtab))
						cIdMercos := szb->zb_idreg
					endif
					if empty(cIdMercos)
						cOpc := "I"
					elseIf da0->da0_ativo != '1' .and. !empty(cIdMercos)
						cOpc := 'B'
					elseif !empty(cIdMercos)
						cOpc := 'A'
					EndIf
				elseif nOpc == 5
					cOpc  := "E"
				endif

				nTotThread += 1
				lWait := .f.
				if lWait
					lOk := startjob("u_tabOper",getenvserver(),lWait,cJobEmp,cJobFil,cJobMod,cOpc,da0->da0_codtab,"",@cErro)
					if !lOk
						MsgInfo("Não conseguiu abrir a filial "+cJobFil+" para efetuar operação na tab. preços no ambiente Mercos Correspondente!", "Problema")
					endif
				else
					startjob("u_tabOper",getenvserver(),lWait,cJobEmp,cJobFil,cJobMod,cOpc,da0->da0_codtab,"",@cErro)
					if !empty(cErro)
						MsgInfo("Não conseguiu abrir a filial "+cJobFil+" para efetuar operação na tab. preços no ambiente Mercos Correspondente!", "Problema")
					endif
				endif
				If nTotThread > 5
					DelClassIntf()
					nTotThread := 0
				EndIf

			Next

			l_MyDa0 := .f.

		endif

		nTotThread := 0
		for nI := 1 to len(aLocal)
			cJobFil := aLocal[nI,1]
			cErro 	:= ''

			if nOpc == 3
				cOpc := "I"
			elseif nOpc == 4 .and. !lDel
				cIdMercos := ''
				if szb->(dbseek(xfilial()+cJobFil+"R"+da1->da1_codtab+da1->da1_codpro))
					cIdMercos := szb->zb_idreg
				endif
				if empty(cIdMercos)
					cOpc := "I"
				elseIf sb1->b1_msblql == '1' .and. !empty(cIdMercos)
					cOpc := 'B'
				elseif !empty(cIdMercos)
					cOpc := 'A'
				EndIf
			elseif nOpc == 5 .or. lDel
				cOpc  := "E"
			endif

			nTotThread += 1
			lWait := .f.
			if lWait
				lOk := startjob("u_prePrdOper",getenvserver(),lWait,cJobEmp,cJobFil,cJobMod,cOpc,da1->da1_codtab,da1->da1_codpro,@cErro)
				if !lOk
					MsgInfo("Não conseguiu abrir a filial "+cJobFil+" para efetuar operação na tab. preços no ambiente Mercos Correspondente!", "Problema")
				endif
			else
				startjob("u_prePrdOper",getenvserver(),lWait,cJobEmp,cJobFil,cJobMod,cOpc,da1->da1_codtab,da1->da1_codpro,@cErro)
				if !empty(cErro)
					MsgInfo("Não conseguiu abrir a filial "+cJobFil+" para efetuar operação na tab. preços no ambiente Mercos Correspondente!", "Problema")
				endif
			endif
			If nTotThread > 5
				DelClassIntf()
				nTotThread := 0
			EndIf
		Next

		aEval(aAreas, {|x| RestArea(x) })
	endif

Return Nil
