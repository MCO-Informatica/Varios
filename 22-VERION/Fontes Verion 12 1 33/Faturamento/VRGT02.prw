#INCLUDE "rwmake.ch"

/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘?
臼?Programa  ? VRGT02   ? Autor ? Paulo Henrique     ? Data ?  28/08/06   艮?
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒?
臼?Descricao ? Gatilho para verfica艫o de C6_TES vazio ou n?o (parte 2)   艮?
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒?
臼?Uso       ? Espec?fico Verion                                          艮?
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識?
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
