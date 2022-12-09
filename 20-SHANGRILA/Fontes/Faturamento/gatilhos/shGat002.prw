#Include 'Protheus.ch'


/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 24/09/2014 - 14:21:28
* @description: Gatilho para atualizar o campo C6_ZCUBAGE, disparado pelo campo C6_QTDVEN. 
*/ 
User Function shGat002()
	
	local aArea 		:= getArea()
	local nRet			:= 0
	local nPosProduto	:= gdFieldPos("C6_PRODUTO")
	local nPosQtdVen	:= gdFieldPos("C6_QTDVEN") 
	local nPosQtdSeg	:= gdFieldPos("C6_UNSVEN") 
	
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