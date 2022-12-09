#INCLUDE "rwmake.ch"
/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGVRESTOQ  บ Autor ณ RICARDO CAVALINI   บ Data ณ  11/01/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
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
