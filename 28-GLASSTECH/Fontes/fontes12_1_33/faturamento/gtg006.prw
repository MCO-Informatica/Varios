#include "Protheus.ch"
/* Gatilho referente ao retorno do valor de venda */
User Function gtg006()

	Local aAreas	:= {sa1->(GetArea()),se4->(GetArea()),da1->(GetArea()),sb1->(GetArea()),sf7->(GetArea()),sx5->(GetArea()), GetArea()}
	Local nPrcVen 	:= 0
	Local nPCom     := 0
	Local nVlrdce	:= 0
	Local nPercIcms	:= 0
	Local nPercIpi  := 0
	Local nPercPIS	:= 0
	Local nPercCOF	:= 0
	Local nPPisCof	:= 0
	Local nFPisCof 	:= 0
	Local nFIcms 	:= 0
	Local nRet      := 0
	local nFator    := 0
	local nFImp     := 1

	Local nBasICM   := 0
	Local nVlrICM   := 0
	Local nVlrPIS   := 0
	Local nVlrCOF   := 0
	Local nVlrIPI   := 0
	Local nVlrSol   := 0
	Local nVlrTot   := 0
	//Local cEstICMS := GetMv("MV_ESTICM")

	if !tmp1->ck_flag		// gatilho ck_qtdven 001

		if m->cj_cliente+m->cj_loja != sa1->a1_cod+sa1->a1_loja
			sa1->(DbSetOrder(1))
			sa1->( DbSeek( xFilial()+m->cj_cliente+m->cj_loja ) )
		endif
		if m->cj_condpag != se4->e4_codigo
			se4->(DbSetOrder(1))
			se4->(dbseek(xfilial()+m->cj_condpag))
		endif
		if tmp1->ck_produto+m->cj_tabela != da1->da1_codpro+da1->da1_codtab
			da1->(DbSetOrder(2))
			da1->(dbseek(xfilial()+tmp1->ck_produto+m->cj_tabela))
		endif
		if tmp1->ck_produto != sb1->b1_cod
			sb1->(DbSetOrder(1))
			sb1->(dbseek(xfilial()+tmp1->ck_produto))
		endif

		u_gtf005(tmp1->ck_produto,@nPercIcms,@nPercIpi,@nPercPIS,@nPercCOF)

		if !empty(sa1->a1_suframa)	//.or sa1->a1_zzraatv == "2"
			u_gtf001(sa1->a1_cod,sa1->a1_loja,sa1->a1_tipo,tmp1->ck_produto,m->cj_condpag,tmp1->ck_tes,tmp1->ck_qtdven,tmp1->ck_prcven,tmp1->ck_qtdven*tmp1->ck_prcven,tmp1->ck_valdesc,@nBasICM,@nVlrICM,@nVlrPIS,@nVlrCOF,@nVlrIPI,@nVlrSol,@nVlrTot)
			nPercPIS := round((nVlrPIS/nBasICM)*100,2)
			nPercCOF := round((nVlrCOF/nBasICM)*100,2)

			nPCom    := nPercIcms
		else
			sx5->(DbSetOrder(1))
			sx5->(dbseek(xfilial()+"ZZ"+m->cj_tabela))
			while !sx5->(eof()) .and. alltrim(sx5->x5_tabela+sx5->x5_chave) == "ZZ"+alltrim(m->cj_tabela)
				if alltrim(sx5->x5_descri) == sa1->a1_est .and. alltrim(sx5->x5_descspa) == m->cj_xnivel
					nPCom := val(alltrim(sx5->x5_desceng))
				endif
				sx5->(dbskip())
			end
		endif

		if m->cj_cliente == '002613'	//IRIZAR
			u_gtf001(sa1->a1_cod,sa1->a1_loja,sa1->a1_tipo,tmp1->ck_produto,m->cj_condpag,tmp1->ck_tes,tmp1->ck_qtdven,tmp1->ck_prcven,tmp1->ck_qtdven*tmp1->ck_prcven,tmp1->ck_valdesc,@nBasICM,@nVlrICM,@nVlrPIS,@nVlrCOF,@nVlrIPI,@nVlrSol,@nVlrTot)
			nPercPIS := round((nVlrPIS/nBasICM)*100,2)
			nPercCOF := round((nVlrCOF/nBasICM)*100,2)
		endif

		//nPrcVen	:= da1->da1_prcven
		nPrcVen	:= a415Tabela(tmp1->ck_produto,m->cj_tabela,tmp1->ck_qtdven)
		if m->cj_xtpfatu == "2"
			nVlrdce := (nPrcVen * (sa1->a1_xpdce/100))
		endif
		nPrcVen -= nVlrdce									// Desconto cliente especial
		nPrcVen := nPrcVen * (1+(se4->e4_xacrsfi/100))		// Acréscimo financeiro
		nPrcVen := nPrcVen * (1+(nPCom/100))				// TX compensação impostos

		nPPisCof := nPercPIS + nPercCOF
		nFPisCof := (100-nPPisCof)/100

		nFIcms := (100-nPercIcms)/100

		nRet := round((nPrcVen/nFPisCof)/nFIcms,2)

		if m->cj_cliente == '002613'		//PREÇO UNITARIO IRIZAR = PRECO UNITARIO * (100% - %ICMS)
			nFImp := (100-nPercIcms) / 100
		elseif m->cj_cliente == '021984'	//PREÇO UNITARIO VOLVO = PRECO UNITARIO * [100% - (%PIS + %COFINS + %ICMS)]
			//nFImp := (100-(nPercPIS + nPercCOF + nPercIcms)) / 100
			nFImp := 100-(nPercPIS + nPercCOF + nPercIcms)
			nFImp := nFImp / (100-(nPercPIS + nPercCOF ))
		elseif m->cj_cliente == '007267'	//PREÇO UNITARIO JACTO = PRECO UNITARIO * [100% - (%PIS + %COFINS + %ICMS)]/({100%-[%PIS+%COFINS+%ICMS(100%-%DESCONTO ICMS)]})
			nFImp := 100-(nPercPIS + nPercCOF + nPercIcms)
			nFImp := nFImp / (100-(nPercPIS + nPercCOF + (nPercIcms-sf4->f4_xdesIcm)))
		endif

		nRet := nRet * nFImp

		if m->cj_xnivel == "2" //.and. m->cj_xtpfatu == "1"
			nFator := 2
		else
			nFator := 1
		endif
		nRet := round(nRet/nFator,2)

	endif

	aEval(aAreas, {|x| RestArea(x) })

Return nRet
