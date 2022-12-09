#Include 'Protheus.ch'

User Function NumSZF()

	Local _Retorno



	// � feito um tratamento bruto de erro. Caso n�o d� certo, � feito um rollback da numera��o
	if reclock('SZF',.T.)
	    // Utilize o cIDCNAB neste bloco na grava��o de campo(s).
	    _Retorno := GetSxeNum("SZF","ZF_IDVEND","ZF_IDVEND" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZF')
	else
	    RollbackSx8()
	endif


Return _Retorno

