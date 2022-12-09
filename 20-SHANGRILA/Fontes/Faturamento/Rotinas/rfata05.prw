#include "rwmake.ch"

User Function RFATA05()

Processa({|| AJUSTE()},"Ajuste Pis/Cofins das Notas Fiscais")
Return

Static Function AJUSTE()

           
cQuery := ""
cQuery += "UPDATE SFT010 SET FT_BASEPIS = FT_VALCONT , FT_ALIQPIS = 0.65 , FT_VALPIS = ROUND(0.0065 * FT_VALCONT,2), "
cQuery += "FT_ALIQCOF = 3.0 , FT_VALCOF = ROUND(0.03 * FT_VALCONT,2) , FT_BASECOF = FT_VALCONT "
cQuery += "WHERE FT_CSTCOF = '01' AND FT_ENTRADA >= '20111201' "

TcSqlExec(cQuery)

Return
