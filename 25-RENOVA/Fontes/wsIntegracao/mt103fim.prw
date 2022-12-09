#Include 'Protheus.ch'

User Function mt103fim()
	Local aAreas  := {sd1->(GetArea()), sf4->(GetArea()), szb->(GetArea()), GetArea()}

	Local nRotina := paramixb[1]  //3=Incluir 4=Classificar 5=Excluir
	Local nOpca   := paramixb[2]  //1= Ok

	Local cJobEmp := cEmpAnt
	Local cJobFil := cFilAnt
	Local cJobMod := "FAT"
	Local cOpc    := "I"
	Local cErro	  := ""
	Local cCompl  := ""

	if cJobEmp == '00' .and. nOpca == 1 .and. ( nRotina == 3 .or. nRotina == 4 .or. nRotina == 5)

		szb->(DbSetOrder(1))
		sd1->( dbSetOrder(1) )
		sd1->( dbSeek(xfilial()+sf1->f1_doc+sf1->f1_serie+sf1->f1_fornece+sf1->f1_loja) )

		while sd1->d1_filial == sf1->f1_filial .and. sd1->d1_doc == sf1->f1_doc .and. sd1->d1_serie == sf1->f1_serie .and. ;
				sd1->d1_fornece == sf1->f1_fornece .and. sd1->d1_loja == sf1->f1_loja

			sf4->( dbSetOrder(1) )
			sf4->( dbSeek(xfilial()+sd1->d1_tes) )
			if sf4->f4_atuatf == "S"

				szb->(dbseek(xfilial()+sb1->(xfilial())+"A"+sd1->d1_cod))

				if nRotina == 5
					if !szb->(eof())
						cOpc := "E"
					endif
				else
					cOpc := "I"
					if !szb->(eof())
						cOpc := "A"
					endif
					cCompl  := xfilial()+sf1->f1_doc+sf1->f1_serie+sf1->f1_fornece+sf1->f1_loja
				endif

				if !empty(cOpc)
					u_atiOper(cJobEmp,cJobFil,cJobMod,cOpc,sd1->d1_cod,cCompl,@cErro)
					//startjob("u_atiOper",getenvserver(),.f./*lWait*/,cJobEmp,cJobFil,cJobMod,cOpc,sd1->d1_cod,,@cErro)
					if !empty(cErro)
						MsgInfo("Não conseguiu efetuar a operação no ativo no ambiente Cmms! Ativo:"+sd1->d1_cod, "Problema")
					endif
				endif

			endif
			sd1->(dbskip())
		end

	endif

	aEval(aAreas, {|x| RestArea(x) })

Return
