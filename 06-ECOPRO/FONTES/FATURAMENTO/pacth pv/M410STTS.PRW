#INCLUDE "rwmake.ch"

/*3 - Inclusão
 4 - Alteração 
 5 - Exclusão
 6 - Cópia
 7 - Devolução de Compras*/

User Function M410STTS()

Local _nOper    := PARAMIXB[1]
Local _aArea	:=	GetArea()
Local cNumOrc   := ""
Local cquery    := ""

If _nOper == 5 
	SCJ->(dbSetOrder(1))
	SCK->(dbSetOrder(1))

    cquery := "select * from " + RetSqlname("SC6") + " where c6_filial = '"+sc6->(xfilial())+"' and c6_num = '"+sc5->c5_num+"' and d_e_l_e_t_ = '*'"

    If Select ("TMP") > 0
        TMP->(DbcloseArea())
    EndIf
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cquery),"TMP",.F.,.T.)
    
    WHILE !tmp->(EOF())

        If  !Empty(tmp->C6_NUMORC)

            if empty(cNumOrc)
                cNumOrc = Substr(tmp->C6_NUMORC,1,6)
            endif
            //CJ_FILIAL + CJ_NUM + CJ_CLIENTE + CJ_LOJA	
            IF SCJ->(dbSeek(xFilial("SCJ")+Substr(tmp->C6_NUMORC,1,6)+tmp->C6_CLI+tmp->C6_LOJA,.f.))		
                RecLock("SCJ",.f.)
                SCJ->CJ_STATUS := "A"
                SCJ->(MsUnLock())
        
            ENDIF

            //CK_FILIAL + CK_NUM + CK_ITEM + CK_PRODUTO
            IF SCK->(dbSeek(xFilial("SCK")+tmp->C6_NUMORC+tmp->C6_PRODUTO,.f.))
                If !Empty(SCK->CK_NUMPV)
                    RecLock("SCK",.f.)
                    SCK->CK_NUMPV := " "
                    SCK->(MsUnLock())

                EndIf    
            ENDIF

        EndIf

        tmp->(DBSKIP())
    END

    if !empty(cNumOrc)
       MsgInfo("Numero Orcamento: " + cNumOrc + " Orçamento foi Reaberto!")
    endif

EndIf

RestArea(_aArea)

Return Nil
