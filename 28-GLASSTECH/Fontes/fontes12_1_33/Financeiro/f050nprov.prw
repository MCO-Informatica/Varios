#include 'protheus.ch'
User Function f050nprov()
	Local lRet := .t.

	if !empty((cAliasSE2)->e2_ok) .and. cFilAnt != se2->e2_filorig
		lRet := .f.
		Help( ,, 'Help',, "Os títulos devem ser da mesma filial. ", 1, 0 )
	endif

Return lRet
