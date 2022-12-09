#Include "Protheus.ch"
#Include "TopConn.ch"

User Function TpOpCall()
Local cRet := ""
Local cSql := ""
Local cPed := SC6->C6_NUM
Local cItm := SC6->C6_ITEM
Local cOpr := SC6->C6_OPER



If Empty(cPed)
    cPed := M->C6_NUM
    cItm := M->C6_ITEM
    cOpr := M->C6_OPER
EndIf

If !Empty(cOpr)
    Return cOpr
EndIf

cSql := "SELECT UB_OPER FROM "+RetSqlName("SUB")+" SUB WHERE SUB.UB_NUMPV = '"+cPed+"' AND SUB.UB_ITEM = '"+cItm+"' AND SUB.D_E_L_E_T_=' ' " 

If Select("QRY") > 0
    QRY->(DbCloseArea())
EndIf

TcQuery cSql New Alias "QRY"

If !Empty(QRY->UB_OPER)
    cRet :=  QRY->UB_OPER
EndIf

If Select("QRY") > 0
    QRY->(DbCloseArea())
EndIf

Return cRet
