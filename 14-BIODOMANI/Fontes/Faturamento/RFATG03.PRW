#include "protheus.ch"

User Function RFATG03()

    Local _cVendC 	:= 	Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_VEND")
    Local _cVendS 	:= 	Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_VEND1")
    Local _cCliente	:=	M->C5_CLIENTE
    Local _cTipo	:=	M->C5_TIPO


//----> TIPO PEDIDO (B/D) DESCONSIDERAR
    If !_cTipo$"BD"

        //----> VENDEDOR COSMOBEAUTY
        If !Empty(_cVendC) .and. !Subs(_cVendC,1,1)$"CZ"
            MsgAlert("Vendedor(a) da Linha Cosmobeauty n?o atualizado. Favor acionar o(a) supervisor(a) para regularizar o cadastro do cliente.")
            _cCliente	:=	"      "
        EndIf

        //----> VENDEDOR SAMANA
        If !Empty(_cVendS) .and. !Subs(_cVendS,1,1)$"SZ"
            MsgAlert("Vendedor(a) da Linha Samana n?o atualizado. Favor acionar o(a) supervisor(a) para regularizar o cadastro do cliente.")
            _cCliente	:=	"      "
        EndIf

    EndIf

Return(_cCliente)


