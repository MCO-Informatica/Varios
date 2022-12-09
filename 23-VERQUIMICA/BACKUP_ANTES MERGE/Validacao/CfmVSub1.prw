#Include "Protheus.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmVSub1 | Autor: Celso Ferrone Martins   | Data: 05/05/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Validacao no campo UB_QUANT                                |||
||+-----------+------------------------------------------------------------+||
||| Alteracao | Revisado 12/08/2014 - Celso Martins                        |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CfmVSub1()

Local lRet     := .T.
Local nPosProd := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"}) // Produto

Local nPQtdUm1 := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT"})   // Quantidade
Local nPUniUm1 := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VRUNIT"})  // Valor Unitário
Local nPTotUm1 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"}) // Valor Total

Local nPQtdUm2 := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT2"})  // Quantidade
Local nPUniUm2 := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VRUNIT2"}) // Valor Unitário
Local nPTotUm2 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITE2"}) // Valor Total

Local nPQtdVer := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"}) // Quantidade
Local nPUniVer := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"}) // Valor Unitário
Local nPTotVer := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_VLRI"}) // Valor Total

Local nPosCapa := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_CAPA"}) // Capacidade
Local nPosEM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_EM"})   // Embalagem
Local nPosVqUm := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_UM"})   // Unidade de Medida Verquimica
Local nPosDens := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_DENS"}) // Densidade

Local nPosVolum:= aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VOLU"}) // VOLUME
 
Local nDifEmb  := 0
Local cEol     := CHR(13)+CHR(10)
Local nQtdEmb  := 0

If aCols[n][nPosCapa] > 0 .And. AllTrim(aCols[n][nPosEM]) != "03000"
	nDifEmb  := M->UB_VQ_QTDE / aCols[n][nPosCapa]
	If nDifEmb - Int(nDifEmb) != 0 .And. M->UB_VQ_QTDE > 0
		MsgAlert("Quantidade nao permitida."+cEol+"Utilize Multiplos de "+AllTrim(Str(aCols[n][nPosCapa])),"Divergencia na quantidade.")
		lRet := .F.
	EndIf
EndIf

If lRet

	DbSelectArea("SB1") ; DbSetOrder(1)
	aAreaSb1 := SB1->(GetArea())
	SB1->(DbSeek(xFilial("SB1")+aCols[n][nPosProd]))

	If SB1->B1_UM == "KG"
		If aCols[n][nPosVqUm] == SB1->B1_UM 
			nQtdUm1 := M->UB_VQ_QTDE
			nQtdUm2 := M->UB_VQ_QTDE / aCols[n][nPosDens]
		Else
			nQtdUm1 := M->UB_VQ_QTDE * aCols[n][nPosDens]
			nQtdUm2 := M->UB_VQ_QTDE
		EndIf
	Else
		If aCols[n][nPosVqUm] == SB1->B1_UM 
			nQtdUm1 := M->UB_VQ_QTDE
			nQtdUm2 := M->UB_VQ_QTDE * aCols[n][nPosDens]
		Else
			nQtdUm1 := M->UB_VQ_QTDE / aCols[n][nPosDens]
			nQtdUm2 := M->UB_VQ_QTDE
		EndIf
	EndIf

	aCols[n][nPQtdUm1] := nQtdUm1
	aCols[n][nPQtdUm2] := nQtdUm2

	aCols[n][nPQtdVer] := M->UB_VQ_QTDE 

	For nX := 1 To Len(aCols)
		If !GdDeleted(nX,aHeader,aCols) .And. AllTrim(aCols[nx][nPosEM]) != "03000"
			nQtdEmb              += aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
			aCols[nx][nPosVolum] := aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
		EndIf
	Next nX
	M->UA_VQ_QEMB := nQtdEmb
	
	aCols[n][nPTotUm1] := aCols[n][nPQtdUm1] * aCols[n][nPUniUm1]
	aCols[n][nPTotUm2] := aCols[n][nPQtdUm2] * aCols[n][nPUniUm2]
	aCols[n][nPTotVer] := aCols[n][nPQtdVer] * aCols[n][nPUniVer]

	SB1->(RestArea(aAreaSb1))
	
	U_fGFrete()
EndIf

//oGetTlv:oBrowse:Refresh(.T.)
//Tk273FRefresh()
//Tk273Refresh()

Return(lRet)
