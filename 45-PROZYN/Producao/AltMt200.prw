#Include 'Protheus.ch'
#Include 'TBICONN.ch'

User Function altMT200(cCod,nItem,nTotal)
    Local aAreaG1 := SG1->(GetArea())
    Local aAreaB1 := SB1->(GetArea())
    Local aCab := {}
    Local aGets := {}
    Local aItens := {}
    PRIVATE lMsErroAuto := .F.
    Private nQtdBase := 0
    Default cCod := ""

    ProcRegua(nTotal)

    IncProc("Atualizando registro " + cValToChar(nItem) + " de " + cValToChar(nTotal) + "...")

    DbSelectArea("SG1")
    SG1->(DbSetOrder(1))
    SG1->(DbGoTop())

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbSeek(xFilial("SB1")+cCod))
    If SB1->B1_MSBLQL != '1' .AND. SG1->(DbSeek(xFilial("SG1")+cCod))
        nQtdBase := SB1->B1_QB

        aCab := {{"G1_COD",SG1->G1_COD,NIL},; 
        {"G1_QUANT",nQtdBase,NIL},; 
        {"NIVALT","S",NIL},;
        {"ATUREVSB1","N",NIL}}

        While SG1->(!EOF()) .AND. Trim(SG1->G1_COD) == Trim(cCod)
            aGets := {}
            aadd(aGets,{"G1_COD",SG1->G1_COD,NIL}) 
            aadd(aGets,{"G1_COMP",SG1->G1_COMP,NIL}) 
            aadd(aGets,{"G1_TRT",SG1->G1_TRT,NIL}) 
            aadd(aGets,{"G1_QUANT",SG1->G1_QUANT,NIL}) 
            aadd(aGets,{"G1_PERDA",SG1->G1_PERDA,NIL}) 
            aadd(aGets,{"G1_PERCDIL",SG1->G1_PERCDIL,NIL}) 
            aadd(aGets,{"G1_TIPO",SG1->G1_TIPO,NIL}) 
            aadd(aGets,{"G1_INI",SG1->G1_INI,NIL}) 
            aadd(aGets,{"G1_FIM",SG1->G1_FIM,NIL})
            aadd(aGets,{"G1_REVINI",SG1->G1_REVINI,NIL}) 
            aadd(aGets,{"G1_REVFIM",SG1->G1_REVFIM,NIL})
            aadd(aItens,aGets)

            SG1->(DbSkip())
        EndDo

        MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItens,4) 
        
        If lMsErroAuto
            MostraErro()
        Else
            ConOut("Alterado com sucesso: "+Time())
        EndIf 

    EndIf
    RestArea(aAreaB1)
    RestArea(aAreaG1)

Return
