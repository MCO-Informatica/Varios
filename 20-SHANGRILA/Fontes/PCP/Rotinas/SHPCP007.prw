#Include 'Protheus.ch'

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 06/01/2015 - 16:15:53
* @description: Função para validar o armazém do produto, dependendo se este é de apropriação direta ou indireta. 
*/ 
User Function SHPCP007()
	
	local lRet 	 := .T.
	local cLocal := "" 
	
	cLocal := iif(type("aCols")<>"U",aCols[n,gdFieldPos("D4_LOCAL")],M->D4_LOCAL)
	
	if posicione('SB1',1,XFILIAL('SB1')+iif(type("aCols")<>"U",aCols[n,1],M->D4_COD),'B1_APROPRI')=='D'
		if cLocal == '99'
			lRet := .F.
			Alert("Armazém não disponível para Produtos de Apropriação Direta!")
		endIf 
	endIf	

return lRet