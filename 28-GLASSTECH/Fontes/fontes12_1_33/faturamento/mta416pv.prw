#Include 'Protheus.ch'

User Function mta416pv()

	Local aAreas := {sa1->(GetArea()), GetArea()}
	Local nLin := PARAMIXB	//numero da linha que esta verificando
	Local cEstE := ""
	Local nFator := 0
	Local nPosPrc := aScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_PRCVEN'})
	Local nPosPru := aScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_PRUNIT'})
	Local nPosVal := aScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_VALOR'})
	Local nPosDes := aScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_VALDESC'})
	Local nPosTes := aScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_TES'})
	//Local nPosipi := aScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_VLRIPI'})
	//Local nPossol := aScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_ICMSOL'})
	//Local nPostot := aScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XVLRTOT'})

	if scj->cj_cliente+scj->cj_loja != scj->cj_client+scj->cj_lojaent
		sa1->(DbSetOrder(1))
		sa1->( DbSeek( xFilial()+scj->cj_client+scj->cj_lojent ) )
	endif
	if empty(sa1->a1_este)
		cEstE := sa1->a1_est
	else
		cEstE := sa1->a1_este
	endif
	nFator := u_gtf002(scj->cj_xnivel,scj->cj_xtpfatu,cEstE)

	if nLin == 1

		if nFator == 3
			if cEstE == "SP"
				m->c5_cliente := "016016"
				m->c5_lojacli := "01"
			elseif cEstE == "RJ"
				m->c5_cliente := "023895"
				m->c5_lojacli := "01"
			elseif cEstE == "MG"
				m->c5_cliente := "022979"
				m->c5_lojacli := "01"
			endif
		endif

		m->c5_xtpfatu := scj->cj_xtpfatu
		m->c5_xnivel := scj->cj_xnivel
		m->c5_xcodusu := scj->cj_xcodusu

		m->c5_vend1 := scj->cj_zzven
		m->c5_transp := scj->cj_zztrans

	endif

	if nFator != 3
		nFator := 1
	endif
	_aCols[nLin,nPosPrc] := round(sck->ck_prcven/nFator,2)
	_aCols[nLin,nPosVal] := round(sck->ck_valor/nFator,2)
	_aCols[nLin,nPosDes] := round(sck->ck_valdesc/nFator,2)
	_aCols[nLin,nPosPru] := round(sck->ck_prunit/nFator,2)
	
	if scj->cj_xtpfatu == "2"
		if m->c5_cliente == "016016"	//SP
			cTes := GetNewPar("MV_XTES68", "506")
		elseif m->c5_cliente == "023895"	//RJ
			cTes := GetNewPar("MV_XTES68", "506") //ou 516 se o valor do Lucro Passar o Lucro Presumido
		elseif m->c5_cliente == "022979"	//MG
			cTes := GetNewPar("MV_XTES68", "506")
		endif
	else
		cTes := sck->ck_tes
	endif

	_aCols[nLin,nPosTes] := cTes
	//_aCols[nLin,nPosipi] := sck->ck_xvlripi
	//_aCols[nLin,nPossol] := sck->ck_xicmsol
	//_aCols[nLin,nPostot] := sck->ck_xvlrtot

	aEval(aAreas, {|x| RestArea(x) })
Return Nil
