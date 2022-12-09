#Include 'Protheus.ch'

User Function verSaldo(cMaterial,cLocal,cLocaliz)

	local nSldDisp := 0

	sb2->(DbSetOrder(1))
	sbf->(dbSetOrder(1))

	if empty(cLocaliz)
		if sb2->(dbseek(xfilial()+cMaterial+cLocal))
			nSldDisp := SaldoSB2()
		endif
	else
		if sbf->(dbSeek(xFilial()+cLocal+cLocaliz+cMaterial)) .and.;
				sb2->(dbseek(xfilial()+cMaterial+cLocal))
			nSldDisp := sbf->bf_quant-sbf->bf_empenho
		endif
	endif

Return nSldDisp
