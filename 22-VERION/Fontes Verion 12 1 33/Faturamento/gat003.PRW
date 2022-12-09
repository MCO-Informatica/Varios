#INCLUDE "rwmake.ch"

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGAT003    บ Autor ณ AP6 IDE            บ Data ณ  21/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
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
