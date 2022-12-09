#Include 'Protheus.ch'

User Function NumSZC()

	Local _RetornoSZC

	// É feito um tratamento bruto de erro. Caso não dê certo, é feito um rollback da numeração
	if reclock('SZC',.T.)
	    // Utilize o cIDCNAB neste bloco na gravação de campo(s).
	    _RetornoSZC := "N1" + substr(GetSX8NUM("SZC","ZC_IDPLAN"),3,7)
	    ConfirmSx8()
	    msunlock('SZC')
	else
	    RollbackSx8()
	endif

Return _RetornoSZC