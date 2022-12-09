#include "protheus.ch"

User Function GravaXX()

Local cDoctran := ""
Local cQry := ""

cQry += " Select E5_NUMSEQ from SE5010 "
cQry += " WHERE D_E_L_E_T_ = '' "
cQry += " AND E5_NUMSEQ >= '"+cDoctran+"'

dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),"TRB", .F., .T.)

While TRB->( !Eof() ) 

cDoctran := Soma1(cDoctran)

End

Return

