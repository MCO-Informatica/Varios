#include "protheus.ch"

User Function RFATG99()

    Local _cCliente	:=	M->C5_CLIENTE
    Local _cLoja	:=	M->C5_LOJACLI
// Local _cFormaPg	:=	M->C5_FORMAPG



    dbSelectArea("SA1")
    dbSetOrder(1)
    If dbSeek(xFilial("SA1")+_cCliente+_cLoja,.f.)

        If !SA1->A1_RISCO$"A"
            MsgStop("Este cliente est? bloqueado pelo financeiro, pois existem t?tulos a receber em aberto. O pedido poder? ser barrado no momento do faturamento se a situa??o permanecer.")
        EndIf
    
    EndIf


Return(_cCliente)
