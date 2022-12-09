#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Vend()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CVEND1,CVEND2,CVEND3,CVEND4,CVEND5,NPOS")
SetPrvt("ACOLS,")

cVend1 := M->C5_VEND1
cVend2 := M->C5_VEND2
cVend3 := M->C5_VEND3
cVend4 := M->C5_VEND4
cVend5 := M->C5_VEND5

Return()

nPOS          := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_VEND1" })
ACOLS[N,NPOS] := cVend1                          // vendedor 1

nPOS          := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_VEND2" })
ACOLS[N,NPOS] := cVend2                          // vendedor 2

nPOS          := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_VEND3" })
ACOLS[N,NPOS] := cVend3                          // vendedor 3

nPOS          := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_VEND4" })
ACOLS[N,NPOS] := cVend4                          // vendedor 4

nPOS          := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_VEND5" })
ACOLS[N,NPOS] := cVend5                          // vendedor 5

//Return(cVend1)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(cVend1)
Return(cVend1)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

