#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA450T  º Autor ³ Giane - ADV Brasil º Data ³  01/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para gravar o log de liberacao do credito º±±
±±º          ³ ou estoque pelas rotinas lib.estoque e lib.cred/estoque    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI / Liberacao Estoque ou credito automaticoº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTA450T() 
	Local _aArea := GetArea()
	Local lEstoque := .f.   
	Local lCredESt := .f.    
	Local _lLibCred := .f.   
	Local _lLibEst  := .f.          
	Local cEvento := ""
	Local _nx := 0
	//apenas liberacao automatica por item do pedido 

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MTA450T" , __cUserID )

	For _nx := 1 to 30      
		if IsInCallStack("MATA455")
			lEstoque := .t.	    
			exit
		Endif
		if IsInCallStack("MATA456")
			lCredEst := .t.	  	    
			exit   
		Endif
	Next    

	If lEstoque .AND. empty(SC9->C9_BLEST)
		U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,'Liberacao Estoque Aut.', ,SC9->C9_ITEM)
	endif 

	If SC9->C9_BLEST =="09"
		U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,'Pedido Rejeitado no Credito', ,SC9->C9_ITEM)
	endif   

	//so grava o log se liberou o credito e estoque, se liberou apenas 1 deles nao grava??
	if lCredEst       
		DbSelectArea("SZ7")                 
		DbSetorder(1)
		If DbSeek(SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM + SC9->C9_CLIENTE+SC9->C9_LOJA+SC9->C9_PRODUTO)

			If !empty(SZ7->Z7_BLCRED) .and. empty(SC9->C9_BLCRED)
				_lLibCred := .t.      
			endif

			if !empty(SZ7->Z7_BLEST) .and. empty(SC9->C9_BLEST)
				_lLibEst := .t.
			endif  

			if _lLibCred .and. _lLibEst
				cEvento := 'Liberacao Cred/Est'
			elseif _lLibCred
				cEvento := 'Liberacao Credito'
			elseif _lLibEst
				cEvento := 'Liberacao Estoque'
			endif      



			if !empty(cEvento)
				U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,cEvento, ,SC9->C9_ITEM)
			endif 

			DbSelectArea("SZ7")
			Reclock("SZ7")
			SZ7->(DbDelete())
			MsUnlock()


		Endif 

		DbSelectArea("SC9") 

	endif



	RestArea(_aArea)
Return 