#Include 'Protheus.ch'

/**
*
* @author: Marcos Flóridi Leme
* @since: 04/11/2020 - 15:43
* @description: Gatilho para realizar o alerta quando o numero nao for inteiro, disparado pelo campo UB_QUANT para o campo "UB_VLIMPOR" sem uso.
*/ 

User Function shGat008()

local aArea 		:= getArea()
	local nRet			:= 0
	local nPosProduto	:= gdFieldPos("UB_PRODUTO")
	local nPosQtdVen	:= gdFieldPos("UB_QUANT") 
	local nPosQtdSeg	:= gdFieldPos("UB_QTSEGUM") 
	
	If aCols[n][nPosQtdSeg] <> INT(aCols[n][nPosQtdSeg])
		Alert("Favor validar a Qtd na 2UM !!!!")
	Endif


	_cCodTab := M->UA_TABELA

	_dDtVal  := Posicione("DA0",1,xfilial("DA0")+_cCodTab,"DA0_DATATE")

	If _dDtVal < DDATABASE
		MsgStop("Tabela fora de Vigencia, Favor Verificar !!!! ","Tabela fora de Vigencia")
	Endif
	

restArea(aArea)	

Return nRet
