
USER FUNCTION SX5NOTA()

    Local cSerie 	:= ""
    Local lRet		:= .F.
    Local cEmpFa	:= ""


//ALERT("SX5NOTA")


//----> GERACAO DA NOTA PELO PEDIDO DE VENDA (MATA410)
    If Alltrim(FunName()) $"MATA461"

        cSerie := Iif(SC5->C5_DF$"S","0"+subs(cFilAnt,3,2),"F"+subs(cFilAnt,3,2))
        cEmpFa := SC5->C5_X_EMPFA

//----> GERACAO DA NOTA PELO DOCUMENTO DE SAIDA (MATA460)
    ElseIf Alltrim(FunName()) $"MATA460A"

        cSerie := Iif(SC9->C9_DF$"S","0"+subs(cFilAnt,3,2),"F"+subs(cFilAnt,3,2))
        cEmpFa := SC9->C9_X_EMPFA

//----> GERACAO DA NOTA PELO LIVRO FISCAL (MATA920)
    ElseIf Alltrim(FunName()) $"MATA920"

        cSerie := Iif(SC9->C9_DF$"S","0"+subs(cFilAnt,3,2),"F"+subs(cFilAnt,3,2))
        cEmpFa := SC9->C9_X_EMPFA

//----> GERACAO DA NOTA PELO DOCUMENTO DE ENTRADA (MATA103) = ENTRADA COM FORMULARIO PROPRIO	
    ElseIf AllTrim(FunName()) $ "MATA103"

        cSerie := Iif(AllTrim(cEspecie)$"SPED","0"+subs(cFilAnt,3,2),"F"+subs(cFilAnt,3,2))
        cEmpFa := AllTrim(cFilAnt)

//----> GERACAO DO MANIFESTO DO DESTINATARIO (SPEDMDFE)
    ElseIf AllTrim(FunName()) $ "SPEDMDFE"

        cSerie := "M"+subs(cFilAnt,3,2)
        cEmpFa := AllTrim(cFilAnt)
    EndIf


    If !Alltrim(FunName()) $"MATA920.SPEDMDFE"
        If Alltrim(X5_CHAVE) = cSerie
            If subs(cSerie,2,2) <>  subs(cEmpFa,3,2)
                MsgStop("Você não está na empresa correta para gerar a nota. Favor verificar.","Empresa de Faturamento")
                lRet := .F.
            Else
                lRet := .T.
            EndIf
        EndIf
    Else
        lRet := .T.
    EndIf

Return(lRet)
