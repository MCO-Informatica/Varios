#INCLUDE "rwmake.ch"
/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘?
臼?Programa  ?GAT002    ? Autor ? AP6 IDE            ? Data ?  07/12/05   艮?
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒?
臼?Descricao ? Codigo gerado pelo AP6 IDE.                                艮?
臼?          ?                                                            艮?
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒?
臼?Uso       ? AP6 IDE                                                    艮?
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識?
*/
User Function Gat002()

Local _aArea := GetArea()
Local _nVend := ""

IF funname() $ "CNTA120"                    
   RETURN(_nVend)
ENDIF

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial()+SA1->A1_VEND)
                                           
_nVend := SA3->A3_NOME

RestArea(_aArea)
Return (_nVend)
