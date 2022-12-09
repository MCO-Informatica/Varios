#include "rwmake.ch"

// Funcao       F370E1F
// Autor 		Alexandre Dalpiaz
// Data 		17/01/2013
// Descricao    ponto de entrada na contabiliza��o do financeiro (fina370). N�o permite contabilizar t�tulos que n�o s�o da filial de origem.
// Uso          Especifico para laselva
//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F370E1F()
///////////////////////

_lRet := .f.

If SE1->E1_MSFIL >= MV_PAR09 .and. SE1->E1_MSFIL <= MV_PAR10
	_lRet := .t.
EndIf

Return(_lRet)