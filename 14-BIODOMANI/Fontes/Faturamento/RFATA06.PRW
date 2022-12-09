#include "totvs.ch"
#include "rwmake.ch"
#Include "Protheus.Ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

User Function RFATA06()

Processa({||RunProc()},"Ajuste Vendedores em Clientes")

return

Static Function RunProc()

Local _nRecSa1 := 0

dbSelectArea("SA1")
dbSetOrder(1)
dbGoTop()
    While Eof() == .f.
    
        IncProc("Processando o cliente "+SA1->A1_COD+" - "+SA1->A1_LOJA)

        If !SA1->A1_VEND$"C00007"
            dbSelectArea("SA1")
            dbSkip()
            Loop
        EndIf

        dbSelectArea("SZ2")
        Reclock("SZ2",.t.)
        SZ2->Z2_FILIAL      :=  xFilial("SZ2")
        SZ2->Z2_COD         :=  SA1->A1_COD
        SZ2->Z2_LOJA        :=  SA1->A1_LOJA
        SZ2->Z2_NOME        :=  SA1->A1_NOME
        SZ2->Z2_VENDOLD     :=  "C00007"
        SZ2->Z2_VENDNEW     :=  "C00030"
        SZ2->Z2_DATA        :=  dDataBase
        SZ2->Z2_USUARIO     :=  "FERNANDA.NOGUEIRA"
        SZ2->Z2_HORA        :=  Time()  
        MsUnLock()

        dbSelectArea("SA1")
        RecLock("SA1",.F.)
        SA1->A1_VEND        :=  "C00030"
        MsUnLock()
        dbSkip()
    EndDo

MsgAlert("Atualização realizada com sucesso!!!")

Return nil
