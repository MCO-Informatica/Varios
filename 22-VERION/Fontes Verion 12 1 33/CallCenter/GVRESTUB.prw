#INCLUDE "rwmake.ch"
/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘?
臼?Programa  ?GVRESTOQ  ? Autor ? RICARDO CAVALINI   ? Data ?  11/01/06   艮?
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒?
臼?Descricao ? Codigo gerado pelo AP6 IDE.                                艮?
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒?
臼?Uso       ? AP6 IDE                                                    艮?
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識?
*/

User Function GVRESTUB()
_aArea     := GetArea()
_cVrPrdSld := M->UB_PRODUTO
_nSldAtual := 0

// SALDO DE ESTOQUE
DbSelectArea("SB2")
DbSetOrder(1)
If DbSeek(Xfilial("SB2")+_cVrPrdSld+"01")
   _nSldAtual := (SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP))
Endif

RestArea(_aArea)
Return(_nSldAtual)
