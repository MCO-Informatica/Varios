
USER FUNCTION SX5NOTA()

Local cSerie 	:= "" 
Local cPrior	:= SC5->C5_X_PRIOR
Local lRet		:= .F.


//ALERT("SX5NOTA")

If cFilAnt$"01" 
//----> GERACAO DA NOTA PELO PEDIDO DE VENDA (MATA410)
	If Alltrim(FunName()) $"MATA461"
	
		cSerie := Iif(SC5->C5_X_PRIOR$"N","001","XT")
	
	//----> GERACAO DA NOTA PELO DOCUMENTO DE SAIDA (MATA460)
	ElseIf Alltrim(FunName()) $"MATA460A"
	
		cSerie := Iif(SC5->C5_X_PRIOR$"N","001","XT")
		
	//----> GERACAO DA NOTA PELO DOCUMENTO DE ENTRADA (MATA103) = ENTRADA COM FORMULARIO PROPRIO	
	ElseIf AllTrim(FunName()) $ "MATA103"
	
		cSerie := "001"
	
	EndIf
	
	If Alltrim(SX5->X5_CHAVE) $ cSerie
		If cPrior$"S" .and. !cSerie$"XT"
			MsgStop("Você não selecionou a série correta para gerar a nota. Favor verificar.","Série de Faturamento")
			lRet := .F.
		ElseIf cPrior$"N" .and. !cSerie$"001"
			MsgStop("Você não selecionou a série correta para gerar a nota. Favor verificar.","Série de Faturamento")
			lRet := .F.
		Else
	   		lRet := .T.
	   	EndIf	
	EndIf

Else 
	//----> GERACAO DA NOTA PELO PEDIDO DE VENDA (MATA410)
	If Alltrim(FunName()) $"MATA461"
	
		cSerie := Iif(SC5->C5_X_PRIOR$"N","000","XT")
	
	//----> GERACAO DA NOTA PELO DOCUMENTO DE SAIDA (MATA460)
	ElseIf Alltrim(FunName()) $"MATA460A"
	
		cSerie := Iif(SC5->C5_X_PRIOR$"N","000","XT")
		
	//----> GERACAO DA NOTA PELO DOCUMENTO DE ENTRADA (MATA103) = ENTRADA COM FORMULARIO PROPRIO	
	ElseIf AllTrim(FunName()) $ "MATA103"
	
		cSerie := "000"
	
	EndIf
	
	If Alltrim(SX5->X5_CHAVE) $ cSerie
		If cPrior$"S" .and. !cSerie$"XT"
			MsgStop("Você não selecionou a série correta para gerar a nota. Favor verificar.","Série de Faturamento")
			lRet := .F.
		ElseIf cPrior$"N" .and. !cSerie$"000"
			MsgStop("Você não selecionou a série correta para gerar a nota. Favor verificar.","Série de Faturamento")
			lRet := .F.
		Else
	   		lRet := .T.
	   	EndIf	
	EndIf
EndIf

IF cFilAnt$"90"
//----> GERACAO DA NOTA PELO PEDIDO DE VENDA (MATA410)
	If Alltrim(FunName()) $"MATA461"
		lRet := .T.
		cSerie := Iif(SC5->C5_X_PRIOR$"N","090",Alert("Não foi encontrada Série para Filial 090"))
	
	//----> GERACAO DA NOTA PELO DOCUMENTO DE SAIDA (MATA460)
	ElseIf Alltrim(FunName()) $"MATA460A"
		lRet := .T.
		cSerie := Iif(SC5->C5_X_PRIOR$"N","090",Alert("Não foi encontrada Série para Filial 090"))

	//----> GERACAO DA NOTA PELO DOCUMENTO DE ENTRADA (MATA103) = ENTRADA COM FORMULARIO PROPRIO	
	ElseIf AllTrim(FunName()) $ "MATA103"
		lRet := .T.
		cSerie := "090"
	ENDIF
ENDIF

Return(lRet)
