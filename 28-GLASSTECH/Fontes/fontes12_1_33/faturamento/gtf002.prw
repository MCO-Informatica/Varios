#include "Protheus.ch"
/* Retornar fator indicativo do valor para gerar venda à empresa*/
User Function gtf002(cNivel,ctpfat,cEst)

    Local nFator := 0

	if ctpfat == "2" .and. (cEst $ "RJ|MG" .and. cNivel == "2" .or. cEst == "SP" .and. cNivel == "6")
		nFator := 3
	elseif cNivel == "2"
		nFator := 2
	else'
		nFator := 1
	endif

Return nFator
