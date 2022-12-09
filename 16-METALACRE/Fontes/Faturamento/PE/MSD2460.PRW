#include "rwmake.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2460	ºAutor  ³ Luiz Alberto       º Data ³18/08/2004   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para gravacao do Codigo FCI             
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico Solutiuon                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MSD2460 
Local _aArea := getarea()
Local _aAreaSB1 := sb1->(getarea())
Local _aAreaSC5 := sc5->(getarea())
Local _aAreaSC6 := sc6->(getarea())

/*
//³ mv_par15 Atualiza Cli.X Prod?                                 ³
//³ mv_par16 Emitir             ?  Nota / Cupom Fiscal            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MT460A",.F.)
lMostraCtb  := MV_PAR01==1
lAglutCtb   := MV_PAR02==1
lCtbOnLine  := MV_PAR03==1
lCtbCusto   := MV_PAR04==1
lReajusta   := MV_PAR05==1
nCalAcrs    := MV_PAR06
nArredPrcLis:= MV_PAR08

*/

lAtuSA7     := MV_PAR15==1

If !sd2->d2_tipo $ "D/B" .And. SC6->(FieldPos("C6_FCICOD")) > 0
  	SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
  	SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))
  	SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
   
	If SB1->(FieldPos("B1_FCICOD")) > 0
	  	SD2->D2_FCICOD  := Iif(Empty(SC6->C6_FCICOD),SB1->B1_FCICOD,SC6->C6_FCICOD)
	Else
	  	SD2->D2_FCICOD  := SC6->C6_FCICOD
	Endif

	// Atualizou Registro na SA7
	If cEmpAnt == '01'
		If SA7->(dbSetOrder(1), dbSeek(xFilial("SA7")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD)) .And. Empty(SA7->A7_XOPC)
			If RecLock("SA7",.F.)
				SA7->A7_XNOMCLI	:= SA1->A1_NOME
				SA7->A7_DESCCLI := SB1->B1_DESC
				SA7->A7_XOPC	:= SC6->C6_OPC
			Endif
		ElseIf !SA7->(dbSetOrder(1), dbSeek(xFilial("SA7")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+AllTrim(SC6->C6_OPC)))
			If RecLock("SA7",.t.)
				SA7->A7_FILIAL := xFilial("SA7")
				SA7->A7_CLIENTE := SD2->D2_CLIENTE
				SA7->A7_LOJA	:= SD2->D2_LOJA
				SA7->A7_PRODUTO	:= SD2->D2_COD
				SA7->A7_XNOMCLI	:= SA1->A1_NOME
				SA7->A7_DESCCLI := SB1->B1_DESC
				SA7->A7_XOPC	:= SC6->C6_OPC
			Endif
		Endif
	Endif
EndIf



Restarea(_aArea)   
Restarea(_aAreaSB1)   
Restarea(_aAreaSC5)   
Restarea(_aAreaSC6)   
   
Return
