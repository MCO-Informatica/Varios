#include "protheus.ch"

User Function RFATG02()

	Local _cCliente	:=	M->C5_CLIENTE
	Local _cLoja	:=	M->C5_LOJACLI
	Local _cFormaPg	:=	M->C5_FORMAPG


	//----> S? EXECUTAR SE A ROTINA FOR CHAMADA NA MATA410
	If Alltrim(FunName()) $"MATA410"

		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbSeek(xFilial("SA1")+_cCliente+_cLoja,.f.)

			//----> SE FOR FOLHA DE PAGAMENTO NAO PRECISA CHECAR INADIMPLENCIA
			If !_cFormaPg$"FP"
				//----> VERIFICA SE TEM BLOQUEIO FINANCEIRO
				If SA1->A1_SITFIN$"I"
					MsgAlert("Cliente inadimplente. N?o ser? permitido a inclus?o do pedido. Favor verificar junto ao Depto. Financeiro")
					_cCliente	:= ""
				ElseIf SA1->A1_SITFIN$"B" .And. _cFormaPg$"FI.BO"
					MsgAlert("N?o ? permitido faturamento no BOLETO para este cliente. Escolha outra modalidade de pagamento.")
					_cCliente	:= ""
				EndIf

				If !SA1->A1_RISCO$"A"
					MsgStop("Este cliente n?o est? bloqueado pelo financeiro, por?m existe t?tulos a receber em aberto. O pedido ser? barrado no momento do faturamento se a situa??o permanecer.")
				EndIf
			EndIf
		EndIf
	EndIf

Return(_cCliente)
