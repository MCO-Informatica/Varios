#include "Protheus.ch"

User Function MT120FIM()
    Local aArea := getArea()
	Local aAreaC7 := sc7->(getArea())
	Local nOper := PARAMIXB[1]   // Op��o Escolhida pelo usuario
	Local cNum  := PARAMIXB[2]   // Numero do Pedido de Compras
	Local nOpcA := PARAMIXB[3]   // Indica se a a��o foi Cancelada = 0  ou Confirmada = 1
    // nOper => 3 - Inclus�o; 4 - Altera��o; 5 - Exclus�o; 6 - C�pia; 7 - Devolu��o de Compras
	if nOpcA == 1 .and. nOper != 7
		fie->(DbSetOrder(1)) //FIE_FILIAL + FIE_CART + FIE_FORNEC + FIE_LOJA + FIE_PREFIX + FIE_NUM + FIE_PARCEL + FIE_TIPO + FIE_PEDIDO
		if fie->(DbSeek(xFilial()+"P"+sc7->c7_num))
			u_gta001(cNum,5)
		else
			u_gta001(cNum,nOper)
		endif
	endIf

    RestArea(aAreaC7)
	RestArea(aArea)
Return
