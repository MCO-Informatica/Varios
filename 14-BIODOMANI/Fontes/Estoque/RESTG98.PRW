#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function RESTG98()

Local _cProd := Iif(Alltrim(FunName())$"MATA241/MATA261",aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "D3_COD"   })],M->D3_COD  )
local _cLocal:= Iif(Alltrim(FunName())$"MATA241/MATA261",aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "D3_LOCAL" })],M->D3_LOCAL)
local _nQuant:= Iif(Alltrim(FunName())$"MATA241/MATA261",aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "D3_QUANT" })],M->D3_QUANT)

DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1")+_cProd,.f.)

    /*
    If !SB1->B1_LOCALIZ$"S" .And. _cLocal$"01A3"
        _nQuant := 0
        MsgAlert("O produto está com o controle de endereçamento desativado no cadastro. Solicite a correção do cadastro para poder realizar essa movimentação.")
    EndIf
    */
EndIf

Return(_nQuant)
