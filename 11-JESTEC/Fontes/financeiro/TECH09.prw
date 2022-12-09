#include "protdef.ch"
#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TECH09      ³ Autor ³ GINES              ³ Data ³ 14/06/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNAB SISPAG - Banco do Brasil                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TECH09()

    Local _cRet:=""

//Programa para identificar qual tipo de DOC está sendo processado

/*
'02' = Pagamento de Aluguel/Condomínio
'10' = Transferência Internacional em Real
*/

    If SEA->EA_MODELO=="03"
        If SEA->EA_TIPOPAG=="20"
            _cRet:="07"
        Elseif SEA->EA_TIPOPAG=="30"
            _cRet:="06"
        Elseif SEA->EA_TIPOPAG=="32"
            _cRet:="18"
        Elseif SEA->EA_TIPOPAG=="34"
            _cRet:="19"
        Elseif SEA->EA_TIPOPAG=="33"
            _cRet:="16"
        Elseif SEA->EA_TIPOPAG=="98"
            _cRet:="13"
        Elseif SEA->EA_TIPOPAG=="10"
            _cRet:="04"
        Elseif SEA->EA_TIPOPAG=="22"
            _cRet:="09"
        Elseif SEA->EA_TIPOPAG=="03"
            _cRet:="03"
        Elseif SEA->EA_TIPOPAG=="05"
            _cRet:="05"
        Elseif SEA->EA_TIPOPAG=="40"
            _cRet:="08"
        Elseif SEA->EA_TIPOPAG=="80"
            _cRet:="17"

        Endif
    ElseIf SEA->EA_MODELO=="01"
        _cRet:="01"
    ElseIf SEA->EA_MODELO=="05"
        _cRet:="11"
    ElseIf SEA->EA_MODELO$"71/72"
        _cRet:="12"
    Else
        _cRet:=""
    Endif

Return(_cRet)