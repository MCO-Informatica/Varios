#include 'protheus.ch'
#include 'parmtype.ch'

user function MA030BRW()
Local cFilBrw := ""	// Sintax de filtro da mBrowse
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//쿝etorna condicao de filtro para o Browse de Apontamentos ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

If SA3->(dbSetOrder(7), dbSeek(xFilial("SA3")+__cUserID)) .And. SA3->A3_TIPO == 'E'	// Representantes
	cFilBrw := "A1_VEND == '" + SA3->A3_COD + "' "
Endif

Return(cFilBrw)