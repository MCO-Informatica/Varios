#include "Protheus.ch"
/* Retornar o calculo do M² Real */
User Function gtg009(nDimen,nLarg,nCompr)

	Local nRet := 0

	nDimen	/= 1000
	nLarg	/= 1000
	nCompr	/= 1000

	if nDimen <= 0
		nRet := nLarg * nCompr
	else
		nRet := ((nLarg + nCompr) * nDimen) / 2
	endif

Return nRet
