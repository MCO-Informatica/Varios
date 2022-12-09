#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Prcmin()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NPOS,CCODIG,NPRCV,CTIPO,_CREGIST,_CORDEM")
SetPrvt("LRETORNA,NPRCMIN,")


// Busca o codigo do produto
nPOS   := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_PRODUTO" })
cCODIG := ACOLS[N,NPOS]                           // Codigo do Produto

// Busca o preco digitado
nPOS   := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_PRCVEN" })
nPRCV  := ACOLS[N,NPOS]                           // Preco de venda

// Tipo do pedido de venda 
cTIPO := M->C5_PAPELET

_cREGIST := Recno()
*_cOrdem  := IndexOrder()
lRetorna := .t.

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek( xFilial("SB1") + cCODIG )

nPRCMIN := SB1->B1_PRCMIN

If nPRCMIN > nPRCV .and. cTIPO <> "O"
   lRetorna := .f.
   Else
       lRetorna := .t.
EndIf

DbSelectArea("SB1")
DbGoTo(_cREGIST)
*DbSetOrder(_cOrdem)

Return(lRetorna)


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

