#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 05/05/03

User Function SUSPIPIF()        // incluido pelo assistente de conversao do AP6 IDE em 05/05/03

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("SUSPIPI,TES,M->C6_TES,_CTES,")

/*/
�����������������������������������������������������������������������Ŀ
�Programa  � SUSPIPIF � Autor �    Priscilla Scoparo  � Data � 03/10/02 �
�����������������������������������������������������������������������Ĵ
�Descricao � Execblock chamado no gatilho C6_PRODUTO para checar se o   �
�          � cliente tem suspensao de IPI ou nao e troca a TES (FAT)    �
�����������������������������������������������������������������������Ĵ
�Uso       � Especifico para Piter Pan Indl. Com. Ltda                  �
�������������������������������������������������������������������������
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
