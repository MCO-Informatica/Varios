#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"

User Function RFATG12()

    Local _cProduto := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO" })]
    Local _cTes		:= aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_TES"   })]

    DbSelectArea("SB1")
    DbSetOrder(1)
    If dbSeek(xFilial("SB1")+_cProduto,.f.)
        dbSelectArea("SF4")
        dbSetOrder(1)
        If dbSeek(xfilial("SF4")+_cTes,.f.)


            If SF4->F4_ESTOQUE$"S" .And. SB1->B1_LOCALIZ$"S"
                MsgAlert("O produto "+Alltrim(_cProduto)+" controla endereço. Favor informar o endereço de onde será baixado o estoque.","Controla Endereço")
            EndIf
        EndIf
    EndIf

Return(_cTes)


