#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE  ENTER CHR(13)+CHR(10)

/**
* Funcao		:	SHFAT009
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Rotina para calculo do MUKPD e MKUPM de coeficiente
* Retorno		: 	Nenhum
*/
User Function SHFAT009()
	Local nDivisor := (100 - M->(ZD_ICMS + ZD_PIS + ZD_COFINS + ZD_IRPJ + ZD_AIRPJ + ZD_CSSL + ZD_DADP + ZD_DADG + ZD_DCDP + ZD_DCDG + ZD_DCCU + ZD_DCPCQE + ZD_DCPSI + ZD_DFDB + ZD_DFODF + ZD_TLDP + ZD_TLGG + ZD_TLFT + ZD_ML + ZD_DMVT + ZD_DMVV))/100
	Local nMultipl := (100 / nDivisor) / 100

	M->ZD_MKUPD :=  nDivisor
	M->ZD_MKUPM :=  nMultipl

	Return .T.



