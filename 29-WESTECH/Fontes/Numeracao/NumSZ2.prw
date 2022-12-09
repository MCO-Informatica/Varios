#Include 'Protheus.ch'

User Function NumSZ2()

	Local _Retorno

	// É feito um tratamento bruto de erro. Caso não dê certo, é feito um rollback da numeração
	if reclock('SZ2',.T.)
	    // Utilize o cIDCNAB neste bloco na gravação de campo(s).
	    _Retorno := GetSxeNum("SZ2","Z2_CODRDV","Z2_CODRDV" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZ2')
	else
	    RollbackSx8()
	endif


Return _Retorno
