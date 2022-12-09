#Include 'Protheus.ch'

User Function NumSZ4()

Local _Retorno

	// � feito um tratamento bruto de erro. Caso n�o d� certo, � feito um rollback da numera��o
	if reclock('SZ4',.T.)
	    // Utilize o cIDCNAB neste bloco na grava��o de campo(s).
	    _Retorno := GetSxeNum("SZ4","Z4_IDAPTHR","Z4_IDAPTHR" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZ4')
	else
	    RollbackSx8()
	endif


Return _Retorno
