#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PZCVG002 ºAutor  ³Microsiga 	          º Data ³ 20/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho da tabela de preço, para preencher o preço de venda º±±
±±º          ³atraves do preço net							    		  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PZCVG002(nPrcNet, nAliqIcm, nAliqPis, nAliqCofins)

	Local aArea 	:= GetArea()
	Local nRet		:= 0
	Local nVlIcm	:= 0
	Local nVlPis	:= 0
	Local nVlCof	:= 0
	Local nFator	:= 0

	Default nPrcNet		:= 0 
	Default nAliqIcm	:= 0 
	Default nAliqPis	:= 0 
	Default nAliqCofins	:= 0

	DbSelectArea("DA0")
	DA0->(DbSetOrder(1))
	DA0->(DbSeek(xFilial("DA0")+M->DA1_CODTAB))

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+DA0->DA0_YCODCL+DA0->DA0_YLJCLI))

	If SA1->A1_EST == 'EX'
		return nPrcNet
	EndIf

	If nPrcNet != 0

		If nAliqIcm != 0
			nVlIcm := nAliqIcm
		EndIf

		If nAliqPis != 0
			nVlPis := nAliqPis
		EndIf

		If nAliqCofins != 0
			nVlCof := nAliqCofins
		EndIf
		
		If ((nVlIcm > 0) .Or. (nVlPis > 0) .Or. (nVlCof > 0)) .And. (nPrcNet > 0)
			nFator	:= (100-(nVlIcm+nVlPis+nVlCof))/100
			nRet	:= (nPrcNet / nFator)
		else
			nRet	:= nPrcNet
		EndIf
		
		nRet := Round(nRet, TamSx3("DA1_PRCVEN")[2])
	Else
		nRet := 0
	EndIf

	RestArea(aArea)	
Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PZCVG202 ºAutor  ³Microsiga 	          º Data ³ 20/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho da tabela de preço, para preencher o preço net	  º±±
±±º          ³												    		  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PZCVG202(nPrcNet, nAliqIcm, nAliqPis, nAliqCofins)

	Local aArea 	:= GetArea()
	Local nRet		:= 0
	Local nVlIcm	:= 0
	Local nVlPis	:= 0
	Local nVlCof	:= 0
	Local nFator	:= 0

	Default nPrcNet		:= 0 
	Default nAliqIcm	:= 0 
	Default nAliqPis	:= 0 
	Default nAliqCofins	:= 0

	If nPrcNet != 0

		If nAliqIcm != 0
			nVlIcm := nAliqIcm
		EndIf

		If nAliqPis != 0
			nVlPis := nAliqPis
		EndIf

		If nAliqCofins != 0
			nVlCof := nAliqCofins
		EndIf
		
		If ((nVlIcm > 0) .Or. (nVlPis > 0) .Or. (nVlCof > 0)) .And. (nPrcNet > 0)
			nFator	:= (100-(nVlIcm+nVlPis+nVlCof))/100
			nRet	:= (nPrcNet * nFator) 
		EndIf
		
		nRet := Round(nRet, TamSx3("DA1_PRCVEN")[2])
	Else
		nRet := 0
	EndIf

	RestArea(aArea)	
Return nRet
