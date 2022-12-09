#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#include "PROTHEUS.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function RPCPG03()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

Local _cProd    :=  M->C2_PRODUTO


If !cFilAnt$"0103.0106"
    MsgAlert("Não é permitido abertura de ordem de produção nesta empresa. Favor entrar na filial 0103-Sorocaba ou 0106-Cajamar", "Abertura de Ordem de Produção")
    _cProd  := ""
else
    M->C2_LOCAL := Subs(cFilAnt,3,2)+"A1"
EndIf 

Return(_cProd)
