#include "rwmake.ch"

User Function RFINA01()

    _cPerg      := "RFINA01    "
    _cRisco     := "A"

    Processa({||Clientes()},"Administração do Risco de Crédito do Clientes")
Return

Static Function Clientes()


    dbSelectArea("SA1")
    dbSetOrder(1)
    dbGoTop()

    ProcRegua(RecCount())
    While Eof() == .f.

        IncProc("Processando Cliente: "+SA1->A1_COD+"/"+SA1->A1_LOJA+" "+ALLTRIM(SA1->A1_NREDUZ))

        //----> EMPRESAS DO GRUPO LIFE NÃO BLOQUEIAM FINANCEIRO
        If SA1->A1_COD$"002796.382039.362467.396547.394445.395811.355449"
            dbSelectArea("SA1")
            RecLock("SA1",.f.)
            SA1->A1_SITFIN     :=  ""
            MsUnLock()

            dbSkip()
            Loop
        EndIf

        dbSelectArea("SE1")
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

        dbSelectArea("SA1")
        dbSkip()
    EndDo

Return

