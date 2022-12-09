

User Function MA030TOK()
    Local aArea := GetArea()
    Local lRet := .T.

    If !Empty(trim(M->A1_TABELA))

        DbSelectArea("DA0")
        DA0->(DbSetOrder(1))

        If DA0->(DbSeek(xFilial("DA0")+M->A1_TABELA)) .and. Trim(DA0->DA0_CONDPG) != Trim(M->A1_COND)
            DA0->(RecLock("DA0",.F.))
            DA0->DA0_CONDPG := M->A1_COND
            DA0->(MsUnlock())
        EndIf

    EndIf

    If Trim(M->A1_VEND) != Trim(SA1->A1_VEND)
        M->A1_XDTOLDV := Date()
        M->A1_XOLDVND := SA1->A1_VEND
    EndIf
    
    RestArea(aArea)
Return lRet
