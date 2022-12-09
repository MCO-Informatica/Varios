#include "protheus.ch"

User Function RTMKG06()

    Local _cCliente	:=	M->UA_CLIENTE
    Local _cLoja	:=	Iif(!Empty(M->UA_LOJA),M->UA_LOJA,'01')

    dbSelectArea("SA1")
    dbSetOrder(1)
    If dbSeek(xFilial("SA1")+_cCliente+_cLoja,.f.)

        //----> VERIFICA SE TEM BLOQUEIO FINANCEIRO
        If Empty(SA1->A1_SATIV1)
            MsgStop("Cliente não segmentado. Favor revisar o cadastro do cliente e preencher o campo SEGMENTO na aba VENDAS")
            Tk271AltEnt()
            //_cCliente	:=	""
        EndIf
    EndIf

Return(_cCliente)