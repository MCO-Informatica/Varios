#include "protheus.ch"

User Function RFATG02()

	Local _cCliente	:=	M->C5_CLIENTE
	Local _cLoja	:=	M->C5_LOJACLI
	Local _cFormaPg	:=	M->C5_FORMAPG


	//----> SÓ EXECUTAR SE A ROTINA FOR CHAMADA NA MATA410
	If Alltrim(FunName()) $"MATA410"

		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbSeek(xFilial("SA1")+_cCliente+_cLoja,.f.)

			//----> SE FOR FOLHA DE PAGAMENTO NAO PRECISA CHECAR INADIMPLENCIA
			If !_cFormaPg$"FP"
				//----> VERIFICA SE TEM BLOQUEIO FINANCEIRO
				If SA1->A1_SITFIN$"I"
					MsgAlert("Cliente inadimplente. Não será permitido a inclusão do pedido. Favor verificar junto ao Depto. Financeiro")
					_cCliente	:= ""
				ElseIf SA1->A1_SITFIN$"B" .And. _cFormaPg$"FI.BO"
					MsgAlert("Não é permitido faturamento no BOLETO para este cliente. Escolha outra modalidade de pagamento.")
					_cCliente	:= ""
				EndIf

				If !SA1->A1_RISCO$"A"
					MsgStop("Este cliente não está bloqueado pelo financeiro, porém existe títulos a receber em aberto. O pedido será barrado no momento do faturamento se a situação permanecer.")
				EndIf
			EndIf
		EndIf
	EndIf

Return(_cCliente)
