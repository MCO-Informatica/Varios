#include "Protheus.ch"
/* Gatilho referente ao retorno dos impostos 1- ipi, 2 - solidário, 3 - total, de total os itens digitados */
User Function gtg003()

	Local lRet		:= .t.
	Local aAreas	:= {tmp1->(GetArea()),sa1->(GetArea()), GetArea()}
	Local cTes		:= ""
	Local nPrcVen 	:= 0
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

	/*
	if  m->cj_cliente+m->cj_loja != m->cj_client+m->cj_lojaent
		sa1->(DbSetOrder(1))
		sa1->( DbSeek( xFilial()+m->cj_client+m->cj_lojent ) )
	endif
	if empty(sa1->a1_este)
		cEstE := sa1->a1_est
	else
		cEstE := sa1->a1_est
	endif
	nFator := u_gtf002(m->cj_xnivel,m->cj_xtpfatu,cEstE)

	if m->cj_xnivel == "2" .and. m->cj_xtpfatu == "1"
		nFator := 2
	else'
		nFator := 1
	endif
	*/
	if m->cj_cliente+m->cj_loja != sa1->a1_cod+sa1->a1_loja
		sa1->(DbSetOrder(1))
		sa1->( DbSeek( xFilial()+m->cj_cliente+m->cj_loja ) )
	endif

	if m->cj_xnivel $ "6|8"
		cTes := GetNewPar("MV_XTES68", "506")	//no nivel 6 pode ser 516 se o valor do Lucro Passar o Lucro Presumido
	else
		cTes := sa1->a1_xtes
	endif

	tmp1->(dbgotop())
	while !tmp1->(eof())
		if !tmp1->ck_flag

			nPrcVen := U_gtg006()                                                                                          
			nValor	:= tmp1->ck_qtdven*nPrcVen
			nValDesc:= (tmp1->ck_descont*nValor)/100
			//nPrcVen := tmp1->ck_prunit					//round(tmp1->ck_prunit/nFator,2)
			//nValor	:= tmp1->ck_qtdven*tmp1->ck_prunit	//round((tmp1->ck_qtdven*tmp1->ck_prunit)/nFator,2)
			//nValDesc:= tmp1->ck_valdesc					//round(tmp1->ck_valdesc/nFator,2)

			u_gtf001(sa1->a1_cod,sa1->a1_loja,sa1->a1_tipo,tmp1->ck_produto,m->cj_condpag,cTes,tmp1->ck_qtdven,nPrcVen,nValor,nValDesc,@nBasICM,@nVlrICM,@nVlrPIS,@nVlrCOF,@nVlrIPI,@nVlrSol,@nVlrTot)
			tmp1->(reclock("TMP1",.f.))
			tmp1->ck_prunit  := nPrcVen
			tmp1->ck_prcven  := nPrcVen-(nValDesc/tmp1->ck_qtdven)
			tmp1->ck_valor   := tmp1->ck_qtdven*tmp1->ck_prcven
			tmp1->ck_valdesc := nValDesc
			tmp1->ck_tes 	 := cTes
			tmp1->ck_entreg  := m->cj_xdtentr
			tmp1->ck_xvlripi := nVlrIPI
			tmp1->ck_xicmsol := nVlrSol
			tmp1->ck_xvlrtot := nVlrTot //+ nVlrIPI
			tmp1->ck_xprctot := iif(m->cj_xnivel=="2",(tmp1->ck_prcven*2)+tmp1->ck_xvlripi+tmp1->ck_xicmsol,0)
			tmp1->(MsUnlock())
		endif
		tmp1->(dbskip())
	end

	aEval(aAreas, {|x| RestArea(x) })

	oGetdad:oBrowse:Refresh()		//oGetdad:Refresh()  //oGrade:Refresh()

Return lRet
