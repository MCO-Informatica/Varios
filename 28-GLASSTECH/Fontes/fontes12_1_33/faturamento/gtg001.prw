#include "Protheus.ch"
/* Gatilho referente ao preenchimento do campo nível */
User Function gtg001()
	Local aAreas := {sa1->(GetArea()), sz2->(GetArea()), tmp1->(GetArea()), GetArea()}
	//Local cEstE  := ""
	Local cRet   := " "
	Local cTes   := ""

	if m->cj_cliente+m->cj_loja != sa1->a1_cod+sa1->a1_loja
		sa1->(DbSetOrder(1))
		sa1->( DbSeek( xFilial()+m->cj_cliente+m->cj_loja ) )
	endif

	if sa1->a1_xfilvin == cFilAnt

		cTes := sa1->a1_xtes

		if sa1->a1_xnivel1
			cRet := "1"
		elseif sa1->a1_xnivel2
			cRet := "2"
		elseif sa1->a1_xnivel6
			cRet := "6"
			cTes := GetNewPar("MV_XTES68", "506")	//no nivel 6 pode ser 516 se o valor do Lucro Passar o Lucro Presumido
		elseif sa1->a1_xnivel8
			cRet := "8"
			cTes := GetNewPar("MV_XTES68", "506")
		endif

		if Empty(cRet)
			Alert("Verificar cadastro de Cliente pois não foi definido um nível!")
		else

			m->cj_xtpfatu := sa1->a1_xtpfatu
			m->cj_condpag := sa1->a1_cond
			m->cj_zzven := sa1->a1_vend
			m->cj_zztrans := sa1->a1_transp

			m->cj_xlimcrd := sa1->a1_lc - u_gtf003(,sa1->a1_cod,,,,.f.)	//SldCliente(sa1->a1_cod,dDatabase,1,.t.)

			tmp1->(dbgotop())
			while !tmp1->(eof())
				if !tmp1->ck_flag
					tmp1->(reclock("TMP1",.f.))
					tmp1->ck_tes := cTes
					tmp1->(MsUnlock())
				endif
				tmp1->(dbskip())
			end

			If ExistTrigger('CJ_CONDPAG')
				RunTrigger(1,nil,nil,,'CJ_CONDPAG')
			endif
			If ExistTrigger('CJ_ZZVEN')
				RunTrigger(1,nil,nil,,'CJ_ZZVEN')
			endif
			If ExistTrigger('CJ_ZZTRANS')
				RunTrigger(1,nil,nil,,'CJ_ZZTRANS')
			endif
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
		if cEstE $ "RJ|MG" .and. cRet == "2" .or.;
				cEstE == "SP" .and. cRet == "6"
			m->cj_xtpfatu := "2"
		else
			m->cj_xtpfatu := "1"
		endif
		*/
		endif
	else
		m->cj_cliente := space(06)
		m->cj_loja := space(02)
		if Empty(sa1->a1_xfilvin)
			Alert("O campo de vinculo com filial do cliente, não esta preenchido. Favor verificar!")
		else
			Alert("O Orçamento deste cliente deve ser feito na filial: "+sa1->a1_xfilvin)
		endif
	endif

	aEval(aAreas, {|x| RestArea(x) })

	oGetdad:oBrowse:Refresh()

Return cRet
