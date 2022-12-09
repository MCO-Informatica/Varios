#include "protheus.ch"

User Function RTMKG03()

    Local _cVendC 	:= 	Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_VEND")
    Local _cVendS 	:= 	Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_VEND1")
    Local _cCliente	:=	M->UA_CLIENTE

//----> VENDEDOR COSMOBEAUTY
    If !Empty(_cVendC) .and. !Subs(_cVendC,1,1)$"CZ"
        MsgAlert("Vendedor(a) da Linha Cosmobeauty não atualizado. Favor acionar o(a) supervisor(a) para regularizar o cadastro do cliente.")
        _cCliente	:=	"      "
    EndIf

//----> VENDEDOR SAMANA
    If !Empty(_cVendS) .and. !Subs(_cVendS,1,1)$"SZ"
        MsgAlert("Vendedor(a) da Linha Samana não atualizado. Favor acionar o(a) supervisor(a) para regularizar o cadastro do cliente.")
        _cCliente	:=	"      "
    EndIf

Return(_cCliente)


