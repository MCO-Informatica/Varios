#include "rwmake.ch"

User Function CNPJCPF()

    Local _cCNPJCPF := Padl(AllTrim(SA2->A2_CGC),15,"0")
//If SA2->A2_TIPO # "J"
    If Len(AllTrim(SA2->A2_CGC)) == 11
        _cCNPJCPF := Left(SA2->A2_CGC,9)+"0000"+SubStr(SA2->A2_CGC,10,2)
    EndIf

Return(_cCNPJCPF)