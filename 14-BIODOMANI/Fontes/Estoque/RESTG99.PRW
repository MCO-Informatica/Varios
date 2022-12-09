#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function RESTG99()

Local _cLote := M->B7_LOTECTL


DbSelectArea("SB8")
DbSetOrder(3)
If !DbSeek(xFilial("SB8")+M->B7_COD+M->B7_LOCAL+M->B7_LOTECTL,.f.)

    MsgAlert("O lote informado não existe para este produto e será inserido no estoque.")

EndIf

Return(_cLote)
