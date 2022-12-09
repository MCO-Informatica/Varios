#Include 'Protheus.ch'

User Function NumSZO()
	Local _RetornoSZO

	// É feito um tratamento bruto de erro. Caso não dê certo, é feito um rollback da numeração
	if reclock('SZO',.T.)
	    // Utilize o cIDCNAB neste bloco na gravação de campo(s).
	    _RetornoSZO := "N3" + substr(GetSX8NUM("SZO","ZO_IDPLSB2"),3,7)
	    ConfirmSx8()
	    msunlock('SZO')
	else
	    RollbackSx8()
	endif


Return _RetornoSZO


