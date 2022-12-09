#include "Protheus.ch"
/* Retornar o calculo m² Comercial */
User Function gtg008(cModel,nDimen,nLarg,nCompr)

	Local nRet := 0

	if cModel == '1'
		nDimen	/= 1000
		nLarg	/= 1000
		nCompr	/= 1000

		if nDimen <= 0
			nRet := (nLarg + 0.040) * (nCompr + 0.040)
		else
			nRet := (((nLarg + 0.040) + (nCompr + 0.040)) * nDimen) / 2
		endif

	else
		nRet := u_gtg009(nDimen,nLarg,nCompr)
	endif

Return nRet
