#include "rwmake.ch"        

//Pos 136 a 138 - Carteira //
User Function BRADCAR()      

SetPrvt("_RETCAR,")

// PROGRAMA PARA SELECIONAR A CARTEIRA NO CODIGO DE BARRAS QUANDO //
// NAO TIVER TEM QUE SER COLOCADO "00"  //

IF SUBSTR(SE2->E2_CODBAR,1,3) != "237"
   _Retcar := "000"
Else
//   _Retcar := "0" + SUBSTR(SE2->E2_CODBAR,09,1)+SUBSTR(SE2->E2_CODBAR,11,1)
    _Retcar := "0" + SUBSTR(SE2->E2_CODBAR,24,2)
EndIf

Return(_Retcar)
