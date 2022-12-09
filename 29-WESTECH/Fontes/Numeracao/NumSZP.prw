#Include 'Protheus.ch'

User Function NumSZP()

Local _Retorno

	// � feito um tratamento bruto de erro. Caso n�o d� certo, � feito um rollback da numera��o
	if reclock('SZP',.T.)
	    // Utilize o cIDCNAB neste bloco na grava��o de campo(s).
	    _Retorno := GetSxeNum("SZP","ZP_IDVDSB2","ZP_IDVDSB2" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZP')
	else
	    RollbackSx8()
	endif


Return _Retorno

