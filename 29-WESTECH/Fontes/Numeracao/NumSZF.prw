#Include 'Protheus.ch'

User Function NumSZF()

	Local _Retorno



	// É feito um tratamento bruto de erro. Caso não dê certo, é feito um rollback da numeração
	if reclock('SZF',.T.)
	    // Utilize o cIDCNAB neste bloco na gravação de campo(s).
	    _Retorno := GetSxeNum("SZF","ZF_IDVEND","ZF_IDVEND" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZF')
	else
	    RollbackSx8()
	endif


Return _Retorno

