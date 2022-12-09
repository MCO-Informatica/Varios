
#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"

// 02/10/2019 - LMS
// PE para gravar o Número de Separação - C5_X_NUMSE
// Em substituição ao RFATG09

User Function MT410INC()

    Local _cNumSep		:= ""
    Local _cQuery		:= ""
    Local _aArea		:= GetArea()
    Local _cNumero      := ""

    _cQuery += "SELECT DISTINCT C5_X_NUMSE FROM SC5010 WHERE C5_X_ARMAZ = '"+M->C5_X_ARMAZ+"' AND C5_X_NUMSE <> 'XXXXXXXXXX' ORDER BY C5_X_NUMSE DESC"
    _cQuery := ChangeQuery(_cQuery)

    dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"QRYNUM",.T.,.T.)
    _cNumSep := QRYNUM->C5_X_NUMSE
    dbCloseArea()

    If _cNumSep == "          "
        _cNumSep := M->C5_X_ARMAZ+"000000"
    EndIf

    _cNumero := SubStr(_cNumSep,5,6)

    _cNumSep := SubStr(_cNumSep,1,4)+Soma1(_cNumero)

    RestArea(_aArea)

    Reclock("SC5",.F.)
    C5_X_NUMSE := _cNumSep
    MSUnlock()

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
