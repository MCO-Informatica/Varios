#include "Protheus.ch"
/* Retornar a descrição da aplicação do produto */
User Function gtg012(cProduto)

	Local aAreas:= {sx5->(GetArea()), sb5->(GetArea()), GetArea()}
	Local cRet := ''
	Default cProduto := &(ReadVar())

	if sb5->(dbseek(xfilial()+cProduto))
		sx5->(DbSetOrder(1))
		if sx5->(dbseek(xfilial()+"ZY"+sb5->b5_xaplic))
			cRet  := alltrim(sx5->x5_descri)
		endif
	endif

	aEval(aAreas, {|x| RestArea(x) })

Return cRet
