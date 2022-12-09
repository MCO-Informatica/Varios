#Include "Protheus.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: fGTabPrc | Autor: Celso Ferrone Martins   | Data: 14/05/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Gatilho do campo UB_VQ_TABE referente a tabela de preco    |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       | obsoleto                                                           |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function fGTabPrc(cCpoSub)

Local aAreaZ02 := Z02->(GetArea())
Local aAreaZ03 := Z03->(GetArea())
Local cRetGat  := ""

Local nPosProd := aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"}) // Cod. Produto
Local nPosVqUm := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_UM"})   // UM - Verquimica
Local nPosVqUm := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_UM"})   // UM - Padrao
Local nPosMoed := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_MOED"}) // Moeda
Local nPosTabe := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_TABE"}) // Tabela

Local cUbProduto  := Iif(AllTrim(cCpoSub)=="UB_PRODUTO",M->UB_PRODUTO,aCols[n][nPosProd]) // Codigo do Produto
Local cUb_Vq_Um   := Iif(AllTrim(cCpoSub)=="UB_VQ_UM"  ,M->UB_VQ_UM  ,aCols[n][nPosVqUm]) // Unidade de Medida Verquimica
Local cUb_Vq_Moed := Iif(AllTrim(cCpoSub)=="UB_VQ_MOED",M->UB_VQ_MOED,aCols[n][nPosMoed]) // Moeda Verquimica
Local cUb_Vq_Tabe := Iif(AllTrim(cCpoSub)=="UB_VQ_TABE",M->UB_VQ_TABE,aCols[n][nPosTabe]) // Tabela de Preco

If AllTrim(cCpoSub) == "UB_PRODUTO"
	cRetGat  := M->UB_PRODUTO
ElseIf AllTrim(cCpoSub) == "UB_VQ_UM"
	cRetGat  := M->UB_VQ_UM
ElseIf AllTrim(cCpoSub) == "UB_VQ_MOED"
	cRetGat  := M->UB_VQ_MOED
ElseIf AllTrim(cCpoSub) == "UB_VQ_TABE"
	cRetGat  := M->UB_VQ_TABE
EndIf

DbSelectArea("Z02") ; DbSetOrder(1)
DbSelectArea("Z03") ; DbSetOrder(2)

If Z02->(DbSeek(xFilial("Z02")+cUbProduto))
	Z03->(DbSeek(xFilial("Z03")+cUbProduto+Z02->Z02_REVISA+cUb_Vq_Tabe))
	U_fGFrete()
EndIf


Z02->(RestArea(aAreaZ02))
Z03->(RestArea(aAreaZ03))

Return(cRetGat)
