#include 'protheus.ch'
#include 'parmtype.ch'

user function zCalcC7si()
	

	Local cXTOTSI 	:= 0
	Local cFornece 	:= ""
	Local cItemCTa	:= ""
	Local cProduto	:= ""
	Local cProdTP	:= ""
	Local cTPJ		:= ""
	Local nTotalOC	:= 0
	Local nTotalSIPI := 0
	Local nValIPI	:= 0
	Local nValICM	:= 0
	Local nValISS 	:= 0
	Local nXTOTSI	:= 0
	Local _cRetorno := 0

	
		cFornece	:= Alltrim(SC7->C7_FORNECE)
		cItemCTA	:= Alltrim(SC7->C7_ITEMCTA)
		cProduto	:= Alltrim(SC7->C7_PRODUTO)
		cProdTP		:= Alltrim(Posicione("SB1",1,xFilial("SB1")+cProduto,"SB1->B1_TIPO"))
		cTPJ		:= Alltrim(Posicione("SA2",1,xFilial("SA2")+cFornece,"SA2->A2_TPJ"))
		nTotalOC 	:= SC7->C7_QUANT*SC7->C7_PRECO
		nTotalSIPI	:= nTotalOC-SC7->C7_VALIPI
		nValIPI 	:= SC7->C7_VALIPI
		nValICM		:= SC7->C7_VALICM
		nValISS 	:= SC7->C7_VALISS
					      
			    	
		if cTPJ = "3" .OR. cProdTP == "MC" .OR. cItemCTA == "ADMINISTRACAO" .OR. cItemCTA == "PROPOSTA" .OR. cItemCTA == "ATIVO" .OR. cItemCTA == "QUALIDADE" .OR. cItemCTA == "ENGENHARIA"
			nValCof			:= 0
			nValPIS 		:= 0 
			
		else
			nValCof			:= 7.6
			nValPIS 		:= 1.65 
			
		endif
			           
		_cRetorno 	:= nTotalSIPI-nValICM-nValISS-(nTotalSIPI*(nValCof/100))-(nTotalSIPI*(nValPIS/100))
		
	
return _cRetorno