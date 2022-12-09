#INCLUDE "QIER270.CH"
#INCLUDE "PROTHEUS.CH"

User Function QIER270R()
Local aVetQEK, lImpFic,lEtiqRast

cProg       := 'QIEA200'
nMv_par11   := MV_PAR01
nMv_par12   := MV_PAR02

U_XQIER270 (cProg,nMv_par11, nMv_par12,aVetQEK,lImpFic,lEtiqRast)

Return
