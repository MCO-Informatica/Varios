#Include 'Protheus.ch'

User Function NumSZG()

Local _Retorno

	// � feito um tratamento bruto de erro. Caso n�o d� certo, � feito um rollback da numera��o
	if reclock('SZG',.T.)
	    // Utilize o cIDCNAB neste bloco na grava��o de campo(s).
	    _Retorno := GetSxeNum("SZG","ZG_IDVDSUB","ZG_IDVDSUB" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZG')
	else
	    RollbackSx8()
	endif


Return _Retorno
