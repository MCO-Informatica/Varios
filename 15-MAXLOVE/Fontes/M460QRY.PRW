#include "protheus.ch"

User Function M460QRY()

Local cQuery   := paramixb[1]
Local cPedEcom := Replicate("Z",55)
/*
If Alltrim(FunName()) $"MATA460A"
    If !Empty(MV_PAR19) .and. ALLTRIM(SX1->X1_GRUPO)$"MT461A"
        cQuery += " AND SUBSTRING(SC9.C9_PEDECOM,1,3) = '"+MV_PAR19+"' "    
    Else
        cQuery += " AND SC9.C9_PEDECOM BETWEEN '' AND '"+cPedEcom+"' "    
    EndIf
EndIF
*/
Return(cQuery)
