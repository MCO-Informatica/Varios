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

User Function GVRESTC6()

_aArea     := GetArea()

_cVrPrdSld := aCols[n][Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})]
_cVrPrdLcl := aCols[n][Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_LOCAL"})]
_nSldAtual := 0

//_cVrPrdSld := M->C6_PRODUTO
//_cVrPrdLcl := M->C6_LOCAL

DbSelectArea("SB2")
DbSetOrder(1)
If DbSeek(xFilial("SB2")+_cVrPrdSld+_cVrPrdLcl)
   _nSldAtual := (SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP))
Endif

RestArea(_aArea)
Return(_nSldAtual)
