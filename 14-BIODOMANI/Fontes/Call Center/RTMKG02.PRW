#include "protheus.ch"

User Function RTMKG02()

    Local _cCliente	:=	M->ACF_CLIENTE
    Local _cLoja	:=	M->ACF_LOJA
// Local _cFormaPg	:=	M->C5_FORMAPG



    dbSelectArea("SA1")
    dbSetOrder(1)
    If dbSeek(xFilial("SA1")+_cCliente+_cLoja,.f.)

        //----> VERIFICA SE TEM BLOQUEIO FINANCEIRO
        If SA1->A1_SITFIN$"I"
            MsgAlert("Cliente inadimplente. N?o ser? permitido a inclus?o do pedido. Depto Financeiro deve verificar")
        ElseIf SA1->A1_SITFIN$"B"
            MsgAlert("N?o ? permitido faturamento no BOLETO para este cliente. Oriente escolha de outra modalidade de pagamento.")
        EndIf

        If !SA1->A1_RISCO$"A"
            MsgStop("Este cliente n?o est? bloqueado pelo financeiro, por?m existe t?tulos a receber em aberto. O pedido poder? ser barrado no momento do faturamento se a situa??o permanecer.")
        EndIf
    EndIf


Return(_cCliente)