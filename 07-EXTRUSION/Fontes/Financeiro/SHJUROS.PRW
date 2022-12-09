#include "PROTHEUS.CH"

User Function SHJUROS()

Local _cRet

_cRet:= StrZero((SE1->E1_SALDO-SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA))*0.16667,13)

Return(_cRet)


