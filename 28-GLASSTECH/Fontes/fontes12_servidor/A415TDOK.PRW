/*/{Protheus.doc} User Function A415TDOK
    (long_description)
    @type  Function
    @author Pirolo
    @since 30/07/2021
    @return return_var, return_type, return_description
    @example
    (examples)
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6784039
    /*/
User Function A415TDOK()
Local lRet      := .T.
Local aAreaTMP1 := TMP1->(GetArea())

//Retorna a TES de acordo com nivel selecionado
If M->CJ_XNIVEL == "1"
    cTes := oCliFat:cTESCli

ElseIf M->CJ_XNIVEL == "2"
    cTes := oCliFat:cTESCli

ElseIf M->CJ_XNIVEL == "6"
    cTes := SuperGetMV("MV_XTESN6", , "506")

ElseIf M->CJ_XNIVEL == "8"
    cTes := SuperGetMV("MV_XTESN8", , "506")

EndIf

TMP1->(DbGotop())

While TMP1->(!Eof()) .AND. lRet
    lRet := TMP1->CK_TES == cTes
    TMP1->(DbSkip())
EndDo

If !lRet 
    MsgInfo("Orçamento possui itens com TES diferente da definida no cadastro do cliente, verifique.", "TES Invalida")
EndIf

//Limpa o OBJ da memória
FreeObj(oClienteFt)
RestArea(aAreaTMP1)
Return lRet
