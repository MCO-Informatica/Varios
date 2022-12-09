#include "rwmake.ch"

User Function RCOMG01()

Local _cArmaz   :=  M->D1_LOCAL

dbSelectArea("SB2")
dbSetOrder(1)
If !dbSeek(xFilial("SB2")+M->D1_COD+M->D1_LOCAL,.f.)
    CriaSB2(M->D1_COD,M->D1_LOCAL)
EndIf

Return(_cArmaz)
