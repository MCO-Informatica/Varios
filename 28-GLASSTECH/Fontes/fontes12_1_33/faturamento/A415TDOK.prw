#include "Protheus.ch"

User Function a415tdok()
	Local lRet		:= .f.
	Local aAreas	:= {sa1->(GetArea()), sz2->(GetArea()), se4->(GetArea()), sa4->(GetArea()), sa3->(GetArea()), GetArea()}
	Local nLimcrd 	:= 0

	se4->(DbSetOrder(1))
	sa4->(DbSetOrder(1))
	sa3->(DbSetOrder(1))

	if !se4->(dbseek(xfilial()+m->cj_condpag)) .or. se4->e4_msblql == "1"
		lRet := .f.
		alert("A condição de pagamento não é valida para essa filial, Verifique!")
	elseif !sa4->(dbseek(xfilial()+m->cj_zztrans)) .or. sa4->a4_msblql == "1"
		lRet := .f.
		alert("A transportadora não é valida para essa filial, Verifique!")
	elseif !sa3->(dbseek(xfilial()+m->cj_zzven)) .or. sa3->a3_msblql == "1"
		lRet := .f.
		alert("O vendedor não é valido para essa filial, Verifique!")
	else
		if m->cj_cliente+m->cj_loja != sa1->a1_cod+sa1->a1_loja
			sa1->(DbSetOrder(1))
			sa1->( DbSeek( xFilial()+m->cj_cliente+m->cj_loja ) )
		endif

		if m->cj_xtpfatu != sa1->a1_xtpfatu
			lRet := .f.
			alert("O tipo de pedido esta incorreto, Verifique!")
		elseif m->cj_zzven != sa1->a1_vend
			lRet := .f.
			alert("O cliente não é atendido por esse vendedor, Verifique!")
		else
			sz2->(DbSetOrder(1))
			sz2->( DbSeek( xFilial()+m->cj_cliente+m->cj_loja ) )
			while !sz2->(eof()) .and. m->cj_cliente == sz2->z2_codcli .and. m->cj_loja == sz2->z2_lojcli .and. lRet
				if sz2->z2_tipo == "C" .and. m->cj_condpag != alltrim(sz2->z2_codigo)
					lRet := .f.
					alert("A condição de pagamento digitada não esta no escopo de condições possíveis, Verifique!")
				elseif sz2->z2_tipo == "T" .and. m->cj_zztrans != alltrim(sz2->z2_codigo)
					lRet := .f.
					alert("A transportadora digitada não esta no escopo de transportadoras possíveis, Verifique!")
				endif
				sz2->(dbskip())
			end
			lRet := u_gtg004()
			if lRet
				lRet := u_gtg005()
			endif
		endif
	endif

	if lRet
		nLimcrd := sa1->a1_lc - SldCliente(sa1->a1_cod,dDatabase,1,.t.)
		if m->cj_xlimcrd != nLimcrd
			if MsgYesNo("Houve alteração do limite de crédito, Verifique!. Era "+transform(m->cj_xlimcrd,"@e 999,999,999.99")+" e o novo valor é "+transform(m->cj_xlimcrd,"@e 999,999,999.99")+". Confirma ?")
				m->cj_xlimcrd := sa1->a1_lc - SldCliente(sa1->a1_cod,dDatabase,1,.t.)
			else
				lRet := .f.
			endif
		endif
	endif

	aEval(aAreas, {|x| RestArea(x) })

Return lRet
