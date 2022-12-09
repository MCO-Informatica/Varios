#INCLUDE "TOTVS.CH"

/*

Ponto:  Ap�s a grava��o de todos os dados e antes da contabiliza��o na rotina de Libera��o de Cheques.

Observa��o       S� ser� executado se MV_LIBCHEQ = "N".
*/
User Function FA190LIB()
Local aArea := GetArea()
Local aAreaSEF := SEF->(GetArea())

If RecLock("SEF",.F.)
	SEF->EF_LA   := Space(TamSX3("EF_LA")[1])
	SEF->EF_DATA := dDataBase
	If SEF->EF_TIPO = 'PA'
		SEF->EF_IMPRESS := 'A'
	EndIf
	MSUNLOCK()
EndIf
RestArea(aArea)
RestArea(aAreaSEF)

Return
