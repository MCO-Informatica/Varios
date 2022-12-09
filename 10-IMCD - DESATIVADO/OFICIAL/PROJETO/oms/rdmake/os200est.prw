#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function OS200EST()
	Local aCabPedCom := {}
	Local aItePedCom := {}
	Local cTitulo    := "Geração de Pedido de Frete (OS200EST)"

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "OS200EST" , __cUserID )

	If !Empty(DAK->DAK_PEDFRE)
		SC7->(DbSetOrder(1))
		SC7->(DbSeek(xFilial("SC7")+DAK->DAK_PEDFRE))

		aCabPedCom := {}
		aItePedCom := {}
		aAdd(aCabPedCom, {"C7_NUM", DAK->DAK_PEDFRE, Nil})

		aAdd(aItePedCom, {})
		aAdd(aItePedCom[Len(aItePedCom)], {"C7_NUM", DAK->DAK_PEDFRE, Nil})

		lMsHelpAuto := .T.
		lMsErroAuto := .F.	
		MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)}, 1, aCabPedCom, aItePedCom, 5)
		If lMsErroAuto
			MostraErro()
			MsgStop("Houve um problema na exclusão do pedido de frete. A carga não será estornada.", cTitulo)
			Final("")
		EndIf
	EndIf
Return