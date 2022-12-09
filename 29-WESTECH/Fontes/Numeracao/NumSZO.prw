#Include 'Protheus.ch'

User Function NumSZO()
	Local _RetornoSZO

	// � feito um tratamento bruto de erro. Caso n�o d� certo, � feito um rollback da numera��o
	if reclock('SZO',.T.)
	    // Utilize o cIDCNAB neste bloco na grava��o de campo(s).
	    _RetornoSZO := "N3" + substr(GetSX8NUM("SZO","ZO_IDPLSB2"),3,7)
	    ConfirmSx8()
	    msunlock('SZO')
	else
	    RollbackSx8()
	endif


Return _RetornoSZO


