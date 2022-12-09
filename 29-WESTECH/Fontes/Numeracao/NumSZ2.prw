#Include 'Protheus.ch'

User Function NumSZ2()

	Local _Retorno

	// � feito um tratamento bruto de erro. Caso n�o d� certo, � feito um rollback da numera��o
	if reclock('SZ2',.T.)
	    // Utilize o cIDCNAB neste bloco na grava��o de campo(s).
	    _Retorno := GetSxeNum("SZ2","Z2_CODRDV","Z2_CODRDV" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZ2')
	else
	    RollbackSx8()
	endif


Return _Retorno
