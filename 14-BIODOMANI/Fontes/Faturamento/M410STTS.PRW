#include "Protheus.ch"

User Function m410stts()
Local aArea := GetArea()
Local nOper := PARAMIXB[1]

    // nOper => 3 - Inclus?o; 4 - Altera??o; 5 - Exclus?o; 6 - C?pia; 7 - Devolu??o de Compras
    if nOper != 7
       u_rfata08(m->c5_num,nOper)
    endIf

    RestArea(aArea)
return Nil
