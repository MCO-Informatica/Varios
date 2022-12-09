#include "Protheus.ch"

User Function m410stts()
Local aArea := GetArea()
Local nOper := PARAMIXB[1]

    // nOper => 3 - Inclusão; 4 - Alteração; 5 - Exclusão; 6 - Cópia; 7 - Devolução de Compras
    if nOper != 7
       u_rfata08(m->c5_num,nOper)
    endIf

    RestArea(aArea)
return Nil
