#Include "Protheus.Ch"

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+---------------------------------+------------------+||
||| Programa: MT120APV | Autor: Celso Ferrone Martins    | Data: 18/06/2014 |||
||+-----------+--------+---------------------------------+------------------+||
||| Descricao | PE para alterar o grupo de aprovacao do pedido de compras   |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/        

User Function MT120APV()        
 
Local cNumPV 	:= SC7->C7_NUM
Local cGrAprOld := SC7->C7_APROV
Local cGrAprNew := Space(Len(SC7->C7_APROV))
Local aAreaSc7  := SC7->(GetArea())
Local aAreaCTT  := CTT->(GetArea())
Local cNumPC    := SC7->C7_NUM

DbSelectArea("CTT") ; DbSetOrder(1)  
DbSelectArea("SC7") ; DbSetOrder(1)

If AllTrim(FunName()) == "MATA121"
	If !Empty(cA120Cc)
		If SC7->(DbSeek(xFilial("SC7")+cNumPC))
			While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cNumPC
				RecLock("SC7",.F.)
				SC7->C7_CC      := cA120Cc
				MsUnLock()
				SC7->(DbSkip())
			EndDo
		EndIf
	EndIf
EndIf

If SC7->(DbSeek(xFilial("SC7")+cNumPV))
	While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM)==xFilial("SC7")+cNumPV
		If CTT->(DbSeek(xFilial("CTT")+SC7->C7_CC))
			If !Empty(CTT->CTT_GRPAPV)
				cGrAprNew := CTT->CTT_GRPAPV
				Exit
			EndIf
		EndIf
		SC7->(DbSkip())
	EndDo
EndIf
SC7->(RestArea(aAreaSc7))

If Empty(cGrAprNew)
	cGrAprNew :=cGrAprOld
EndIf

Return(cGrAprNew)          
