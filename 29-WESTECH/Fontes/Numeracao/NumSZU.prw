#Include 'Protheus.ch'

User Function NumSZU()

Local _RetornoSZU
	Local Retorno2

	if reclock('SZU',.T.)
	    // Utilize o cIDCNAB neste bloco na gravação de campo(s).
	    _RetornoSZU := "N4" + substr(GetSX8NUM("SZU","ZU_IDPLSB3"),3,7)
	    ConfirmSx8()
	    msunlock('SZU')
	else
	    RollbackSx8()
	endif

Return _RetornoSZU

