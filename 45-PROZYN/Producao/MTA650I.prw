#Include "Protheus.ch"
#include "rwmake.ch"
#include "TbiConn.ch"

User Function MTA650I()
    Local aMATA650      := {}       //-Array com os campos
    Local aArea := GetArea()
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ 3 - Inclusao     ³
    //³ 4 - Alteracao    ³
    //³ 5 - Exclusao     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Local nOpc              := 3
    Local aOPs              := {}
    Local nQtdPrin          := SC2->C2_QUANT
    Local cOpOrig           := ""
    Local nOP               := 0
    Local cBatUsr := ""
    Local cBatch := ""
    Local cBatOrca := ""
    Local cBatRot := ""
    Local nRecPai := 0
    Private lMsErroAuto     := .F.

    // DbSelectArea("SB1")
    // SB1->(DbSetOrder(1))
    // SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))

    //Tratativa para alimentar o Lote na tabela QPK após a inclusão da OP.
    QPK->(RecLock("QPK",.F.))
    QPK->QPK_LOTE := SC2->C2_LOTECTL
    QPK->(MsUnlock())

    If SC2->C2_QUANT > SZP->ZP_MAX
        MsgAlert("A quantidade excede o limite de produção da sala, novas OP's serão geradas para suprir a quantidade.","Atenção!")
        cOpOrig := SC2->C2_NUM
        nSobra := SC2->C2_QUANT - SZP->ZP_MAX

        If nSobra > 0 .and. nSobra < SZP->ZP_MIN
            nQtdPrin := SC2->C2_QUANT - SZP->ZP_MIN
            nSobra := SZP->ZP_MIN
        ElseIf nSobra > 0 .and. nSobra >= SZP->ZP_MIN
            nQtdPrin := SZP->ZP_MAX
        EndIf

        While nSobra > 0
            If nSobra > SZP->ZP_MAX
                If nSobra - SZP->ZP_MAX < SZP->ZP_MIN
                    aAdd(aOPs, nSobra - SZP->ZP_MIN)
                    aAdd(aOPs, SZP->ZP_MIN)
                Else
                    aAdd(aOPs, SZP->ZP_MAX)
                    nSobra -= SZP->ZP_MAX
                EndIf
            Else
                aAdd(aOPs, nSobra)
                nSobra := 0
            EndIf
        EndDo

        If len(aOPs) > 0
            SC2->(RecLock("SC2",.F.))
            SC2->C2_XOPPAI := cOpOrig
            SC2->C2_QUANT := nQtdPrin
            SC2->C2_QTSEGUM := nQtdPrin * 1000
            SC2->(MsUnlock())
        EndIf
        nRecPai := SC2->(Recno())

        ConOut("Inicio  : "+Time())

        For nOP := 1 to len(aOPs)
            cOP := GETNUMSC2()
            aMata650  := {  {'C2_FILIAL'    ,SC2->C2_FILIAL         ,NIL},;
                            {'C2_PRODUTO'   ,SC2->C2_PRODUTO        ,NIL},;          
                            {'C2_NUM'       ,cOP                    ,NIL},;          
                            {'C2_ITEM'      ,"01"                   ,NIL},;          
                            {'C2_SEQUEN'    ,"001"                  ,NIL},;           
                            {'C2_MISTURA'   ,SC2->C2_MISTURA        ,NIL},;          
                            {'C2_SALA'      ,SC2->C2_SALA           ,NIL},;          
                            {'C2_LOCAL'     ,SC2->C2_LOCAL          ,NIL},;   
                            {'C2_DATPRI'    ,SC2->C2_DATPRI         ,NIL},;        
                            {'C2_OBS'       ,SC2->C2_OBS            ,NIL},;   
                            {'C2_DATPRF'    ,SC2->C2_DATPRF         ,NIL},;   
                            {'C2_YAMOSTR'   ,SC2->C2_YAMOSTR        ,NIL},;  
                            {'C2_OPTERCE'   ,SC2->C2_OPTERCE        ,NIL},;   
                            {'C2_XOPPAI'    ,cOpOrig                ,NIL},;  
                            {'C2_QUANT'     ,aOPs[nOP]              ,NIL}}  
                            
            MsExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)

            If !lMsErroAuto
                ConOut("Sucesso! ")

                cBatUsr := SC2->C2_BATUSR
                cBatch := SC2->C2_BATCH
                cBatOrca := SC2->C2_BATORCA
                cBatRot := SC2->C2_BATROT

                SC2->(DbGoTo(nRecPai))
                SC2->(RecLock("SC2",.F.))
                
                SC2->C2_BATUSR := cBatUsr
                SC2->C2_BATCH := cBatch
                SC2->C2_BATORCA := cBatOrca
                SC2->C2_BATROT := cBatRot
                
                SC2->(MsUnlock())

                RollBackSX8()
            Else
                ConfirmSX8()
                ConOut("Erro!")
                MostraErro()
            EndIf

        Next nOP

    EndIf

    RestArea(aArea)

Return

User Function MT650QIP
    Local lRet := .T.//Customizacoes conforme necessidade
    If Trim(SC2->C2_XOPPAI) != ''
        lRet := .F.
    EndIf
Return lRet
