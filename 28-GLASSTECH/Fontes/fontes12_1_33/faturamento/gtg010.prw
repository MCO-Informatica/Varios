#include "Protheus.ch"
/* Retornar o calculo do M² primitivo */
User Function gtg010(cModel,cTpVidro,nDimen,nLarg,nCompr,nEspess)

	Local nRet := 0

	if cModel == '1'
		nDimen	/= 1000
		nLarg	/= 1000
		nCompr	/= 1000

		if ( cTpVidro = 'T' .and. nEspess > 4 ) .or. ( cTpVidro = 'L' .and. nEspess > 9 )
			if nDimen <= 0
				nRet := (nLarg + 0.040) * (nCompr + 0.040)
			else
				nRet := (((nLarg + 0.040) + (nCompr + 0.040)) * nDimen) / 2
			endif
		else
			if nDimen <= 0
				nRet := (nLarg + 0.020) * (nCompr + 0.020)
			else
				nRet := (((nLarg + 0.020) + (nCompr + 0.020)) * nDimen) / 2
			endif
		endif

	else
		nRet := u_gtg009(nDimen,nLarg,nCompr)
	endif

Return nRet
