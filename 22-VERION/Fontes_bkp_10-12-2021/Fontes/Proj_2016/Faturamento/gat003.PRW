#INCLUDE "rwmake.ch"

/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘?
臼?Programa  ?GAT003    ? Autor ? AP6 IDE            ? Data ?  21/12/05   艮?
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒?
臼?Descricao ? Codigo gerado pelo AP6 IDE.                                艮?
臼?          ?                                                            艮?
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒?
臼?Uso       ? AP6 IDE                                                    艮?
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識?
*/

User Function Gat003()

Local _aArea  := GetArea()
Local _nPreco := 0

If SB1->B1_IMPIMPO > 0
   _nPreco := M->D1_VUNIT + (M->D1_VUNIT * SB1->B1_IMPIMPO)
Else
   _nPreco := M->D1_VUNIT   
EndIf   

RestArea(_aArea)

Return (_nPreco)