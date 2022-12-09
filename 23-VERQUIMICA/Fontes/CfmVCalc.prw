#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmVCalc | Autor: Celso Ferrone Martins   | Data: 25/07/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Gatilho para execucao do Programa de ajuste de Frete       |||
||+-----------+------------------------------------------------------------+||
||| Alteracao | Revisado 12/08/2014 - Celso Martins                        |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CfmVCalc(cCpo)

Local lRet     := .T.
Local nPosCpo  := aScan(aHeader,{|x| Alltrim(x[2])==cCpo})	       // Posicao do Campo
Local nPosCapa := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_CAPA"}) // Capacidade
Local nPosDens := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_DENS"}) // Densidade

Local nPQtdVer := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_QTDE"}) // Quantidade
Local nPUniVer := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"}) // Valor Unitário
Local nPTotVer := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_VLRI"}) // Valor Total

Local nPQtdUm1 := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT"})   // Quantidade
Local nPUniUm1 := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VRUNIT"})  // 1a-Valor Unitário
Local nPTotUm1 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"}) // 1a-Valor Total

Local nPQtdUm2 := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT2"})  // Quantidade
Local nPUniUm2 := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VRUNIT2"}) // 2a-Valor Unitário
Local nPTotUm2 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITE2"}) // 2a-Valor Total

Local nPosVRTb := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRCTAB"})  // Tabela de Preço

Local nPosBICM := aScan(aHeader,{|x| Alltrim(x[2])=="UB_BASEICM"})  // Tabela de Preço
Local nPosPICM := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PICM"}) // Percentual de ICMS
Local nPosPPis := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PPIS"}) // Percentual de Pis
Local nPosPCof := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PCOF"}) // Percentual de Cof

Local lExecGat := &("M->"+cCpo) != aCols[n][nPosCpo]

If lExecGat
	aCols[n][nPosCpo] := &("M->"+cCpo)

	aCols[n][nPUniUm1] := 0
	aCols[n][nPTotUm1] := 0
	aCols[n][nPUniUm2] := 0
	aCols[n][nPTotUm2] := 0
	aCols[n][nPUniVer] := 0
	aCols[n][nPTotVer] := 0
	aCols[n][nPosVRTb] := 0
	aCols[n][nPosBICM] := 0

	aCols[n][nPosPICM] := 0
	aCols[n][nPosPPis] := 0
	aCols[n][nPosPCof] := 0

	If cCpo == "UB_VQ_UM"
		If &("M->"+cCpo) == "KG"
			aCols[n][nPQtdVer] := Round(aCols[n][nPQtdVer] * aCols[n][nPosDens],2)
			aCols[n][nPosCapa] := Round(aCols[n][nPosCapa] * aCols[n][nPosDens],2)
		Else
			aCols[n][nPQtdVer] := Round(aCols[n][nPQtdVer] / aCols[n][nPosDens],2)
			aCols[n][nPosCapa] := Round(aCols[n][nPosCapa] / aCols[n][nPosDens],2)
		EndIf
	EndIf
	U_fGFrete()

/*	
oGetTLV:Refresh()
TK273DesCab()
oGetTLV:Refresh()
TK273DesCab()
oGetTLV:Refresh()
TK273DesCab()	
*/

EndIf

Return(lRet)
