#include "Protheus.ch"

/* Gatilho referente a verificação se os produtos digitados fazem parte da tabela de preços */
User Function gtg005()

	Local aAreas:= {tmp1->(GetArea()), da1->(GetArea()), sz3->(GetArea()), sb1->(GetArea()), GetArea()}
	Local lRet  := .t.
	Local cTes  := ""
	//Local n_LimDVe := 0
	//Local n_LimDGe := 0
	Local nPos  := 0
	Local aProdOrc := {}
	//Local cUf   := "**"

	if empty(m->cj_tabela)
		lRet := .f.
		alert("Favor preencher a tabela de Preços!")
	else

		if m->cj_cliente+m->cj_loja != sa1->a1_cod+sa1->a1_loja
			sa1->(DbSetOrder(1))
			sa1->( DbSeek( xFilial()+m->cj_cliente+m->cj_loja ) )
		endif

		if m->cj_xnivel $ "6|8"
			cTes := GetNewPar("MV_XTES68", "506")	 //no nivel 6 pode ser 516 se o valor do Lucro Passar o Lucro Presumido
		else
			cTes := sa1->a1_xtes
		endif

		DbSelectArea("SZ3")
		DbSetOrder(1)	// Z3_FILIAL+Z3_TPFATU+Z3_UF+Z3_TPMATE+Z3_GRUPO

		da1->(DbSetOrder(2))
		sb1->(DbSetOrder(1))

		tmp1->(dbgotop())
		while !tmp1->(eof())
			if !tmp1->ck_flag
				if !empty(tmp1->ck_tes) .and. tmp1->ck_tes != cTes
					lRet := .f.
					alert("TES incorreta no produto "+alltrim(tmp1->ck_produto)+". Verifique!")
				endif
				if !empty(tmp1->ck_produto) .and. !da1->( DbSeek( xFilial()+tmp1->ck_produto+m->cj_tabela ) )
					lRet := .f.
					alert("Produto "+alltrim(tmp1->ck_produto)+" não esta presente na tabela de Preços!")
				endif

				nPos := aScan(aProdOrc,{|x| x == tmp1->ck_produto})
				if nPos == 0
					aadd(aProdOrc,tmp1->ck_produto)
				else
					lRet := .f.
					alert("Produto "+alltrim(tmp1->ck_produto)+" já foi registrado no item "+strzero(nPos,2)+" !")
				endif

				if !lDir
					if sa1->a1_xpdce != 0
						if tmp1->ck_xdescV + tmp1->ck_xdescG > sa1->a1_xpdce
							lRet := .f.
							alert("O limite do desconto foi violado no produto "+alltrim(tmp1->ck_produto)+". Seu limite é "+alltrim(str(sa1->a1_xpdce))+"%, Verifique!")
						endif
					else
						/*
						if sa1->a1_est $ "RJ|SP|MG"
							cUf := sa1->a1_est
						endif
						
						if tmp1->ck_produto != sb1->b1_cod
							sb1->( DbSeek( xFilial()+tmp1->ck_produto ) )
						endif

						n_LimDVe := 0
						n_LimDGe := 0
						if sz3->( DbSeek( xFilial()+m->cj_xtpfatu+cUf+sb1->b1_tipoprd+sb1->b1_grupo ) )  // Z3_FILIAL+Z3_TPFATU+Z3_UF+Z3_TPMATE+Z3_GRUPO
							n_LimDVe := sz3->z3_pmaxVe
							n_LimDGe := sz3->z3_pmaxGe
						endif

						if tmp1->ck_xdescV > n_LimDVe
							tmp1->(reclock("TMP1",.f.))
							tmp1->ck_xdescV := n_LimDVe
							tmp1->ck_descont := tmp1->ck_xdescV + tmp1->ck_xdescG
							tmp1->ck_valdesc := (tmp1->ck_descont * (tmp1->ck_prunit * tmp1->ck_qtdven))/100
							tmp1->ck_prcven  := tmp1->ck_prunit - (tmp1->ck_valdesc/tmp1->ck_qtdven)
							tmp1->ck_valor   := tmp1->ck_prcven * tmp1->ck_qtdven
							tmp1->(MsUnlock())
							//If ExistTrigger('CK_XDESCV')
							//	RunTrigger(2,nI,nil,,'CK_XDESCV')
							//endif
							//lRet := .f.
							//alert("O limite do desconto dado pelo Vendedor violou o limite permitido: "+alltrim(str(n_LimDVe))+"%, Verifique!")
						endif
						if tmp1->ck_xdescG > n_LimDGe
							tmp1->(reclock("TMP1",.f.))
							tmp1->ck_xdescG  := n_LimDGe
							tmp1->ck_xvldesG := (tmp1->ck_xdescG * (tmp1->ck_prunit * tmp1->ck_qtdven))/100
							tmp1->ck_descont := tmp1->ck_xdescV + tmp1->ck_xdescG
							tmp1->ck_valdesc := (tmp1->ck_descont * (tmp1->ck_prunit * tmp1->ck_qtdven))/100
							tmp1->ck_prcven  := tmp1->ck_prunit - (tmp1->ck_valdesc/tmp1->ck_qtdven)
							tmp1->ck_valor   := tmp1->ck_prcven * tmp1->ck_qtdven
							tmp1->(MsUnlock())
							//If ExistTrigger('CK_XDESCG')
							//	RunTrigger(2,nI,nil,,'CK_XDESCG')
							//endif
							//lRet := .f.
							//alert("O limite do desconto dado pelo Gerente violou o limite permitido: "+alltrim(str(n_LimDGe))+"%, Verifique!")
						endif
						*/
					endif
				endif
			endif
			tmp1->(dbskip())
		end

		aEval(aAreas, {|x| RestArea(x) })

		oGetdad:oBrowse:Refresh()
	endif

Return lRet
