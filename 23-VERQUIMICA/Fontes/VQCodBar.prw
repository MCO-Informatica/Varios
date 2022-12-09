User Function VQCodBar()
Local cRet

If SEA->EA_MODELO == "13" .AND. SE2->E2_XGPS01 == "99"

cRet := SUBSTR(SE2->E2_LINDIG,1,11) + SUBSTR(SE2->E2_LINDIG,13,11) + SUBSTR(SE2->E2_LINDIG,25,11) + SUBSTR(SE2->E2_LINDIG,37,11) + SPACE(4)
              
ElseIf(Empty(SE2->E2_LINDIG))

cRet := SE2->E2_LINDIG

Else

cRet := SE2->E2_LINDIG

EndIf

Return(cRet)