#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 05/05/03

User Function SUSPIPIF()        // incluido pelo assistente de conversao do AP6 IDE em 05/05/03

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("SUSPIPI,TES,M->C6_TES,_CTES,")

/*/
旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴?
쿛rograma  ? SUSPIPIF ? Autor ?    Priscilla Scoparo  ? Data ? 03/10/02 ?
쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴?
쿏escricao ? Execblock chamado no gatilho C6_PRODUTO para checar se o   ?
?          ? cliente tem suspensao de IPI ou nao e troca a TES (FAT)    ?
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
쿢so       ? Especifico para Piter Pan Indl. Com. Ltda                  ?
읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
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

