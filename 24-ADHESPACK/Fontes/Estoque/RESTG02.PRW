#include "rwmake.ch"

User Function RESTG02()

Local _cArmaz   :=  M->D3_LOCAL

dbSelectArea("SB2")
dbSetOrder(1)
If !dbSeek(xFilial("SB2")+M->D3_COD+M->D3_LOCAL,.f.)
    ALERT("TESTE")


    lMsErroAuto := .F.        
    aVetor :={;
        {"B9_FILIAL", FWxFilial('SB9'), Nil},;
        {"B9_COD",    M->D3_COD,        Nil},;
        {"B9_LOCAL",  M->D3_LOCAL,      Nil},;
        {"B9_QINI",   0,              Nil};
    }
    
    //Iniciando transação e executando saldos iniciais
    Begin Transaction
        MSExecAuto({|x, y| Mata220(x, y)}, aVetor, 3)
        
        //Se houve erro, mostra mensagem
        If lMsErroAuto
            MostraErro()
            DisarmTransaction()
        EndIf
    End Transaction

EndIf

Return(_cArmaz)
