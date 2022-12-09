#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2520E     ºAutor  ³Felipe Valenca   º Data ³  08/03/2012 º ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA PARA VERIFICAR SALDO NO ESTORNO DO        º±±
±±º          ³ FATURAMENTO DAS TAREFAS DO PROJETO                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2520E()

    Local _cRevisa := ""
    Local _cProjet := ""
    Local _cEdt	   := ""
    Local _nValBrut:= SF2->F2_VALBRUT
    Local _cArea   := ""

    _cArea := GetArea()

    mSQL := " SELECT AFC_PROJET,MAX(AFC_REVISA)AFC_REVISA,AFC_EDT,AFC_EDTPAI
    mSQL += " FROM "+RetSQLName("AFC")
    mSQL += " WHERE AFC_PROJET='"+SD2->D2_PROJPMS+"' AND D_E_L_E_T_<>'*' AND AFC_FILIAL='"+xFilial ("AFC")+"' "
    mSQL += " GROUP BY AFC_PROJET,AFC_EDT,AFC_EDTPAI "

    If Select( "TREV" ) > 0
        TREV->( DbCloseArea() )
    EndIf

    dbUseArea(.T.,"TOPCOON",TcGenQry(,,mSQL),"TREV",.F.,.T.)
    dbSelectArea("TREV")
    dbGoTop()

    _cRevisa := TREV->AFC_REVISA
    _cTarefa := Posicione("AF9",1,xFilial("AF9")+SD2->(D2_PROJPMS+_cRevisa+D2_TASKPMS),"AF9_EDTPAI")
    _cEDT    := Posicione("AFC",1,xFilial("AFC")+SD2->(D2_PROJPMS+_cRevisa+_cTarefa),"AFC_EDTPAI")

    RestArea(_cArea)

    _cArea := GetArea()
    dbSelectArea("SD2")
    dbSetOrder(3)
    dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))

    Do While SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)

        dbSelectArea("AF9")
        dbSetORder(1)
        If dbSeek(xFilial("AF9")+SD2->D2_PROJPMS+_cRevisa+SD2->D2_TASKPMS,.F.)
            RecLock("AF9",.F.)
            AF9->AF9_FATPV -= SD2->D2_TOTAL
            MsUnlock()
        Endif

        For _nX := Len(Alltrim(SD2->D2_TASKPMS)) to 1 Step -2
            _cEdtAFC := Substr(Alltrim(SD2->D2_TASKPMS),1,_nX-2)
            If !Empty(_cEdtAFC)

                dbSelectArea("AFC")
                dbSetOrder(1)
                If dbSeek(xFilial("AFC")+SD2->D2_PROJPMS+_cRevisa+_cEdtAFC,.F.)
                    RecLock("AFC",.F.)
                    AFC->AFC_FATPV -= SD2->D2_TOTAL
                    MsUnlock()
                Endif
            Else

                dbSelectArea("AFC")
                dbSetOrder(1)
                If dbSeek(xFilial("AFC")+SD2->D2_PROJPMS+_cRevisa+SD2->D2_PROJPMS,.F.)
                    RecLock("AFC",.F.)
                    AFC->AFC_FATPV -= SD2->D2_TOTAL
                    MsUnlock()
                Endif

            Endif
        Next

        SD2->(dbSkip())
    EndDo

    RestArea(_cArea)

Return