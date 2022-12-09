#Include 'Protheus.ch'

User Function NumSZC()

	Local _RetornoSZC

	// � feito um tratamento bruto de erro. Caso n�o d� certo, � feito um rollback da numera��o
	if reclock('SZC',.T.)
	    // Utilize o cIDCNAB neste bloco na grava��o de campo(s).
	    _RetornoSZC := "N1" + substr(GetSX8NUM("SZC","ZC_IDPLAN"),3,7)
	    ConfirmSx8()
	    msunlock('SZC')
	else
	    RollbackSx8()
	endif

Return _RetornoSZC