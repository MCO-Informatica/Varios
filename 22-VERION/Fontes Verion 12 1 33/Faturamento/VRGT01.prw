#INCLUDE "rwmake.ch"

/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘?
臼?Programa  ? VRGT01   ? Autor ? Paulo Henrique     ? Data ?  28/08/06   艮?
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒?
臼?Descricao ? Gatilho para verfica艫o de C6_TES vazio ou n?o             艮?
臼?          ? no caso de produtos com aliquota zero de IPI               艮?
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒?
臼?Uso       ? Espec?fico Verion                                          艮?
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識?
*/

User Function VRGT01()

Local _aArea  := {}
Local _cCdOpr := "",_cCdTes := ""

_aArea  := GetArea()
_cCdTes := aCols[n][Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_TES"})]

If _cCdTes == "521"
   MsgInfo(OemToAnsi("Campo de Tipo de Sa?da j? preenchdo"),OemToAnsi("Aten艫o"))
Else   
   _cCdOpr := M->C6_OPER
EndIf   

RestArea(_aArea)
Return(_cCdOpr)
