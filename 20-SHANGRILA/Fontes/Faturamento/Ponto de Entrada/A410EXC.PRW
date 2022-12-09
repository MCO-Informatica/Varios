#include "rwmake.ch"
#include "protheus.ch"

***********************
User Function A410EXC()
	***********************

	//Local cPosNumItem     := AScan(aHeader, {|aX| Trim(aX[2])=="C6_ITEM"})
	//Local cPosQtdade      := AScan(aHeader, {|aX| Trim(aX[2])=="C6_QTDVEN"})

	//Local cC6_ITEM := " "
	//Local i:=0
/*
	dbselectarea('AA3')
	DbOrderNickName('AA3PED')

	For i := 1 to Len(aCols)

		cC6_ITEM     := aCols[cPosNumItem]

		if dbseek(xfilial('AA3')+M->C5_NUM+cC6_ITEM)
			MsgAlert("Pedido não pode ser excluido pois existe registro de Status de Produção !!!","Atenção !!!")
			return .f.

			RecLock("AA3",.F.)
			AA3->(DbDelete())
			AA3->(MsUnlock())
		endif

	next
*/
    DbSelectArea("ZB5")
    DbSetOrder(1)
    If DbSeek(xFilial("ZB5")+SC5->C5_XPEDEMP)
        RecLock("ZB5",.f.)
        ZB5->ZB5_IMPORT := '2'
        MsUnlock()
    EndIf

    DbSelectArea("SUA")
    DbSetOrder(8)
    If DbSeek(xFilial("SUA")+SC5->C5_NUM)
        RecLock("SUA",.f.)
        SUA->UA_CANC := 'S'
        MsUnlock()
    EndIf

    

return NIL
