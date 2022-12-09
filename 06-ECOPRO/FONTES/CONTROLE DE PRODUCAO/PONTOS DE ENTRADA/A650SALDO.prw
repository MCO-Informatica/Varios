#Include "Protheus.Ch"

User Function A650SALDO()
	Local nSaldoAnt := PARAMIXB
	Local nRetSaldo := 0

	if alltrim(funname()) == "MATA650"
		If SB1->B1_XKIT != 'S'
			nRetSaldo := nSaldoAnt
		Endif
	else
		nRetSaldo := nSaldoAnt
	Endif

Return nRetSaldo
