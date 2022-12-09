#Include 'Protheus.ch'

User Function NumSZD()
	Local _RetornoSZD

	// � feito um tratamento bruto de erro. Caso n�o d� certo, � feito um rollback da numera��o
	if reclock('SZD',.T.)
	    // Utilize o cIDCNAB neste bloco na grava��o de campo(s).
	    _RetornoSZD := "N2" + substr(GetSX8NUM("SZD","ZD_IDPLSUB"),3,7)
	    ConfirmSx8()
	    msunlock('SZD')
	else
	    RollbackSx8()
	endif

Return _RetornoSZD

