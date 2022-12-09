#include 'protheus.ch'
#include 'parmtype.ch'

user function TK260FIL()
Local cFilBrw := ""	// Sintax de filtro da mBrowse
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna condicao de filtro para o Browse de Apontamentos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If SA3->(dbSetOrder(7), dbSeek(xFilial("SA3")+__cUserID)) .And. SA3->A3_TIPO == 'E'	// Representantes
	cFilBrw := "US_VEND == '" + SA3->A3_COD + "' "
Endif

Return(cFilBrw)