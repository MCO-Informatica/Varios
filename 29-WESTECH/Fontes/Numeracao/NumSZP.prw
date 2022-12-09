#Include 'Protheus.ch'

User Function NumSZP()

Local _Retorno

	// É feito um tratamento bruto de erro. Caso não dê certo, é feito um rollback da numeração
	if reclock('SZP',.T.)
	    // Utilize o cIDCNAB neste bloco na gravação de campo(s).
	    _Retorno := GetSxeNum("SZP","ZP_IDVDSB2","ZP_IDVDSB2" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZP')
	else
	    RollbackSx8()
	endif


Return _Retorno

