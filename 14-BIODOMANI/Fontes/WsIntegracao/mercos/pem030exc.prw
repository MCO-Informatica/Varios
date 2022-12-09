#include "Protheus.ch"

User Function pem030exc()
	Local aAreas := {GetArea()}
	Local cOpc  := "E"       //C-Consulta;I-Inclusão;A-Alteração;B-Bloqueio;E-Exclusão
	Local cErro := ""
	Local nI := 0
	Local aLocal := {}
	Local cJobEmp := cEmpAnt
	Local cJobFil := '0101'
	Local cJobMod := 'FAT'
	Local lOk	  := .t.
	Local lWait   := .t.
	Local nTotThread := 0

	If cJobEmp == '01'
		aLocal := u_mercos98()
		for nI := 1 to len(aLocal)
			cJobFil := aLocal[nI,1]
			cErro 	:= ''

			nTotThread += 1
			lWait := .f.

			lOk := startjob("u_cliOper",getenvserver(),lWait,cJobEmp,cJobFil,cJobMod,cOpc,sa1->a1_cod,sa1->a1_loja,@cErro)
			if !empty(cErro) .or. lWait .and. !lOk
				MsgInfo("Não conseguiu abrir a filial "+cJobFil+" para efetuar a exclusão do cliente no ambiente Mercos Correspondente!", "Problema")
			endif

			If nTotThread > 5
				DelClassIntf()
				nTotThread := 0
			EndIf
		Next
		aEval(aAreas, {|x| RestArea(x) })
	endif
Return .t.
