#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmVPrc  | Autor: Celso Ferrone Martins   | Data: 05/08/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Ajusta peco dos itens em KG e Litro                        |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CfmVPrc(nOpc)

Local lRet := .T.
Local nPosProd  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"}) // Produto

Local nPQtdVer  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"}) // Quantidade
Local nPUniVer  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"}) // Valor Unitário
Local nPTotVer  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_VLRI"}) // Valor Total

Local nPQtdUm1  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT"})   // Quantidade
Local nPUniUm1  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VRUNIT"})  // Valor Unitário
Local nPTotUm1  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"}) // Valor Total

Local nPQtdUm2  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT2"})  // Quantidade
Local nPUniUm2  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VRUNIT2"}) // Valor Unitário
Local nPTotUm2  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITE2"}) // Valor Total

Local nPosVqUm  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_UM"})   // Unidade de Medida Verquimica
Local nPosDens  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_DENS"}) // Densidade
Local nPosVRTb  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRCTAB"})  // Tabela de Preço

Local nPosVal   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VAL"})  // Valor tabela
Local nPosMoed  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MOED"}) // Moeda

//Local nFatorMoed := StaticCall(FgFrete,CfmTaxm2)
Local nFatorMoed := U_FGFRETE()

Local aAreaSb1 := SB1->(GetArea())
Local aAreaZ02 := Z02->(GetArea())

Local cEol     := CHR(13)+CHR(10)

DbSelectArea("SB1") ; DbSetOrder(1)
DbSelectArea("Z02") ; DbSetOrder(1)

SB1->(DbSeek(xFilial("SB1")+aCols[n][nPosProd]))
Z02->(DbSeek(xFilial("Z02")+aCols[n][nPosProd]))

If nOpc == 1
	aCols[n][nPUniVer] := M->UB_VQ_VRUN
EndIf

If SB1->B1_UM == Z02->Z02_UM
	If Z02->Z02_UM == aCols[n][nPosVqUm]
		nValUnt1 := aCols[n][nPUniVer]							// ok
		If SB1->B1_UM == "KG"
			nValUnt2 := aCols[n][nPUniVer] * Z02->Z02_DENSID
		Else
			nValUnt2 := aCols[n][nPUniVer] / Z02->Z02_DENSID	// ok
		EndIf
	Else
		nValUnt2 := aCols[n][nPUniVer]							// ok
		If SB1->B1_UM == "KG"
			nValUnt1 := aCols[n][nPUniVer] / Z02->Z02_DENSID
		Else
			nValUnt1 := aCols[n][nPUniVer] * Z02->Z02_DENSID	// ok	
		EndIf
	EndIf
Else
	If Z02->Z02_UM == aCols[n][nPosVqUm]
		nValUnt2 := aCols[n][nPUniVer]							// ok
		If SB1->B1_UM == "KG"
			nValUnt1 := aCols[n][nPUniVer] / Z02->Z02_DENSID	// ok	
		Else
			nValUnt1 := aCols[n][nPUniVer] * Z02->Z02_DENSID
		EndIf
	Else
		nValUnt1 := aCols[n][nPUniVer]							// ok
		If SB1->B1_UM == "KG"
			nValUnt2 := aCols[n][nPUniVer] * Z02->Z02_DENSID	// ok	
		Else
			nValUnt2 := aCols[n][nPUniVer] / Z02->Z02_DENSID
		EndIf
	EndIf
EndIf

/*
If aCols[n][nPosMoed] == "2"
	nValUnt1 := nValUnt1 * nFatorMoed
	nValUnt2 := nValUnt2 * nFatorMoed
EndIf
*/

aCols[n][nPUniUm1] := nValUnt1
aCols[n][nPosVRTb] := nValUnt1
aCols[n][nPUniUm2] := nValUnt2

aCols[n][nPTotVer] := aCols[n][nPQtdVer] * aCols[n][nPUniVer]
aCols[n][nPTotUm1] := aCols[n][nPQtdUm1] * aCols[n][nPUniUm1]
aCols[n][nPTotUm2] := aCols[n][nPQtdUm2] * aCols[n][nPUniUm2]

SB1->(RestArea(aAreaSb1))
Z02->(RestArea(aAreaZ02))

oGetTLV:Refresh()
TK273DesCab()
oGetTLV:Refresh()
TK273DesCab()
oGetTLV:Refresh()
TK273DesCab()

If nOpc == 1 .And. lRet
	If aCols[n][nPUniVer] < aCols[n][nPosVal]
		MsgAlert("Atencao!!!."+cEol+"Valor utilizado esta abaixo da tabela de preco.","Preco abaixo da tabela!")
	EndIf
EndIf

Return(lRet)
