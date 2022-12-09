#Include 'Protheus.ch'

User Function NumSZD()
	Local _RetornoSZD

	// É feito um tratamento bruto de erro. Caso não dê certo, é feito um rollback da numeração
	if reclock('SZD',.T.)
	    // Utilize o cIDCNAB neste bloco na gravação de campo(s).
	    _RetornoSZD := "N2" + substr(GetSX8NUM("SZD","ZD_IDPLSUB"),3,7)
	    ConfirmSx8()
	    msunlock('SZD')
	else
	    RollbackSx8()
	endif

Return _RetornoSZD

