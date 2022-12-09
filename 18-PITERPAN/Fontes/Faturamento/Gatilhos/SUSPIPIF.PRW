#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 05/05/03

User Function SUSPIPIF()        // incluido pelo assistente de conversao do AP6 IDE em 05/05/03

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("SUSPIPI,TES,M->C6_TES,_CTES,")

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa  ³ SUSPIPIF ³ Autor ³    Priscilla Scoparo  ³ Data ³ 03/10/02 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descricao ³ Execblock chamado no gatilho C6_PRODUTO para checar se o   ³
³          ³ cliente tem suspensao de IPI ou nao e troca a TES (FAT)    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³ Especifico para Piter Pan Indl. Com. Ltda                  ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

// SUSPIPI:=""
// TES    :=""

dbSelectArea("SA1")
dbSetOrder(1)
// dbSeek(xFilial()+AllTrim(M->C5_CLIENTE)+ALLTRIM(M->C5_LOJACLI))
IF FOUND()
   SUSPIPI:= SA1->A1_SUSPIPI
endif

dbselectArea("SB1")
dbsetOrder(1)
dbSeek(xFilial()+Alltrim(M->C6_PRODUTO))
IF FOUND()
   TES:= SB1->B1_TS
ENDIF

// dbSelectarea("SC6")
IF SUSPIPI=="S"
   // M->C6_TES:="503"
   _cTES:="503"
ELSE
   // M->C6_TES:= TES
   _cTES:=TES
ENDIF


// Substituido pelo assistente de conversao do AP6 IDE em 05/05/03 ==> __Return(_cTes)
Return(_cTes)        // incluido pelo assistente de conversao do AP6 IDE em 05/05/03

