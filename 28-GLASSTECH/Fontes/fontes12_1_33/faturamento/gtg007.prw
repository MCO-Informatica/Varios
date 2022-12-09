#include "Protheus.ch"
/* Retornar o calculo do Peso liquido */
User Function gtg007(cTpVidro,nDimen,nLarg,nCompr,nEspess)

	Local nRet := 0
	Local nM2real := u_gtg009(nDimen,nLarg,nCompr)

	if cTpVidro == "T"
		nRet := (nM2Real * nEspess * 2.500)
	elseif cTpVidro == "L"
		nRet := (nM2Real * (nEspess - 1) * 2.500) + (nM2Real * 0.820)
	endif

Return nRet
