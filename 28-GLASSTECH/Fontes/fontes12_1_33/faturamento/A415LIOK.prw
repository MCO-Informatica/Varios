#include "Protheus.ch"

User Function a415liok()
	Local lRet		:= .t.
	Local aAreas	:= {sa1->(GetArea()), da1->(GetArea()), sf4->(GetArea()), GetArea()}
	Local nPrUnit 	:= 0
	Local nValor	:= 0
	Local nValDesc  := 0
	//Local nFator    := 0
	//Local cEstE     := ""
	Local nBasICM	:= 0
	Local nVlrICM	:= 0
	Local nVlrPIS   := 0
	Local nVlrCOF   := 0
	Local nVlrIPI	:= 0
	Local nVlrSol	:= 0
	Local nVlrTot	:= 0

	if !tmp1->ck_flag

		sf4->(dbSetOrder(1))
		if !sf4->( dbSeek(xFilial()+tmp1->ck_tes) )
			lRet := .f.
			alert("TES incorreta no produto "+alltrim(tmp1->ck_produto)+". Verifique!")
		else
			lRet := u_gtg005()
			if lRet
				/*
				if m->cj_cliente+m->cj_loja != m->cj_client+m->cj_lojaent
					sa1->(DbSetOrder(1))
					sa1->( DbSeek( xFilial()+m->cj_client+m->cj_lojent ) )
				endif
				if empty(sa1->a1_este)
					cEstE := sa1->a1_est
				else
					cEstE := sa1->a1_este
				endif
				nFator := u_gtf002(m->cj_xnivel,m->cj_xtpfatu,cEstE)

				if m->cj_xnivel == "2" .and. m->cj_xtpfatu == "1"
					nFator := 2
				else
					nFator := 1
				endif
				*/
				nPrUnit  := tmp1->ck_prunit					//round(tmp1->ck_prunit/nFator,2)
				nValor	 := tmp1->ck_qtdven*tmp1->ck_prunit	//round((tmp1->ck_qtdven*tmp1->ck_prunit)/nFator,2)
				nValDesc := tmp1->ck_valdesc				//round(tmp1->ck_valdesc/nFator,2)

				if m->cj_cliente+m->cj_loja != sa1->a1_cod+sa1->a1_loja
					sa1->(DbSetOrder(1))
					sa1->( DbSeek( xFilial()+m->cj_cliente+m->cj_loja ) )
				endif

				u_gtf001(sa1->a1_cod,sa1->a1_loja,sa1->a1_tipo,tmp1->ck_produto,m->cj_condpag,tmp1->ck_tes,tmp1->ck_qtdven,nPrUnit,nValor,nValDesc,@nBasICM,@nVlrICM,@nVlrPIS,@nVlrCOF,@nVlrIPI,@nVlrSol,@nVlrTot)

				tmp1->ck_xvlripi := nVlrIPI
				tmp1->ck_xicmsol := nVlrSol
				tmp1->ck_xvlrtot := nVlrTot
			endif
		endif

		aEval(aAreas, {|x| RestArea(x) })

	endif

Return lRet
