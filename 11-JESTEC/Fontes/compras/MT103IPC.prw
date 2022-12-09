#INCLUDE "RWMAKE.CH"
/*
//importa dados do pedidos de compra
*/

User Function MT103IPC()

    Private aArea 	 := GetArea()

    _cMT103A := aScan(aHeader,{|x| AllTrim(x[2])=="D1_DESCRI" })	   // DESCRIÇÃO DO PRODUTO

    Acols[Paramixb[1],_cMT103A]:= SC7->C7_DESCRI

    RestArea(aArea)
Return