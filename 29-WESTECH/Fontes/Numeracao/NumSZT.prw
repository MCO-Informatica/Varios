#Include 'Protheus.ch'

User Function NumSZT()
Local _Retorno
	// � feito um tratamento bruto de erro. Caso n�o d� certo, � feito um rollback da numera��o
	if reclock('SZT',.T.)
	    // Utilize o cIDCNAB neste bloco na grava��o de campo(s).
	    _Retorno := GetSxeNum("SZT","ZT_IDVDSB3","ZG_IDVDSB3" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZT')
	else
	    RollbackSx8()
	endif


Return _Retorno


