#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"

// Gatilho para retornar Número de Separação - C5_X_NUMSE

// ATENÇÃO: 
// **********************************************************************************
//    SUBSTITUIDO PELO PE MT410INC EM 02/10/2019 PARA EVITAR DUPLICIDADE DE NÚMEROS
// **********************************************************************************

User Function RFATG09()

    Local _cNumSep		:= ""
    Local _cQuery		:= ""
    Local _aArea		:= GetArea()
    Local _cNumero      := ""

// PARA SAIR DIRETO DA FUNÇÃO SEM EXECUTAR - 02/10/2019
RETURN()

    _cQuery += "SELECT DISTINCT C5_X_NUMSE FROM SC5010 WHERE C5_X_ARMAZ = '"+M->C5_X_ARMAZ+"' AND C5_X_NUMSE <> 'XXXXXXXXXX' ORDER BY C5_X_NUMSE DESC"
    _cQuery := ChangeQuery(_cQuery)

    dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"QRYNUM",.T.,.T.)
    _cNumSep := QRYNUM->C5_X_NUMSE
    dbCloseArea()

    If _cNumSep == "          "
        _cNumSep := M->C5_X_ARMAZ+"000000"
    Else

    EndIf

    _cNumero := SubStr(_cNumSep,5,6)

    _cNumSep := SubStr(_cNumSep,1,4)+Soma1(_cNumero)

    RestArea(_aArea)

Return(_cNumSep)