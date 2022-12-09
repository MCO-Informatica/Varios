#include "rwmake.ch"       

User Function PAGCCDEST()        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_RETCC,")

////  PROGRAMA PARA SELECIONAR A CONTA DO NUMERO CNAB QUANDO NAO
////  NAO TIVER TEM QUE SER COLOCADO "0000000000"


IF SEA->EA_MODELO = "06"   
   _RETCC := "0000000000"
Else
   _RETCC := STRZERO(VAL(SA2->A2_NUMCON),10)
EndIf


Return(_RETCC)   
  