#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Lote()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AAREA,_CNUMLOT,")

*** LOTE.PRW
*** AJUSTA A LEITURA DO CODIGO DE BARRAS DE ACORDO COM O CAMPO DE LOTE NO SIGA.

_aArea   := GetArea()
_cNumLot := Space(0)

_cNumLot := Substr(M->C6_LOTECTL,3,12)

RestArea(_aArea)

__RetProc(_cNumLot)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

