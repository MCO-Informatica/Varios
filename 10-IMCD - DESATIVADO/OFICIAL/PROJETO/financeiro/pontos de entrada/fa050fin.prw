#include "Protheus.ch"
#include "rwmake.ch"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050FIN  ºAutor  ³Leandro Duarte      º Data ³  09/25/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alimenta o campo E2_GRUPO para todos os titulos gerados     º±±
±±º          ³a partir do original EX: titulos de impostos                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function FA050FIN()
    Local cQuery := "SELECT E2_GRUPO FROM "+RETSQLNAME("SE2")+" WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ = ' ' AND E2_NUM = '"+SE2->E2_NUM+"' AND E2_GRUPO <> ' ' "
    Local cQuery2 := "SELECT R_E_C_N_O_ AS REC FROM "+RETSQLNAME("SE2")+" WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ = ' ' AND E2_NUM = '"+SE2->E2_NUM+"' AND E2_GRUPO = ' ' "
    Local cGrupo    := ""

    cQuery := ChangeQuery( cQuery )
    IIF(SELECT("TRBTR")>0,TRBTR->(DBCLOSEAREA()),NIL)
    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRBTR", .T., .T.)
    IF TRBTR->(!EOF())
        cGrupo := TRBTR->E2_GRUPO
    ENDIF
    cQuery := ChangeQuery( cQuery2 )
    IIF(SELECT("TRBTR")>0,TRBTR->(DBCLOSEAREA()),NIL)
    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRBTR", .T., .T.)
    while TRBTR->(!EOF())
        SE2->(DBGOTO(TRBTR->REC))
        RECLOCK("SE2",.F.)
        SE2->E2_GRUPO := cGrupo
        MSUNLOCK()
        TRBTR->(DBSKIP())
    END

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³Microsiga           º Data ³  09/26/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function SF1100I()


    local  _aArea  := GetArea()
    dbSelectArea("SE2")
    _aAreaSE2   :=  GetArea()
    dbSetOrder(6)
    If dbSeek(SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC),.f.)

        While Eof() == .f. .and. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)

            DbSelectArea("SED")
            SED->(DbSetOrder(1))
            If SED->(DbSeek(xFilial("SED")+SF1->F1_NATUREZ))

                RecLock("SE2",.F.)
                
                //----> COFINS
                If ALLTRIM(SE2->E2_NATUREZ)$"218001"
                    SE2->E2_CODRET := SED->ED_XCODCOF
                
                //----> CSLL
                ELSEIf ALLTRIM(SE2->E2_NATUREZ)$"218002"
                    SE2->E2_CODRET := SED->ED_XCODCSL

                //----> INSS
                ELSEIf ALLTRIM(SE2->E2_NATUREZ)$"218005"
                    SE2->E2_CODRET := SED->ED_XCODINS

                //----> IRPJ
                ELSEIf ALLTRIM(SE2->E2_NATUREZ)$"218008"
                    SE2->E2_CODRET := SED->ED_CODRET

                //----> IRRF
                ELSEIf ALLTRIM(SE2->E2_NATUREZ)$"218009"
                    SE2->E2_CODRET := SED->ED_CODRET

                //----> PIS 
                ELSEIf ALLTRIM(SE2->E2_NATUREZ)$"218012"
                    SE2->E2_CODRET := SED->ED_XCODPIS

                //----> PIS 
                ELSEIf ALLTRIM(SE2->E2_NATUREZ)$"218013"
                    SE2->E2_CODRET := SED->ED_XCODPIS

                //----> COFINS
                ELSEIf ALLTRIM(SE2->E2_NATUREZ)$"218015"
                    SE2->E2_CODRET := SED->ED_XCODCOF

                //----> CSLL
                ELSEIf ALLTRIM(SE2->E2_NATUREZ)$"218016"
                    SE2->E2_CODRET := SED->ED_XCODCSL

                //----> PIS
                ELSEIf ALLTRIM(SE2->E2_NATUREZ)$"218017"
                    SE2->E2_CODRET := SED->ED_CODRET

                //----> CSLL
                ELSEIf ALLTRIM(SE2->E2_NATUREZ)$"218018"
                    SE2->E2_CODRET := SED->ED_XCODPIS

                //----> PIS
                ELSEIf ALLTRIM(SE2->E2_NATUREZ)$"218012"
                    SE2->E2_CODRET := SED->ED_XCODPIS

                ENDIF

                SE2->(MsUnlock())

            EndIf
            dbSelectArea("SE2")
            dbSkip()
        EndDo
    EndIf

    RestArea(_aAreaSE2)

    RestArea(_aArea)

	U_FA050FIN()

    Return()
