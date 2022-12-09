#Include 'Protheus.ch'

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 06/01/2015 - 15:36:25
* @description: Fonte utilizado no gatilho do campo D4_COD para D4_LOCAL. 
*/ 
User Function SHPCP006()

	local cRet		:= ""
	local cProduto 	:= "" 
	
	cProduto := padR(iif(type("aCols")<>"U",aCols[n,1],M->D4_COD),tamSX3("B1_COD")[1])
	
	if Posicione('SB1',1,XFILIAL('SB1')+cProduto,'B1_APROPRI')<>'D'
		cRet:= '99'
	else
		cRet := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_LOCPAD")
	endIf	
	
Return cRet

