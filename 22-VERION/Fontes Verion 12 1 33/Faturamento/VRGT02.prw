#INCLUDE "rwmake.ch"

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VRGT02   บ Autor ณ Paulo Henrique     บ Data ณ  28/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gatilho para verfica็ใo de C6_TES vazio ou nใo (parte 2)   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico Verion                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/

User Function VRGT02()

Local _aArea  := {}
Local _cCdTs1 := "",_cCdTse := "",_cCdPrd := ""

_aArea  := GetArea()
_cCdTse := aCols[n][Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_TES"})] 
_cCdPrd := aCols[n][Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})] 

_cCdTs1 := If(Empty(_cCdTse),MaTesInt(2,,M->C5_CLIENTE,M->C5_LOJACLI,If(M->C5_TIPO$'DB',"F","C"),_cCdPrd,"C6_TES"),_cCdTse)

RestArea(_aArea)
Return(_cCdTs1)
//MaTesInt(2,,M->C5_CLIENTE,M->C5_LOJACLI,If(M->C5_TIPO$'DB',"F","C"),M->C6_PRODUTO,"C6_TES")
