#Include 'Protheus.ch'

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 06/01/2015 - 14:50:08
* @description: Fonte para validação do campo D4_LOCAL (campo de edição)
*/
User Function SHPCP005()

	local lRet 		:= .T.
	local cProduto 	:= "" 
		
	cProduto := padR(iif(type("aCols")<>"U",aCols[n,1],M->D4_COD),tamSX3("B1_COD")[1])
	
	if retField('SB1',1,XFILIAL('SB1')+cProduto,'B1_APROPRI')<>'D'
		lRet := .F.			
	endIf	
		
Return lRet



