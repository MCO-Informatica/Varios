#Include "Protheus.ch"

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: M200TEXT | Autor: Celso Ferrone Martins  | Data: 01/04/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao | PE para alterar a descricao da estrutura no DbTree        |||
||+-----------+-----------------------------------------------------------+||
||| Parametro | ParamIxb[1] - Texto Original                              |||
|||           | ParamIxb[2] - Codigo do Item Pai                          |||
|||           | ParamIxb[3] - TRT                                         |||
|||           | ParamIxb[4] - Codigo do componente inserido na estrutura  |||
|||           | ParamIxb[5] - Qtde. do item na estrutura                  |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
User Function M200TEXT()

Local cRet      := ParamIxb[1]
Local Sg1Cod    := SubStr(ParamIxb[2]+Space(15),1,15)
Local Sg1Trt    := ParamIxb[3]
Local Sg1Comp   := SubStr(ParamIxb[4]+Space(15),1,15)
Local Sg1Qtde   := ParamIxb[5]
Local cTipoPai  := ""
Local cTipoComp := ""
Local aAreaSb1  := SB1->(GetArea())
Local aAreaSg1  := SG1->(GetArea())

If AllTrim(FunName()) == "CFMTPRECO"
	DbSelectArea("SB1") ; DbSetOrder(1)
	DbSelectArea("SG1") ; DbSetOrder(1) // G1_FILIAL+G1_COD+G1_COMP+G1_TRT
	
	If Sg1Cod != Sg1Comp
		SG1->(DbSeek(xFilial("SG1")+Sg1Cod+Sg1Comp+Sg1Trt))
		If SB1->(DbSeek(xFilial("SB1")+Sg1Cod))
			cTipoPai := SB1->B1_TIPO
			If SB1->(DbSeek(xFilial("SB1")+Sg1Comp))
				cTipoComp := SB1->B1_TIPO
				If cTipoPai == cTipoComp .And. cTipoComp == "MP"
					cRet := AllTrim(Sg1Comp)+" - "+AllTrim(Transform(SG1->G1_VQ_PVER,"@E 999.99"))+" %"
				Else
					cRet := AllTrim(Sg1Comp)+" - "+AllTrim(SB1->B1_DESC)
				EndIf
			EndIf
		EndIf
	EndIf
	SB1->(RestArea(aAreaSb1))
	SG1->(RestArea(aAreaSg1))
EndIf

Return(cRet)