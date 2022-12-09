#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#Define  CRLF Chr(13)+Chr(10)

//+----------------------------------------------------------------+
//| Rotina | CSFAT020 | Autor | Rafael Beghini | Data | 10/04/2015 |
//+----------------------------------------------------------------+
//| Descr. | Rotina para alterar o código do vendedor no pedido    |
//|        | de venda quando Voucher for do tipo 'F'               |
//+----------------------------------------------------------------+
//| Uso    | CertiSign - Faturamento                               |
//+----------------------------------------------------------------+
User Function CSFAT020(cVoucher)
	Local cOport    := ''
	Local cVendedor := ''

	dbSelectArea("SZF")
	dbSetOrder(2)
	If dbSeek(xFilial("SZF")+cVoucher)
		cOport := Alltrim(SZF->ZF_OPORTUN)
		If SZF->ZF_TIPOVOU == 'F'
			dbSelectArea("AD1")
			dbSetOrder(1)
			If dbSeek(xFilial("AD1")+cOport)
				cVendedor := Alltrim(AD1->AD1_VEND)
					
				If !Empty(cVendedor)
					M->C5_VEND1 := cVendedor
				EndIf
			EndIf
		EndIf
	EndIf
Return