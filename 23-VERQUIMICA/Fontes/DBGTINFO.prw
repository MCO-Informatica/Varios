#include 'protheus.ch'
#include 'parmtype.ch'

user function DBGTINFO(cInf)
DbSelectArea("SA1"); DbSetOrder(1)
DbSelectArea("SA2"); DbSetOrder(1)
DbSelectArea("SC5"); DbSetOrder(1)
DbSelectArea("SA3"); DbSetOrder(1)

If cInf == "VENDEDOR"
	If SC5->(DbSeek(xFilial("SC5")+SC9->(C9_PEDIDO)))
		If SA3->(DbSeek(xFilial("SA3")+SC5->(C5_VEND1)))
			Return SA3->A3_NOME
		EndIf
	EndIf
Else
	If SA1->(DbSeek(xFilial("SA1")+SC9->(C9_CLIENTE+C9_LOJA)))
		If cInf == "UF"
			Return SA1->A1_EST
		Else
			Return SA1->A1_MUN
		EndIf
	ElseIf SA2->(DbSeek(xFilial("SA2")+SC9->(C9_CLIENTE+C9_LOJA)))
		If cInf == "UF"
			Return SA2->A2_EST
		Else
			Return SA2->A2_MUN
		EndIf 
	Else
		Return ""
	EndIf
EndIf

Return ""