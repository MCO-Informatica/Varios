#include "rwmake.ch"

User Function SACI008()

    _cRisco     := ""
    _aArea		:= GetArea()
    _cCliente	:= ""
    _cRiscoAnt	:= ""

    dbSelectArea("SA1")
    dbSetOrder(1)
    If dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.)

        _cRiscoAnt	:= SA1->A1_SITFIN

        If SA1->A1_COD$"002796.382039.362467.396547.394445.395811.355449"
            dbSelectArea("SA1")
            RecLock("SA1",.f.)
            SA1->A1_SITFIN     :=  ""
            MsUnLock()
        EndIf

        dbSelectArea("SE1")
        _aAreaSE1 := GetArea()
        dbSetOrder(8)
        If dbSeek(xFilial("SE1")+SA1->(A1_COD+A1_LOJA),.F.)

            If ALLTRIM(SE1->E1_FORMAPG)$"CC CD R$ DA DC DH TR" .Or. SE1->E1_TIPO $ "NCC AB- IN- IS- IR- PI- CS- CF-" .Or. SE1->E1_STATUS == 'B' .Or. SE1->E1_VENCREA >= dDataBase
                _cRisco := ""
            Else
                _cRisco := "I"
            EndIf

            dbSelectArea("SA1")
            RecLock("SA1",.f.)
            SA1->A1_SITFIN     :=  _cRisco
            MsUnLock()

            //----> caso nao exista contas a receber o risco sempre sera A
        Else
            dbSelectArea("SA1")
            RecLock("SA1",.f.)
            SA1->A1_SITFIN     :=  ""
            MsUnLock()
        EndIf
    EndIf

    If _cRisco <> _cRiscoAnt
        //MsgAlert("O cliente "+SA1->A1_COD+" "+Alltrim(SA1->A1_NREDUZ)+" teve a situação financeira alterada de "+Iif(_cRiscoAnt$"I","INADIMPLENTE","ADIMPLENTE")+" para "+Iif(_cRisco$"I","INADIMPLENTE","ADIMPLENTE"),"Situação Financeira")
    EndIf


    RecLock("SE5",.f.)
    SE5->E5_FORMAPG := SE1->E1_FORMAPG
    MsUnLock()

    RestArea(_aAreaSE1)
    RestArea(_aArea)

Return

