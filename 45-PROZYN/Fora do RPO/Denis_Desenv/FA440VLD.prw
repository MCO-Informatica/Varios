User Function FA440VLD()    
    Local aArea := GetArea()
    Local nTipo := PARAMIXB
    Local lRet := .T.

    If nTipo == 2 .and. SE3->(DbSeek(xFilial("SE3")+SE1->E1_PREFIXO+SE1->E1_NUM))
        While SE3->(!EOF()) .AND. SE3->E3_PREFIXO == SE1->E1_PREFIXO .AND. SE3->E3_NUM == SE1->E1_NUM
            If SE3->E3_BAIEMI == 'E'
                lRet := .F.
                exit
            EndIf
            SE3->(DbSkip())
        EndDo
    EndIf

    RestArea(aArea)
Return lRet
