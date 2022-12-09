#Include "Protheus.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: TMKVDEL  | Autor: Celso Ferrone Martins   | Data: 04/07/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | PE ao deletar a linha no televanda - CallCenter            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao | Revisado 12/08/2014 - Celso Martins                        |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function TMKVDEL()

Local nPosCapa := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_CAPA"}) // Capacidade
Local nPQtdVer := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"})   // Quantidade
Local nPosEM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_EM"})   // Embalagem
Local nPosVolum:= aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VOLU"}) // VOLUME
Local nQtdEmb := 0          
Local nQtdEmb2 := {}

For nX := 1 To Len(aCols)
	If !GdDeleted(nX,aHeader,aCols) .And. AllTrim(aCols[nx][nPosEM]) != "03000"
		nQtdEmb              += aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]   
		AADD(nQtdEmb2, aCols[nx][nPQtdVer] / aCols[nx][nPosCapa])
		aCols[nx][nPosVolum] := aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
	EndIf
Next nX

M->UA_VQ_QEMB := nQtdEmb

U_fGFrete()

Return
