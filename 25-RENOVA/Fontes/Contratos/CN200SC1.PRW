#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  CN200SC1   บAutor  ณPedro Augusto      บ Data ณ  12/08/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ P.E. para filtrar filial destino no browse do F4 do GCT     ฑฑ
ฑฑบDesc.     ณ (em "planilha"                                              ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Workflow RENOVA                                            บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function CN200SC1()
   //Local ExpC1 := 	" C1_FILDEST = '"+cFilAnt+"' .And. Empty(C1_XNUMANT) "
   //Local ExpC1 := "TRIM(C1_XNUMANT) IS NULL"  
     Local ExpC1:= "Empty(C1_XNUMANT) "
	
Return ExpC1
	