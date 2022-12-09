#include "PROTHEUS.CH"

user function SHCONTA()

Local _cConta := ""

If SEE->EE_CODIGO$"341"
    _cConta := SubStr(SEE->EE_AGENCIA,1,4)+"00"+SubStr(SEE->EE_CONTA,1,5)+SEE->EE_DVCTA
ElseIf SEE->EE_CODIGO$"237"
    _cConta := "00090"+SubStr(SEE->EE_AGENCIA,1,4)+"00"+SubStr(SEE->EE_CONTA,1,5)+SEE->EE_DVCTA
EndIf

Return(_cConta)
