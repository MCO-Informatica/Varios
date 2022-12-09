User Function GERETIQ()
    
    #DEFINE API_KEY '02144ab9fac19db9c6bc2303f4f01f725c9580beb97f85ef626781fea0f4c410'
    
    Local cPedShopify   := ''
    Local nX            := 0
    Local cUrl          := ''
    Local cPath         := ''
    Local aHeader       := {}
    Local cResult       := ''
    Local oResult       := Nil
    Local cUrlEtiq      := ''
    Local nHandle       := 0
    Local cAlias        := GetNextAlias()
    Local cNFisc         := ''
    Local oContent      := Nil
    Local cDiretorio    := ''
    Local cPDF          := ''
    Local cNomePDF      := ''


    cUrl    := 'https://api.intelipost.com.br/api/v1/'

    Aadd(aHeader, "Content-Type: application/json")
    Aadd(aHeader, "api-key: " + API_KEY)

    oResult := JsonObject():New()
    
    /*
    --------------------------------------------
    |                                          |
    |     MV_PAR01 = Informe a Nota Fiscal     |
    |                                          |
    --------------------------------------------
    */

    Pergunte("GERETIQ", .T.)

    cNFisc  := MV_PAR01
        IF !Empty(AllTrim(cNFisc))
        
            BEGINSQL ALIAS cAlias
                SELECT *
                FROM %TABLE:SC5%
                WHERE C5_NOTA = %Exp:cNFisc%
                AND %notdel%
                ORDER BY C5_NOTA
            ENDSQL
        ElseIf Empty(AllTrim(cNFisc))
            MsgAlert("Preencha o número da NFs", "Erro no preenchimento dos parâmetros")
            Return
        Else
            Return
        ENDIF


    ( cAlias )->( DbGoTop() )

    
    cDiretorio := "C:\ETIQUETAS\"
    
    If !ExistDir(cDiretorio)
        MakeDir(cDiretorio)
    EndIf
        
    IF EMPTY(( cAlias )->C5_NOTA)
        MsgAlert("Não vai ser gerada, pois não existe a Nota Fiscal digitada! Por favor colocar Nota Fiscal válida.", "ATENÇÃO")
        RETURN
    ENDIF
    
    While ( cAlias )->( !EOF() )
        
        If !Empty(( cAlias )->C5_NOTA)
        
        cPedShopify := AllTrim(( cAlias )->C5_XPEDSHP)

        For nX := 1 to 4
            If !Empty(&(cAlias+"->C5_ESPECI"+ CValToChar(nX)))
                cPath       := 'shipment_order/get_label/' + cPedShopify + "/" + CValToChar(nX)
                cResult     := Requisicao(aHeader, cUrl, cPath)
                //ALERT(cResult)
                IF cResult <> NIL 
                    oResult:FromJSON(cResult)
                    oContent    := oResult["content"]
                    cUrlEtiq    := oContent["label_url"]
                    cPDF := Requisicao({}, cUrlEtiq, "")
                    cNomePDF := cDiretorio + "PEDIDO_" + ( cAlias )->C5_NUM + "_" + "NF_" + ( cAlias )->C5_NOTA + "_" + StrTran(DToS(Date()) + "_" + Time() + ".pdf", ":", "")
                    nHandle := FCreate(cNomePDF)
                    ShellExecute("Open", cUrlEtiq, "", "", 1)
                    If nHandle == -1
                        MsgInfo("Erro ao criar arquivo: " + Str(Ferror()), "Erro")

                    Else 
                        FWrite(nHandle, cPDF)
                        FClose(nHandle)
                    EndIf
                ENDIF
            EndIf
        
        Next nX
        
        ( cAlias )->( DbSkip() )
    
        EndIf
    EndDo

    ( cAlias )->( DbCloseArea() )

    //MsgInfo("Etiquetas salvas em: " + cDiretorio, ".Etiquetas geradas com sucesso!")
    
Return

        

Static Function Requisicao(aHeader, cUrl, cPath)
    
    Local oRest     :=  Nil
    Local cResult   :=  ''
    Local cError    :=  ''
    Local cHTTPCode :=  ''

    oRest := FWRest():New(cUrl)
    oRest:SetPath(cPath)
    
    If oRest:Get(aHeader)  
        cResult := oRest:GetResult()
        MsgInfo(cResult, "Resultado do consumo da API")
    Else
        cError      := oRest:GetLastError()
        cHTTPCode   := oRest:GetHTTPCode()
        MsgInfo(cError, "Erro no consumo da API:")
        MsgInfo(cHTTPCode, "Código HTTP:")
    EndIf
    
    IF cHTTPCode != "400"
       Return cResult
    ELSE
        MsgStop("Etiqueta não integrada na intelipost", "NAO INTEGRADO")
        Return(NIL)
    ENDIF

Return cResult

