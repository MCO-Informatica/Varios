#Include 'Protheus.ch'

User Function NumSZ4()

Local _Retorno

	// É feito um tratamento bruto de erro. Caso não dê certo, é feito um rollback da numeração
	if reclock('SZ4',.T.)
	    // Utilize o cIDCNAB neste bloco na gravação de campo(s).
	    _Retorno := GetSxeNum("SZ4","Z4_IDAPTHR","Z4_IDAPTHR" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZ4')
	else
	    RollbackSx8()
	endif


Return _Retorno
