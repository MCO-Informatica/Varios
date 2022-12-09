#Include 'Protheus.ch'

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 29/09/2014 - 09:49:03
* @description: Gatilho para atualizar o campo UB_ZCUBAGE, disparado pelo campo UB_OPER. 
*/ 
User Function shGat004()

	local aArea 		:= getArea()
	local nRet			:= 0
	local nPosProduto	:= gdFieldPos("UB_PRODUTO")
	local nPosQtdVen	:= gdFieldPos("UB_QUANT") 
	local nPosQtdSeg	:= gdFieldPos("UB_QTSEGUM") 
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+aCols[n][nPosProduto],.f.)
		dbSelectArea("SB5")
		dbSetOrder(1)
		If SB5->(DbSeek(xFilial("SB5")+padR(aCols[n][nPosProduto],tamSX3("B5_COD")[1])))
			
			If SB1->B1_UM$"PC/PT"
				nRet := Round(aCols[n][nPosQtdSeg] * ((((SB5->B5_COMPRLC * SB5->B5_LARGLC * SB5->B5_ALTURLC)/1000)))*0.3,2) 
			Else //If SB1->B1_SEGUM$"CX"
				nRet := Round(aCols[n][nPosQtdVen] * ((((SB5->B5_COMPRLC * SB5->B5_LARGLC * SB5->B5_ALTURLC)/1000)))*0.3,2) 
			//Else
			//	nRet := 0
			EndIf
		EndIf
	EndIf

restArea(aArea)	

Return nRet