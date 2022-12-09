#INCLUDE "rwmake.ch"

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VRGT01   บ Autor ณ Paulo Henrique     บ Data ณ  28/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gatilho para verfica็ใo de C6_TES vazio ou nใo             บฑฑ
ฑฑบ          ณ no caso de produtos com aliquota zero de IPI               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico Verion                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/

User Function VRGT01()

Local _aArea  := {}
Local _cCdOpr := "",_cCdTes := ""

_aArea  := GetArea()
_cCdTes := aCols[n][Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_TES"})]

If _cCdTes == "521"
   MsgInfo(OemToAnsi("Campo de Tipo de Saํda jแ preenchdo"),OemToAnsi("Aten็ใo"))
Else   
   _cCdOpr := M->C6_OPER
EndIf   

RestArea(_aArea)
Return(_cCdOpr)