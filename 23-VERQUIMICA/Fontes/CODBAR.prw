#include "rwmake.ch"       

User Function CODBAR()        

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CODBAR,")

////  PROGRAMA PARA MONTAR O CODIDO DE BARRAS DO CNAB SAFRA

IF SEA->EA_MODELO = "06"
   _CODBAR:= SE2->(SUBSTR(E2_CODBAR,1,4)+SUBSTR(E2_CODBAR,33,15)+SUBSTR(E2_CODBAR,5,5)+SUBSTR(E2_CODBAR,11,10)+SUBSTR(E2_CODBAR,22,10))
Else
   _CODBAR:= SPACE(44)
EndIf

Return(_CODBAR) 
