#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

// CRIAR AS NATUREZAS COMO TAREFAS NO PROJETO
User Function RoAF9()
    Local mSQL	:= ""
    Local cSequen := '01'
    Local cDescr  := ""

    IF SELECT("QUERY") > 0
        dbSelectArea("QUERY")
        QUERY->(dbCloseArea())
    Endif

    mSQL := " SELECT * FROM "+RETSQLNAME("SED")
    mSQL += " WHERE D_E_L_E_T_ <> '*' AND ED_FILIAL = '"+xFilial("SED")+"'"

    dbUseArea(.T., "TOPCONN", TCGenQry(,,mSQL),"QUERY", .F., .T.)

    WHILE QUERY->(!EOF())
        RecLock("AF9",.T.)
        AF9_FILIAL 	:= xFilial("AF9")
        AF9_PROJET	:= "2012000000"
        AF9_REVISA	:= "0002"
        AF9_TAREFA	:= PmsNumAF9("2012000000", "0002", "003", "1")
        AF9_NIVEL 	:= "003"
        AF9_DESCRI	:= QUERY->ED_DESCRIC
        AF9_EDTPAI	:= "1"
        AF9_UM		:= "UN"
        AF9_CALEND  := "001"
        AF9_FATURA	:= "1"
        AF9_PRIORI	:= 500
        AF9->( MsUnLock() )
        QUERY->(DBSKIP())
    ENDDO

    QUERY->(DBCLOSEAREA())



Return
