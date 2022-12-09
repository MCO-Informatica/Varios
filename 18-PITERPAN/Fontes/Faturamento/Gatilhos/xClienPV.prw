#include "Protheus.ch"
#include "TOTVS.ch"
#include "TopConn.ch"

User Function xClienPV()

cCliente := M->C5_CLIENTE
cLoja := M->C5_LOJACLI
//cCondP := M->C5_CONDPAG

dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+cCliente+cLoja)

    If SA1->A1_SIMPNAC=="1"
        MsgAlert("O Cliente selecionado é optante pelo Simples Nacional","ATENÇÃO")
    EndIf    
EndIf

Return(cCliente)