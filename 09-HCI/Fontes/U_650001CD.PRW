#INCLUDE 'PROTHEUS.CH'

/* Regra de LP 650001 para alimentar a conta de debito das notas de entrada
Reegra Padrao::
If(!Empty(SA2->A2_CCPROD),SA2->A2_CCPROD,IF(!Empty(SD1->D1_CONTA),SD1->D1_CONTA,If(!Empty(SF4->F4_CONTA),SF4->F4_CONTA,SB1->B1_CONTA)))                                                                 
*/

User Function 650001CD()      

	Local cContaFornecedor		:= Alltrim(SA2->A2_CCPROD)
	Local cContaNFItem		:= AllTrim(SD1->D1_CONTA)
	//Local cContaTes		:= AllTrim(SF4->F4_CONTA)
	//Local cTESItem		:= AllTrim("10E|10F|10G|10H|10I|10J|10L|10M|10N")
	Local cTESItem			:= SUPERGETMV("ES_TESCD",.T.,"10E|10F|10G|10H|10I|10J|10L|10M|10N")
	Local cContaDebito		:= ""

	IF AllTrim(SD1->D1_TES) $ AllTrim(cTESItem)
		cContaDebito := "4.2.1.04.23"
		Return(cContaDebito)
	EndIF
	
	IF !(Empty(cContaFornecedor))
		cContaDebito := AllTrim(cContaFornecedor)
		Return(cContaDebito)
	EndIF
	
	IF !(Empty(cContaNFItem))
		cContaDebito := AllTrim(cContaNFItem)
		Return(cContaDebito)
	EndIF		                             
	
/*	IF !(Empty(cContaTes))
		cContaDebito := cContaTes
		Return(cContaDebito)
	EndIF
*/	
	
Return AllTrim(cContaDebito)	