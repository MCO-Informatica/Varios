
User Function QP215J26()
    Local aRotina := PARAMIXB[1]     
    aAdd (arotina, {'Observação', "U_PosicSD7()", 0, 6,,.F.})  
Return aRotina

User Function PosicSD7()
    DbSelectArea("SC2")
    SC2->(DbSetOrder(1))
    If SC2->(DbSeek(xFilial("SC2")+QPK->QPK_OP))
        cQry := " SELECT D7.R_E_C_N_O_ RECNO FROM SD7010 D7 WHERE D7_PRODUTO = '"+QPK->QPK_PRODUTO+"' AND D7_LOTECTL = '"+SC2->C2_LOTECTL+"' AND D7.D_E_L_E_T_ = '' "
        DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQry),"D7POS",.F.,.F.)

        If D7POS->(!EOF())
            SD7->(DbGoTo(D7POS->RECNO))
            U_PZCVA011()
        EndIf
        D7POS->(DbCloseArea())
    EndIf
Return
