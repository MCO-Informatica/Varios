#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function F200tit()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIASINI,_NORDEMINI,_NRECNOINI,")


_cAliasIni  := Alias()
_nOrdemIni  := INDEXORD()
_nRecnoIni  := RECNO()

ALERT("SE5")

ALERT(SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)

ALERT("SE1")

ALERT(SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)


DbSelectArea(_cAliasIni)
dbSetOrder(_nOrdemIni)
dbGoto(_nRecnoIni)

Return
