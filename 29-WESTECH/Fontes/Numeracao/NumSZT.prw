#Include 'Protheus.ch'

User Function NumSZT()
Local _Retorno
	// É feito um tratamento bruto de erro. Caso não dê certo, é feito um rollback da numeração
	if reclock('SZT',.T.)
	    // Utilize o cIDCNAB neste bloco na gravação de campo(s).
	    _Retorno := GetSxeNum("SZT","ZT_IDVDSB3","ZG_IDVDSB3" + cEmpAnt)
	    ConfirmSx8()
	    msunlock('SZT')
	else
	    RollbackSx8()
	endif


Return _Retorno


