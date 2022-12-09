#Include 'Protheus.ch'

User Function NumSZG()

Local _Retorno

	// É feito um tratamento bruto de erro. Caso não dê certo, é feito um rollback da numeração
	if reclock('SZG',.T.)
	    // Utilize o cIDCNAB neste bloco na gravação de campo(s).
	    _Retorno := GetSxeNum("SZG","ZG_IDVDSUB","ZG_IDVDSUB" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZG')
	else
	    RollbackSx8()
	endif


Return _Retorno
