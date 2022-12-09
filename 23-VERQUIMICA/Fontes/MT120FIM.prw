#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: MT120FIM  | Autor: Celso Ferrone Martins  | Data: 04/11/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function MT120FIM()

Local nOpcao := ParamIxb[1]   // Opção Escolhida pelo usuario
Local cNumPC := ParamIxb[2]   // Numero do Pedido de Compras
Local nOpcA  := ParamIxb[3]   // Indica se a ação foi Cancelada = 0  ou Confirmada = 1.CODIGO DE APLICAÇÃO DO USUARIO.....
Local aAreaSc7 := SC7->(GetArea())

IF nModulo <> 17 // 17 - SIGAEIC
	If nOpcA != 0
		DbSelectArea("SC7") ; DbSetOrder(1)
		If (nOpcao == 3 .Or. nOpcao == 4) //.And. !Empty(cCfmFretVer) .And. nCfmFretVer > 0
			If SC7->(DbSeek(xFilial("SC7")+cNumPC))
				While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cNumPC
					RecLock("SC7",.F.)
					SC7->C7_VQ_TRAN := cCfmFretVer
					SC7->C7_VQ_VFRE := nCfmFretVer
	//				SC7->C7_CC      := cA120Cc
					SC7->C7_VQ_TFRE := cCfmTpFretV
					MsUnLock()
					SC7->(DbSkip())
				EndDo
			EndIf
		EndIf
	EndIf

	SC7->(RestArea(aAreaSc7))

ENDIF

Return()
