#include "rwmake.ch"       

User Function PAGTIPO()        

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_PAGTIPO,")

////  PROGRAMA PARA SELECIONAR O TIPO DO TITULO PARA CNAB QUANDO 
////  TIPO "PA" RETORNA "REC" 


IF SE2->E2_TIPO = "PA"   
   _PAGTIPO := "REC"
Else
   _PAGTIPO := SE2->E2_TIPO
EndIf


Return(_PAGTIPO)   
  