
USER FUNCTION SX5NOTA()

Local cSerie 	:= "" 
Local lRet		:= .F.
Local cEmpFa	:= ""


//ALERT("SX5NOTA")

//----> GERACAO DA NOTA PELO PEDIDO DE VENDA (MATA410)
If Alltrim(FunName()) $"MATA461"

	cSerie := "0"+subs(cFilAnt,3,2)
	cEmpFa := SC5->C5_X_EMPFA

//----> GERACAO DA NOTA PELO DOCUMENTO DE SAIDA (MATA460)
ElseIf Alltrim(FunName()) $"MATA460A"

	cSerie := "0"+subs(cFilAnt,3,2)
	cEmpFa := SC9->C9_X_EMPFA
	
//----> GERACAO DA NOTA PELO DOCUMENTO DE ENTRADA (MATA103) = ENTRADA COM FORMULARIO PROPRIO	
ElseIf AllTrim(FunName()) $ "MATA103"

	cSerie := "0"+subs(cFilAnt,3,2)
	cEmpFa := AllTrim(cFilAnt)

EndIf

If Alltrim(X5_CHAVE) = cSerie
	If subs(cSerie,2,2) <>  subs(cEmpFa,3,2)
		MsgStop("Voc? n?o est? na empresa correta para gerar a nota. Favor verificar.","Empresa de Faturamento")
		lRet := .F.
	Else
   		lRet := .T.
   	EndIf	
EndIf

Return(lRet)