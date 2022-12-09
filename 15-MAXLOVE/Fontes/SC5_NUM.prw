#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"


User Function SC5_NUM()

Local _cNumPed:= ""

If cFilAnt$"0101"
	_cQuery := "SELECT MAX('1'+SUBSTRING(C5_NUM,2,5)) C5_NUM FROM SC5010 WHERE D_E_L_E_T_ = '' "	
ElseIf cFilAnt$"0102"
	_cQuery := "SELECT MAX('2'+SUBSTRING(C5_NUM,2,5)) C5_NUM FROM SC5010 WHERE D_E_L_E_T_ = '' "	
ElseIf cFilAnt$"0103"
	_cQuery := "SELECT MAX('3'+SUBSTRING(C5_NUM,2,5)) C5_NUM FROM SC5010 WHERE D_E_L_E_T_ = '' "	
ElseIf cFilAnt$"0104"
	_cQuery := "SELECT MAX('4'+SUBSTRING(C5_NUM,2,5)) C5_NUM FROM SC5010 WHERE D_E_L_E_T_ = '' "	
EndIf

_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRY",.T.,.T.)
QRY->(dbGoTop())

_cNumPed := QRY->C5_NUM                                         
_cNumPed := Soma1(_cNumPed)

dbCloseArea("QRY")


Return(_cNumPed)