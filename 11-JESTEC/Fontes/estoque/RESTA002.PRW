#Include "Protheus.ch"
#Include "Rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA002  บAutor  ณFelipe Valen็a      บ Data ณ  13-11-12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para gravar toda a movimentacao interna na tabela   บฑฑ
ฑฑบ          ณ AFI                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function RESTA002

    Processa({|| RunProc()},"Processando...")
    Alert("FIM")

Return

//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑ 						Chamada da Rotina.                              บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ

Static Function RunProc()

    Local _aArea := GetArea()

    Local cProjeto	:= ""
    Local cRevisao	:= ""

    cQuery := "SELECT D3_PROJPMS,D3_TASKPMS,D3_COD,D3_LOCAL,D3_NUMSEQ, D3_EMISSAO, D3_QUANT FROM SD3010 D3 WHERE D3.D_E_L_E_T_ = '' AND D3_TM = '601' AND D3_PROJPMS <> '' "
    cQuery += "ORDER BY D3_DOC "

    If Select("TRB") > 0
        dbSelectArea("TRB")
        dbCloseArea()
    EndIf

    DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

    dbSelectArea("TRB")
    ProcRegua(RecCount())
    dbGoTop()
    _aArea := GetArea()
    Do While !TRB->(Eof())
        IncProc("Gravando registros na AFI.")
        dbSelectArea("AF8")
        dbSetOrder(1)
        dbSeek(xFilial("AF8")+TRB->D3_PROJPMS,.F.)
        cProjeto := AF8->AF8_PROJET
        Do While !Eof() .And. cProjeto == AF8->AF8_PROJET
            cRevisao := AF8->AF8_REVISA
            AF8->(dbSKip())
        EndDo
        RestArea(_aArea)

        dbSelectArea("AFI")
        dbSetOrder(1)
        If !dbSeek(xFilial("AFI")+TRB->D3_PROJPMS+cRevisao+TRB->D3_TASKPMS+TRB->D3_COD,.F.)

            Reclock("AFI",.T.)
            AFI_FILIAL	:= xFilial("AFI")
            AFI_LOCAL	:= TRB->D3_LOCAL
            AFI_COD		:= TRB->D3_COD
            AFI_NUMSEQ	:= TRB->D3_NUMSEQ
            AFI_EMISSA	:= StoD(TRB->D3_EMISSAO)
            AFI_PROJET	:= TRB->D3_PROJPMS
            AFI_REVISA	:= cRevisao
            AFI_TAREFA	:= TRB->D3_TASKPMS
            AFI_QUANT	:= TRB->D3_QUANT
            MsUnlock()

        Endif

        RestArea(_aArea)
        dbSkip()
    EndDo

Return