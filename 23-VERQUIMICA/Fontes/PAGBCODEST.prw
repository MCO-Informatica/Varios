#include "rwmake.ch"        
User Function PAGBCODEST()        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_RETBCO,")

////  PROGRAMA PARA SELECIONAR O BANCO DO NUMERO CNAB QUANDO NAO
////  NAO TIVER TEM QUE SER COLOCADO "000"


IF SEA->EA_MODELO = "06"   
   _RETBCO := "000"
Else
   _RETBCO := LEFT(SA2->A2_BANCO,3)
EndIf


Return(_RETBCO)        
