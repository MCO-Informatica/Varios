#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATG001  บ Autor ณCintia Aquino       บ Data ณ  15/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGatilho C6_TES - Alterar valor unitario para Standard       บฑฑ
ฑฑบ          ณ  caso a TES selecionada nao gere financeiro e nao bloqueia บฑฑ
ฑฑบ          ณ  alteracao do preco pelo usuario.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico LISONDA.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function RFATG001(nTipo)

Local nPosProd  := GdFieldPos("C6_PRODUTO",aHeader)
Local nPosTES   := GdFieldPos("C6_TES"    ,aHeader)
Local nPosUnit  := GdFieldPos("C6_PRCVEN" ,aHeader)
Local nPosTotal := GdFieldPos("C6_VALOR"  ,aHeader)
Local nRetVal   := aCols[n, nPosUnit]
Local lGerFIN   := GetAdvFval("SF4", "F4_DUPLIC", xFilial('SF4') + aCols[n, nPosTES] , 1, 'S')
Local nCustStd  := GetAdvFval("SB1", "B1_CUSTD" , xFilial('SB1') + aCols[n, nPosProd], 1, aCols[n, nPosUnit])

Private cEOL    := CHR(13) + CHR(10)

Default nTipo   := 0

If !Empty( aCols[n, nPosTES] )
	If nTipo == 1
		If lGerFIN <> "S"
			nRetVal := nCustStd
		EndIf
	Else
		If lGerFIN <> "S"
			MsgInfo("Aten็ใo"+ cEOL + cEOL +"O pre็o nใo pode ser alterado para itens com TES que geram financeiro"+ cEOL, "Aten็ใo")
			
			nRetVal := .F.
		Else
			nRetVal := .T.
		EndIf
	EndIf
Else
	nRetVal := .T.
EndIf

Return(nRetVal)