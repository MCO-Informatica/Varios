#INCLUDE "rwmake.ch"

/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘?
臼?Programa  ?GAT001    ? Autor ? AP6 IDE            ? Data ?  16/11/05   艮?
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒?
臼?Descricao ? Codigo gerado pelo AP6 IDE.                                艮?
臼?          ?                                                            艮?
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒?
臼?Uso       ? AP6 IDE                                                    艮?
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識?
*/

User Function Gat001()

Local _aArea  := GetArea()
Local _nPreco := 0

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial()+M->C7_PRODUTO)

If SB1->B1_ORIGEM == " " .OR. SB1->B1_ORIGEM == "0"
   If SB1->B1_UPRC == 0
      _nPreco := SB1->B1_VERCOM // CAMPO ESPECIFICO DO CLIENTE
   Else
      _nPreco := SB1->B1_UPRC   
   EndIf
Else
   If SB1->B1_VERCOM == 0  // CAMPO ESPECIFICO DO CLIENTE
      _nPreco := SB1->B1_UPRC
   Else
      _nPreco := SB1->B1_VERCOM  // CAMPO ESPECIFICO DO CLIENTE
   EndIf
EndIf

Eval(bgdRefresh)
RestArea(_aArea)
Return (_nPreco)
