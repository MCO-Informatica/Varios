#INCLUDE "RWMAKE.CH"

User Function RETQTD(DINI,DFIM)

NRet := 0
ASD2 := GETAREA()


_NTT	:= 0
_NQTD	:= 0

cQry:="SELECT SUM(D2_TOTAL) NVALFAT "
cQry+="FROM "+RetSqlName("SD2")+" WHERE D_E_L_E_T_=' ' " 
cQry+="AND SUBSTR(D2_EMISSAO,1,6) >= '" + DtoS(DINI)  + "'  "
cQry+="AND SUBSTR(D2_EMISSAO,1,6) <= '" + DtoS(DFIM) + "'  "
cQry+="AND D2_TES IN('564','573')   "

DbUseArea( .t., "TOPCONN", TcGenQry(,,cQry), "Pega" )
TcSetField( "Pega", "NVALFAT", "N", 17, 2 )

NRet := Pega->NVALFAT

Pega->(DbCloseArea())


RESTAREA(ASD2)
Return nRet