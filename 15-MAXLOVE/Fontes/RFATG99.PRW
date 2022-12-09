#include "protheus.ch"

User Function RFATG99()

    Local _cCliente	:=	M->C5_CLIENTE
    Local _cLoja	:=	M->C5_LOJACLI
// Local _cFormaPg	:=	M->C5_FORMAPG



    dbSelectArea("SA1")
    dbSetOrder(1)
    If dbSeek(xFilial("SA1")+_cCliente+_cLoja,.f.)

        If !SA1->A1_RISCO$"A"
            MsgStop("Este cliente está bloqueado pelo financeiro, pois existem títulos a receber em aberto. O pedido poderá ser barrado no momento do faturamento se a situação permanecer.")
        EndIf
    
    EndIf


Return(_cCliente)
